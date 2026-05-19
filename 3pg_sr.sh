#!/bin/bash
# ---------------------------------------------------------
# 3PAR SR (SQLite) INFLUX LOADER
# ---------------------------------------------------------
# Usage: ./3pg_sr.sh [-n | -a] <path_to_sqlite_db_OR_directory>
#   -n : New Database (Create DB & Datasource, then process)
#   -a : Aggregate (Append to existing DB)
#
# Requires the `sqlite_to_lp` helper binary on PATH (or set
# SQLITE_TO_LP below to its absolute path). The helper replaces
# the old sqlite3 | awk transformation pipeline and is ~7-10x
# faster with a fraction of the memory.
# ---------------------------------------------------------

# ---------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------
INFLUX_HOST="localhost"
INFLUX_PORT="8086"
INFLUX_URL="http://${INFLUX_HOST}:${INFLUX_PORT}"

GRAFANA_INFLUX_URL="http://localhost:8086"
GRAFANA_HOST="http://localhost:3000"
GRAFANA_TOKEN="<insert grafana token>"
MAX_PARALLEL=17  # max concurrent .db file jobs

# Path to the Go helper. Override here or via env if not on PATH.
SQLITE_TO_LP="${SQLITE_TO_LP:-sqlite_to_lp}"

# Verify the helper is available before doing anything else.
if ! command -v "$SQLITE_TO_LP" >/dev/null 2>&1; then
  echo "Error: '$SQLITE_TO_LP' not found on PATH." >&2
  echo "Install the helper or set SQLITE_TO_LP to its absolute path." >&2
  exit 1
fi

# Setup temp directory and guarantee cleanup on any exit
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# ---------------------------------------------------------
# ARGUMENT PARSING
# ---------------------------------------------------------
MODE=""
while getopts "na" opt; do
  case $opt in
    n) MODE="new" ;;
    a) MODE="append" ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        echo "Usage: $0 [-n (new) | -a (append)] <path>" >&2
        exit 1 ;;
  esac
done
shift $((OPTIND-1))

INPUT_PATH="$1"

if [[ -z "$MODE" ]]; then
  echo "Error: You must specify a mode." >&2
  echo "  -n : Create a new database" >&2
  echo "  -a : Aggregate to an existing database" >&2
  exit 1
fi

if [[ -z "$INPUT_PATH" ]]; then
  echo "Error: No file or directory provided." >&2
  echo "Usage: $0 [-n | -a] <path>" >&2
  exit 1
fi

if [[ ! -e "$INPUT_PATH" ]]; then
  echo "Error: Path '$INPUT_PATH' not found!" >&2
  exit 1
fi

# ---------------------------------------------------------
# USER PROMPT & DB SETUP
# ---------------------------------------------------------
read -p 'Enter Short Customer Nickname (no spaces): ' customer
dbname="${USER}_${customer}"
echo "Target Database: $dbname"

