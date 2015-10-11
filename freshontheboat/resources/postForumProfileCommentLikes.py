from datetime import datetime
from flask import g
from flask_restful import Resource, reqparse
from freshontheboat import app, db
from freshontheboat.authentication import auth
from freshontheboat.models.forumpostcommentlikes import ForumPostCommentLikes 
from freshontheboat.models.forumpostcomments import ForumPostComments

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
    results = ForumPostCommentLikes.query.filter(ForumPostCommentLikes.user_who_liked == g.user.id, ForumPostCommentLikes.forum_profile_posting_id == args['forum_profile_posting_id']).first()
    if results > 0:
        if results.likes > 0 and args['likes'] != 0:
            return {'status': 'AlreadyLiked'}
        if results.dislikes < 0 and args['dislikes'] != 0:
            return {'status': 'AlreadyDisliked'}
        updatePost = ForumPostComments.query.get(args['forum_profile_posting_id'])
        if results.likes > 0 and args['dislikes'] != 0:
            results.dislikes = -1
            results.likes = 0
            updatePost.userHasDisliked()
            updatePost.userHasDisliked()
        if results.dislikes < 0 and args['likes'] != 0:
            results.likes = 1
            results.dislikes = 0
            updatePost.userHasLiked()
            updatePost.userHasLiked()
        db.session.commit()
        return {'status' : 'successful'}
    else:
        newentry = ForumPostCommentLikes(forum_profile_posting_id = args['forum_profile_posting_id'], user_who_liked = g.user.id, likes = args['likes'], dislikes = args['dislikes'])
        db.session.add(newentry)
        updatePost = ForumPostComments.query.get(args['forum_profile_posting_id'])
        if args['likes'] != 0:
            updatePost.userHasLiked()
        if args['dislikes'] != 0:
            updatePost.userHasDisliked()
        db.session.commit()
        message = {'status': 'successful'}
        return message
