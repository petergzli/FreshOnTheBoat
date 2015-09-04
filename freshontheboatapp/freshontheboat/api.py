from freshontheboat import app
from flask_restful import Api

from freshontheboat.resources.root import Foo
from freshontheboat.resources.registerNewUsers import RegisterNewUsers
from freshontheboat.resources.loginUsers import Login 

api = Api(app)

#Routes
api.add_resource(RegisterNewUsers, '/users/new/')
api.add_resource(Foo, '/')
api.add_resource(Login, '/users/login/')
