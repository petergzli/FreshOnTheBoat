from flask import make_response, jsonify, g
from flask.ext.httpauth import HTTPBasicAuth
from freshontheboat.models.users import User

auth = HTTPBasicAuth()

@auth.verify_password
def verify_password(username_or_token, password):
    # first try to authenticate by token
    user = User.verify_auth_token(username_or_token)
    if not user:
        # try to authenticate with username/password
        user = User.query.filter_by(username = username_or_token).first()
        if not user or not user.verify_password(password):
            return False
    g.user = user
    return True

@auth.error_handler
def unauthorized():
    return make_response(jsonify({'message': 'Unauthorized'}), 403)
