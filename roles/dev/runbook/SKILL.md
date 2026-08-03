---
name: runbook
description: Use to document how to operate, monitor, and troubleshoot a service — the reference handed off so someone other than the author can diagnose and respond to problems.
---

# Runbook

## Purpose
Give whoever is on call or supporting a service what they need to diagnose and respond to problems, without needing the original author available to explain it live.

## When to use
- Before or at `release` of a new service or significant new operational surface.
- After an incident reveals the existing runbook was missing something needed during response.

## Process
1. **Describe the service at a glance.** What it does, its dependencies, and what "healthy" looks like (key metrics/dashboards).
2. **List common failure modes.** For each: symptoms (what an on-call person would actually observe), likely cause, and diagnostic steps — written for someone without full context.
3. **Give concrete diagnostic commands/queries**, not just descriptions — exact commands, log queries, or dashboard links that can be run directly under pressure.
4. **Document recovery actions.** Step-by-step remediation for each known failure mode, including how to roll back or fail over if applicable.
5. **List escalation paths.** Who/what to contact if the runbook doesn't resolve it, and what information they'll need.
6. **Keep it current.** Update the runbook whenever a new failure mode is discovered (especially post-incident) — a stale runbook is worse than none, because it misdirects.

## Output
A runbook: service overview, health indicators, failure modes with diagnosis and remediation steps, escalation path.

## Handoff
Produced alongside `release` for anything with an operational surface; updated as part of incident follow-up.

## Checklist
- [ ] Health indicators are concrete (specific metrics/dashboards), not vague
- [ ] Each failure mode has observable symptoms, not just a label
- [ ] Diagnostic steps include exact commands/queries, not descriptions alone
- [ ] Remediation steps are actionable by someone without prior context
- [ ] Escalation path is defined for when the runbook doesn't resolve it
- [ ] Runbook was updated after the most recent incident that used it
