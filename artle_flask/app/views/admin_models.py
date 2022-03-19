from flask_admin.contrib.sqla import ModelView
from flask_login import current_user
from flask import redirect, url_for


class ProtectedModelView(ModelView):
    def __init__(self, model, session,
                 name=None, category=None, endpoint=None, url=None, static_folder=None,
                 menu_class_name=None, menu_icon_type=None, menu_icon_value=None,
                 can_create=False, can_edit=False, can_delete=False):
        super(ProtectedModelView, self).__init__(model, session, name, category, endpoint, url, static_folder,
                                                 menu_class_name=menu_class_name,
                                                 menu_icon_type=menu_icon_type,
                                                 menu_icon_value=menu_icon_value)
        self.can_create = can_create
        self.can_edit = can_edit
        self.can_delete = can_delete

    def is_accessible(self):
        return current_user.is_authenticated

    def inaccessible_callback(self, name, **kwargs):
        return redirect(url_for('admin_authentication.login'))
