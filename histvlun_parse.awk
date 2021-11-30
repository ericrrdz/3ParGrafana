#!/usr/bin/awk -f
# Usage histvlun_parse.awk ./histvlun.out
{
### TIME STAMP ###
 if(($0 ~ /millisec/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### VV stats ###
# Time Hist Read
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=101 value="$3" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=102 value="$4" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=103 value="$5" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=104 value="$6" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=105 value="$7" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=106 value="$8" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=107 value="$9" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=108 value="$10" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=109 value="$11" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=110 value="$12" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=111 value="$13" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=112 value="$14" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=113 value="$15" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=114 value="$16" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=115 value="$17" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=116 value="$18" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistTime,%s,%s,%s\n","Vv="$1,"op="$2,"type=117 value="$19" "ts);t++;}

# Size Hist Read
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=201 value="$20" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=202 value="$21" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=203 value="$22" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=204 value="$23" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=205 value="$24" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=206 value="$25" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=207 value="$26" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=208 value="$27" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=209 value="$28" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=210 value="$29" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=211 value="$30" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=212 value="$31" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=213 value="$32" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=214 value="$33" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=215 value="$34" "ts);t++;}
 if ((NF==35)&&($1!="VVname")) {printf("VlunHistSize,%s,%s,%s\n","Vv="$1,"op="$2,"type=216 value="$35" "ts);t++;}
}
