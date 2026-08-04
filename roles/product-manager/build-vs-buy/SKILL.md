---
name: build-vs-buy
description: Use to decide whether a needed capability should be built in-house, bought from a vendor, or bought-and-extended, weighing true total cost of ownership and competitive differentiation, prepared as analysis, pressure-tested with stakeholders, and closed out as a logged decision, not a gut call.
---

# Build vs Buy

## Purpose
Decide, with evidence, whether a capability is worth building, buying, or buying-and-extending. Most of what a product needs isn't what makes it win, undifferentiated work that has to get done but doesn't set the product apart, and it's easy to let that consume most of a team's time and budget for a fraction of the value. The default should be buy; building is the exception that has to earn its keep. The analysis has to exist before stakeholders weigh in, or the review becomes the analysis, done live, under time pressure, by people who weren't asked to do it.

## When to use
- A new capability is needed and nobody has yet named whether it's worth building.
- A "let's just build it" or "let's just buy a tool" call is being made on gut feel, without a stated reason.
- An existing build or buy decision needs revisiting because a trigger condition (below) fired.

## Process

### Prepare
1. **Frame the capability, not a vendor or an approach.** Name the actual need ("we need to enrich lead data") before anyone proposes a tool or a build plan; naming the vendor first anchors the whole analysis on justifying that choice.
2. **Run the rapid filter.** Score each driver on a build/buy lean:

   | Driver | Build signal | Buy signal |
   |---|---|---|
   | Strategic importance | Core differentiator | Standard business function |
   | Time to market | Can absorb months | Need weeks |
   | TCO predictability | Long-term cost is manageable and known | Subscription is cheaper than build + maintain |
   | Team capacity | Deep relevant expertise, real bandwidth | Skills or bandwidth aren't there |

   A clean lean on most drivers settles it here. Mixed signals mean it's a real decision, keep going.
3. **Evaluate any driver that's genuinely unclear, don't guess.**

   | Driver | Ask | Risk if wrong | De-risk with |
   |---|---|---|---|
   | Strategic importance | Would this be genuinely better than alternatives, not just different? Is it why customers actually choose the product? Would removing it weaken the core offering? | Building something customers don't value enough to justify the cost, or that doesn't fit where the business is actually trying to win | Customer interviews for real signal over assumption; a smoke test, a landing page or a manually-delivered version of the capability, before committing engineering time |
   | Time to market | What's the real deadline, and what actually breaks if it's missed? Is the urgency externally imposed (a client commitment, a compliance date) or self-imposed? What's the cost of being late versus shipping something narrower, fast? | Underestimating how long a build actually takes, or rushing a buy integration without real validation | A pre-mortem, assume the timeline was blown and work backward to what caused it, before committing to build; a time-boxed spike for a real estimate instead of a guess |
   | TCO predictability | What's the full 3-5 year cost, including maintenance, not the sticker price? What's the true opportunity cost of the engineers involved? Does vendor pricing scale predictably with growth, or does it have a cliff? | The true build cost turning out far higher than estimated, or the economics not actually working at real scale | Side-by-side financial modeling, build vs. every buy option, 3-5 years; talking to other teams already using a candidate vendor about real implementation time and hidden costs, not just the pitch |
   | Team capacity | Does the team have the specific expertise this needs, not just general capability? What do they stop doing if they take this on? Is this one person who knows how, or a real team capability? | The team can't actually deliver what was promised, or ships it but can't support it without the surrounding process/ops capability to move fast | A technical assessment or prototype test with the actual team, not a hypothetical estimate; war-gaming what happens if the one person who understands it leaves |
4. **Pressure-test any build lean against the moat, not the ego.** A confident yes to most of these means build; anything else, reconsider:
   - Would this be genuinely, measurably better than existing alternatives, not just different?
   - Does it depend on data or integration only this team can uniquely provide?
   - Is this the actual reason customers choose the product, would removing it weaken the core offering?
   - Is vendor roadmap risk on this specific thing unacceptable, not just generically undesirable?
   - Could this become a platform others build on, not just an internal tool?
5. **Consider extend as a third path, not just build or buy.** Buying a platform and extending it via API or low-code is often cheaper than either pure option; don't force a binary where a hybrid (vendor owns the undifferentiated core, your team builds the differentiated layer on top) fits better.
6. **Cost every surviving option on true total cost of ownership, 3-5 years, not sticker price.** Build's real cost includes ongoing maintenance (commonly 60-80% of total build effort over its life), infrastructure/DevOps, security and compliance upkeep, and opportunity cost, what the same engineers would otherwise deliver, often the largest number and the easiest one to leave out. Buy's real cost includes scaling with usage/seats, migration and training, integration effort (budget it in sprints), and vendor lock-in risk. Check every number against these three traps:
   - Comparing salary to license fee instead of true opportunity cost, which can dwarf the license cost.
   - Assuming code ownership alone equals business value; a build without the surrounding ecosystem, support, data visibility, a process that can actually ship fast, wastes the flexibility it bought.
   - Assuming build avoids lock-in; a homegrown system accumulates its own technical debt and migration cost, sometimes worse than a vendor's.
