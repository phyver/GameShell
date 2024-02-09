from sqlmodel import Session, SQLModel, create_engine

from api.config import settings

engine = create_engine(settings.DATABASE_URI)


def create_db_and_tables():
    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
