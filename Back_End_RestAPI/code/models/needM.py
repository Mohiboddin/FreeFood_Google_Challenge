from flask import jsonify, make_response
import sys
sys.path.append("..")
from app import mysql

class NeedModel:
    def __init__(self,_id,username,phone,address,latitude,longitude,created_at,plates,food_type):
        self.username = username
        self.id = _id
        self.food_type = food_type
        self.plates = plates
        self.created_at = created_at
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.phone = phone
        

    
    def json(self):
        return {"id": self.id, "username" : self.username,"food_type":self.food_type, "plates" : self.plates, 
        "created_at" : str(self.created_at), "longitude" : self.longitude, "latitude" : self.latitude, 
         "address" : self.address,"phone":self.phone}

    @classmethod
    def get_posts(cls,location_data):
        longitudeU = float(location_data['longitude']) + 1
        longitudeL = float(location_data['longitude']) - 1
        latitudeU = float(location_data['latitude']) + 1
        latitudeL = float(location_data['latitude']) - 1

        cursor = mysql.connection.cursor()
      #  sql = "Select post.id,post.taker ,post.no_of_people, post.food_type, DATE_FORMAT(post.created_at, '%%M %%D %%Y %%T'), user.phone, post.latitude, post.longitude, post.fixed_position, post.address from post INNER JOIN user ON post.taker=user.username WHERE post.created_at > DATE_SUB(now(),interval 1 day) AND (post.latitude BETWEEN %s AND %s ) AND (post.longitude BETWEEN %s AND %s) AND taker_accepted=0 order by post.created_at" #mohib
        sql = "Select post.id,post.taker ,post.no_of_people, post.food_type, post.created_at, user.phone, post.latitude, post.longitude, post.fixed_position, post.address from post INNER JOIN user ON post.taker=user.username WHERE post.created_at > DATE_SUB(now(),interval 1 day) AND (post.latitude BETWEEN %s AND %s ) AND (post.longitude BETWEEN %s AND %s) AND taker_accepted=0 order by post.created_at" #israr
        cursor.execute(sql,(latitudeL, latitudeU,longitudeL,longitudeU))
        # row_headers=[x[0] for x in cursor.description]
        posts = cursor.fetchall()   
        payload = []
        content = {}
        print(len(posts))
        for result in posts:
            # content = {"id": result[0], "username" : result[1],"food_type":result[2], "plates" : result[3],"created_at" : result[4], "longitude" : result[5], "latitude" : result[6],"address" : result[7],"phone":result[8]} # Mohib
            content = {"id": result[0], "username" : result[1],"plates":result[2], "food_type" : result[3],"created_at" : str(result[4]), "phone" : result[5], "latitude" : result[6],"longitude" : result[7],"fixed_position":result[8],"address" : result[9]}
           
            payload.append(content)
            content = {}
        print(payload)
        return payload

    @classmethod
    def save_to_db(cls,data):
        print('running save to db')
        
        cursor = mysql.connection.cursor()
        sqlInsert= 'INSERT INTO `post` (`taker`, `food_type`, `no_of_people`, `longitude`, `latitude`, `address`, `fixed_position`) VALUES ( %s,%s, %s, %s,%s,%s, %s);'
        insertData = (data['username'],data['food_type'],data['no_of_people'],data['longitude'],data['latitude'],data['address'], data['fixed_position'])
        affectedRow = cursor.execute( sqlInsert , insertData )
        cursor.close()    
        mysql.connection.commit()
        print("end save")
        print("returining user model object")
        if affectedRow:
            return 1
        else:
            return 0

