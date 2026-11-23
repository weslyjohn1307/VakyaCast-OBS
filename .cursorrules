# VakyaCast LT — Complete Project Context & Agent Handoff Guide (Google Antigravity)

> **Purpose of this Document**: This is the authoritative, end-to-end engineering handoff and context memory for **VakyaCast LT** (Bible Lower-Third & Live Sermon Media Broadcast System for OBS Studio & Standalone Presentation). Drop this repository into **Google Antigravity** (or pass this file as the initial context prompt to a fresh Antigravity agent session) so new agents immediately understand the full chronological history, architectural decisions, exact data schemas, Telugu OpenType typography rules, OBS synchronization protocols, and anti-slop UI constraints without losing a single detail.

---

## 1. Project Identity & Core Objective

- **Project Name**: **VakyaCast LT** (`bible_lower_third_studio.html`)
- **Primary Operator / Architect Context**: Engineered for **Wesly John** (Civil Engineer, Graphic Designer, Telugu Typography & OpenType specialist, and Live OBS Broadcast Engineer).
- **Core Problem Solved**:
  - Church/sermon broadcast operators need an ultra-fast, keyboard-first lower-third presentation system that runs **inside OBS Studio** (as a Custom Browser Dock + Transparent 1080p Browser Source overlay) **and outside OBS** (as a standalone Chrome/Edge control deck or pop-out projection window).
  - Must support **66-Book Multilingual Bible Citations** (`యోహాను 15:4`, `యోహాను 15:4-15`), **Whole Chapter Mode without verse picking** (`యోహాను సువార్త 12వ అధ్యాయము`), **Full Bilingual Bible Text** (**Telugu O.V. Bible BSI — పరిశుద్ధ గ్రంథము** + **English 1769 King James Version KJV**), **Separated Full-Bible Concordance Search (`Ctrl+F`)**, **Part-of-Verse Word Highlighting**, **Present Part-Verse Only (Clause/Fragment Slicing)**, **Reference + Verse Lower-Third Layouts**, and **Instant Sermon Picture / Missionary Slide-Over Presentation** (`Ctrl+V` clipboard paste, Wikipedia API lookup, local image upload, and OBS WebSocket scene switching).

---

## 2. Chronological Evolution & Decisions (Turns 1 to 9)

Every feature in `bible_lower_third_studio.html` was built iteratively across 9 phases. **Never regress or remove any of these capabilities when editing or refactoring:**

