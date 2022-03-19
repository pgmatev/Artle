from flask import Blueprint, redirect, url_for


main = Blueprint('main', __name__)


@main.route('/')
def index():
    return redirect(url_for('admin_authentication.login'))


@main.route('/favicon.ico')
def favicon():
    return redirect(url_for('static', filename='images/favicon.ico'))


if __name__ == '__main__':
    main.app.run()
