---
name: plan
description: Use after design is complete to break it into sequenced, right-sized units of work with dependencies and an execution order before build starts.
---

# Plan

## Purpose
Turn a design into an ordered set of implementable units of work, sized so each can be built, tested, and reviewed as a coherent whole, with dependencies made explicit so work can be sequenced or parallelized correctly. Plan decides *what order* and *what depends on what*; it does not decide *how* to build anything: that's `design`, which already happened by the time this stage starts.

## When to use
- A design exists and is ready to be turned into buildable work.
- A large unit of work needs to be re-broken-down because it turned out too big or its dependencies changed.

## Process
1. **Decompose with work-breakdown structuring.** Break the design into units of work small enough to build, test, and review in one focused pass, and large enough to deliver something coherent (not a single line of code). Group related units into phases or milestones based on real dependency, not convenience or the order they happened to be written. Rule of thumb for a unit: describable in one sentence, with one clear deliverable.
2. **Sequence.** Identify dependencies between units, what must exist before another unit can start. Order units accordingly; flag units that can run in parallel.
3. **Size and flag risk.** For each unit, note relative size/effort and anything uncertain (unknowns, external dependencies, areas needing a `technical-spike`). Flag risks per phase where relevant.
4. **Define done.** For each unit, state what "done" means in terms of the acceptance criteria from `concept`/`design` it satisfies.
5. **Map every requirement, in both directions.** Every requirement maps to at least one unit; every unit maps back to at least one requirement. A requirement with zero units mapped to it got dropped, go back and account for it. A unit that doesn't trace to a requirement is scope that snuck in.
6. **Watch for design decisions hiding as tasks.** If a unit implies a specific technology, library, or structural choice that wasn't already settled in `design`, that's a signal it belongs in `design`, not here; loop back rather than deciding it inline.
7. **Sanity-check scope.** Confirm the sum of units covers all requirements from `concept`/`design` with nothing missing and nothing extra (gold-plating).

### Common mistakes

| Mistake | Why it fails |
|---|---|
| Task sizes wildly inconsistent (one task = a whole subsystem, another = one line) | Makes review and progress tracking meaningless |
| A task is actually a design decision in disguise ("decide on folder structure") | Belongs in `design`, not `plan` |
| A requirement has zero tasks mapped to it | It got dropped, go back and account for it |
| Sequencing ignores real dependencies | Breaks the build order downstream |
| Phases defined by calendar time instead of dependency | Produces a schedule that looks plausible but doesn't reflect what actually blocks what |

## Output
An ordered work plan: list of units with description, dependencies, sequencing/parallelization notes, size/risk flags, and a done-definition per unit, with every unit mapped to the requirement ID(s) it satisfies.

## Handoff
Each unit feeds the `build` → `test` → `debug` → `review` → `security-review` → `refactor` loop. Run a `review`-style critical pass (see review/SKILL.md's Critical Review section) before treating the plan as approved. Re-enter `plan` if a unit turns out to be miscut once build starts.

## Checklist
- [ ] Every requirement from `concept`/`design` maps to at least one unit
- [ ] No unit exists that doesn't trace back to a requirement
- [ ] Dependencies between units are explicit
- [ ] Each unit has a stated definition of done
- [ ] High-uncertainty units are flagged, not silently treated as routine
- [ ] No unit is secretly a design decision in disguise
