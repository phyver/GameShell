from typing import List
from sqlmodel import Field, Relationship, SQLModel

from api.public.room.models import Room
from api.public.player.models import Player


class GameSessionBase(SQLModel):
    uuid: str

    class Config:
        json_schema_extra = {
            "example": {
                "uuid": "123e4567-e89b-12d3-a456-426614174000",
            }
        }


class GameSession(GameSessionBase, table=True):
    id: int = Field(default=None, primary_key=True)

    rooms: List["Room"] = Relationship(back_populates="gamesession")
    players: List["Player"] = Relationship(back_populates="gamesession")


class GameSessionCreate(GameSessionBase):
    pass


class GameSessionRead(GameSessionBase):
    uuid: str | None = None


class GameSessionUpdate(GameSessionBase):
    uuid: str | None = None
