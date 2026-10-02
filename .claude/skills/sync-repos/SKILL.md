---
name: sync-repos
description: Clone, update or inspect the product repos listed in repos.json. Use before working in any repo, when a repo is missing under repos/, or when asked which repos exist or what state they are in.
---

# Sync repos

`repos.json` is the single source of truth for which repos make up the product. Clones live under
`repos/<name>/` and are git-ignored.

## Commands

```bash
./scripts/status.sh                 # which repos exist, branch, dirty, ahead/behind
./scripts/status.sh --fetch         # same, with fresh upstream counts
./scripts/sync.sh                   # clone missing, fast-forward clean ones on default branch
./scripts/sync.sh --tag backend     # subset by tag
./scripts/sync.sh example-api       # subset by name
```

## Rules

- Run `status.sh` before `sync.sh` when you are unsure what is checked out. Sync never discards
  work: dirty trees and non-default branches are skipped and reported. Leave them alone unless the
  user asks.
- A repo missing from `repos/` but present in `repos.json`: run sync. A repo present in `repos/`
  but missing from `repos.json`: tell the user; do not add manifest entries on your own.
- Adding or changing a manifest entry is a workspace-contract change: do it in a PR, keep the entry
  valid against `scripts/repos.schema.json`, and add the matching `docs/agent-guides/<name>.md`.
- After syncing a repo for the first time, read its guide before running anything inside it.
