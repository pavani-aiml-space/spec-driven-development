---
name: adr
description: Use to record a significant, hard-to-reverse technical decision — context, alternatives, and consequences — as a standalone durable record separate from the design doc itself.
---

# Architecture Decision Record (ADR)

## Purpose
Preserve the reasoning behind a significant technical decision as a permanent, standalone record — so future maintainers understand *why* the code is shaped the way it is, not just what it does.

## When to use
- A decision is hard or costly to reverse (choice of datastore, core library, protocol, major pattern).
- A decision resolved real disagreement between viable options.
- Something in `design` needs a durable record that will outlive the design doc itself as the system evolves.

## Process
1. **State the context.** What problem or constraint forced this decision — what would have happened if no decision were made?
2. **List the options considered**, with real trade-offs for each, not a strawman comparison that makes the chosen option look obviously best.
3. **State the decision** plainly, in one or two sentences.
4. **State the consequences.** What this decision makes easier, what it makes harder, and what it forecloses — the honest cost, not just the benefit.
5. **Mark status and supersession.** Proposed / accepted / superseded — and if it later gets superseded, link to the ADR that replaces it rather than deleting or silently editing this one.
6. **Keep it immutable once accepted.** An ADR is a historical record; if the decision changes, write a new ADR that supersedes it rather than rewriting history.

## Output
A numbered, dated ADR: context, options considered, decision, consequences, status.

## Handoff
Referenced from `design` and `decision-log` where relevant. A superseding ADR should link back to the one it replaces.

## Checklist
- [ ] Context explains what forced a decision to be made at all
- [ ] Rejected options are listed with genuine trade-offs, not a strawman
- [ ] Consequences include real costs, not just benefits
- [ ] Status is set and kept current (including supersession links)
- [ ] Record is treated as immutable once accepted — changes become a new ADR
