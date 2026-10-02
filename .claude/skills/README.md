# Skills (Tier 2)

A skill is a Markdown file at `.claude/skills/<name>/SKILL.md` that an agent loads only when a task
calls for it. Skills are the chapters between the root `CLAUDE.md` (table of contents) and the
agent guides (appendices). They keep task-specific instructions out of the every-session context.

The starter ships two skills tied to this workspace's scripts. Add more only when a workflow has
been done by hand enough times to know what the steps are. Good candidates for a meta repo:

- `release` — the full path from merged PR to production for this product, including the human gates
- `create-new-service` — scaffold a repo, register it in `repos.json`, add CI, write its guide
- `cross-repo-change` — plan, sequence and open PRs across several repos
- `self-review-checklist` — what to verify before declaring any change done

## Format

```markdown
---
name: skill-name
description: One line. When to use it. Agents match on this, so be concrete.
---

# Skill name

Steps, rules, commands. Point at guides for depth rather than repeating them.
```

Keep the content runtime-neutral Markdown so other agents can read it too (see `AGENTS.md`).
Register each new skill in the table in `CLAUDE.md`.
