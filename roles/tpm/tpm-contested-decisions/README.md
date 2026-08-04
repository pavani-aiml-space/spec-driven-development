# Contested Decisions - quick guide

## What it's for
Tracks and resolves **contested** decisions - stuck because too many people are weighing in and nobody has clear final say - on one shared **Contested Decisions** table per program, one row per decision, with Driver/Approver/Contributors/Informed as columns. Most decisions are **regular** (someone just decides, `decision-log` records it); this is only for the exception. A contested decision reaches here **directly** (obviously contested from the moment it's raised) or **gradually** (logged first, turns out stuck once people start working it).

## How to trigger it
- Plain English: "we need to decide whether to build or buy X and it keeps going in circles"
- Name it directly: "use tpm-contested-decisions to resolve the vendor decision"
- Slash command: `/tpm-contested-decisions`

## What you'll be asked for
- The decision, written as a specific question with clear possible answers - not a vague topic (required)
- Driver's name - the person who runs the process (required)
- Approver's name - the one person with final say (required)
- Contributors - who should give input before the decision is made
- Informed - who should be told the outcome afterward
- A deadline for the decision itself
- Once decided: the options considered (including rejected ones) and whether it's a one-way or two-way door

## What happens, step by step
1. You name the decision precisely, as a question with clear possible answers.
2. If this program doesn't have a Contested Decisions page yet, generates the starter table with one worked example row. If it already exists, adds a new row instead.
3. Fills in Driver, Approver, Contributors, and Informed for that row - Contributors/Informed can pull from the Stakeholder Map if one exists.
4. Checks whether this decision falls inside an existing RACI's scope - if so, the Approver here should match that row's Accountable owner, not be a different person picked fresh.
5. Sets a real deadline, so this doesn't become a standing debate that never resolves.
6. Once decided, documents the decision and the reasoning behind it, not just the outcome, plus the options considered (including rejected ones) and reversibility, and sets Status to Decided.
7. Communicates the outcome to everyone Informed, plus anyone materially affected who wasn't already in the loop.

## What you get
One table per program, one row per contested decision: Driver/Approver/Contributors/Informed, deadline, status, the decision, the reasoning, options considered, reversibility, and the date decided - deliberately shaped so a Decided row also satisfies `decision-log`'s output for that decision (see "Works well with").

## Examples
Contested decisions are the exception - most of a program's RACI rows never need a row here:
- **No row needed**: a RACI's "Scope & priority decisions" row just runs on its named owner indefinitely.
- **Row needed**: a RACI's "Launch readiness (go/no-go)" row usually resolves by the owner just declaring it - but when Engineering and Support hit a real standoff over one specific P1 bug, that single question becomes a row here (Approver = the RACI row's Accountable owner), decided by a deadline, then folded back into that same row.

## Works well with
- Can consume open questions from `plan`, `design`, or a `decision-log` row that turned out contested (gradual entry) - or start here directly for a decision that's obviously contested from the start (direct entry)
- Contributors/Informed can be pulled from `tpm-stakeholder-map` instead of guessed
- Feeds `tpm-raci` once a decided row needs follow-on execution work with its own ownership breakdown
- Replaces the `decision-log` entry for a row here, not both - a decided row already has everything a log entry needs, so the log row links here instead of duplicating it
- If a Confluence space exists (`tpm-program-space`), publish this page there the first time a contested decision actually arises - it isn't scaffolded at kickoff
