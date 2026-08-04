---
name: tpm-raci
description: Use when a workstream has ambiguous ownership or multiple people/teams are involved, to define who is Responsible, Accountable, Consulted, and Informed for each deliverable or standing decision-making role. For a one-off contested decision with no established owner, use tpm-contested-decisions instead.
---

# RACI

## Purpose
Remove ambiguity about who does the work, who answers for it, who needs to weigh in, and who just needs to know - before that ambiguity causes a dropped ball or a decision made by the wrong person.

## When to use
- A workstream spans more than one team or more than a couple of people, and it's unclear who the standing owner is for each part of it.
- A new initiative is starting and ownership hasn't been made explicit yet - an assignment gap, not yet a live dispute over any one call.
- Note: RACI fits execution/delivery ownership - naming who does the work and who answers for it, as a standing role, when the fix is simply "assign someone." If instead one specific decision is actively stalling because too many people are weighing in and nobody has final say, that's a live dispute, not an assignment gap - use `tpm-contested-decisions` instead, which separates who runs the process from who has final say. RACI's shared Accountable role can't force a contested decision closed the way a Contested Decisions row's single Approver can.

## Process
1. **Start from `tpm-concept`** (scope in/out, sponsor) and the roster from `tpm-stakeholder-map`. Don't invent either from scratch. Expect this first pass to be incomplete early on.
2. **Scaffold the starter draft.** Run `scripts/generate-template.sh --title "<initiative name>" --output-dir <path>` to generate a starting CSV and Markdown matrix with standard functions pre-filled per step 6, rather than building the grid from a blank page.
3. **Fill in and mark gaps explicitly.** Replace the template's placeholders with the real deliverables from step 1, marking unnamed owners as TBD rather than guessing or leaving a cell blank, and revisit as design/planning fills gaps in - a new team gets pulled in, a risk from the brief turns into its own decision needing an owner, a deliverable surfaces that wasn't in the original scope. Commonly missed even once things stabilize: the business case/budget approval decision itself - don't assume it happened somewhere upstream; give it its own item with a named Accountable/Approver.
4. **Identify stakeholders before assigning names.** Map which teams/functions are actually touched by this workstream, then confirm ownership with each function's lead directly - a RACI assigned unilaterally from outside a function is often wrong about who that function would actually put forward.
5. **Assign roles per item**, not per person:
   - **Responsible** - does the work. Can be more than one.
   - **Accountable** - answers for the outcome. Exactly one person per item, no exceptions. Same concept as "DRI" (Directly Responsible Individual) in orgs that use that term instead - different vocabulary, not a second ownership model to reconcile against this one.
   - **Consulted** - gives input before the decision/work is final (two-way).
   - **Informed** - told after the fact (one-way).
6. **Place the Sponsor above the grid for delivery items, not inside it.** A Sponsor (typically an exec/senior leader) isn't Accountable for day-to-day delivery - they resolve resourcing/priority conflicts between Accountable owners and back the initiative to leadership. Don't fill them into an R/A/C/I cell for a specific deliverable; name them separately as the escalation point. The one exception: the business case/budget approval decision itself is usually theirs to hold as Accountable/Approver, since that's a funding gate, not a delivery task.
7. **Map standard functions to their typical role**, then adjust per initiative:
   - Product: Accountable/Responsible for scope and product decisions.
   - Engineering: Responsible for implementation; Accountable for technical-delivery items.
   - Design: Responsible for design deliverables, Consulted on user-facing decisions elsewhere.
   - Security: Consulted by default; Accountable on security-review gating decisions.
   - Finance: Consulted on anything with budget/pricing impact elsewhere in the matrix; Responsible for building/maintaining the business case or ROI model that the Sponsor's funding decision rests on.
   - Support/CS: Informed by default; Consulted if the change affects support load or runbooks.
   - **Legal and Compliance: escalate past Consulted whenever the initiative has compliance, regulatory, contractual, or data-privacy surface.** Consulted only means "gives input, doesn't block" - if Legal/Compliance actually need to sign off before something ships, that's Accountable-tier (or joint-Approver) authority, not Consulted. Defaulting them to Consulted on a regulated initiative is a common, costly mistake - it lets compliance find out after the decision shipped instead of gating it. See `examples/compliance-initiative-example.md` for a worked matrix.
