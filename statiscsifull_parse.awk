#!/usr/bin/awk -f 
# Usage statiscsifull_parse.awk ./statiscsi-fullcounts.out 
{
### TIME STAMP ###
 if(($0 ~ /Counts/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### VV stats ###
# Current io
 if ((NF==5)&&($3>0)&&$1!="Port") {printf("iscsicounters,%s,%s,%s\n","Port="$1,"counter="$2,"type=cur value="$3" "ts);t++;}
}


# {printf("VvIo,%s,%s\n","Vv="$1,"type=tioszavg value="$12" "ts);t++;}

