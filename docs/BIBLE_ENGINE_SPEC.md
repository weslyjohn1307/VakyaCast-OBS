# Full Bilingual Bible Engine Specification (`BIBLE_ENGINE_SPEC.md`)

## 1. Verified Open-Source Repositories
- **Telugu O.V. Bible (BSI) — పరిశుద్ధ గ్రంథము**:
  - Repository: `https://github.com/aruljohn/Bible-telugu`
  - Raw JSON Endpoint: `https://raw.githubusercontent.com/aruljohn/Bible-telugu/main/<Book>.json`
  - Special Filename Rule: Book 22 is `Song of Songs.json`.
- **English King James Version (1769 KJV)**:
  - Repository: `https://github.com/aruljohn/Bible-kjv`
  - Raw JSON Endpoint: `https://raw.githubusercontent.com/aruljohn/Bible-kjv/master/<Book>.json`
  - Special Filename Rule: Book 22 is `Song of Solomon.json`.
- **Alternative Single-File JSON/XML Sources Supported by Importer**:
  - `godlytalias/Bible-Database`: `https://github.com/godlytalias/Bible-Database/blob/master/Telugu/bible.json`
  - `sajeevavahini/bibles`: `https://github.com/sajeevavahini/bibles/blob/main/Telugu%20Bible%20(BSI).xml`
  - `thiagobodruk/bible`: `https://github.com/thiagobodruk/bible/blob/master/json/en_kjv.json`

## 2. Clause Slicer Algorithm (`splitVerseIntoClauses`)
- Splits verse text into word tokens by whitespace (`/\s+/`).
- Scans for natural clause boundaries at punctuation marks (`/[,;:—–.!?;]$/`) where the current clause has at least 3 words (`i - currentStart >= 2`).
- Assigns each clause a sequential letter (`a`, `b`, `c`, `d`) and word index span (`startWordIdx` to `endWordIdx`).
- Selecting a clause chip (`Part a`, `Part b`) or pressing `Alt + ←` / `Alt + →` populates `selectedTeWordIndices` and `selectedEnWordIndices` and optionally appends the clause letter (`యోహాను 15:4a`) to the citation header.
