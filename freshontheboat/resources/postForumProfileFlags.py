from flask import g
from flask_restful import Resource, reqparse
from freshontheboat import app, db
from freshontheboat.authentication import auth
from freshontheboat.models.forumpostflagged import ForumPostFlagged 

class PostForumProfileFlags(Resource):
  decorators = [auth.login_required]

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_profile_flagged_id', type = int, required=True)
    super(PostForumProfileFlags, self).__init__()

  def post(self):
    args = self.reqparse.parse_args()
    results = ForumPostFlagged.query.filter_by(user_who_flagged = g.user.id).first()
    if results > 0:
        return {'status': 'AlreadyFlagged'}
    else:
        newentry = ForumPostFlagged(forum_profile_flagged_id = args['forum_profile_flagged_id'], user_who_flagged = g.user.id)
        db.session.add(newentry)
        db.session.commit()
        message = {'status': 'successful'}
        return message
