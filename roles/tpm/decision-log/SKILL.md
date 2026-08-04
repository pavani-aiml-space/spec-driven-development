---
name: decision-log
description: Use whenever a decision is made or an open question surfaces during a program. Regular decisions get recorded right here; decisions that turn out contested become a row on the program's shared Contested Decisions table (tpm-contested-decisions) - directly, if contested from the start, or gradually, if a logged item turns out to be stuck - and get linked back, never duplicated.
---

# Decision Log

## Purpose
One running log per program for every decision and open question, so nothing gets lost and nothing gets silently re-litigated later. Most decisions are **regular**: log them, decide them, done - no process needed. Some turn out to be **contested**: real disagreement, nobody has clear final say - those become a row on the program's shared **Contested Decisions** table (`tpm-contested-decisions`), either **directly** (obviously contested the moment it's raised) or **gradually** (logged here first as Open, only turns out to be stuck once people start working it). Either way, exactly one record exists per decision at any time - a full record here for regular ones, a link here for contested ones - never both.

## When to use
- A question surfaces that needs an answer eventually, even if it's not urgent yet - log it as Open the moment it comes up, don't wait.
- A decision - regular or contested - was just made and needs to be recorded so it isn't silently re-litigated later.
- Note: a contested decision doesn't get resolved inline here. It becomes a row on `tpm-contested-decisions`'s Contested Decisions table, which runs the actual resolution process (Driver, Approver, deadline). This log then just links to that page rather than duplicating its content.

## Process
1. **Log it the moment it surfaces.** Add a row with the question and today's date, Status = Open. Don't wait until it's urgent or already answered to write it down.
2. **Scaffold the starter log**, if one doesn't exist yet for this program. Run `scripts/generate-template.sh --title "<program name>" --output-dir <path>` to generate a starting CSV and Markdown table, rather than building it from a blank page.
3. **Watch for which kind it is** as the question gets worked:
   - **Regular** - resolves without real disagreement, usually by whoever already had standing authority (a `tpm-raci` Accountable owner) or by simple agreement. Fill in Options Considered, Decision, Rationale, Owner, Date Decided, and Reversibility directly in the same row. Status → Decided. This row is now the complete record.
   - **Contested** - real disagreement, nobody has clear final say, or it's stalling. This needs `tpm-contested-decisions`'s forcing process, not just an answer. It reaches the Contested Decisions table two ways:
     - **Direct**: obviously contested the moment it's raised - add it as a row there straight away (scaffolding the page if this program doesn't have one yet); the log row (new or existing) stays a stub.
     - **Gradual**: it sat here as Open, and only became clear it was stuck once people started working it - add it as a row there at that point instead.
4. **Never fill in both.** Once a row is Contested, set Status to "Contested - see Contested Decisions page" and link to it. Leave Options Considered/Decision/Rationale/Reversibility blank on this row - those live only on that row, so there's exactly one record, not two.
5. **Note reversibility on regular rows** - one-way door or two-way door - since that shapes how much scrutiny the call deserved.
6. **Link it.** Connect the row (or the Contested Decisions row it points to) to the related `tpm-program-brief`, design doc, or ADR. If this program has a Confluence space (see `tpm-program-space`), publish this log there directly rather than only keeping it local.

## Output
A single dated log: one row per decision or open question. Regular rows carry the full record (options considered, decision, rationale, owner, reversibility, date). Contested rows carry only a status and a link to the program's Contested Decisions page - the actual record lives there as a row, not a duplicate. `scripts/generate-template.sh` produces the starting CSV/Markdown draft.

## Handoff
**PMLC phase:** Delivery **Prepare** (`tpm-pdlc`).
**One job:** log regular decisions — contested multi-party calls graduate to `tpm-contested-decisions`.
Feeds `tpm-contested-decisions`'s Contested Decisions table when a row turns out contested (gradual escalation), or when a decision is raised already knowing it's contested and never sits here first (direct escalation) - and receives a link back once that row resolves, rather than a duplicated record. Can consume open questions surfaced by `plan` or `design`, and standing-owner context from `tpm-raci` for who typically decides regular items. Links to `tpm-program-brief`, design docs, or ADRs. If this program has a Confluence space (see `tpm-program-space`), this is the log scaffolded there in place of a separate "Open Decisions & Questions" page - update it directly rather than only keeping it local.

## Checklist
- [ ] Every open question got logged the moment it surfaced, not once it became urgent
- [ ] Regular rows have options considered (including rejected ones), not just the winner
- [ ] Regular rows have rationale explaining *why*, not just *what*
- [ ] Regular rows have an owner, a date, and reversibility noted
- [ ] Contested rows (direct or gradual) link to the program's Contested Decisions page instead of being filled in inline - no duplicated record
- [ ] Status is current for every row (Open / Decided / Contested - see Contested Decisions page)