7. **Score requirements against every surviving option**, must-haves and nice-to-haves, weighted, build included as one of the options, not the default nobody has to justify.
8. **Draft a lean recommendation with its trade-off stated**, before anyone outside prep sees it. This is what goes to review, a real position to react to, not a blank comparison for stakeholders to build from scratch.

### Review with stakeholders
9. **Take the draft to the right people, with the right question, not one open meeting.** Engineering: does the timeline/team/risk estimate hold up? Business: does this actually map to the goal it's meant to serve? Finance: does the opportunity-cost model hold up? If a buy path is live, security and legal: compliance posture, data handling, and contract terms, before a vendor is treated as chosen.
10. **Revise the recommendation based on what surfaces.** A credible objection from any one of these can flip the lean; that's the point of review, not a rubber stamp on the draft from prep.

### Post
11. **Write the decision to `decision-log`, not just this document.** If review surfaced no real disagreement, this is a regular decision, fill in that row directly, in `decision-log`'s own fields, not a paraphrase:
    - **Question:** the capability as framed in step 1.
    - **Options Considered:** every surviving option from step 6/7, including the ones not picked, build, each buy candidate, extend if it got this far; a winner with no rejected options listed isn't a real record.
    - **Decision:** the verdict from step 10.
    - **Rationale:** the trade-off from step 8/10, why this one, not just which one.
    - **Owner:** whoever had standing authority to decide, usually named during review in step 9.
    - **Date Decided:** today.
    - **Reversibility:** one-way door or two-way door, drawn straight from the lock-in and vendor-risk analysis already done in steps 4 and 6, not re-derived.

    If review surfaced real, unresolved disagreement instead, this is contested: don't fill in that row. Add it to the program's Contested Decisions page (`tpm-contested-decisions`) instead, and leave a stub in `decision-log` that links to it, exactly as `decision-log` itself specifies for a contested item. Either way, a hard-to-reverse (one-way door) call also becomes an `adr`; `decision-log` is the running record that a decision was made, `adr` is the durable *why* for the ones significant enough to need one, they're not substitutes for each other.
12. **Name the triggers that would reopen this decision.** The capability becomes strategically critical when it wasn't before; the vendor's roadmap stops meeting real needs; the cost balance flips as scale changes. A decision with no reopening condition quietly calcifies past the point it's still right.

## Output
A build-vs-buy recommendation: the capability framed independent of any vendor, the rapid-filter lean (with driver-level evaluation where it was unclear), a build lean's result against the moat checklist, whether extend was considered, true TCO for every surviving option, a requirements score, stakeholder input by role and how it changed the draft, the final recommendation with its stated trade-off, a `decision-log` row (or a stub pointing to a Contested Decisions entry), and reopening triggers. See [template.md](template.md) for a fully worked example.

## Handoff
A build decision feeds `concept` and `plan` like any other unit of work. A buy decision that involves a vendor connection feeds `integration-spec` for the technical contract, and `api-contract` if it's a REST integration specifically. Feeds `roadmap-prioritization` if the resulting work needs a slot this cycle. Every decision this skill produces gets written to `decision-log` (Options Considered, Decision, Rationale, Owner, Date Decided, Reversibility), regular or contested; a contested one graduates to `tpm-contested-decisions` instead of being filled in there directly. A hard-to-reverse call additionally becomes an `adr`.

## Checklist
- [ ] The capability was framed before any vendor or build approach was named
- [ ] The rapid filter was run first; any driver with a genuinely unclear lean was evaluated with its own questions, not guessed
- [ ] A build lean was pressure-tested against the moat checklist, not assumed
- [ ] Extend was genuinely considered, not just build vs. buy
- [ ] TCO for every surviving option covers maintenance, infra, opportunity cost (build) and scaling, migration, integration, lock-in (buy), checked against the three traps
- [ ] Requirements (must-have/nice-to-have) were scored against every surviving option, including build
- [ ] A draft recommendation with its trade-off existed before stakeholder review started
- [ ] Stakeholder input was gathered by role, with the question specific to that role, and it visibly shaped the final recommendation
- [ ] The `decision-log` row is filled in with Options Considered (including rejected ones), Decision, Rationale, Owner, Date Decided, and Reversibility, not a paraphrase in this document alone
- [ ] A contested outcome went to `tpm-contested-decisions` with a stub link in `decision-log`, not filled in there directly
- [ ] A hard-to-reverse call was also recorded as an `adr`
- [ ] Reopening triggers are named explicitly
