---
name: tpm-risk-register
description: Use to identify and track program risks, including a computed risk score, so they're actively managed instead of discovered only after they materialize; also use whenever a new risk surfaces or a paused program restarts and the register needs re-validating.
---

# Risk Register

## Purpose
Turn "things that could go wrong" from background anxiety into a tracked, owned, scored list, so risks get mitigated proactively instead of becoming surprises. Discovery is systematic (dependencies, lenses, single points of failure), not just whatever comes to mind in a kickoff meeting.

## When to use
- At program kickoff, alongside the `tpm-program-brief`, to capture known risks from the start.
- Whenever a new risk is identified during the program.
- Periodically, to review whether existing risks have changed in likelihood/impact or should be closed.
- When a paused program restarts or relaunches - a stale register is worse than none, since it creates false confidence that risks were already accounted for.

## Process
1. **Read the `tpm-program-brief`** for goals and scope - risk discovery is scoped to what the program actually touches, not a blanket brainstorm.
2. **Scaffold the starter register.** Run `scripts/generate-template.sh --title "<program name>" --output-dir <path>` to generate example risks across each category below as a starting point, not a blank page.
3. **Map dependencies and integration points, then ask "what if" for each.** What systems, teams, data feeds, or third parties does this program rely on, and what happens if any one of them doesn't deliver on time or at all? This single technique surfaces risks nobody volunteers proactively.
4. **Scan systematically across lenses**, not just "what comes to mind": People (key-person dependency, turnover, skill gaps), Technology (unproven/new tech, scaling limits, technical debt), Compliance (regulatory, legal, audit exposure), Resource (budget, competing priorities, staffing). Tag each risk by what it threatens - Scope, Schedule, or Quality - so the mitigation matches the actual failure mode.
5. **Flag single points of failure explicitly.** Any person, system, or vendor whose failure alone would stop the program deserves elevated priority regardless of its assessed likelihood - a rare-but-catastrophic single point of failure is exactly what gets under-weighted by likelihood alone.
6. **Name the risk concretely.** Not "timeline risk" - state the specific thing that could happen and its trigger condition.
7. **Assess likelihood and impact, and compute a risk score.** Rate both on a consistent 1-5 scale and multiply them into a score (1-25) - this is what actually lets risks get ranked instead of eyeballed.
8. **Define mitigation.** What's being done now to reduce likelihood or impact - a risk with no mitigation is just a complaint.
9. **Define a trigger and contingency.** What signal indicates the risk is materializing, and what's the fallback plan if it does?
10. **Assign an owner.** Someone specific watches this risk and acts on the mitigation - not "the team."
11. **Review and retire on a cadence, and always at relaunch.** Revisit the register regularly; close risks that no longer apply rather than letting the list grow stale, and re-validate every risk, not just new ones, when a paused program restarts.

## Output
A risk register, in Markdown and CSV/Excel: risk description, category, what it threatens (scope/schedule/quality), likelihood, impact, computed risk score, mitigation, trigger/contingency, owner, status. `scripts/generate-template.sh` scaffolds the starting file in both formats with example risks per category.

## Handoff
**PMLC phase:** Delivery **Prepare** (`tpm-pdlc`); seeded empty in Mechanism setup; critical at Close for go/no-go.
**One job:** track risks with owner + mitigation — not status narrative, not contested decisions.
Consumes scope from `tpm-concept` (or brief distill) and dependency/stakeholder context from `tpm-stakeholder-map` when one exists. Feeds `status-report` for ongoing visibility, and can feed `tpm-raci`/`tpm-contested-decisions` when a mitigation itself needs an owner or a decision that isn't already assigned. If this program has a Confluence space (see `tpm-program-space`), update the existing Risk Register page there directly whenever a new risk surfaces, rather than only keeping this local.

## Checklist
- [ ] Dependencies and integration points mapped, with "what if" asked for each
- [ ] Risks scanned across all four lenses (People, Technology, Compliance, Resource), not just the obvious ones
- [ ] Single points of failure flagged explicitly, regardless of their computed score
- [ ] Each risk is stated as a specific, concrete scenario
- [ ] Likelihood and impact are both rated and multiplied into a risk score
- [ ] Every risk has an active mitigation, not just a description
- [ ] Trigger condition and contingency plan are defined
- [ ] Every risk has a named owner
- [ ] Register is reviewed on a cadence, and fully re-validated at relaunch, not just left stale
