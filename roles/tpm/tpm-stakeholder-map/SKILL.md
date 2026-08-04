---
name: tpm-stakeholder-map
description: Use when kicking off a new program, or re-mapping an existing one after scope changed, to systematically identify every stakeholder that needs to be involved and prioritize engagement by power and interest, before RACI or Contested Decisions assigns accountability against that same roster.
---

# Stakeholder Map

## Purpose
Identify everyone who does the work, is affected by it, influences it, or is needed to support it, and prioritize how to engage each of them, so no key stakeholder gets discovered mid-program instead of before it starts.

This skill identifies and prioritizes stakeholders; assigning accountability against that roster is `tpm-raci`'s or `tpm-contested-decisions`'s job, not this one.

## When to use
- A new program is kicking off and a `tpm-concept` exists (or optional `tpm-program-brief` distill).
- An existing program needs re-mapping after scope, systems, or teams changed - stakeholders drift as programs evolve, and a stale map is worse than none because it creates false confidence.
- Note: `tpm-concept` names the sponsor only. Reach for this skill for systematic discovery and prioritization.

## Process
1. **Read `tpm-concept`** (or the brief distill) for the problem, goals, and in/out-of-scope boundaries - stakeholder discovery is scoped by what the program actually touches, not a blanket list of "everyone who might care."
2. **Scaffold the starter map.** Run `scripts/generate-template.sh --title "<program name>" --output-dir <path>` to generate a starting CSV and Markdown map with the standard categories below pre-filled, rather than building the roster from a blank page.
3. **Identify stakeholders by category**, not just by asking "who's involved":
   - Customers/end-users, internal and external, and the journeys they go through.
   - Dependent or affected teams whose workflows change.
   - Systems and technical dependencies, and whoever owns them.
   - Sponsors and decision-makers.
   - Influencers - people without formal authority who still shape adoption or opinion.
   - Support/operational owners who inherit this post-launch.
4. **Capture each stakeholder's objectives directly, not by inference.** A short 1:1 (or reusing an existing conversation) to learn their vision for the program, their pain points, and their specific concerns beats guessing what they probably want. Different functions optimize for different things by default (engineering for technical feasibility, product for user needs and timelines, legal for risk exposure) - write down what this specific stakeholder actually said, not the generic assumption for their function.
5. **Plot each stakeholder on a power/interest grid** (Mendelow's Matrix): power = ability to affect the program's outcome; interest = how much the outcome affects them. This produces four groups, not a flat list:
   - Manage Closely (high power, high interest)
   - Keep Satisfied (high power, low interest)
   - Keep Informed (low power, high interest)
   - Monitor (low power, low interest)
6. **Set the engagement approach per priority group**, not per person individually, and frame it using their stated objective from step 4. Manage Closely gets direct involvement in decisions; Keep Satisfied gets periodic updates framed around their specific concern; Keep Informed gets regular broadcast updates; Monitor gets checked occasionally but not actively managed.
7. **Flag the risky mismatches.** A high-power, high-interest stakeholder who isn't yet engaged, or an affected team that was never consulted, is exactly the gap that causes late-stage surprises - call these out explicitly rather than letting the map imply everything's covered. See `examples/prescription-alternatives-example.md` for a worked map, including a stakeholder whose engagement tier is easy to under-invest in.
8. **Revisit as the program evolves.** Stakeholders move between priority groups as scope or circumstances change (a regulator moves from low to high interest the moment a compliance issue surfaces) - treat the map as living, not a one-time artifact.

## Output
A stakeholder map, in Markdown and CSV/Excel: each stakeholder, their category, stated objective, power/interest priority group, and engagement approach. `scripts/generate-template.sh` scaffolds the starting file in both formats.

## Handoff
**PMLC phase:** Align (`tpm-pdlc`) — step 1 of 2 (then `tpm-raci`).
**One job:** who matters and engagement priority — not RACI, not Hub setup.
Consumes the problem/scope and sponsor from `tpm-concept` (or brief distill). Feeds `tpm-raci` and `tpm-contested-decisions` - the roster this produces is exactly who gets assigned R/A/C/I or Driver/Approver/Contributor/Informed roles downstream; this skill identifies and prioritizes, it doesn't assign accountability.

## Checklist
- [ ] Stakeholders identified by systematic category, not just "who comes to mind"
- [ ] Every stakeholder plotted by power AND interest, not just listed flat
- [ ] Each stakeholder's objective is what they actually said, not the generic assumption for their function
- [ ] Engagement approach set per priority group and references the stakeholder's stated objective
- [ ] High-power/high-interest stakeholders who aren't yet engaged are flagged explicitly
- [ ] Map is treated as revisited/living, not finalized once and left static
