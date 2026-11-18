# VakyaCast LT — Broadcast Bible Lower-Third & Sermon Media Studio

**VakyaCast LT** is a high-speed, keyboard-driven broadcast lower-third and sermon media presentation studio built for **OBS Studio** (`?mode=dock` and `?mode=overlay`) and **Standalone Projection** (`?mode=studio`).

## Quick Start in Google Antigravity

1. **Extract this workspace** and open the folder in **Google Antigravity**.
2. **Agent Context**: Antigravity agents automatically read `AGENTS.md` / `GEMINI.md` / `ANTIGRAVITY_AGENT_HANDOFF.md` at the root of this workspace.
3. **Run Locally**:
   - Open `bible_lower_third_studio.html` directly in Chrome/Edge, OR
   - Run `scripts/Start-Browser-To-OBS-Bridge.bat` on Windows to serve the app on `http://localhost:8765/bible_lower_third_studio.html` with real-time cross-browser sync to OBS Studio.
4. **Cache All 66 Books Offline**:
   - Click **`Bible DB (OV+KJV)`** in the top header and click **`Sync All 66 Books Offline Now (Telugu OV + KJV)`**, OR
   - Run `scripts/Download-Full-Bibles-Offline.bat` to download all 66 Telugu O.V. (BSI) and 66 English KJV JSON files into `C:\OBS-VakyaCast\bibles\` and import them via **`Import Local Bible JSON / XML`**.

## Documentation Index

- [`ANTIGRAVITY_AGENT_HANDOFF.md`](./ANTIGRAVITY_AGENT_HANDOFF.md) — Complete project history (Phases 1–9), architectural decisions, and agent guardrails.
- [`docs/PRODUCT_VISION.md`](./docs/PRODUCT_VISION.md) — User stories, live church production workflows, and feature specifications.
- [`docs/ARCHITECTURE_AND_STATE.md`](./docs/ARCHITECTURE_AND_STATE.md) — State schema, multi-channel sync protocols, and DOM rendering pipeline.
- [`docs/BIBLE_ENGINE_SPEC.md`](./docs/BIBLE_ENGINE_SPEC.md) — Telugu O.V. (BSI) & English KJV schemas, concordance search, word highlighting, and part-verse slicing.
- [`docs/UI_AND_MOTION_SYSTEM.md`](./docs/UI_AND_MOTION_SYSTEM.md) — Monochrome UI tokens, Telugu OpenType typography, and GSAP motion templates.
- [`docs/ROADMAP_NEXT_TASKS.md`](./docs/ROADMAP_NEXT_TASKS.md) — Prioritized next tasks for Antigravity agents.
