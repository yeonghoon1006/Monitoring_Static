from bs4 import BeautifulSoup
import pymysql
import sys

db = pymysql.connect(host="localhost", port=3306, user="gr_db", passwd="qmfvld12", db="wireless", charset='utf8', init_command='SET NAMES UTF8')

cur = db.cursor()
cur.execute("set character_set_connection=utf8;")
cur.execute("set character_set_server=utf8;")
cur.execute("set character_set_client=utf8;")
cur.execute("set character_set_results=utf8;")

sel_db = sys.argv[1]
file = sys.argv[2]

fp = open(file)
soup = BeautifulSoup(fp,"html.parser")

query = "select to_days(NOW()) +7 - mod(to_days(NOW()),7);"
cur.execute(query)
rows = cur.fetchall()
for row in rows:
    p=str(row[0])

for el in soup.findAll('fileheader'):
    datetime = el.meascollec['begintime'].replace("T", " ").replace("+09:00", "")
for el in soup.findAll('managedelement'):
    system = el['localdn']
    db_name = sel_db

for el in soup.findAll('measinfo'):
    table = el['measinfoid']
    table = table.replace('/','|')
    query = "CREATE TABLE IF NOT EXISTS `" + db_name + "`.`"+ table +"` (       "
    query += "`DATETIME` DATETIME "
    query += ",`SYSTEM` VARCHAR(20) "
    query += ",`PORT` VARCHAR(50) "
    for meastypes in el.findAll('meastypes'):
        fields = meastypes.string
        fieldlist = fields.split(' ')
        for field in fieldlist :
            query += ",`" + field + "` FLOAT( 11 ) NOT NULL DEFAULT 0"
    query += ", PRIMARY KEY  (`DATETIME`,`SYSTEM`,`PORT`)) ENGINE = InnoDB ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 \n"
    query += " PARTITION BY RANGE (to_days(`DATETIME`)) "
    query += " (PARTITION p" + p + " VALUES LESS THAN (" + p + ") ENGINE = InnoDB  );"
    cur.execute(query)
    #print(query)

    for measvalue in el.findAll('measvalue'):
        port_value = measvalue['measobjldn']
        port_value = port_value.replace("H'", "H\\'")
        add_query = ''
        query = "INSERT INTO `" + db_name + "`.`"+ table +"` ("
        query += "`DATETIME`, `SYSTEM`, `PORT`"
        for field in fieldlist:
            in_field = "," + "`"+field+"`"
            query += in_field
        query += ") VALUES ("
        query += "'"+ datetime + "','"+ system +"','"+ port_value +"'"
        for value in measvalue.findAll('measresults'):
            in_values = value.string
            in_valueslist =in_values.split(' ')
            for in_value in in_valueslist :
                in_query = ",'" + in_value + "'"
                query += in_query
        query += ");"
        cur.execute(query)
        #print(query)
db.commit()
db.close()
