---
name: technical-spike
description: Use when there's too much technical uncertainty to plan or estimate confidently, a time-boxed investigation or prototype to answer a specific question before committing to an approach.
---

# Technical Spike

## Purpose
Reduce uncertainty about feasibility, approach, or effort *before* committing real implementation time to it: a deliberately time-boxed, throwaway-friendly investigation, not the start of the real build.

## When to use
- `plan` flags a unit of work as high-uncertainty and it can't be sized confidently.
- It's genuinely unclear whether an approach from `design` is technically feasible.
- Evaluating a new library, service, or pattern before committing to it.

## Process
1. **Write the question, not the task.** A spike exists to answer a specific question ("can X handle Y load," "does this API support Z"), if there's no clear question, it's not a spike; it's just building.
2. **Time-box it up front.** Set a fixed, short duration before starting. When time is up, stop and report findings; don't let a spike quietly become the real implementation.
3. **Optimize for learning, not quality.** Spike code can be rough, hardcoded, and disposable. Polish is wasted effort here.
4. **Answer the question explicitly.** The output is a clear yes/no/it-depends with evidence, not just leftover code.
5. **Feed the answer back.** Findings go back into `design`/`plan` to make the real approach and sizing decision; the spike itself is not the deliverable.
6. **Discard or clearly flag spike code.** If any of it is kept, it needs to go through `build`/`test`/`review` properly; spike code doesn't ship as-is.

## Output
A specific answer to the spike's question, with supporting evidence, feeding back into `design` or `plan`.

## Handoff
Resolves an uncertainty flagged in `plan`; may send the work back to `design` if the answer changes the approach.

## Checklist
- [ ] Spike had one specific question to answer, defined before starting
- [ ] Time-box was set in advance and respected
- [ ] Output is an explicit answer with evidence, not just leftover code
- [ ] Findings were fed back into design/plan, not left implicit
- [ ] Any kept code was routed through the normal build/test/review process
