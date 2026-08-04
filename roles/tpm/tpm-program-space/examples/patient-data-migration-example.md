# Worked example: Patient Data Migration to Centralized Store

Illustrative content for both tiers of a program space, not a template to copy verbatim - the point is the split between a minimal Space Home and a content-rich Program Hub, per Process steps 2-3.

## Tier 1: Space Home (minimal - landing/navigation only)

```
# Patient Data Migration to Centralized Store

Migration of patient and member data from different data sources - Benefits, Pharmacy, Legacy Invoicing, and Claims - into a single centralized store.

**Go to the [Program Hub](https://your-site.atlassian.net/wiki/spaces/PDM/overview#)** to access mission, vision, success metrics, key documents, risks, decisions, and program status information.

## Quick Links
- [Program Hub](https://your-site.atlassian.net/wiki/spaces/PDM/overview#) - mission, vision, success metrics, key documents
- [Risk Register](https://your-site.atlassian.net/wiki/spaces/PDM/overview#) - program-level risks
- [Decision Log](https://your-site.atlassian.net/wiki/spaces/PDM/overview#) - open questions and regular decisions; contested ones link out to the Contested Decisions page
- [Most Recent Status Update](https://your-site.atlassian.net/wiki/spaces/PDM/overview#) - latest dated entry, not just the Progress Log index

## Space Contacts
- Program Sponsor: Jessie-ToyStory
- Program Manager: Buzz Light Year
```

Note the Quick Links deliberately point at Risk Register, Decision Log, and the *most recent* status entry, not a generic "Progress Log" index - someone landing here should get the current state in one click, not two.

## Tier 2: Program Hub (content-rich - the actual working document)

```
# Program Hub: Patient Data Migration to Centralized Store

## Overview

### Mission
Consolidate patient and member data currently fragmented across the Benefits, Pharmacy, Legacy Invoicing, and Claims systems into a single centralized data store, so every downstream system reads from and writes to one canonical record instead of four separate, sometimes conflicting, ones.

### Vision
A single source of truth for patient data that eligibility checks, pharmacy adjudication, claims processing, and billing all depend on consistently - ending the current state where the same patient can have different records depending on which system you ask.

### Success Metrics
- 100% of active patient records migrated with zero data loss, verified by reconciliation counts against each source system.
- A canonical patient ID model adopted by all four source systems, with zero unresolved duplicate or conflicting identity matches at cutover.
- No unplanned downtime in Pharmacy or Claims during migration - both are live transactional systems that can't go down mid-migration.
- Legacy Invoicing fully decommissioned within [X months] of go-live.
- All migrated data passes compliance validation (HIPAA/PHI handling) before launch, with zero compliance findings at go-live.

## Key Documents
- Program Brief, RACI, Contested Decisions, Risk Register, Decision Log, Progress Log

## Program Aggregation

| Project | Status | Key Risk | Owner |
|---|---|---|---|
| Benefits | Not started | Source of truth for downstream systems - must be validated first | TBD |
| Pharmacy | Not started | Live transactional system; needs parallel-run cutover | TBD |
| Legacy Invoicing Systems | Not started | Undocumented business logic buried in legacy code | TBD |
| Claims | Not started | Depends on Benefits and Pharmacy landing correctly first | TBD |

## Projects
- Benefits, Pharmacy, Legacy Invoicing Systems, Claims
```

Two design points worth noting:

- **The canonical patient ID decision belongs on a `tpm-contested-decisions` page, not buried in the Hub's prose.** It's the single highest-stakes cross-project decision in this program (every project's migration depends on it), which is exactly the "one Driver, one Approver" case `tpm-contested-decisions` exists for.
- **Migration sequencing (Benefits before Claims, both before full cutover) belongs in the program-level `tpm-risk-register`, not assumed.** The Aggregation table above already hints at it (Claims' Key Risk names the dependency directly) - the actual risk register entry should carry likelihood/impact/mitigation for it, not just a one-line callout.
