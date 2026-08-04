---
name: adr
description: Use to record a significant, hard-to-reverse technical decision (reversibility, context, decision drivers, options, decision, consequences, compliance) as a standalone durable record separate from the design doc itself.
---

# Architecture Decision Record (ADR)

## Purpose
Preserve the reasoning behind a significant technical decision as a permanent, standalone record, so future maintainers understand *why* the code is shaped the way it is, not just what it does. Understanding the "why" makes it easier for the team to adopt a decision, and prevents someone who wasn't involved from overruling it later without knowing what they'd be reopening. Small, focused records survive; a large specification everyone stops reading does not.

## When to use
- A decision is a one-way door: hard or costly to reverse (choice of datastore, core library, protocol, published interface, major pattern).
- A decision resolved real disagreement between viable options.
- The decision affects structure (e.g. a service-decomposition pattern), a non-functional requirement (security, availability, fault tolerance), a dependency/coupling choice, a published interface, or a construction technique (framework, tool, process) that the team will be held to later.
- Something in `design` needs a durable record that will outlive the design doc itself as the system evolves.

Two-way doors, easily reversible choices with low blast radius, usually don't need an ADR; deciding and moving on is cheaper than documenting. Reserve the process for decisions where getting it wrong is expensive to walk back.

## Process
1. **Classify reversibility and blast radius.** State whether this is a one-way door (hard/costly to reverse) or a two-way door (cheap to reverse; if so, reconsider whether it needs an ADR at all), and how far the consequences reach: one component, the whole service, other teams' systems, or external customers. This is the test that decided this needs an ADR in the first place; record it, don't just use it implicitly.
2. **State the context in neutral language.** Describe the forces at play, technical, political, social, and project-local, without smuggling in the answer. Name the tension, not the resolution.
3. **State the decision drivers.** The criteria any acceptable option must satisfy (a specific NFR, a cost ceiling, a compliance requirement, a deadline). This is what makes the record checkable later: a reader can verify whether the chosen option actually meets the drivers, instead of taking the conclusion on faith.
4. **List the options considered**, with real trade-offs for each against the decision drivers, not a strawman comparison that makes the chosen option look obviously best.
5. **State the decision** plainly, in full sentences, active voice ("We will use X because...").
6. **State the consequences**, both directions: what gets easier (`Good, because...`) and what gets harder or is given up (`Bad, because...`). The honest cost belongs here, not just the benefit.
7. **State compliance rules.** Turn the decision into concrete, checkable rules a code reviewer can actually enforce (e.g. "all new services use X client library," "no direct writes to table Y from outside service Z"). Without this, the ADR is a historical curiosity instead of something `review` can hold code to.
8. **State confidence and the reevaluation trigger.** How confident is the team in this decision, and what specific event or evidence (not a calendar date) should trigger revisiting it? This replaces vague "review periodically" language with something someone can actually notice happening.
9. **Record the owner and who was consulted.** Every team member can own an ADR, but the record should say who owns it and who was consulted (the people and experts actually affected by the decision), even though the owner retains the call. This is what lets a reader tell a reviewed decision apart from a unilateral one.
10. **Mark status.** Proposed / Accepted / Rejected / Superseded. A rejected decision keeps its reason recorded, so the same debate doesn't restart from zero later.
11. **Keep it immutable once accepted.** An ADR is a historical record; if the decision changes, write a new ADR that supersedes it (mark the old one Superseded with a link forward) rather than rewriting history.

## Output
A numbered, dated ADR, stored in a fixed, central, project-wide location (a version-controlled `docs/adr/` directory or a team wiki, whichever the project already uses for durable records), numbered sequentially with numbers never reused: reversibility/blast radius, context, decision drivers, options considered, decision, consequences (good and bad), compliance rules, confidence/reevaluation trigger, owner and consulted parties, and status.

## Handoff
Referenced from `design` and `decision-log` where relevant, and traceable back to the requirement or NFR that made the decision necessary. Run a `review`-style critical pass, see review/SKILL.md's Critical Review section, before treating the ADR as Accepted: this is exactly the kind of expensive-to-unwind decision that pass is for. Once accepted, `review` (code review) should treat the ADR's compliance rules as something a change can violate, flagging it back to the ADR rather than adjudicating the tradeoff fresh each time. A superseding ADR should link back to the one it replaces.

## Checklist
- [ ] Reversibility (one-way vs. two-way door) and blast radius are stated explicitly
- [ ] Context is written in neutral language, forces at play, not a pre-loaded case for the answer
- [ ] Decision drivers are stated as checkable criteria, not vague adjectives
- [ ] Rejected options are listed with genuine trade-offs against the decision drivers, not a strawman
- [ ] Decision is written in full sentences, active voice
- [ ] Consequences include real costs, not just benefits
- [ ] Compliance rules are concrete enough for a code reviewer to check a change against them
- [ ] Confidence level and a specific reevaluation trigger are stated, not a vague "review later"
- [ ] Owner and consulted parties are recorded
- [ ] Status is set and kept current (including Rejected and supersession links)
- [ ] Record is treated as immutable once accepted; changes become a new ADR that supersedes it
