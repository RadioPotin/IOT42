from fastapi import FastAPI
from fastapi.responses import FileResponse

app = FastAPI()

@app.get("/")
async def root():
    homepage = "home.html"
    return FileResponse(homepage)