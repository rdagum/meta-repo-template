# {{PRODUCT_NAME}} — Meta Repo

> A **meta repo** (virtual monorepo) is a standalone repository that contains **no application
> code**. It holds the documentation, manifest, scripts and agent configuration that give humans
> and AI coding agents the cross-repo context a single product repo cannot provide.
>
> Background: [The Meta-Repo Pattern](https://devnewsletter.com/p/meta-repo-pattern/) ·
> [Operating a Meta-Repo](https://devnewsletter.com/p/operating-a-meta-repo/)

## Why this exists

Every agent session starts stateless. A feature in {{PRODUCT_NAME}} may touch several repos, but an
agent scoped to one of them sees only part of the picture. This repo is the shared context layer
above the product repos: the *why* behind the architecture, how the pieces connect, how to build
and test each one, and which actions need a human.

The product repos keep their own CI, release cadence and access controls. Nothing moves here.
A product with a single repo still benefits: this is where context, tickets and decisions live
without polluting the product code.

## Layout

```
.
├── CLAUDE.md                  Tier 1 — universal rules, under 100 lines, loaded every session
├── AGENTS.md                  Runtime-neutral entry point for non-Claude agents
├── repos.json                 Manifest: every product repo, URL, default branch, tags
├── CODEOWNERS                 Named owners of the workspace contract (see note below)
├── .azuredevops/
│   └── pull_request_template.md
├── .claude/
│   ├── settings.json          Permission boundaries: files agents may never read or commit
│   └── skills/*/SKILL.md      Tier 2 — task-specific behaviour, loaded on demand
├── docs/
│   ├── architecture.md        Narrative: what the system is and why it is shaped this way
│   ├── agent-guides/          Tier 3 — one deep reference per repo (build, test, conventions)
│   ├── adr/                   Architecture Decision Records, prescriptive and agent-readable
│   └── generated/             Machine-generated topology. Never hand-edit; regenerate.
├── tickets/                   Active multi-session work: extended memory for agents and humans
│   └── done/                  Completed tickets, kept as a searchable knowledge base
├── scripts/                   sync, status, new-ticket, new-adr, init
└── repos/                     Product repos are cloned here (git-ignored)
```

## Quick start

Requirements: `bash`, `git`, `jq`. On Windows use Git Bash; install jq with `winget install jqlang.jq`.

```bash
# 1. Instantiate the template: fills in product, org and Azure DevOps project names
./scripts/init.sh --product "Acme Billing" --org "acme" --project "Billing"

# 2. Describe the product repos
$EDITOR repos.json

# 3. Clone or fast-forward every repo in the manifest
./scripts/sync.sh              # all repos
./scripts/sync.sh --tag backend

# 4. See branch, dirty state and ahead/behind for every repo
./scripts/status.sh

# 5. Write a guide per repo from the template
cp docs/agent-guides/_template.md docs/agent-guides/<repo>.md
```

Then open an agent session at the root of this repo. The test that matters:
**any developer should be able to launch the agent, say "run the tests for `<repo>`", and have it
work first try.** If it does not, that repo's guide is missing commands.

## Operating rules

1. **Policy is hand-written, topology is generated.** `CLAUDE.md`, skills and guides explain *why*
   and *how we work*. Which repo depends on which belongs in `docs/generated/` and should come from a
   script. When prose and the generated map disagree, the generated map wins. Fix the prose.
2. **Context is scarce.** `CLAUDE.md` loads every session, so it carries only rules that apply to
   every task. Anything narrower goes in a skill or a guide. Audit it: does each line still apply?
3. **Gate changes like code.** The workspace contract (`CLAUDE.md`, `repos.json`, `.claude/`,
   `scripts/`, ADRs) merges only after review by its owners, so one person's local habit does not
   silently become everyone's rule.
4. **Document what the agent gets wrong,** not everything you think it should know. Start with
   guardrails, grow a manual only where it earns its place.
5. **Stale is worse than missing.** A meta repo that drifts from reality produces confidently wrong
   behaviour at agent speed. When a service is renamed or a pipeline retired, update or delete the
   reference here in the same change.

## Azure DevOps notes

- `CODEOWNERS` is not enforced by Azure Repos. It documents ownership for humans and agents. To
  enforce it, add a **branch policy** on `main` with *Automatically included reviewers* for the paths
  listed in `CODEOWNERS`, and require a minimum number of reviewers.
- The PR template at `.azuredevops/pull_request_template.md` is picked up automatically.
- Clone URLs in `repos.json` use the SSH form
  `git@ssh.dev.azure.com:v3/<org>/<project>/<repo>`. The HTTPS form
  `https://dev.azure.com/<org>/<project>/_git/<repo>` works too.

## Working on a multi-session task

```bash
./scripts/new-ticket.sh "Migrate auth to new identity provider"
```

The agent records progress, decisions and gotchas in the ticket and resumes from it next session.
When finished, move the file to `tickets/done/`. The trail is for humans first: review it, correct
it, learn from it.

## Growing beyond the starter

Add these when the need appears, not before:

- **More skills** in `.claude/skills/` for cross-repo workflows (release, create-new-service).
  See `.claude/skills/README.md`.
- **A dependency-map generator** in `scripts/` that writes `docs/generated/dependency-map.md` from
  package manifests. Until then, keep cross-repo dependencies in `docs/architecture.md` and label
  them as hand-maintained.
- **Per-repo instruction overrides** when a repo's conventions are large enough that its guide
  should be split.

## Adopting this template

Run `scripts/init.sh`, replace the two `example-*` entries in `repos.json`, write
`docs/architecture.md`, create one guide per repo, then delete this section.
