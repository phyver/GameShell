from sqlmodel import Field, Relationship, SQLModel

from api.public.team.models import Team
from api.utils.generic_models import HeroTeamLink


class HeroBase(SQLModel):
    name: str
    secret_name: str
    age: int | None = None

    class Config:
        json_schema_extra = {
            "example": {
                "id": 1,
                "name": "Super Man",
                "secret_name": "Clark Kent",
                "age": 27,
                "team_id": 1,
            }
        }


class Hero(HeroBase, table=True):
    id: int | None = Field(default=None, primary_key=True)
    teams: list[Team] = Relationship(back_populates="heroes", link_model=HeroTeamLink)


class HeroCreate(HeroBase):
    pass


class HeroRead(HeroBase):
    id: int
    name: str | None = None
    secret_name: str | None = None
    age: int | None = None
    teams: list[Team] = None


class HeroUpdate(HeroBase):
    name: str | None = None
    secret_name: str | None = None
    age: int | None = None
    teams: list[Team] = None

    class Config:
        json_schema_extra = {
            "example": {
                "name": "Super Man",
                "secret_name": "Clark Kent",
                "age": 27,
                "team_id": 1,
            }
        }
