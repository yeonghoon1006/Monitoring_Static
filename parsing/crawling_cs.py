from bs4 import BeautifulSoup
import pymysql
import sys

db = pymysql.connect(host="localhost", port=3306, user="gr_db", passwd="qmfvld12", db="wireless", charset='utf8', init_command='SET NAMES UTF8')
#db = pymysql.connect(host="172.21.62.83", port=33061, user="traffic", passwd="traffic1", db="tool", charset='utf8', init_command='SET NAMES UTF8')
cur = db.cursor()
cur.execute("set character_set_connection=utf8;")
cur.execute("set character_set_server=utf8;")
cur.execute("set character_set_client=utf8;")
cur.execute("set character_set_results=utf8;")

sel_db = sys.argv[1]
file = sys.argv[2]
#sel_db = 'DG_UPF01_5M'
#file = "A20190404.1530+0900_20190404.1535+0900_DEGU_UPF01_01.xml"
fp = open(file)
soup = BeautifulSoup(fp,"html.parser")

for el in soup.findAll('fileheader'):
    datetime = el.meascollec['begintime'].replace("T", " ")
for el in soup.findAll('managedelement'):
    sys = el['localdn']
    db_name = sel_db

for el in soup.findAll('measinfo'):
    table = el['measinfoid']
    types = list()
    query = "CREATE TABLE IF NOT EXISTS `" + db_name + "`.`"+ table +"` (	"
    #query += "`NO` int(6) NOT NULL AUTO_INCREMENT,"
    query += "`DATETIME` DATETIME "
    query += ",`SYSTEM` VARCHAR(20) "
    add_field = el.find('measvalue')
    try:
        obj = add_field['measobjldn'].split(',')
        key = ''
        for fields in obj:
            field = fields.split('=')[0]
            query += ",`" + field + "` VARCHAR(50) "
            key += ",`" + field + "`"
    except :
        key = ''
    for meastypes in el.findAll('meastypes'):
        types.append(meastypes.string)
        # print(meastypes.string)
        if table == 'IPPoolStat' or table == 'EGTPCPeerStat':
            query += ",`" + meastypes.string + "` VARCHAR( 30 ) NOT NULL DEFAULT 0"
        else :
            query += ",`" + meastypes.string + "` FLOAT( 11 ) NOT NULL DEFAULT 0"
    if table == 'IPPoolStat':
        query += ", PRIMARY KEY  (`DATETIME`,`SYSTEM`" + key + ", `NAME`)) ENGINE = InnoDB ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 \n"
    else :
        query += ", PRIMARY KEY  (`DATETIME`,`SYSTEM`" + key + ")) ENGINE = InnoDB ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 \n"

    # query += ", KEY `NO` (`NO`)) ENGINE = Archive  ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 \n "
    query += " PARTITION BY RANGE (to_days(`DATETIME`)) "
    query += " (PARTITION p" + p + " VALUES LESS THAN (" + p + ") ENGINE = InnoDB  )"
    #print(query)
    cur.execute(query)
    #print(cur._last_executed)

    for measvalue in el.findAll('measvalue'):
        obj = measvalue['measobjldn'].split(',')
        add_query1 = ''
        add_query2 = ''
        for fields in obj:
            field = fields.split('=')[0]
            value = fields.split('=')[1]
            add_query1 += ","+field+""
            add_query2 += ",'"+value+"'"
        query = "INSERT INTO `" + db_name + "`.`"+ table +"` ("
        query += "`DATETIME`, `SYSTEM`"
        query += add_query1
        for field in types:
            in_field = "," + "`"+field+"`"
            query += in_field
        query += ") VALUES ("
        query += "'"+ datetime + "','"+sys+"'"
        query += add_query2
        for value in measvalue.findAll('r'):
            in_value = ",'" + value.string + "'"
            query += in_value
        query += ") "
        #print(query)
        cur.execute(query)
        #print(cur._last_executed)


db.commit()
db.close()

