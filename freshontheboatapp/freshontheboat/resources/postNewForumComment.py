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
    self.reqparse.add_argument('comment_flagged', type = int, default = 0)
    super(PostNewForumComment, self).__init__()

  def post(self):
    args = self.reqparse.parse_args()
    currentDateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
    newentry = ForumPostComments(forum_id = args['forum_id'], poster_id = g.user.id, body  = args['body'], created_at  = currentDateTime, image_url = args['image_url'])
    db.session.add(newentry)
    db.session.commit()
    message = {'status': 'successful'}
    return message

