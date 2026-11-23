# VakyaCast LT — Design System & Broadcast Engineering Rules (`DESIGN.md`)

> **Authoritative Visual, Typography, Motion & UX Contract** for all human contributors and AI agents working on VakyaCast LT. Every future change MUST obey these rules without regression.

---

## 1. Global Telugu / Indic Zero-Clipping Discipline (Non-Negotiable)
Telugu glyphs feature tall ascending vowel signs (*dirgham*, *gudi*, *etvam*) and deep descending sub-base conjuncts (*ottulu* like `క్త`, `ష్ట`, `ధ్యా`, `ద్రాక్షావల్లిలో`) that protrude beyond standard Latin CSS line-boxes.
1. **NEVER put `overflow: hidden` directly around Telugu text lines** (including `.fs-mask`, `.truncate`, or tight line-masks).
2. **NEVER put permanent `will-change: transform, opacity` on Telugu text nodes** — Chromium promotes them to a GPU texture layer cropped to the element's border-box, slicing top diacritics flat.
3. **Mandatory vertical safe padding:** Animated Telugu display nodes (`.fs-stage-ref`, `.fs-stage-verse`) MUST carry `padding-top: 0.24em; padding-bottom: 0.24em;` directly on the node itself.
4. **Safe line-height & tracking:** Telugu display headings MUST use `line-height >= 1.40` and `letter-spacing: 0` (NEVER `leading-tight` / `1.25` or negative `tracking-tight` `-0.025em`). Telugu body copy uses `line-height: 1.48–1.60`.
5. **Safe `clip-path` wipes:** Any horizontal wipe on Telugu text MUST include `-0.35em` vertical bleed (`inset(-0.35em 100% -0.35em 0)` → `inset(-0.35em -0.1em -0.35em -0.1em)`) and `clearProps: 'clipPath'` on finish.
6. **Never split Telugu by code units (`str.split('')`):** Always split by whitespace words (`split(/\s+/)`) or `Intl.Segmenter('te', { granularity: 'grapheme' })`.

---

## 2. Church TV Readability-First Display Rules (1920×1080)
1. **Reference Bigger & First:** On Church TVs, the Scripture Reference is ALWAYS larger/commanding so the congregation identifies book/chapter/verse immediately before reading the verse.
2. **Full Title-Safe Canvas:** Use `4.5%` horizontal and `4%` vertical padding (not cramped narrow columns) + `autoFitFullScreenStage` (`92%` max height) so long ranges never clip off top/bottom.
3. **Optical Bilingual Pairing (Distinct Telugu vs English Ratios):**
   - **Telugu Sans (`Anek Telugu`, `Noto Sans Telugu`, `Ramabhadra`, etc.)** pairs with **`Anek Latin`** (same Ek Type superfamily).
   - **Telugu Serif (`Suranna`, `Noto Serif Telugu`, `Sree Krushnadevaraya`)** pairs with **`Source Serif 4`**.
   - NEVER hardcode `Inter` for English broadcast Scripture.
   - Telugu uses ~`1.17×–1.27×` larger nominal font-size than English so both scripts read optically balanced on TV.
4. **English-Only Header Rule:** In `ref_en` mode, display the English Reference (`John 15:4`) as the big primary header.
5. **No Cheap Decorative Slop:**
   - NO tiny centered floating yellow divider bar below the reference.
   - NO dated radial spotlight blobs (use deep matte sanctuary canvases + subtle `3%` fine SVG film grain to eliminate 8-bit HDMI/TV banding).
   - NO emojis (`📖`) on broadcast overlays — use crisp consistent inline SVG icons.
   - NO synthetic CSS shimmer sweeps on Lower-Thirds.
6. **3 Broadcast Full-Screen Layouts:**
   - `editorial` (**Sanctuary Editorial — Default**): Ref top-left, parallel right, single edge-to-edge `1px` architectural hairline, left-aligned Scripture.
   - `centered` (**Sanctuary Centered**): Pure typographic hierarchy (no floating line).
   - `tag_header` (**Architectural Ref Tag**): Precision `1px`-bordered broadcast tag framing the reference.

---

## 3. Broadcast Motion & Contrast Safety Rules
1. **Persistent DOM + Real GSAP Choreography:** Never wipe `innerHTML` on live verse swaps or fade-outs. Keep `.fs-wrapper` persistent so verse-to-verse steps NEVER blink the backdrop and OFF-AIR exits play a smooth `power3.in` fade (`260ms`).
2. **3 Purposeful Motion Presets:** `broadcast_mask` (Zero-Clip Rise, default), `sanctuary_dissolve` (Calm Fade), `editorial_wipe` (Bleed-Safe Clip Wipe). Zero cheap `filter: blur()` fog on static reveals.
3. **Light/Black Contrast Guard:** When `clean_light` is paired with `pure_black`, automatically invert text to high-contrast white + gold ink. On light canvases, activate `.fs-theme-light` dark-ink highlight pills and dark hairline dividers.
4. **Split-Screen Media Collision Guard:** Both Lower-Third and Full-Screen modes MUST pad/shift cleanly away from active `split_right_full` / `split_left_full` media panels.

---

