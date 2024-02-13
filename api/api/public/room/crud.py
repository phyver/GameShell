from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select

from api.database import get_session
from api.public.room.models import Room, RoomCreate, RoomUpdate


def create_room(room: RoomCreate, db: Session = Depends(get_session)):
    room_to_db = Room.model_validate(room)
    db.add(room_to_db)
    db.commit()
    db.refresh(room_to_db)
    return room_to_db


def read_rooms(offset: int = 0, limit: int = 20, db: Session = Depends(get_session)):
    rooms = db.exec(select(Room).offset(offset).limit(limit)).all()
    return rooms


def read_room(room_id: int, db: Session = Depends(get_session)):
    room = db.get(Room, room_id)
    if not room:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Room not found with id: {room_id}",
        )
    return room


def update_room(room_id: int, room: RoomUpdate, db: Session = Depends(get_session)):
    room_to_update = db.get(Room, room_id)
    if not room_to_update:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Room not found with id: {room_id}",
        )

    team_data = room.model_dump(exclude_unset=True)
    for key, value in team_data.items():
        setattr(room_to_update, key, value)

    db.add(room_to_update)
    db.commit()
    db.refresh(room_to_update)
    return room_to_update


def delete_room(room_id: int, db: Session = Depends(get_session)):
    room = db.get(Room, room_id)
    if not room:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Room not found with id: {room_id}",
        )

    db.delete(room)
    db.commit()
    return {"ok": True}
