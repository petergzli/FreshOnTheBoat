from freshontheboat import db

class ForumPostCommentLikes(db.Model):
    __tablename__ = 'forum_profile_postings_likes'
    id = db.Column(db.Integer, primary_key = True)
    forum_profile_posting_id = db.Column(db.Integer)
    user_who_liked  = db.Column(db.Integer)
    likes = db.Column(db.Integer)
    dislikes = db.Column(db.Integer)
