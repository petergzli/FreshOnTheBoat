#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/comments/newpost/'
username = "callmemaybe"
password = "baby"
parameters = {'body': 'This is a test post','forum_id': 2, 'image_url' : '910290193102912039abcdes.jpg'}
HTTPresponse = requests.post(url, data = parameters, auth=(username,password))
print HTTPresponse.json()
