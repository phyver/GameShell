from sqlmodel import Field, Relationship, SQLModel

from api.utils.generic_models import HeroTeamLink


class TeamBase(SQLModel):
    name: str
    headquarters: str

    class Config:
        json_schema_extra = {
            "example": {
                "name": "wonderful league",
                "headquarters": "Fortress of Solitude",
            }
        }


class Team(TeamBase, table=True):
    id: int | None = Field(default=None, primary_key=True)

    heroes: list["Hero"] = Relationship(back_populates="teams", link_model=HeroTeamLink)  # type: ignore


class TeamCreate(TeamBase):
    pass


class TeamRead(TeamBase):
    id: int
    name: str | None = None
    headquarters: str | None = None
    heroes: list | None = None


class TeamUpdate(TeamBase):
    name: str | None = None
    headquarters: str | None = None
