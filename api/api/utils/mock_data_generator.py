from sqlmodel import Session

from api.database import engine
from api.public.hero.models import Hero
from api.public.team.models import Team
from api.utils.logger import logger_config

logger = logger_config(__name__)


def create_heroes_and_teams():
    with Session(engine) as session:
        team_preventers = Team(name="Preventers", headquarters="Sharp Tower")
        team_z_force = Team(name="Z-Force", headquarters="Sister Margaret's Bar")
        wornderful_league = Team(
            name="Wonderful-League", headquarters="Fortress of Solitude"
        )

        hero_deadpond = Hero(
            name="Deadpond",
            secret_name="Dive Wilson",
            age=24,
            teams=[team_z_force, team_preventers],
        )
        hero_rusty_man = Hero(
            name="Rusty-Man",
            secret_name="Tommy Sharp",
            age=48,
            teams=[team_preventers],
        )
        hero_spider_boy = Hero(
            name="Spider-Boy",
            secret_name="Pedro Parqueador",
            age=37,
            teams=[team_preventers],
        )
        hero_super_good_boy = Hero(
            name="Super-Good-Boy",
            secret_name="John Goodman",
            age=30,
            teams=[wornderful_league, team_z_force],
        )

        session.add(hero_deadpond)
        session.add(hero_rusty_man)
        session.add(hero_spider_boy)
        session.add(hero_super_good_boy)
        session.commit()

        session.refresh(hero_deadpond)
        session.refresh(hero_rusty_man)
        session.refresh(hero_spider_boy)
        session.refresh(hero_super_good_boy)

        logger.info("=========== MOCK DATA CREATED ===========")
        logger.info("Deadpond %s", hero_deadpond)
        logger.info("Deadpond teams %s", hero_deadpond.teams)
        logger.info("Rusty-Man %s", hero_rusty_man)
        logger.info("Rusty-Man Teams %s", hero_rusty_man.teams)
        logger.info("Spider-Boy %s", hero_spider_boy)
        logger.info("Spider-Boy Teams %s", hero_spider_boy.teams)
        logger.info("Super-Good-Boy %s", hero_super_good_boy)
        logger.info("Super-Good-Boy Teams: %s", hero_super_good_boy.teams)
        logger.info("===========================================")
