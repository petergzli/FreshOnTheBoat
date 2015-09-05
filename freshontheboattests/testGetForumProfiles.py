#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://127.0.0.1:5000/forum/getresults/'
parameters = {'latitude': 34.068699, 'longitude': -118.445557}
HTTPresponse = requests.get(url, params  = parameters) 
print HTTPresponse.json()
