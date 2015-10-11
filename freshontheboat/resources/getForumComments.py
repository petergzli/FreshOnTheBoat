from datetime import datetime
from flask import g
from sqlalchemy import desc
from flask_restful import Resource, reqparse
from freshontheboat.models.forumpostcomments import ForumPostComments
from freshontheboat.models.forumpostcommentlikes import ForumPostCommentLikes 
from freshontheboat.models.users import User 

class GetForumComments(Resource):

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_id', type = int,  default="")
    self.reqparse.add_argument('replied_to_forum_id', type = int, default = "")
    self.reqparse.add_argument('user_id', type = int)
    super(GetForumComments, self).__init__()

  def get(self):
    reply = False
    args = self.reqparse.parse_args()
    if args['forum_id'] != "" and args['replied_to_forum_id'] == "":
        results = ForumPostComments.query.filter_by(forum_id = args['forum_id']).order_by(desc(ForumPostComments.id)).all()
    else:
        results = ForumPostComments.query.filter_by(replied_to_forum_id = args['replied_to_forum_id']).order_by(desc(ForumPostComments.id)).all()
        reply = True
        
    json_results = []
    json_results_replies = []
    for result in results:
        username = User.query.get(result.poster_id).username
        resultDictionary = {'id': result.id, 'forum_id': result.forum_id, 'image_url': result.image_url, 'replied_to_forum_id': result.replied_to_forum_id, 'location_pin_latitude': result.location_pin_latitude, 'location_pin_longitude': result.location_pin_longitude, 'poster_id': result.poster_id, 'poster_username': username, 'body': result.body, 'created_at': str(result.created_at), 'total_likes': result.total_likes, 'user_has_liked': False, 'total_replies': ForumPostComments.query.filter(ForumPostComments.replied_to_forum_id==result.id).count()}
        if args['user_id'] != None:
            resultDictionary['user_has_liked'] = self.userHasLiked(args['user_id'], result.id)
        if result.replied_to_forum_id == None and not reply:
            json_results.append(resultDictionary)
        else:
            json_results_replies.append(resultDictionary)
    if not reply:
        response = {'status': 'successful', 'results' : json_results}
    else:
        response = {'status': 'successful', 'results' : json_results_replies}
    return response

  def userHasLiked(self, userId, forumId):
    likedStatus = ForumPostCommentLikes.query.filter(ForumPostCommentLikes.user_who_liked == userId, ForumPostCommentLikes.forum_profile_posting_id == forumId).first()
    if likedStatus == None:
        return False
    else:
        return True
