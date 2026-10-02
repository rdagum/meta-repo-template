# Architecture Decision Records

Stable ids, one decision per file, never edited after acceptance except to change status.
Create one with `./scripts/new-adr.sh "title"`.

ADRs here are **prescriptive**. A traditional ADR explains a choice to humans: "We chose PostgreSQL
for transactional consistency." An agent-facing ADR also states the rule that follows:
"All database access goes through the shared PostgreSQL pool. Do not introduce another datastore
without an accepted ADR." Agents read the *Rule* section and comply; humans read the *Context* to
understand why.

## When an ADR is required

- A new service, repo, datastore, queue or third-party dependency
- A new dependency between repos, or a change to a cross-repo contract (API, events, schemas)
- A change to how code is built, tested, deployed or released across the product
- Reversing or superseding an earlier ADR

`CLAUDE.md` instructs agents to write an ADR whenever a change meets one of these. Review it like code.

## Statuses

`proposed` → `accepted` | `rejected`; later `deprecated` or `superseded by ADR-nnnn`.

## Index

| ID | Title | Status |
|---|---|---|
| [0001](0001-adopt-meta-repo.md) | Adopt a meta repo for {{PRODUCT_NAME}} | accepted |
