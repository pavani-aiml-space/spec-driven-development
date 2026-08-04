---
name: tpm-sdd-bridge
description: >-
  Use when connecting Program Management Lifecycle (this pack) to Spec-Driven Development eng
  lifecycle skills: what hands off, who Approves, and where specs live. Does not
  run SDD skills or write program artifacts.
---

# Spec-Driven Development Bridge

## Purpose
**One job:** define the handoff contract between **Program Management Lifecycle** (`tpm-pdlc` + TPM skills) and **Spec-Driven Development** (`~/Spec-Driven-Development`) so neither pack steals the other’s responsibility.

## When to use
- Eng is about to start Spec-Driven work on a program that already has Concept / Align
- Clarifying who Approves SDD `design` / `plan` / `release`
- Wiring Hub Documents to `specs/` as build truth
- Onboarding someone who knows one pack but not the other

## Contract (do not merge the packs)

| Program Management Lifecycle | Hands across | Spec-Driven Development |
| --- | --- | --- |
| `tpm-concept` success criteria | → | `concept` (problem → stories) |
| `tpm-raci` Approvers | → | Who signs `design` / `plan` / `release` |
| Hub + `tpm-tooling-setup` | → | Links to board; specs live in SDD `specs/` |
| Delivery Prepare / Plan | → | `design` → `plan` |
| Delivery Execute (eng) | → | `build ↔ test ↔ review` (eng owns) |
| Delivery Measure | ← | Demos + `log` inform bi-weekly; do not replace it |
| Close | → | `release` → `closeout` → `kaizen` |

## Rules
1. TPM owns **program outcome and gates**; SDD owns **unit-of-work correctness**.
2. Hub **summarizes and links**; `specs/` is source of truth for build units.
3. AI may draft on either side; humans validate gates on both sides.
4. Do not copy full specs into Confluence registers.

## Process
1. Confirm Concept success criteria exist (`tpm-concept`).
2. Confirm Align Approvers exist (`tpm-raci`) for the SDD gates you will use.
3. Add Hub link to SDD `specs/` (and board from `tpm-tooling-setup`).
4. Tell eng which SDD skill to start (`concept` or `design` if concept already mirrored).
5. Stop — invoke the SDD skill in that repo; do not execute it from this skill.

## Output
A short bridge note: SDD starting skill, Approver names for design/plan/release, Hub → specs URL, board URL.

## Handoff
**PMLC phase:** usually end of Mechanism setup or start of Delivery Prepare (`tpm-pdlc`).
Does not replace `tpm-pdlc` or any SDD skill. Returns control to eng SDD pack or back to Delivery loop Measure.

## Checklist
- [ ] Concept success criteria exist
- [ ] Approvers named for SDD gates that matter
- [ ] Hub links to specs (and board if used)
- [ ] Starting SDD skill named
- [ ] No full spec pasted into Hub registers