8. **Resolve overload.** If one person is Accountable for too many items, or Consulted on everything, that's a signal to redistribute - flag it rather than leaving it.
9. **Check for gaps.** Every deliverable needs exactly one Accountable owner. No item should have zero Responsible parties.
10. **Circulate and confirm in a live session, not just an inbox.** Walk through the matrix with everyone named in it together and get explicit agreement - how that conversation happens matters as much as the matrix's accuracy, since disagreements about who's actually Accountable surface in the room, not in a silently-approved email thread.

## Output
A RACI matrix: rows are deliverables or standing decision-making roles (a category of choices someone has ongoing authority over, or an approval gate with an already-known owner - not a one-off contested decision, which is `tpm-contested-decisions`'s job), columns are people/roles, cells are R/A/C/I, with the Sponsor named separately as the escalation layer above the grid. `scripts/generate-template.sh` produces the starting CSV/Markdown draft; the finished matrix is that template edited with the initiative's real deliverables and names.

## Examples
RACI is the default - built once per program, and most rows run on their named owner without ever needing a Contested Decisions row:
- **Stays in RACI**: the "Scope & priority decisions" row - PM is Accountable and decides scope changes as they come up, indefinitely. No Contested Decisions row, ever - naming the owner was the whole fix.
- **Escalates, then folds back in**: the "Launch readiness (go/no-go review)" row - PM is normally Accountable and just declares go/no-go using established criteria. But when Engineering and Support hit a real standoff over whether a specific P1 bug blocks this launch, that one question becomes a row on the program's Contested Decisions page (`tpm-contested-decisions`, PM as Approver, matching this row's Accountable), decided by a deadline - then the outcome folds back into this same row, not into a new standing structure. See `tpm-contested-decisions`'s Examples section for the same case from the other side.

## Handoff
**PMLC phase:** Align (`tpm-pdlc`) — step 2 of 2 (after `tpm-stakeholder-map`); revisit in Delivery / Close when ownership shifts.
**One job:** Accountable / Responsible (and C/I) for deliverables and gates — not stakeholder discovery, not Hub setup.
Consumes scope from `tpm-concept` (or brief distill), the stakeholder roster from `tpm-stakeholder-map` when one exists, and a resolved decision from `tpm-contested-decisions` when that decision needs execution work staffed out. Feeds `status-report` (who to escalate a blocker to) and `decision-log` (who actually held Accountable/Approver authority when a regular decision was made). A regular decision that comes up inside one of these rows gets logged directly in `decision-log`; only a genuinely contested one - no clear final say, real disagreement - escalates to `tpm-contested-decisions`, either directly or gradually from a logged row. If this program has a Confluence space (see `tpm-program-space`), update the existing RACI page there directly rather than only keeping this local.

## Checklist
- [ ] Deliverable list and initial stakeholders pulled from the program-brief, not invented from scratch
- [ ] Unknown owners marked TBD and revisited as scope clarifies, not guessed or left blank
- [ ] Ownership confirmed with each function's actual lead, not assigned unilaterally from outside
- [ ] Every deliverable has exactly one Accountable owner
- [ ] No deliverable has zero Responsible parties
- [ ] Consulted/Informed lists are as short as they can be (not "everyone, to be safe")
- [ ] Overloaded owners were flagged, not silently accepted
- [ ] Sponsor identified and kept outside the R/A/C/I cells for delivery items, not conflated with Accountable
- [ ] Business case/budget approval captured as its own item with a named Accountable/Approver, not left implicit
- [ ] If the initiative touches legal/compliance/regulatory surface, Legal/Compliance hold Accountable or joint-Approver authority on the gating decision, not just Consulted
- [ ] Matrix was walked through live with everyone named in it, not just circulated for silent sign-off
- [ ] Any row added to the Contested Decisions page (`tpm-contested-decisions`) for a decision inside this matrix has an Approver matching the relevant row's Accountable/DRI, or an explicit documented delegate - not a different, unreconciled owner
