from flask import Flask
from flask_restful import Api
from flask_mysqldb import MySQL


app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'freefood'

api = Api(app)
mysql = MySQL(app)



if __name__ == '__main__':
    from resources.people import People
    from resources.sessionR import SessionResource, ProfileResource
    from resources.needR import NeedResource
    from resources.relationR import RelationResource, OtpResoure, TakingResource


    api.add_resource(People, '/people/<string:name>')
    api.add_resource(SessionResource, '/session')
    api.add_resource(NeedResource, '/need')
    api.add_resource(RelationResource, '/relation')
    api.add_resource(OtpResoure, '/otp')
    api.add_resource(TakingResource, '/taking')
    api.add_resource(ProfileResource, '/profile')

    app.run(host='0.0.0.0',port=5000,debug=True) # Used to run it on the same netwrok to which mobile is connected
    # app.run(port=5000, debug=True)
