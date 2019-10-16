The following awk scripts will assist in parsing stats data collected from 3par array. 

Stats data can be captured from array using stats* commands and outputting to a file.

cli% statcmp > statcmp.out

awk scripts can be run against the out file.
Syntax:
statcmp_parse.awk statcmp.out > cmpinfo
statpd_parse.awk statpd.out > pdinfo
statport-disk_parse.awk statport-disk.out > diskportinfo
statport-host_parse.awk statport-host.out > hostportinfo
statvlun_parse.awk statvlun.out > vluninfo
statvv_parse.awk statvv.out > vvinfo

The files outputted above can then be fed to influxdb using cURL:
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @cmpinfo
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @pdinfo
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @diskportinfo
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @hostportinfo
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @vluninfo
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @vvinfo

Depending on size of out files, some influxdb settings (max-body-size, timeouts, max-series-per-database) in /etc/influxdb/influxdb.conf may have to be modified. 



