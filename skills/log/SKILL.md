---
name: log
description: Use to record progress and notable changes as work happens, so intent and history are traceable without reconstructing them later from memory or git archaeology.
---

# Log

## Purpose
Keep a running, human-readable record of what happened and why, written at the time of the work — not reconstructed afterward.

## When to use
- After completing a meaningful step in `build`, `debug`, or `refactor`.
- When a decision is made that isn't already captured by a `decision-log` entry but affects this unit of work.
- Before `closeout`, to make sure the record is complete.

## Process
1. **Write it when it happens.** Log entries lose value the longer they're deferred — capture the change while context is fresh.
2. **Say what changed and why**, not just what files were touched. "Why" is the part that can't be recovered from a diff later.
3. **Keep it short.** One or a few lines per entry. This is a trail, not documentation — link out to fuller docs (design, ADRs) rather than duplicating them.
4. **Note deviations.** If the work departed from the `plan`/`design`, say so and why — this is what future readers most need to know.

## Output
A chronological entry (changelog, session log, or equivalent) describing what changed, why, and any deviation from plan.

## Handoff
Feeds `closeout`, which should be able to summarize the unit of work from the log without re-deriving it from the diff.

## Checklist
- [ ] Entry was written close to when the work happened, not backfilled from memory
- [ ] Entry explains why, not just what
- [ ] Any deviation from the plan/design is called out
- [ ] Entry is concise and links to fuller docs rather than duplicating them
