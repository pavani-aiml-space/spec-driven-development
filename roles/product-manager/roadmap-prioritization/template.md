This is a worked example, 10 candidates, following the corrected step order in SKILL.md (translate asks and spike uncertain items before scoring, not after). Copy it and replace the specifics with your own.

# Roadmap: Growth & Platform

**Cycle:** Q3 2026 (quarterly cadence)
**Date:** 2026-08-03
**Status:** Active
**Owner:** Product Manager, Growth & Platform

## Prep

### 1. Candidates collected
| Initiative | Source |
|---|---|
| Self-serve onboarding | Discovery findings, `concept` |
| Usage-based billing | Sales/stakeholder request |
| Admin audit log | Client request (security review requirement) |
| Bulk CSV import | Support ticket volume |
| Dark mode | Team vote |
| Legacy API v1 sunset | Tech debt, engineering |
| Enterprise SSO | Client request |
| In-app notifications | Discovery findings |
| Mobile performance improvements | Support tickets, app store reviews |
| Public API rate limit increase | Client request |

### 2. Strategic gates
| Initiative | Gate result | Reason |
|---|---|---|
| Self-serve onboarding | Pass | Activation goal |
| Usage-based billing | Pass | Revenue goal |
| Admin audit log | Pass | Compliance disqualifier if not done this cycle |
| Bulk CSV import | Pass with caveats | Overlaps with import work in progress |
| Dark mode | Wait | No stated business goal |
| Legacy API v1 sunset | Pass | Required before Q4 infra work |
| Enterprise SSO | Pass | Same clients driving the audit log ask |
| In-app notifications | Pass | Engagement goal |
| Mobile performance improvements | Pass with caveats | Fits, but scope not yet bounded |
| Public API rate limit increase | Do not pursue | No client currently blocked by the current limit |

### 3. Stakeholder asks translated, before scoring
| Ask | Opportunity Score (importance + gap to satisfaction) | Resolution |
|---|---|---|
| "Add SSO for our team" | 9 + (9−4) = 14 | Genuinely underserved; scored as its own initiative, not folded into the audit log |
| "Raise our API rate limit" | 3 + (3−7) = −1 | Not underserved (satisfaction already high); this is why it was gated out above |
| "Add dark mode" | 3 + (3−6) = 0 | Not underserved; parked |

### 4. Spiked before scoring
- Usage-based billing: two-week spike on the metering approach (see `technical-spike`). Confidence moved from 40% to 60%; the score below uses 60%.
- Mobile performance improvements: one-week spike to bound scope (which platforms, which regressions). Effort estimate below reflects the spike's finding (iOS only, this cycle).

### 5. Scoring
RICE for reach-driven work; WSJF where a deadline or risk, not reach, is the deciding factor:

| Initiative | Reach | Impact | Confidence | Effort | RICE |
|---|---|---|---|---|---|
| Self-serve onboarding | 8,000/mo | 3 | 80% | 6 person-months | 3,200 |
| Bulk CSV import | 1,200/mo | 1 | 70% | 1 person-month | 840 |
| In-app notifications | 6,000/mo | 2 | 65% | 3 person-months | 2,600 |
| Mobile performance improvements | 4,000/mo | 2 | 75% | 2 person-months | 3,000 |
| Usage-based billing | 500/mo | 3 | 60% | 8 person-months | 113 |
| Legacy API v1 sunset | n/a | 2 | 95% | 3 person-months | gate dependency, not ranked against reach-based work |

| Initiative | Business Value | Time Criticality | Risk Reduction | Job Size | WSJF |
|---|---|---|---|---|---|
| Admin audit log | 5 | 13 (hard deadline, 8 weeks) | 8 (2 clients at risk of contract breach) | 2 | 13 |
| Enterprise SSO | 5 | 8 (same 2 clients, softer deadline) | 5 | 3 | 6 |

