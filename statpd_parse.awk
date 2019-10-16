#!/usr/bin/awk -f 
# Usage statpd_parse.awk ./statpd.out 
{
### TIME STAMP ###
 if(($0 ~ /second/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### SSD150 ###
# Current io
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=riocur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=wiocur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=rioavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=wioavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=tioavg value="$7" "ts);t++;}


# Maximum io
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=riomax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=wiomax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Io,%s,%s\n","PDID="$1,"type=tiomax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg Mbps
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max Mbps
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Average service times
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="SSD") && ($4 == "150") && ($5=="r") && ($6 > 0)) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="w") && ($6 > 0)) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="SSD") && ($4 == "150") && ($5=="t") && ($6 > 0)) {printf("SSD150Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### SSD100 ###
# Current io
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=riocur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=wiocur value="$6" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=rioavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=wioavg value="$7" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=tioavg value="$7" "ts);t++;}


# Max io
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=riomax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=wiomax value="$8" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Io,%s,%s\n","PDID="$1,"type=tiomax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg Mbps
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max Mbps
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="SSD") && ($4 == "100") && ($5=="r") && ($6 > 0)) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="w") && ($6 > 0)) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="SSD") && ($4 == "100") && ($5=="t") && ($6 > 0)) {printf("SSD100Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### FC15 ###
# Current io
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=riocur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=wiocur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=rioavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=wioavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=tioavg value="$7" "ts);t++;}


# Max io
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=riomax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=wiomax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Io,%s,%s\n","PDID="$1,"type=tiomax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg Mbps
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max Mbps
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="FC") && ($4 == "15") && ($5=="r") && ($6 > 0)) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="w") && ($6 > 0)) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="FC") && ($4 == "15") && ($5=="t") && ($6 > 0)) {printf("FC15Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### FC10 ###
# Current io
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=riocur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=wiocur value="$6" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=rioavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=wioavg value="$7" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=tioavg value="$7" "ts);t++;}


# Max io
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=riomax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=wiomax value="$8" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Io,%s,%s\n","PDID="$1,"type=tiomax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg Mbps
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max Mbps
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="FC") && ($4 == "10") && ($5=="r") && ($6 > 0)) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="w") && ($6 > 0)) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="FC") && ($4 == "10") && ($5=="t") && ($6 > 0)) {printf("FC10Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}

### NL7 ###
# Current io
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=riocur value="$6" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=wiocur value="$6" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=tiocur value="$6" "ts);t++;}

# Avg io
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=rioavg value="$7" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=wioavg value="$7" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=tioavg value="$7" "ts);t++;}


# Max io
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=riomax value="$8" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=wiomax value="$8" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Io,%s,%s\n","PDID="$1,"type=tiomax value="$8" "ts);t++;}

# Current Mbps
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=rmbpscur value="$9/1000" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=wmbpscur value="$9/1000" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=tmbpscur value="$9/1000" "ts);t++;}

# Avg Mbps
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=rmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=wmbpsavg value="$10/1000" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=tmbpsavg value="$10/1000" "ts);t++;}

# Max Mbps
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=rmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=wmbpsmax value="$11/1000" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Mbps,%s,%s\n","PDID="$1,"type=tmbpsmax value="$11/1000" "ts);t++;}

# Current service times
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=rsvtcur value="$12" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=wsvtcur value="$12" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=tsvtcur value="$12" "ts);t++;}

# Avg service times
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=rsvtavg value="$13" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=wsvtavg value="$13" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Svts,%s,%s\n","PDID="$1,"type=tsvtavg value="$13" "ts);t++;}

# Current IOSz
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=rioszcur value="$14" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=wioszcur value="$14" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=tioszcur value="$14" "ts);t++;}

# Avg IOSz
 if (($3=="NL") && ($4 == "7") && ($5=="r") && ($6 > 0)) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=rioszavg value="$15" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="w") && ($6 > 0)) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=wioszavg value="$15" "ts);t++;}
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Iosz,%s,%s\n","PDID="$1,"type=tioszavg value="$15" "ts);t++;}

# Qlen
 if (($3=="NL") && ($4 == "7") && ($5=="t") && ($6 > 0)) {printf("NL7Qlen,%s,%s\n","PDID="$1,"type=qlen value="$16" "ts);t++;}
}
