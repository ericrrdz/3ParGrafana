#!/usr/bin/awk -f 
# Usage statvlun_parse.awk ./statvlun.out 
{
### TIME STAMP ###
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### VLUN stats ###
# Current io
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=riocur value="$6" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=wiocur value="$6" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=rioavg value="$7" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=wioavg value="$7" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=tioavg value="$7" "ts);t++;}

# Max io
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=riomax value="$8" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=wiomax value="$8" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s\n","VLUN="$2,"type=tiomax value="$8" "ts);t++;}

# Current mbps
 if (($5=="r")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg mbps
 if (($5=="r")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max mbps
 if (($5=="r")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunMbps,%s,%s\n","VLUN="$2,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($5=="r")&&($6>0)) {printf("VlunSvt,%s,%s\n","VLUN="$2,"type=rsvtcur value="$12" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunSvt,%s,%s\n","VLUN="$2,"type=wsvtcur value="$12" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunSvt,%s,%s\n","VLUN="$2,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($5=="r")&&($6>0)) {printf("VlunSvt,%s,%s\n","VLUN="$2,"type=rsvtavg value="$13" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunSvt,%s,%s\n","VLUN="$2,"type=wsvtavg value="$13" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunSvt,%s,%s\n","VLUN="$2,"type=tsvtavg value="$13" "ts);t++;}

# Current IO size
 if (($5=="r")&&($6>0)) {printf("VlunIosz,%s,%s\n","VLUN="$2,"type=rioszcur value="$14" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIosz,%s,%s\n","VLUN="$2,"type=wioszcur value="$14" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIosz,%s,%s\n","VLUN="$2,"type=tioszcur value="$14" "ts);t++;}

# Avg IO size
 if (($5=="r")&&($6>0)) {printf("VlunIosz,%s,%s\n","VLUN="$2,"type=rioszavg value="$15" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIosz,%s,%s\n","VLUN="$2,"type=wioszavg value="$15" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIosz,%s,%s\n","VLUN="$2,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($5=="t")&&($6>0)) {printf("VlunQlen,%s,%s\n","VLUN="$2,"type=qlen value="$16" "ts);t++;}

### Host stats ###
# Current io
 if (($5=="r")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=riocur value="$6" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=wiocur value="$6" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($5=="r")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=rioavg value="$7" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=wioavg value="$7" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=tioavg value="$7" "ts);t++;}

# Max io
 if (($5=="r")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=riomax value="$8" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=wiomax value="$8" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostIo,%s,%s\n","Host="$3,"type=tiomax value="$8" "ts);t++;}

# Current mbps
 if (($5=="r")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg mbps
 if (($5=="r")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max mbps
 if (($5=="r")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostMbps,%s,%s\n","Host="$3,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($5=="r")&&($6>0)) {printf("HostSvt,%s,%s\n","Host="$3,"type=rsvtcur value="$12" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostSvt,%s,%s\n","Host="$3,"type=wsvtcur value="$12" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostSvt,%s,%s\n","Host="$3,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($5=="r")&&($6>0)) {printf("HostSvt,%s,%s\n","Host="$3,"type=rsvtavg value="$13" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostSvt,%s,%s\n","Host="$3,"type=wsvtavg value="$13" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostSvt,%s,%s\n","Host="$3,"type=tsvtavg value="$13" "ts);t++;}

# Current IO size
 if (($5=="r")&&($6>0)) {printf("HostIosz,%s,%s\n","Host="$3,"type=rioszcur value="$14" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostIosz,%s,%s\n","Host="$3,"type=wioszcur value="$14" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostIosz,%s,%s\n","Host="$3,"type=tioszcur value="$14" "ts);t++;}

# Avg IO size
 if (($5=="r")&&($6>0)) {printf("HostIosz,%s,%s\n","Host="$3,"type=rioszavg value="$15" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("HostIosz,%s,%s\n","Host="$3,"type=wioszavg value="$15" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("HostIosz,%s,%s\n","Host="$3,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($5=="t")&&($6>0)) {printf("HostQlen,%s,%s\n","Host="$3,"type=qlen value="$16" "ts);t++;}
}
