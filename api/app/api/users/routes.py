from flask import render_template
from app.api.users import bp
from app.extensions import db
from app.api.models.user import User


@bp.route("/")
def index():
    users = User.query.all()
    return render_template("users/index.html", users=users)
