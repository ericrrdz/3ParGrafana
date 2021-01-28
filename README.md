The following awk scripts will assist in parsing stats data collected from 3par array. <br>
<br>
Stats data can be captured from array using stats* commands and outputting to a file.<br>
<br>
cli% statcmp > statcmp.out<br>
<br>
awk scripts can be run against the out file.<br>
Syntax:<br>
statcmp_parse.awk statcmp.out > cmpinfo<br>
statpd_parse.awk statpd.out > pdinfo<br>
statport-disk_parse.awk statport-disk.out > diskportinfo<br>
statport-host_parse.awk statport-host.out > hostportinfo<br>
statvlun_parse.awk statvlun.out > vluninfo<br>
statvv_parse.awk statvv.out > vvinfo<br>
etc,etc<br>
<br>
The files outputted above can then be fed to influxdb using cURL:<br>
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @cmpinfo<br>
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @pdinfo<br>
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @diskportinfo<br>
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @hostportinfo<br>
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @vluninfo<br>
/usr/bin/curl -i -XPOST 'http://127.0.0.1:8086/write?db=test&precision=s' --data-binary @vvinfo<br>
<br>
Depending on size of out files, some influxdb settings (max-body-size, timeouts, max-series-per-database) in /etc/influxdb/influxdb.conf may have to be modified. <br>
<br>
The above can be automated using 3pg_new & 3pg_add scripts. 3pg_new will create new influx DB & 3pg_add will add to an existing influx DB. Both will prompt for name of DB upon running

<br>

