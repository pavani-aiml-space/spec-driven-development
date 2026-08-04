---
name: concept
description: Use at the start of a new initiative, feature, or product idea to turn a raw idea into a validated problem statement, target users, and requirements/user stories before any design or planning begins.
---

# Concept

## Purpose
Convert an unstructured idea into a shared, written understanding of *what problem is being solved, for whom, and why* before anyone designs or builds anything. This is the single entry point for both greenfield ideas and new features on existing systems.

## When to use
- A new product, feature, or initiative is proposed and nothing is written down yet.
- Someone asks "should we build X?" or "what should we build for Y?"
- An existing idea needs to be re-validated because assumptions have changed.

## Process
1. **Frame the problem.** State the problem in one sentence: who has it, what it costs them, and how you know it's real (evidence, not opinion).
2. **Explore with Socratic Discovery.** The point of this stage is to find what you don't know, not to produce a polished document. An unasked question is a hidden assumption: ask, don't assert.
   - Read the source material first; don't ask what's already answered there.
   - Ask in small batches, leading with whatever is most foundational or blocking, the questions whose answers change the most downstream.
   - Justify each question: if you can't say what changes based on the answer, don't ask it.
   - Track status per question: Open / Answered / Deferred. An answer isn't done until its downstream implications are noted.
   - Let answers branch: a real dialogue produces new questions from tensions or contradictions with prior material; add them rather than treating the original list as fixed.
   - Stop when foundational questions are answered or deferred, not when you run out of things to ask.
3. **Widen the lens on hard or novel problems.** Socratic questioning surfaces hidden assumptions by asking directly: that's one lens, and it only ever finds the kind of gap it's built to find. For a small, well-scoped question, Socratic Discovery alone is enough. For a hard or novel problem, run a short sequence of complementary mental models first:

   | Lens | Finds | Best for |
   |---|---|---|
   | Jobs To Be Done | What's actually being hired to do a job, reframed as an outcome | Product/strategy framing |
   | First Principles | Whether the current approach is even the right shape | Avoiding inherited assumptions, novel problems |
   | Systems Thinking | Where a bottleneck really lives, among interacting parts | Multi-stakeholder, multi-component problems |
   | Five Whys | The actual root cause behind a stated problem | Operational/process investigations |
   | Inversion | Failure modes, by designing the worst version on purpose, then doing the opposite | Risk review, design review |
   | Design Thinking | User pain, through empathy before ideation | User-centric products with a direct end user |
   | TRIZ | A way to satisfy a tradeoff instead of just accepting it | Two requirements that seem to conflict |
   | Scientific Method | A testable, falsifiable claim instead of an unproven assertion | Validating the riskiest assumption before committing |

   Recommended default sequence: Jobs To Be Done → First Principles → Systems Thinking → Socratic Questioning (step 2, now that the shape is clearer) → Inversion → Scientific Method. Running every lens on every question turns discovery into a research project; most problems need one or two lenses, not all of them. Picking the lens that confirms what you already believed defeats the purpose.
4. **Diverge.** Generate multiple candidate solutions or approaches; do not anchor on the first idea. Note trade-offs for each.
5. **Converge.** Pick a direction with an explicit rationale for why it beats the alternatives.
6. **Define users and value.** Name the primary user(s)/persona(s) and the value each gets. Reject scope that doesn't trace back to a named user.
7. **Write verifiable requirements.** A requirement isn't done when it has a Given/When/Then block attached; it's done when someone who wasn't in the room could verify it without asking what you meant. If it can't fail, it's not a requirement, it's a wish. Every requirement must be:
   - **Necessary**: traces to a real discovery finding or initiative outcome, not invented to fill a template.
   - **Unambiguous**: one reasonable reading, not several.
   - **Singular**: one outcome. If the sentence needs "and" to join two independently verifiable things, it's two requirements.
   - **Feasible**: achievable within known constraints, not aspirational.
   - **Verifiable**: someone can actually check it, with a defined method.
   - **Traceable**: links back to the question, decision, or initiative outcome that produced it.

   Structure each requirement with a plain-language title, one or two sentences of context, **Given/When/Then**, **Done when** (concrete checkable items), and **How to check** (self-contained, numbered steps someone could actually go do, never a pointer to another requirement). Turn requirements into functional requirements (what the system must do) and user stories ("As a [user], I want [capability], so that [outcome]") with acceptance criteria per story.
8. **Flag unknowns.** List open questions, assumptions, and anything that needs validation before design starts. Do not silently resolve ambiguity: surface it, and get every deferred item and open question an actual answer from a human before moving on, rather than just parking it in the document.

## Output
A concept brief containing: the discovery record (questions asked, status, downstream implications), problem statement with evidence, chosen direction + rejected alternatives, target user(s), verifiable requirements with Given/When/Then and traceability, user stories with acceptance criteria, and open questions.

## Handoff
Output feeds directly into `design` (with `plan` sequencing the work in between, per this pack's lifecycle). Run a `review`-style critical pass (see review/SKILL.md's Critical Review section) before treating the concept brief as approved; requirements are expensive to get wrong once design and plan build on them. Anything marked as an open question should be resolved or explicitly deferred before design starts.

## Checklist
- [ ] Problem statement is falsifiable (someone could show it's wrong)
- [ ] At least one alternative approach was considered and rejected with a reason
- [ ] Every open question has a stated reason it matters, and is marked Open / Answered / Deferred
- [ ] For hard/novel problems, more than one discovery lens was applied, not just the first one reached for
- [ ] Every requirement is necessary, unambiguous, singular, feasible, verifiable, and traceable
- [ ] Every requirement traces to a named user and a stated value
- [ ] Acceptance criteria exist for every user story
- [ ] Every "How to check" is a self-contained numbered action, not a reference to another requirement's ID
- [ ] Open questions are listed, not silently assumed away
