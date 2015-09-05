from datetime import datetime
from flask import g
from flask_restful import Resource, reqparse
from freshontheboat import app, db
from freshontheboat.authentication import auth
from freshontheboat.models.forumposts import Forumposts 

class PostNewForumProfile(Resource):
  decorators = [auth.login_required]

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('description', type = str, default="")
    self.reqparse.add_argument('title', type = str,  default="")
    self.reqparse.add_argument('latitude', type = float,  default="")
    self.reqparse.add_argument('longitude', type = float,  default="")
    self.reqparse.add_argument('location', type = str, default="")
    self.reqparse.add_argument('image_url', type = str, default = "")
    self.reqparse.add_argument('forum_post_flagged', type = int, default = 0)
    super(PostNewForumProfile, self).__init__()

  def post(self):
    args = self.reqparse.parse_args()
    currentDateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
    newentry = Forumposts(title = args['title'], created_by = g.user.id, description = args['description'], latitude = args['latitude'], longitude = args['longitude'], created_at  = currentDateTime, location = args['location'], image_url = args['image_url'])
    db.session.add(newentry)
    db.session.commit()
    message = {'status': 'successful'} 
    return message
