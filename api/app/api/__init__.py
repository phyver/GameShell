from flask import Blueprint

bp = Blueprint("api", __name__, template_folder="templates")

# pytlint: disable=import-outside-toplevel
from app.api import routes
