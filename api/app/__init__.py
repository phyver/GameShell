from flask import Flask

from config import Config
from app.extensions import db


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize Flask extensions here
    db.init_app(app)

    # Register blueprints here (pylint: disable=import-outside-toplevel)
    from app.api import bp as api_bp
    from app.web import bp as web_bp

    app.register_blueprint(web_bp, url_prefix="/")
    app.register_blueprint(api_bp, url_prefix="/api")

    return app
