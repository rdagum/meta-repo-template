#!/usr/bin/env bash
# Clone every repo in repos.json that is missing, and fast-forward the ones already present.
#
# Usage:
#   ./scripts/sync.sh                 all repos
#   ./scripts/sync.sh --tag backend   only repos carrying that tag
#   ./scripts/sync.sh api web         only the named repos
#   ./scripts/sync.sh --no-fetch      clone missing repos, leave existing ones untouched
#
# Existing repos are only updated when they are on their default branch with a clean tree.
# Anything else is reported and left alone; this script never discards local work.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

tag=""; fetch=1; names=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag) tag="$2"; shift 2 ;;
    --no-fetch) fetch=0; shift ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) names+=("$1"); shift ;;
  esac
done

root="$(clone_root)"
mkdir -p "$root"

wanted() {
  [[ ${#names[@]} -eq 0 ]] && return 0
  local n; for n in "${names[@]}"; do [[ "$n" == "$1" ]] && return 0; done
  return 1
}

count=0
while IFS=$'\t' read -r name url branch tags guide; do
  wanted "$name" || continue
  count=$((count + 1))
  dir="$root/$name"

  if [[ ! -d "$dir/.git" ]]; then
    say "clone  $name  ($url)"
    git clone --branch "$branch" "$url" "$dir" || { warn "clone failed: $name"; continue; }
  elif [[ $fetch -eq 1 ]]; then
    current="$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
    if [[ -n "$(git -C "$dir" status --porcelain)" ]]; then
      warn "skip   $name  dirty working tree on '$current'"
    elif [[ "$current" != "$branch" ]]; then
      warn "skip   $name  on '$current', not '$branch' (fetched only)"
      git -C "$dir" fetch --prune --quiet || true
    else
      say "update $name  ($branch)"
      git -C "$dir" pull --ff-only --prune --quiet || warn "pull --ff-only failed: $name"
    fi
  fi

  if [[ -n "$guide" && ! -f "$ROOT_DIR/$guide" ]]; then
    warn "no agent guide for $name: expected $guide (copy docs/agent-guides/_template.md)"
  fi
done < <(repo_rows "$tag")

[[ $count -gt 0 ]] || die "no repos matched (tag='${tag}', names='${names[*]:-}')"
say "done: $count repo(s) in $root"
