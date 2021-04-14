from flask import jsonify, make_response
import sys
sys.path.append("..")
from app import mysql

class SessionModel:
    def __init__(self,username):
        self.username = username
        
    def json(self):
        return {"username" : self.username}

    @classmethod
    def find_by_username(cls,username,password):
        print('in modal to find user',username, 'and',password)
        cursor = mysql.connection.cursor()
        sql = "SELECT username FROM user WHERE username = %s AND password =%s"
        cursor.execute(sql,(username,password))
        data = cursor.fetchone()
        cursor.close()    
        mysql.connection.commit()
        print("Signin Ends")
        return True if data else False        

    @classmethod
    def save_to_db(cls,data):
        print('running save to db')
        
        cursor = mysql.connection.cursor()
        sql = "SELECT username FROM user WHERE username = %s"
        cursor.execute(sql,(data['username'],))
        dataExist = cursor.fetchone()

        if dataExist:
            return 0
        else:
            sqlInsert= 'INSERT INTO `user` (`id`, `username`, `password`, `phone`, `created_at`, `updated_at`, `longitude`, `latitude`, `address`) VALUES (NULL,%s,%s,%s,CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,%s,%s,%s)'
            insertData = (data['username'],data['password'],data['phone'],data['longitude'],data['latitude'],data['address'])
            affectedRow = cursor.execute( sqlInsert , insertData )
            cursor.close()    
            mysql.connection.commit()
            print("end save")
            print("returining user model object")
            return 1
        

    @classmethod
    def get_user_info(cls,data):
        cursor = mysql.connection.cursor()
        # sql = "SELECT username, phone, DATE_FORMAT(created_at, '%%M %%D %%Y %%T'), latitude, longitude,address FROM user WHERE username = %s " # Mohib
        sql = "SELECT username, phone, created_at, latitude, longitude,address FROM user WHERE username = %s "
        cursor.execute(sql,(data["username"],))
        data = cursor.fetchone()
        cursor.close()    
        mysql.connection.commit()
        print("Signin Ends")
        if data:
            # return {"username": data[0],"phone": data[1],"joining_date": data[2],"latitude": data[3],"longitude": data[4],"address": data[5]}  # Mohib
            return {"username": data[0],"phone": data[1],"joining_date": str(data[2]),"latitude": data[3],"longitude": data[4],"address": data[5]} 
        else:
            return {"msg": "Usr Not found"}     