---
name: tpm-contested-decisions
description: Use to track and resolve contested decisions - ones stalling because too many people are weighing in and nobody has final say - on a per-program Contested Decisions table with Driver/Approver/Contributors/Informed as columns, one row per decision. Most decisions are regular and belong in decision-log instead; this is for the exception.
---

# Contested Decisions

## Purpose
Get contested decisions actually made and have them stick, by separating who runs the process from who has final say, before they get relitigated in every subsequent meeting. Most decisions in a program are **regular** - someone with standing authority just decides, and `decision-log` records it, done. This skill is for the exception: a decision is **contested** when people genuinely disagree and nobody has clear final say. A contested decision reaches this skill two ways - **directly** (obviously contested the moment it's raised, never sits anywhere as a plain open question) or **gradually** (logged in `decision-log` first, turns out stuck once people start working it). Every contested decision in a program lives as one row on one shared **Contested Decisions** table - not a separate page per decision.

## When to use
- A decision is contested: stalling because too many people are weighing in and no one has clear final say.
- The thing that needs resolving is the decision itself, not the resulting execution work (`tpm-raci` covers that once the call is made).
- A past decision keeps getting relitigated because ownership of it was never made explicit.
- Note: if the decision isn't actually contested - someone just needs to decide and record it - that's a regular decision. Use `decision-log` directly instead; don't add a row here for something nobody disagrees about.

## Process
1. **Name the decision precisely.** Write it as a specific question with a clear set of possible answers (yes/no, A/B/C), not a vague topic like "figure out our approach to X."
2. **Scaffold the page if one doesn't exist yet for this program.** Run `scripts/generate-template.sh --title "<program name>" --output-dir <path>` to generate a starting CSV and Markdown table, rather than building it from a blank page. If the page already exists, add a new row directly instead of re-running the generator (which only produces the starter page).
3. **Assign the four roles per row**:
   - **Driver** - runs the process: gathers input, sets the timeline, keeps it moving toward a resolution. Does not necessarily have final say.
   - **Approver** - exactly one person with final authority. Keep this separate from the Driver wherever possible, so the person facilitating the discussion isn't also the loudest vote in the room.
   - **Contributors** - give input and expertise before the decision is made.
   - **Informed** - told the outcome afterward; not involved in making it.
4. **Check the Approver against any existing RACI for this scope.** If this decision falls inside a deliverable already covered by a `tpm-raci` matrix, the Approver here should be the same person as that row's Accountable/DRI, or an explicit, documented delegate - not a different person picked fresh for this decision. A mismatch is an authority collision, not a second valid owner; see `examples/delegated-access-decision-example.md` for a worked case.
5. **Set a deadline for the decision**, not just for who's involved - an undated row just becomes another standing debate that never resolves.
6. **Decide and document the reasoning**, not just the outcome - so it isn't relitigated later without new information actually changing anything.
7. **List the options considered, including the ones rejected, and note reversibility** (one-way door vs. two-way door) - this is what makes the row complete enough that `decision-log` doesn't need a duplicate entry (see Handoff).
8. **Communicate the decision** to everyone Informed, plus anyone materially affected who wasn't already in the loop.
9. **Set Status to Decided** once resolved; don't leave a settled row marked Open. If this row graduated from `decision-log`, update that row's Status there too, pointing back to this page instead of leaving it Open.

## Output
A Contested Decisions table, one page per program: rows are contested decisions, columns are Driver/Approver/Contributors/Informed/Deadline/Status/Decision/Rationale/Options Considered/Reversibility/Date Decided. `scripts/generate-template.sh` produces the starting CSV/Markdown draft with one worked example row; new contested decisions are added as new rows by editing the page directly, the same way `tpm-raci` rows get added. This table is deliberately shaped so a Decided row satisfies `decision-log`'s output too - see Handoff.

## Examples
Contested decisions are the exception - most RACI rows never need a row here; a row gets added only when a specific call inside one is genuinely stuck:
- **Most rows never need this**: a RACI's "Scope & priority decisions" row runs indefinitely on its named Accountable owner - no row here, because nothing there is actually contested.
- **This row's decision gets stuck, so it graduates**: a RACI's "Launch readiness (go/no-go review)" row usually resolves by its Accountable owner (PM) just declaring it. But when Engineering and Support disagree hard over whether a specific P1 bug blocks this launch - stalling because neither will yield - that one question becomes a row here: PM as Approver (matching the RACI row's Accountable, not a different person), Engineering and Support as Contributors, a real deadline. Once decided, the outcome folds back into that same RACI row's execution - this table doesn't track ongoing work, only the decision.

## Handoff
**PMLC phase:** Delivery **Prepare / Execute** (`tpm-pdlc`); Contested is a human gate.
**One job:** force a closer (Approver + deadline) on stuck multi-party decisions — not the full decision log, not status.
Feeds `tpm-raci` once a decided row requires follow-on execution work that needs its own ownership breakdown. Can consume open questions surfaced by `plan` or `design` that need a single owner to resolve before work continues, and Contributors/Informed can be pulled from `tpm-stakeholder-map` when one exists rather than guessed. Reaches this table from `decision-log` two ways: **gradually**, when a row logged there turns out contested and needs to graduate; or **directly**, when a decision is raised already knowing it's contested and never sits in the log as a plain open item. Either way, once resolved, this row **replaces the decision-log entry, not both**: a decided row already has everything `decision-log` asks for (context, options considered, choice, rationale, owner, date, reversibility) - the log row just links to this page instead of duplicating it. If this program has a Confluence space (see `tpm-program-space`), run `scripts/generate-template.sh` and publish this page there directly - it's created the first time a contested decision actually arises, not scaffolded at kickoff alongside the always-present docs.

## Checklist
- [ ] Decision is written as a specific question, not a vague topic
- [ ] Exactly one Approver per row, kept distinct from the Driver wherever possible
- [ ] If a row sits inside an existing RACI's scope, the Approver matches that row's Accountable/DRI, or the delegation was made explicit - not left as an unreconciled second owner
- [ ] A deadline was set for each row
- [ ] Reasoning was documented, not just the outcome
- [ ] Options considered (including rejected ones) and reversibility are captured, not just the final call
- [ ] Everyone Informed actually got told, not assumed to find out on their own
- [ ] No separate `decision-log` entry exists for a decision that's already a row here
- [ ] New contested decisions were added as rows on the existing page, not as new separate pages
