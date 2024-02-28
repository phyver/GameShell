from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select

from api.database import get_session
from api.public.player.models import Player


def read_player_by_name_and_gamesession(gamesession_id: int, username: str, db: Session = Depends(get_session)):
    player = db.exec(
        select(Player).filter(Player.username == username).filter(Player.gamesession_id == gamesession_id)
    ).first()
    if not player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player not found with username: {username}",
        )
    return player
