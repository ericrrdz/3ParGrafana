#!/bin/bash
# ---------------------------------------------------------
# 3PAR INFLUX LOADER (Optimized)
# ---------------------------------------------------------
# Usage: ./3pg_perfanal.sh [-n | -a] <path_to_Perf_parent_dir>
#   -n : New Database (Create DB & Datasource)
#   -a : Aggregate (Append to existing DB)

# --- CONFIGURATION ---
INFLUX_HOST="c3-dl360pg8-300.cxo.storage.hpecorp.net"
INFLUX_PORT="8086"
INFLUX_URL="http://${INFLUX_HOST}:${INFLUX_PORT}"

GRAFANA_HOST="http://c3-dl360pg8-300.cxo.storage.hpecorp.net:3000"
GRAFANA_INFLUX_URL="http://c3-dl360pg8-300.cxo.storage.hpecorp.net:8086"

GRAFANA_TOKEN="glsa_ghRR5ijBXGdiPlz5dNkhDRz5yXi3BJ7r_512b85e5"
MAX_PARALLEL=17  # max concurrent dataset jobs

# Setup Temp Directory
WORK_DIR=$(mktemp -d)
PARSER_DIR="$WORK_DIR/parsers"
mkdir -p "$PARSER_DIR"

# Guarantee cleanup on any exit (normal, error, or interrupt)
trap 'rm -rf "$WORK_DIR"' EXIT

echo "Extracting embedded parsers..."

# =========================================================
# EMBEDDED AWK PARSERS
# =========================================================

# --- 1. HistPD Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/histpd_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /millisec/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==29)&&($1!="ID")&&($1!="total")) {
   for(i=3;i<=15;i++) printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=" (100+i-2) " value="$i" "ts);
   for(i=16;i<=24;i++) printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=" (200+i-15) " value="$i" "ts);
 }
}
AWK_EOF

# --- 2. HistVLUN Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/histvlun_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /millisec/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF>=32 && NF<=35)&&($1!="VVname")&&($1!="total")) {
   for(i=3;i<=19;i++) {
     if(i<=NF) printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=" (100+i-2) " value="$i" "ts);
   }
   for(i=20;i<=35;i++) {
     if(i<=NF) printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=" (200+i-19) " value="$i" "ts);
   }
 }
}
AWK_EOF

# --- 3. StatCMPCred Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statcmpcred_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /Current/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==9)&&($1!="Node")) {
   for(i=2;i<=9;i++) printf("PageCred,%s,%s\n","Node="$1,"type=node" (i-2) " value="$i" "ts);
 }
}
AWK_EOF

# --- 4. StatCMP Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statcmp_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /Current/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==10)&&($7>10000)&&($7!="SSD")&&($7!="Writing")) {
   if($8>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=fcdelack value="$8" "ts);
   if($9>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=nldelack value="$9" "ts);
   if($10>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssddelack value="$10" "ts);
 }
 if ((NF==13)&&($1!="Node")) {
   if($10>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=fcdelack value="$10" "ts);
   if($11>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=nldelack value="$11" "ts);
   if($12>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssd150delack value="$12" "ts);
   if($13>0) printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssd100delack value="$13" "ts);
 }
}
AWK_EOF

# --- 5. StatCPU Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statcpu_parse.awk"
#!/usr/bin/awk -f
{
 if((NF==2)&&gsub(/\//," ")&&gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if (/total/) {gsub (/,total/," "); printf("CPU,%s,%s\n","NODE="$1,"type=user value="$2" "ts);}
 if ((NF==6)&&($2!="user")&&($5>1110)) {
   printf("CPU,%s,%s\n","NODE="$1,"type=sys value="$3" "ts);
   printf("CPU,%s,%s\n","NODE="$1,"type=idle value="$4" "ts);
   printf("CPU,%s,%s\n","NODE="$1,"type=intr value="$5" "ts);
   printf("CPU,%s,%s\n","NODE="$1,"type=ctxt value="$6" "ts);
 }
}
AWK_EOF

# --- 6. iSCSI Full Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statiscsifull_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /Counts/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==5)&&($3>0)&&$1!="Port") {printf("iscsicounters,%s,%s,%s\n","Port="$1,"counter="$2,"type=cur value="$3" "ts);}
}
AWK_EOF

# --- 7. StatPD Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statpd_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==16)&&(ts>0)&&($6>0)&&($5~/^[rwt]$/)) {
   t=$5;
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"iocur value="$6" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"ioavg value="$7" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"iomax value="$8" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"mbpscur value="$9/1000" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"mbpsavg value="$10/1000" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"mbpsmax value="$11/1000" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"svtcur value="$12" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"svtavg value="$13" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"ioszcur value="$14" "ts);
   printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type="t"ioszavg value="$15" "ts);
   if (t=="t") printf("PdIo,%s,%s,%s,%s,%s\n","PD="$1,"PORT="$2,"TIER="$3,"SPEED="$4,"type=qlen value="$16" "ts);
 }
}
AWK_EOF

# --- 8. StatPort Disk Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statport-disk_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==14)&&($2=="Data")&&($4>0)) {
   t=$3;
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"iocur value="$4" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"ioavg value="$5" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"iomax value="$6" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"mbpscur value="$7/1000" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"mbpsavg value="$8/1000" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"mbpsmax value="$9/1000" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"svtcur value="$10" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"svtavg value="$11" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"ioszcur value="$12" "ts);
   printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type="t"ioszavg value="$13" "ts);
   if (t=="t") printf("DiskPortIo,%s,%s\n","DiskPort="$1,"type=qlen value="$14" "ts);
 }
}
AWK_EOF

