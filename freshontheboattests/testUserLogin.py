#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/users/login/'
username = "callmemaybe"
password = "baby"
HTTPresponse = requests.post(url, auth=(username,password)) 
print HTTPresponse.json()
