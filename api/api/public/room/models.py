from typing import Optional, TYPE_CHECKING
from sqlmodel import Field, Relationship, SQLModel

if TYPE_CHECKING:
    from api.public.gamesession.models import GameSession
    from api.public.player.models import Player


class RoomBase(SQLModel):
    name: str


class Room(RoomBase, table=True):
    id: int = Field(default=None, primary_key=True)
    gamesession_id: Optional[int] = Field(default=None, foreign_key="gamesession.id")

    gamesession: Optional["GameSession"] = Relationship(back_populates="rooms")
    players: list["Player"] = Relationship(back_populates="room")


class RoomCreate(RoomBase):
    name: str
    gamesession_id: int


class RoomRead(RoomBase):
    name: str | None = None


class RoomUpdate(RoomBase):
    name: str | None = None
