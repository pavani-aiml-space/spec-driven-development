---
name: review
description: Use to review code or a pull request for correctness, quality, and adherence to standards before it merges. Covers self-review, peer code review, and PR review.
---

# Review

## Purpose
Catch correctness, quality, and consistency problems before code merges — a second (or first, self-applied) set of eyes distinct from the person who wrote it.

## When to use
- A unit of work has passed `test` and is ready to merge.
- A pull request is opened and needs review before approval.
- Before opening a PR, as a self-review pass.

## Process
1. **Understand intent first.** Know what the change is supposed to do (definition of done, linked requirement) before judging whether it does it.
2. **Check correctness.** Does the logic do what it claims? Are edge cases from `test` actually covered? Any silent failure modes?
3. **Check fit.** Does the change match existing conventions, avoid unnecessary abstraction, and stay within the scope it was supposed to cover (no drive-by scope creep)?
4. **Check maintainability.** Would someone unfamiliar with this change understand it in six months? Are non-obvious decisions explained (not over-commented)?
5. **Separate blocking from optional.** Distinguish "this must change before merge" from "consider this later" — don't block on nitpicks.
6. **Verify, don't just skim.** For anything uncertain, check it against the actual code/tests rather than assuming it's fine.

## Output
A findings list ranked by severity (blocking vs. optional), each with the concrete failure scenario it causes — not vague style preferences.

## Handoff
Blocking findings loop back to `build`/`debug`. Security-specific concerns are handed to `security-review` rather than judged here. Once clean, proceed to `refactor` (if warranted) or `log`/`closeout`.

## Checklist
- [ ] Change does what it claims to do, verified against tests/design
- [ ] No unrelated scope was folded into this change
- [ ] Findings are ranked by severity, not a flat list
- [ ] Each blocking finding states a concrete failure scenario
- [ ] Security-specific issues routed to `security-review`, not adjudicated here
