# VakyaCast — Complete Build Playbook, Practical Learnings & Architecture Guide

> **Who This Document Is For:** Any developer, church broadcast engineer, or fresh AI agent building or extending **VakyaCast** from scratch. It captures the exact **user intentions**, **separated Bible & Media architectures**, **every practical live-church problem we hit**, **how we solved each one**, and a **suggested roadmap** for what can come next.

---

## 1. User Intentions & Live Church Reality

VakyaCast was not built as a generic web app — it was built for **real Sunday church broadcasts** (Telugu + English congregations, mixed ages from elders in the back row to youth watching on YouTube/OBS).

### Core Intentions
1. **Audience First (All Ages):** Elders in the back row must read Telugu scripture and names effortlessly on TV without squinting. Youth on livestream must see clean, modern broadcast visuals — never dated PowerPoint gold bevels or sloppy layouts.
2. **Speed Under Live Pressure:** Pastors jump chapters, quote missionaries mid-sermon, or read half a verse without warning. Operators need a **keyboard-first**, zero-hesitation control desk.
3. **Zero Clashes Between Workspaces:** Bible verses and Sermon Media (pictures, quotes, maps) must live in **completely separated workspaces** and never collide on air.
4. **Works Inside OBS *and* Standalone on Any PC:** Must run as an OBS Custom Browser Dock + 1080p Transparent Browser Source, or in Chrome/Edge via the local Bridge — and must work cleanly if downloaded onto **any fresh PC** with zero manual setup.
5. **Calm Monochrome Operator UI:** The control desk stays quiet (`#09090b` Zinc-950, subtle `1px` borders, zero decorative clutter) so the operator's eyes stay focused on the live output monitor and scripture.

---

## 2. System Architecture & Portability

### Single-File Zero-Build Core
- **Canonical App:** `bible_lower_third_studio.html` (mirrored byte-identically to `src/bible_lower_third_studio.html` and `C:\OBS-VakyaCast\bible_lower_third_studio.html`).
- **3 Operating Modes (Same File via `?mode=`):**
  - `?mode=studio` (default): Full 2-column control deck + 16:9 Live Output Monitor.
  - `?mode=dock`: Compact layout tailored for narrow vertical or short bottom OBS Custom Browser Docks.
  - `?mode=overlay`: Pure transparent `1920×1080` canvas (`rgba(0,0,0,0)`) for OBS Browser Source. **Strictly read-only** — boots with `isLive: false` and never writes back to storage.

### Multi-Channel Real-Time Sync
Every live action syncs across:
1. `BroadcastChannel('vakyacast_bible_lt_channel')` (instant same-origin sync)
2. `localStorage` (`vakyacast_lt_live_state_v1`)
3. `window.postMessage` (pop-out standalone projector window)
4. **Portable HTTP Sync Bridge** (`scripts/Bridge-Server.ps1` on `http://localhost:8765`):
   - `POST /sync` & `GET /state` — bridges external Chrome/Edge to OBS CEF (which isolates storage).
   - `POST /prefs` & `GET /prefs` — keeps settings identical between OBS Dock (`file:///`) and Chrome (`localhost:8765`).
   - `GET /backgrounds-list` & HTTP `Range` streaming (`206 Partial Content`) — serves `./backgrounds/` relative to the script directory on **any PC** for smooth `.mp4`/`.webm`/image playback.

### Any-PC Portability Rules
- **No hardcoded user paths** in the HTML/JS.
- **66-Book Offline Bibles** (`bibles/`) + **IndexedDB** (`VakyaCastBibleDB_v1`) store full Telugu O.V. (BSI) + English KJV plus custom background images/videos locally (50+ MB safe, zero `localStorage` overflow).
- **Inline WebGL Shaders & SVG Textures** live inside the HTML file (~4 KB) with automatic CSS gradient fallback on PCs without WebGL.

---

## 3. Part A — Bible Verse Presentation (Features & Operation)

### Authentic Translations
- **Telugu:** పరిశుద్ధ గ్రంథము (**O.V. Bible — Bible Society of India**)
- **English:** **1769 King James Version (KJV)**
- Supports 6 citation languages (`te`, `te_full`, `en`, `hi`, `ta`, `custom`), Whole Chapter Mode (`యోహాను సువార్త 12వ అధ్యాయము`), and 4 content layouts (`Ref Only`, `Ref + Telugu`, `Ref + KJV`, `Ref + Dual Bilingual`).

