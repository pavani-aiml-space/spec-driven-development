---
name: tpm-concept
description: >-
  Use in PMLC Concept (work backwards) to lock business goal, vision, measurable
  success criteria, in/out of scope, and customer/business framing before Align.
  Prefer this over tpm-program-brief for new programs. Does not own stakeholders,
  RACI, or Hub setup.
---

# Program Concept

## Purpose
**One job:** work backwards from the outcome and lock Concept — why this program exists, what success looks like, and what is in/out — before people maps or tooling.

Amazon flavor: start from the customer/business press-release view (PR/FAQ-lite), not from a Jira board.

## When to use
- PMLC **Concept / Work backwards** (`tpm-pdlc`) — first artifact on a new program
- Goals or success bar shifted and must be re-locked before re-Align
- Before `tpm-stakeholder-map`, `tpm-raci`, or `tpm-program-space`

## Process
1. **Customer / business problem.** Who hurts, what fails today, why now.
2. **Vision.** One plain paragraph of the world after launch.
3. **Success criteria.** Measurable outcomes (leading and lagging if useful). Not a feature list.
4. **In / out of scope.** Explicit outs prevent silent creep.
5. **FAQ / tradeoffs (lite).** Top anticipated objections: why not wait, why not descope X, what we will not optimize for yet.
6. **High-level timeline.** Target milestones only; detailed critical path comes in Delivery Plan.
7. **Sponsor.** Name the sponsor. Full stakeholder map is Align (`tpm-stakeholder-map`).
8. **Keep it readable.** Prefer a short narrative + bullets over a slide deck. Link out for deep research.

## Output
A Concept doc (Markdown/Confluence): problem, vision, success criteria, in/out, FAQ-lite, timeline summary, sponsor.

Optional: publish the same content (or a shortened form) as the Hub “Program Brief” page via `tpm-program-brief` if you want a one-page distill for readers who will not open the full Concept.

## Handoff
**PMLC phase:** Concept / Work backwards (`tpm-pdlc`).
Feeds Align (`tpm-stakeholder-map` → `tpm-raci`), then Mechanism setup. Success criteria hand to Spec-Driven Development via `tpm-sdd-bridge` when eng build starts. Does not own RACI, Hub, Jira, or status.

## Checklist
- [ ] Problem and vision are clear without other docs
- [ ] Success criteria are measurable
- [ ] Out-of-scope is explicit
- [ ] FAQ-lite covers the hard “why this / why now” questions
- [ ] Sponsor named; stakeholder map deferred to Align
- [ ] No RACI, Hub scaffold, or Jira setup in this artifact
