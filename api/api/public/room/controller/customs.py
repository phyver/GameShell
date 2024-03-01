from fastapi import Depends
from sqlmodel import Session, select

from api.database import get_session
from api.public.room.models import Room


def read_rooms_by_gamesession(gamesession_id: int, db: Session = Depends(get_session)) -> list[Room]:
    rooms = db.exec(select(Room).filter(Room.gamesession_id == gamesession_id)).all()
    return rooms


def read_rooms_by_name_and_gamesession(gamesession_id: int, name: str, db: Session = Depends(get_session)):
    rooms: list[Room] = read_rooms_by_gamesession(gamesession_id, db)
    rooms = [room for room in rooms if room.name == name]
    return rooms
