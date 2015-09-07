#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/comments/getlikes/'
parameters = {'forum_profile_posting_id': 1}
HTTPresponse = requests.get(url, params = parameters)
print HTTPresponse.json()
