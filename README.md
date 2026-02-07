The following bash scripts will assist in parsing performance data collected from HPE 3par/Primera/Alletra 9k/Alletra MP arrays. <br>
The scripts will also create corresponding influxdb and grafana data source. Edit script with detals for your environment.
<br>
influxdb, grafana, curl and gawk will need to be installed.
<br>
For perfanal data (Settings > Telemetry > Collect Support Data > Actions > Collect Performance Analysis
<br>
From directory where Perf.* directories reside, run 3pg_perfanal.sh
<br>
3pg_perfanal.sh -n for new influxdb instance
<br>
3pg_perfanal.sh -a to add to an existing influxdb instance.
<br>
Run from directory where Perf.* directories reside
<br>
e.g:
<br>
3pg_perfanal.sh -n .
<br>
For srdata, unpack srdata tarballs and run 3pg_sr.sh from hires directory.
<br>
3pg_sr.sh -n .
