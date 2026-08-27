# Grok Zen Master (optional)

Local FastAPI process on `127.0.0.1:4200`. Speaks to official Grok APIs only when `XAI_API_KEY` is set. Without a key it still serves health, flavor context, and a dry-run planner.

```bash
python3 -m venv .venv
.venv/bin/pip install fastapi uvicorn httpx pydantic
export XAI_API_KEY=...          # optional
export FRESHOS_SHARE=/usr/local/share/freshos
./scripts/serve-zen-master.sh
```

Open http://localhost:4200/docs
