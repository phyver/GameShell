from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.player.crud import (
    create_player,
    delete_player,
    read_player,
    read_players,
    update_player,
)
from api.public.player.models import PlayerCreate, PlayerRead, PlayerUpdate

router = APIRouter()


@router.post("", response_model=PlayerRead)
def create_a_player(player: PlayerCreate, db: Session = Depends(get_session)):
    return create_player(player=player, db=db)


@router.get("", response_model=list[PlayerRead])
def get_players(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_players(offset=offset, limit=limit, db=db)


@router.get("/{player_id}", response_model=PlayerRead)
def get_a_player(player_id: int, db: Session = Depends(get_session)):
    return read_player(player_id=player_id, db=db)


@router.patch("/{player_id}", response_model=PlayerRead)
def update_a_player(player_id: int, player: PlayerUpdate, db: Session = Depends(get_session)):
    return update_player(player_id=player_id, player=player, db=db)


@router.delete("/{player_id}")
def delete_a_player(player_id: int, db: Session = Depends(get_session)):
    return delete_player(player_id=player_id, db=db)
