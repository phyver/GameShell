from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select

from api.database import get_session
from api.public.gamesession.models import GameSession, GameSessionCreate, GameSessionUpdate


def create_gamesession(gamesession: GameSessionCreate, db: Session = Depends(get_session)):
    gamesession_to_db = GameSession.model_validate(gamesession)
    db.add(gamesession_to_db)
    db.commit()
    db.refresh(gamesession_to_db)
    return gamesession_to_db


def read_gamesessions(offset: int = 0, limit: int = 20, db: Session = Depends(get_session)):
    gamesessions = db.exec(select(GameSession).offset(offset).limit(limit)).all()
    return gamesessions


def read_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    gamesession = db.get(GameSession, gamesession_id)
    if not gamesession:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GameSession not found with id: {gamesession_id}",
        )
    return gamesession


def update_gamesession(gamesession_id: int, gamesession: GameSessionUpdate, db: Session = Depends(get_session)):
    gamesession_to_update = db.get(GameSession, gamesession_id)
    if not gamesession_to_update:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GameSession not found with id: {gamesession_id}",
        )

    team_data = gamesession.model_dump(exclude_unset=True)
    for key, value in team_data.items():
        setattr(gamesession_to_update, key, value)

    db.add(gamesession_to_update)
    db.commit()
    db.refresh(gamesession_to_update)
    return gamesession_to_update


def delete_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    gamesession = db.get(GameSession, gamesession_id)
    if not gamesession:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GameSession not found with id: {gamesession_id}",
        )

    db.delete(gamesession)
    db.commit()
    return {"ok": True}
