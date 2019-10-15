#!/usr/bin/awk -f 
# Usage statcmp_parse.awk ./statcmp.out 
{
### TIME STAMP ###
 if(($0 ~ /Current/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### Node stats ###
# DelAck
if ((NF==13)&&($1!="Node")) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=fcdelack value="$10" "ts);t++;}
if ((NF==13)&&($1!="Node")) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=nldelack value="$11" "ts);t++;}
if ((NF==13)&&($1!="Node")) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssd150delack value="$12" "ts);t++;}
if ((NF==13)&&($1!="Node")) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssd100delack value="$13" "ts);t++;}

}
