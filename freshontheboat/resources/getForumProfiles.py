from flask_restful import Resource, reqparse
from freshontheboat.models.forumposts import Forumposts
from freshontheboat.models.users import User
from freshontheboat.models.forumpostlikes import ForumPostLikes
from freshontheboat.models.forumpostcomments import ForumPostComments
from freshontheboat.models.forumpostflagged import ForumPostFlagged

class GetForumProfiles(Resource):

  def __init__(self):
    self.reqparse = reqparse.RequestParser()
    self.reqparse.add_argument('latitude', type = float,  default="")
    self.reqparse.add_argument('longitude', type = float,  default="")
    self.reqparse.add_argument('limit', type = int, default = 50)
    self.reqparse.add_argument('radius', type = float, default = 15.0)
    self.reqparse.add_argument('user_id', type = int)
    self.reqparse.add_argument('category', type = int, default = 0)
    self.reqparse.add_argument('preference', type = int, default = 0)
    super(GetForumProfiles, self).__init__()

  #Preference: 0 = hottest, 1 = newest, 2 = top
  def get(self):
    args = self.reqparse.parse_args()
    if args['preference'] == 0:
        query = 'SELECT id, (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s)) *sin(radians(latitude)))) AS distance, round(cast(log(greatest(abs(total_likes), 1)) * sign(total_likes) + (extract(epoch from timestamp) - 1134028003) / 45000.0 as numeric), 7) AS hottest FROM forum_profile WHERE (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s)) * sin(radians(latitude)))) < %(radius)s AND category=%(category)s ORDER BY hottest LIMIT %(limit)s' % {"latitude": args['latitude'], "longitude": args['longitude'], "radius": args['radius'], "limit": args['limit'], "category": args['category']} 
        results = Forumposts.query.from_statement(query).all()

    if args['latitude'] and args['longitude'] and args['radius'] and args['preference']==1:
        query = 'SELECT id, (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s)) * sin(radians(latitude)))) AS distance FROM forum_profile WHERE (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s))     * sin(radians(latitude)))) < %(radius)s AND category=%(category)s ORDER BY created_at DESC, created_at_time DESC LIMIT %(limit)s' % {"latitude": args['latitude'], "longitude": args['longitude'], "radius": args['radius'], "limit": args['limit'], "category": args['category']} 
        results = Forumposts.query.from_statement(query).all()

    if args['preference'] == 2:
        query = 'SELECT id, (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s)) *     sin(radians(latitude)))) AS distance FROM forum_profile WHERE (3959 * acos(cos(radians(%(latitude)s)) * cos(radians(latitude)) * cos(radians(longitude) - radians(%(longitude)s)) + sin(radians(%(latitude)s)) * sin(radians(latitude)))) < %(radius)s AND category=%(category)s ORDER BY total_likes DESC LIMIT %(limit)s' % {"latitude": args['latitude'], "longitude": args['longitude'], "radius": args['radius'], "limit": args['limit'], "category": args['category']}
        results = Forumposts.query.from_statement(query).all()

    json_results = []
    for result in results:
        user = User.query.get(result.created_by)
        resultDictionary = {'id': result.id, 'image_url': result.image_url, 'title': result.title, 'created_by': user.username, 'description': result.description, 'latitude': result.latitude, 'longitude': result.longitude, 'created_at': str(result.created_at), 'created_at_time': str(result.created_at_time),'location': result.location, 'created_by_id': user.id, 'category': result.category, 'location_pin_latitude': result.location_pin_latitude, 'location_pin_longitude': result.location_pin_longitude, 'total_likes': result.total_likes, 'user_has_liked': 0, 'total_comments': ForumPostComments.query.filter(ForumPostComments.forum_id==result.id).count(), 'user_has_flagged': False}

        if args['user_id'] != None:
            resultDictionary['user_has_liked'] = self.userHasLiked(args['user_id'], result.id) 
            resultDictionary['user_has_flagged'] = self.userHasFlagged(args['user_id'], result.id)

        json_results.append(resultDictionary)

    response = {'status': 'successful', 'results' : json_results}
    return response
                       
  def userHasFlagged(self, userId, forumId):
    flaggedStatus = ForumPostFlagged.query.filter(ForumPostFlagged.user_who_flagged == userId, ForumPostFlagged.forum_profile_flagged_id == forumId ).first()
    if flaggedStatus == None:
        return False
    else:
        return True

  def userHasLiked(self, userId, forumId):
    likedStatus = ForumPostLikes.query.filter(ForumPostLikes.user_who_liked == userId, ForumPostLikes.forum_profile_id == forumId).first()
    if likedStatus == None:
        return 0
    elif likedStatus.likes == 1:
        return 1
    elif likedStatus.dislikes == -1:
        return -1 
