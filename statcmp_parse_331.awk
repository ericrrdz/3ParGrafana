#!/usr/bin/awk -f 
# Usage statcmp_parse.awk ./statcmp.out 
{
### TIME STAMP ###
 if(($0 ~ /Current/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### Node stats ###
# DelAck
if ((NF==10)&&($7==76800)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=fcdelack value="$8" "ts);t++;}
if ((NF==10)&&($7==76800)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=nldelack value="$9" "ts);t++;}
if ((NF==10)&&($7==76800)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssddelack value="$10" "ts);t++;}
}
