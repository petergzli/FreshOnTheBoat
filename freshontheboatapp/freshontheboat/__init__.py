from flask import Flask, g
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgres://dcpaqcaqfgsknw:VL5J4ews_-CDvpZi06rEYImuXQ@ec2-54-197-241-24.compute-1.amazonaws.com:5432/df93a0pc1b0ioa'
app.config['SECRET_KEY'] = 'super-secret'
app.config['SQLALCHEMY_POOL_RECYCLE'] = 299
app.config['SQLALCHEMY_POOL_TIMEOUT'] = 20

import freshontheboat.api
