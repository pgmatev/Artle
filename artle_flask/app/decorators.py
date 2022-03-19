from functools import wraps
from flask_login import current_user
from flask import redirect, flash, jsonify, request, current_app, url_for

from app.extensions import guard
from app.models import User


def anonymous_user_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if current_user.is_authenticated:
            flash('You are already logged in!', 'danger')
            return redirect(url_for('admin.index'))

        return f(*args, **kwargs)

    return decorated_function


def restrict_user_access(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = guard.read_token_from_header()
        token_information = guard.extract_jwt_token(token)

        user = User.query.get(token_information['id'])

        if user.id != kwargs['user_id']:
            resp = {'message': 'Unauthorized access to other users information'}
            return jsonify(resp), 401

        return f(*args, **kwargs)

    return decorated_function


def api_key_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if request.headers.get('X-API-KEY') != current_app.config['ARTLEAPI_KEY']:
            return jsonify({'message': 'API key required!'}), 401

        return f(*args, **kwargs)

    return decorated_function
