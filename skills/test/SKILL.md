---
name: test
description: Use to write and run tests that validate a built unit of work against its acceptance criteria, including strict test-first/TDD workflows and end-to-end scenario sensitivity checks. Covers unit, integration, and end-to-end verification.
---

# Test

## Purpose
Verify that a unit of work actually does what its acceptance criteria and design say it should, and give future changes a safety net.

## When to use
- After `build` produces a change, before it goes to `review`.
- Before `build`, when working test-first (write the failing test, then build to pass it); see Test-Driven Development below.
- When a defect is fixed via `debug` and needs a regression test.
- Authoring or reviewing an automated end-to-end scenario, before trusting that it passing means the behavior is correct; see Verifying Scenario Sensitivity below.

## Process
1. **Identify what must be true.** Pull the acceptance criteria from `concept`/`plan` for this unit, those are the tests that matter most.
2. **Choose the right level.** Prefer the cheapest test that still catches real breakage: unit tests for logic, integration tests for component boundaries, end-to-end only for critical user-facing flows.
3. **Write tests that fail for the right reason.** A test should fail when the behavior is actually wrong, not because of incidental setup or ordering. Avoid mocking so heavily that the test stops proving anything real.
4. **Test-first when uncertainty is high.** For tricky logic or bug fixes, write the failing test before the fix; it proves the bug existed and proves the fix works. See Test-Driven Development for the strict version of this discipline.
5. **Run the full relevant suite**, not just the new tests, to catch regressions elsewhere.
6. **Cover the edges**, not just the happy path: empty/null input, boundary values, concurrent/error conditions relevant to the design's NFRs.

### Test-Driven Development (TDD)

Write the test first. Watch it fail. Write minimal code to pass. If you didn't watch the test fail, you don't know if it tests the right thing, a test that passes immediately proves nothing: it might test the wrong thing, might test implementation instead of behavior, and you never saw it actually catch anything.

**The Iron Law:** no production code without a failing test first. Wrote code before the test? Delete it. Don't keep it "as reference" or adapt it while writing tests after the fact. Implement fresh from the test.

**RED → GREEN → REFACTOR:**
1. **RED.** Write one minimal test showing what should happen: one behavior, a clear name, real code rather than a mock of the thing under test. Run it. Confirm it fails, and fails for the right reason (missing/wrong behavior, not a typo or setup error). If it passes immediately, it's testing existing behavior, not new. Fix the test.
2. **GREEN.** Write the simplest code that passes the test. Don't add features, refactor unrelated code, or "improve" beyond what the test asks for. Run it. Confirm it passes and nothing else broke.
3. **REFACTOR.** Only once green: remove duplication, improve names, extract helpers. Keep tests green. Don't add behavior here.
4. Repeat for the next failing test.

A bug found later is a failing test written first, reproducing it, then the same cycle. Never fix a bug without a regression test proving it existed and proving the fix.

**Common rationalizations, and why they don't hold:**

| Excuse | Reality |
|---|---|
| "Too simple to test" / "I'll test after" | Simple code breaks too; tests written after a pass prove nothing since they never demonstrated a failure |
| "I already manually tested it" | Ad hoc, no record, can't re-run, easy to forget cases under pressure |
| "Deleting this work is wasteful" | Sunk cost fallacy, keeping code you can't trust is the actual waste |
| "Tests after achieve the same goal, it's spirit not ritual" | Tests-after answer "what does this do," tests-first answer "what should this do", they're biased by the implementation that already exists |
| "TDD will slow me down" | Debugging an unverified change in production is slower than writing the test first |

Exceptions worth naming explicitly rather than silently skipping: throwaway prototypes, generated code, configuration files. Everything else (new features, bug fixes, refactoring, behavior changes) goes through the cycle.

### Verifying Scenario Sensitivity

The end-to-end-specific sibling of TDD above. A scenario that has never been seen to fail hasn't been verified; it might just be unable to fail. A scenario that always passes is worse than no scenario at all, because it looks like coverage while proving nothing.

**RED.** Run the new scenario against a state where the expected behavior is known to be broken or absent: a bug repro, an unfixed defect, a deliberately reverted change, or a fault-injected build. Confirm it fails, and fails for the right reason: the assertion catching the missing/broken behavior, not a setup error, a bad selector, or an environment problem.

**GREEN.** Run the same scenario against the correct, expected state. Confirm it passes.

Only after both steps: trust the scenario as real coverage. A scenario that's only ever been run once, against a passing build, hasn't earned that trust yet.

**When RED isn't practical:** fall back to inspecting the assertion directly: could this assertion still pass even if the feature were broken? If yes, the assertion is too weak; strengthen it before trusting the scenario, even without a live RED run. An assertion that only checks "the page didn't crash" or "the element exists" would pass on almost any state, broken or not. That's the most common way a scenario ends up unable to fail.

## Output
A passing test suite covering the unit's acceptance criteria, committed alongside the code it verifies. For TDD work, evidence that each test was watched to fail before the code existed. For end-to-end scenarios, evidence of both a RED run (against known-broken state) and a GREEN run (against correct state).

## Handoff
Feeds `review`. If tests reveal the design itself is wrong, loop back to `design`; if they reveal a bug, hand off to `debug`, and see `debug`'s classification step for whether a failure is a real defect, a test defect, an environment problem, or a flake.

## Checklist
- [ ] Every acceptance criterion for the unit has a corresponding test
- [ ] Tests fail when behavior is wrong and pass when it's right (verified both ways)
- [ ] Edge cases and error paths are covered, not just the happy path
- [ ] Full relevant suite passes, not just new tests
- [ ] No test mocks away the exact thing it's supposed to verify
- [ ] For TDD work: every test was watched to fail, for the right reason, before the code that makes it pass existed
- [ ] For end-to-end scenarios: a RED run (against known-broken state) and a GREEN run are both recorded as evidence
