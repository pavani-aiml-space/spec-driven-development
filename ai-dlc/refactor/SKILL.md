---
name: refactor
description: Use to improve the structure, clarity, or efficiency of existing code without changing its external behavior, distinct from adding new functionality.
---

# Refactor

## Purpose
Improve code that already works (structure, clarity, duplication, efficiency) without changing what it does. Refactoring is a deliberate, scoped action, not a side effect of an unrelated change.

## When to use
- `review` or `kaizen` surfaces a specific structural or quality issue worth fixing.
- Code needs to change shape before a new `build` unit can be added cleanly.
- Duplication, dead code, or an outdated pattern is found in passing.

## Process
1. **Establish a safety net first.** Confirm tests exist and pass before touching the code (see `test`). Refactoring without coverage is a rewrite in disguise.
2. **Scope it.** Define exactly what's being improved and why (e.g., "collapse duplicated validation logic in X and Y"). Don't let a scoped refactor drift into a rewrite.
3. **Change structure, not behavior.** Every step should be verifiable as behavior-preserving. If behavior needs to change, that's `build`, not `refactor`.
4. **Prefer deletion.** The best refactor often removes code rather than reorganizing it. Ask what can be deleted before asking what can be restructured.
5. **Re-run tests after every meaningful step**, not just at the end, so a regression is caught immediately and is easy to attribute.

## Output
Structurally improved code with identical external behavior, verified by the existing (or strengthened) test suite.

## Handoff
Feeds `review` like any other change. If a refactor reveals a real bug, hand off to `debug` rather than fixing it silently inside the refactor.

## Checklist
- [ ] Tests existed and passed before the refactor started
- [ ] Scope was defined up front and not exceeded
- [ ] External behavior is unchanged, verified by tests
- [ ] Net result is simpler/smaller, not just differently organized
- [ ] Any bug found along the way was routed to `debug`, not silently patched
