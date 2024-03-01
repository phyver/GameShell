from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.room.controller.crud import (
    create_room,
    delete_room,
    read_room,
    read_rooms,
    update_room,
)
from api.public.room.controller.customs import read_rooms_by_gamesession, read_rooms_by_name_and_gamesession
from api.public.room.models import RoomCreate, RoomRead, RoomUpdate

from api.public.gamesession.views import PREFIX as GAMESSESSION_PREFIX

router = APIRouter()
PREFIX = "/rooms"


@router.post(PREFIX, response_model=RoomRead)
def create_a_room(room: RoomCreate, db: Session = Depends(get_session)):
    return create_room(room=room, db=db)


@router.get(PREFIX, response_model=list[RoomRead])
def get_rooms(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_rooms(offset=offset, limit=limit, db=db)


@router.get(PREFIX + "/{room_id}", response_model=RoomRead)
def get_a_room(room_id: int, db: Session = Depends(get_session)):
    return read_room(room_id=room_id, db=db)


@router.patch(PREFIX + "/{room_id}", response_model=RoomRead)
def update_a_room(room_id: int, room: RoomUpdate, db: Session = Depends(get_session)):
    return update_room(room_id=room_id, room=room, db=db)


@router.delete(PREFIX + "/{room_id}")
def delete_a_room(room_id: int, db: Session = Depends(get_session)):
    return delete_room(room_id=room_id, db=db)


@router.get(GAMESSESSION_PREFIX + "/{gamesession_id}/rooms", response_model=list[RoomRead])
def get_gamesession_rooms(gamesession_id: int, name: str = None, db: Session = Depends(get_session)):
    if name:
        return read_rooms_by_name_and_gamesession(gamesession_id=gamesession_id, name=name, db=db)
    return read_rooms_by_gamesession(gamesession_id=gamesession_id, db=db)
