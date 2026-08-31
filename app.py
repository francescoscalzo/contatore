import math
from pathlib import Path as FilePath

from fastapi import FastAPI, HTTPException, Path
from fastapi.responses import FileResponse

app = FastAPI()

INDEX_HTML = FilePath(__file__).parent / "index.html"


@app.get("/")
def serve_index() -> FileResponse:
    return FileResponse(INDEX_HTML)


@app.get("/compute/{n}")
def compute(n: int = Path(ge=0)) -> dict[str, float]:
    try:
        return {
            "sqrt": round(math.sqrt(n), 2),
            "square": round(n**2, 2),
            "times_pi": round(n * math.pi, 2),
        }
    except OverflowError as exc:
        raise HTTPException(status_code=400, detail="n troppo grande per il calcolo") from exc
