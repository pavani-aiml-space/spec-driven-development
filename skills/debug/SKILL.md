---
name: debug
description: Use when behavior diverges from what's expected — a bug report, failing test, error, or "this works in one place but not another" — to find the root cause before fixing it.
---

# Debug

## Purpose
Find the actual root cause of a defect before changing anything, so the fix resolves the real problem instead of masking a symptom.

## When to use
- A test is failing and the cause isn't obvious.
- A bug report or error surfaces unexpected behavior.
- Something works in one environment/path but not another.

## Process
1. **Reproduce.** Get a reliable, minimal reproduction before doing anything else. If it can't be reproduced, gather more evidence (logs, inputs, environment) instead of guessing.
2. **Form a hypothesis.** State what you think is causing it and how you'd confirm or rule it out — don't jump straight to a fix.
3. **Isolate.** Narrow the reproduction down to the smallest case that still shows the bug (bisect: remove/change one variable at a time).
4. **Confirm root cause**, not just a correlated symptom. Ask "why" until the answer is a specific line/assumption/interaction, not "it's flaky."
5. **Fix at the root**, and write a regression test (see `test`) that fails before the fix and passes after.
6. **Check for siblings.** If this root cause could exist elsewhere (same pattern copy-pasted, same class of bug), check those spots too.

## Output
A confirmed root cause, a minimal fix, and a regression test — plus a note on any sibling instances checked.

## Handoff
Feeds back into `build`/`test` for the fix, then `review`. If the root cause is a design flaw, loop back to `design` rather than patching around it repeatedly.

## Checklist
- [ ] Bug was reliably reproduced (or evidence gathered if it couldn't be)
- [ ] Root cause is confirmed, not assumed or guessed
- [ ] Fix addresses the cause, not just the visible symptom
- [ ] A regression test exists that fails without the fix
- [ ] Codebase checked for the same bug pattern elsewhere
