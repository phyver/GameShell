from typing import List

import uuid as uuid_pkg
from sqlmodel import Field, Relationship, SQLModel

from api.public.room.models import Room
from api.public.player.models import Player


class GameSessionBase(SQLModel):
    pass


class GameSession(GameSessionBase, table=True):
    id: int = Field(default=None, primary_key=True)
    uuid: str = Field(
        default_factory=lambda: str(uuid_pkg.uuid4()),
        nullable=False,
    )

    rooms: List["Room"] = Relationship(back_populates="gamesession")
    players: List["Player"] = Relationship(back_populates="gamesession")


class GameSessionCreate(GameSessionBase):
    pass


class GameSessionRead(GameSessionBase):
    uuid: str | None = None


class GameSessionUpdate(GameSessionBase):
    uuid: str | None = None
