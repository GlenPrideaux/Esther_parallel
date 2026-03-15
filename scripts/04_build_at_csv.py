import csv, json, re, argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("-b", action="store_true", help="Use the British English version of WEB")

args = parser.parse_args()


ROOT = Path(__file__).resolve().parents[1]
MAP = ROOT / "data" / "mapping.csv"
def inp(job: str):
    return ROOT / "build" / "json" / f"{job}.json"
def outfile(job: str):
    return ROOT / "build" / f"{job}.csv"

RANGE_RE = re.compile(r"^((\d+|[A-F]):\d+[a-z]?)\s*-\s*((\d+|[A-F]):\d+[a-z]?)$")

import re

REF_RE = re.compile(r'^(\d+|[A-F]):(\d+)([a-z]?)$', re.IGNORECASE)

def parse_ref(ref: str) -> tuple[int, int, str]:
    """
    Parses '24:40a' -> (24, 40, 'a')
           '24:40'  -> (24, 40, '')
    """
    ref = ref.strip()
    m = REF_RE.match(ref)
    if not m:
        raise ValueError(f"Bad ref format: {ref!r}")
    ch = m.group(1)
    v  = int(m.group(2))
    suf = (m.group(3) or "").lower()
#    print(f"ch {ch}: v {v} suf {suf}")
    return ch, v, suf

def ref_sort_key(ref: str) -> tuple[int, int, int]:
    """
    Sort order: 40 < 40a < 40b < 41
    """
    ch, v, suf = parse_ref(ref)
    suf_ord = 0 if suf == "" else (ord(suf) - ord("a") + 1)
    return (ch, v, suf_ord)

def ref_to_tuple(ref: str):
    ch, v, suf = parse_ref(ref)
    suf_ord = 0 if suf == "" else (ord(suf) - ord("a") + 1)
    return (ch, v, suf_ord)

def expand_range_old(start: str, end: str):
#    print(f"start {start} - end {end}")
    sc, sv, ss = parse_ref(start)
    ec, ev, es = parse_ref(end)
    if ss or es:
        if sv != ev:
            raise ValueError(f"Ranges with suffixes not supported with different verse numbers: {start}-{end}")
        if ss == '':
                    return [f"{sc}:{sv}"]+[f"{sc}:{sv}{chr(ss)}" for ss in range(ord('a'), ord(es) + 1)]
#        print([f"{sc}:{sv}{chr(ss)}" for ss in range(ord(ss), ord(es) + 1)])
        return [f"{sc}:{sv}{chr(ss)}" for ss in range(ord(ss), ord(es) + 1)]
    if sc != ec:
        raise ValueError(f"Range crosses chapters: {start}-{end}")
    return [f"{sc}:{vv}" for vv in range(sv, ev + 1)]

def expand_ref_old(ref):
    if not ref.strip():
        return ["---"]
    m = RANGE_RE.match(ref.strip())
    if m:
#        print(f"RANGE_RE matched {ref} in expand_ref()")
        start, end = m.group(1), m.group(2)
        return expand_range(start, end)
    return [ref]
    
def get_refs(dict, ref: str) -> str:
    if not ref.strip():
        return ""
    m = RANGE_RE.match(ref.strip())
    if m:
#        print(f"RANGE_RE matched {ref} in get_text()")
        start_ref, end_ref = m.group(1), m.group(3)
        keys = list(dict)
        start = keys.index(start_ref)
        end = keys.index(end_ref)
        return keys[start:end+1]
#    print(f"no RANGE_RE match on {ref} in get_text()")
    return [ref]

def sort_key(ref: str):
    return ref_to_tuple(ref)

def row(rows, r, at_dict):
    ch = r.get("ch")
    mt_ref = r.get("mt_ref")
    refs = get_refs(at_dict, r.get("at_ref"))
    if refs == "":
        return rows
    for at_ref in refs:
        at_ch, v, suf = ref_to_tuple(at_ref)
        at_txt  = at_dict.get(at_ref)
        par = 1 if at_txt.startswith(STYLE_PARA) else 0 
        rows.append({
            "ch": ch,
            "at_ch": at_ch,
            "v": v,
            "cont" : suf,
            "par": par,
            "at_ref": at_ref,
            "mt_ref": mt_ref,
            "at_text": at_txt,
        })
    return rows

STRUCT_DELIM = "\u241E"
STYLE_PARA = f"{STRUCT_DELIM}P{STRUCT_DELIM}{STRUCT_DELIM}STYLE:PARA{STRUCT_DELIM}"

jobs = [
    ("Prideaux_ESGA","esther"),
    ("PrideauxBE_ESGA", "esther_be"),
    ]

def main():
    for job, output in jobs:
        rows = []
        at_dict  = json.loads(inp(job).read_text(encoding="utf-8"))
        with MAP.open(newline="", encoding="utf-8") as f:
            for r in csv.DictReader(f):
                rows=row(rows, r, at_dict)

            outfile(output).parent.mkdir(parents=True, exist_ok=True)
            with outfile(output).open("w", newline="", encoding="utf-8") as f:
                w = csv.DictWriter(f, fieldnames=["ch","at_ch", "v", "cont", "par", "at_ref", "mt_ref", "at_text"])
                w.writeheader()
                w.writerows(rows)

                print(f"Wrote {outfile(output)} ({len(rows)} rows)")

if __name__ == "__main__":
    main()
