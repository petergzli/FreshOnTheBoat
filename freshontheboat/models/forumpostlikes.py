from freshontheboat import db

class ForumPostLikes(db.Model):
    __tablename__ = 'forum_profile_likes'
    id = db.Column(db.Integer, primary_key = True)
    forum_profile_id = db.Column(db.Integer)
    user_who_liked  = db.Column(db.Integer)
    likes = db.Column(db.Integer)
    dislikes = db.Column(db.Integer)

        
