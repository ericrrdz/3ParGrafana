#!/bin/bash
# This command only parses host port throughput data
# ---------------------------------------------------------
# Usage: ./3pg_thru.sh [-n | -a] <path_to_sqlite_db_OR_directory>
#   -n : New Database (Create DB once, then process all files)
#   -a : Aggregate (Append to existing DB)
# ---------------------------------------------------------

# 1. Parse Command Line Arguments
MODE=""

while getopts "na" opt; do
  case $opt in
    n)
      MODE="new"
      ;;
    a)
      MODE="append"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 [-n (new) | -a (append)] <path>"
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

# 2. Validation
if [ -z "$MODE" ]; then
    echo "Error: You must specify a mode."
    echo "  -n : Create a new database"
    echo "  -a : Aggregate to an existing database"
    exit 1
fi

INPUT_PATH="$1"

if [ -z "$INPUT_PATH" ]; then
    echo "Error: No file or directory provided."
    echo "Usage: $0 [-n | -a] <path>"
    exit 1
fi

if [ ! -e "$INPUT_PATH" ]; then
    echo "Error: Path '$INPUT_PATH' not found!"
    exit 1
fi

# ---------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------
INFLUX_HOST="<INFLUXDB HOSTNAME>"
INFLUX_PORT="8086"
INFLUX_URL="http://${INFLUX_HOST}:${INFLUX_PORT}"
OUTPUT_FILE="influx_payload.lp"

# GRAFANA Config
GRAFANA_INFLUX_URL="<INFLUXDB HOSTNAME>:8086"
GRAFANA_HOST="<GRAFANA HOSTNAME>:3000"
GRAFANA_TOKEN="<GRAFANA TOKEN>"

# ---------------------------------------------------------
# User Prompt & DB Setup
# ---------------------------------------------------------
read -p 'Enter Short Customer Nickname (no spaces): ' customer

# Construct DB name
dbname="${USER}_${customer}"
echo "Target Database: $dbname"

if [ "$MODE" == "new" ]; then
    echo "Mode: NEW (Creating database...)"
    influx -host "$INFLUX_HOST" -execute "CREATE DATABASE $dbname"
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create database. Is InfluxDB running?"
        exit 1
    fi
else
    echo "Mode: AGGREGATE (Appending to existing database...)"
fi

