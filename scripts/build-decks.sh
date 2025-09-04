#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

mkdir -p _site/slides
pnpm -w install || true

decks=()

for deckdir in slides/*; do
  if [[ -f "$deckdir/slides.md" ]]; then
    deckname="$(basename "$deckdir")"
    echo "==> Building Slidev deck: $deckname"
    pnpm -w exec slidev build "$deckdir/slides.md" \
         --base "/slides/${deckname}/" \
         --out "../../_site/slides/${deckname}"
    decks+=("$deckname")
  else
    echo "Skipping $deckdir (missing package.json or slides.md)"
  fi
done
