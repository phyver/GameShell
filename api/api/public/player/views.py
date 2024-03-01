from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.player.controller.crud import (
    create_player,
    delete_player,
    read_player,
    read_players,
    update_player,
)
from api.public.player.controller.customs import read_player_by_name_and_gamesession, read_players_by_gamesession
from api.public.player.models import PlayerCreate, PlayerRead, PlayerUpdate

from api.public.gamesession.views import PREFIX as GAMESSESSION_PREFIX

router = APIRouter()
PREFIX = "/players"


@router.post(PREFIX, response_model=PlayerRead)
def create_a_player(player: PlayerCreate, db: Session = Depends(get_session)):
    return create_player(player=player, db=db)


@router.get(PREFIX, response_model=list[PlayerRead])
def get_players(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_players(offset=offset, limit=limit, db=db)


@router.get(PREFIX + "/{player_id}", response_model=PlayerRead)
def get_a_player(player_id: int, db: Session = Depends(get_session)):
    return read_player(player_id=player_id, db=db)


@router.patch(PREFIX + "/{player_id}", response_model=PlayerRead)
def update_a_player(player_id: int, player: PlayerUpdate, db: Session = Depends(get_session)):
    return update_player(player_id=player_id, player=player, db=db)


@router.delete(PREFIX + "/{player_id}")
def delete_a_player(player_id: int, db: Session = Depends(get_session)):
    return delete_player(player_id=player_id, db=db)


@router.get(GAMESSESSION_PREFIX + "/{gamesession_id}/players", response_model=list[PlayerRead])
def get_gamesession_players(gamesession_id: int, db: Session = Depends(get_session)):
    return read_players_by_gamesession(gamesession_id=gamesession_id, db=db)


@router.get(GAMESSESSION_PREFIX + "/{gamesession_id}/players/{username}", response_model=list[PlayerRead])
def get_a_gamesession_player_by_name(gamesession_id: int, username: str, db: Session = Depends(get_session)):
    return read_player_by_name_and_gamesession(gamesession_id=gamesession_id, username=username, db=db)
