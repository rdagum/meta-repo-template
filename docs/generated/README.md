# Generated artifacts

Files in this folder are produced by scripts from source code, package manifests, API schemas or
CI output. **Do not edit them by hand.** When one disagrees with prose elsewhere in this repo, the
generated file is right and the prose needs fixing.

## Status

No generator ships with the starter template. Cross-repo dependencies are kept, dated and clearly
labelled hand-maintained, in `docs/architecture.md`.

## Adding a generator

When the number of repos or the pace of change makes the hand-maintained list unreliable, add
`scripts/gen-dependency-map.sh` that writes `dependency-map.md` here. Detect dependencies between
repos by scanning each clone under `repos/` for references to other repo names in:

| Stack | Files to scan |
|---|---|
| TypeScript / Node | `package.json` dependencies, workspace references, `.env.example` service URLs |
| Python | `pyproject.toml`, `requirements*.txt`, `setup.py` |
| .NET / Java / Go | `*.csproj` ProjectReference / PackageReference, `pom.xml`, `build.gradle*`, `go.mod` |
| Infra | `docker-compose*.yml` service names and images, Terraform module sources, Ansible inventories |

Commit the output, run the generator in CI on a schedule or on manifest change, and fail the build
when the committed file is stale. Then delete the hand-maintained section from `architecture.md`.
