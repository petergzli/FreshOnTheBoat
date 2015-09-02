from freshontheboat import app, db
from itsdangerous import (TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired)
from passlib.apps import custom_app_context as pwd_context

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key = True)
    username = db.Column(db.String(32), index = True)
    firstname = db.Column(db.String(60))
    lastname = db.Column(db.String(60))
    email = db.Column(db.String(100))
    encrypted_password  = db.Column(db.String(128))
    reset_password_token = db.Column(db.String(100))
    authentication_token = db.Column(db.String(100))
    bio = db.Column(db.String)
    profile_photo = db.Column(db.String(100))
    main_city = db.Column(db.String(100))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    user_flagged = db.Column(db.Integer)
    device_id = db.Column(db.Integer)

    def generate_auth_token(self, expiration = 600):
        s = Serializer(app.config['SECRET_KEY'], expires_in = expiration)
        return s.dumps({ 'id': self.id })

    @staticmethod
    def verify_auth_token(token):
        s = Serializer(app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
        except SignatureExpired:
            return None # valid token, but expired
        except BadSignature:
            return None # invalid token
        user = User.query.get(data['id'])
        return user

    def hash_password(self, password):
        self.encrypted_password = pwd_context.encrypt(password)

    def verify_password(self, password):
        return pwd_context.verify(password, self.encrypted_password)
    
