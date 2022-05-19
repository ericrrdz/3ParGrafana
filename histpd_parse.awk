#!/usr/bin/awk -f
# Usage histpd_parse.awk ./histpd.out
{
### TIME STAMP ###
 if(($0 ~ /millisec/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### Pd stats ###
# Time Hist Read
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=101 value="$3" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=102 value="$4" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=103 value="$5" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=104 value="$6" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=105 value="$7" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=106 value="$8" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=107 value="$9" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=108 value="$10" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=109 value="$11" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=110 value="$12" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=111 value="$13" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=112 value="$14" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistTime,%s,%s,%s\n","Pd="$1,"Port="$2,"type=113 value="$15" "ts);t++;}

# Size Hist Read
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=201 value="$16" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=202 value="$17" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=203 value="$18" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=204 value="$19" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=205 value="$20" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=206 value="$21" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=207 value="$22" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=208 value="$23" "ts);t++;}
 if ((NF==24)&&($1!="ID")&&($1!="total")) {printf("PdHistSize,%s,%s,%s\n","Pd="$1,"Port="$2,"type=209 value="$24" "ts);t++;}
}
