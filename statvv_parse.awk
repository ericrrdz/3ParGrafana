#!/usr/bin/awk -f 
# Usage statvv_parse.awk ./statvv.out 
{
### TIME STAMP ###
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### VV stats ###
# Current io
 if (($2=="r")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=riocur value="$3" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=wiocur value="$3" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=tiocur value="$3" "ts);t++;}

# Avg io
 if (($2=="r")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=rioavg value="$4" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=wioavg value="$4" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=tioavg value="$4" "ts);t++;}

# Max io
 if (($2=="r")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=riomax value="$5" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=wiomax value="$5" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvIo,%s,%s\n","Vvalue="$1,"type=tiomax value="$5" "ts);t++;}

# Current mbps
 if (($2=="r")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=rmbpscur value="$6/1024" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=wmbpscur value="$6/1024" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=tmbpscur value="$6/1024" "ts);t++;}

# Avg mbps
 if (($2=="r")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=rmbpsavg value="$7/1024" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=wmbpsavg value="$7/1024" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=tmbpsavg value="$7/1024" "ts);t++;}

# Max mbps
 if (($2=="r")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=rmbpsmax value="$8/1024" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=wmbpsmax value="$8/1024" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvMbps,%s,%s\n","Vvalue="$1,"type=tmbpsmax value="$8/1024" "ts);t++;}

# Current service times
 if (($2=="r")&&($3>0)) {printf("VvSvt,%s,%s\n","Vvalue="$1,"type=rsvtcur value="$9" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvSvt,%s,%s\n","Vvalue="$1,"type=wsvtcur value="$9" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvSvt,%s,%s\n","Vvalue="$1,"type=tsvtcur value="$9" "ts);t++;}

# Avg service times
 if (($2=="r")&&($3>0)) {printf("VvSvt,%s,%s\n","Vvalue="$1,"type=rsvtavg value="$10" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvSvt,%s,%s\n","Vvalue="$1,"type=wsvtavg value="$10" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvSvt,%s,%s\n","Vvalue="$1,"type=tsvtavg value="$10" "ts);t++;}

# Current IO size
 if (($2=="r")&&($3>0)) {printf("VvIosz,%s,%s\n","Vvalue="$1,"type=rioszcur value="$11" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvIosz,%s,%s\n","Vvalue="$1,"type=wioszcur value="$11" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvIosz,%s,%s\n","Vvalue="$1,"type=tioszcur value="$11" "ts);t++;}

# Avg IO size
 if (($2=="r")&&($3>0)) {printf("VvIosz,%s,%s\n","Vvalue="$1,"type=rioszavg value="$12" "ts);t++;}
 if (($2=="w")&&($3>0)) {printf("VvIosz,%s,%s\n","Vvalue="$1,"type=wioszavg value="$12" "ts);t++;}
 if (($2=="t")&&($3>0)) {printf("VvIosz,%s,%s\n","Vvalue="$1,"type=tioszavg value="$12" "ts);t++;}

# Qlen
 if (($2=="t")&&($3>0)) {printf("VvQlen,%s,%s\n","Vvalue="$1,"type=qlen value="$13" "ts);t++;}
}
