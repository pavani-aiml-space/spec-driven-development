---
name: build
description: Use to implement a planned unit of work against its design and definition of done. The core "write the code" step of the construction loop.
---

# Build

## Purpose
Implement a single unit of work from `plan`, matching the design's intent, without expanding scope or re-deciding things `design` already settled.

## When to use
- A unit of work from `plan` is next in sequence and its dependencies are satisfied.
- Implementing a fix or change whose design and scope are already agreed.

## Process
1. **Confirm inputs.** Reread the unit's definition of done and the relevant slice of the design. If either is missing or ambiguous, stop and resolve it in `plan`/`design` rather than guessing.
2. **Implement the smallest correct change.** Build only what the unit requires. Don't add abstractions, config options, or handling for cases the design didn't call for.
3. **Match existing conventions.** Follow the codebase's existing patterns, naming, and structure rather than introducing a new style.
4. **Keep it observable.** Make failure states legible (errors, logs) so `debug` and `review` don't have to reverse-engineer what happened.
5. **Self-check before handoff.** Re-read the diff against the unit's definition of done before moving to `test`.

## Output
Working code for the unit, matching its definition of done, ready for `test`.

## Handoff
Feeds `test`. If something in the design turns out to be wrong or infeasible while building, surface it rather than silently deviating — loop back to `design`/`plan`.

## Checklist
- [ ] Change satisfies the unit's stated definition of done, nothing more
- [ ] No scope was added beyond what `plan`/`design` specified
- [ ] Code follows existing conventions in the surrounding codebase
- [ ] Failure/error paths are visible, not swallowed
- [ ] Diff has been re-read against the definition of done
