from freshontheboat import db

class Forumposts(db.Model):
    __tablename__ = 'forum_profile'
    id = db.Column(db.Integer, primary_key = True)
    created_by = db.Column(db.Integer)
    description = db.Column(db.String)
    category = db.Column(db.Integer)
    location_pin_latitude = db.Column(db.Float)
    location_pin_longitude = db.Column(db.Float)
    title = db.Column(db.String)
    location = db.Column(db.String)
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    created_at = db.Column(db.DateTime)
    image_url = db.Column(db.String)
    forum_post_flagged = db.Column(db.Integer)
