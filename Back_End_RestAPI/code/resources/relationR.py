from flask_restful import request, Resource
from models.relationM import RelationModel
import sys
sys.path.append("..")
from app import mysql


class RelationResource(Resource):
    
    def post(self):
        data = request.get_json()
        relation = RelationModel.save_to_db(data)
        if relation:
            return {'msg' : "added Successfully"
            } , 201
        else:
            return {'msg': 'You cannot give to this request'}, 404
    
    def get(self):
        # data = request.get_json() # mohib
        data = request.args.to_dict() # israr
        relationGiver = RelationModel.get_givings(data)
        if relationGiver:
            return relationGiver,200 # OK
        else:
            return {'messsage':'No more requests'}, 401 # user not found

    def delete(self):
        data = request.get_json()
        relationDelete = RelationModel.relationDelete(data)
        if relationDelete:
            return {"msg": "relation Deleted"},200 # OK
        else:
            return {'messsage':'cannot able to delete'}, 401 # user not found

class OtpResoure(Resource):
    
    def post(self):
        data = request.get_json()
        otpgiven = RelationModel.otpByGiver(data)
        if otpgiven:
            return {'msg' : "Work completed"
            } , 201
        else:
            return {'msg': 'incorrect OTP'}, 404
    

class TakingResource(Resource):
    
    def post(self):
        data = request.get_json()
        relationTaking = RelationModel.get_takings(data)
        if relationTaking:
            return relationTaking,200 # OK
        else:
            return {'messsage':'No more requests'}, 401 # user not found

    def get(self):
        data = request.args.to_dict() # ISrar
        # data = request.get_json() # mohib
        givers_info_list = RelationModel.get_givers_info_list(data)
        if givers_info_list:
            return givers_info_list,200 # OK
        else:
            return {'messsage':'No data found'}, 401 # user not found
    
    def put(self):
        data = request.get_json()
        print('printing data')
        print(data)
        cursor = mysql.connection.cursor()
        affectedRow = cursor.execute('UPDATE relation SET taker_accepted=1 where giver=%s and post_id=%s',(data["username"],data["post_id"]))
        affectedRowPost = cursor.execute('UPDATE post SET taker_accepted=1 where id=%s',(data["post_id"],))
        cursor.close()
        mysql.connection.commit()  
        print('affected rows')
        print(affectedRow)
        if affectedRow == 1:
            # return {'msg' : 'boolean ON'}  # Mohib
            return {'msg' : 'boolean ON'}, 200 # Israr
        else:
            # return {'msg' : 'cannot execute the request'} # Mohib
            return {'msg' : 'cannot execute the request'}, 404 # ISrar