# --- 9. StatPort Host Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statport-host_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==14)&&($2=="Data")&&($4>0)) {
   t=$3;
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"iocur value="$4" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"ioavg value="$5" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"iomax value="$6" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"mbpscur value="$7/1000" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"mbpsavg value="$8/1000" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"mbpsmax value="$9/1000" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"svtcur value="$10" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"svtavg value="$11" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"ioszcur value="$12" "ts);
   printf("HostPortIo,%s,%s\n","HostPort="$1,"type="t"ioszavg value="$13" "ts);
   if (t=="t") printf("HostPortIo,%s,%s\n","HostPort="$1,"type=qlen value="$14" "ts);
 }
}
AWK_EOF

# --- 10. StatQoS Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statqos_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF=="21")&&($5>0)) {
   t=$3;
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"iocur value="$5" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"ioavg value="$6" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"iomax value="$7" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"mbpscur value="$9/1000" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"mbpsavg value="$10/1000" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"mbpsmax value="$11/1000" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"svtcur value="$13" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"svtavg value="$14" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"wvtcur value="$15" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"wvtavg value="$16" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"ioszcur value="$17" "ts);
   printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type="t"ioszavg value="$18" "ts);
   if (t=="t") {
     printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rjct value="$19" "ts);
     printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qlen value="$20" "ts);
     printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wqlen value="$21" "ts);
     printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qosio value="$4" "ts);
     printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qosbw value="$8" "ts);
     printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qossvt value="$12" "ts);
   }
 }
}
AWK_EOF

# --- 11. StatRCVV Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statrcvv_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /KBytes/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==18)&&($1!="VVname")&&($7>0)) {
   prefix="RCVV="$1",RCGroup="$2",Target="$3",Mode="$4",Port="$5",RcType="$6
   printf("RcVvIo,%s,%s\n",prefix,"type=iocur value="$7" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=ioavg value="$8" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=iomax value="$9" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=mbpscur value="$10/1000" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=mbpsavg value="$11/1000" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=mbpsmax value="$12/1000" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=svtcur value="$13" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=svtavg value="$14" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=rmtsvtcur value="$15" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=rmtsvtavg value="$16" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=ioszcur value="$17" "ts);
   printf("RcVvIo,%s,%s\n",prefix,"type=ioszavg value="$18" "ts);
 }
}
AWK_EOF

# --- 12. StatVLUN Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statvlun_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((ts>0)&&($6>0)&&($5~/^[rwt]$/)) {
   t=$5;
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"iocur value="$6" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"ioavg value="$7" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"iomax value="$8" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"mbpscur value="$9/1000" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"mbpsavg value="$10/1000" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"mbpsmax value="$11/1000" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"svtcur value="$12" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"svtavg value="$13" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"ioszcur value="$14" "ts);
   printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type="t"ioszavg value="$15" "ts);
   if (t=="t") printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=qlen value="$16" "ts);
 }
}
AWK_EOF

