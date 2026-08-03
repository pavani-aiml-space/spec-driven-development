---
name: review
description: Use to review code or a pull request for correctness, quality, and adherence to standards before it merges, and (via Critical Review) to critique a requirement, plan, or design decision before it's approved.
---

# Review

## Purpose
Catch correctness, quality, and consistency problems before code merges — a second (or first, self-applied) set of eyes distinct from the person who wrote it. The same discipline, applied earlier in the lifecycle as **Critical Review**, checks whether a *decision* (not code) is actually good before it's approved and other stages start building on it.

## When to use
- A unit of work has passed `test` and is ready to merge.
- A pull request is opened and needs review before approval.
- Before opening a PR, as a self-review pass.
- Before presenting a requirement (`concept`), plan (`plan`), or design decision (`design`) for approval — use Critical Review (below).

## Process

### Code review
1. **Understand intent first.** Know what the change is supposed to do (definition of done, linked requirement) before judging whether it does it.
2. **Check correctness.** Does the logic do what it claims? Are edge cases from `test` actually covered? Any silent failure modes?
3. **Check fit.** Does the change match existing conventions, avoid unnecessary abstraction, and stay within the scope it was supposed to cover (no drive-by scope creep)?
4. **Check maintainability.** Would someone unfamiliar with this change understand it in six months? Are non-obvious decisions explained (not over-commented)?
5. **Separate blocking from optional.** Distinguish "this must change before merge" from "consider this later" — don't block on nitpicks.
6. **Verify, don't just skim.** For anything uncertain, check it against the actual code/tests rather than assuming it's fine.

### Critical Review (for requirements, plans, and design decisions)
Self-review catches placeholders, contradictions, and format gaps — whether an artifact follows its own rules. Critical Review is different: it checks whether the *decision itself* is good, the way a principal engineer or tech lead would in a real review. A critique without evidence is just an opinion; every concern raised must point to something concrete, not a vague "this doesn't feel right."

Use judgment about where it pays off most, not a checklist that fires everywhere:
- **High value:** requirements (`concept`), `plan`, `design`. Decisions here are expensive to unwind once build starts.
- **Lower value, still worth a light pass:** early concept/discovery findings — still fluid, but a critique can catch confirmation bias in what got asked or answered.
- **Usually redundant:** `build`, `test`, `debug`, `kaizen` — these already have dedicated skills providing stage-specific rigor.

1. Read the artifact as if seeing it for the first time, not as the person who just wrote it.
2. Look specifically for:
   - A decision justified by "it's common," "it's simple," "it's clean," or similar, with no requirement, risk, or concrete scenario backing it.
   - A hidden assumption stated as settled fact.
   - Scope that quietly grew past what was actually approved upstream.
   - A tradeoff the initiative explicitly cares about that got traded away without saying so.
   - A claim of correctness with no evidence behind it.
3. For each concern found, state three things: what the problem is, why it matters (the evidence), and what would resolve it.
4. Separate **blocking** concerns (must be resolved before this goes to approval) from **non-blocking** observations.
5. Fix what's unambiguously correct to fix. Surface what's genuinely uncertain to the human rather than silently deciding it yourself.
6. Record what the critique found and what changed as a result — don't edit silently. If the finding reveals an upstream stage's output was wrong, treat that as drift: update the upstream artifact itself, not just the current one, and check any already-approved downstream artifacts for the same staleness.

Critiquing wording or style instead of substance isn't what this is for (self-review already covers format). A concern with no evidence behind it — "I would have done it differently" — isn't a critique on its own. Treating every observation as blocking buries the real concerns and stalls approval on non-issues. A critique needs a conclusion: flag it, resolve or defer it, move on.

## Output
A findings list ranked by severity (blocking vs. optional), each with the concrete failure scenario it causes or the evidence behind it — not vague style preferences or unsupported opinions.

## Handoff
**Code review:** Blocking findings loop back to `build`/`debug`. Security-specific concerns are handed to `security-review` rather than judged here. Once clean, proceed to `refactor` (if warranted) or `log`/`closeout`.

**Critical Review:** Feeds back into whichever stage invoked it (`concept`, `plan`, or `design`), immediately before that stage's human approval step.

## Checklist
- [ ] Change does what it claims to do, verified against tests/design
- [ ] No unrelated scope was folded into this change
- [ ] Findings are ranked by severity, not a flat list
- [ ] Each blocking finding states a concrete failure scenario or piece of evidence, not an opinion
- [ ] Security-specific issues routed to `security-review`, not adjudicated here
- [ ] For Critical Review: every concern names the problem, the evidence, and what would resolve it
- [ ] For Critical Review: any upstream drift found was fixed at the source, not patched around downstream
