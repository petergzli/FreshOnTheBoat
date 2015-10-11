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
    replied_to_forum_id = db.Column(db.Integer)
    location_pin_latitude = db.Column(db.Float)
    location_pin_longitude = db.Column(db.Float)
    total_likes = db.Column(db.Integer)
    
    def userHasLiked(self):
        if self.total_likes != None:
            self.total_likes = self.total_likes + 1
        else:
            self.total_likes = 1
    def userHasDisliked(self):
        if self.total_likes != None:
            self.total_likes = self.total_likes - 1
        else:
            self.total_likes = -1
