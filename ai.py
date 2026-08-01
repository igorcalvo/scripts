#!/usr/bin/env python3
from __future__ import annotations

import argparse
import difflib
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

MAX_FILE_DEPTH = 10
TREE_DEPTH = 10
IGNORED_DIRS = {".git", "node_modules", "dist", "build", "__pycache__"}

LANG_MAP = {
    ".py": "python",
    ".ts": "ts",
    ".tsx": "tsx",
    ".js": "js",
    ".jsx": "jsx",
    ".json": "json",
    ".md": "md",
    ".txt": "text",
    ".yaml": "yaml",
    ".yml": "yaml",
    ".sh": "bash",
    ".css": "css",
    ".scss": "scss",
    ".html": "html",
}


def ignored(parts):
    return any(p in IGNORED_DIRS for p in parts)


def iter_files(root: Path):
    for p in root.rglob("*"):
        if not p.is_file():
            continue
        rel = p.relative_to(root)
        if ignored(rel.parts):
            continue
        if len(rel.parts) - 1 > MAX_FILE_DEPTH:
            continue
        yield p


def find_file(root: Path, query: str) -> Path:
    direct = (root / query).resolve()
    if direct.is_file():
        return direct

    base = Path(query).name.lower()
    matches = [p for p in iter_files(root) if p.name.lower() == base]
    if len(matches) == 1:
        return matches[0]
    if len(matches) > 1:
        print(f'Multiple matches for "{query}":', file=sys.stderr)
        for m in matches:
            print(f"  - {m.relative_to(root)}", file=sys.stderr)
        sys.exit(1)

    candidates = [str(p.relative_to(root)) for p in iter_files(root)]
    sugg = difflib.get_close_matches(query, candidates, n=5, cutoff=0.5)
    print(f'Could not find "{query}".', file=sys.stderr)
    if sugg:
        print("Did you mean:", file=sys.stderr)
        for s in sugg:
            print(f"  - {s}", file=sys.stderr)
    sys.exit(1)


def tree(root: Path, depth=TREE_DEPTH):
    lines = ["."]

    def walk(cur: Path, prefix: str, lvl: int):
        if lvl >= depth:
            return
        entries = sorted(
            [e for e in cur.iterdir() if e.name not in IGNORED_DIRS],
            key=lambda x: (x.is_file(), x.name.lower()),
        )
        for i, e in enumerate(entries):
            last = i == len(entries) - 1
            branch = "└── " if last else "├── "
            lines.append(prefix + branch + e.name)
            if e.is_dir():
                walk(e, prefix + ("    " if last else "│   "), lvl + 1)

    walk(root, "", 0)
    return "\n".join(lines)


def lang(path: Path):
    return LANG_MAP.get(path.suffix.lower(), "")


def copy_clipboard(text: str):
    if shutil.which("wl-copy"):
        subprocess.run(["wl-copy"], input=text.encode(), check=True)
        return "wl-copy"
    if shutil.which("xclip"):
        subprocess.run(
            ["xclip", "-selection", "clipboard"], input=text.encode(), check=True
        )
        return "xclip"
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("-o", "--output", default="submit.txt")
    ap.add_argument("--copy", action="store_true")
    args = ap.parse_args()

    root = Path.cwd()
    files = [find_file(root, f) for f in args.files]

    cmd = " ".join(sys.argv)
    now = datetime.now().strftime("%H:%M")

    out = []
    out.append(f"Generated: {now}")
    out.append("")
    out.append(f"Working directory:\n{root}")
    out.append("")
    out.append("Command:")
    out.append(cmd)
    out.append("")
    out.append("=" * 80)
    out.append(f"REPOSITORY TREE (depth={TREE_DEPTH})")
    out.append("=" * 80)
    out.append(tree(root))
    out.append("")

    for f in files:
        rel = f.relative_to(root)
        out.append("=" * 80)
        out.append(f"FILE: {rel}")
        out.append("=" * 80)
        out.append("")
        out.append(f"```{lang(f)}")
        try:
            out.append(f.read_text(encoding="utf-8"))
        except UnicodeDecodeError:
            out.append("[Binary file omitted]")
        out.append("```")
        out.append("")

    text = "\n".join(out)
    out_path = root / args.output
    out_path.write_text(text, encoding="utf-8")

    print(f"Wrote {out_path}")

    if args.copy:
        tool = copy_clipboard(text)
        if tool:
            print(f"Copied to clipboard via {tool}")
        else:
            print("No clipboard tool found (tried wl-copy and xclip).")


if __name__ == "__main__":
    main()
