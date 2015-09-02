from flask import Flask, g
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root@localhost/FreshOnTheBoat'
app.config['SECRET_KEY'] = 'super-secret'
app.config['SQLALCHEMY_POOL_RECYCLE'] = 299
app.config['SQLALCHEMY_POOL_TIMEOUT'] = 20

import freshontheboat.api
