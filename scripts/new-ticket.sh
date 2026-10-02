#!/usr/bin/env bash
# Scaffold a ticket in tickets/ from tickets/_template.md.
#
# Usage:  ./scripts/new-ticket.sh "Short imperative title" [--id AB-123]
#   --id   optional external work item id (Azure Boards etc.) to key the file by

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

title=""; ext=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) ext="$2"; shift 2 ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) title="$1"; shift ;;
  esac
done
[[ -n "$title" ]] || die 'usage: new-ticket.sh "title" [--id AB-123]'

slug="$(slugify "$title")"
prefix="$(today)"
[[ -n "$ext" ]] && prefix="$(slugify "$ext")"
file="$ROOT_DIR/tickets/${prefix}-${slug}.md"
[[ -e "$file" ]] && die "already exists: $file"

sed -e "s|{{TITLE}}|$title|g" \
    -e "s|{{DATE}}|$(today)|g" \
    -e "s|{{EXTERNAL_ID}}|${ext:-none}|g" \
    "$ROOT_DIR/tickets/_template.md" > "$file"

say "created $file"
