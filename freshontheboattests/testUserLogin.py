#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/users/login/'
username = "callmemaybe"
password = "baby"
#username = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0Mjc5ODMxNywiaWF0IjoxNDQyNzk3NzE3fQ.eyJpZCI6OH0.wiTeR-XKyNQagyz9npPfFkyFDBZreQpy9ed-dp7KcQE"
#password = "" 
HTTPresponse = requests.post(url, auth=(username,password)) 
print HTTPresponse.json()
