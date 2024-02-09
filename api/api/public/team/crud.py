from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select, text

from api.database import get_session
from api.public.team.models import Team, TeamCreate, TeamUpdate


def create_team(team: TeamCreate, db: Session = Depends(get_session)):
    team_to_db = Team.model_validate(team)
    db.add(team_to_db)
    db.commit()
    db.refresh(team_to_db)
    return team_to_db


def read_teams(offset: int = 0, limit: int = 20, db: Session = Depends(get_session)):
    teams = db.exec(select(Team).offset(offset).limit(limit)).all()
    return teams


def read_team(team_id: int, db: Session = Depends(get_session)):
    team = db.get(Team, team_id)
    if not team:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Team not found with id: {team_id}",
        )
    return team


def update_team(team_id: int, team: TeamUpdate, db: Session = Depends(get_session)):
    team_to_update = db.get(Team, team_id)
    if not team_to_update:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Team not found with id: {team_id}",
        )

    team_data = team.model_dump(exclude_unset=True)
    for key, value in team_data.items():
        setattr(team_to_update, key, value)

    db.add(team_to_update)
    db.commit()
    db.refresh(team_to_update)
    return team_to_update


def delete_team(team_id: int, db: Session = Depends(get_session)):
    team = db.get(Team, team_id)
    if not team:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Team not found with id: {team_id}",
        )

    db.delete(team)
    db.commit()
    return {"ok": True}
