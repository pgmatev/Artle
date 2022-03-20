import random
from os import urandom

from flask import Blueprint, request, jsonify
from flask_praetorian import auth_required

from app.extensions import db
from app.models import User, Staff, Music, Quote, Movie, Drawing, Rhyme, MusicSuggestion, QuoteSuggestion, RhymeSuggestion, DrawingSuggestion
from app.decorators import restrict_user_access, api_key_required

from sqlalchemy.sql.expression import func, select
from sqlalchemy.orm import load_only


api_tasks = Blueprint('api_tasks', __name__, url_prefix='/api/v1/tasks')


@api_tasks.route('/generate', methods=['GET'])
# @api_key_required
# @auth_required
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

        # for sug in suggestion:
        #     print("this is ", sug.suggestion)

        # query = DBsession.query(globals()[f"{choice.__name__}Suggestion"])
        # rowCount = int(query.count())
        # randomRow = query.offset(int(rowCount * random.random())).first()
        # suggestion = globals()[f"{choice.__name__}Suggestion"].get.order_by(func.random())
        # print("this was ", suggestion)

    return jsonify({"message": "okay"}), 200
