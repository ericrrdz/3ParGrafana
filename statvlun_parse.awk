#!/usr/bin/awk -f 
# Usage statvlun_parse.awk ./statvlun.out 
{
### TIME STAMP ###
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### VLUN stats ###
# Current io
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=riocur value="$6" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wiocur value="$6" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rioavg value="$7" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wioavg value="$7" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tioavg value="$7" "ts);t++;}

# Max io
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=riomax value="$8" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wiomax value="$8" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tiomax value="$8" "ts);t++;}

# Current mbps
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg mbps
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max mbps
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rsvtcur value="$12" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wsvtcur value="$12" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rsvtavg value="$13" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wsvtavg value="$13" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tsvtavg value="$13" "ts);t++;}

# Current IO size
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rioszcur value="$14" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wioszcur value="$14" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tioszcur value="$14" "ts);t++;}

# Avg IO size
 if (($5=="r")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=rioszavg value="$15" "ts);t++;}
 if (($5=="w")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=wioszavg value="$15" "ts);t++;}
 if (($5=="t")&&($6>0)) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($5=="t")&&($6>0)&&$16>0) {printf("VlunIo,%s,%s,%s,%s\n","VLUN="$2,"HOST="$3,"PORT="$4,"type=qlen value="$16" "ts);t++;}
}
