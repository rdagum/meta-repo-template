# <repo-name>

<!-- Copy to docs/agent-guides/<repo-name>.md. Delete sections that do not apply and every
     comment. Every command below must have been run successfully before it is written down. -->

**Purpose:** <one sentence: what this repo owns>
**Stack:** <e.g. TypeScript + Vite + Vitest | .NET 8 Web API | Python 3.12 + FastAPI | Terraform + Ansible>
**Default branch:** `main`
**Pipeline:** <Azure Pipelines definition path, e.g. `azure-pipelines.yml`; what it runs on PR vs merge>
**Owners:** <team or people>

## Setup (first time)

```bash
# prerequisites: runtime versions, package manager, SDKs, CLIs
# e.g. node 22 (see .nvmrc), pnpm 9      |  dotnet 8 SDK  |  python 3.12 + uv  |  terraform 1.9
# install
```

## Build

```bash
```

## Test

```bash
# unit
# integration (and what it needs running: docker compose up -d db ...)
# a single test file / filter
```

## Run locally

```bash
# command, port, URL, which env vars are required and where to get non-secret defaults
```

## Lint and format

```bash
```

## Layout

<!-- Only the folders an agent needs to find its way. -->

```
src/
tests/
```

## Conventions

<!-- Repo-specific. Naming, module boundaries, error handling, logging, how migrations are added,
     commit message format if different from the workspace default. -->

## Talks to

<!-- Upstream and downstream services, queues, databases. Protocol and contract location
     (OpenAPI file, proto, event schema). -->

## Infra and deployment

<!-- Where IaC lives, which pipeline deploys, which environments. State clearly that agents prepare
     changes and humans apply them. -->

## Gotchas

<!-- Things that have bitten people or agents. Each one a sentence or two. Date entries that may
     expire. -->

## Do not

<!-- Hard prohibitions specific to this repo. -->
