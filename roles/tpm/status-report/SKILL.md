---
name: status-report
description: Use on a recurring cadence during a program to give stakeholders a concise, honest update on progress, health, milestones, and blockers. Lane/eng status rolls up into tpm-biweekly-stakeholder-update when items are at risk and have a mitigation.
---

# Status Report

## Purpose
Keep the working team and TPM accurately informed without requiring them to dig - and surface problems early enough that they're still cheap to fix. This is the **bottom of the status rollup** (eng / lane → program → sponsor).

## When to use
- On a lane or program's regular working-level cadence (weekly/biweekly).
- When status has materially changed (a risk became real, a milestone slipped) and the TPM shouldn't wait for the next scheduled update.
- **Bi-weekly sponsor / senior-leadership updates:** use `tpm-biweekly-stakeholder-update` instead. That skill consumes only rolled-up at-risk / off-track items from these reports (with mitigations).

## Process
1. **Lead with overall health**, not activity. A single clear signal (on track / at risk / off track) before the details.
2. **Report against the plan**, not just "what we did." Compare actual progress to milestones from `tpm-program-brief` / Hub.
3. **Call out blockers explicitly**, with what's needed to unblock and from whom.
4. **Be honest about risk.** Every **at risk** or **off track** item must include:
   - Owner
   - By-when
   - **Mitigation** (what is already being done to reduce likelihood or impact)
   - Whether it should **surface to the bi-weekly** (hits date, scope, trust, or needs a sponsor/Legal/Security decision)
5. **Keep it scannable.** Bullet points over prose. Assume the reader has thirty seconds.

## Output
A short recurring update: overall health, progress vs plan, blockers with asks, at-risk items with mitigations (and surface-up flag), next milestone.

### Suggested at-risk shape
| Item | Owner | By | Mitigation | Surface to bi-weekly? |
| --- | --- | --- | --- | --- |

## Handoff
- **PMLC phase:** Delivery **Execute → Measure** (`tpm-pdlc`); lane input to the rollup.
- **One job:** lane health with mitigations and surface-up flags — not the sponsor bi-weekly.
- Compares progress against `tpm-program-brief` milestones and pulls risk context from `tpm-risk-register`.
- Feeds `tpm-biweekly-stakeholder-update`: only at-risk / off-track rows with mitigations (or an explicit blocked-mitigation ask) roll into **Items to Watch** or **Decision to review**.
- Green / on-track detail stays at this level unless needed as a short Done / Demo proof on the bi-weekly.

## Checklist
- [ ] Overall health signal is stated clearly, not buried in narrative
- [ ] Progress is measured against the plan, not just listed as activity
- [ ] Every blocker has a concrete ask and an owner to unblock it
- [ ] Every at-risk / off-track item has a mitigation and owner / by-when
- [ ] Items that can hit date, scope, or trust are flagged to surface to the bi-weekly
- [ ] No at-risk row without mitigation (block publish until filled)
- [ ] Report is scannable in under a minute
