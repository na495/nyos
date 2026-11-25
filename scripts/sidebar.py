#!/usr/bin/env python3
from pathlib import Path

root = Path(__file__).resolve().parent.parent
docs = root / "docs"
notes = docs / "notes"


# 1. 목차(_sidebar.md) 갱신
def title_of(f):
    for line in f.read_text(encoding="utf-8").splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return f.stem

lines = ["- [🔧 트러블슈팅](/notes/troubleshooting.md)", ""]
for f in sorted(notes.glob("[0-9][0-9]-*.md")):
    lines.append(f"- [{title_of(f)}](/notes/{f.name})")

(docs / "_sidebar.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print("목차 갱신 완료")


# 2. README.md → docs/index.md (사이트 첫 화면)
#    README 링크의 "docs/" 를 떼서 사이트 기준 경로로 바꿈
readme = (root / "README.md").read_text(encoding="utf-8")
readme = readme.replace("](docs/", "](").replace("](./docs/", "](")

(docs / "index.md").write_text(
    "<!-- README.md 에서 자동 생성 (make sidebar). 직접 수정 X -->\n\n" + readme,
    encoding="utf-8",
)
print("첫 화면 갱신 완료 (README.md → docs/index.md)")
