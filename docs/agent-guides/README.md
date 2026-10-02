# Agent guides (Tier 3)

One file per repo in `repos.json`, named exactly after the repo: `docs/agent-guides/<name>.md`.
Agents read a guide only when they are about to work in that repo, so a guide can be long.

Start from `_template.md`. Fill in only what you can verify by running it. A guide that says
`npm test` when the repo uses `bun test` is worse than no guide: the agent will follow it with
confidence.

## The acceptance test

Launch an agent at the root of this workspace and say:

> run the tests for `<repo>`

If that does not work first try, the guide is missing something. Fix the guide, not the agent.

## When to update

- A build, test or run command changes
- A convention is added or dropped
- The agent got something wrong twice. Write down the correction where it will be read next time.
- A service, pipeline or dependency is renamed or retired. Remove the stale reference in the same PR.

## What does not belong here

- Dependency topology between repos: that is generated (`docs/generated/`) or, until a generator
  exists, kept in `docs/architecture.md`.
- Rules that apply to every repo: those go in `CLAUDE.md`.
- Secrets or environment values: never.
