from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException


def parse_integrity_error(error: IntegrityError) -> None:
    print(vars(error.orig))
    if "violates foreign key constraint" in str(error):
        if "room_id" in str(error):
            raise HTTPException(status_code=404, detail="Room not found")
        if "player_id" in str(error):
            raise HTTPException(status_code=404, detail="Player not found")
        if "gamesession_id" in str(error):
            raise HTTPException(status_code=404, detail="GameSession not found")
    raise error
