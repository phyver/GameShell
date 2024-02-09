import uvicorn

from api.app import create_app
from api.config import settings

api = create_app(settings)

if __name__ == "__main__":
    uvicorn.run("asgi:api", host="0.0.0.0", port=8080, reload=True)