# ---------------------------------------------------------
# Create Grafana Data Source
# ---------------------------------------------------------
if [ "$ANY_UPLOAD_SUCCESS" = true ]; then
    echo "------------------------------------------------"
    echo "Creating Grafana Data Source..."

    if [ -n "$GRAFANA_HOST" ] && [ -n "$GRAFANA_TOKEN" ]; then
        GF_RESPONSE=$(curl --noproxy '*' --insecure --silent --write-out "HTTPSTATUS:%{http_code}" \
            -X POST \
            -H "Authorization: Bearer $GRAFANA_TOKEN" \
            -H "Content-Type: application/json" \
            -d '{
                "name": "'$dbname'",
                "type": "influxdb",
                "url": "'$GRAFANA_INFLUX_URL'",
                "database": "'$dbname'",
                "access": "proxy"
            }' \
            "$GRAFANA_HOST/api/datasources")

        GF_STATUS=$(echo $GF_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

        if [ "$GF_STATUS" -eq 200 ]; then
            echo "Success: Grafana Data Source '$dbname' created."
        elif [ "$GF_STATUS" -eq 409 ]; then
             echo "Info: Grafana Data Source '$dbname' already exists."
        else
            echo "Warning: Failed to create Grafana Data Source (HTTP $GF_STATUS)"
        fi
    fi
fi

# ---------------------------------------------------------
# HELPER: Tag Definitions
# ---------------------------------------------------------
get_tags_for_table() {
    # Tags for statport (excluding the N:S:P which we handle dynamically)
    if [ "$1" == "statport" ]; then
        echo "PORT_TYPE,TRANS_TYPE" 
    else
        echo ""
    fi
}

# ---------------------------------------------------------
# CORE FUNCTION: Process Single File
# ---------------------------------------------------------
process_sqlite_file() {
    local db_file="$1"
    
    echo "------------------------------------------------"
    echo "Processing: $db_file"
    
    # Clear output file for this batch
    > "$OUTPUT_FILE"

    # Only process 'statport' table
    local tables="statport"
    
    for table in $tables; do
        local tag_cols=$(get_tags_for_table "$table")
        
        # Verify table exists in DB before querying
        local check_table=$(sqlite3 "$db_file" "SELECT name FROM sqlite_master WHERE type='table' AND name='$table';")
        if [ -z "$check_table" ]; then
            echo "  - Skipping $table (not found in DB)"
            continue
        fi

        sqlite3 -header -csv "$db_file" "SELECT * FROM $table;" | \
        awk -F, -v measurement="$table" -v tags="$tag_cols" '
        BEGIN {
            split(tags, t_array, ",");
            for (i in t_array) is_tag[t_array[i]] = 1;
            
            idx_pn = 0; idx_ps = 0; idx_pp = 0; idx_pt = 0;
        }
        NR==1 {
            for (i=1; i<=NF; i++) {
                gsub(/^"|"$/, "", $i);
                col_name[i] = $i;
                if (tolower($i) == "tsecs") time_col = i;
                
                # Identify Columns
                if ($i == "PORT_N") idx_pn = i;
                if ($i == "PORT_S") idx_ps = i;
                if ($i == "PORT_P") idx_pp = i;
                if ($i == "PORT_TYPE") idx_pt = i;
            }
            next;
        }
        {
            # Pre-process row to strip quotes
            for (i=1; i<=NF; i++) gsub(/^"|"$/, "", $i);

            # --- FILTER: HOST PORTS ONLY ---
            if (idx_pt > 0) {
                if (tolower($idx_pt) != "host") next;
            }

            # --- BUILD TAGS ---
            tag_string = ""
            for (i=1; i<=NF; i++) {
                if (col_name[i] in is_tag) {
                    val = $i
                    gsub(/ /, "\\ ", val); 
                    gsub(/,/, "\\,", val);
                    tag_string = tag_string "," col_name[i] "=" val
                }
            }
            
            # DATA_PORT Logic
            if (idx_pn > 0 && idx_ps > 0 && idx_pp > 0) {
                tag_string = tag_string ",DATA_PORT=" $idx_pn ":" $idx_ps ":" $idx_pp
            }

            timestamp = (time_col) ? $time_col : "";

            # --- AGGREGATION LOGIC ---
            # Instead of printing immediately, sum values into an array
            # Key = timestamp + tags + field_name
            
            for (i=1; i<=NF; i++) {
                header = col_name[i];
                value = $i;

                # Filter fields: Only aggregate rbytes and wbytes
                if (header != "rbytes" && header != "wbytes") continue;

                # Skip invalid values
                if (value == "" || value == "-") continue;

                # Create a unique key for the array
                # SUBSEP is the default separator for multidimensional arrays in AWK
                key = timestamp SUBSEP tag_string SUBSEP header
                
                # Add value to existing sum (automatically handles 0 + val)
                agg[key] += value
            }
        }
        END {
            # --- OUTPUT ---
            # Iterate through the aggregated array and print final sums
            for (key in agg) {
                split(key, parts, SUBSEP)
                ts = parts[1]
                tgs = parts[2]
                fld = parts[3]
                val = agg[key]
                
                printf "%s%s,type=%s value=%s %s\n", measurement, tgs, fld, val, ts
            }
        }' >> "$OUTPUT_FILE"
    done

    # Upload this file's payload
    if [ -s "$OUTPUT_FILE" ]; then
        echo "  - Uploading payload..."
        HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" \
            --request POST "$INFLUX_URL/write?db=$dbname&precision=s" \
            --data-binary @"$OUTPUT_FILE")

        HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

        if [ "$HTTP_STATUS" -eq 204 ]; then
            echo "  - Success (HTTP 204)"
            return 0
        else
            echo "  - Error: Upload failed (HTTP $HTTP_STATUS)"
            return 1
        fi
    else
        echo "  - Warning: No data extracted."
        return 0
    fi
}

# ---------------------------------------------------------
# EXECUTION LOOP
# ---------------------------------------------------------
ANY_UPLOAD_SUCCESS=false

if [ -d "$INPUT_PATH" ]; then
    echo "Target is a directory. Processing all .db files in '$INPUT_PATH'..."
    shopt -s nullglob
    for f in "$INPUT_PATH"/*.db; do
        process_sqlite_file "$f"
        if [ $? -eq 0 ]; then ANY_UPLOAD_SUCCESS=true; fi
    done
    shopt -u nullglob
else
    # Single file processing
    process_sqlite_file "$INPUT_PATH"
    if [ $? -eq 0 ]; then ANY_UPLOAD_SUCCESS=true; fi
fi

echo "All tasks finished."