### Phase 1 — Core 66-Book Multilingual Lower-Third Presenter
- Built a zero-dependency, single-file HTML5 broadcast studio inspired by [Animated Lower Thirds with Dockable Control Panel](https://obsproject.com/forum/resources/animated-lower-thirds-with-dockable-control-panel.1057/) ([GitHub: `noeal-dac/Animated-Lower-Thirds`](https://github.com/noeal-dac/Animated-Lower-Thirds)).
- Embedded complete 66-book metadata (`BIBLE_BOOKS`) with exact chapter counts, verse counts per chapter (`verses: [...]`), and book titles in:
  1. **Telugu Concise (`te`)**: e.g., `యోహాను 15:4` or `యోహాను 15:4-15`
  2. **Telugu Full Traditional (`te_full`)**: e.g., `యోహాను సువార్త 15:4`
  3. **English (`en`)**: e.g., `John 15:4`
  4. **Hindi (`hi`)**: e.g., `यूहन्ना 15:4`
  5. **Tamil (`ta`)**: e.g., `யோவான் 15:4`
  6. **Custom Dialect/Language (`custom`)**: User-editable 66-book mapping persisted in `localStorage`.
- Built the `/` **Quick Reference Omnibox** (`#quickCommandInput`) supporting fuzzy phonetic/Tanglish and native script parsing (`yoh 15:4`, `yoh 15:4-15`, `jn 15 4 15`, `ps 23:1-6`, `యోహాను 15:4-15`).

### Phase 2 — Whole Chapter Presentation Mode & 1-Click OBS Auto-Setup
- Added **Whole Chapter Mode (`state.wholeChapter = true`)** so when a pastor announces an entire chapter without a verse number, clicking any Chapter cell, pressing `C`, clicking `📖 Whole Ch (C)`, or typing `yoh 12` in the `/` bar formats the citation naturally as:
  - Telugu: **`యోహాను సువార్త 12వ అధ్యాయము`**
  - English: **`John Chapter 12`**
  - Hindi: **`यूहन्ना अध्याय 12`**
  - Tamil: **`யோவான் 12-ம் அதிகாரம்`**
- Created automated Windows/macOS/Linux setup scripts (`Setup-VakyaCast-OBS.bat`, `setup_vakyacast_obs.sh`) that install to `C:\OBS-VakyaCast\`, generate `obs_dock.html` and `obs_overlay.html`, create `VakyaCast-OBS-Scene-Import.json`, and copy `file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock` to the clipboard.

### Phase 3 — Cross-Browser HTTP Sync Bridge (`Port 8765`)
- **Problem**: OBS Studio's embedded CEF (Chromium Embedded Framework) uses an isolated browser storage partition, so `BroadcastChannel` and `localStorage` inside Chrome/Edge cannot directly reach an OBS `file://` Browser Source unless bridged.
- **Solution**: Created `Start-Browser-To-OBS-Bridge.bat`, a zero-install Windows PowerShell `System.Net.HttpListener` microservice on `http://127.0.0.1:8765` with `/sync` (`POST`) and `/state` (`GET` every 250ms), enabling operators to control OBS from external Chrome, Edge, Firefox, or a tablet/phone on the LAN.

### Phase 4 — Unobstructed Omnibox & Multi-Aspect Responsive OBS Dock
- Removed any floating preview badge inside `#quickCommandInput` so typed characters are never obstructed.
- Added `📐 Dock View` (`body.dock-compact-mode`) and CSS media queries (`@media (max-height: 560px)`, `.adaptive-num-grid`) so the 3-column cascading picker (`1. Book | 2. Ch | 3. Verse`) remains side-by-side in narrow vertical docks, wide bottom docks, and full studio views.

### Phase 5 — Clean Replacement & Uninstaller Scripts
- Added `Uninstall-Previous-Setup.bat` to cleanly wipe old `C:\OBS-VakyaCast` files and desktop shortcuts before installing updates.

### Phase 6 — High-Craft Broadcast Templates, GSAP Motion & Telugu Font Studio
- Upgraded motion choreography using [GSAP 3.12.5](https://gsap.com/) and multi-stage CSS cubic-bezier curves (`lt-stage-bar`, `lt-stage-book`, `lt-stage-badge`, `lt-stage-sub`, `lt-stage-verse`).
- Added **10 Broadcast Architecture Templates** (`royal_gold`, `sacred_crimson`, `minimal_glass`, `clean_light`, `emerald_sanctuary`, `pure_minimal`, `beam_21st`, `ae_ribbon`, `obsidian_hud`, `swiss_grid`).
- Integrated **Telugu Font Studio**:
  - Loaded Google Fonts for `Anek Telugu` (with variable weight `300..800` and width `75..125`), `Ramabhadra`, `Suranna`, `Noto Sans Telugu`, `Noto Serif Telugu`, `Mandali`, `NTR`, `Mallanna`, `Sree Krushnadevaraya`, `Tenali Ramakrishna`, `Timmana`, and `Gidugu`.
  - Added `window.queryLocalFonts()` PC font enumeration (`#btnScanLocalPcFonts`) and direct `.ttf` / `.otf` / `.woff2` binary `FontFace` file loader (`#inputCustomFontFile`).

### Phase 7 — Zero-Flash OBS Scene Transition Fix & Sermon Picture Slide-Over Presenter
- **Bug Fixed**: Previously, when switching scenes or transitioning from Preview to Program in OBS Studio, the Browser Source overlay briefly flashed visible even when not live because `state.isLive` defaulted to `true` and `.lt-hidden` only used `opacity: 0`.
- **Engineering Fix**:
  1. When URL has `?mode=overlay`, `state.isLive` strictly initializes to `false` (unless `localStorage` explicitly holds an active live state) and `?mode=overlay` instances are **read-only consumers** that never call `broadcastStateToOverlays()`.
  2. `.lt-wrapper.lt-hidden` and `.media-overlay-wrapper.media-hidden` enforce `visibility: hidden; opacity: 0; pointer-events: none;`.
- **Sermon Picture / Missionary Slide-Over Presenter (`#panelMedia`)**:
  - Built for mid-sermon image requests (e.g., showing a missionary like *William Carey*, a map, or a situation photo without leaving the control deck).
  - Supports **Global `Ctrl+V` Clipboard Image Paste**, **Local Image Upload**, **Wikipedia REST API Image Fetch** (`https://en.wikipedia.org/api/rest_v1/page/summary/<query>`), and 4 broadcast slide-over layouts (`slide_right`, `slide_left`, `news_ots`, `center_spotlight`).

### Phase 8 — Monochrome `coss.com/ui` + `shadcn/ui` + `unslop` UI Engineering
- Applied strict monochrome Zinc-950 (`#09090b` / `#0f0f12` / `#18181b`) surfaces, crisp `1px` `rgba(255,255,255,0.075)` borders, high-density studio controls, and reference architectures from the user's Google Keep notes (`Ultimate Free UI Component Libraries & Gap-Fill Directory (2026)` and `Intake of All`), drawing from [React Bits](https://reactbits.dev/) ([GitHub](https://github.com/DavidHDev/react-bits)), [Motion Primitives](https://motion-primitives.com/) ([GitHub](https://github.com/ibelick/motion-primitives)), [Magic UI](https://magicui.design/docs/components) ([GitHub](https://github.com/magicuidesign/magicui)), [Subframe Motion](https://www.subframe.com/motion), [beUI](https://beui.dev/components/motion), [UI Motion](https://uimotion.fyi/docs), [Opus Motion Library](https://github.com/GovinduSasanka/opus-motion-library), [XSplit Lower Thirds](https://github.com/Zettersten/xsplit-lowerthirds), and [LowerThird OBS](https://github.com/rse/lowerthird).

### Phase 9 — Full Bilingual Bible Engine (Telugu OV BSI + English KJV), Concordance Search (`Ctrl+F`), Part-Verse Highlighting & Part-Verse Slicing
- **Full 66-Book Bilingual Bible Engine**:
  - **Telugu Translation**: **పరిశుద్ధ గ్రంథము (O.V. Bible — Published by the Bible Society of India)** sourced from [`aruljohn/Bible-telugu`](https://github.com/aruljohn/Bible-telugu) (`https://raw.githubusercontent.com/aruljohn/Bible-telugu/main/<Book>.json`).
  - **English Translation**: **1769 King James Version (KJV)** sourced from [`aruljohn/Bible-kjv`](https://github.com/aruljohn/Bible-kjv) (`https://raw.githubusercontent.com/aruljohn/Bible-kjv/master/<Book>.json`).
  - **Hybrid Storage (`IndexedDB` + Pre-Bundled Corpus + Local JSON/XML Import)**:
    - Pre-bundles core high-frequency sermon chapters inline (`BUILTIN_BIBLE_CORPUS`) for instant zero-latency startup.
    - Automatically fetches any selected book from GitHub Raw CDN and caches it permanently in browser `IndexedDB` (`VakyaCastBibleDB_v1`).
    - Includes a 1-click **"Sync All 66 Books Offline Now (Telugu OV + KJV)"** progress modal (`#bibleSyncModal`), an offline `.bat` downloader (`Download-Full-Bibles-Offline.bat`), and a multi-format local JSON importer (`#inputImportBibleFiles`) supporting [`aruljohn/Bible-telugu`](https://github.com/aruljohn/Bible-telugu), [`aruljohn/Bible-kjv`](https://github.com/aruljohn/Bible-kjv), and [`godlytalias/Bible-Database`](https://github.com/godlytalias/Bible-Database/blob/master/Telugu/bible.json).
- **Requirement 1 — Separated Full-Bible Concordance Search (`Ctrl+F`)**:
  - Strictly separated from `/` Quick Reference search.
  - Supports Telugu script (`ప్రేమించెను`, `ద్రాక్షావల్లి`, `కాపరి`), English KJV (`abide in me`, `shepherd`), multi-word AND queries, `"exact phrase"` matching, scope filters (`ALL`, `OT`, `NT`, `BOOK`), version filters (`BOTH`, `TE`, `EN`), and a **Phonetic Tanglish-to-Telugu Dictionary (`PHONETIC_TE_KEYWORDS`)** so typing `preminchenu`, `kaapari`, `yehova`, `krupa`, or `vishwasamu` matches Telugu O.V. verses directly.
- **Requirement 2 — Part-of-Verse Highlighting (`workbenchActionMode: 'highlight'`)**:
  - Interactive word-token clickers (`#teluguWordTokensContainer`, `#englishWordTokensContainer`) allow clicking or `Shift+Clicking` any words or clause chip (`Part a`, `Part b`, `Part c`) to wrap those words in an animated broadcast marker (`<mark class="lt-word-highlight lt-hl-gold">`) inside the full verse on air.
  - Includes 4 broadcast marker styles: `Gold Marker` (`lt-hl-gold`), `Cyan Glow` (`lt-hl-cyan`), `Emerald Underline` (`lt-hl-emerald`), and `Crimson Accent` (`lt-hl-crimson`).
- **Requirement 3 — Present Part-Verse Only (`workbenchActionMode: 'part_only'`)**:
  - Slices and presents **only** the selected words or punctuation clause (`Part a`, `Part b`, `Part c`, `Part d`) on the lower-third rather than the entire verse.
  - Automatically adds leading/trailing `…` ellipsis indicators when a mid-verse fragment is presented, enlarges the lower-third font size dynamically for short clauses, optionally appends the clause letter to the citation badge (`యోహాను 15:4a` / `John 15:4a`), and supports live on-air clause stepping via **`Alt + ←`** and **`Alt + →`**.
- **Requirement 4 — Reference + Bible Verse Lower-Third Layouts (`state.ltDisplayMode`)**:
  - 4 instant layout modes right in the composer bar:
    1. `ref_only`: Compact Reference Badge Only (`యోహాను 15:4` or `యోహాను సువార్త 12వ అధ్యాయము`)
    2. `ref_te`: Reference Header + **Telugu O.V. (BSI)** Verse Plate
    3. `ref_en`: Reference Header + **English KJV** Verse Plate
    4. `ref_dual`: Reference Header + **Parallel Bilingual (Telugu O.V. + English KJV)** Stacked Plates

### Phase 10 — OBS Production Integration Fix & Offline 66-Book Corpus
- **Diagnosed and corrected 5 OBS Studio configuration and runtime issues**:
  1. Fixed broken regex escaping on line 3081 (`/[.*+?^${}()|[\]\\]/g`) that previously threw `Uncaught SyntaxError: Invalid regular expression: missing /` on load in OBS CEF.
  2. Fixed literal escaped quotation marks in OBS Browser Source setting (`"\"C:\OBS-VakyaCast\obs_overlay.html\""` -> `"file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=overlay"`).
  3. Corrected Browser Source width from `1980` to standard `1920` (1080p).
  4. Disabled `restart_when_active` (`restart_when_active: false`, `shutdown: false`) in OBS scene configuration to eliminate scene switch reloading, lag, and CEF duplicate `obsCSS` injection crashes (`Identifier 'obsCSS' has already been declared`).
  5. Synchronized Custom Browser Docks between `global.ini` and `user.ini` so the `Bible` dock is persistently registered.
- **Offline 66-Book Telugu OV + English KJV Corpus Installed**:
  - Downloaded and verified all 67 Telugu OV + 67 English KJV JSON books into `C:\OBS-VakyaCast\bibles\` and `vakyacast-lt-workspace\bibles\`.
  - Added 3-tier offline book resolution in `ensureBookLoaded(bookId)`: relative `bibles/`, local bridge `http://localhost:8765/bibles/`, and GitHub Raw fallback.
  - Bidirectional HTTP sync bridge listener enables `file:///` OBS overlay to receive updates from external Chrome/Edge controllers on port 8765 with zero configuration.

---

## 3. Repository Directory Structure (For Google Antigravity)

```text
vakyacast-lt-workspace/
├── ANTIGRAVITY_AGENT_HANDOFF.md   # Master context & system instructions for Antigravity AI agents
├── AGENTS.md                      # Auto-loaded agent rules for Google Antigravity / Cursor / Cline
├── .cursorrules                   # IDE rules mirror for multi-agent compatibility
├── README.md                      # Operator & Developer Quickstart Guide
├── bible_lower_third_studio.html  # Production Single-File Broadcast Application (Dock + Overlay + Studio)
├── src/
│   └── bible_lower_third_studio.html
├── docs/
│   ├── PRODUCT_VISION.md          # Complete user stories & broadcast requirements (Phases 1-9)
│   ├── ARCHITECTURE_AND_STATE.md  # State model, Sync protocols, IndexedDB & DOM architecture
│   ├── BIBLE_ENGINE_SPEC.md       # Telugu OV (BSI) & English KJV JSON schemas & clause/word algorithms
│   ├── UI_AND_MOTION_SYSTEM.md    # Monochrome UI rules, Telugu OpenType fonts & GSAP choreography
│   └── ROADMAP_NEXT_TASKS.md      # Next-stage engineering backlog for Antigravity agents
├── scripts/
│   ├── Setup-VakyaCast-OBS.bat            # 1-Click Windows installer to C:\OBS-VakyaCast
│   ├── Uninstall-Previous-Setup.bat       # Clean uninstaller for previous versions
│   ├── Start-Browser-To-OBS-Bridge.bat    # Port 8765 HTTP Sync Bridge for Chrome/Edge -> OBS
│   ├── Download-Full-Bibles-Offline.bat   # Downloads all 66 Telugu OV + 66 English KJV JSONs offline
│   └── setup_vakyacast_obs.sh             # macOS / Linux installer script
└── obs/
    ├── obs_dock.html                      # Redirect wrapper for ?mode=dock
    ├── obs_overlay.html                   # Redirect wrapper for ?mode=overlay
    └── VakyaCast-OBS-Scene-Import.json    # Ready-to-import OBS 1080p60 Browser Source scene collection
```

---

## 4. Technical Architecture & State Payload Specification

### 4.1 URL Operating Modes
The single file `bible_lower_third_studio.html` adapts its UI based on the `?mode=` query parameter:
1. **Studio Split View (`?mode=studio` or no parameter)**: Displays the full 12-column operator interface (Left 7 cols: Composer, Lower-Third Mode Bar, Concordance Search Drawer, Interactive Verse Workbench, and 3-Column Book/Chapter/Verse Picker; Right 5 cols: 16:9 Live Output Monitor + Queue/Style/Picture/Custom-Book tabs).
2. **OBS Compact Dock Mode (`?mode=dock`)**: Adds `body.dock-compact-mode`, hiding the 16:9 stage monitor so the picker and workbench fit comfortably inside narrow vertical or short bottom OBS Custom Browser Docks.
3. **OBS Transparent Overlay Mode (`?mode=overlay`)**: Adds `body.obs-overlay-mode`, hides `#appRoot`, shows `#pureOverlayRoot` on a `rgba(0,0,0,0)` transparent canvas, initializes `state.isLive = false` (preventing scene-switch flashes), and listens passively for sync payloads.

### 4.2 Real-Time Synchronization Payload (`STORAGE_KEY_STATE = 'vakyacast_lt_live_state_v1'`)
Every state change in the control panel broadcasts a JSON payload across:
1. **`BroadcastChannel('vakyacast_bible_lt_channel')`** (instant same-browser-engine sync)
2. **`localStorage.setItem('vakyacast_lt_live_state_v1', JSON.stringify(payload))`** (`storage` event listener)
3. **`popoutWindowRef.postMessage({ type: 'VAKYACAST_SYNC', payload }, '*')`** (standalone projector window sync)
4. **`http://localhost:8765/sync` (`POST`) / `/state` (`GET`)** (when running on the Cross-Browser Bridge port `8765`)

```json
{
  "bookId": 43,
  "chapter": 15,
  "verseStart": 4,
  "verseEnd": null,
  "wholeChapter": false,
  "customOverride": "",
  "isLive": true,
  "lang": "te",
  "showBilingual": false,
  "theme": "royal_gold",
  "position": "bottom-left",
  "animStyle": "ae_stagger",
  "fontFamily": "anek",
  "fontWeight": "800",
  "customFontFamilyName": "",
  "scalePercent": 105,
  "showBibleIcon": true,
  "ltDisplayMode": "ref_te",
  "workbenchActionMode": "highlight",
  "highlightColor": "gold",
  "selectedTeWordIndices": [0, 1],
  "selectedEnWordIndices": [0, 1, 2],
  "activeClauseIndex": 0,
  "appendClauseLetter": true,
  "mediaIsLive": false,
  "mediaTitle": "William Carey (1761–1834)",
  "mediaSubtitle": "Pioneer Bible Translator — Serampore Mission",
  "mediaImageSrc": "data:image/svg+xml;utf8,...",
  "mediaLayout": "slide_right",
  "timestamp": 1763216400000
}
```

### 4.3 External Bible JSON Schemas & Edge Cases Handled
1. **Telugu O.V. Bible (BSI) — [`aruljohn/Bible-telugu`](https://github.com/aruljohn/Bible-telugu)**:
   - Raw URL pattern: `https://raw.githubusercontent.com/aruljohn/Bible-telugu/main/<Book>.json`
   - **Critical Edge Case Handled**: Book #22 is named `Song of Songs.json` in `aruljohn/Bible-telugu`, whereas it is named `Song of Solomon.json` in `aruljohn/Bible-kjv`. `ensureBookLoaded(bookId)` explicitly maps `book.id === 22` to `'Song of Songs'` for Telugu and `'Song of Solomon'` for English.
   - Schema:
     ```json
     {
       "book": { "english": "John", "telugu": "యోహాను సువార్త" },
       "count": "21",
       "chapters": [
         {
           "chapter": "15",
           "verses": [
             { "verse": "4", "text": "నాయందు నిలిచియుండుడి, మీయందు నేనును నిలిచియుందును..." }
           ]
         }
       ]
     }
     ```
2. **English King James Version (KJV) — [`aruljohn/Bible-kjv`](https://github.com/aruljohn/Bible-kjv)**:
   - Raw URL pattern: `https://raw.githubusercontent.com/aruljohn/Bible-kjv/master/<Book>.json`
   - Schema: `{ "book": "John", "chapter-count": "21", "chapters": [ { "chapter": "15", "verses": [ { "verse": "4", "text": "Abide in me, and I in you..." } ] } ] }`.
3. **Single-File Whole Bible Importer (`#inputImportBibleFiles`)**:
   - Auto-detects both `aruljohn` per-book JSONs and [`godlytalias/Bible-Database`](https://github.com/godlytalias/Bible-Database/blob/master/Telugu/bible.json) whole-Bible `bible.json` (`{ "Book": [ { "Chapter": [ { "Verse": [ { "Verse": "..." } ] } ] } ] }`) and stores all 66 books into `IndexedDB` (`VakyaCastBibleDB_v1`, object store `'books'`, key `'te_<bookId>'` and `'en_<bookId>'`).

---

## 5. Strict Guardrails for Antigravity Agents

When continuing development in Google Antigravity, all agents MUST obey these 7 engineering rules:
1. **Preserve Authentic Translations**: Never substitute modern dynamic paraphrases for Telugu or English scripture. Always use **పరిశుద్ధ గ్రంథము (O.V. Bible — Bible Society of India)** for Telugu and **1769 King James Version (KJV)** for English.
2. **Never Break Telugu Akhands or Consonant Conjuncts**: When animating Telugu text per-word or per-grapheme (such as `క్ష`, `క్ష్వ`, `స్త్ర`, `ప్రేమించెను`, `ద్రాక్షావల్లి`), never split strings with `str.split('')`. Always split by whitespace words (`split(/\s+/)`) or `new Intl.Segmenter('te', { granularity: 'grapheme' })`.
3. **Keep `/` and `Ctrl+F` Strictly Separated**:
   - `/` focuses `#quickCommandInput` (instant reference parser: `yoh 15:4`, `yoh 15:4-15`, `yoh 12`).
   - `Ctrl+F` focuses `#concordanceQueryInput` (full-Bible word/phrase/phonetic concordance search).
4. **Zero-Flash Overlay Discipline**: `?mode=overlay` must never default to `isLive: true` on boot and must never broadcast state back to storage. Hidden overlays must use `visibility: hidden` in addition to `opacity: 0`.
5. **Anti-Slop Monochrome Studio UI**: Keep the operator UI in Zinc-950 (`#09090b` / `#0f0f12` / `#18181b`) with subtle `1px` borders (`rgba(255,255,255,0.075)`), compact typography, and zero decorative bloat.
6. **Preserve All Element IDs & Keyboard Shortcuts**:
   - `/` or `Ctrl+K`: Focus Quick Reference Omnibox
   - `Ctrl+F`: Open & Focus Full-Bible Concordance Search
   - `Enter`: Present Live (`Shift+Enter`: Add to Service Queue)
   - `Space`: Toggle Live / Standby
   - `Escape`: Instant Panic Hide (hides both Scripture Lower-Third and Picture Slide-Over)
   - `←` / `→`: Step Previous / Next Verse
   - `Shift + ←` / `→`: Shrink / Expand Verse Range End (`15:4` → `15:4-15`)
   - `Alt + ←` / `→`: Step Clause Fragment (`Full Verse` → `Part a` → `Part b` → `Part c`)
   - `Alt + 1..9`: Fire Pinned Service Queue Slot `1..9`
   - `C`: Activate Whole Chapter Mode (`యోహాను సువార్త 12వ అధ్యాయము`)
   - `L`: Cycle Language (`te` → `te_full` → `en` → `hi` → `ta` → `custom`)
   - `B`: Toggle English Parallel Sub-label
   - `Ctrl+V`: Paste clipboard image directly into Sermon Picture Slide-Over Presenter
7. **Recommended Next Tasks in Antigravity**: See `docs/ROADMAP_NEXT_TASKS.md` for modularizing into a Vite + React + TypeScript + GSAP workspace (if desired) or adding offline SQLite/JSON bundling, multi-verse auto-pagination, and two-way OBS WebSocket 5.x Tally integration.

---

## 6. Mandatory UI, UX, Broadcast & Telugu Zero-Clip Rules (Authoritative — See `DESIGN.md`)

All future changes and new AI agents working on VakyaCast LT MUST follow [DESIGN.md](./DESIGN.md):

1. **Global Telugu Zero-Clipping:** NEVER apply `overflow: hidden`, `truncate`, `leading-tight`, negative `tracking-tight`, or permanent `will-change` on Telugu text lines/headings. Always use `line-height >= 1.40`, `letter-spacing: 0`, `padding-top/bottom: 0.24em` on animated Telugu nodes, and `-0.35em` vertical bleed on any `clip-path` wipe.
2. **Church TV Readability First:** Full 1080p title-safe width (`4.5%` horizontal / `4%` vertical margins), Reference ALWAYS bigger & identified first, distinct optical sizing for Telugu (`Anek Telugu`) vs English (`Anek Latin` / `Source Serif 4` — never hardcoded `Inter`), and `autoFitFullScreenStage` (`92%` height guard).
3. **Zero Broadcast Slop:** No floating yellow divider bar, no radial spotlight blobs (use matte surfaces + subtle fine grain), no `📖` emoji icons, no shimmer sweeps, and persistent DOM GSAP transitions (zero backdrop flash on verse step, real `power3.in` fade-out on hide).
4. **Contrast & Collision Safety:** Auto-invert ink for `clean_light` + `pure_black`, keep `.fs-theme-light` dark-ink highlights, and preserve Split-Screen Media collision guards in both Lower-Third and Full-Screen modes.
5. **Calm Monochrome Operator UI:** Linear/Raycast monochrome palette (`#09090b` / `#0f0f12`), proportional `Anek Latin` + `tabular-nums` (never `JetBrains Mono` / `font-mono`), Red strictly for `ON AIR`, progressive disclosure (`Tools ▾`, collapsible Workbench, focused OBS Dock tabs).
6. **Preview-First Safety (`staged` vs `live`):** Clicking History, Queue, Books/Chapters/Verses, Chapter Feed, or Search results MUST load into Preview ONLY — never hijacking the live Church TV until `Enter`, `PRESENT`, inline `▶` Play, or `Alt+1..9` is triggered. Keep **History** (40 persistent items, snippet + timestamp, `Alt+Z` quick-back) separate from **Queue**.
