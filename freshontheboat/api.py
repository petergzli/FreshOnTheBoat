from freshontheboat import app
from flask_restful import Api

from freshontheboat.resources.registerNewUsers import RegisterNewUsers
from freshontheboat.resources.loginUsers import Login 
from freshontheboat.resources.postNewForumProfile import PostNewForumProfile
from freshontheboat.resources.getForumProfiles import GetForumProfiles 
from freshontheboat.resources.postNewForumComment import PostNewForumComment 
from freshontheboat.resources.getForumComments import GetForumComments 
from freshontheboat.resources.postForumProfileLikes import PostNewForumLikes 
from freshontheboat.resources.getForumProfileLikes import GetNewForumLikes 
from freshontheboat.resources.postForumProfileCommentLikes import PostNewForumCommentLikes 
from freshontheboat.resources.getForumProfileCommentLikes import GetNewForumCommentLikes 
from freshontheboat.resources.postForumProfileFlags import PostForumProfileFlags 
from freshontheboat.resources.postForumProfileCommentFlags import PostForumProfileCommentFlag 
from freshontheboat.resources.getAccountForumProfiles import GetAccountForumProfiles 
from freshontheboat.controllers import root

api = Api(app)

#Routes
api.add_resource(RegisterNewUsers, '/users/new/')
api.add_resource(Login, '/users/login/')
api.add_resource(GetAccountForumProfiles, '/users/forumposts/')

api.add_resource(PostNewForumProfile, '/forum/newpost/')
api.add_resource(GetForumProfiles, '/forum/getresults/')
api.add_resource(PostNewForumLikes, '/forum/likes/')
api.add_resource(GetNewForumLikes, '/forum/getlikes/')
api.add_resource(PostForumProfileFlags, '/forum/flag/')

api.add_resource(PostNewForumComment, '/forum/comments/newpost/')
api.add_resource(GetForumComments, '/forum/comments/getcomments/')
api.add_resource(PostNewForumCommentLikes, '/forum/comments/likes/')
api.add_resource(GetNewForumCommentLikes, '/forum/comments/getlikes/')
api.add_resource(PostForumProfileCommentFlag, '/forum/comments/flag/')

