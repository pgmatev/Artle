from flask import Flask, url_for
from flask_admin.menu import MenuLink

from app.commands import create_database, import_initial_data, delete_database
from app.extensions import db, guard, login_manager, admin
from app.models import User, Staff
from app.views.admin_models import ProtectedModelView


def register_extensions(app):
    db.init_app(app)
    guard.init_app(app, User)
    login_manager.init_app(app)
    admin.init_app(app)


def register_admin_views(app):
    admin.add_view(ProtectedModelView(Staff, db.session, name='Staff', endpoint='staff',
                                      can_edit=True, can_create=True, can_delete=True))
    admin.add_view(ProtectedModelView(User, db.session, name='Users', endpoint='users',
                                      can_edit=True, can_create=True, can_delete=True))

    with app.app_context():
        admin.add_link(MenuLink(name='Logout', url=url_for('admin_authentication.logout')))


def register_blueprints(app):
    from app.views.main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    from app.views.admin_authentication import admin_authentication as admin_authentication_blueprint
    app.register_blueprint(admin_authentication_blueprint)

    from app.views.api_authentication import api_authentication as api_authentication_blueprint
    app.register_blueprint(api_authentication_blueprint)


def register_commands(app):
    app.cli.add_command(delete_database)
    app.cli.add_command(create_database)
    app.cli.add_command(import_initial_data)


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
