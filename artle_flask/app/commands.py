import click
from flask.cli import with_appcontext
from werkzeug.security import generate_password_hash

from app.extensions import guard, db
from app.models import Staff, User


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

