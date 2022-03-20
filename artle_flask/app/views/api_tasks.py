import random
from os import urandom

from flask import Blueprint, request, jsonify
from flask_praetorian import auth_required

from app.extensions import db, guard
from app.models import User, Staff, Music, Quote, Movie, Drawing, Rhyme, \
    MusicSuggestion, QuoteSuggestion, RhymeSuggestion, DrawingSuggestion, Template
from app.decorators import restrict_user_access, api_key_required

from sqlalchemy.sql.expression import func, select
from sqlalchemy.orm import load_only


api_tasks = Blueprint('api_tasks', __name__, url_prefix='/api/v1/tasks')


@api_tasks.route('/generate', methods=['GET'])
@api_key_required
@auth_required
def generate_task():
    available_tasks = [Quote, Music, Movie, Drawing, Rhyme]

    random.seed(urandom(128))
    choice = random.choice(available_tasks)

    print(choice)

    if hasattr(choice, f"{choice.__name__.lower()}_suggestion_id"):
        suggestion = globals()[f"{choice.__name__}Suggestion"].query.options(load_only('id')).offset(
            func.floor(
                func.random() *
                db.session.query(func.count(globals()[f"{choice.__name__}Suggestion"].id)).scalar_subquery()
            )
        ).limit(1).one()

        print(type(suggestion.suggestion), type(choice))
        return jsonify(model=choice.__name__, suggestion=suggestion.suggestion), 200

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
        suggestion = globals()[f"{task.get('model')}Suggestion"].query.filter_by(suggestion=task.get('suggestion')).one()

        if task.get('model') == "Movie" or task.get('model') == "Song" or task.get('model') == "Quote":
            is_likable = True
        else:
            is_likable = False

        template = Template(url=task.get('url'), user_thought=task.get('user_thought'), user_id=token_information["id"], can_like=is_likable, is_liked=task.get('is_liked'))
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
