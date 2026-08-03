---
name: closeout
description: Use to finalize a unit of work after release — merging, documentation updates, and confirming delivery is actually complete against its original acceptance criteria.
---

# Closeout

## Purpose
Formally close a unit of work: confirm it delivered what `concept` and `plan` said it would, tie up loose ends, and leave the codebase and docs in a state that doesn't owe anyone anything.

## When to use
- After `release`, once a unit of work is live and verified.
- At the end of a work session, to close out whatever was completed.

## Process
1. **Verify against acceptance criteria.** Check the original requirements/user stories from `concept` — confirm each is actually satisfied, not just "code was written."
2. **Reconcile the log.** Confirm `log` entries reflect what actually shipped, including any deviations from plan.
3. **Update durable docs.** Anything design docs, READMEs, or ADRs reference that changed as a result of this work gets updated now, not left stale.
4. **Merge/finalize.** Complete any remaining merge, tagging, or ticket-closing mechanics.
5. **Run `kaizen`.** Before calling it done, take the continuous-improvement pass — closeout isn't complete without it.

## Output
A unit of work confirmed complete against its original criteria, with docs, logs, and tickets/records all consistent with what shipped.

## Handoff
Feeds `kaizen`. If acceptance criteria weren't actually met, this is not closeout — loop back to `build`/`test`.

## Checklist
- [ ] Every acceptance criterion from `concept` is verified as met, not assumed
- [ ] Log entries match what actually shipped
- [ ] Docs referencing this work are updated, not left stale
- [ ] Merge/ticket mechanics are fully complete
- [ ] `kaizen` has been run before calling the unit closed
