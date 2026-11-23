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
