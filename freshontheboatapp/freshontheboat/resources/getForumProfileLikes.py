from flask_restful import Resource, reqparse
from freshontheboat.models.users import User
from freshontheboat.models.forumpostlikes import ForumPostLikes

class GetNewForumLikes(Resource):
  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_profile_id', type = int, required=True)
    super(GetNewForumLikes, self).__init__()

  def get(self):
    args = self.reqparse.parse_args()
    results = ForumPostLikes.query.filter_by(forum_profile_id = args['forum_profile_id']).all()
    jsonDictionary = []
    for result in results:
        username = User.query.get(result.user_who_liked).username
        dictionaryResult = {'id' : result.id, 'user_who_liked': username,  'forum_profile_id': result.forum_profile_id, 'likes': result.likes, 'dislikes': result.dislikes}
        jsonDictionary.append(dictionaryResult)
    response = {'status': 'successful', 'results' : jsonDictionary}
    return response
