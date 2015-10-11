#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/flag/'
username = "callmemaybe"
password = "baby"
parameters = {'forum_profile_flagged_id': 1}
HTTPresponse = requests.post(url, data = parameters, auth=(username,password))
print HTTPresponse.json()
