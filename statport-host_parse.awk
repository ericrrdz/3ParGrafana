#!/usr/bin/awk -f 
# Usage statport-host_parse.awk ./statport-host.out 
{
### TIME STAMP ###
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### HostPort stats ###
# Current io
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=riocur value="$4" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=wiocur value="$4" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=tiocur value="$4" "ts);t++;}

# Avg io
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=rioavg value="$5" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=wioavg value="$5" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=tioavg value="$5" "ts);t++;}

# Max io
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=riomax value="$6" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=wiomax value="$6" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortIo,%s,%s\n","HostPort="$1,"type=tiomax value="$6" "ts);t++;}

# Current mbps
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=rmbpscur value="$7/1000" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=wmbpscur value="$7/1000" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=tmbpscur value="$7/1000" "ts);t++;}

# Avg mbps
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=rmbpsavg value="$8/1000" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=wmbpsavg value="$8/1000" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=tmbpsavg value="$8/1000" "ts);t++;}

# Max mbps
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=rmbpsmax value="$9/1000" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=wmbpsmax value="$9/1000" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortMbps,%s,%s\n","HostPort="$1,"type=tmbpsmax value="$9/1000" "ts);t++;}

# Current service times
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortSvt,%s,%s\n","HostPort="$1,"type=rsvtcur value="$10" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortSvt,%s,%s\n","HostPort="$1,"type=wsvtcur value="$10" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortSvt,%s,%s\n","HostPort="$1,"type=tsvtcur value="$10" "ts);t++;}

# Avg service times
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortSvt,%s,%s\n","HostPort="$1,"type=rsvtavg value="$11" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortSvt,%s,%s\n","HostPort="$1,"type=wsvtavg value="$11" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortSvt,%s,%s\n","HostPort="$1,"type=tsvtavg value="$11" "ts);t++;}

# Current IO size
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortIosz,%s,%s\n","HostPort="$1,"type=rioszcur value="$12" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortIosz,%s,%s\n","HostPort="$1,"type=wioszcur value="$12" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortIosz,%s,%s\n","HostPort="$1,"type=tioszcur value="$12" "ts);t++;}

# Avg IO size
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="r")) {printf("HstPortIosz,%s,%s\n","HostPort="$1,"type=rioszavg value="$13" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="w")) {printf("HstPortIosz,%s,%s\n","HostPort="$1,"type=wioszavg value="$13" "ts);t++;}
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortIosz,%s,%s\n","HostPort="$1,"type=tioszavg value="$13" "ts);t++;}

# Qlen
 if ((NF==14)&&($2=="Data")&&($4>0)&&($3=="t")) {printf("HstPortQlen,%s,%s\n","HostPort="$1,"type=qlen value="$14" "ts);t++;}
}
