mkdir perf_`date +%Y%m%d`
cat Perf.*/statvlun*.out > perf_`date +%Y%m%d`/statvlun.out
cat Perf.*/statport-host*.out > perf_`date +%Y%m%d`/statport-host.out
cat Perf.*/statcache*.out > perf_`date +%Y%m%d`/statcache.out
cat Perf.*/statport-disk*.out > perf_`date +%Y%m%d`/statport-disk.out
cat Perf.*/statrcvv*.out > perf_`date +%Y%m%d`/statrcvv.out
cat Perf.*/statcpu*.out > perf_`date +%Y%m%d`/statcpu.out
cat Perf.*/statrcopyhb*.out > perf_`date +%Y%m%d`/statrcopyhb.out
cat Perf.*/statpd*.out > perf_`date +%Y%m%d`/statpd.out
cat Perf.*/statld*.out > perf_`date +%Y%m%d`/statld.out
cat Perf.*/statvv*.out > perf_`date +%Y%m%d`/statvv.out
cat Perf.*/statcmp*.out > perf_`date +%Y%m%d`/statcmp.out
cat Perf.*/statport-rcfc*.out > perf_`date +%Y%m%d`/statport-rcfc.out
cat Perf.*/statiscsi-fullcounts*.out > perf_`date +%Y%m%d`/statiscsi-fullcounts.out
cat Perf.*/statiscsisession*.out > perf_`date +%Y%m%d`/statiscsisession.out
cat Perf.*/statld*.out > perf_`date +%Y%m%d`/statld.out
cat Perf.*/statqos*.out > perf_`date +%Y%m%d`/statqos.out
