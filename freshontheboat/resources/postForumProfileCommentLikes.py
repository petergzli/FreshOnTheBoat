from datetime import datetime
from flask import g
from flask_restful import Resource, reqparse
from freshontheboat import app, db
from freshontheboat.authentication import auth
from freshontheboat.models.forumpostcommentlikes import ForumPostCommentLikes 

class PostNewForumCommentLikes(Resource):
  decorators = [auth.login_required]

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_profile_posting_id', type = int, required=True)
    self.reqparse.add_argument('likes', type = int, default = 0)
    self.reqparse.add_argument('dislikes', type = int, default = 0)
    super(PostNewForumCommentLikes, self).__init__()

  def post(self):
    args = self.reqparse.parse_args()
    results = ForumPostCommentLikes.query.filter_by(user_who_liked = g.user.id).first()
    if results > 0:
        return {'status': 'AlreadyLiked'}
    else:
        newentry = ForumPostCommentLikes(forum_profile_posting_id = args['forum_profile_posting_id'], user_who_liked = g.user.id, likes = args['likes'], dislikes = args['dislikes'])
        db.session.add(newentry)
        db.session.commit()
        message = {'status': 'successful'}
        return message
