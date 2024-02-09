from fastapi import APIRouter, Depends

from api.public.hero import views as heroes
from api.public.team import views as teams

api = APIRouter()


api.include_router(
    heroes.router,
    prefix="/heroes",
    tags=["Heroes"],
)
api.include_router(
    teams.router,
    prefix="/teams",
    tags=["Teams"],
)
