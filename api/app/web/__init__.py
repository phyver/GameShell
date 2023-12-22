from flask import Blueprint


bp = Blueprint("web", __name__, template_folder="templates")

# pylint: disable=wrong-import-position
from app.web import routes
