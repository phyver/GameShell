from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select
from sqlalchemy.exc import IntegrityError

from api.database import get_session
from api.public.player.models import Player, PlayerCreate, PlayerUpdate

from api.utils.error_parser import parse_integrity_error


def create_player(player: PlayerCreate, db: Session = Depends(get_session)):
    try:
        player_to_db = Player.model_validate(player)
        db.add(player_to_db)
        db.commit()
        db.refresh(player_to_db)
    except IntegrityError as error:
        parse_integrity_error(error)
    return player_to_db


def read_players(offset: int = 0, limit: int = 20, db: Session = Depends(get_session)):
    players = db.exec(select(Player).offset(offset).limit(limit)).all()
    return players


def read_player(player_id: int, db: Session = Depends(get_session)):
    player = db.get(Player, player_id)
    if not player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player not found with id: {player_id}",
        )
    return player


def update_player(player_id: int, player: PlayerUpdate, db: Session = Depends(get_session)):
    player_to_update = db.get(Player, player_id)
    if not player_to_update:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player not found with id: {player_id}",
        )

    team_data = player.model_dump(exclude_unset=True)
    for key, value in team_data.items():
        setattr(player_to_update, key, value)

    db.add(player_to_update)
    db.commit()
    db.refresh(player_to_update)
    return player_to_update


def delete_player(player_id: int, db: Session = Depends(get_session)):
    player = db.get(Player, player_id)
    if not player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player not found with id: {player_id}",
        )

    db.delete(player)
    db.commit()
    return {"ok": True}
