from flask import jsonify, make_response
import sys
sys.path.append("..")
from app import mysql

class RelationModel:
    def __init__(self,_id,username):
        self.username = username
        self.id = _id
        

    
    def json(self):
        return {"id": self.id, "username" : self.username}

    @classmethod
    def get_givings(cls,data): 
        print("in get giving")
        cursor = mysql.connection.cursor()
        # sql = "SELECT relation.`post_id` , relation.`taker` , relation.`food_type` ,relation.`plate` ,relation.`taker_accepted` ,relation.`latitude` ,relation.`longitude` ,DATE_FORMAT(relation.created_at, '%%M %%D %%Y %%T'),user.`phone` FROM relation ,user WHERE user.`username` = relation.`taker`and giver=%s and post_id not in (select post_id from relation where taker_accepted=1 AND giver!= %s)" # mohib
        sql = "SELECT relation.`post_id` , relation.`taker` , relation.`food_type` ,relation.`plate` ,relation.`taker_accepted` ,relation.`latitude` ,relation.`longitude` , relation.created_at, user.`phone` FROM relation ,user WHERE user.`username` = relation.`taker`and giver=%s and post_id not in (select post_id from relation where taker_accepted=1 AND giver!= %s)" # ISrar
       
        print("after query")
        cursor.execute(sql,(data['username'],data['username']))
        # row_headers=[x[0] for x in cursor.description]
        posts = cursor.fetchall() 
        cursor.close()    
        mysql.connection.commit()  
        print("data found")
        payload = []
        content = {}
        for result in posts:
            content = {"post_id": result[0], "taker" : result[1],"food_type":result[2], "plates" : result[3],"taker_accepted" : result[4], "latitude" : result[5], "longitude" : result[6],"created_at":str(result[7]),"phone":result[8]} # ISrar
            # content = {"post_id": result[0], "taker" : result[1],"food_type":result[2], "plates" : result[3],"taker_accepted" : result[4], "latitude" : result[5], "longitude" : result[6],"created_at":str(result[7]),"phone":result[8]} # Mohib
            payload.append(content)
            content = {}
        print(payload)
        return payload

    @classmethod
    def save_to_db(cls,data):
        print('running save to db')
        
        cursor = mysql.connection.cursor()
        notSameAsTaker= 'Select taker from post where taker= %s AND id =%s'
        notSameAsTakerData = (data['username'],data['post_id'])
        sameAsTakerFind = cursor.execute( notSameAsTaker , notSameAsTakerData )
        if sameAsTakerFind:
            return 0
        
        duplicateGiver= 'Select giver from relation where giver= %s AND post_id =%s'
        duplicateGiverData = (data['username'],data['post_id'])
        duplicateGiverFind = cursor.execute( duplicateGiver , duplicateGiverData )
        if duplicateGiverFind:
            return 0
        
        insertIntoRelation = "INSERT INTO relation (`post_id`, `taker`, `giver`, `food_type`, `plate`, `latitude`, `longitude`, `otp` ) SELECT id, taker, %s, food_type , no_of_people , latitude, longitude , (FLOOR(1000+RAND()*8999))FROM post WHERE post.id=%s"
        insertIntoRelationData = (data['username'], data['post_id'])
        affectedRow = cursor.execute( insertIntoRelation , insertIntoRelationData)
        cursor.close()    
        mysql.connection.commit()

        print("end save")
        print("returining user model object")
        if affectedRow:
            return 1
        else:
            return 0

    @classmethod
    def otpByGiver(cls,data): 
        print("in OTP by Giver")
        cursor = mysql.connection.cursor()
        sql = "SELECT 1 FROM relation WHERE otp=%s AND post_id=%s"
        print("after query")
        cursor.execute(sql,(data['otp'],data['post_id']))
        # row_headers=[x[0] for x in cursor.description]
        correctOTP = cursor.fetchall()
        print("data found")
        if correctOTP:
            sql = "UPDATE relation SET otp_given=1 WHERE post_id=%s"
            cursor.execute(sql,(data['post_id'],))
            sql = "DELETE from relation WHERE post_id=%s"
            cursor.execute(sql,(data['post_id'],))
            cursor.close()    
            mysql.connection.commit()
            return 1
        else:
            cursor.close()    
            mysql.connection.commit()
            return 0

    @classmethod
    def get_takings(cls,data): 
        print("in get taking")
        cursor = mysql.connection.cursor()
        # sql = "SELECT id,taker,food_type,no_of_people,DATE_FORMAT(created_at, '%%M %%D %%Y %%T'),longitude, latitude,address, fixed_position, taker_accepted from post where taker= %s"   # mohib
        sql = "SELECT id,taker,food_type,no_of_people,created_at,longitude, latitude,address, fixed_position, taker_accepted from post where taker= %s"   # israr
        print("after query")
        cursor.execute(sql,(data['username'],))
        # row_headers=[x[0] for x in cursor.description]
        posts = cursor.fetchall()   
        print("data found")
        payload = []
        content = {}
        for result in posts:
            # content = {"post_id": result[0], "taker" : result[1],"food_type":result[2], "no_of_people" : result[3],"created_at" : result[4],"longitude" : result[5], "latitude" : result[6], "address" : result[7],"fixed_position" : result[8],"taker_accepted" : result[9]} # Mohib
            content = {"post_id": result[0], "taker" : result[1],"food_type":result[2], "no_of_people" : result[3],"created_at" : str(result[4]),"longitude" : result[5], "latitude" : result[6], "address" : result[7],"fixed_position" : result[8],"taker_accepted" : result[9]}
            payload.append(content)
            content = {}
        print(payload)
        # adding the post which got the responces
        sql = "SELECT distinct post_id from relation where taker= %s"
        print("after query")
        cursor.execute(sql,(data['username'],))
        # row_headers=[x[0] for x in cursor.description]
        posts = cursor.fetchall()   
        print("data found for distinct post")
        payload2 = []
        for result in posts:
            payload2.append(result[0])
        print(payload2)

        cursor.close()    
        mysql.connection.commit()
        return {"your_takings": payload, "got_responses": payload2} # israr
        # return {"your_takings": payload, "got_responces": payload2} # Mohib
    
    @classmethod
    def get_givers_info_list(cls,data): 
        print("in get_givers_info_list")
        print(data)
        cursor = mysql.connection.cursor()
        # sql = "Select user.phone, user.username, user.latitude, user.longitude, user.address,DATE_FORMAT(relation.created_at, '%%M %%D %%Y %%T')  from relation JOIN user on relation.giver =user.username WHERE relation.post_id=%s and relation.taker= %s order by relation.created_at" # mohib
        sql = "Select user.phone, user.username, user.latitude, user.longitude, user.address,relation.created_at from relation JOIN user on relation.giver =user.username WHERE relation.post_id=%s and relation.taker= %s order by relation.created_at" # israr

        print("after query")
        cursor.execute(sql,(data['post_id'],data['username']))
        posts = cursor.fetchall() 
        cursor.close()    
        mysql.connection.commit()  
        print("data found")
        payload = []
        content = {}
        for result in posts:
            content = {"phone": result[0], "username" : result[1],"latitude":result[2], "longitude" : result[3],"address" : result[4], "created_at" : str(result[5])}
            payload.append(content)
            content = {}
        print(payload)
        return payload

    @classmethod
    def relationDelete(cls,data):
        print("in relation Delete")
        cursor=mysql.connection.cursor()
        deleteRelation = cursor.execute("DELETE from relation where post_id=%s and giver=%s",(data['post_id'],data['username']))
        taker_accepted_remains= cursor.execute("SELECT 1 from relation where post_id=%s and taker_accepted=1",(data['post_id'],))
        if taker_accepted_remains==0:
            update_posts= cursor.execute("UPDATE post SET taker_accepted=0 where id = %s",(data['post_id'],))

        cursor.close()    
        mysql.connection.commit()  
        return 1