from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.gamesession.controller.crud import (
    create_gamesession,
    delete_gamesession,
    read_gamesession,
    read_gamesessions,
    update_gamesession,
)
from api.public.gamesession.controller.customs import read_gamesession_by_name
from api.public.gamesession.models import GameSessionCreate, GameSessionRead, GameSessionUpdate

router = APIRouter()
PREFIX = "/gamesessions"


@router.post(PREFIX, response_model=GameSessionRead)
def create_a_gamesession(gamesession: GameSessionCreate, db: Session = Depends(get_session)):
    return create_gamesession(gamesession=gamesession, db=db)


@router.get(PREFIX, response_model=list[GameSessionRead])
def get_gamesessions(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_gamesessions(offset=offset, limit=limit, db=db)


@router.get(PREFIX + "/{gamesession_id}", response_model=GameSessionRead)
def get_a_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    return read_gamesession(gamesession_id=gamesession_id, db=db)


@router.get(PREFIX + "/name/{name}", response_model=GameSessionRead)
def get_a_gamesession_by_name(name: str, db: Session = Depends(get_session)):
    return read_gamesession_by_name(name=name, db=db)


@router.patch(PREFIX + "/{gamesession_id}", response_model=GameSessionRead)
def update_a_gamesession(gamesession_id: int, gamesession: GameSessionUpdate, db: Session = Depends(get_session)):
    return update_gamesession(gamesession_id=gamesession_id, gamesession=gamesession, db=db)


@router.delete(PREFIX + "/{gamesession_id}")
def delete_a_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    return delete_gamesession(gamesession_id=gamesession_id, db=db)
