---
name: test
description: Use to write and run tests that validate a built unit of work against its acceptance criteria, including test-first/TDD workflows. Covers unit, integration, and end-to-end verification.
---

# Test

## Purpose
Verify that a unit of work actually does what its acceptance criteria and design say it should — and give future changes a safety net.

## When to use
- After `build` produces a change, before it goes to `review`.
- Before `build`, when working test-first (write the failing test, then build to pass it).
- When a defect is fixed via `debug` and needs a regression test.

## Process
1. **Identify what must be true.** Pull the acceptance criteria from `concept`/`plan` for this unit — those are the tests that matter most.
2. **Choose the right level.** Prefer the cheapest test that still catches real breakage: unit tests for logic, integration tests for component boundaries, end-to-end only for critical user-facing flows.
3. **Write tests that fail for the right reason.** A test should fail when the behavior is actually wrong, not because of incidental setup or ordering. Avoid mocking so heavily that the test stops proving anything real.
4. **Test-first when uncertainty is high.** For tricky logic or bug fixes, write the failing test before the fix — it proves the bug existed and proves the fix works.
5. **Run the full relevant suite**, not just the new tests, to catch regressions elsewhere.
6. **Cover the edges**, not just the happy path: empty/null input, boundary values, concurrent/error conditions relevant to the design's NFRs.

## Output
A passing test suite covering the unit's acceptance criteria, committed alongside the code it verifies.

## Handoff
Feeds `review`. If tests reveal the design itself is wrong, loop back to `design`; if they reveal a bug, hand off to `debug`.

## Checklist
- [ ] Every acceptance criterion for the unit has a corresponding test
- [ ] Tests fail when behavior is wrong and pass when it's right (verified both ways)
- [ ] Edge cases and error paths are covered, not just the happy path
- [ ] Full relevant suite passes, not just new tests
- [ ] No test mocks away the exact thing it's supposed to verify
