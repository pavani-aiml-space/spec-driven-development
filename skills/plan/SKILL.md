---
name: plan
description: Use after design is complete to break it into sequenced, right-sized units of work with dependencies and an execution order before build starts.
---

# Plan

## Purpose
Turn a design into an ordered set of implementable units of work, sized so each can be built, tested, and reviewed as a coherent whole — with dependencies made explicit so work can be sequenced or parallelized correctly.

## When to use
- A design exists and is ready to be turned into buildable work.
- A large unit of work needs to be re-broken-down because it turned out too big or its dependencies changed.

## Process
1. **Decompose.** Break the design into units of work. A unit should be small enough to build, test, and review in one focused pass, and large enough to deliver something coherent (not a single line of code).
2. **Sequence.** Identify dependencies between units — what must exist before another unit can start. Order units accordingly; flag units that can run in parallel.
3. **Size and flag risk.** For each unit, note relative size/effort and anything uncertain (unknowns, external dependencies, areas needing a `technical-spike`).
4. **Define done.** For each unit, state what "done" means in terms of the acceptance criteria from `concept` it satisfies.
5. **Sanity-check scope.** Confirm the sum of units covers all requirements from `concept`/`design` with nothing missing and nothing extra (gold-plating).

## Output
An ordered work plan: list of units with description, dependencies, sequencing/parallelization notes, size/risk flags, and a done-definition per unit.

## Handoff
Each unit feeds the `build` → `test` → `debug` → `review` → `security-review` → `refactor` loop. Re-enter `plan` if a unit turns out to be miscut once build starts.

## Checklist
- [ ] Every requirement from `concept`/`design` maps to at least one unit
- [ ] No unit exists that doesn't trace back to a requirement
- [ ] Dependencies between units are explicit
- [ ] Each unit has a stated definition of done
- [ ] High-uncertainty units are flagged, not silently treated as routine
