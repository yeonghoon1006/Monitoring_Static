#!/bin/bash
sys='GURO_A-MME2'
db='GR_MME2'
sys2='MME2'
day=`date +%Y%m%d -d '3 min ago'`
min=`echo "$(date +%M)%5" | bc`
HOST='***'
USER='***'
PASSWORD='***'


if [ $min -gt 1 ]
then
	dis1=`echo "$(date +%M)%5" | bc`
	dis2=`echo "$(date +%M)%5 + 5" | bc`
else
	dis1=`echo "$(date +%M)%5 + 5 " | bc`
	dis2=`echo "$(date +%M)%5 + 10" | bc`
fi

ld='/home/get/'
rd='/log/pm/ossraw/'$sys'/'$day

sf=`date +'%Y%m%d.%H%M' -d ''$dis2' min ago'`
tf=`date +'%H%M' -d ''$dis1' min ago'`
ff='B'$sf'-'$tf'_'$sys'.xml'
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
python3 /home/parsing/crawling_ss.py $db /home/get/$ff
rm -f /home/get/$ff

python3 /home/maca/maca_lte.py $mdt $sys2
