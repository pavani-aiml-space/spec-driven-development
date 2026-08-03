---
name: release
description: Use to ship completed and reviewed work — deployment steps, rollout strategy, and operational handoff — turning "done" into "delivered."
---

# Release

## Purpose
Move reviewed, tested work from "ready" to "live," with a rollout approach that limits blast radius and a clear rollback path if something goes wrong.

## When to use
- Work has passed `test`, `review`, and (where applicable) `security-review`, and is ready to ship.
- A scheduled release or deployment window is happening.

## Process
1. **Confirm readiness.** Verify all gating steps (`test`, `review`, `security-review`, QA sign-off where applicable) are actually complete — don't assume.
2. **Choose a rollout strategy** proportional to risk: full deploy for low-risk changes, staged/canary/feature-flagged rollout for higher-risk ones.
3. **Define rollback before deploying**, not after something breaks. Know exactly how to revert and how long that takes.
4. **Deploy.** Execute the release through the established pipeline/process; avoid manual, unrepeatable steps where an automated path exists.
5. **Verify in production.** Confirm the release actually behaves as expected post-deploy (smoke check, key metrics/logs) — don't assume deploy success equals correctness.
6. **Hand off operationally.** Make sure whoever is on call/support knows what shipped and how to diagnose it if it misbehaves (see `runbook`).

## Output
A deployed, verified release with a documented rollback plan and operational handoff.

## Handoff
Feeds `closeout`. If production verification finds a problem, route to `debug` immediately and consider rollback before further diagnosis.

## Checklist
- [ ] All gating steps confirmed complete before deploying, not assumed
- [ ] Rollout strategy matches the risk level of the change
- [ ] Rollback plan is defined before deployment, not improvised after
- [ ] Post-deploy verification actually happened, not just "deploy succeeded"
- [ ] On-call/support has what they need to diagnose issues in this release
