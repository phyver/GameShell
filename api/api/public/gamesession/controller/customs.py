from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select

from api.database import get_session
from api.public.gamesession.models import GameSession


def read_gamesession_by_name(name: str, db: Session = Depends(get_session)):
    gamesession = db.exec(select(GameSession).filter(GameSession.name == name)).first()
    if not gamesession:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GameSession not found with name: {name}",
        )
    return gamesession
