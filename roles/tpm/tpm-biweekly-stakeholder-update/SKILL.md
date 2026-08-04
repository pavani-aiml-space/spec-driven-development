---
name: tpm-biweekly-stakeholder-update
description: Use on a bi-weekly cadence to write a senior-stakeholder program update — recommendation, one decision table to review (with pre-read / trade-off links), progress and demos as evidence, and next-two-weeks commitments. Prefer this over status-report when the audience is sponsor / leadership.
---

# Bi-weekly Stakeholder Update

## Purpose
Give sponsors and senior stakeholders a scannable bi-weekly update that answers: Are we holding the launch date? What decision do you need to make? Did the team produce real progress? What must be true in two weeks?

This is not a second Program Hub and not a team standup dump.

## When to use
- Bi-weekly stakeholder / sponsor update for a live program
- When rewriting or reviewing an existing bi-weekly update for senior altitude
- When publishing a dated edition under a Bi-weekly Stakeholder Updates index in Confluence (`tpm-program-space`)

For lightweight or internal status only, use `status-report` instead.

## Language
Use plain terms common at Atlassian / Amazon / Google:

| Prefer | Avoid |
| --- | --- |
| bi-weekly update / this update | pack, fortnight |
| on track / at risk / off track | Mixed, “needs attention” without a date call |
| DRI / owner | Driver (unless the program already uses DACI labels on Contested Decisions) |
| launch / launch date | unexplained jargon; spell out GA once if used |
| We’ll call this green in two weeks if… | On track next pack if… |
| Proposed (recommendation under review) | crafty or coaching asides |
| schedule buffer / not on critical path yet | “slack remains” (reads as the Slack app) |

Do not put TPM meta in the update (“CTO lens”, “do not steal airtime”, “classic failure mode”).
Do not use em dashes (`—`) in the published update; prefer `,` / `;` / `:`.

## Section order (most → least important)
1. **Status banner + meta** — RAG panel, then a **label | value** table (not `<br/>` lines): Period, Phase 1 launch, Confidence, TPM, Sponsor, optional Delivery vs launch, Call on [launch date]. Label column uses header fill `#8993A5`; alternate value cells `#F4F5F7`. Do not use an H2 titled “Recommendation”.
2. **Decision to review** — one primary decision; table + pre-reads (see below). Proposed column carries the recommendation.
3. **Progress and demos** — Done, Demos (evidence), Missed vs plan.
4. **Next two weeks** — dated commitments + “We’ll call this green in two weeks if…”
5. **Items to Watch** — normal `## 4.` section (not a Confluence expand). These are **rolled up** from lower-level status (see Status rollup below): only at-risk / off-track items that still matter at sponsor altitude, each with a **mitigation**. Do not duplicate the period’s decision. End with one labeled **Program docs:** line (Hub + updates index). Detail lives in Risk Register; link it in the intro.

Avoid leading with an H2 titled “Recommendation”. Prefer “Decision to review” first among section headings.

## Status rollup (eng → sponsor)
Status is written at the working level and filtered upward. Do not paste raw eng status into the bi-weekly.

| Level | Artifact | Who | What goes up |
| --- | --- | --- | --- |
| Lane / eng | `status-report` (weekly) or team sync + Jira | Eng lead / lane DRI | RAG per workstream; every **at risk** / **off track** item must include owner, by-when, and **mitigation** (what we are doing now) |
| Program | Risk Register + Contested Decisions | TPM | New or worsened risks; decisions that need an Approver |
| Sponsor | This bi-weekly update | TPM | Banner RAG + Decision to review; **Items to Watch** only for items that can still hit date, scope, trust, or cost |

Rules:
- **Green stays down.** On-track eng detail does not appear in the bi-weekly except as short Done / Demo evidence.
- **At risk surfaces with mitigation.** If a lane marks at risk / off track, it is a candidate for Items to Watch only when a mitigation exists (or an explicit ask is needed because mitigation is blocked).
- **Mitigation blocked → Decision or Ask.** If the team cannot mitigate without sponsor/Legal/Security, promote it into Decision to review or a Next-two-weeks commitment with a named DRI — do not leave it as a vague watch bullet.
- **One altitude per page.** Do not dump Jira story lists into Items to Watch; optional one tracking link under Pre-reads for the period’s decision is enough.

## Decision to review
Senior readers should see **options**, a **proposed** recommendation, and **pre-reads** that contain trade-offs — the same pattern program managers use at Amazon / Atlassian (decision brief / one-pager before the review).

### Above the table
- State the **Decision** in one plain sentence (not crammed into a narrow column that mid-wraps).
- State the **Ask in the review** (what you need approved or redirected).

### Table shape
| Options | Proposed | DRI | By | If late |
| --- | --- | --- | --- | --- |

