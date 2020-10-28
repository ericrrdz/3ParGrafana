#!/usr/bin/awk -f 
# Usage statcmp_parse.awk ./statcmp.out 
{
### TIME STAMP ###
 if(($0 ~ /Current/)&& gsub(/\//," ") && gsub(/:/," ")) {ts=mktime($6" "$4" "$5" "$1" "$2" "$3)}

### Node stats ###
# DelAck
if ((NF==10)&&($7>10000)&&($7!="SSD")&&($7!="Writing")&&($8>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=fcdelack value="$8" "ts);t++;}
if ((NF==10)&&($7>10000)&&($7!="SSD")&&($7!="Writing")&&($9>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=nldelack value="$9" "ts);t++;}
if ((NF==10)&&($7>10000)&&($7!="SSD")&&($7!="Writing")&&($10>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssddelack value="$10" "ts);t++;}
# Old arrays (3.2.2 & older)
if ((NF==13)&&($1!="Node")&&($10>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=fcdelack value="$10" "ts);t++;}
if ((NF==13)&&($1!="Node")&&($11>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=nldelack value="$11" "ts);t++;}
if ((NF==13)&&($1!="Node")&&($12>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssd150delack value="$12" "ts);t++;}
if ((NF==13)&&($1!="Node")&&($13>0)) {printf("NodeDelAck,%s,%s\n","Node="$1,"type=ssd100delack value="$13" "ts);t++;}
}
