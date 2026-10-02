# ADR-0001: Adopt a meta repo for {{PRODUCT_NAME}}

- **Status:** accepted
- **Date:** {{DATE}}
- **Deciders:** {{OWNER_PLATFORM}}
- **Related:** [The Meta-Repo Pattern](https://devnewsletter.com/p/meta-repo-pattern/),
  [Operating a Meta-Repo](https://devnewsletter.com/p/operating-a-meta-repo/)

## Context

{{PRODUCT_NAME}} is built from one or more repositories, each with its own CI, release cadence and
access control. Humans and AI coding agents working in any one repo lack the cross-repo context:
how services connect, how each repo is built and tested, which decisions constrain changes, and
what work is in flight. Agents in particular start every session stateless, so this knowledge must
exist in files they can read.

Options considered: a monorepo migration (high cost, loses per-repo autonomy), per-repo
instruction files only (no cross-repo view, duplicated rules), or a meta repo above the product
repos (this decision).

## Decision

Keep product code where it is. Create a meta repo that holds the manifest of repos, the
root agent instructions, per-repo guides, decision records, multi-session work tickets and the
scripts that operate the workspace. Product repos are cloned under `repos/` and are not committed.

## Rule

- Application code never lives in the meta repo.
- Cross-repo knowledge (architecture narrative, guides, ADRs, tickets) lives in the meta repo, not
  duplicated into product repos. A product repo may keep a short instruction file that points here.
- `repos.json` is the single source of truth for which repos make up the product.
- Hand-written files carry policy and reasoning. Topology is generated or, until a generator exists,
  explicitly labelled hand-maintained and dated.
- Changes to the workspace contract (`CLAUDE.md`, `.claude/`, `repos.json`, `scripts/`, ADRs) go
  through pull request review by the owners in `CODEOWNERS`.
- When a repo, service, pipeline or command is renamed or retired, the meta repo is updated in the
  same change.

## Consequences

- One `git clone` plus `scripts/sync.sh` gives a new team member or agent a fully configured workspace.
- Cross-repo work has a place to be planned, tracked and reviewed.
- The meta repo needs active maintenance. Stale instructions produce confidently wrong behaviour,
  so ownership and review are mandatory, not optional.
- Atomic cross-repo commits remain impossible; cross-repo changes are coordinated through tickets
  and sequenced PRs.

## Follow-ups

- Populate `repos.json` and write one guide per repo.
- Configure the Azure Repos branch policy that mirrors `CODEOWNERS`.
