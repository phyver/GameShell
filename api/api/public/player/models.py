from typing import Optional
from sqlmodel import Field, Relationship, SQLModel

from api.public.room.models import Room


class PlayerBase(SQLModel):
    username: str
    progress: str


class Player(PlayerBase, table=True):
    id: int = Field(default=None, primary_key=True)
    room_id: Optional[int] = Field(default=None, foreign_key="room.id")

    room: Optional[Room] = Relationship(back_populates="players")


class PlayerCreate(PlayerBase):
    username: str
    progress: str = "0/100"
    room_id: int


class PlayerRead(PlayerBase):
    username: str | None = None
    progress: str | None = None


class PlayerUpdate(PlayerBase):
    username: str | None = None
    progress: str | None = None
