# {{PRODUCT_NAME}} architecture

> Narrative, not reference. `CLAUDE.md` gives agents the map; this file gives them the story:
> what the system is for, why it is shaped the way it is, and what would break if that shape
> changed. Keep it honest and current. If something here contradicts a generated artifact in
> `docs/generated/`, the generated artifact is right and this file needs fixing.

## What the product does

<!-- Two or three paragraphs. Who the users are, the main jobs the product does for them, the
     business constraints that matter (compliance, SLAs, cost ceilings). -->

## Repos and what each one owns

<!-- One row per entry in repos.json. "Owns" means the data or capability no other repo may
     implement. Mirror the names exactly; the sync script and guides key off them. -->

| Repo | Owns | Talks to | Guide |
|---|---|---|---|
| `example-web` | UI, session handling | `example-api` over HTTPS/JSON | `agent-guides/example-web.md` |
| `example-api` | Domain logic, persistence | database, message bus | `agent-guides/example-api.md` |

## How a request flows

<!-- Walk one or two representative flows end to end across repos. This is the view a single-repo
     agent cannot see; it is the most valuable paragraph in this file. -->

## Environments and infrastructure

<!-- Dev / test / prod. Where infra-as-code lives (Terraform, Ansible, Compose), who applies it, and
     the rule that agents prepare infra changes but humans apply them. -->

## Cross-repo dependencies (hand-maintained)

<!-- Until a generator writes docs/generated/dependency-map.md, keep the list here and date it.
     Delete this section the day the generator exists. -->

Last reviewed: {{DATE}}

- `example-web` → `example-api` (REST, versioned under `/v1`)

## Design decisions that constrain everyone

<!-- Link the ADRs. One line each: the rule, not the history. -->

- [ADR-0001](adr/0001-adopt-meta-repo.md): context, decisions and multi-session work live in this
  meta repo, not in product repos.

## Known rough edges

<!-- The things an experienced team member would warn a newcomer about. Agents need these too. -->
