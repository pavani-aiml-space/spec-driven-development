---
name: debug
description: Use when behavior diverges from what's expected — a bug report, failing test, error, or "this works in one place but not another" — to find the root cause before fixing it.
---

# Debug

## Purpose
Find the actual root cause of a defect before changing anything, so the fix resolves the real problem instead of masking a symptom. Evidence over assertions: never guess, never patch symptoms, and never claim a fix works without fresh, verifiable evidence.

## When to use
- A test is failing and the cause isn't obvious.
- A bug report or error surfaces unexpected behavior.
- Something works in one environment/path but not another.

## Process
1. **Classify first.** Before investigating, decide which of four categories the failure actually is: a real product defect, a test defect (bad assertion, bad setup, wrong expectation), an environment or dependency problem, or flaky/non-deterministic execution. Each needs a different response — apply the steps below to whichever category it actually is, not to an assumed one.
2. **Reproduce.** Get a reliable, minimal reproduction before doing anything else. If it can't be reproduced, gather more evidence (logs, inputs, environment) instead of guessing.
3. **Form a hypothesis.** State what you think is causing it and how you'd confirm or rule it out — don't jump straight to a fix.
4. **Isolate.** Narrow the reproduction down to the smallest case that still shows the bug (bisect: remove/change one variable at a time).
5. **Confirm root cause**, not just a correlated symptom. Ask "why" until the answer is a specific line/assumption/interaction, not "it's flaky."
6. **Question the architecture, not just the code, once fixes start failing.** If three or more attempted fixes haven't resolved it, the problem is likely architectural, not a simple bug — stop and discuss rather than trying a fourth patch.
7. **Fix at the root**, and write a regression test (see `test`) that fails before the fix and passes after.
8. **Check for siblings.** If this root cause could exist elsewhere (same pattern copy-pasted, same class of bug), check those spots too.
9. **Verify rigorously before claiming done.** Identify what command or check actually proves this is fixed, run it in full, and read the real output (exit code, failure count) — don't claim success on "should work," "seems fixed," or "looks good." State the evidence.

## Output
A classified, confirmed root cause; a minimal fix addressing it; a regression test that fails without the fix and passes with it; a note on any sibling instances checked; and the evidence (command + output) that proves the fix actually works.

## Handoff
Feeds back into `build`/`test` for the fix, then `review`. If the root cause is a design flaw, loop back to `design` rather than patching around it repeatedly. If the fix reveals a process improvement worth capturing, note it for `kaizen`.

## Checklist
- [ ] Failure was classified (product defect / test defect / environment / flake) before investigating
- [ ] Bug was reliably reproduced (or evidence gathered if it couldn't be)
- [ ] Root cause is confirmed, not assumed or guessed
- [ ] If 3+ fixes failed, the architecture itself was questioned rather than attempting a 4th patch
- [ ] Fix addresses the cause, not just the visible symptom
- [ ] A regression test exists that fails without the fix and passes with it
- [ ] Codebase checked for the same bug pattern elsewhere
- [ ] Fix claimed done only with explicit evidence (command output), not an assertion that it "should work"

## Attribution
The classification step, the "question the architecture after 3 failed fixes" rule, and the rigorous-verification framing are adapted from a third-party MIT-licensed skill; see [ATTRIBUTION.md](../../ATTRIBUTION.md) at the repo root.
