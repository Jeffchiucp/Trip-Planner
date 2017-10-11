from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
import bcrypt


app = Flask(__name__)
mongo = MongoClient('localhost', 27017)
app.db = mongo.trip_planner_development
app.bcrypt_rounds = 12
api = Api(app)


## Write Resources here
class User(Resource):

    def post(self):
        # Get route to database
        user_collection = app.db.users
        # JSON to post
        json = request.json

        if 'name' in json and 'email' in json and 'password' in json:
            myobject = user_collection.find_one({'email': json['email']})
            if user:
                # User exists
                return({'error': 'User already exists'}, 409, None)
            user_collection.insert_one(json)
            return (json, 201, None)
        else:
            return(None, 404, None)

    def get(self):
        # Get route to database
        user_collection = app.db.users
        user_email = request.args.get("email")

        # We will use emails as our unique identifiers
        user_find = user_collection.find_one({"email": user_email})

        if user_find is None:
            return(None, 404, None)
        elif user_find is not None:
            # Returning a document
            return(user_find, 200, None)

    def put(self):
        # Update one single node
        user_collection = app.db.users

        # Document from MongoClient
        user_email = request.args.get('email')
        # JSON format
        user_username = request.json.get('user_username')
        find_user_email = user_collection.find_one({'email': user_email})
        if find_user is None:
            return(None, 404, None)
        elif find_user is not None:
            find_user['username'] = user_username
            user_collection.save(find_user)
            return(find_user, 200, None)

    def delete(self):
        user_collection = app.db.users
        user_email = request.args.get("email")
        find_user_email = user_collection.find({'email': user_email})

        if find_user_email is None:
            return(None, 404, None)
        elif find_user_email is not None:
            user_collection.remove(find_user_email)
            return(find_user_email, 204, None)

    def patch(self):




## Add api routes here
api.add_resource(User, '/users','/myobject/<string:myobject_id>')

#  Custom JSON serializer for flask_restful
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp

if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
