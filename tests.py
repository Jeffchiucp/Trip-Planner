import server
import unittest
import json
import bcrypt
import base64
from pymongo import MongoClient


class TripPlannerTestCase(unittest.TestCase):
    def setUp(self):

      self.app = server.app.test_client()
      # Run app in testing mode to retrieve exceptions and stack traces
      server.app.config['TESTING'] = True

      mongo = MongoClient('localhost', 27017)
      global db

      # Reduce encryption workloads for tests
      server.app.bcrypt_rounds = 4

      db = mongo.trip_planner_test
      server.app.db = db

      db.drop_collection('users')
      db.drop_collection('trips')


    # User tests, fill with test methods
    def testCreateUser(self):
        self.app.post(
        '/users',
        data=json.dumps(dict(
        password='test'
        email="astudilloelmer@icloud.com"
        )), content_type='application/json'
        )

        response = self.app.get(
          '/users',
          query_string=dict(email="astudilloelmer@icloud.com")
          )

        response_json = json.loads(response.data.decode())

        self.assertEqual(response.status_code, 200)


    def testCreateUser(self):
       post_resp = self.app.post(‘/user’, headers=None,data=json.dumps(dict(name=“sky2”, email=“sky@gmail.com”)), content_type=“application/json”)
       response_id = json.loads(post_resp.data.decode())[‘_id’]
       pdb.set_trace()
       response = self.app.get(‘/user/user_id’, query_string=dict(user_id=“response_id”))
       # decode response
       response_json = json.loads(response.data.decode())
       self.assertEqual(response.status_code, 200)






if __name__ == '__main__':
    unittest.main()
