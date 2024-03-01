from fastapi import Depends
from sqlmodel import Session, select

from api.database import get_session
from api.public.gamesession.models import GameSession


def read_gamesession_by_name(name: str, db: Session = Depends(get_session)):
    gamesessions = db.exec(select(GameSession).filter(GameSession.name == name))
    return gamesessions
