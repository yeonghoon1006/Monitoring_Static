#!/bin/bash
sys='GURO_PGW18'
db='GR_PGW18'
sys2='PGW18'
day=`date +%Y%m%d -d '3 min ago'`
min=`echo "$(date +%M)%5" | bc`
HOST='172.21.24.244'
USER='kuroadmin1'
PASSWORD='WnRnal#8'


if [ $min -gt 1 ]
then
	dis1=`echo "$(date +%M)%5" | bc`
	dis2=`echo "$(date +%M)%5 + 5" | bc`
else
	dis1=`echo "$(date +%M)%5 + 5 " | bc`
	dis2=`echo "$(date +%M)%5 + 10" | bc`
fi

ld='/home/get_cisco/'
rd='/home/nmsftp/STATXML/5MIN/'$sys'/'$day

sf=`date +'%Y%m%d.%H%M' -d ''$dis2' min ago'`
tf=`date +'%Y%m%d.%H%M' -d ''$dis1' min ago'`
ff='A'$sf'+0900_'$tf'+0900_'$sys'.xml'
#ff='B20200327.1155-1200_GURO_vCSCF51.xml'
mdt=`date +'%Y-%m-%d %H:%M:00' -d ''$dis2' min ago'`

echo 'Target File name : '$ff

sshpass -p $PASSWORD sftp $USER@$HOST <<EOF

cd $rd
pwd

#!mkdir $ld
lcd $ld
!pwd

get $ff
bye
EOF

echo $ld$ff
python3 /home/parsing/crawling_cs.py $db /home/get_cisco/$ff
rm -f /home/get_cisco/$ff

python3 /home/maca/maca_lte.py $mdt $sys2