# --- 13. StatVLUN Throughput Totals Parser ---
# Captures aggregate r/w/t throughput rows (NF==11) from statvlun output.
# Emits TtlVlunThru metrics: ttlthru, rdthru, wrthru.
cat << 'AWK_EOF' > "$PARSER_DIR/statvlunthru.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if (($2=="t")&&NF==11) {printf("TtlVlunThru,%s\n","type=ttlthru value="$5" "ts);}
 if (($2=="r")&&NF==11) {printf("TtlVlunThru,%s\n","type=rdthru value="$5" "ts);}
 if (($2=="w")&&NF==11) {printf("TtlVlunThru,%s\n","type=wrthru value="$5" "ts);}
}
AWK_EOF

# --- 14. StatVV Parser ---
cat << 'AWK_EOF' > "$PARSER_DIR/statvv_parse.awk"
#!/usr/bin/awk -f
{
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}
 if ((NF==13)&&(ts>0)&&($3>0)&&($2~/^[rwt]$/)) {
   t=$2;
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"iocur value="$3" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"ioavg value="$4" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"iomax value="$5" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"mbpscur value="$6/1000" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"mbpsavg value="$7/1000" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"mbpsmax value="$8/1000" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"svtcur value="$9" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"svtavg value="$10" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"ioszcur value="$11" "ts);
   printf("VvIo,%s,%s\n","Vv="$1,"type="t"ioszavg value="$12" "ts);
   if (t=="t") printf("VvIo,%s,%s\n","Vv="$1,"type=qlen value="$13" "ts);
 }
}
AWK_EOF

