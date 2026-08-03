---
name: kaizen
description: Use at closeout or between iterations to reflect on the cycle just completed and capture concrete process or codebase improvements for next time.
---

# Kaizen

## Purpose
Make sure every cycle through the lifecycle doesn't just finish — it leaves the codebase and the process a little better than it found them. Small, continuous improvement rather than periodic big rewrites. The goal is less total code and documentation in the final result, not less to write right now: writing 50 lines that delete 200 is a net win; keeping 14 functions to avoid writing 2 is a net loss.

## When to use
- As the last step of `closeout`, before considering a unit of work truly done.
- Between iterations, when friction was noticeable but not worth stopping mid-work to fix.

## Process

### The 3Ms of waste
1. **Muda (waste).** Dead code, redundant steps, unused dependencies introduced or exposed during this cycle — what can be removed?
2. **Mura (inconsistency).** Naming, patterns, or conventions that drifted from the rest of the codebase during this cycle — worth reconciling now while context is fresh.
3. **Muri (overburden).** Over-complex functions, over-built abstractions, or logic that "smells" — what's carrying more weight than the problem actually requires?

### Process refinement
- Did a tool call or process step fail or cause friction repeatedly? That's a candidate to fix, automate, or document so it doesn't recur.

### Reducing entropy
Core question: what does the codebase look like *after*?
1. What's the smallest codebase that solves this — not the smallest change, the smallest result?
2. Does the change result in less total code? Count lines before and after; if after is greater, reconsider.
3. What can be deleted? Every change is a chance to remove something obsolete.

Red flags to watch for in your own reasoning: "keep what exists" (status quo bias), "this adds flexibility" (YAGNI — flexibility not asked for isn't free), "better separation of concerns" (separation isn't free either, it costs lines).

### Artifact management
Refactor bloated agent instruction files (SKILL.md, CLAUDE.md, or similar) to follow progressive disclosure: essentials at the root, the rest organized into linked, categorized files. Trigger this when an instruction file exceeds roughly 500 lines, contains contradictions, or has become hard to navigate. Analyze for contradictions and redundancy, extract what must stay in the root, categorize the rest, build the file hierarchy, and flag vague or obsolete instructions for deletion.

### Implementing improvements
1. **Pick one improvement, not ten.** Identify the single highest-value, smallest-effort improvement and act on it (or explicitly schedule it) rather than listing many and doing none.
2. **Keep it atomic.** A kaizen improvement should be a small, independently verifiable change ("refactor `auth.ts` to use a helper," not "rewrite the auth system") — not folded into unrelated work.

## Output
One concrete, applied (or explicitly scheduled) improvement to the code or process, plus a short note on what friction or waste it addresses, and whether net lines of code went down.

## Handoff
If the improvement is code, it goes through the normal `build`/`test`/`review` loop like any other change — kaizen identifies it, it doesn't bypass the process. Feeds the next `concept`, whether that's a new initiative or the next iteration of this one.

## Checklist
- [ ] At least one instance of Muda, Mura, or Muri was identified
- [ ] Process friction was documented with a proposed or implemented mitigation
- [ ] Exactly one improvement was chosen and either applied or explicitly scheduled
- [ ] The improvement is atomic and independently verifiable
- [ ] Net lines of code (or documentation) went down, or there's a stated reason it didn't
- [ ] Applied improvements went through the normal build/test/review loop

## Attribution
The 3Ms framing, entropy-reduction questions, and artifact-management guidance are adapted from a third-party MIT-licensed skill; see [ATTRIBUTION.md](../../ATTRIBUTION.md) at the repo root.