Rules:
- **One primary decision** per bi-weekly update.
- **Each option on its own line** inside the Options cell (separate `<p>` per option: `A: …`, `B: …`, `C: …`). Do not run options as a single mid-wrapping sentence. Prefer `:` over `--` / em dashes in option labels.
- When the decision is geographic or regulatory footprint, **name real jurisdictions** and say why they change eng/QA load (do not leave “+2 states” abstract).
- **Proposed** is bold and unmistakable; short conditionals OK on a second line in that cell.
- Header cells use a clear header fill (`data-background="#8993A5"` plus matching `style="background-color: #8993A5"`) and `data-colwidth` sized so headers and short labels do not awkwardly wrap mid-word. Alternate body rows with `#F4F5F7` (same pattern as Risk Register). Prefer `data-layout="default"` and `data-display-mode="fixed"`. Confluence draws cell borders natively; do not rely on custom CSS (it is stripped).
- Put a decision in the table only if it changes **date, scope, customer/trust risk, or material cost** at sponsor altitude.
- Do not restate the full option set in §1; §1 points at §2.
- Do **not** add peer “example” technical decisions or cache-architecture rows to pad the section.

### Pre-reads (required when a decision is open)
Link the artifacts a TPM would actually send before a decision review:

| Artifact | Purpose |
| --- | --- |
| **Decision brief** (one-pager) | Context, options, trade-offs (upside / downside), recommendation, reversibility, what we need in the review, consulted / informed |
| **Contested Decisions** row | DACI / approver, deadline, options considered (when contested) |
| **RACI** (relevant row) | Who is Accountable vs consulted |

Create or update the decision brief if it does not exist yet — do not leave “trade-offs” only as oral context. Optional extras when they help: load-test or customer evidence, escape-hatch / descope note already approved, link to Hub go/no-go criteria.

### FYI under the table
Working-team items that are **not** leadership decisions stay out of the table (one line max, or omit). Prefer linking a settled eng recommendation in a design/RFC doc over elevating it into Options/Proposed.

## Progress and demos (evidence)
- **Done** — outcomes this period.
- **Demos** — max ~3; columns: What you can see | Owner | Where | Loom | Why it matters. Include a Loom share link per row (real recording when available; `loom.com/share/…-placeholder` OK while drafting). Header cells shaded; colwidths avoid mid-word header wrap.
- **Not demoable yet** — critical-path gaps and whether schedule/dependency vs capacity.
- **Missed vs plan** — honest misses.

## Items to Watch (surfaced risks)
Intro line (plain language): **Key risk items that need to be on radar.** On-track detail stays at the team level. Full register: [Risk Register].

Table shape (prefer over bullets when there is more than one item):

| Item | Owner | By | Mitigation |
| --- | --- | --- | --- |

- Pull candidates from lane `status-report`s and the Risk Register for the period.
- Only include items that are **at risk** or **off track** (or open product/compliance gates) at program altitude.
- **Mitigation is required** on every row: the action already in motion, not a wish.
- If mitigation needs a decision from leadership, that item belongs in Decision to review (or Next two weeks as the decision commitment), not only here.

## Senior-altitude filter
Include if a CEO / CTO / CPO would need it to choose. Exclude or demote:
- Implementation detail with a settled eng recommendation
- On-track lane status with no date/scope impact
- Duplicate storytelling of the same gate across every section
- Unanchored metrics
- Insider nicknames without the plain decision name

## Publishing
- Prefer dated editions under a **Bi-weekly Stakeholder Updates** index.
- Publish via Atlassian MCP as HTML+ with shaded header cells and balanced `data-colwidth`.
- Confirm with the user before publishing new shared pages.

## Handoff
- **PMLC phase:** Delivery **Plan / Measure** (`tpm-pdlc`); also Close for final score and launch call.
- **One job:** sponsor-altitude update (decision + evidence + commitments + rolled-up watch items) — not lane status dumps.
- Hub / registers remain source of truth (`tpm-program-space`, `tpm-risk-register`, `decision-log`, `tpm-contested-decisions`).
- Lane / eng cadence uses `status-report`; this skill consumes only rolled-up at-risk items with mitigations.
- Decision briefs may live under Contested Decisions or next to the bi-weekly edition.
- Score prior “next two weeks” commitments as Done / Missed in the following update.
- General cadence reporting without this stakeholder shape → `status-report`.
- Typical **bi-weekly bolt:** Draft → TPM altitude validate → Publish (see `tpm-pdlc`).

## Checklist
- [ ] RAG and launch-date call are visible before activity
- [ ] No H2 titled “Recommendation”; call on the date is short body text under status (or only in Proposed)
- [ ] Decision stated in prose above the table; ask in the review is clear
- [ ] Table headers shaded; Options / Proposed / DRI / By / If late
- [ ] Each option on its own line; no mid-word header/option smash
- [ ] Proposed recommendation is explicit
- [ ] Pre-reads link decision brief (trade-offs), Contested Decisions, and RACI as relevant
- [ ] No padder technical “example” decisions in the table
- [ ] Demos under Progress as evidence
- [ ] “We’ll call this green in two weeks if…” (no “pack” / “fortnight”)
- [ ] Every Next-two-weeks commitment has owner + by (if late implied or stated)
- [ ] Items to Watch rows came from lower-level at-risk status and each has a mitigation
- [ ] On-track eng detail was not pasted into the bi-weekly
- [ ] Items to Watch is a normal H2 (table preferred); Program docs is one labeled line
- [ ] User confirmed before publishing new shared pages
