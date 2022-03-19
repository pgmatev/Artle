from flask import Blueprint, request, redirect, url_for, render_template, flash
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.security import check_password_hash

from app.models import Staff
from app.decorators import anonymous_user_required


admin_authentication = Blueprint('admin_authentication', __name__)


@admin_authentication.route('/admin/login', methods=['GET', 'POST'])
@anonymous_user_required
def login():
    if request.method == 'GET':
        return render_template('admin/login.html')

    else:
        username = request.form.get('username')
        password = request.form.get('password')
        remember = True if request.form.get('remember') else False

        user = Staff.query.filter_by(username=username).one_or_none()

        if user is None or not check_password_hash(user.password, password):
            flash('Wrong username or password!', 'danger')
            return redirect(url_for('admin_authentication.login'))

        login_user(user, remember=remember)

        return redirect(url_for('admin.index'))


@admin_authentication.route('/admin/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('admin_authentication.login'))
