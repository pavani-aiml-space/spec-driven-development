---
name: concept
description: Use at the start of a new initiative, feature, or product idea to turn a raw idea into a validated problem statement, target users, and requirements/user stories before any design or planning begins.
---

# Concept

## Purpose
Convert an unstructured idea into a shared, written understanding of *what problem is being solved, for whom, and why* — before anyone designs or builds anything. This is the single entry point for both greenfield ideas and new features on existing systems.

## When to use
- A new product, feature, or initiative is proposed and nothing is written down yet.
- Someone asks "should we build X?" or "what should we build for Y?"
- An existing idea needs to be re-validated because assumptions have changed.

## Process
1. **Frame the problem.** State the problem in one sentence: who has it, what it costs them, and how you know it's real (evidence, not opinion).
2. **Diverge.** Generate multiple candidate solutions or approaches — do not anchor on the first idea. Note trade-offs for each.
3. **Converge.** Pick a direction with an explicit rationale for why it beats the alternatives.
4. **Define users and value.** Name the primary user(s)/persona(s) and the value each gets. Reject scope that doesn't trace back to a named user.
5. **Write requirements.** Turn the direction into requirements at two levels:
   - **Functional requirements** — what the system must do.
   - **User stories** — "As a [user], I want [capability], so that [outcome]" with acceptance criteria per story.
6. **Flag unknowns.** List open questions, assumptions, and anything that needs validation before design starts. Do not silently resolve ambiguity — surface it.

## Output
A concept brief containing: problem statement, evidence, chosen direction + rejected alternatives, target user(s), functional requirements, user stories with acceptance criteria, and open questions.

## Handoff
Output feeds directly into `design`. Anything marked as an open question should be resolved or explicitly deferred before design starts.

## Checklist
- [ ] Problem statement is falsifiable (someone could show it's wrong)
- [ ] At least one alternative approach was considered and rejected with a reason
- [ ] Every requirement traces to a named user and a stated value
- [ ] Acceptance criteria exist for every user story
- [ ] Open questions are listed, not silently assumed away
