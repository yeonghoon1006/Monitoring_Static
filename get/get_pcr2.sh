#!/bin/bash
sys='GURO_PCRF1'
db='GR_PCRF1'
sys2='PCRF1'
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
[root@localhost get_pcrf]# cat get_pcrf2.sh
#!/bin/bash
sys='GURO_PCRF2'
db='GR_PCRF2'
sys2='PCRF2'
day=`date +%Y%m%d -d '3 min ago'`
min=`echo "$(date +%M)%5" | bc`
HOST='172.21.161.155'
USER='aixml'
PASSWORD='Alsgml1200!!'


if [ $min -gt 1 ]
then
        dis1=`echo "$(date +%M)%5" | bc`
        dis2=`echo "$(date +%M)%5 + 5" | bc`
else
        dis1=`echo "$(date +%M)%5 + 5 " | bc`
        dis2=`echo "$(date +%M)%5 + 10" | bc`
fi

ld='/home/get_pcrf/'
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
python3 /home/parsing/crawling_pcrf.py $db /home/get_pcrf/$ff

rm -f /home/get_pcrf/$ff

python3 /home/maca/maca_lte.py $mdt $sys2
