import os
import secrets
from typing import Literal

from pydantic_settings import BaseSettings

from dotenv import load_dotenv

load_dotenv(override=True)


class Settings(BaseSettings):
    PROJECT_NAME: str = f"GameShell API - {os.getenv('ENV', 'development').capitalize()}"
    DESCRIPTION: str = "A FastAPI + SQLModel production-ready API"
    ENV: Literal["development", "staging", "production"] = "development"
    VERSION: str = "0.1"
    SECRET_KEY: str = secrets.token_urlsafe(32)
    DATABASE_URI: str = "postgresql://test:test@localhost:5432/test"
    API_USERNAME: str = "svc_test"
    API_PASSWORD: str = "superstrongpassword"

    class Config:
        case_sensitive = True


settings = Settings()
