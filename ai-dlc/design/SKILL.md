---
name: design
description: Use after concept is validated to produce the architecture, functional design, non-functional requirements, and diagrams needed before planning and implementation work begins.
---

# Design

## Purpose
Translate validated requirements into a concrete technical design: how the system will be structured, how it will behave, what quality attributes it must meet, and how the pieces fit together, documented well enough that planning can break it into units of work. Design isn't picking the obvious option; it's making the reasoning visible enough that someone else could evaluate whether the right call was made. Every non-trivial decision must be able to answer: "what else did we consider, and why not that?" If you can't name a real alternative, you haven't decided anything: you defaulted.

## When to use
- Requirements from `concept` exist and it's time to decide *how* to build it.
- An existing feature needs a design change (extend/modify architecture).
- Non-functional constraints (performance, scale, security posture) need to be made explicit before build starts.

## Process
1. **Functional design.** Describe the components/services involved and how data and control flow between them for each requirement from `concept`.
2. **Non-functional requirements (NFRs).** Make explicit: performance/latency targets, scale, availability, security/compliance constraints, observability needs. Absence of an NFR is a decision, state it.
3. **Architecture & infrastructure design.** Decide component boundaries, data ownership, integration points, and what infrastructure/environment the design assumes. Prefer the simplest architecture that meets the stated NFRs; do not design for scale or flexibility that wasn't asked for.
4. **Document design tradeoffs for every open area.** For each design decision that isn't obvious or forced:
   - List 2–3 *real* options, not one genuine option plus strawmen built to lose.
   - State pros and cons of each, grounded in the requirements from `concept`, not personal preference or "what's common." A decision justified only by "it's common," "it's simple," or "it's clean," with no requirement or concrete scenario backing it, isn't a real reason.
   - Put real options in front of the human and get an answer before finalizing, a recommendation is fine, a silent decision isn't.
   - Record the selected option with rationale tied back to specific requirement IDs.
   - Record anything still genuinely open after asking, rather than letting it quietly disappear.
5. **Define the reusable-vs-specific boundary.** State explicitly what's generic/reusable versus scenario- or application-specific, as an explicit boundary, not just an implied structure. Leaving this implicit leaves the next stage guessing what's safe to change per-application.
6. **Diagram it.** Produce at least one diagram (system/component, sequence, or data-flow) for any design non-trivial enough that a text description alone would be ambiguous. Use the simplest diagram form (ASCII, mermaid, or box-and-line) that conveys the structure. The point is shared understanding, not polish.
7. **Confirm nothing gets built here.** Design produces decisions and rationale, not code, folders, or tasks. Building something during design "just to check it works" blurs the approval gate; implementation waits for design sign-off.

### Common mistakes

| Mistake | Why it fails |
|---|---|
| One real option, two strawmen | Not a real comparison; the outcome was decided before the analysis was written |
| "It's common" / "it's simple" / "it's clean" as the stated reason | Not a reason tied to a requirement, a default wearing a justification |
| Skipping the reusable-vs-specific boundary | Leaves the next stage guessing what's safe to change per-application |
| A deferred decision that just vanishes instead of being recorded | Someone downstream re-litigates it from scratch, or assumes it was already decided |

## Output
A design doc: functional design per requirement, NFRs with explicit targets, architecture/infrastructure decisions, options considered per design area with the selected approach and rationale tied to requirement IDs, the reusable-versus-application-specific boundary, diagrams, and any deferred decisions.

## Handoff
Output feeds `plan`, which breaks the design into sequenced units of work. Run a `review`-style critical pass (see review/SKILL.md's Critical Review section) before treating the design as approved; this is the highest-value stage for that pass, since decisions here are expensive to unwind once implementation starts. If the design reveals the requirements from `concept` were wrong or incomplete, go back to `concept` rather than silently patching around it.

## Checklist
- [ ] Every requirement from `concept` maps to a part of the design
- [ ] NFRs are stated as measurable targets, not adjectives ("fast", "scalable")
- [ ] Every non-trivial decision names 2–3 real alternatives, not strawmen, with rationale tied to requirement IDs
- [ ] The reusable-versus-application-specific boundary is stated explicitly
- [ ] At least one diagram exists for any non-trivial flow or architecture
- [ ] Rejected alternatives and why are recorded for non-obvious decisions
- [ ] Design is the simplest one that satisfies the stated requirements and NFRs
- [ ] Nothing was built during design; it produced decisions and rationale only
