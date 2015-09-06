from datetime import datetime
from flask import g
from sqlalchemy import desc
from flask_restful import Resource, reqparse
from freshontheboat.models.forumpostcomments import ForumPostComments
from freshontheboat.models.users import User 

class GetForumComments(Resource):

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_id', type = int,  default="")
    super(GetForumComments, self).__init__()

  def get(self):
    args = self.reqparse.parse_args()
    results = ForumPostComments.query.filter_by(forum_id = args['forum_id']).order_by(desc(ForumPostComments.id)).all()

    json_results = []
    for result in results:
        username = User.query.get(result.poster_id).username
        resultDictionary = {'id': result.id, 'image_url': result.image_url, 'poster_id': username, 'body': result.body, 'created_at': str(result.created_at)}
        json_results.append(resultDictionary)

    response = {'status': 'successful', 'results' : json_results}
    return response
