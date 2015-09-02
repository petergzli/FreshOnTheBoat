from freshontheboat import app
from flask_restful import Api

from freshontheboat.resources.root import Foo
api = Api(app)

#Routes
api.add_resource(Foo, '/')
