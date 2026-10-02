# Agent instructions

Durable knowledge in this workspace is kept in portable Markdown and JSON so any coding agent can
use it. Tool-specific wrappers are a thin layer on top.

| Layer | Location | Portable? |
|---|---|---|
| Root rules (read first) | [`CLAUDE.md`](./CLAUDE.md) | Yes, plain Markdown |
| Task skills | `.claude/skills/<name>/SKILL.md` | Yes, plain Markdown with a small front matter |
| Per-repo guides | `docs/agent-guides/<repo>.md` | Yes |
| Decisions | `docs/adr/` | Yes |
| Active work | `tickets/` | Yes |
| Repo manifest | `repos.json` | Yes |
| Permission boundaries | `.claude/settings.json` | Claude Code specific; mirror in your runtime |

If your runtime does not load `CLAUDE.md` automatically, read it as the root instruction set for
this repo. If your runtime has its own instruction file name (for example `.cursorrules` or
`GEMINI.md`), add a one-line file pointing here rather than duplicating content.
