---
name: tpm-pdlc
description: >-
  Use when framing, kicking off, running, or closing a cross-team program as a TPM.
  Map-only skill for the Program Management Lifecycle (PMLC): dual-named phases
  (plain + Amazon flavor), which single-purpose skill to run next, human gates, and
  Prepare→Plan→Execute→Measure. Does not produce artifacts. Prefer as entry skill
  for "how do we run this program?"
---

# Program Management Lifecycle (PMLC)

## Purpose
One map for how a TPM runs a program end to end.

**This skill’s only job:** say which **phase** you are in, which **skill** to run next, and which **human gate** must pass. It does not write Concept docs, Hubs, RACIs, or status.

**PMLC** = Program Management Lifecycle (not product discovery, not eng AI-DLC).  
Skill folder id remains `tpm-pdlc` for compatibility; always say **Program Management Lifecycle** in docs and interview materials.

## Single responsibility

| Layer | One job |
| --- | --- |
| **`tpm-pdlc`** | Phase → next skill → gate |
| **Each artifact skill** | One artifact or one cadence report |
| **`tpm-sdd-bridge`** | Handoff contract to Spec-Driven Development |
| **Spec-Driven Development** (other repo) | Eng unit of work |

If a step needs two outputs, run **two skills in order**.

## Lifecycle (best of both names)

Plain names first; Amazon flavor in parentheses — same phases, not two lifecycles.

```
Concept (Work backwards)
  → Align (Staff / ownership)
  → Mechanism setup (Mechanisms)
  → Delivery / Deliver: Prepare → Plan → Execute → Measure
  → Close (Bar)
```

| Phase | Amazon flavor | One job | Skill(s) | Exit gate |
| --- | --- | --- | --- | --- |
| **1. Concept** | Work backwards | Lock goal, vision, success criteria, in/out | `tpm-concept` | Sponsor accepts Concept |
| **2. Align** | Staff / ownership | Who matters, then who is Accountable | (1) `tpm-stakeholder-map` (2) `tpm-raci` | Launch-critical Accountables + Approver path |
| **3. Mechanism setup** | Mechanisms | Where work lives | (1) `tpm-program-space` (2) `tpm-tooling-setup` then optional `tpm-sdd-bridge` | Hub + tracker conventions; program runnable without chasing TPM |
| **4. Delivery** | Deliver | Loop until Close | See loop table | Contested have Approver + deadline; commitments scorable |
| **5. Close** | Bar | Launch / handoff / learn | Hub go/no-go; QA `release-signoff` if needed; final Measure | Go/no-go recorded; sustainment owners named |

Block on **missing gates**, not perfect docs.

### 1. Concept (Work backwards)
1. Run **`tpm-concept` only**.
2. Optional: distill to Hub one-pager with `tpm-program-brief` if readers need a shorter page.
3. Do not run stakeholder map, RACI, or space here.

### 2. Align (Staff / ownership)
1. `tpm-stakeholder-map`
2. `tpm-raci`
3. Do not scaffold Hub/Jira here.

### 3. Mechanism setup (Mechanisms)
1. `tpm-program-space` — Confluence Home, Hub, seeded pages
2. `tpm-tooling-setup` — Jira/tracker project + conventions + Hub link
3. `tpm-sdd-bridge` when eng will use Spec-Driven Development
4. Contested Decisions page only when first needed

### 4. Delivery (Deliver) — loop
| Step | One job | Skills |
| --- | --- | --- |
| **Prepare** | Risks + decision packets | `tpm-risk-register`; `decision-log` / `tpm-contested-decisions` |
| **Plan** | Period commitments + critical path | Hub milestones; bi-weekly “Next two weeks” |
| **Execute** | Deliver + unblock + closers | `status-report`; `tpm-contested-decisions` |
| **Measure** | Sponsor score | `tpm-biweekly-stakeholder-update`; Hub status |

**Rollup:** green stays at lane; at risk → Measure only with mitigation.

### 5. Close (Bar)
1. Go/no-go from Hub criteria + critical-path risks
2. QA `release-signoff` when shared bar
3. Final Measure; RACI sustainment owners

## Gates (always human)

| Gate | After | Question |
| --- | --- | --- |
| **Outcome** | Concept | Right problem and success bar? |
| **Ownership** | Align | Who is Accountable if this fails? |
| **Mechanisms live** | Mechanism setup | Runnable without chasing the TPM? |
| **Contested** | Delivery Prepare | Who decides when we disagree? |
| **Date / scope** | Delivery Measure | Hold, move, or descope? |
| **Go / no-go (Bar)** | Close | Ship? |

