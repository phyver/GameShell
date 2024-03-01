from fastapi import Depends
from sqlmodel import Session, select

from api.database import get_session
from api.public.player.models import Player
from api.public.room.models import Room


def read_players_by_gamesession(gamesession_id: int, db: Session = Depends(get_session)):
    gamesession_rooms = db.exec(select(Room).filter(Room.gamesession_id == gamesession_id)).all()
    players = []
    for room in gamesession_rooms:
        players.extend(db.exec(select(Player).filter(Player.room_id == room.id)).all())
    return players


def read_player_by_name_and_gamesession(gamesession_id: int, username: str, db: Session = Depends(get_session)):
    players = read_players_by_gamesession(gamesession_id, db)
    player = [player for player in players if player.username == username]
    return player
