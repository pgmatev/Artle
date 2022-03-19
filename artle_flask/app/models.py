from flask_login import UserMixin

from app.extensions import db


class Staff(db.Model, UserMixin):
    __tablename__ = "staff"

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.Text, unique=True, nullable=False)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return self.username


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.Text, unique=True, nullable=False)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())
    is_active = db.Column(db.Boolean, default=False, nullable=False)

    @classmethod
    def lookup(cls, username):
        return cls.query.filter_by(username=username).one_or_none()

    @classmethod
    def identify(cls, user_id):
        return cls.query.filter_by(id=user_id).one_or_none()

    @property
    def rolenames(self):
        return []

    @property
    def identity(self):
        return self.id

    def is_valid(self):
        return self.is_active

    def to_json(self):
        return dict(id=self.id, email=self.email, username=self.username)

    def __repr__(self):
        return self.username
