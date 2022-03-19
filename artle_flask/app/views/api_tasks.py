import random
from os import urandom

from flask import Blueprint, request, jsonify
from flask_praetorian import auth_required

from app.models import User, Staff, Music, Quote, Movie, Drawing, Rhyme
from app.decorators import restrict_user_access, api_key_required


api_tasks = Blueprint('api_tasks', __name__, url_prefix='/api/v1/tasks')


@api_tasks.route('/generate', methods=['GET'])
@api_key_required
@auth_required
def generate_task():
    available_tasks = [Quote, Music, Movie, Drawing, Rhyme]

    random.seed(urandom(128))
    choice = random.choice(available_tasks)

    print(choice.__name__)

    return jsonify({"message": "okay"}), 200
