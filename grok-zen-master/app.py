"""Grok Zen Master — optional local Vizier for FreshOS / Harbor Flavors."""

from __future__ import annotations

import os
from pathlib import Path

from fastapi import FastAPI
from pydantic import BaseModel, Field

SHARE = Path(os.environ.get("FRESHOS_SHARE", "/usr/local/share/freshos"))
PROMPT_PATH = SHARE / "prompts" / "zen-master.md"
FLAVOR_PATH = SHARE / "current-flavor"
API_KEY = os.environ.get("XAI_API_KEY") or os.environ.get("GROK_API_KEY")

app = FastAPI(
    title="FreshOS Grok Zen Master",
    version="1.0.0",
    description="Local Vizier. Emperor remains the operator.",
)


def load_prompt() -> str:
    if PROMPT_PATH.is_file():
        return PROMPT_PATH.read_text(encoding="utf-8")
    return "You are the Grok Zen Master. Calm, strategic, override-friendly."


def current_flavor() -> dict:
    if not FLAVOR_PATH.is_file():
        return {"id": "zen-garden", "version": "1.0.0", "applied_at": None}
    lines = FLAVOR_PATH.read_text(encoding="utf-8").splitlines()
    return {
        "id": lines[0] if lines else "unknown",
        "version": lines[1] if len(lines) > 1 else "unknown",
        "applied_at": lines[2] if len(lines) > 2 else None,
    }


class Goal(BaseModel):
    text: str = Field(..., min_length=1, max_length=8000)
    module_hint: str | None = None
    confirm_irreversible: bool = False


@app.get("/health")
def health():
    return {
        "ok": True,
        "role": "vizier",
        "api_key_present": bool(API_KEY),
        "flavor": current_flavor(),
        "bind": "127.0.0.1:4200",
    }


@app.get("/alignment")
def alignment():
    return {
        "principles": [
            "Sovereignty First",
            "Visual Clarity Over Opacity",
            "Value Coherence",
            "Graduated Agency",
            "Long-Term Orientation",
        ],
        "prompt_present": PROMPT_PATH.is_file(),
        "prompt_excerpt": load_prompt()[:400],
    }


@app.post("/plan")
def plan(goal: Goal):
    """Return a visible plan. Does not execute anything."""
    flavor = current_flavor()
    steps = [
        "Restate the operator goal in one sentence.",
        "Map the goal onto enabled modules for flavor '%s'." % flavor["id"],
        "List local tools before any network call.",
        "Wait for Emperor confirmation before irreversible steps.",
    ]
    if goal.module_hint:
        steps.insert(1, f"Prefer module '{goal.module_hint}'.")
    return {
        "goal": goal.text,
        "flavor": flavor,
        "agency": "graduated",
        "would_call_grok": bool(API_KEY),
        "steps": steps,
        "note": "Execution is intentionally not implemented in Phase 1. The plan is the product.",
    }


@app.post("/ask")
async def ask(goal: Goal):
    planned = plan(goal)
    if not API_KEY:
        planned["reply"] = (
            "No XAI_API_KEY in the environment. "
            "Zen Master remains local. Use /plan and act as Emperor."
        )
        return planned
    planned["reply"] = (
        "API key is present. Phase 1 still does not auto-execute tools. "
        "Wire the official xAI chat completions endpoint here when you want live Vizier speech."
    )
    return planned