### Fast Navigation & Safe Live Operation
- **4-Step Bible Navigator:** Color-grouped 66-Book Matrix → Chapters → Verses → **Live Chapter Read Feed** (click any verse in context to stage or air).
- **Fast 3-Box Tab-Jump Bar:** `Book → Tab → Ch → Tab → Verse → Enter` for instant preaching jumps.
- **Strictly Separated Search Bars:**
  - `/` or `Ctrl+K` → Quick Reference Omnibox (`yoh 15:4-15`, `ps 23:1-6`, `yoh 12`).
  - `Ctrl+F` → Full-Bible Concordance Search (Telugu script, English KJV, multi-word AND, `"exact phrase"`, and Tanglish phonetic lookup like `preminchenu`, `kaapari`).
- **Preview vs Program Separation (`staged` vs `liveProgram`):** Browse ahead safely while a different verse stays ON AIR; click `GO LIVE` or press `Enter` to push the staged verse to TV.
- **Persistent History & Service Queue:** Last 40 verses saved in History (safe click-to-preview, `Alt+Z` quick-back); pinned Queue slots (`Alt+1..9`).
- **Verse Workbench (Collapsible):**
  - **Word Highlighting:** Click/Shift-click words or clause chips (`Part a/b/c`) with 4 broadcast marker colors.
  - **Part-Verse Slicing:** Present *only* the chosen clause (`యోహాను 15:4a`) with auto `…` ellipsis and live stepping via `Alt+←`/`→`.

### 3 Bible Presentation Modes (Contextual Settings)
1. **Lower-Third:** Broadcast strip at bottom-left/center/right over live camera.
2. **Scene Overlay:** Automatically switches OBS WebSocket (`Center Stage` ↔ `Book Overlay` — shared with Media!) and displays a full-height right/left split verse panel or transparent overlay.
3. **Full-Screen TV (`Alt+F`) + Sanctuary Backdrop Lab:**
   - **4 Reference-vs-Verse Separation Styles:**
     - `Liquid Glass Ref Pill` (frosted capsule with `1px` specular top sheen — `Top` or `Bottom`)
     - `Two-Zone Frosted Verse Card` (Header strip + `1px` hairline divider + Scripture body)
     - `Bottom-Anchored Sanctuary Bar` (oversized verse centered + quiet grounded reference bar)
     - `Pure Editorial Rule` (crisp typography + `1px` hairline, zero card chrome)
   - **6 Verified WCAG AAA Backdrops** (`Deep Navy Waves` 16.4:1, `Midnight Aurora` 16.9:1, `Warm Sanctuary Gold` 15.1:1, `Quiet Charcoal Mist` 17.2:1, `Still Waters` 15.4:1, `Soft Linen Light` 13.8:1).
   - **4 Constant-Motion WebGL Engines:** `Silk Waves`, `Aurora`, `Mesh Orbs`, `Beams` — capped at **30fps** + `640×360` internal buffer (`< 1–2%` GPU), **0% GPU auto-pause** off-air, and `webglcontextlost` silent CSS fallback.
   - **Custom Images, Videos & Textures:** Upload `.jpg`/`.png`/`.mp4`/`.webm` (IndexedDB offline) or scan `./backgrounds/`, add `Fine Grain` / `Subtle World Map` / `Soft Linen`, tune `Dimmer` & `Blur`, with a live **WCAG AAA Contrast Meter** that auto-dims bright photos/videos.

---

## 4. Part B — Sermon Media Studio (Completely Separated)

### Why Media Is Strictly Separate
- Lives in its own top-level **`Media`** workspace (`Bible | Media`).
- **On-Air Mutual Exclusion:** Putting Media ON AIR automatically takes Bible OFF AIR (and vice versa) — they can never overlap or clash on TV.

### 4-Tier Operational Hierarchy (Fits `1536×639` Without Clutter)
1. **Tier 1 — Live Action & Deck Stepper:** Status pill (`OFF AIR` / `ON AIR`), OBS WebSocket badge, `◀ ▶` Slide Deck Prev/Next, **`Show On Air (Alt+P)`**, **`Hide`**.
2. **Tier 2 — Contextual Content Type (`Picture` | `Quote` | `Sermon Point` | `Map / Diagram`):**
   - Selecting `Quote` or `Sermon Point` hides image upload/search/zoom and reveals clean quote/point text inputs.
   - Selecting `Map / Diagram` switches layout to **Full-Screen (100% TV)** + `contain_blur` + Commons search automatically.
