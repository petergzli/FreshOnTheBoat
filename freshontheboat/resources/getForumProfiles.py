from flask_restful import Resource, reqparse
from freshontheboat.models.forumposts import Forumposts
from freshontheboat.models.users import User
from freshontheboat.models.forumpostlikes import ForumPostLikes

class GetForumProfiles(Resource):

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('latitude', type = float,  default="")
    self.reqparse.add_argument('longitude', type = float,  default="")
    self.reqparse.add_argument('limit', type = int, default = 50)
    self.reqparse.add_argument('radius', type = float, default = 15.0)
    self.reqparse.add_argument('user_id', type = int)
    super(GetForumProfiles, self).__init__()

  def get(self):
    args = self.reqparse.parse_args()

    if args['latitude'] and args['longitude'] and args['radius']:
        query = 'SELECT id, (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s)) * sin(radians(latitude)))) AS distance FROM forum_profile WHERE (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s))     * sin(radians(latitude)))) < %(radius)s ORDER BY distance LIMIT %(limit)s' % {"latitude": args['latitude'], "longitude": args['longitude'], "radius": args['radius'], "limit": args['limit']} 
        results = Forumposts.query.from_statement(query).all()

    json_results = []
    for result in results:
        user = User.query.get(result.created_by)
        resultDictionary = {'id': result.id, 'image_url': result.image_url, 'title': result.title, 'created_by': user.username, 'description': result.description, 'latitude': result.latitude, 'longitude': result.longitude, 'created_at': str(result.created_at), 'location': result.location, 'created_by_id': user.id, 'category': result.category, 'location_pin_latitude': result.location_pin_latitude, 'location_pin_longitude': result.location_pin_longitude, 'total_likes': result.total_likes, 'user_has_liked': False}

        if args['user_id'] != None:
            resultDictionary['user_has_liked'] = self.userHasLiked(args['user_id'], result.id) 

        json_results.append(resultDictionary)

    response = {'status': 'successful', 'results' : json_results}
    return response
                       
  def userHasLiked(self, userId, forumId):
    likedStatus = ForumPostLikes.query.filter(ForumPostLikes.user_who_liked == userId, ForumPostLikes.forum_profile_id == forumId).first()
    if likedStatus ==  None:
        return False
    else:
        return True 
