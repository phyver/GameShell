import flask
from app.api import bp

# /api/users
from app.api.users import bp as users_bp

bp.register_blueprint(users_bp, url_prefix="/users")


@bp.route("/")
def index():
    return flask.jsonify({"message": "Hello world"})