3. **Tier 3 — Collapsible `▸ Layout, Framing & OBS Scene` Drawer:** Holds Split Width (`25–50%`), Fit Mode, Focal Position, Live Zoom (`100–160%`), Caption toggle, and OBS auto-switch (`Center Stage` ↔ `Book Overlay`), with a live summary badge (`Right Split 34% • Book Overlay`).
4. **Tier 4 — Uncropped 16:9 Slide Deck:** Pin pictures, quotes, or sermon points for Sunday (`Click to Stage`, `Double-Click to Air`, `Alt+Shift+1..9`).

### Church-Specific Media Intelligence
- **Church-Native Vocabulary Engine:** Rewrites dry Wikipedia secular descriptions (e.g. *"English clergyman"*) into warm church-understood roles (`John Wesley` → `Missionary & Preacher • 1703–1791`), with 1-click **`Role + Years` | `Years` | `None`** pills.
- **3-Source Multi-Image Finder (Zero API Keys):**
  - `Portraits` → Wikipedia REST Summary + Wikimedia Commons 6-image contact sheet
  - `Maps & History` → Wikimedia Commons historical plates & Bible maps
  - `Illustrations` → Openverse CC-licensed visuals
  - Plus global **`Ctrl+V` clipboard paste**, drag-drop upload, and automatic portrait (`cover` + `top` focal) vs landscape (`contain_blur`) detection.
- **Fluid Container-Relative TV Typography (`cqi`):** Media overlays use `container-type: inline-size` with `cqi` units + a dark bottom cinema vignette scrim so headlines and roles stay bold and readable across every split width and 1080p TV size (zero fixed tiny pixel labels).

---

## 5. Practical Problems We Hit & How We Solved Them

| Practical Problem | Root Cause | Permanent Solution |
| :--- | :--- | :--- |
| **Telugu top *gudi* / *dirgham* clipped flat on line 1** | Chromium GPU texture-box cropping triggered by `overflow: hidden`, `leading-tight` (1.25), negative tracking, or permanent `will-change` | Enforce `overflow: visible`, `line-height >= 1.40`, `letter-spacing: 0`, `padding-top/bottom: 0.24em` directly on Telugu text nodes; never split Telugu with `str.split('')` |
| **Dock showed Centered verse while Chrome Bridge showed Left aligned** | OBS Dock (`file:///`) and Chrome (`localhost:8765`) had isolated `localStorage` origins | Added `/prefs` (`GET`/`POST`) to `Bridge-Server.ps1` so both controllers stay 100% in sync |
| **Overlay briefly flashed visible on OBS scene switch** | `?mode=overlay` booted with `isLive: true`, used `opacity: 0` without `visibility: hidden`, and OBS had `restart_when_active: true` | Overlay boots `isLive: false`, read-only consumer, `.lt-hidden` uses `visibility: hidden; opacity: 0`, and OBS source keeps `restart_when_active: false` |
| **Blank animation dropdown after update** | Old `localStorage` held retired preset name (`ae_stagger`) | Added `normalizeAnimStyle()` auto-migration inside `applyPrefsObjectToState()` |
| **Clean Light dark ink invisible on Pure Black keying** | Theme ink color wasn't aware of Pure Black backdrop override | Added contrast-safe `effTheme` auto-inversion + `text-shadow: none` on dark glass pills over light backdrops |
| **Small Media caption unreadable on church TVs + "English clergyman"** | Fixed pixel font sizes inside narrow split panel + raw Wikipedia `description` string | Switched to `container-type: inline-size` + `cqi` fluid scaling + bottom cinema scrim + `CHURCH_HERITAGE_BIOS` & `normalizeChurchBio()` |
| **OBS `backdrop-filter` / Liquid Glass didn't blur live camera** | Browser CSS filters can only blur content *inside* the same Browser Source, not OBS video layers underneath | Used real Liquid Glass / frosted blur over in-browser shaders/images/videos (Full-Screen), and rich dark translucent + specular sheen simulated glass over live cameras |
| **Big videos/photos break `localStorage` (~5 MB limit)** | Browser `localStorage` is tiny and synchronous | Used **IndexedDB** (`VakyaCastBibleDB_v1`) for offline standalone uploads + Bridge `./backgrounds/` with HTTP `Range` streaming |
| **Controls felt cluttered on real `1536×639` laptop screen** | Irrelevant settings shown at the same time (e.g. Lower-Third position visible during Full-Screen) | Enforced strict **Contextual Visibility** + collapsible drawers (`Highlight & Slice ▸`, `Layout, Framing & OBS Scene ▸`) |
| **Separate OBS scenes for Bible vs Media confused setup** | Bible Scene Overlay defaulted to `Bible Overlay` while church already used `Book Overlay` | Unified both to share `Center Stage` ↔ `Book Overlay` with automatic prefs migration |
| **Live WebGL motion risk during busy multi-camera OBS stream** | Unthrottled 60fps 1080p shaders can eat GPU | Capped shader buffer to `640×360`, throttled to **30fps**, auto-paused at `0%` GPU off-air, and added `webglcontextlost` CSS fallback |

