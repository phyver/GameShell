from typing import Optional
from sqlmodel import Field, Relationship, SQLModel

from api.public.room.models import Room
from api.public.gamesession.models import GameSession


class PlayerBase(SQLModel):
    username: str
    progress: str

    class Config:
        json_schema_extra = {
            "example": {
                "username": "glox",
                "progress": "0/100",
            }
        }


class Player(PlayerBase, table=True):
    id: int = Field(default=None, primary_key=True)
    room_id: Optional[int] = Field(default=None, foreign_key="room.id")
    gamesession_id: Optional[int] = Field(default=None, foreign_key="gamesession.id")

    room: Optional[Room] = Relationship(back_populates="players")
    gamesession: Optional[GameSession] = Relationship(back_populates="players")
