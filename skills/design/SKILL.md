---
name: design
description: Use after concept is validated to produce the architecture, functional design, non-functional requirements, and diagrams needed before planning and implementation work begins.
---

# Design

## Purpose
Translate validated requirements into a concrete technical design: how the system will be structured, how it will behave, what quality attributes it must meet, and how the pieces fit together — documented well enough that planning can break it into units of work.

## When to use
- Requirements from `concept` exist and it's time to decide *how* to build it.
- An existing feature needs a design change (extend/modify architecture).
- Non-functional constraints (performance, scale, security posture) need to be made explicit before build starts.

## Process
1. **Functional design.** Describe the components/services involved and how data and control flow between them for each requirement from `concept`.
2. **Non-functional requirements (NFRs).** Make explicit: performance/latency targets, scale, availability, security/compliance constraints, observability needs. Absence of an NFR is a decision — state it.
3. **Architecture & infrastructure design.** Decide component boundaries, data ownership, integration points, and what infrastructure/environment the design assumes. Prefer the simplest architecture that meets the stated NFRs — do not design for scale or flexibility that wasn't asked for.
4. **Diagram it.** Produce at least one diagram (system/component, sequence, or data-flow) for any design non-trivial enough that a text description alone would be ambiguous. Use the simplest diagram form (ASCII, mermaid, or box-and-line) that conveys the structure — the point is shared understanding, not polish.
5. **Call out trade-offs.** For any non-obvious decision, record what was rejected and why.

## Output
A design doc: functional design per requirement, NFRs with explicit targets, architecture/infrastructure decisions, diagrams, and a trade-offs section.

## Handoff
Output feeds `plan`, which breaks the design into sequenced units of work. If the design reveals the requirements from `concept` were wrong or incomplete, go back to `concept` rather than silently patching around it.

## Checklist
- [ ] Every requirement from `concept` maps to a part of the design
- [ ] NFRs are stated as measurable targets, not adjectives ("fast", "scalable")
- [ ] At least one diagram exists for any non-trivial flow or architecture
- [ ] Rejected alternatives and why are recorded for non-obvious decisions
- [ ] Design is the simplest one that satisfies the stated requirements and NFRs
