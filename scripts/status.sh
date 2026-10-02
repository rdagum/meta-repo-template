#!/usr/bin/env bash
# One line per repo in repos.json: presence, branch, dirty state, ahead/behind its upstream.
#
# Usage:  ./scripts/status.sh [--tag t] [--fetch]
#   --fetch   run `git fetch` first so ahead/behind is current (slower)

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

tag=""; fetch=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag) tag="$2"; shift 2 ;;
    --fetch) fetch=1; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

root="$(clone_root)"
printf '%-24s %-22s %-8s %-12s %s\n' REPO BRANCH STATE SYNC TAGS
printf '%-24s %-22s %-8s %-12s %s\n' ---- ------ ----- ---- ----

while IFS=$'\t' read -r name url branch tags guide; do
  dir="$root/$name"
  if [[ ! -d "$dir/.git" ]]; then
    printf '%-24s %-22s %-8s %-12s %s\n' "$name" "-" "missing" "-" "$tags"
    continue
  fi
  [[ $fetch -eq 1 ]] && git -C "$dir" fetch --quiet --prune 2>/dev/null || true
  current="$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
  state="clean"; [[ -n "$(git -C "$dir" status --porcelain)" ]] && state="dirty"
  sync="no-upstream"
  if git -C "$dir" rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
    read -r behind ahead < <(git -C "$dir" rev-list --left-right --count '@{u}...HEAD')
    if [[ "$ahead" == 0 && "$behind" == 0 ]]; then sync="in-sync"
    else sync="+${ahead}/-${behind}"; fi
  fi
  [[ "$current" != "$branch" ]] && current="$current*"
  printf '%-24s %-22s %-8s %-12s %s\n' "$name" "$current" "$state" "$sync" "$tags"
done < <(repo_rows "$tag")

echo
echo "* = not on default branch    +ahead/-behind upstream    run with --fetch for current counts"
