#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/newpost/'
username = "callmemaybe"
password = "baby"
parameters = {'description': 'This is a test post', 'title': 'Where is the best chinese food on the west side?', 'latitude': 34.068699, 'longitude': -118.445557, 'location': 'UCLA', 'image_url' : '910290193102912039abcdes.jpg'}
HTTPresponse = requests.post(url, data = parameters, auth=(username,password))
print HTTPresponse.json()
