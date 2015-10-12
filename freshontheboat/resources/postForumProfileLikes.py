from datetime import datetime
from flask import g
from flask_restful import Resource, reqparse
from freshontheboat import app, db
from freshontheboat.authentication import auth
from freshontheboat.models.forumpostlikes import ForumPostLikes 
from freshontheboat.models.forumposts import Forumposts

class PostNewForumLikes(Resource):
  decorators = [auth.login_required]

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_profile_id', type = int, required=True)
    self.reqparse.add_argument('comment_flagged', type = int, default = 0)
    self.reqparse.add_argument('likes', type = int, default = 0)
    self.reqparse.add_argument('dislikes', type = int, default = 0)
    super(PostNewForumLikes, self).__init__()

  def post(self):
    args = self.reqparse.parse_args()
    results = ForumPostLikes.query.filter(ForumPostLikes.user_who_liked == g.user.id, ForumPostLikes.forum_profile_id == args['forum_profile_id']).first()
    if results > 0:
        if results.likes > 0 and args['likes'] != 0:
            return {'status': 'AlreadyLiked'}
        if results.dislikes < 0 and args['dislikes'] != 0:
            return {'status': 'AlreadyDisliked'}
        updatePost = Forumposts.query.get(args['forum_profile_id'])
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
        newentry = ForumPostLikes(forum_profile_id = args['forum_profile_id'], user_who_liked = g.user.id, likes = args['likes'], dislikes = args['dislikes'])
        db.session.add(newentry)
        updatePost = Forumposts.query.get(args['forum_profile_id'])
        if args['likes'] != 0:
            updatePost.userHasLiked()        
        if args['dislikes'] != 0:
            updatePost.userHasDisliked()
        db.session.commit()
        message = {'status': 'successful'}
        return message
