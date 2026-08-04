---
name: roadmap-prioritization
description: Use to turn competing candidate initiatives across the product areas you own, plus stakeholder input and discovery findings, into a prioritized roadmap that partner teams can execute against, prepped and decided as an actual session, not just a scored spreadsheet.
---

# Roadmap Prioritization

## Purpose
Turn every candidate initiative into one ranked, sequenced plan a partner team can start against without a follow-up meeting, and without date promises the team can't keep. Same method regardless of planning horizon, quarterly, six weeks, monthly; the cadence is your org's, not this skill's. Prioritization is a decision session with people who have competing incentives and limited capacity, not a spreadsheet exercise, so the analysis has to be done before the room convenes.

## When to use
- Multiple initiatives compete for the same limited capacity.
- Stakeholder requests, discovery findings, and leadership priorities need reconciling into one order.
- New information (a finding, an ask, a capacity change) invalidates the current order.

## Process
If tracked in Aha!, run `scripts/fetch-aha-roadmap.sh` once at the start of prep (`AHA_SUBDOMAIN`/`AHA_PRODUCT_ID` from `config.env`, `AHA_API_KEY` in your shell profile). Read-only; pulls initiatives, features, requirements/dependencies, and open ideas in one call.

### Prep
1. **Collect every candidate**, from every source: stakeholder requests, `concept` findings, compliance requirements, tech debt. If tracked in Aha!, this is the fetched `features` plus `ideas` not yet promoted; don't hand-collect what the tool already has.
2. **Gate every candidate from step 1's list before scoring any of them.** For each one: does it fit the product areas you own, a stated business goal, any hard disqualifier? Mark it Pass / Pass with caveats / Wait / Do not pursue. Only what passes moves on to step 3; don't spend scoring effort on candidates that were never in play.
3. **For every stakeholder ask that passed step 2, translate it into the need behind it, before scoring it.** "Add feature Y" often encodes an unmet need, not a literal spec. Opportunity Score (importance + the gap between importance and current satisfaction) checks whether it's genuinely underserved or just loud; a cheaper fix to the real need is a legitimate resolution, not a rejection. If tracked in Aha!, work from the fetched `ideas`, sorted by votes.
4. **For every candidate resting on a shaky assumption, spike it before scoring it.** A short, time-boxed spike (see `technical-spike`) on anything that would otherwise score well on a guess. Score the post-spike confidence, not the guess.
5. **Score what passes, one tool per candidate, applied consistently:**

   | Tool | Use for |
   |---|---|
   | RICE (Reach × Impact × Confidence / Effort) | Default: reach-driven features |
   | WSJF (Business Value + Time Criticality + Risk Reduction / Job Size) | Cost of *not* doing it matters: a deadline, decaying opportunity, compliance exposure |
   | Weighted scoring (your own criteria) | Strategy-specific criteria RICE/WSJF don't capture |
   | MoSCoW | Fast, low-stakes release scoping |

   Low confidence should visibly lower the score, not get footnoted. If Aha!'s scorecard is already configured, use it instead of re-deriving a score.
6. **Turn the scores into a trade-off matrix**, one row per candidate: objective, cost (effort), cost of not doing (the WSJF terms, or plainly stated: "client churn risk"), and what it competes with for the same team/slot. This, not the score alone, is what the session works from, a rank tells you who won, the matrix tells you why and what was given up.
7. **Sanity-check the portfolio shape.** Rough default: 70% low-risk/near-term, 20% riskier bets, 10% smaller/delight. All-safe has no differentiation; all-bets has no reliable delivery. Worth a second look if it's badly off, not a reason to force the split.

### Run the session
8. **Name attendees and a time box before it starts.** Small group, empowered to commit capacity or veto, not a stakeholder audience. Minutes per candidate against the matrix, not open-ended; unresolved items carry to a named follow-up, not overtime.
9. **Decide from the matrix.** The room weighs conflicts and calls it; estimating happened in prep. Anything without a matrix row defaults to Later, reviving it takes someone arguing for it, not running out of time to object.
10. **Sequence by real dependency**, not score alone; a high scorer blocked on a low scorer still waits. If tracked in Aha!, use the fetched `dependencies`/`requirements` directly.
11. **Present by confidence, not date.** Now: committed. Next: validated, not started. Later: a bet still being shaped. A date on a Later item is a promise nobody can keep. A timeline for the Now slice only, once committed.
12. **Decide cuts and overrides on the spot, with a reason.** A lower scorer beating a higher one for strategic reasons gets that reason stated in the matrix, live, the same evidence-backed rigor `review`'s Critical Review asks elsewhere. A cut decided quietly afterward reads as a decision made without the people it affects, because it was.
13. **Assign an owner and a success metric to every Now item before the room breaks.** No owner or metric means it's still an idea with a good score, not something ready to hand off (see `success-metrics`).

### Post-session
14. **Brief non-attendees within 24 to 48 hours**, before the outcome leaks informally, especially anyone whose ask was cut. Tailor per audience, the way `success-metrics` tailors outcome reporting.
15. **Confirm cadence, and a separate re-prioritization trigger.** State the org's actual cycle (quarterly, six weeks, monthly); re-run this full process at every boundary. Separately, name what forces an out-of-cycle re-rank: a new deadline, a capacity change, an assumption the order was built on turning out false.
16. **Publish somewhere durable and versioned.** What changed since the last version, and why, same immutable-with-supersession discipline as `adr`. If tracked in Aha!, write scores/release assignments back via `scripts/sync-aha-roadmap.sh`: dry run first (the default), confirm the list with the user, then `--apply`. This edits shared data, same reason `publish-wiki.sh` in `release-notes` requires confirmation.

## Output
A prioritized roadmap: every candidate gated, scored, and laid out in a trade-off matrix; portfolio shape checked; sequenced by dependency; presented Now/Next/Later; cuts and overrides decided visibly in-session; owner and metric on every Now item; cadence and re-prioritization trigger stated. See [template.md](template.md) for a full worked example.

## Handoff
Each Now item feeds `concept`. An uncertain candidate feeds `technical-spike` before commit (in prep, not after). Feeds `success-metrics` for metrics before the initiative starts. A call the scoring criteria can't resolve is a `decision-log` entry or escalation, not a quiet PM pick. If tracked in Aha!, the tool itself is the durable record; a separate summary should link to it, not duplicate it.

## Checklist
- [ ] Every candidate captured in one place, gated before scoring
- [ ] Stakeholder asks translated into the underlying need, and uncertain candidates spiked, before scoring, not after
- [ ] One scoring tool per candidate, chosen deliberately, applied consistently; cost-of-delay used where the cost of *not* doing something is the deciding factor
- [ ] A trade-off matrix (objective, cost, cost of not doing, conflicts) exists and is what the session worked from
- [ ] Portfolio shape checked, not just rank order
- [ ] Session had a named, empowered attendee list and a hard time box, set in advance
- [ ] Anything without a matrix row defaulted to Later, not a live debate
- [ ] Sequencing reflects real dependencies
- [ ] Roadmap presented by confidence (Now/Next/Later), not fixed dates beyond Now
- [ ] Cuts and overrides decided visibly in-session, with a reason, not afterward
- [ ] Every Now item has an owner and a success metric before handoff
- [ ] Non-attendees, especially anyone cut, briefed within the stated window
- [ ] Cadence stated explicitly; re-prioritization trigger defined separately
- [ ] Roadmap versioned, with what changed and why
- [ ] If tracked in Aha!, changes confirmed in dry-run form before `--apply`
