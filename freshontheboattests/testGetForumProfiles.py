#The Following Script is a sample POST tester, to see if your entry was authorized.
import requests

url = 'http://www.underbored.com/forum/getresults/'
parameters = {'latitude': 34.068699, 'longitude': -118.445557, 'user_id': 1, 'category': 0}
HTTPresponse = requests.get(url, params  = parameters) 
print HTTPresponse.json()
