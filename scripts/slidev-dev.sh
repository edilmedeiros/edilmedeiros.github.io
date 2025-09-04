#!/usr/bin/env bash
set -euo pipefail

arg="${1:-}"  # don't break if no arg

# Accept either "slides/hello" or just "hello"
if [[ -n "$arg" && -d "$arg" ]]; then
  deckdir="$arg"
elif [[ -n "$arg" && -d "slides/$arg" ]]; then
  deckdir="slides/$arg"
else
  # No (valid) arg: try to auto-pick or list
  mapfile -t decks < <(find slides -maxdepth 1 -mindepth 1 -type d -exec test -f "{}/slides.md" \; -print | sort || true)
  if (( ${#decks[@]} == 0 )); then
    echo "No decks found under slides/ (expecting slides/<deck>/slides.md)" >&2
    exit 1
  else
    echo "Usage: slidev-dev slides/<deck>  or  slidev-dev <deck>" >&2
    echo "Available decks:" >&2
    printf '  %s\n' "${decks[@]}" >&2
    exit 2
  fi
fi

if [[ ! -f "$deckdir/slides.md" ]]; then
  echo "slides.md not found in $deckdir" >&2
  exit 1
fi

# Use shared workspace deps
pnpm -w install || true
pnpm -w exec slidev "$deckdir/slides.md"
