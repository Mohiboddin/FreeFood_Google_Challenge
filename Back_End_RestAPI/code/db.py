import pymysql

conn = pymysql.connect(host='localhost',
                       user='root',
                       password='',
                       database='freefood',
                       charset='utf8mb4',
                       cursorclass=pymysql.cursors.DictCursor)
