---
name: tpm-tooling-setup
description: >-
  Use in PMLC Mechanism setup after Confluence space exists, to set Jira (or
  equivalent tracker) project conventions for the program: board, epics/labels,
  and how work links back to the Hub. Does not create Confluence pages.
---

# Tooling Setup (Jira / tracker)

## Purpose
**One job:** make the work tracker usable for this program — project/board, naming conventions, and Hub link-back — so Mechanism setup is complete without stuffing tracker config into `tpm-program-space`.

## When to use
- PMLC **Mechanism setup / Mechanisms** (`tpm-pdlc`) — after or beside `tpm-program-space`
- Program needs a clean Jira (or Linear/Asana/etc.) project before Delivery Execute
- Re-baselining labels/epics after a major scope change

## Process
1. **Confirm tracker.** Which system is source of execution truth (usually Jira).
2. **Project / board.** Create or designate the project; columns match how the team actually works (not an idealized waterfall).
3. **Naming.** Epic/label/component convention for this program (document on Hub in one line).
4. **Link to Hub.** Program Hub Documents (or Quick Links) points at the board; epics can link to Confluence Concept/Brief where useful.
5. **Do not** invent the full backlog here — Plan/Execute owns sequencing. This skill only makes the container and conventions real.

## Output
Checklist result + Hub note: tracker URL, project key, label/epic convention, board owner.

## Handoff
**PMLC phase:** Mechanism setup / Mechanisms (`tpm-pdlc`), after Align; usually after `tpm-program-space` (Confluence) so the Hub can link the board.
Feeds Delivery Execute (teams file work against the convention). Spec-Driven Development units may reference the same epics via `tpm-sdd-bridge`.

## Checklist
- [ ] Tracker project/board exists and is named for this program
- [ ] Column/workflow matches the team
- [ ] Epic/label convention written on the Hub
- [ ] Hub links to the board
- [ ] No full backlog invented in this skill
