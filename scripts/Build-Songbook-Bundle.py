import json
import os
import re
import openpyxl

EXCEL_PATH = r"C:\users\daniel\Downloads\Church Works\Carols\Carols-2025\Song Book.xlsx"
OUT_JS = r"d:\Vakya_Cast\songs\songs_church_bundle.js"

BOOKS = [
    ("englishHymns", "eh", "English Hymns", "en"),
    ("englishChoruses", "ec", "English Choruses", "en"),
    ("teluguSongs", "te", "Telugu Songs", "te"),
]


def clean_line(ln: str) -> str:
    return re.sub(r"[ \t]+$", "", ln.replace("\r", ""))


def extract_title(raw_text: str, num) -> str:
    for ln in raw_text.splitlines():
        t = ln.strip()
        if not t:
            continue
        t = re.sub(r"^\d+[\.\)\-]\s*", "", t).strip()
        t = re.sub(r"^(Chorus|Refrain|Pallavi|పల్లవి)\s*[:\-]?\s*", "", t, flags=re.I).strip()
        if t:
            return t[:72]
    return f"Song #{num}"


def split_stanza_phrase_safe(lines):
    """Conservative musical-phrase splitter: prefers 2-4 lines, cuts at sentence/clause boundaries."""
    clean = [ln for ln in lines if ln.strip()]
    n = len(clean)
    if n <= 4:
        return [clean] if clean else []

    chunks = []
    cur = []
    for idx, ln in enumerate(clean):
        cur.append(ln)
        rem = n - (idx + 1)
        ends_strong = bool(re.search(r"[.!?।;:\u0964]\s*$", ln))
        ends_soft = bool(re.search(r"[,–—\-]\s*$", ln))
        # Prefer cutting at 2 lines on strong punctuation, or 3-4 lines on soft punctuation
        if len(cur) >= 2 and rem >= 2 and ends_strong:
            chunks.append(cur)
            cur = []
        elif len(cur) >= 3 and rem >= 2 and (ends_strong or ends_soft):
            chunks.append(cur)
            cur = []
        elif len(cur) >= 4 and rem >= 1:
            chunks.append(cur)
            cur = []
    if cur:
        # Avoid tiny 1-line orphan if previous chunk has <= 3 lines
        if len(cur) == 1 and chunks and len(chunks[-1]) <= 3:
            chunks[-1].extend(cur)
        else:
            chunks.append(cur)
    return chunks


def parse_excel_song_to_slides(raw_text: str, book_key: str):
    """
    Conservative baseline parser respecting Song Book.xlsx real patterns:
    - Keeps 100% verbatim wording (zero words altered or invented)
    - Explicit 1., 2., 3. -> V1, V2, V3
    - Telugu Pallavi before 1. -> C1 followed by V1, V2, V3
    - Continuation slides retain the exact original section label
    """
    text = raw_text.replace("\r\n", "\n").replace("\r", "\n").strip()
    blocks = [b.strip() for b in re.split(r"\n\s*\n+", text) if b.strip()]
    has_numbered_block = any(re.match(r"^\d+[\.\)]\s*", b) for b in blocks)

    slides = []
    verse_counter = 0
    chorus_counter = 0

    for b_idx, block in enumerate(blocks):
        raw_lines = [clean_line(ln) for ln in block.splitlines() if ln.strip()]
        if not raw_lines:
            continue

        first = raw_lines[0].strip()
        label = None

        # Explicit numbered verse: 1., 2., 3.
        m_num = re.match(r"^(\d+)[\.\)]\s*(.*)$", first)
        m_kw = re.match(r"^(Chorus|Refrain|Bridge|Pre-Chorus|Tag|Intro|Outro|Pallavi)\s*[:\-]?\s*(.*)$", first, flags=re.I)

        if m_num:
            v_num = int(m_num.group(1))
            label = f"V{v_num}"
            rest = m_num.group(2).strip()
            if rest:
                raw_lines[0] = rest
            else:
                raw_lines = raw_lines[1:]
            verse_counter = max(verse_counter, v_num)
        elif m_kw:
            kw = m_kw.group(1).lower()
            prefix_map = {
                "chorus": "C1",
                "pallavi": "C1",
                "refrain": "R1",
                "bridge": "B1",
                "pre-chorus": "P1",
                "tag": "T1",
                "intro": "I1",
                "outro": "O1",
            }
            label = prefix_map.get(kw, "C1")
            rest = m_kw.group(2).strip()
            if rest:
                raw_lines[0] = rest
            else:
                raw_lines = raw_lines[1:]
        else:
            # Unnumbered stanza heuristics
            if b_idx == 0 and has_numbered_block:
                # Classic Telugu Pallavi-first or English Hymn Refrain-first before 1.
                label = "C1"
                chorus_counter = max(chorus_counter, 1)
            elif book_key == "englishChoruses" and not has_numbered_block:
                chorus_counter += 1
                label = f"C{chorus_counter}" if chorus_counter <= 3 else f"V{chorus_counter}"
            elif has_numbered_block and b_idx > 0:
                # Unnumbered stanza between numbered verses is typically Chorus/Refrain
                label = "C1"
            else:
                verse_counter += 1
                label = f"V{verse_counter}"

        for chunk in split_stanza_phrase_safe(raw_lines):
            slides.append({
                "label": label,
                "text": "\n".join(chunk)
            })

    if not slides:
        slides.append({"label": "V1", "text": text})
    return slides


def main():
    wb = openpyxl.load_workbook(EXCEL_PATH, read_only=True, data_only=True)
    ws = wb["songsTable"]
    header = [str(c).strip() if c is not None else "" for c in next(ws.iter_rows(values_only=True))]
    col_idx = {name: i for i, name in enumerate(header)}

    songs = []
    counts = {}

    for row in ws.iter_rows(min_row=2, values_only=True):
        raw_num = row[col_idx["number"]]
        if raw_num is None:
            continue
        num_str = str(raw_num).strip()
        for col_name, prefix, book_label, lang in BOOKS:
            val = row[col_idx[col_name]]
            if not val or not str(val).strip():
                continue
            raw_text = str(val).strip()
            slides = parse_excel_song_to_slides(raw_text, col_name)
            title = extract_title(raw_text, num_str)
            songs.append({
                "id": f"{prefix}_{num_str}",
                "book": col_name,
                "num": num_str,
                "lang": lang,
                "title": title,
                "verified": False,
                "slides": slides,
            })
            counts[col_name] = counts.get(col_name, 0) + 1

    os.makedirs(os.path.dirname(OUT_JS), exist_ok=True)
    payload = json.dumps(songs, ensure_ascii=False, separators=(",", ":"))
    with open(OUT_JS, "w", encoding="utf-8") as f:
        f.write("// Auto-generated offline Church Songbook Bundle (Song Book.xlsx: English Hymns, English Choruses, Telugu Songs)\n")
        f.write("window.VAKYACAST_OFFLINE_SONGS = ")
        f.write(payload)
        f.write(";\n")

    size_kb = os.path.getsize(OUT_JS) / 1024
    print(f"Generated {OUT_JS} ({size_kb:.1f} KB) -> {len(songs)} songs:", counts)


if __name__ == "__main__":
    main()
