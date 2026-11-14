#!/usr/bin/env python3
"""Check that the local links (href/src starting with /) of the built site lead to a file: python3 scripts/linkcheck.py _site"""
import re, sys
from pathlib import Path

root = Path(sys.argv[1] if len(sys.argv) > 1 else "_site")
bad = []
for page in root.rglob("*.html"):
    for m in re.finditer(r'(?:href|src)="(/[^"#?]*)', page.read_text(encoding="utf-8", errors="replace")):
        target = root / m.group(1).lstrip("/")
        if not (target.is_file() or (target / "index.html").is_file()):
            bad.append(f"{page.relative_to(root)}: {m.group(1)}")
print("\n".join(sorted(set(bad))) if bad else "all local links lead somewhere")
sys.exit(1 if bad else 0)
