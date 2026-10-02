#!/usr/bin/env bash
# Scaffold an Architecture Decision Record with the next sequential id.
#
# Usage:  ./scripts/new-adr.sh "Use the shared PostgreSQL pool for all services"

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

title="${1:-}"
[[ -n "$title" ]] || die 'usage: new-adr.sh "title"'

dir="$ROOT_DIR/docs/adr"
last="$(ls "$dir" | grep -E '^[0-9]{4}-' | sort | tail -n1 | cut -c1-4 || true)"
next="$(printf '%04d' $(( 10#${last:-0} + 1 )))"
file="$dir/${next}-$(slugify "$title").md"

sed -e "s|{{ID}}|$next|g" \
    -e "s|{{TITLE}}|$title|g" \
    -e "s|{{DATE}}|$(today)|g" \
    "$dir/0000-template.md" > "$file"

say "created $file"
