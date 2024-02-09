from fastapi import Depends, HTTPException, status
from sqlmodel import Session, select

from api.database import get_session
from api.public.hero.models import Hero, HeroCreate, HeroUpdate


def create_hero(hero: HeroCreate, db: Session = Depends(get_session)):
    hero_to_db = Hero.model_validate(hero)
    db.add(hero_to_db)
    db.commit()
    db.refresh(hero_to_db)
    return hero_to_db


def read_heroes(offset: int = 0, limit: int = 20, db: Session = Depends(get_session)):
    heroes = db.exec(select(Hero).offset(offset).limit(limit)).all()
    return heroes


def read_hero(hero_id: int, db: Session = Depends(get_session)):
    hero = db.get(Hero, hero_id)
    if not hero:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Hero not found with id: {hero_id}",
        )
    return hero


def update_hero(hero_id: int, hero: HeroUpdate, db: Session = Depends(get_session)):
    hero_to_update = db.get(Hero, hero_id)
    if not hero_to_update:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Hero not found with id: {hero_id}",
        )

    team_data = hero.model_dump(exclude_unset=True)
    for key, value in team_data.items():
        setattr(hero_to_update, key, value)

    db.add(hero_to_update)
    db.commit()
    db.refresh(hero_to_update)
    return hero_to_update


def delete_hero(hero_id: int, db: Session = Depends(get_session)):
    hero = db.get(Hero, hero_id)
    if not hero:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Hero not found with id: {hero_id}",
        )

    db.delete(hero)
    db.commit()
    return {"ok": True}
