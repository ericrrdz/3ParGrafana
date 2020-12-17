#!/usr/bin/awk -f 
# Usage statqos_parse.awk ./statqos.out 
{
### TIME STAMP ###
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### QoS stats ###
# Current io
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=riocur value="$5" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wiocur value="$5" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tiocur value="$5" "ts);t++;}

# Avg io
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rioavg value="$6" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wioavg value="$6" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tioavg value="$6" "ts);t++;}

# Max io
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=riomax value="$7" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wiomax value="$7" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tiomax value="$7" "ts);t++;}

# Current mbps
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rmbpscur value="$9/1000" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wmbpscur value="$9/1000" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg mbps
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max mbps
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current Service Times
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rsvtcur value="$13" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wsvtcur value="$13" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tsvtcur value="$13" "ts);t++;}

# Avg Service Times
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rsvtavg value="$14" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wsvtavg value="$14" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tsvtavg value="$14" "ts);t++;}

# Current Wait Times
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rwvtcur value="$15" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wwvtcur value="$15" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=twvtcur value="$15" "ts);t++;}

# Avg Wait Times
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rwvtavg value="$16" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wwvtavg value="$16" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=twvtavg value="$16" "ts);t++;}

# Current IO Size
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rioszcur value="$17" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wioszcur value="$17" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tioszcur value="$17" "ts);t++;}

# Avg IO Size
 if ((NF=="21")&&($3=="r")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rioszavg value="$18" "ts);t++;}
 if ((NF=="21")&&($3=="w")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wioszavg value="$18" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=tioszavg value="$18" "ts);t++;}

# Rejects
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=rjct value="$19" "ts);t++;}
 
# Qlen
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qlen value="$20" "ts);t++;}

# Waiting Qlen
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=wqlen value="$21" "ts);t++;}

# QoS params
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qosio value="$4" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qosbw value="$8" "ts);t++;}
 if ((NF=="21")&&($3=="t")&&($5>0)) {printf("QoS,%s,%s,%s\n","TYPE="$1,"NAME="$2,"type=qossvt value="$12" "ts);t++;}
}
