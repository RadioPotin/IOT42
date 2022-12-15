from fastapi import FastAPI
from fastapi.responses import FileResponse
import os

app = FastAPI()

@app.get("/")
async def root():
    homepage = os.path.join(os.getcwd(), "app", "home.html")
    return FileResponse(homepage)