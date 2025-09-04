#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <deck-name>   (e.g., $0 hello-world)" >&2
  exit 1
fi

raw="$1"

# slugify (letters, digits, hyphens)
slug="$(echo "$raw" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-+|-+$//g')"
if [[ -z "$slug" ]]; then
  echo "Error: invalid deck name '$raw' (after slugify it became empty)" >&2
  exit 1
fi

deckdir="slides/$slug"
if [[ -e "$deckdir" ]]; then
  echo "Error: '$deckdir' already exists" >&2
  exit 1
fi

echo "==> Creating deck at $deckdir"
mkdir -p "$deckdir"

# package.json (dev script + build script)
cat > "$deckdir/package.json" <<EOF
{
  "name": "deck-$slug",
  "private": true
}
EOF

# Minimal slides.md
cat > "$deckdir/slides.md" <<'EOF'
---
theme: default
title: Hello Slidev
---

# Hello, Slidev 👋

This is a tiny deck scaffolded by `new-deck.sh`.

---

## A second slide

- Markdown works
- Code works:

```ts
console.log("hello");
```
EOF

# Install deps (creates pnpm-lock.yaml)
echo "==> Installing dependencies"
(
cd "$deckdir"
pnpm -w install
)
echo
echo "✅ Done. Next steps:"
echo " nix develop"
echo " # dev server:"
echo " serve-deck $deckdir"
echo
echo "To build into your site output (what CI does):"
echo " build-site && build-decks"
