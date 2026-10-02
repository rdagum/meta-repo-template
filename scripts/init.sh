#!/usr/bin/env bash
# Instantiate this template for a new product: fills in the {{PLACEHOLDERS}} across the repo.
#
# Usage:
#   ./scripts/init.sh --product "Acme Billing" --org acme --project Billing \
#                     [--owner-platform "@acme/platform"] [--owner-architecture "@acme/architects"]
#
# Run once, right after copying the template. Review `git diff` afterwards, then commit.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

product=""; org=""; project=""; owner_p=""; owner_a=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --product) product="$2"; shift 2 ;;
    --org) org="$2"; shift 2 ;;
    --project) project="$2"; shift 2 ;;
    --owner-platform) owner_p="$2"; shift 2 ;;
    --owner-architecture) owner_a="$2"; shift 2 ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done
[[ -n "$product" && -n "$org" && -n "$project" ]] || die "--product, --org and --project are required"
owner_p="${owner_p:-platform-team@$org.example}"
owner_a="${owner_a:-architecture@$org.example}"

# Files that carry placeholders. Excludes repos/ (clones), scripts/ (their placeholders are used at
# run time) and the two scaffold templates filled by new-ticket.sh / new-adr.sh.
mapfile -t files < <(grep -rl --exclude-dir=repos --exclude-dir=.git --exclude-dir=scripts --exclude='_template.md' --exclude='0000-template.md' '{{[A-Z_]*}}' "$ROOT_DIR")

# Portable in-place edit (GNU and BSD sed differ on -i): write to a temp file, then move.
for f in "${files[@]}"; do
  sed \
    -e "s|{{PRODUCT_NAME}}|$product|g" \
    -e "s|{{ORG}}|$org|g" \
    -e "s|{{PROJECT}}|$project|g" \
    -e "s|{{OWNER_PLATFORM}}|$owner_p|g" \
    -e "s|{{OWNER_ARCHITECTURE}}|$owner_a|g" \
    -e "s|{{DATE}}|$(today)|g" \
    "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  say "templated ${f#$ROOT_DIR/}"
done

left="$(grep -rn --exclude-dir=repos --exclude-dir=.git --exclude-dir=scripts --exclude='_template.md' --exclude='0000-template.md' '{{[A-Z_]*}}' "$ROOT_DIR" || true)"
if [[ -n "$left" ]]; then
  warn "placeholders remaining (fill by hand):"
  printf '%s\n' "$left"
fi

cat <<EOF

Next:
  1. Edit repos.json: replace the example-* entries with real repos.
  2. Write docs/architecture.md.
  3. ./scripts/sync.sh, then one guide per repo from docs/agent-guides/_template.md.
  4. Delete the "Adopting this template" section from README.md.
  5. Set up the Azure Repos branch policy that mirrors CODEOWNERS.
EOF
