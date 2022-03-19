from flask_sqlalchemy import SQLAlchemy
from flask_praetorian import Praetorian
from flask_login import LoginManager
from flask_admin import Admin


db = SQLAlchemy()
guard = Praetorian()
login_manager = LoginManager()
admin = Admin(name='Artle', url='/admin', template_mode='bootstrap3')
