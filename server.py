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

        print("This is the json " + str(json))
        if 'username' in json and 'email' in json and 'password' in json:
            user = user_collection.find_one({'email': json['email']})
            if user is not None:
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

        # Document from MongoDatabase
        user_email = request.args.get('email')
        # Getting username from JSON passed from client
        user_json_email = request.json.get('username')
        # JSON format
        # 
        # user_username = request.json.get('username')
        # email = request.json.get('email')
        find_user_email = user_collection.find_one({'email': user_email})
        if find_user_email is None:
            return(None, 404, None)
        elif find_user_email is not None:
            find_user_email['username'] = user_json_email
            user_collection.save(find_user_email)
            return(find_user_email, 200, None)

    def delete(self):
        user_collection = app.db.users
        trips_collection = app.db.trips
        user_email = request.args.get("email")
        user_trip_email = request.args.get("email")
        find_user_email = user_collection.find_one({'email': user_email})
        find_trip_email = trips_collection.find_one({'email' : user_trip_email})
        print("email is " + str(find_user_email))
        if find_user_email is None and find_trip_email is None:
            return(None, 404, None)
        elif find_user_email is not None and find_trip_email is not None:
            user_collection.remove(find_user_email)
            trips_collection.remove(find_trip_email)
            return(find_user_email, 204, None)


class Trip(Resource):

    def get(self):
        """Get a trip. Either one or all trips"""
        # Get all trips if not argument is passed
        trips_collection = app.db.trips
        trip_request = request.args.get('email')
        # Return on trip if looking for a specific trip
        # if 'destination' in trip_request:
        #     trip_destination = trip_request.get('destination')
        #     trip = trips_collection.find({'destination': trip_destination})
        email = trips_collection.find_one({'email': trip_request})

        if email is None:
            return({'error': 'Invalid email'}, 404, None)
        else:
            return(email, 200, None)

    def post(self):
        # Route to collection
        trips_collection = app.db.trips
        # Gets the json sent
        trip_request = request.json

        if 'destination' not in trip_request:
            return ({'error': 'empty required fields'}, 400, None)
        else:
            trips_collection.insert_one(trip_request)
            # Return json to see what JSON was pushed
            return (trip_request, 201, None)

    def put(self):
        trips_collection = app.db.trips
        user_email = request.args.get("email")

        if 'destination' in args:
            trip_destination = args.get('destination')

        trip = trips_collection.find_one({'email': user_email})
        print(user)

        if trip is not None:
            if 'email' in json:
                user['email'] = json['email']
                user[''] = json['']

            trips_collection.save(user)
            return (user, 200, None)
        return({'error': 'email not found'}, 404, None)

    def delete(self):
        trip_collection = app.db.trips
        trip_request = request.args.get('email')

        trip_email = trip_collection.find_one({'email': trip_request})
        if trip_email is None:
            return(None, 404, None)
        else:
            trips_collection.remove(trip_email)

                
# Add api routes here
api.add_resource(User, '/users')
api.add_resource(Trip, '/trips')


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
