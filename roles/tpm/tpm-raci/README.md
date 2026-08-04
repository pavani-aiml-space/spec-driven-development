# RACI - quick guide

## What it's for
Figures out who does the work, who's on the hook for it, who needs to weigh in, and who just needs to know, for each deliverable or standing decision-making role in a program. A one-off contested decision with no established owner belongs in `tpm-contested-decisions` instead - see "Works well with" below.

## How to trigger it
- Plain English: "who owns the launch decision for X" or "create a RACI for the Caregiver Access program"
- Name it directly: "use tpm-raci to define ownership for X"
- Slash command: `/tpm-raci`

## What you'll be asked for
- The program or initiative name (required)
- Sponsor's name (optional - defaults to "TBD" if you don't have one yet)
- Program Manager's name (optional - defaults to a generic "Program Manager" label if you don't have one yet)
- The real deliverables/standing decision-making roles for this program (you fill these in after the starter draft is generated)
- Real names for Responsible/Accountable/Consulted/Informed on each row (starter draft uses generic role names like "Engineering" or "Security" as placeholders)

## What happens, step by step
1. Pulls the deliverable list and initial stakeholder names from the Program Brief, if one exists.
2. Generates a starter table (with example rows already filled in with common roles) instead of a blank page.
3. You replace the starter rows with your program's real deliverables and swap in real names.
4. Checks that every row has exactly one Accountable owner and at least one Responsible party - never zero, never more than one Accountable.
5. Flags if Legal/Compliance need to be Accountable (not just Consulted) because the work touches regulated or data-privacy territory.
6. Walk the finished matrix through with everyone named in it, in a live conversation, and get explicit agreement before treating it as final.

## What you get
A table: Deliverable/Decision, Responsible, Accountable (DRI), Consulted, Informed - plus a plain-English legend, a Sponsor field, and notes on how RACI and Contested Decisions relate so the two don't create competing owners for the same decision.

## Examples
RACI is the default - most rows just run on their named owner and never need a Contested Decisions row:
- **Stays in RACI**: "Scope & priority decisions" - PM is Accountable and makes the call whenever it comes up. Done, no Contested Decisions row needed.
- **Escalates, then comes back**: "Launch readiness (go/no-go)" - PM is Accountable and usually just declares it. But if Engineering and Support get into a real standoff over one specific P1 bug, that one question becomes a row on the program's Contested Decisions page (`tpm-contested-decisions`, with the PM as Approver, matching this row), and the answer folds back into this same row once decided.

## Works well with
- Pulls from: `tpm-program-brief` (deliverable list), `tpm-stakeholder-map` (who the real stakeholders are)
- Feeds: `status-report` (who to escalate a blocker to), `decision-log` (where regular decisions inside these rows get recorded)
- If a decision inside this matrix turns out contested, it escalates to `tpm-contested-decisions` (directly or gradually) - its Approver should match this matrix's Accountable for that row
- If a Confluence space exists (`tpm-program-space`), updates the existing RACI page there directly