## 4. Operator UI Architecture (OBS Dock & Browser Studio)
1. **Calm Monochrome Palette:** Neutral dark surfaces (`#09090b`, `#0f0f12`, `#111114`, `#18181b`), subtle `1px` hairlines (`rgba(255,255,255,0.08)`), zero nested card shadows, zero rainbow button soup.
   - **Red** = `ON AIR` only (never decorative).
   - **White (`bg-white text-zinc-950`)** = Active state / primary action.
2. **Proportional UI Typography:** Use **Anek Latin** + `font-variant-numeric: tabular-nums` for chapter/verse numbers — NEVER `JetBrains Mono` or `font-mono`.
3. **Progressive Disclosure:**
   - Tuck secondary setup/utility buttons into the top **`Tools ▾`** menu.
   - Keep Word Highlight & Clause Slicer collapsed into a 1-line bar (`H` to toggle).
   - In **OBS Dock Mode**, show one focused view at a time via **`Live | History | Queue | Media | Look`**.
4. **Preview-First Broadcast Safety (`staged` vs `live`):**
   - Passive clicks (History, Queue, Books/Chapters/Verses, Chapter Feed, Search) MUST load into **Preview (`staged`)** ONLY — never hijacking the live Church TV!
   - Updating **ON AIR (`live`)** happens ONLY via `Enter`, `PRESENT`, double-click / inline `▶` Play button, `Alt+1..9` Queue hotkeys, or explicit *Auto-Live*.
   - **History** is a first-class, dedicated panel (40 persistent items, Telugu snippet + timestamp, `Alt+Z` quick-back) strictly separated from **Queue (`Alt+1..9`)**.

---

## 5. Workspace Separation, Bible Scene Overlay & Contextual Settings
1. **Strict Bible ↔ Media Separation:** `Bible` and `Media` are separate top-level workspaces (`body[data-workspace="bible" | "media"]`) with strict On-Air mutual exclusion — going live with Bible automatically takes Media off air, and vice versa.
2. **3 Bible Output Modes:** `lower_third`, `scene_overlay` (OBS WebSocket 5.x auto-switch `Center Stage` ↔ `Bible Overlay` with `split_right`, `split_left`, or `transparent_full`), and `full_screen`.
3. **Contextual / Conditional Settings:** Automatically hide controls that do nothing in the active mode (Lower-Third vs Scene Overlay vs Full-Screen settings, Emblem Icon only in Lower-Third Ref-Only, Sub-label hidden when language is English, Word Workbench hidden in Ref-Only/Whole Chapter, Media Split Width hidden on floating layouts).
4. **Cross-Origin Preference Sync:** OBS Dock (`file://`) and Browser Bridge (`localhost:8765`) mirror settings through `/prefs` so defaults and edits never drift.

---

## 6. Core Frontend & UX Architecture Principles (For All Future Sessions & Agents)
Every fresh session or agent designing or modifying frontend/UX in VakyaCast LT MUST follow these 6 foundational engineering principles:

1. **Fluid Container-Relative Typography (`cqi` / `clamp`) — Never Fixed Pixel Sizes on Variable Panels:**
   - Broadcast media overlays and split panels vary in width (34% Split, 50% Split, 100% Full-Screen, or 16:9 Studio preview).
   - Always declare `container-type: inline-size` on overlay panels and size captions/quotes fluidly with `clamp(..., Xcqi, ...)` + length scaling so text stays legible from 40+ feet on Church TVs at every panel width and matches pixel-for-pixel in the 16:9 preview.
2. **Contextual Viewer & Conditional Controls:**
   - Never display controls that have zero effect in the active mode or content type (e.g., hide Image Search/Crop in `Quote` mode; hide Split Width on floating/full-screen layouts; hide Lower-Third Position in Full-Screen mode).
3. **Operational Hierarchy (4-Tier Workspace Order):**
   - Structure every control workspace in strict live-operator priority:
     - **Level 1 (Top):** Immediate Live Action (`Show On Air` / `Hide`, Live Status, Deck `Prev / Next`).
     - **Level 2 (Center):** Primary Content inputs for the active mode (`Picture | Quote | Sermon Point | Map` or `Books | Chapters | Verses | Read`).
     - **Level 3 (Collapsible Drawer):** Secondary framing, zoom, or OBS scene-routing controls tucked behind a 1-click progressive disclosure bar (`Framing & OBS Scene ▸`, `Highlight & Slice ▸`).
     - **Level 4 (Bottom):** Saved Deck / History for fast recall.
4. **Progressive Disclosure:**
   - Tuck rare setup/utility actions into calm popovers (`Tools ▾`) or collapsible drawers so the live operator viewport stays calm and fits compact laptop heights (`1536×639`) and narrow OBS docks (`420px`) without clutter.
5. **Church-Native Domain Language:**
   - Never dump raw secular encyclopedic jargon (`clergyman`, `Anglican divine`, `vicar`, `curate`, `hymnographer`) onto a church screen. Always normalize into warm, congregation-understood language (`Missionary`, `Preacher`, `Evangelist`, `Bible Teacher`, `Hymn Writer`) or clean `Years Only (1703–1791)`.
6. **Preview-First Safety & Mutual Exclusion:**
   - Passive clicks stage into Preview only; Bible and Media are top-level separated workspaces with strict On-Air mutual exclusion.
