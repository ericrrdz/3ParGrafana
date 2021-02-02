mv statcmp* statcmp.out
mv statcpu* statcpu.out
mv statiscsi-fullcounts* statiscsi-fullcounts.out
mv statiscsisession* statiscsisession.out
mv statpd* statpd.out
mv statld* statld.out
mv statport-disk* statport-disk.out
mv statport-host* statport-host.out
mv statvlun* statvlun.out
mv statvv* statvv.out
mv statport-rcfc* statport-rcfc.out
mv statport-rcip* statport-rcip.out
mv statqos* statqos.out
mv statcache* statcache.out
mv statrcopyhb* statrcopyhb.out
mv statrcvv* statrcvv.out
mv statqos* statqos.out
du -hd 0
ls -lah
awk '$6!=0&&$7!=0&&$8!=0{print}' statvlun.out > statvlun.out2 
awk '$3!=0&&$4!=0&&$5!=0{print}' statvv.out > statvv.out2 
awk '$6!=0&&$7!=0&&$8!=0{print}' statpd.out > statpd.out2 
awk '$4!=0&&$5!=0&&$6!=0{print}' statport-disk.out > statport-disk.out2
awk '$4!=0&&$5!=0&&$6!=0{print}' statport-host.out > statport-host.out2 
awk '$4>0{print}' statiscsisession.out > statiscsisession.out2
awk '$3!=0.0&&$4!=0.0&&$5!=0.0{print}' statiscsi-fullcounts.out > statiscsi-fullcounts.out2
awk '$7>0{print}' statrcvv.out > statrcvv.out2
awk '$5>0{print}' statqos.out > statqos.out2
ls -lh
mv statvlun.out2 statvlun.out
mv statvv.out2 statvv.out
mv statpd.out2 statpd.out
mv statport-disk.out2 statport-disk.out
mv statport-host.out2 statport-host.out
mv statiscsi-fullcounts.out2 statiscsi-fullcounts.out
mv statiscsisession.out2 statiscsisession.out
mv statrcvv.out2 statrcvv.out
mv statqos.out2 statqos.out
/home/daddy/bin/rmz
du -hd 0