chmod +x "$PARSER_DIR"/*.awk

# =========================================================
# MAIN LOGIC
# =========================================================

MODE=""
while getopts "na" opt; do
  case $opt in
    n) MODE="new" ;;
    a) MODE="append" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

INPUT_DIR="$1"

if [[ -z "$MODE" || -z "$INPUT_DIR" ]]; then
  echo "Usage: $0 [-n | -a] <path_to_Perf_parent_dir>" >&2
  exit 1
fi

if [[ ! -d "$INPUT_DIR" ]]; then
  echo "Error: Input directory '$INPUT_DIR' does not exist." >&2
  exit 1
fi

if [[ "$MODE" == "new" ]]; then
  read -p 'Enter Short Customer Nickname: ' customer
  dbname="${USER}_${customer}"
  echo "Creating DB: $dbname"
  curl --noproxy '*' -sf -XPOST "$INFLUX_URL/query" --data-urlencode "q=CREATE DATABASE $dbname"

  echo "Creating Grafana Datasource..."
  curl --noproxy '*' --insecure --silent -X POST \
    -H "Authorization: Bearer ${GRAFANA_TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "'"$dbname"'",
      "type": "influxdb",
      "url": "'"$GRAFANA_INFLUX_URL"'",
      "database": "'"$dbname"'",
      "access": "proxy"
    }' "$GRAFANA_HOST/api/datasources" > /dev/null
  echo " Done."
else
  read -p 'Enter Existing DB Customer Nickname (DB will be ${USER}_<nickname>): ' customer
  dbname="${USER}_${customer}"
  echo "Using DB: $dbname"
fi

# --- AGGREGATION ---
echo "Aggregating files from $INPUT_DIR/Perf.* ..."

aggregate() {
  find "$INPUT_DIR" -type f -name "$1" -exec cat {} + > "$WORK_DIR/$2" 2>/dev/null
}

aggregate "statcpu*"        "statcpu.out"
aggregate "statpd*"         "statpd.out"
aggregate "statvv*"         "statvv.out"
aggregate "statvlun*"       "statvlun.out"
aggregate "statport-host*"  "hostport.out"
aggregate "statport-disk*"  "diskport.out"
aggregate "statiscsi-full*" "iscsi.out"
aggregate "statrcvv*"       "rcvv.out"
aggregate "statqos*"        "qos.out"
aggregate "histvlun*"       "histvlun.out"
aggregate "histpd*"         "histpd.out"
aggregate "statcmp*"        "statcmp.out"

# Special split for statcmp
if [[ -s "$WORK_DIR/statcmp.out" ]]; then
  awk '/Page Statistics/{flag=1;next}/Current/{flag=0}flag {if (NF>0) {print $0}};/Current/{print}' \
    "$WORK_DIR/statcmp.out" > "$WORK_DIR/delack.out"
  awk '/Temporary and Page Credits/{flag=1;next}/Page Statistics/{flag=0}flag {if (NF>0) {print $0}};/Current/{print}' \
    "$WORK_DIR/statcmp.out" > "$WORK_DIR/cmpcred.out"
fi

# --- PROCESSING ---

# Builds a pipeline from file -> optional awk filter -> parser -> optional grep_filter
# and writes chunks to InfluxDB. Called in background for parallelism.
run_pipeline() {
  local file="$1" parser="$2" filter="$3" grep_filter="$4"

  if [[ -n "$filter" && -n "$grep_filter" ]]; then
    awk "$filter {print}" "$WORK_DIR/$file" | awk -f "$PARSER_DIR/$parser" | grep -v -- "$grep_filter"
  elif [[ -n "$filter" ]]; then
    awk "$filter {print}" "$WORK_DIR/$file" | awk -f "$PARSER_DIR/$parser"
  elif [[ -n "$grep_filter" ]]; then
    awk -f "$PARSER_DIR/$parser" "$WORK_DIR/$file" | grep -v -- "$grep_filter"
  else
    awk -f "$PARSER_DIR/$parser" "$WORK_DIR/$file"
  fi
}

process_dataset() {
  local name="$1" file="$2" parser="$3" filter="$4" grep_filter="$5"
  local chunk_dir="$WORK_DIR/chunks_${name// /_}"

  [[ -s "$WORK_DIR/$file" ]] || return
  echo "Processing $name..."
  mkdir -p "$chunk_dir"

  run_pipeline "$file" "$parser" "$filter" "$grep_filter" \
    | split -l 500000 - "$chunk_dir/chunk_"

  for chunk in "$chunk_dir"/chunk_*; do
    [[ -e "$chunk" ]] || continue
    HTTP_CODE=$(curl --noproxy '*' -s -o /dev/null -w "%{http_code}" \
      -XPOST "$INFLUX_URL/write?db=${dbname}&precision=s" --data-binary @"$chunk")
    if [[ "$HTTP_CODE" != "204" ]]; then
      echo "Warning: InfluxDB write returned HTTP $HTTP_CODE for $name ($chunk)" >&2
      if [[ "$HTTP_CODE" == "400" ]]; then
        echo "--- First 3 lines of bad chunk ---" >&2
        head -3 "$chunk" >&2
        echo "---" >&2
      fi
    fi
    rm "$chunk"
  done
}

# Run datasets in parallel, capped at MAX_PARALLEL concurrent jobs
run_limited() {
  while [[ $(jobs -rp | wc -l) -ge $MAX_PARALLEL ]]; do sleep 0.2; done
  process_dataset "$@" &
}

run_limited "CPU"         "statcpu.out"   "statcpu_parse.awk"       "" ""
run_limited "DelAck"      "delack.out"    "statcmp_parse.awk"       "" ""
run_limited "CMP Credits" "cmpcred.out"   "statcmpcred_parse.awk"   "" "---"
run_limited "iSCSI"       "iscsi.out"     "statiscsifull_parse.awk" '$3!=0.0&&$4!=0.0&&$5!=0.0' ""
run_limited "Host Port"   "hostport.out"  "statport-host_parse.awk" '$4!=0&&$5!=0&&$6!=0' ""
run_limited "Disk Port"   "diskport.out"  "statport-disk_parse.awk" '$4!=0&&$5!=0&&$6!=0' ""
run_limited "PD"          "statpd.out"    "statpd_parse.awk"        '$6!=0&&$7!=0&&$8!=0' ""
run_limited "VV"          "statvv.out"    "statvv_parse.awk"        '$3!=0&&$4!=0&&$5!=0' ""
run_limited "VLUN"        "statvlun.out"  "statvlun_parse.awk"      '$6!=0&&$7!=0&&$8!=0' ""
run_limited "VLUN Thru"   "statvlun.out"  "statvlunthru.awk"        '$6!=0&&$7!=0&&$8!=0' ""
run_limited "RCVV"        "rcvv.out"      "statrcvv_parse.awk"      '$7>0' ""
run_limited "QoS"         "qos.out"       "statqos_parse.awk"       '$5>0' ""
run_limited "Hist VLUN"   "histvlun.out"  "histvlun_parse.awk"      "" "value=0"
run_limited "Hist PD"     "histpd.out"    "histpd_parse.awk"        "" "value=0"

wait
echo "Job Complete."