AI drafts between gates; never passes a gate.

## Bolts (Draft → Validate → Publish)

| Bolt | Skill |
| --- | --- |
| Concept bolt | `tpm-concept` |
| Brief distill (optional) | `tpm-program-brief` |
| Map / RACI bolts | `tpm-stakeholder-map` / `tpm-raci` |
| Space bolt | `tpm-program-space` |
| Tooling bolt | `tpm-tooling-setup` |
| SDD bridge bolt | `tpm-sdd-bridge` |
| Risk / decision / status / bi-weekly | matching skills |

## Skill index

| Skill | One job | Phase |
| --- | --- | --- |
| `tpm-concept` | Work-backwards Concept | Concept |
| `tpm-program-brief` | Optional one-page distill | Concept (optional) |
| `tpm-stakeholder-map` | Who matters | Align |
| `tpm-raci` | Who is Accountable | Align |
| `tpm-program-space` | Confluence mechanisms | Mechanism setup |
| `tpm-tooling-setup` | Tracker/Jira mechanisms | Mechanism setup |
| `tpm-sdd-bridge` | Handoff to SDD | Mechanism setup / Prepare |
| `tpm-risk-register` | Risks + mitigations | Prepare |
| `decision-log` | Regular decisions | Prepare |
| `tpm-contested-decisions` | Stuck decisions | Prepare / Execute |
| `status-report` | Lane health | Execute → Measure |
| `tpm-biweekly-stakeholder-update` | Sponsor Measure (+ Plan slice) | Plan / Measure / Close |

## Output
Produce exactly one of: **phase check**, **kickoff sequence**, **loop check**, or **one bolt** — then run (or name) that skill. Do not generate every artifact here.

## Maturity (L1 now; L2 later)

| Level | Meaning |
| --- | --- |
| **L1 (current bar)** | Skills + right questions; TPM drives every bolt manually |
| **L2 (roadmap)** | Scheduled drafts + reminders; TPM validates and publishes |
| **L3+** | Exception-only / escalations — see roadmap; never auto-pass judgment gates |

Full roadmap and **TPM adoption metrics:** [`docs/pmlc-roadmap-and-adoption.md`](../../../docs/pmlc-roadmap-and-adoption.md).

### L1 in place (definition of done)
A program is L1-complete when all of the following are true:

- [ ] `tpm-concept` locked (measurable success criteria) — gate: Outcome  
- [ ] `tpm-stakeholder-map` + `tpm-raci` (Accountable on launch-critical lanes) — gate: Ownership  
- [ ] `tpm-program-space` Hub + `tpm-tooling-setup` board link — gate: Mechanisms live  
- [ ] Every Ask / commitment has **who + by + if late**  
- [ ] Every surfaced at-risk item has **mitigation** (`status-report` → bi-weekly Watch)  
- [ ] Contested rows (if any) have **Approver + deadline**  
- [ ] Bi-weekly uses Decision → evidence → Measure shape when sponsors need a cadence  
- [ ] Judgment gates are never skipped or “AI decided”  
- [ ] SDD (if used) goes through `tpm-sdd-bridge`  

**L1 exit test:** Another TPM can run the program for two weeks from Hub + registers alone.

### Self-running intent (does not change L1)
- **Automate later:** drafts, reminders, checklist validation, escalation pings (L2+).  
- **Never automate:** Outcome, Ownership, Contested choice, Date/scope, Go/no-go (Bar).  
- **Silence needs a default** (opt-in at L2): document “if no Approver by date → X” so the system does not stall.

## Handoff
Entry map for the TPM pack. Artifact work is always delegated. Eng build lifecycle is via `tpm-sdd-bridge` → Spec-Driven Development. Maturity and adoption measurement → `docs/pmlc-roadmap-and-adoption.md`.

## Checklist
- [ ] One phase named (plain + Amazon flavor OK)
- [ ] Next action is one skill (or Align’s map→RACI, or Mechanism’s space→tooling)
- [ ] No artifact drafted inside `tpm-pdlc`
- [ ] Next human gate named
- [ ] Delivery step labeled Prepare / Plan / Execute / Measure when in Delivery
- [ ] SDD work goes through `tpm-sdd-bridge`, not ad hoc
- [ ] L1 bar understood; L2 work tracked in roadmap doc (not invented ad hoc)
