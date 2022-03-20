import random
import requests
import string
from os import urandom

from flask import Blueprint, request, jsonify, current_app
from flask_praetorian import auth_required
from requests.auth import HTTPBasicAuth

from app.extensions import db, guard
from app.models import User, Staff, Music, Quote, Movie, Drawing, Rhyme, \
    MusicSuggestion, QuoteSuggestion, RhymeSuggestion, DrawingSuggestion, Template
from app.decorators import restrict_user_access, api_key_required

from sqlalchemy.sql.expression import func, select
from sqlalchemy.orm import load_only

api_tasks = Blueprint('api_tasks', __name__, url_prefix='/api/v1/tasks')


def get_quote():
    quote_response = requests.get("https://api.quotable.io/random")
    s = quote_response.json().get('content') + " - " + quote_response.json().get('author')

    return s


def get_spotify_token():
    return requests.post('https://accounts.spotify.com/api/token', data={'grant_type': "client_credentials"},
                         auth=(current_app.config['SPOTIFY_USERNAME'], current_app.config['SPOTIFY_PASSWORD']))


def rand_search_query():
    letter = random.choice(string.ascii_letters)
    return f"%{letter}%"


def get_music():
    token = get_spotify_token().json()
    spotify_response = requests.get(f"https://api.spotify.com/v1/search?q={rand_search_query()}&type=track",
                                    headers={'Authorization': f"Bearer {token.get('access_token')}"})

    return spotify_response.json().get('tracks').get('items')[0].get('href')


@api_tasks.route('/generate', methods=['GET'])
# @api_key_required
# @auth_required
def generate_task():
    available_tasks = [Quote, Music, Movie, Drawing, Rhyme]
    random.seed(urandom(128))
    choice = random.choice(available_tasks)

    if hasattr(choice, "suggestion_id"):
        suggestion = globals()[f"{choice.__name__}Suggestion"].query.options(load_only('id')).offset(
            func.floor(
                func.random() *
                db.session.query(func.count(globals()[f"{choice.__name__}Suggestion"].id)).scalar_subquery()
            )
        ).limit(1).one_or_none()

        if suggestion:
            if choice.__name__ == "Music":
                return jsonify(model=choice.__name__, suggestion=suggestion.suggestion, url=get_music()), 200
            return jsonify(model=choice.__name__, suggestion=suggestion.suggestion), 200
        else:
            if choice.__name__ == "Quote":
                return jsonify(model=choice.__name__, url=get_quote()), 200
    else:
        return jsonify(model=choice.__name__), 200

    # return jsonify({"message": "okay"}), 200


@api_tasks.route('/save', methods=['POST'])
@api_key_required
@auth_required
def save_task():
    task = request.get_json()
    print(task)
    # rhyme_sug = RhymeSuggestion.query.filter_by(suggestion="Наркотици").one()
    # print(rhyme_sug)
    token = guard.read_token_from_header()
    token_information = guard.extract_jwt_token(token)
    try:
        suggestion = globals()[f"{task.get('model')}Suggestion"].query.filter_by(
            suggestion=task.get('suggestion')).one()

        if task.get('model') == "Movie" or task.get('model') == "Song" or task.get('model') == "Quote":
            is_likable = True
        else:
            is_likable = False

        template = Template(url=task.get('url'), user_thought=task.get('user_thought'), user_id=token_information["id"],
                            can_like=is_likable, is_liked=task.get('is_liked'))
        db.session.add(template)
        db.session.commit()

        model_type = globals()[task.get('model')](suggestion_id=suggestion.id, template_id=template.id)
        # print(model_type.__name__)
        db.session.add(model_type)
        db.session.commit()

        return jsonify(), 200
    except Exception as e:
        print(e)
    return jsonify(), 500
