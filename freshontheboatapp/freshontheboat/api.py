from freshontheboat import app
from flask_restful import Api

from freshontheboat.resources.root import Foo
from freshontheboat.resources.registerNewUsers import RegisterNewUsers

api = Api(app)

#Routes
api.add_resource(RegisterNewUsers, '/users/new/')
api.add_resource(Foo, '/')
