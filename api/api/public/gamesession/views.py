from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.gamesession.crud import (
    create_gamesession,
    delete_gamesession,
    read_gamesession,
    read_gamesessions,
    update_gamesession,
)
from api.public.gamesession.models import GameSessionCreate, GameSessionRead, GameSessionUpdate

router = APIRouter()


@router.post("", response_model=GameSessionRead)
def create_a_gamesession(gamesession: GameSessionCreate, db: Session = Depends(get_session)):
    return create_gamesession(gamesession=gamesession, db=db)


@router.get("", response_model=list[GameSessionRead])
def get_gamesessions(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_gamesessions(offset=offset, limit=limit, db=db)


@router.get("/{gamesession_id}", response_model=GameSessionRead)
def get_a_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    return read_gamesession(gamesession_id=gamesession_id, db=db)


@router.patch("/{gamesession_id}", response_model=GameSessionRead)
def update_a_gamesession(gamesession_id: int, gamesession: GameSessionUpdate, db: Session = Depends(get_session)):
    return update_gamesession(gamesession_id=gamesession_id, gamesession=gamesession, db=db)


@router.delete("/{gamesession_id}")
def delete_a_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    return delete_gamesession(gamesession_id=gamesession_id, db=db)
