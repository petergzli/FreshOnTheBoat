from freshontheboat import app
from flask_restful import Api

from freshontheboat.resources.root import Foo
from freshontheboat.resources.registerNewUsers import RegisterNewUsers
from freshontheboat.resources.loginUsers import Login 
from freshontheboat.resources.postNewForumProfile import PostNewForumProfile
from freshontheboat.resources.getForumProfiles import GetForumProfiles 

api = Api(app)

#Routes
api.add_resource(RegisterNewUsers, '/users/new/')
api.add_resource(Foo, '/')
api.add_resource(Login, '/users/login/')

api.add_resource(PostNewForumProfile, '/forum/newpost/')
api.add_resource(GetForumProfiles, '/forum/getresults/')
