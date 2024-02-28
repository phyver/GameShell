from fastapi import APIRouter

from api.public.player import views as players
from api.public.gamesession import views as gamesessions
from api.public.room import views as rooms

api = APIRouter()


api.include_router(
    gamesessions.router,
    tags=["GameSessions"],
)
api.include_router(
    players.router,
    tags=["Players"],
)
api.include_router(
    rooms.router,
    tags=["Rooms"],
)
