#!/usr/bin/awk -f 
# Usage statrcvv_parse.awk ./statrcvv.out 
{
### TIME STAMP ###
 if(($0 ~ /KBytes/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### RCVV stats ###
# Current io
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=iocur value="$7" "ts);t++;}

# Avg io
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=ioavg value="$8" "ts);t++;}

# Max io
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=iomax value="$9" "ts);t++;}

# Current mbps
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=mbpscur value="$10/1000" "ts);t++;}

# Avg mbps
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=mbpsavg value="$11/1000" "ts);t++;}

# Max mbps
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=mbpsmax value="$12/1000" "ts);t++;}

# Current service times
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=svtcur value="$13" "ts);t++;}

# Avg service times
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=svtavg value="$14" "ts);t++;}
 
# Current Rmt service times
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=rmtsvtcur value="$15" "ts);t++;}

# Avg Rmt service times
if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=rmtsvtavg value="$16" "ts);t++;}
 
# Current IO size
 if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=ioszcur value="$17" "ts);t++;}

# Avg IO size
if ((NF==18)&&($1!="VVname")&&($7>0)) {printf("RcVvIo,%s,%s,%s,%s,%s,%s,%s\n","RCVV="$1,"RCGroup="$2,"Target="$3,"Mode="$4,"Port="$5,"RcType="$6,"type=ioszavg value="$18" "ts);t++;}
}
