#!/usr/bin/awk -f
# Usage statcpu_parse.awk ./statcpu.out
{
### TIME STAMP ###
 if((NF==2)&&gsub(/\//," ")&&gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

###CPU stats###
 if (/total/) {gsub (/,total/," "); printf("CPU,%s,%s\n","NODE="$1,"type=user value="$2" "ts);t++;}
 if ((NF==6)&&($2!="user")&&($5>1110)) {printf("CPU,%s,%s\n","NODE="$1,"type=sys value="$3" "ts);t++;}
 if ((NF==6)&&($2!="user")&&($5>1110)) {printf("CPU,%s,%s\n","NODE="$1,"type=idle value="$4" "ts);t++;}
 if ((NF==6)&&($2!="user")&&($5>1110)) {printf("CPU,%s,%s\n","NODE="$1,"type=intr value="$5" "ts);t++;}
 if ((NF==6)&&($2!="user")&&($5>1110)) {printf("CPU,%s,%s\n","NODE="$1,"type=ctxt value="$6" "ts);t++;}
}
