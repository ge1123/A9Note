"""Assemble the GitHub Pages artifact and check local HTML references."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit
import shutil

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "_site"
# Add a mapping and a homepage link when another certification site is ready.
SITES = {"az-104": "AZ-104-Azure Administrator/site"}


class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []

    def handle_starttag(self, tag, attrs):
        self.urls.extend(value for key, value in attrs if key in ("href", "src") and value)


def build():
    for source in [ROOT / "site", *(ROOT / path for path in SITES.values())]:
        if not (source / "index.html").is_file():
            raise SystemExit(f"Missing entry point: {source / 'index.html'}")
    if OUTPUT.exists():
        shutil.rmtree(OUTPUT)
    ignore = shutil.ignore_patterns("*.md", ".DS_Store")
    shutil.copytree(ROOT / "site", OUTPUT, ignore=ignore)
    for slug, source in SITES.items():
        shutil.copytree(ROOT / source, OUTPUT / slug, ignore=ignore)
    errors = []
    pages = list(OUTPUT.rglob("*.html"))
    for page in pages:
        parser = References()
        parser.feed(page.read_text(encoding="utf-8"))
        for url in parser.urls:
            parts = urlsplit(url)
            if parts.scheme or parts.netloc or not parts.path:
                continue
            target = (page.parent / unquote(parts.path)).resolve()
            if parts.path.startswith("/") or OUTPUT not in target.parents:
                errors.append(f"{page.relative_to(OUTPUT)}: path outside site: {url}")
            elif not target.exists() or (target.is_dir() and not (target / "index.html").is_file()):
                errors.append(f"{page.relative_to(OUTPUT)}: missing target: {url}")
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"Built {len(pages)} HTML pages; local href/src paths checked: {OUTPUT}")


if __name__ == "__main__":
    build()
