#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/getlikes/'
parameters = {'forum_profile_id': 2}
HTTPresponse = requests.get(url, params = parameters)
print HTTPresponse.json()
