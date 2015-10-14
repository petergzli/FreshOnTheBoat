from flask_restful import Resource, reqparse
from flask import g
from freshontheboat.models.users import User
from freshontheboat import db

class RegisterNewUsers(Resource):

    def __init__(self):
        self.reqparse = reqparse.RequestParser()
        self.reqparse.add_argument('id', type = str , default="")
        self.reqparse.add_argument('username', type = str , default="")
        self.reqparse.add_argument('firstname', type = str,  default="")    
        self.reqparse.add_argument('lastname', type = str,  default="")
        self.reqparse.add_argument('email', type = str,  default="")
        self.reqparse.add_argument('encrypted_password', type = str,  default="")
        self.reqparse.add_argument('bio', type = str,  default="")
        self.reqparse.add_argument('profile_photo', type = str,  default="")
        self.reqparse.add_argument('main_city', type = str,  default="")
        self.reqparse.add_argument('latitude', type = str,  default="")
        self.reqparse.add_argument('longitude', type = str,  default="")
        self.reqparse.add_argument('user_flagged', type = str,  default="")
        self.reqparse.add_argument('device_id', type = str,  default="")
        super(RegisterNewUsers, self).__init__()

    def post(self):
        args = self.reqparse.parse_args()
        password = args['encrypted_password']
        username = args['username']
        email = args['email']

        if username is None or password is None or email is None:
            return {'status': 'entryError', 'message': 'Username and password combination incorrect'}

        if User.query.filter_by(username = username).first() is not None:
            return {'status': 'usernameTaken', 'message': 'Username is taken'}

        if User.query.filter_by(email = email).first() is not None:
            return {'stats': 'emailTaken', 'message': 'Email has been registered'}

        user = User(username = username, firstname = args['firstname'], lastname = args['lastname'], email = email)
        user.hash_password(password)
        
        db.session.add(user)
        db.session.commit()
        g.user = user
        token = g.user.generate_auth_token()
        user.authentication_token = token.decode('ascii') 
        db.session.commit()
        
        message = {'status': 'successful', 'user': [{
        'userid'   : user.id,
        'username' : user.username,
        'authentication_token' : user.authentication_token
        }]}
        return message

