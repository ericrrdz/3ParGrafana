#!/bin/bash
# ---------------------------------------------------------
# 3PAR SR (SQLite) INFLUX LOADER (Optimized)
# ---------------------------------------------------------
# Usage: ./3pg_sr.sh [-n | -a] <path_to_sqlite_db_OR_directory>
#   -n : New Database (Create DB & Datasource, then process)
#   -a : Aggregate (Append to existing DB)
# ---------------------------------------------------------

# ---------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------
INFLUX_HOST="c3-dl360pg8-300"
INFLUX_PORT="8086"
INFLUX_URL="http://${INFLUX_HOST}:${INFLUX_PORT}"

GRAFANA_INFLUX_URL="http://c3-dl360pg8-300.cxo.storage.hpecorp.net:8086"
GRAFANA_HOST="http://c3-dl360pg8-300.cxo.storage.hpecorp.net:3000"
GRAFANA_TOKEN="glsa_ghRR5ijBXGdiPlz5dNkhDRz5yXi3BJ7r_512b85e5"
MAX_PARALLEL=17  # max concurrent .db file jobs

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
# HELPER: Tag Definitions
# ---------------------------------------------------------
get_tags_for_table() {
  case $1 in
    cpgspace)  echo "CPG_NAME,DOM_NAME,CPGID,DISK_TYPE" ;;
    statcache) echo "node" ;;
    statcmp)   echo "node" ;;
    statcpu)   echo "NODE,CPU" ;;
    statpd)    echo "PDID,DISK_TYPE,SPEED" ;;
    statport)  echo "" ;;
    statqos)   echo "DOM_NAME,QOS_ID" ;;
    statrcopy) echo "TARGET_NAME,LINK_NAME" ;;
    statrcvv)  echo "VV_NAME" ;;
    statvlun)  echo "VV_NAME,LUN,HOST_NAME,HOST_WWN" ;;
    statvv)    echo "VV_NAME,VVID,DOM_NAME,WWN,SNP_CPG_NAME,USR_CPG_NAME,PROV_TYPE,VV_TYPE,VVSET_NAME,VVSET_ID,CPGID" ;;
    sysspace)  echo "DOM_NAME,DISK_TYPE" ;;
    vvspace)   echo "VV_NAME,DOM_NAME,VVID,BSID,WWN,CPG_NAME,PROV_TYPE,VV_TYPE,VM_NAME,VM_ID,VM_HOST,VVOLSC,COMPR,VVSET_NAME,VVSET_ID,CPGID" ;;
    *)         echo "" ;;
  esac
}

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

  > "$output_file"

  local tables
  tables=$(sqlite3 "$db_file" "SELECT name FROM sqlite_master WHERE type='table';")

  for table in $tables; do
    local tag_cols
    tag_cols=$(get_tags_for_table "$table")

    sqlite3 -header -csv "$db_file" "SELECT * FROM $table;" | \
    awk -F, -v measurement="$table" -v tags="$tag_cols" '
    BEGIN {
      split(tags, t_array, ",");
      for (i in t_array) is_tag[t_array[i]] = 1;
      idx_pn = 0; idx_ps = 0; idx_pp = 0;
      idx_pt = 0; idx_gb = 0; idx_tt = 0;
      whitelist_str = "begin_msec,now_msec,rerror,rdrops,rticks,werror,wdrops,wticks,GBITPS"
      split(whitelist_str, wl_array, ",");
      for (i in wl_array) keep_zeros[wl_array[i]] = 1;
    }
    NR==1 {
      for (i=1; i<=NF; i++) {
        gsub(/^"|"$/, "", $i);
        col_name[i] = $i;
        if (tolower($i) == "tsecs") time_col = i;
        if ($i == "PORT_N")    idx_pn = i;
        if ($i == "PORT_S")    idx_ps = i;
        if ($i == "PORT_P")    idx_pp = i;
        if ($i == "PORT_TYPE") idx_pt = i;
        if ($i == "TRANS_TYPE") idx_tt = i;
        if ($i == "GBITPS")    idx_gb = i;
      }
      next;
    }
    {
      for (i=1; i<=NF; i++) gsub(/^"|"$/, "", $i);

      tag_string = ""
      for (i=1; i<=NF; i++) {
        if (col_name[i] in is_tag) {
          val = $i
          gsub(/ /, "\\ ", val);
          gsub(/,/, "\\,", val);
          tag_string = tag_string "," col_name[i] "=" val
        }
      }
      if (idx_pn > 0 && idx_ps > 0 && idx_pp > 0)
        tag_string = tag_string ",DATA_PORT=" $idx_pn ":" $idx_ps ":" $idx_pp
      if (idx_pt > 0) { val = $idx_pt; gsub(/ /, "\\ ", val); tag_string = tag_string ",PORT_TYPE=" val }
      if (idx_tt > 0) { val = $idx_tt; gsub(/ /, "\\ ", val); tag_string = tag_string ",TRANS_TYPE=" val }
      if (idx_gb > 0) { tag_string = tag_string ",GBITPS=" $idx_gb }

      timestamp = (time_col) ? $time_col : "";

      for (i=1; i<=NF; i++) {
        header = col_name[i];
        value = $i;
        if (i == time_col || header in is_tag) continue;
        if (i == idx_pn || i == idx_ps || i == idx_pp) continue;
        if (i == idx_pt || i == idx_gb || i == idx_tt) continue;
        if (value == "" || value == "-") continue;
        if ((value == "0" || value == "0.0") && !(header in keep_zeros)) continue;

        key = timestamp SUBSEP tag_string SUBSEP header
        if (value ~ /^[+-]?[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?$/) {
          agg_val[key] += value
          agg_type[key] = "value"
        } else {
          gsub(/"/, "\\\"", value);
          agg_val[key] = "\"" value "\""
          agg_type[key] = "value_str"
        }
      }
    }
    END {
      for (key in agg_val) {
        split(key, parts, SUBSEP)
        ts  = parts[1]
        tgs = parts[2]
        fld = parts[3]
        val = agg_val[key]
        f_key = agg_type[key]
        if (ts != "")
          printf "%s%s,type=%s %s=%s %s\n", measurement, tgs, fld, f_key, val, ts
        else
          printf "%s%s,type=%s %s=%s\n", measurement, tgs, fld, f_key, val
      }
    }' >> "$output_file"
  done

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
