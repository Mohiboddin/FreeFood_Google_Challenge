from flask_restful import request, Resource
from models.needM import NeedModel
import sys
sys.path.append("..")
from app import mysql


class NeedResource(Resource):
        
    def post(self):
        data = request.get_json()
        need = NeedModel.save_to_db(data)
        if need:
            return {'msg' : "Posted Successfully"
            } , 201
        else:
            return {'msg': 'Try again'}, 404
    
    def get(self):
        # data = request.get_json() # Mohib
        data = request.args.to_dict() # Israr
        print(data)
        need = NeedModel.get_posts(data)
        print('need')
    
        if need:
            return need, 200 # OK Mohib
            # return {"needs" : need},200 # OK ISrar
        else:
            return {'messsage':'No more requests'}, 401 # user not found
    
