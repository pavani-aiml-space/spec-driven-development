This is a worked example, following SKILL.md's Prepare / Review / Post structure. Copy it and replace the specifics with your own.

# Build vs Buy: Lead Enrichment

**Date:** 2026-08-03
**Status:** Logged (see Post)
**Owner:** Product Manager, Growth
**Decision needed by:** 2026-08-25 (Q3 planning cutoff)

## Prepare

### 1. Capability, framed
We need to enrich inbound leads with firmographic data (company size, industry, revenue band) before routing them to sales. Not "should we buy Vendor X" or "should we build a scraper", the need is enrichment, the approach is still open.

### 2. Rapid filter
| Driver | Lean | Why |
|---|---|---|
| Strategic importance | Buy | Enrichment data itself isn't our differentiator; how we route and act on it might be |
| Time to market | Buy | Sales wants this in weeks, not a quarter |
| TCO predictability | Unclear | Vendor subscription cost is known, but the scraper alternative's real maintenance cost hasn't actually been estimated, evaluate it, don't guess |
| Team capacity | Buy | No one on the team has data-vendor-relationship or scraping-infra expertise |

Three of four lean buy cleanly. TCO predictability is genuinely unclear, evaluated below rather than assumed.

### 3. Driver evaluation: TCO predictability
- **Ask:** What's the full 3-year cost of the scraper option, including maintenance, not just the initial build? What's the true opportunity cost of the engineer who'd build and maintain it?
- **Risk if wrong:** The scraper looks cheap on paper (no subscription fee) while its real maintenance cost, and what that engineer isn't doing instead, goes uncounted until it's already built.
- **De-risked with:** A financial model of the scraper's 3-year cost (below), and a conversation with another team that tried something similar, which is where the "source sites change without warning" maintenance risk actually surfaced.

Result: TCO predictability also leans buy once evaluated, not assumed. All four drivers now agree; the moat pressure-test below is a confirmation pass, not a coin flip.

### 4. Moat pressure-test (on the "build a scraper" option)
- Genuinely better than existing alternatives? No, vendors already do this well.
- Depends on proprietary data only we have? No, the source data is public/firmographic.
- The reason customers choose us? No, they choose us for what we do with the data, not how we got it.
- Unacceptable vendor roadmap risk? No, several vendors serve this market; not a single point of failure.
- Could become a platform? No.

Fails on all five. Build is ruled out here, not on a TCO technicality.

### 5. Extend considered
Considered extending our existing CRM's native enrichment add-on instead of a separate best-of-breed vendor. Ruled out: the CRM's enrichment coverage is materially worse for our target company size band (confirmed via a trial); a dedicated vendor is a cleaner buy, not an extend.

### 6. TCO (3-year, per option) and traps checked
| | Build (scraper) | Buy: Vendor A | Buy: Vendor B |
|---|---|---|---|
| License/subscription | $0 | $54,000 | $72,000 |
| Build/implementation | 4 engineer-months (~$120,000 loaded) | 1 sprint integration (~$15,000) | 1 sprint integration (~$15,000) |
| Maintenance (3yr) | ~$180,000 (source sites change; ~0.5 FTE ongoing) | included in subscription | included in subscription |
| Opportunity cost | ~4 engineer-months not spent on core routing logic, the actual differentiator | negligible | negligible |
| 3-year TCO | ~$300,000+ engineer time, plus what those months of core-work delay cost | ~$99,000 | ~$117,000 |

Traps checked: opportunity cost priced as lost core-work time, not just salary, this is what actually rules out build, not the sticker price. Build's "control" doesn't help here, no data-quality ops process exists to act on it faster than a vendor's pipeline would. Lock-in evaluated both ways: Vendor A's export format is standard (low lock-in); the scraper would lock us into maintaining scraper logic against sites that change without notice, arguably worse lock-in than a vendor contract.

### 7. Requirements scored
| Requirement | Weight | Vendor A | Vendor B |
|---|---|---|---|
| Coverage for our target company size band | Must | Meets | Meets |
| SOC 2 Type II | Must | Meets | Does not meet |
| API rate limit sufficient for our volume | Must | Meets | Meets |
| Firmographic + technographic data | Nice-to-have | Meets | Meets |
| Native CRM integration | Nice-to-have | Partial | Meets |

Vendor B fails a must-have (SOC 2 Type II); eliminated regardless of price or nice-to-haves.

### 8. Draft recommendation, going into review
**Buy: Vendor A.** Trade-off: pay ~$99,000 over 3 years and accept normal SaaS lock-in, in exchange for shipping in weeks instead of months and freeing 4 engineer-months for core routing-logic work.

## Review with stakeholders

### 9. Input gathered, by role
| Role | Question asked | Answer |
|---|---|---|
| Engineering lead | Does the 4-month/1-engineer build estimate hold up? | Yes, and flagged the scraper's breakage risk is worse than modeled, sites change without warning, no advance notice window |
| Business sponsor | Does this map to the goal? | Yes, directly, faster/better-enriched leads shorten sales cycle, a stated Q3 goal |
| Finance | Does the opportunity-cost model hold up? | Yes, $30k/engineer-month loaded is right; confirmed against the core routing-logic roadmap item it would have displaced |
| Security | Vendor compliance posture? | Vendor A: SOC 2 Type II, current |
| Legal | MSA red flags? | Vendor A: standard terms, no redline needed |

### 10. Recommendation revised
No flips: the draft held up under review. Engineering's added color (breakage risk understated) strengthens the case against build rather than changing it; folded into the final recommendation below as an explicit reason, not just a footnote.

## Post

### 11. Written to decision-log
No disagreement surfaced in review, this is a regular decision, logged directly:

| Field | Value |
|---|---|
| Question | Should lead enrichment be built, bought, or extended from the existing CRM? |
| Status | Decided |
| Options Considered | Build (custom scraper); Buy: Vendor A; Buy: Vendor B; Extend (CRM's native enrichment add-on) |
| Decision | Buy: Vendor A |
| Rationale | Fails the moat test on all five checks; scraper's real 3-year TCO (~$300k+ engineer time, understated maintenance risk per engineering review) far exceeds Vendor A (~$99k); Vendor B eliminated on a must-have (SOC 2 Type II); CRM's native option ruled out on coverage. Vendor A frees 4 engineer-months for the actual differentiator (routing logic) |
| Owner | Product Manager, Growth (standing authority for Growth-area tooling decisions) |
| Date Decided | 2026-08-04 |
| Reversibility | Two-way door, standard SaaS contract, low switching cost if Vendor A underperforms |

Not hard-to-reverse enough on its own to warrant a separate `adr`; the Q3 routing-logic work this decision protects already has one.

### 12. Reopening triggers
- Enrichment becomes something we need to differentiate on (e.g., a proprietary scoring model layered on top), revisit as an extend case.
- Vendor A's pricing or SOC 2 status changes.
- Lead volume grows past Vendor A's rate limits before a plan upgrade covers it.

## Next
Feeds `integration-spec` for the API connection and `roadmap-prioritization` for a Q3 slot.