if [[ "$MODE" == "new" ]]; then
  echo "Mode: NEW — creating database and Grafana datasource..."
  influx -host "$INFLUX_HOST" -execute "CREATE DATABASE $dbname"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create database. Is InfluxDB running?" >&2
    exit 1
  fi

  # Create Grafana datasource immediately so data is visible as it loads
  echo "Creating Grafana Datasource..."
  GF_RESPONSE=$(curl --noproxy '*' --insecure --silent --write-out "HTTPSTATUS:%{http_code}" \
    -X POST \
    -H "Authorization: Bearer $GRAFANA_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "'"$dbname"'",
      "type": "influxdb",
      "url": "'"$GRAFANA_INFLUX_URL"'",
      "database": "'"$dbname"'",
      "access": "proxy"
    }' \
    "$GRAFANA_HOST/api/datasources")
  GF_STATUS=$(echo "$GF_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
  if [[ "$GF_STATUS" -eq 200 ]]; then
    echo "  Grafana datasource '$dbname' created. Data will appear as files are processed."
  elif [[ "$GF_STATUS" -eq 409 ]]; then
    echo "  Info: Grafana datasource '$dbname' already exists."
  else
    echo "  Warning: Failed to create Grafana datasource (HTTP $GF_STATUS)" >&2
  fi
else
  echo "Mode: AGGREGATE — appending to existing database '$dbname'..."
fi

# ---------------------------------------------------------
# CORE FUNCTION: Process Single File
# Each file gets its own chunk dir under WORK_DIR to avoid
# collisions when files are processed in parallel.
# ---------------------------------------------------------
process_sqlite_file() {
  local db_file="$1"
  local safe_name
  safe_name=$(basename "$db_file" | tr ' /' '__')
  local chunk_dir="$WORK_DIR/chunks_${safe_name}"
  mkdir -p "$chunk_dir"
  local output_file="$chunk_dir/payload.lp"

  echo "------------------------------------------------"
  echo "Processing: $db_file"

  # Transform sqlite -> InfluxDB line protocol in one go.
  if ! "$SQLITE_TO_LP" "$db_file" "$output_file"; then
    echo "  Error: sqlite_to_lp failed for $db_file" >&2
    return 1
  fi

  if [[ ! -s "$output_file" ]]; then
    echo "  Warning: No data extracted from $db_file"
    return 0
  fi

  # Split into 500k-line chunks and upload each
  echo "  Uploading payload..."
  split -l 500000 "$output_file" "$chunk_dir/chunk_"

  local any_error=0
  for chunk in "$chunk_dir"/chunk_*; do
    [[ -e "$chunk" ]] || continue
    HTTP_CODE=$(curl --noproxy '*' -s -o /dev/null -w "%{http_code}" \
      -XPOST "$INFLUX_URL/write?db=${dbname}&precision=s" \
      --data-binary @"$chunk")
    if [[ "$HTTP_CODE" == "204" ]]; then
      echo "  Chunk $(basename "$chunk"): OK"
    else
      echo "  Warning: InfluxDB write returned HTTP $HTTP_CODE for $(basename "$chunk")" >&2
      if [[ "$HTTP_CODE" == "400" ]]; then
        echo "  --- First 3 lines of bad chunk ---" >&2
        head -3 "$chunk" >&2
        echo "  ---" >&2
      fi
      any_error=1
    fi
    rm "$chunk"
  done

  return $any_error
}

# ---------------------------------------------------------
# EXECUTION
# ---------------------------------------------------------
ANY_UPLOAD_SUCCESS=false

if [[ -d "$INPUT_PATH" ]]; then
  echo "Target is a directory. Processing all .db files in '$INPUT_PATH'..."
  shopt -s nullglob
  db_files=("$INPUT_PATH"/*.db)
  shopt -u nullglob

  if [[ ${#db_files[@]} -eq 0 ]]; then
    echo "No .db files found in '$INPUT_PATH'." >&2
    exit 1
  fi

  # Process all .db files in parallel, capped at MAX_PARALLEL concurrent jobs
  pids=()
  for f in "${db_files[@]}"; do
    while [[ $(jobs -rp | wc -l) -ge $MAX_PARALLEL ]]; do sleep 0.2; done
    process_sqlite_file "$f" &
    pids+=($!)
  done

  # Collect results
  for pid in "${pids[@]}"; do
    if wait "$pid"; then ANY_UPLOAD_SUCCESS=true; fi
  done
else
  process_sqlite_file "$INPUT_PATH"
  if [[ $? -eq 0 ]]; then ANY_UPLOAD_SUCCESS=true; fi
fi

# ---------------------------------------------------------
# For -a mode: create/verify Grafana datasource at end
# (For -n mode it was already created upfront)
# ---------------------------------------------------------
if [[ "$MODE" == "append" && "$ANY_UPLOAD_SUCCESS" == true ]]; then
  echo "------------------------------------------------"
  echo "Verifying Grafana Datasource..."
  GF_RESPONSE=$(curl --noproxy '*' --insecure --silent --write-out "HTTPSTATUS:%{http_code}" \
    -X POST \
    -H "Authorization: Bearer $GRAFANA_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "'"$dbname"'",
      "type": "influxdb",
      "url": "'"$GRAFANA_INFLUX_URL"'",
      "database": "'"$dbname"'",
      "access": "proxy"
    }' \
    "$GRAFANA_HOST/api/datasources")
  GF_STATUS=$(echo "$GF_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
  if [[ "$GF_STATUS" -eq 200 ]]; then
    echo "  Grafana datasource '$dbname' created."
  elif [[ "$GF_STATUS" -eq 409 ]]; then
    echo "  Info: Grafana datasource '$dbname' already exists."
  else
    echo "  Warning: Failed to verify Grafana datasource (HTTP $GF_STATUS)" >&2
  fi
fi

echo "------------------------------------------------"
echo "All tasks finished."
