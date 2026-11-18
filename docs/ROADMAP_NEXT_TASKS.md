# Antigravity Next-Phase Roadmap (`ROADMAP_NEXT_TASKS.md`)

Here are high-value engineering tasks ready for an AI agent session in **Google Antigravity**:

- [x] **Task 1 — Local Bundled 66-Book JSON Loader via Local Bridge (`Port 8765`)**:
  - Implemented 3-tier fallback loader in `ensureBookLoaded(bookId)`: relative `bibles/telugu_ov/`, local bridge `http://localhost:8765/bibles/...`, and GitHub Raw CDN.
  - Downloaded and verified all 67 Telugu OV + 67 English KJV JSON books in `C:\OBS-VakyaCast\bibles\` and `vakyacast-lt-workspace\bibles\`.
  - Updated `scripts/Start-Browser-To-OBS-Bridge.bat` to serve MIME types (`application/json`) with unescaped URL paths.
  - Corrected OBS integration: fixed invalid regex syntax on line 3081, removed literal escaped quotes in OBS browser source URL, set dimensions to 1920x1080, disabled `restart_when_active` to prevent scene transition flashing and `obsCSS` duplicate declaration errors, and synchronized the Bible dock into `global.ini`.
- [ ] **Task 2 — Multi-Verse Auto-Pagination for Long Scripture Ranges**:
  - When presenting a long range like `యోహాను 15:4-15` in `Ref + Telugu OV` mode, add a Verse Pager (`Page 1/6: v4-5`, `Page 2/6: v6-7`) with `Alt + Up / Down` stepping and an optional auto-advance timer.
- [ ] **Task 3 — Two-Way OBS WebSocket 5.x Tally & Scene Auto-Trigger**:
  - Connect to OBS WebSocket (`ws://127.0.0.1:4455`) to show a live green/red Tally indicator when the Bible Lower-Third Browser Source is visible in the active OBS Program scene, and optionally switch to a dedicated Picture Scene when `Show Picture` is clicked.
- [ ] **Task 4 — Optional Vite + React + TypeScript Modular Build**:
  - If transitioning from single-file HTML to a multi-file TypeScript project in Antigravity, split `bible_lower_third_studio.html` into `src/components/`, `src/store/`, and `src/bible-engine/` using `vite-plugin-singlefile` so it still compiles down to a single portable `dist/bible_lower_third_studio.html` for OBS Studio!
