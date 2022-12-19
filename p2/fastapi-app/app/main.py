from fastapi import FastAPI
from fastapi.responses import FileResponse
import os
import sys

app = FastAPI()

@app.get("/")
async def root():
    homepage = os.path.join(os.getcwd(), "app", "home.html")
    return FileResponse(homepage)

@app.get("/500")
async def e500():
    sys.exit(1)