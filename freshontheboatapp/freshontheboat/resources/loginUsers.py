from flask_restful import Resource, reqparse
from flask import g
from freshontheboat.models.users import User
from freshontheboat.authentication import auth
from freshontheboat import db

class Login(Resource):
    decorators = [auth.login_required]

    def __init__(self):
        self.reqparse = reqparse.RequestParser()
        self.reqparse.add_argument('userid', type = str , default="")
        self.reqparse.add_argument('username', type = str,  default="")
        self.reqparse.add_argument('password', type = str,  default="")
        super(Login, self).__init__()

    def post(self):
        args = self.reqparse.parse_args()
        
        token = g.user.generate_auth_token()
        g.user.authentication_token = token.decode('ascii')
        db.session.commit()

        message = {'status': 'successful', 'user': [{
        'userid'   : g.user.id,
        'username' : g.user.username,
        'authentication_token' : g.user.authentication_token
        }]}
        return message