---

## 6. Live Operator Keyboard Shortcuts

| Shortcut | Action |
| :--- | :--- |
| `/` or `Ctrl+K` | Focus Quick Reference Omnibox (`yoh 15:4-15`) |
| `Ctrl+F` | Open & Focus Full-Bible Concordance Search |
| `Enter` | Push Staged Verse ON AIR (`Shift+Enter`: Add to Queue) |
| `Space` | Toggle Live / Standby |
| `Escape` | **Panic Hide** (instantly hides both Bible & Media) |
| `←` / `→` | Step Previous / Next Verse |
| `Shift + ←` / `→` | Shrink / Expand Verse Range (`15:4` → `15:4-15`) |
| `Alt + ←` / `→` | Step Clause Fragment (`Full` → `Part a` → `Part b`) |
| `Alt + 1..9` | Fire Pinned Service Queue Slot `1..9` |
| `Alt + Z` | Quick-Back to Previous Verse from History |
| `Alt + F` | Toggle Full-Screen Bible Mode |
| `Alt + P` | Show Staged Sermon Media ON AIR |
| `C` / `L` / `B` | Whole Chapter Mode / Cycle Language / Toggle English Sub-label |
| `Ctrl + V` | Paste Clipboard Image directly into Media Studio |

---

## 7. Suggested Roadmap (Optional Future Milestones)

These are **suggestions**, kept strictly separate from what is already complete and production-ready:

### Milestone 1 — Dedicated Worship Lyrics Workspace (`Bible | Media | Lyrics`)
- **Same strict separation & mutual exclusion** as Bible and Media.
- **VideoPsalm Songbook Importer (`.json` / `.vpc`):** Tolerant parser handling VideoPsalm's relaxed JSON syntax, section tags (`V1`, `C`, `P`, `B`, `T`), `Sequence` playback order, inline `[Chord]` stripping for TV output, and Telugu Unicode + English transliteration bilingual slides.
- **Worship Agenda (Sunday Setlist):** Drag/click song order + live verse/chorus/bridge jump pads + **Lower-Third (2-line stream)** and **Full-Screen (Backdrop Lab)** outputs.

### Milestone 2 — Multi-Verse Auto-Pagination
- Automatically split long 5–8 verse ranges into readable `Page 1/2` cards (stepped with `→`) instead of shrinking font size below comfortable back-row legibility.

### Milestone 3 — Two-Way OBS Live Tally Indicator
- Subscribe to OBS WebSocket `CurrentProgramSceneChanged` events and show the live OBS scene name (`LIVE: Center Stage` / `LIVE: Book Overlay`) in the top header bar.

### Milestone 4 — Companion / Stream Deck HTTP Triggers
- Add simple REST endpoints to `Bridge-Server.ps1` (`POST /trigger/next`, `/trigger/prev`, `/trigger/hide`, `/trigger/live`) so churches using Elgato Stream Deck or Bitfocus Companion can fire VakyaCast actions from hardware buttons.

### Milestone 5 — Portable Sunday Service Pack (`.vakyacast` Export/Import)
- Export the entire Sunday prep (**Bible Queue + Media Slide Deck + Lyrics Agenda**) into one portable file to copy via USB/WhatsApp from home laptop to church broadcast PC in seconds.
