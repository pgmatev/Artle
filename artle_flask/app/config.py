import os
from dotenv import load_dotenv

import pendulum

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(os.path.dirname(basedir), '.env'))

SECRET_KEY = os.environ.get('SECRET_KEY')
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
SQLALCHEMY_TRACK_MODIFICATIONS = False
SERVER_NAME = os.environ.get('SERVER_NAME')

PRAETORIAN_CONFIRMATION_SENDER = os.environ.get('MAIL_DEFAULT_SENDER')
PRAETORIAN_CONFIRMATION_URI = f'http://{os.environ.get("SERVER_NAME")}/finalize'

PRAETORIAN_RESET_SENDER = os.environ.get('MAIL_DEFAULT_SENDER')
PRAETORIAN_RESET_URI = f'http://{os.environ.get("SERVER_NAME")}/reset'

JWT_ACCESS_LIFESPAN = pendulum.duration(hours=1)

ARTLEAPI_KEY = os.environ.get('ARTLEAPI_KEY')

JSON_AS_ASCII = False
