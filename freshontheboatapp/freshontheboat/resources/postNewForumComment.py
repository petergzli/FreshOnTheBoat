from datetime import datetime
from flask import g
from flask_restful import Resource, reqparse
from freshontheboat import app, db
from freshontheboat.authentication import auth
from freshontheboat.models.forumpostcomments import ForumPostComments 

class PostNewForumComment(Resource):
  decorators = [auth.login_required]

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('body', type = str, default="")
    self.reqparse.add_argument('forum_id', type = str,  default="")
    self.reqparse.add_argument('image_url', type = str, default = "")
    self.reqparse.add_argument('replied_to_forum_id', type = int, default = "")
    self.reqparse.add_argument('location_pin_latitude', type = float, default = "")
    self.reqparse.add_argument('location_pin_longitude', type = float, default = "")
    self.reqparse.add_argument('comment_flagged', type = int, default = 0)
    super(PostNewForumComment, self).__init__()

  def post(self):
    args = self.reqparse.parse_args()
    currentDateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
    newentry = ForumPostComments(forum_id = args['forum_id'], poster_id = g.user.id, body  = args['body'], created_at  = currentDateTime, image_url = args['image_url'])
    if args['replied_to_forum_id'] != "": 
        newentry.replied_to_forum_id = args['replied_to_forum_id'] 
    if args['location_pin_latitude'] != "" and args['location_pin_longitude'] != "":
        newentry.location_pin_latitude = args['location_pin_latitude']
        newentry.location_pin_longitude = args['location_pin_longitude']
    db.session.add(newentry)
    db.session.commit()
    message = {'status': 'successful'}
    return message

