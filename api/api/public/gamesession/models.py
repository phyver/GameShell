from typing import List

from sqlmodel import Field, Relationship, SQLModel

from api.public.room.models import Room


class GameSessionBase(SQLModel):
    name: str
    author: str


class GameSession(GameSessionBase, table=True):
    id: int = Field(default=None, primary_key=True)
    name: str = Field(max_length=30, unique=True)
    author: str = Field(max_length=50)

    rooms: List["Room"] = Relationship(back_populates="gamesession")


class GameSessionCreate(GameSessionBase):
    pass


class GameSessionRead(GameSessionBase):
    id: int


class GameSessionUpdate(GameSessionBase):
    name: None | str = None
    author: None | str = None
