#!/bin/bash
sys='GURO_PCRF3'
db='GR_PCRF3'
sys2='PCRF3'
day=`date +%Y%m%d -d '3 min ago'`
min=`echo "$(date +%M)%5" | bc`
HOST='***'
USER='***'
PASSWORD='***''


if [ $min -gt 1 ]
then
        dis1=`echo "$(date +%M)%5" | bc`
        dis2=`echo "$(date +%M)%5 + 5" | bc`
else
        dis1=`echo "$(date +%M)%5 + 5 " | bc`
        dis2=`echo "$(date +%M)%5 + 10" | bc`
fi

ld='/home/get/'
rd='/home/argos/5MIN/'$sys'/'$day

sf=`date +'%Y%m%d.%H%M' -d ''$dis2' min ago'`
tf=`date +'%Y%m%d.%H%M' -d ''$dis1' min ago'`
ff='A'$sf'+0000_'$tf'+0000_'$sys'.xml'

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
python3 /home/parsing/crawling_pcrf.py $db /home/get/$ff

rm -f /home/get/$ff

python3 /home/maca/maca_lte.py $mdt $sys2
