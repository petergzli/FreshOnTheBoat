#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/users/forumposts/'
parameters = {'user_id': 1}
HTTPresponse = requests.get(url, params  = parameters) 
print HTTPresponse.json()
