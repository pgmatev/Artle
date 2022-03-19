from flask import Blueprint, request, jsonify
from flask_praetorian import auth_required

from app.models import User
from app.decorators import restrict_user_access, api_key_required
from app.extensions import db


api_users_information = Blueprint('api_users_information', __name__, url_prefix='/api/v1/users')


@api_users_information.route('/<int:user_id>', methods=['GET'])
@api_key_required
@auth_required
@restrict_user_access
def get_user(user_id):
    print('asd')

    user = User.query.get(user_id)

    return jsonify(user.to_json()), 200


@api_users_information.route('/<int:user_id>', methods=['PUT'])
@api_key_required
@auth_required
@restrict_user_access
def update_user(user_id):
    user = User.query.get(user_id)

    req = request.get_json()
    email = req.get('email', None)
    username = req.get('username', None)

    if user:
        user.email = email
        user.username = username
        db.session.commit()
        return '', 204

    else:
        resp = {'message': 'Not found'}
        return jsonify(resp), 404


@api_users_information.route('/<int:user_id>', methods=['POST'])
@api_key_required
@auth_required
@restrict_user_access
def set_user_preferences(user_id):  # TODO
    pass
