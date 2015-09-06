from freshontheboat import db

class ForumPostComments(db.Model):
    __tablename__ = 'forum_profile_postings'
    id = db.Column(db.Integer, primary_key = True)
    forum_id = db.Column(db.Integer)
    poster_id = db.Column(db.Integer)
    body = db.Column(db.String)
    created_at = db.Column(db.DateTime)
    image_url = db.Column(db.String)
    comment_flagged = db.Column(db.Integer)
