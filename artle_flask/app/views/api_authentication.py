from flask import request, Blueprint, jsonify
from sqlalchemy.exc import IntegrityError

from app.extensions import guard, db
from app.models import User
from app.decorators import api_key_required


api_authentication = Blueprint('api_authentication', __name__)


@api_authentication.route('/api/login', methods=['POST'])
@api_key_required
def login():
    req = request.get_json(force=True)
    username = req.get('username', None)
    password = req.get('password', None)

    user = guard.authenticate(username.lower(), password)

    resp = {'access_token': guard.encode_jwt_token(user)}
    return jsonify(resp), 200


@api_authentication.route('/api/register', methods=['POST'])
@api_key_required
def register():
    req = request.get_json(force=True)
    username = req.get('username', None)
    email = req.get('email', None)
    password = req.get('password', None)

    new_user = User(
        email=email,
        username=username.lower(),
        password=guard.hash_password(password),
        is_active=True
    )

    try:
        db.session.add(new_user)
        db.session.commit()

    except IntegrityError:
        resp = {'message': 'Email or username already registered'}
        return jsonify(resp), 409

    resp = {'message': f'Successfully registered!'}
    return jsonify(resp), 201


@api_authentication.route('/api/refresh', methods=['GET'])
@api_key_required
def refresh():
    old_token = guard.read_token_from_header()
    resp = {'access_token': guard.refresh_jwt_token(old_token)}
    return jsonify(resp), 200
