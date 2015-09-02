#The Following Script is a sample POST tester, to see if your entry was successfully added to database.
import requests

url = 'http://127.0.0.1:5000/users/new/'
params = {"firstname": "Carly", "lastname": "Jepsen", "username": "callmemaybe", "encrypted_password": "baby"}
HTTPresponse = requests.post(url, data = params)
print HTTPresponse.json()
