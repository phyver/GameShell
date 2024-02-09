from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.team.crud import (
    create_team,
    delete_team,
    read_team,
    read_teams,
    update_team,
)
from api.public.team.models import TeamCreate, TeamRead, TeamUpdate
from api.utils.logger import logger_config

router = APIRouter()

logger = logger_config(__name__)


@router.post("", response_model=TeamRead)
def create_a_team(team: TeamCreate, db: Session = Depends(get_session)):
    logger.info("%s.create_a_team: %s", __name__, team)
    return create_team(team=team, db=db)


@router.get("", response_model=list[TeamRead])
def get_teams(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    logger.info("%s.get_teams: triggered", __name__)
    return read_teams(offset=offset, limit=limit, db=db)


@router.get("/{team_id}", response_model=TeamRead)
def get_a_team(team_id: int, db: Session = Depends(get_session)):
    logger.info("%s.get_a_team.id: %s", __name__, team_id)
    return read_team(team_id=team_id, db=db)


@router.patch("/{team_id}", response_model=TeamRead)
def update_a_team(team_id: int, team: TeamUpdate, db: Session = Depends(get_session)):
    logger.info("%s.update_a_team.id: %s", __name__, team_id)
    return update_team(team_id=team_id, team=team, db=db)


@router.delete("/{team_id}")
def delete_a_team(team_id: int, db: Session = Depends(get_session)):
    logger.info("%s.delete_a_team: %s triggered", __name__, team_id)
    return delete_team(team_id=team_id, db=db)
