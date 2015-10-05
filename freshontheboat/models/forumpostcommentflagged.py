from freshontheboat import db

class ForumPostCommentFlagged(db.Model):
    __tablename__ = 'forum_profile_postings_flagged'
    id = db.Column(db.Integer, primary_key = True)
    forum_profile_flagged_id = db.Column(db.Integer)
    user_who_flagged = db.Column(db.Integer)
