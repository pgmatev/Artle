import click
from flask.cli import with_appcontext
from werkzeug.security import generate_password_hash

from app.extensions import guard, db
from app.models import Staff, User, RhymeWord, DrawingWord, MusicQuestion


@click.command(name='delete_database')
@with_appcontext
def delete_database():
    db.drop_all()


@click.command(name='create_database')
@with_appcontext
def create_database():
    db.create_all()


@click.command(name='import_initial_data')
@with_appcontext
def import_initial_data():
    user2 = User(email="vesko@vesko.com", username="vesko", password=guard.hash_password("vesko"), is_active=True)
    user1 = Staff(email="admin@admin.com", username="admin", password=generate_password_hash("admin"))
    db.session.add(user1)
    db.session.add(user2)

    db.session.commit()


def each_chunk(stream, separator):
  buffer = ''
  while True:  # until EOF
    chunk = stream.read(4096)  # I propose 4096 or so
    if not chunk:  # EOF?
      yield buffer
      break
    buffer += chunk
    while True:  # until no separator is found
      try:
        part, buffer = buffer.split(separator, 1)
      except ValueError:
        break
      else:
        yield part


@click.command(name='fill_database')
@with_appcontext
def fill_database():
    with open('rhymes') as f:
        for chunk in each_chunk(f, ',\n'):
            word = RhymeWord(word=chunk)
            db.session.add(word)
    with open('drawings') as f1:
        for chunk in each_chunk(f1, ',\n'):
            word = DrawingWord(word=chunk)
            db.session.add(word)
    with open('songs') as f2:
        for chunk in each_chunk(f2, ',\n'):
            question = MusicQuestion(question=chunk)
            db.session.add(question)
    db.session.commit()


