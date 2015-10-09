#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/likes/'
username = "callmemaybe"
password = "baby"
parameters = {'likes': 1,'forum_profile_id': 1}
HTTPresponse = requests.post(url, data = parameters, auth=(username,password))
print HTTPresponse.json()
