from flask import Flask, url_for
from flask_admin.menu import MenuLink

from app.commands import create_database, import_initial_data, delete_database, fill_database
from app.extensions import db, guard, login_manager, admin
from app.models import User, Staff, Template, Movie, Music, Quote, Rhyme, RhymeSuggestion,\
    DrawingSuggestion, Drawing, MusicSuggestion, QuoteSuggestion
from app.views.admin_models import ProtectedModelView


def register_extensions(app):
    db.init_app(app)
    guard.init_app(app, User)
    login_manager.init_app(app)
    admin.init_app(app)


def register_admin_views(app):
    user = "User Info"
    task = "Tasks"
    task_question = "Task Questions"

    admin.add_view(ProtectedModelView(Staff, db.session, name='Staff', endpoint='staff', category=user,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(User, db.session, name='Users', endpoint='users', category=user,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(Template, db.session, name='Templates', endpoint='templates',
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(Music, db.session, name='Musics', endpoint='musics', category=task,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(MusicSuggestion, db.session, name='MusicQuestions', endpoint='music_questions',
                                      category=task_question, can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(Quote, db.session, name='Quotes', endpoint='quotes', category=task,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(QuoteSuggestion, db.session, name='QuoteQuestions', endpoint='quote_questions',
                                      category=task_question, can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(Movie, db.session, name='Movies', endpoint='movies', category=task,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(Rhyme, db.session, name='Rhymes', endpoint='rhymes', category=task,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(RhymeSuggestion, db.session, name='RhymeWords', endpoint='rhyme_words',
                                      category=task_question, can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(Drawing, db.session, name='Drawings', endpoint='drawings', category=task,
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(DrawingSuggestion, db.session, name='DrawingWords', endpoint='drawing_words',
                                      category=task_question, can_edit=True, can_create=True, can_delete=True))

    with app.app_context():
        admin.add_link(MenuLink(name='Logout', url=url_for('admin_authentication.logout')))


def register_blueprints(app):
    from app.views.main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    from app.views.admin_authentication import admin_authentication as admin_authentication_blueprint
    app.register_blueprint(admin_authentication_blueprint)

    from app.views.api_authentication import api_authentication as api_authentication_blueprint
    app.register_blueprint(api_authentication_blueprint)

    from app.views.api_users_information import api_users_information as api_users_information_blueprint
    app.register_blueprint(api_users_information_blueprint)

    from app.views.api_tasks import api_tasks as api_tasks_blueprint
    app.register_blueprint(api_tasks_blueprint)


def register_commands(app):
    app.cli.add_command(delete_database)
    app.cli.add_command(create_database)
    app.cli.add_command(import_initial_data)
    app.cli.add_command(fill_database)


def create_app():
    app = Flask(__name__)

    app.config.from_pyfile('config.py')

    register_extensions(app)
    register_blueprints(app)
    register_admin_views(app)
    register_commands(app)

    login_manager.login_view = 'admin_authentication.login'

    @login_manager.user_loader
    def load_user(user_id):
        return Staff.query.get(int(user_id))

    return app
