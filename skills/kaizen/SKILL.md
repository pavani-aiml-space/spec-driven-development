---
name: kaizen
description: Use at closeout or between iterations to reflect on the cycle just completed and capture concrete process or codebase improvements for next time.
---

# Kaizen

## Purpose
Make sure every cycle through the lifecycle doesn't just finish — it leaves the codebase and the process a little better than it found them. Small, continuous improvement rather than periodic big rewrites.

## When to use
- As the last step of `closeout`, before considering a unit of work truly done.
- Between iterations, when friction was noticeable but not worth stopping mid-work to fix.

## Process
1. **Look for waste.** Dead code, redundant steps, unused dependencies introduced or exposed during this cycle — what can be removed?
2. **Look for inconsistency.** Naming, patterns, or conventions that drifted from the rest of the codebase during this cycle — worth reconciling now while context is fresh.
3. **Look for friction.** Did any tool call, process step, or manual task repeatedly cause trouble? That's a candidate to fix, automate, or document so it doesn't recur.
4. **Pick one improvement, not ten.** Identify the single highest-value, smallest-effort improvement and act on it (or explicitly schedule it) rather than listing many and doing none.
5. **Keep it atomic.** A kaizen improvement should be a small, independently verifiable change — not folded into unrelated work.

## Output
One concrete, applied (or explicitly scheduled) improvement to the code or process, plus a short note on what friction it addresses.

## Handoff
If the improvement is code, it goes through the normal `build`/`test`/`review` loop like any other change — kaizen identifies it, it doesn't bypass the process.

## Checklist
- [ ] At least one instance of waste, inconsistency, or friction was identified
- [ ] Exactly one improvement was chosen and either applied or explicitly scheduled
- [ ] The improvement is atomic and independently verifiable
- [ ] Applied improvements went through the normal build/test/review loop