### 6. Trade-off matrix
| Initiative | Objective | Cost | Cost of not doing | Competes with |
|---|---|---|---|---|
| Self-serve onboarding | Activation goal | 6 person-months, Growth | Activation flat; growth targets missed | Bulk CSV import, in-app notifications (same team) |
| Admin audit log | Compliance / retain 2 clients | 2 person-months, Platform | Contract breach risk within 8 weeks | Usage-based billing, Enterprise SSO (same team) |
| Enterprise SSO | Retain same 2 clients | 3 person-months, Platform | Same clients churn on a softer timeline | Admin audit log, usage-based billing |
| Usage-based billing | Revenue goal | 8 person-months, Platform | Revenue goal slips a quarter | Admin audit log, Enterprise SSO |
| In-app notifications | Engagement goal | 3 person-months, Growth | Engagement stays flat | Self-serve onboarding, bulk CSV import |
| Mobile performance improvements | Retention, app store rating | 2 person-months, Growth | Rating and retention keep declining | Self-serve onboarding, in-app notifications |
| Bulk CSV import | Support cost reduction | 1 person-month, Growth | Ticket volume keeps climbing, low severity | Self-serve onboarding, in-app notifications |
| Legacy API v1 sunset | Unblocks Q4 infra | 3 person-months, Platform | Q4 infra work can't start | None (sequencing gate) |
| Dark mode | None stated | small | None material | N/A |

### 7. Portfolio shape check
- Low-risk, near-term: self-serve onboarding, admin audit log, mobile performance, bulk CSV import (~55%)
- Riskier, longer-term: usage-based billing, Enterprise SSO (~30%)
- Required/smaller: legacy API v1 sunset (~15%)

A bit heavier on bets than the 70/20/10 default; worth naming in the session, not necessarily rebalancing, given two of the "bets" (audit log, SSO) are compliance-adjacent, not discretionary.

## Run the session
- **Attendees:** Growth PM (owner), Platform PM, Growth Eng lead, Platform Eng lead. Each can commit their team's capacity or veto.
- **Time box:** 50 minutes for 9 scored candidates (dark mode already gated to Wait, rate limit increase already gated out), roughly 5 minutes each plus 15 minutes for cuts and sequencing.
- **Ground rule:** nothing without a trade-off matrix row gets debated; it's Later by default.

### Sequencing
- Legacy API v1 sunset before usage-based billing (billing depends on v2 metering hooks).
- Admin audit log and Enterprise SSO can run in parallel; both touch the same 2 clients but not the same code.

### Decided in-session
| Initiative | Bucket | Owner | Success metric |
|---|---|---|---|
| Admin audit log | Now | Platform PM | Compliance sign-off; 0 open findings |
| Legacy API v1 sunset | Now | Platform Eng lead | 100% traffic migrated off v1 |
| Self-serve onboarding | Now | Growth PM | Activation rate 22% → 35% (see `success-metrics`) |
| Enterprise SSO | Now | Platform PM | Both at-risk clients confirm renewal |
| Mobile performance improvements | Next | unassigned | Spike complete; full fix not yet started |
| In-app notifications | Next | unassigned | Validated, not yet started |
| Bulk CSV import | Next | unassigned | Validated, not yet started |
| Usage-based billing | Next | unassigned | Spike complete; full build not yet started |
| Dark mode | Later | none | No business goal yet; revisit if one emerges |

### Cuts and overrides, decided live
- Usage-based billing (RICE-scored) had the resources to be Now, but Admin audit log and Enterprise SSO (WSJF-scored, same team) outrank it on cost-of-not-doing; billing moves to Next as a direct capacity conflict, not a quality judgment.
- Mobile performance improvements and in-app notifications both had room to be Now on score alone, but Self-serve onboarding's activation goal was named this cycle's top strategic priority; the other two move to Next, stated on the spot, not decided afterward.
- Public API rate limit increase was gated out (step 2), not scored, because the Opportunity Score in step 3 showed no genuinely underserved need behind the ask.

## Post-session
- **Communicated:** 2026-08-04 (within 24 hours). Growth and Platform teams briefed directly. The client who asked for a higher rate limit was told directly why it wasn't picked up, with the Opportunity Score reasoning. The stakeholder who requested dark mode got the same treatment.
- **Cadence:** quarterly; full process, prep through post-session, every cycle boundary.
- **Re-prioritization trigger:** the audit log's compliance deadline moves up, either at-risk client signals earlier churn intent, or the billing provider's metering API changes before the spike's assumptions are re-validated.

## Version history
- v1 (2026-08-03): initial Q3 roadmap, this document.
