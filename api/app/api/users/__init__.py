from flask import Blueprint

bp = Blueprint('main', __name__)


from app.api import routes
