#!/usr/bin/env bash
# Shared helpers for workspace scripts. Source this file; do not run it.
#
# Manifest access goes through `manifest_value` / `repo_rows`, which use jq when installed and fall
# back to python3 or node, so the scripts run on a bare Git Bash as well as on Linux/macOS.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${MANIFEST:-$ROOT_DIR/repos.json}"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[[ -f "$MANIFEST" ]] || die "manifest not found: $MANIFEST"

# manifest_value <key> [default]   -> top-level string value
manifest_value() {
  local key="$1" default="${2:-}"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg k "$key" --arg d "$default" '.[$k] // $d' "$MANIFEST"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    local py; py="$(command -v python3 || command -v python)"
    "$py" - "$MANIFEST" "$key" "$default" <<'PY'
import json, sys
m = json.load(open(sys.argv[1], encoding="utf-8"))
v = m.get(sys.argv[2], sys.argv[3])
print(v if v is not None else sys.argv[3])
PY
  elif command -v node >/dev/null 2>&1; then
    node -e 'const m=require(process.argv[1]);const v=m[process.argv[2]];console.log(v??process.argv[3])' "$MANIFEST" "$key" "$default"
  else
    die "need jq, python3 or node to read $MANIFEST"
  fi
}

# repo_rows [tag]
# Prints one tab-separated row per repo: name, url, defaultBranch, tags(comma), guide
# Optionally filtered to repos carrying <tag>.
repo_rows() {
  local tag="${1:-}"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg t "$tag" '
      .repos[]
      | select($t == "" or ((.tags // []) | index($t)) != null)
      | [.name, .url, (.defaultBranch // "main"), ((.tags // []) | join(",")), (.guide // "")]
      | @tsv' "$MANIFEST"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    local py; py="$(command -v python3 || command -v python)"
    "$py" - "$MANIFEST" "$tag" <<'PY'
import json, sys
m = json.load(open(sys.argv[1], encoding="utf-8")); tag = sys.argv[2]
for r in m.get("repos", []):
    tags = r.get("tags", [])
    if tag and tag not in tags:
        continue
    print("\t".join([r["name"], r["url"], r.get("defaultBranch", "main"), ",".join(tags), r.get("guide", "")]))
PY
  elif command -v node >/dev/null 2>&1; then
    node -e '
      const m=require(process.argv[1]); const tag=process.argv[2];
      for (const r of m.repos||[]) { const tags=r.tags||[]; if (tag && !tags.includes(tag)) continue;
        console.log([r.name, r.url, r.defaultBranch||"main", tags.join(","), r.guide||""].join("\t")); }' "$MANIFEST" "$tag"
  else
    die "need jq, python3 or node to read $MANIFEST"
  fi
}

clone_root() {
  local rel; rel="$(manifest_value cloneRoot repos)"
  printf '%s/%s\n' "$ROOT_DIR" "$rel"
}

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

today() { date +%Y-%m-%d; }
