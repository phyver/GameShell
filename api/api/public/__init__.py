from fastapi import APIRouter

from api.public.gamesession import views as gamesessions

api = APIRouter()


api.include_router(
    gamesessions.router,
    prefix="/gamesessions",
    tags=["GameSessions"],
)
