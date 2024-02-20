from typing import Optional, TYPE_CHECKING
from sqlmodel import Field, Relationship, SQLModel

from api.public.room.models import Room

if TYPE_CHECKING:
    from api.public.gamesession.models import GameSession


class PlayerBase(SQLModel):
    username: str
    progress: str


class Player(PlayerBase, table=True):
    id: int = Field(default=None, primary_key=True)
    room_id: Optional[int] = Field(default=None, foreign_key="room.id")
    gamesession_id: Optional[int] = Field(default=None, foreign_key="gamesession.id")

    room: Optional[Room] = Relationship(back_populates="players")
    gamesession: Optional["GameSession"] = Relationship(back_populates="players")


class PlayerCreate(PlayerBase):
    username: str
    progress: str = "0/100"
    room_id: int
    gamesession_id: int


class PlayerRead(PlayerBase):
    username: str | None = None
    progress: str | None = None


class PlayerUpdate(PlayerBase):
    username: str | None = None
    progress: str | None = None
