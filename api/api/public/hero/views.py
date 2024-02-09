from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from api.database import get_session
from api.public.hero.crud import (
    create_hero,
    delete_hero,
    read_hero,
    read_heroes,
    update_hero,
)
from api.public.hero.models import HeroCreate, HeroRead, HeroUpdate

router = APIRouter()


@router.post("", response_model=HeroRead)
def create_a_hero(hero: HeroCreate, db: Session = Depends(get_session)):
    return create_hero(hero=hero, db=db)


@router.get("", response_model=list[HeroRead])
def get_heroes(
    offset: int = 0,
    limit: int = Query(default=100, lte=100),
    db: Session = Depends(get_session),
):
    return read_heroes(offset=offset, limit=limit, db=db)


@router.get("/{hero_id}", response_model=HeroRead)
def get_a_hero(hero_id: int, db: Session = Depends(get_session)):
    return read_hero(hero_id=hero_id, db=db)


@router.patch("/{hero_id}", response_model=HeroRead)
def update_a_hero(hero_id: int, hero: HeroUpdate, db: Session = Depends(get_session)):
    return update_hero(hero_id=hero_id, hero=hero, db=db)


@router.delete("/{hero_id}")
def delete_a_hero(hero_id: int, db: Session = Depends(get_session)):
    return delete_hero(hero_id=hero_id, db=db)
