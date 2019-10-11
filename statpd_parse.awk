#!/usr/bin/awk -f 
# Usage statpd_parse.awk ./statpd.out 
{
### TIME STAMP ###
 if(($0 ~ /second/ )&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### SSD150 ###
# Current iops
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=riopscur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=wiopscur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=tiopscur value="$6" "ts);t++;}

# Avg iops
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=riopsavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=wiopsavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=tiopsavg value="$7" "ts);t++;}


# Maximum iops
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=riopsmax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=wiopsmax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150IO,%s,%s\n","PDID="$1,"type=tiopsmax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1024" "ts);t++;}

# Avg Mbps
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1024" "ts);t++;}

# Max Mbps
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1024" "ts);t++;}

# Current service times
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Average service times
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="SSD") && ($4 == "150") && ( $5=="r" )) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="w" )) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="SSD") && ($4 == "150") && ( $5=="t" )) {printf("SSD150Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### SSD100 ###
# Current iops
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=riopscur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=wiopscur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=tiopscur value="$6" "ts);t++;}

# Avg iops
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=riopsavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=wiopsavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=tiopsavg value="$7" "ts);t++;}


# Max iops
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=riopsmax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=wiopsmax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100IO,%s,%s\n","PDID="$1,"type=tiopsmax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1024" "ts);t++;}

# Avg Mbps
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1024" "ts);t++;}

# Max Mbps
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1024" "ts);t++;}

# Current service times
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="SSD") && ($4 == "100") && ( $5=="r" )) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="w" )) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="SSD") && ($4 == "100") && ( $5=="t" )) {printf("SSD100Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### FC15 ###
# Current iops
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=riopscur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=wiopscur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=tiopscur value="$6" "ts);t++;}

# Avg iops
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=riopsavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=wiopsavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=tiopsavg value="$7" "ts);t++;}


# Max iops
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=riopsmax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=wiopsmax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15IO,%s,%s\n","PDID="$1,"type=tiopsmax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1024" "ts);t++;}

# Avg Mbps
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1024" "ts);t++;}

# Max Mbps
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1024" "ts);t++;}

# Current service times
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="FC") && ($4 == "15") && ( $5=="r" )) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="w" )) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="FC") && ($4 == "15") && ( $5=="t" )) {printf("FC15Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### FC10 ###
# Current iops
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=riopscur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=wiopscur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=tiopscur value="$6" "ts);t++;}

# Avg iops
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=riopsavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=wiopsavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=tiopsavg value="$7" "ts);t++;}


# Max iops
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=riopsmax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=wiopsmax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10IO,%s,%s\n","PDID="$1,"type=tiopsmax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1024" "ts);t++;}

# Avg Mbps
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1024" "ts);t++;}

# Max Mbps
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1024" "ts);t++;}

# Current service times
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="FC") && ($4 == "10") && ( $5=="r" )) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="w" )) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="FC") && ($4 == "10") && ( $5=="t" )) {printf("FC10Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### NL7 ###
# Current iops
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=riopscur value="$6" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=wiopscur value="$6" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=tiopscur value="$6" "ts);t++;}

# Avg iops
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=riopsavg value="$7" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=wiopsavg value="$7" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=tiopsavg value="$7" "ts);t++;}


# Max iops
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=riopsmax value="$8" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=wiopsmax value="$8" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7IO,%s,%s\n","PDID="$1,"type=tiopsmax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1024" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1024" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1024" "ts);t++;}

# Avg Mbps
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1024" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1024" "ts);t++;}

# Max Mbps
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1024" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1024" "ts);t++;}

# Current service times
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="NL") && ($4 == "7") && ( $5=="r" )) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="w" )) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="NL") && ($4 == "7") && ( $5=="t" )) {printf("NL7Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}
}
