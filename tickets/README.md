# Tickets: extended memory for multi-session work

A ticket is a version-controlled Markdown file that tracks one piece of work across agent sessions
and across people. The agent reads it before starting, writes to it before stopping. The next
session, or the next person, continues from the last checkpoint.

This is not automatic memory. It is structured, human-reviewable documentation. The agent benefits,
but the real value is for humans: an auditable trail you can review, correct and learn from.

## Lifecycle

```bash
./scripts/new-ticket.sh "Migrate auth to the new identity provider"
./scripts/new-ticket.sh "Add rate limiting" --id AB-1234     # keyed by an Azure Boards id
```

1. Fill in *Goal* and *Scope*. Link the Azure Boards work item if one exists.
2. Each session: update *Status*, append to *Log*, keep *Next steps* truthful.
3. Decisions that affect architecture become ADRs; link them from the ticket.
4. Done: set status, write the *Outcome* and *Lessons* sections, move the file to `tickets/done/`.

## Rules

- One ticket per outcome, not per session.
- The *Log* is append-only. Correct earlier entries by adding a new one.
- Gotchas discovered during the work go in *Lessons* and, if they will recur, into the relevant
  agent guide in the same PR.
- Never paste secrets, tokens or production data into a ticket.

`tickets/done/` is a knowledge base. Search it before starting similar work.
