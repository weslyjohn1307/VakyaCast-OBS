# UI, Telugu Typography & Motion Design System (`UI_AND_MOTION_SYSTEM.md`)

## 1. Monochrome Studio UI (`coss.com/ui` + `shadcn/ui` + `unslop`)
- **Canvas Background**: `#09090b` (Zinc-950)
- **Card Surface**: `#0f0f12` with `1px solid rgba(255, 255, 255, 0.075)`
- **Elevated Control Surface**: `#18181b` (Zinc-900)
- **Semantic Accents**:
  - Primary Scripture / Gold: `#f59e0b` (Amber-500)
  - Concordance / Clause Slicer: `#38bdf8` (Sky-400)
  - Standby / Ready / DB Sync: `#10b981` (Emerald-500)
  - On-Air Live Pulse: `#e11d48` (Rose-600)

## 2. Telugu OpenType Typography Rules
- Primary Variable Font: **`Anek Telugu`** (`wdth` 75–125, `wght` 100–800)
- Display & Literary Fonts: **`Ramabhadra`**, **`Suranna`**, **`Noto Sans Telugu`**, **`Noto Serif Telugu`**, **`Mandali`**, **`NTR`**, **`Mallanna`**, **`Sree Krushnadevaraya`**, **`Tenali Ramakrishna`**, **`Timmana`**, **`Gidugu`**.
- **Shaping Guardrail**: Never apply positive `letter-spacing` (`tracking-widest`) or naive character splitting to Telugu script, as it detaches subjoined consonant vattulu and Akhands (`క్ష`, `క్ష్వ`).
