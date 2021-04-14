import sys
sys.path.append("..")
from app import mysql

class PeopleModel:

    def __init__(self, name):
        self.name = name

    def json(self):
        return {'name': self.name}

    def save_to_db(self):
        cursor = mysql.connection.cursor()
        sql = "INSERT INTO people (username, password) VALUES (%s, %s)"
        cursor.execute(sql, (self.name, self.name))
        cursor.close()
        mysql.connection.commit()