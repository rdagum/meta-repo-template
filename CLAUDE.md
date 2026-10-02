# {{PRODUCT_NAME}} workspace

This is a **meta repo**: documentation, manifest, scripts and agent config only. Product code lives
in `repos/<name>/`, cloned by `scripts/sync.sh` from `repos.json`. Treat this file as a table of
contents; load deeper material only when the task needs it.

## Universal rules

- Code changes happen inside `repos/<name>/`. Never put application code in this repo.
- Before building, testing or committing in a repo, read its guide at `docs/agent-guides/<name>.md`.
  If the guide is missing or wrong, fix the guide as part of your change.
- Policy here is hand-written; topology should be generated. If `docs/generated/` and any prose
  disagree, trust the generated file and say so.
- Cross-repo changes: plan first, list every repo touched, and get explicit approval before editing.
- Never read, commit or print secrets: `.env*`, keys, tokens, connection strings.
  `.claude/settings.json` denies them; do not work around it.
- Deployments, releases, data migrations, pipeline edits and anything touching production need a
  human. Prepare the change and stop; do not run it.
- Multi-session work lives in `tickets/`. Read the active ticket before starting; update it before
  stopping with decisions, discoveries, gotchas and remaining work.
- Architectural changes (new service, datastore, cross-repo dependency, protocol or contract change)
  need an ADR in `docs/adr/`. ADRs are prescriptive: follow the rules in accepted ADRs.
- Each product repo keeps its own conventions, CI and release process. Respect them over habits
  carried from other repos.
- Pull requests go through Azure DevOps. Use the PR template. Agent-authored changes get the same
  review as human-authored ones.

## Skills (Tier 2 — load on demand)

| Skill | Use when |
|---|---|
| `sync-repos` | Cloning, updating or inspecting the repos in the manifest |
| `work-ticket` | Starting, resuming or closing multi-session work |

## Reference (Tier 3 — read when full context is needed)

- `docs/architecture.md` — narrative system overview and the reasoning behind it
- `docs/agent-guides/<repo>.md` — per-repo build, test, run, conventions, gotchas
- `docs/generated/` — generated topology; see its README for status
- `docs/adr/` — decision records
- `tickets/` — active work; `tickets/done/` — past work and lessons

## Workspace commands

```
./scripts/sync.sh [--tag t] [name...]   clone or fast-forward repos from repos.json
./scripts/status.sh                     branch, dirty state, ahead/behind per repo
./scripts/new-ticket.sh "title"         scaffold a ticket in tickets/
./scripts/new-adr.sh "title"            scaffold an ADR with the next ID
```

## Maintaining this file

Keep it under 100 lines. Only rules that apply to every task belong here. Add a rule when an agent
gets something wrong repeatedly; remove one when it stops being true. Changes need owner review
(see `CODEOWNERS`).
