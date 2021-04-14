from flask_restful import request, Resource
from models.sessionM import SessionModel
import sys
sys.path.append("..")
from app import mysql


class SessionResource(Resource):
    
    def post(self):
        data = request.get_json()
        user = SessionModel.save_to_db(data)
        if user:
            return {'msg' : data["username"] + ' created'
            } , 201
        else:            
            return {'msg': 'User already exist'}, 409
            # return {'msg': 'User already exist'}, 404 # Mohib
    
    def get(self):
        data = request.args.to_dict()  # Israr , fetching query parameters
       # data = request.get_json()  # mohib
        user = SessionModel.find_by_username(data['username'], data['password'])
        if user:
            return {'msg': 'Successfully Loged in'},200 # OK
        else:
            return {'messsage':'Invalid Username Or password '}, 401 # user not found
    
class ProfileResource(Resource):
        
    def get(self):
        # data = request.get_json() #Mohib
        data = request.args.to_dict()
        user = SessionModel.get_user_info(data)
        if user:
            return user,200 # OK
        else:
            return {'messsage':'Invalid Username'}, 401 # user not found
    
