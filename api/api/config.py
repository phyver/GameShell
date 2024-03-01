import os
import secrets
from typing import Literal

from pydantic_settings import BaseSettings

from dotenv import load_dotenv

load_dotenv(override=True)


class Settings(BaseSettings):
    PROJECT_NAME: str = f"GameShell API - {os.getenv('ENV', 'development').capitalize()}"
    DESCRIPTION: str = "GameShell API, made with FastAPI and SQLModel."
    ENV: Literal["development", "staging", "production"] = "development"
    VERSION: str = "0.1"
    SECRET_KEY: str = secrets.token_urlsafe(32)
    DATABASE_URI: str = "postgresql://test:test@localhost:5432/test"

    class Config:
        case_sensitive = True


settings = Settings()
