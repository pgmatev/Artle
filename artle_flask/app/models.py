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
    templates = db.relationship('Template', backref='user', lazy='dynamic')

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


class Template(db.Model):
    __tablename__ = "templates"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    url = db.Column(db.Text, nullable=True, server_default="Null")
    user_thought = db.Column(db.Text, nullable=True, server_default="Null")
    is_liked = db.Column(db.Boolean, server_default="False")
    can_like = db.Column(db.Boolean, server_default="False")
    created_at = db.Column(db.DateTime, server_default=db.func.now())
    musics = db.relationship('Music', backref='template', lazy='dynamic')
    rhymes = db.relationship('Rhyme', backref='template', lazy='dynamic')
    drawings = db.relationship('Drawing', backref='template', lazy='dynamic')
    movies = db.relationship('Movie', backref='template', lazy='dynamic')
    quotes = db.relationship('Quote', backref='template', lazy='dynamic')

    def to_json_short(self):
        template_type = ""
        if self.musics:
            template_type = "Music"
        elif self.rhymes:
            template_type = "Rhyme"
        elif self.drawings:
            template_type = "Drawing"
        elif self.movies:
            template_type = "Movie"
        if self.quotes:
            template_type = "Quote"

        return dict(id=self.id, created_at=self.created_at, template_type=template_type)

    def to_json(self):
        return dict(id=self.id, url=self.url, user_thought=self.user_thought, is_liked=self.is_liked,
                    can_like=self.can_like, created_at=self.created_at)


class MusicSuggestion(db.Model):
    __tablename__ = "music_suggestions"

    id = db.Column(db.Integer, primary_key=True)
    suggestion = db.Column(db.Text)
    musics = db.relationship('Music', backref='music_suggestions', lazy='dynamic')

    def to_json(self):
        return dict(suggestion=self.suggestion)


class Music(db.Model):
    __tablename__ = "musics"

    id = db.Column(db.Integer, primary_key=True)
    template_id = db.Column(db.Integer, db.ForeignKey('templates.id'), nullable=False)
    suggestion_id = db.Column(db.Integer, db.ForeignKey('music_suggestions.id'), nullable=False)

    def to_json(self):
        return dict(self.music_suggestions.to_json(), template=self.template.to_json())


class RhymeSuggestion(db.Model):
    __tablename__ = "rhyme_suggestions"

    id = db.Column(db.Integer, primary_key=True)
    suggestion = db.Column(db.Text)
    rhymes = db.relationship('Rhyme', backref='rhyme_suggestions', lazy='dynamic')

    def to_json(self):
        return dict(suggestion=self.suggestion)


class Rhyme(db.Model):
    __tablename__ = "rhymes"

    id = db.Column(db.Integer, primary_key=True)
    template_id = db.Column(db.Integer, db.ForeignKey('templates.id'), nullable=False)
    suggestion_id = db.Column(db.Integer, db.ForeignKey('rhyme_suggestions.id'), nullable=False)

    def to_json(self):
        return dict(self.rhyme_suggestions.to_json(), template=self.template.to_json())


class DrawingSuggestion(db.Model):
    __tablename__ = "drawing_suggestions"

    id = db.Column(db.Integer, primary_key=True)
    suggestion = db.Column(db.Text)
    drawings = db.relationship('Drawing', backref='drawing_suggestions', lazy='dynamic')

    def to_json(self):
        return dict(suggestion=self.suggestion)


class Drawing(db.Model):
    __tablename__ = "drawings"

    id = db.Column(db.Integer, primary_key=True)
    template_id = db.Column(db.Integer, db.ForeignKey('templates.id'), nullable=False)
    suggestion_id = db.Column(db.Integer, db.ForeignKey('drawing_suggestions.id'), nullable=False)

    def to_json(self):
        return dict(self.drawing_suggestions.to_json(), template=self.template.to_json())


class Movie(db.Model):
    __tablename__ = "movies"

    id = db.Column(db.Integer, primary_key=True)
    template_id = db.Column(db.Integer, db.ForeignKey('templates.id'), nullable=False)

    def to_json(self):
        return dict(template=self.template.to_json())


class QuoteSuggestion(db.Model):
    __tablename__ = "quote_suggestions"

    id = db.Column(db.Integer, primary_key=True)
    suggestion = db.Column(db.Text)
    quotes = db.relationship('Quote', backref='quote_suggestions', lazy='dynamic')

    def to_json(self):
        return dict(suggestion=self.suggestion)


class Quote(db.Model):
    __tablename__ = "quotes"

    id = db.Column(db.Integer, primary_key=True)
    template_id = db.Column(db.Integer, db.ForeignKey('templates.id'), nullable=False)
    suggestion_id = db.Column(db.Integer, db.ForeignKey('quote_suggestions.id'), nullable=False)

    def to_json(self):
        return dict(self.quote_suggestions.to_json(), template=self.template.to_json())
