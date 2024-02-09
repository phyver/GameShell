from typing import Optional
from sqlmodel import Field, Relationship, SQLModel

from api.public.gamesession.models import GameSession


class RoomBase(SQLModel):
    name: str

    class Config:
        json_schema_extra = {
            "example": {
                "name": "RE-B00-117A",
            }
        }


class Room(RoomBase, table=True):
    id: int = Field(default=None, primary_key=True)
    gamesession_id: Optional[int] = Field(default=None, foreign_key="gamesession.id")

    gamesession: Optional[GameSession] = Relationship(back_populates="rooms")
