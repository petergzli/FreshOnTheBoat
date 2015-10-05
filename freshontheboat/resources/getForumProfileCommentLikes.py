from flask_restful import Resource, reqparse
from freshontheboat.models.users import User
from freshontheboat.models.forumpostcommentlikes import ForumPostCommentLikes 

class GetNewForumCommentLikes(Resource):
  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('forum_profile_posting_id', type = int, required=True)
    super(GetNewForumCommentLikes, self).__init__()

  def get(self):
    args = self.reqparse.parse_args()
    results = ForumPostCommentLikes.query.filter_by(forum_profile_posting_id= args['forum_profile_posting_id']).all()
    jsonDictionary = []
    for result in results:
        username = User.query.get(result.user_who_liked).username
        dictionaryResult = {'id' : result.id, 'user_who_liked': username,  'forum_profile_posting_id': result.forum_profile_posting_id, 'likes': result.likes, 'dislikes': result.dislikes}
        jsonDictionary.append(dictionaryResult)
    response = {'status': 'successful', 'results' : jsonDictionary}
    return response
