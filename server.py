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

# Authentication decorator
def authenticated_request(func):
    # Set unlimited arguments to return back
    def wrapper(*args, **kwargs):
        auth = request.authorization
        # Gets the headers in the Authorization JSONd
        auth_code = request.headers['authorization']
        email, password = decode(auth_code)
        if email is not None and password is not None:
            user_collection = database.users
            found_user = user_collection.find_one({"email" : email})
            if found_user is not None:
                encoded_password = password.encode("utf-8")
                if bcrypt.checkpw(encoded_password, found_user["password"]):
                    return func(*args, **kwargs)
                else:
                    return ({'error' : 'email or password is not correct'}, 401, None)
            else:
                return ({'error' : 'email or password is not correct'}, 401, None)
        else return ({'error' : 'could not find user in the database'})
    return wrapper

## Write Resources here
class User(Resource):

    def post(self):

        # Get route to database
        user_collection = app.db.users
        # JSON to post
        json = request.json
        #Getting password from client
        password = json.get('password')
        print(password)

        # Encrypting password by using a hash function and salt
        encoded_password = password.encode('utf-8')
        hashed = bcrypt.hashpw(
                encoded_password, bcrypt.gensalt(app.bcrypt_rounds)
                )
        json['password'] = hashed

        print("This is the json " + str(json))
        if 'username' in json and 'email' in json and 'password' in json:

            user = user_collection.find_one({'email': json['email']})
            if user is not None:
                # User exists
                return({'error': 'User already exists'}, 409, None)
            user_collection.insert_one(json)
            json.pop('password')
            return (json, 201, None)
        else:
            return(None, 404, None) 

    @authenticated_request
    def get(self):
        # Get route to database
        user_collection = app.db.users
        auth = request.authorization
        user_find = user_collection.find_one({"email": auth.username})
        # print("The current password is " + user_password)
        encoded_password = user_password.encode('utf-8')

        if auth.username is not None and auth.password is not None:
            user_find.pop('password')
            return(user_find,200, None)
        else:
            return(None, 401, None)


        # if bcrypt.checkpw(encoded_password, user_find['password']):
        #     user_find.pop('password')
        #     return(user_find, 200, None)
        # else:
        #     return(None, 401, None)

    @authenticated_request
    def put(self):
        # Update one single node
        user_collection = app.db.users
        auth = request.authorization
        # Document from MongoDatabase
        user_email = request.args.get('email')
        # Getting username from JSON passed from client
        user_json_username = request.json.get('username')
        # JSON format
        # 
        # user_username = request.json.get('username')
        # email = request.json.get('email')
        find_user_email = user_collection.find_one({'email': auth.email})
        if find_user_email is None:
            return(None, 404, None)
        elif find_user_email is not None:
            find_user_email['username'] = user_json_username
            user_collection.save(find_user_email)
            return(find_user_email, 200, None)

    @authenticated_request
    def delete(self):
        user_collection = app.db.users
        trips_collection = app.db.trips
        find_user_email = user_collection.find_one({'username': auth.username})
        find_trip_email = trips_collection.find_one({'username' : auth.username})
        print("email is " + str(find_user_email))
        if find_user_email is None and find_trip_email is None:
            return(None, 404, None)
        elif find_user_email is not None and find_trip_email is not None:
            find_user_email.pop('password')
            user_collection.remove(find_user_email)
            trips_collection.remove(find_trip_email)
            return(find_user_email, 204, None)


class Trip(Resource):

    @authenticated_request
    def get(self):
        """Get a trip. Either one or all trips"""
        # Get all trips if not argument is passed
        users_collection = app.db.users
        trips_collection = app.db.trips
        # trip_request = request.args.get('email')
        auth = request.authorization
        # Return on trip if looking for a specific trip
        # if 'destination' in trip_request:
        #     trip_destination = trip_request.get('destination')
        #     trip = trips_collection.find({'destination': trip_destination})
        found_username_users = user_collection.find_one('username' : auth.username)
        found_username_trips = trips_collection.find_one({'username': auth.username})
        encoded_password = auth.password.encode('utf-8')

        # if email is None:
        #     return({'error': 'Invalid email'}, 404, None)
        # else:
        #     return(email, 200, None)

        if bcrypt.checkpw(encoded_password, found_username_user['password']):
            return (found_username_trip, 200, None)
        else:
            return (None, 401, None)

    @authenticated_request
    def post(self):
        # Route to collection
        trips_collection = app.db.trip
        users_collection = app.db.users

        # Gets the json sent
        trip_request = request.json
        # Get authorization header
        auth = request.authorization

        encoded_password = auth.password.encode('utf-8')
        found_username_user = users_collection.find_one({'username': auth.username})

        if bcrypt.checkpw(encoded_password, found_username_user['password']):
            trips_collection.insert_one(trip_request)
            return (trip_request, 201, None)
        else:
            return (None, 404, None)


        # if 'destination' not in trip_request:
        #     return ({'error': 'empty required fields'}, 400, None)
        # else:
        #     trips_collection.insert_one(trip_request)
        #     # Return json to see what JSON was pushed
        #     return (trip_request, 201, None)

    @authenticated_request
    def put(self):
        trips_collection = app.db.trips
        users_collection = app.db.users

        user_email = request.args.get("email")
        auth = request.authorization

        # if 'destination' in args:
        #     trip_destination = args.get('destination')

        trip = trips_collection.find_one({'username': auth.username})
        found_username_user = users_collection.find_one({'username', auth.username})
        encoded_password = auth.password.encode('utf-8')
        print(trip)
        # print(user)

        update_destination = request.json['destination']
        update_start_date = request.json['start_date']
        update_end_date = request.json['end_date']
        update_completed = request.json['completed']
        update_waypoint_destination = request.json['waypoint']['waypoint_destination']
        update_lat = request.json['waypoint']['lat']
        update_long = request.json['waypoint']['long']

        if trip is not None and bcrypt.checkpw(encoded_password, found_username_user['password']):
            trip['destination'] = update_destination
            trip['start_date'] = update_start_date
            trip['end_date'] = update_end_date
            trip['completed']= update_completed
            print("THis is my way point destination " + update_waypoint_destination)
            trip['waypoint']['waypoint_destination'] = update_waypoint_destination
            trip['waypoint']['lat'] = update_lat
            trip['waypoint']['long'] = update_long
            trips_collection.save(trip)
            return (trip, 200, None)
        else:
            return(None, 404,None)

    def delete(self):
        trip_collection = app.db.trips
        users_collection = app.db.users
        auth = request.authorization
        encoded_password = auth.password.encode('utf-8')

        trip_username = trip_collection.find_one({'username': auth.username})
        found_username_user = users_collection.find_one({'username' : auth.username})
        if trip_email is not None and bcrypt.checkpw(encoded_password, found_username_user['password']):
            remove_trip = trips_collection.remove(trip_username)
            return(remove_trip, 204, None)
        else:
            return(None, 404, None)
                
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
