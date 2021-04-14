from flask_restful import Resource, request
from models.people import PeopleModel
from db import conn

import sys
sys.path.append("..")
from app import mysql


class People(Resource):

    def post(self, name):
        people = PeopleModel(name)
        print(name)
        try:
            people.save_to_db()
        except Exception as e:
            print(e)
            return {"message": "An error occurred creating the store."}, 500
        print(people.json())
        print('about to send the json')
        return people.json(), 201

