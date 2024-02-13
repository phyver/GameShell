from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.room.crud import (
    create_room,
    delete_room,
    read_room,
    read_rooms,
    update_room,
)
from api.public.room.models import RoomCreate, RoomRead, RoomUpdate

router = APIRouter()


@router.post("", response_model=RoomRead)
def create_a_room(room: RoomCreate, db: Session = Depends(get_session)):
    return create_room(room=room, db=db)


@router.get("", response_model=list[RoomRead])
def get_rooms(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_rooms(offset=offset, limit=limit, db=db)


@router.get("/{room_id}", response_model=RoomRead)
def get_a_room(room_id: int, db: Session = Depends(get_session)):
    return read_room(room_id=room_id, db=db)


@router.patch("/{room_id}", response_model=RoomRead)
def update_a_room(room_id: int, room: RoomUpdate, db: Session = Depends(get_session)):
    return update_room(room_id=room_id, room=room, db=db)


@router.delete("/{room_id}")
def delete_a_room(room_id: int, db: Session = Depends(get_session)):
    return delete_room(room_id=room_id, db=db)
