---
name: work-ticket
description: Start, resume or close multi-session work tracked in tickets/. Use when a task will span sessions, when the user mentions a ticket or work item, or at the start and end of any session that continues earlier work.
---

# Work a ticket

Tickets are the workspace's extended memory. See `tickets/README.md` for the lifecycle.

## Starting new work

1. Check `tickets/` and `tickets/done/` for the same or similar work first.
2. `./scripts/new-ticket.sh "title"` (add `--id AB-123` for an Azure Boards item).
3. Fill *Goal*, *Scope*, *Repos touched* and a first *Plan* with the user. For cross-repo work,
   one plan step per repo PR, in merge order. Get approval before editing code.

## Resuming

1. Read the whole ticket. *Next steps* is where you start; *Decisions* and *Lessons* are constraints.
2. Run `./scripts/status.sh` and confirm the repos are in the state the ticket expects.
3. Say what you are about to do in one line, then do it.

## Before stopping (every session, including interrupted ones)

Append a dated entry to *Log*: what was done, what was learned, what is unverified. Rewrite *Next
steps* so a stranger could continue. Update *Status*. Add decisions to *Decisions*; if one is
architectural, create an ADR and link it.

## Closing

Fill *Outcome* (what shipped, PR links) and *Lessons*. Move recurring gotchas into the relevant
agent guide in the same PR. Set status `done` and move the file to `tickets/done/`.

## Never

- Paste secrets, tokens or production data into a ticket.
- Rewrite earlier *Log* entries. Append a correction instead.
