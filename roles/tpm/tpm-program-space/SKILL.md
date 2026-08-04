---
name: tpm-program-space
description: Use when a new program is assigned, to scaffold its entire Confluence space in one pass - a minimal Home, a content-rich Program Hub, and every artifact page pre-filled with each skill's own starter template, ready for the PM to edit rather than a blank page. Publishes directly via the Atlassian MCP connector, not a terminal command.
---

# Program Space

## Purpose
Give a program manager a fully scaffolded, editable Confluence space the moment a program is assigned - not finished content, starter templates - organized the way a real program actually works: a minimal landing Home, a content-rich Program Hub, and each project underneath with its own scoped docs.

## When to use
- PMLC **Mechanism setup** (`tpm-pdlc`) — stand up where work lives after Concept and Align.
- A new program needs its Confluence space set up.
- A program is expanding to cover multiple projects, each needing its own scoped ownership/risk tracking under the shared program-level view.

## One job
**Mechanism setup only:** Home, Hub, seeded registers/pages, links, and the checklist below (Jira/doc conventions). Do not invent status, contested rows, or replace `tpm-program-brief` / `tpm-raci` content — publish their outputs into the space.

## How this actually gets published
This skill publishes through the **Atlassian MCP connector directly** (`getAccessibleAtlassianResources`, `getConfluenceSpaces`, `getPagesInConfluenceSpace`, `getConfluencePage`, `createConfluencePage`, `updateConfluencePage`) - not a terminal command with a personal API token. That connector needs to already be authorized (a one-time connection in Claude's settings, done outside this skill); once it is, there's nothing else to configure.

**One real limitation**: this connector has no space-creation call. Creating the empty space itself still needs either (a) the user creating it in the Confluence UI directly (Spaces → Create space, ~30 seconds), or (b) the legacy `scripts/create-space.sh` (curl + personal token, see `config.env.example`) if they'd rather script it. Everything after the space exists is done directly, no terminal step required.

**Content format matters.** This connector's HTML+ dialect is *not* legacy XHTML storage format - `data-colwidth` and `data-background` on table cells, not `<colgroup>`/CSS classes (confirmed by reading a published page back: Confluence silently drops custom classes and `<colgroup>` on save). Always convert generated Markdown through `scripts/md-to-htmlplus.sh` before publishing - never author storage-format XHTML by hand and never reuse the retired `md-to-storage.sh`.

## The Program Hub structure
Every hub uses the same section order, so a stakeholder who has read one program's hub can read any other program's hub without relearning the layout. `scripts/generate-hub-template.sh` emits exactly this order; don't reorder or drop sections per program.

1. **Status** - RAG plus Timeline / Done / Watch / Known gap rows, then a **Blockers** table and an **Asks** table.
2. **RACI** - summary rows, link to the full one. Placed second on purpose: a reader needs to know who decides before anything else is actionable.
3. **Recent Activity** - dated, most recent first.
4. **Goals and OKRs** - six numbered parts: business goals (G1..Gn), program objective, north star, metric tree, phased OKRs, goal coverage check.
5. *(conditional)* **Program domain model** (`--model`) - the dimensions that cut across all phases rather than belonging to one.
6. **Go / No-Go Launch Criteria**
7. **Open Decisions** *(filtered)*
8. **Dependencies** - separate from Risks, always.
9. **Risks** *(filtered)*
10. *(conditional)* **Compliance and Security** (`--compliance`) - for regulated programs.
11. **Program Structure** - lanes and their projects, plus the critical path.
12. **Current Milestones** *(filtered)*
13. **Contacts and Escalation**
14. **Documents** - grouped Technical / Business and Strategy / Compliance and Risk / Process and Governance / Communications and Enablement.

### Rules that make the structure work
These are the parts a PM gets wrong when filling the template in, so hold them in review:

- **The hub is a map, not a source of truth.** Every section summarizes and links out to the artifact that owns it. When a number here disagrees with the register, the register wins and the hub is stale.
- **Filtered sections stay filtered.** Open Decisions, Risks, and Current Milestones surface only what needs attention now; the full list lives in the linked register. A hub that lists every risk becomes a second risk register nobody updates.
- **Blockers are plural and ranked.** Most programs have several. Mark which sit on the critical path, because treating four blockers as equally urgent tells the reader nothing about what to fix first. Timeline names only the driving constraint.
- **Every Ask needs a name, a date, and a consequence.** Missing any of the three makes it reporting rather than escalating. One Ask per blocker that needs someone outside the program.
- **Dependencies are not risks.** A risk might happen; a dependency is someone else's deliverable you're waiting on. Dependencies are where programs actually slip, so they get their own section.
- **Watch must differ from Blockers.** If an item appears in both, one of them is mislabeled.
- **Known gap is the row most hubs omit.** It's what stops an exec "discovering" a descope that was decided deliberately months earlier.
- **One north star, not five.** It's singular by definition. A five-row table under that heading is a dashboard, and the program will report whichever row looks best that month. The chosen metric should decompose into factors that different phases move, so it stays meaningful across the whole roadmap rather than only the current phase.
- **Market sizing is not a metric.** TAM and SAM are ceilings on the prize, not numbers a team moves; they belong in the business case. Same for revenue figures that are outcomes of the north star rather than drivers of it, which are KRs. Anything nobody can act on this quarter doesn't belong in the metric lists.
- **Every KR is tagged** with the business goal it moves, or as `ENABLER` (a precondition, not an outcome) or `GUARDRAIL` (a miss fails the phase regardless of the rest). An untagged KR usually turns out to be a delivery milestone in disguise.
- **KRs are outcomes; milestones live elsewhere.** Delivery belongs in Go/No-Go and Program Structure, so shipping a feature is never mistaken for moving a number.
- **Each phase needs its own Objective**, not just a segment name. If the objective reduces to "ship phase 2", the phase has no thesis and the KRs will read as an unmotivated metric list.
- **The goal coverage check is the honesty test.** A goal with no KR in any phase is either a missing KR or a goal that doesn't belong in section 1. State every deliberate gap in prose; an unexplained blank reads as an oversight, a stated one reads as sequencing.
- **Empty categories are deleted, not left as headers.** This applies to Documents groups and to conditional sections.

## Process
1. **Ask for the inputs before assuming or inventing any of them.** Program name is required. Tagline, sponsor, program manager, and project list are optional - ask the user for each rather than guessing; a genuinely unknown one can default to "TBD" (or be omitted for tagline/lead), but don't invent a name, scope, or project breakdown that wasn't given. Also confirm the Confluence space key to use - it must not collide with an existing space (check with `getConfluenceSpaces`). For the Hub specifically, also ask for the business goals, the phase breakdown with target dates, and the workstream lanes - these drive the OKR scaffolding and the coverage matrix, and inventing them produces a hub the PM has to rewrite rather than edit.
2. **Confirm before publishing anything** - this posts visible content to a shared space, so the user should see what's about to be created before it happens, not be told afterward.
3. **Make sure the space exists.** Call `getConfluenceSpaces` with the chosen key. If it doesn't exist yet, ask the user to create it (UI, or `create-space.sh` if they prefer) and confirm once done - don't attempt to create it yourself, the connector can't. Once it exists, the response includes `homepageId` directly - no need to guess a title.
4. **Publish the Space Home** by updating that homepage via `updateConfluencePage` - deliberately minimal (title, tagline, a link to the Hub, Quick Links, Space Contacts). Generate its Markdown with `scripts/generate-space-home.sh`, convert with `scripts/md-to-htmlplus.sh`.
5. **Create leaf pages before parent pages that link to them**, so nothing needs a placeholder-then-fixup pass:
   - Create the Program Hub as a child of Home (`createConfluencePage`, `parentId` = homepageId) using a placeholder body for now - its own content needs child links that don't exist yet.
   - Create each program-level doc as a child of the Hub, each from its own skill's generator (`tpm-program-brief`, `tpm-stakeholder-map`, `tpm-raci`, `tpm-risk-register`, `decision-log`), converted with `md-to-htmlplus.sh`. Before creating each, check `getPagesInConfluenceSpace` (filter by title) - if it already exists, `updateConfluencePage` instead of creating a duplicate.
   - Create an empty Progress Log as a child of the Hub.
   - Now that every child's real `webUrl` is known from its creation response, build the Hub's real content with those links filled in, and `updateConfluencePage` the Hub with it. Generate it with the full flag set so the OKR and structure scaffolding matches the program, not just its name:
     ```
     scripts/generate-hub-template.sh --title "<program>" --space-url "<space>" \
       --goal "<business goal>" ...        # repeatable, becomes G1..Gn
       --phase "<scope>|GA <date>" ...     # repeatable, drives phased OKRs + coverage matrix
       --lane "<workstream>" ...           # repeatable, becomes Lane A..N
       --project "<project>" ...           # repeatable
       --compliance                        # regulated programs only
       --model "<domain model title>"      # only when cross-cutting dimensions exist
     ```
   - Update Space Home with the Hub's real link the same way.
   - **Do not scaffold a Contested Decisions page at kickoff** - `tpm-contested-decisions`'s table only gets created the first time an actual contested decision arises (see that skill's Handoff). Reference it in the Hub's Key Documents list as "created once needed," not as a live link, until it exists.
   - If there's more than one project: create a Projects index page under the Hub, then for each project its own page with its own scoped Brief/RACI/Risk Register underneath - kept separate from the program-level versions, even when they cover overlapping ground.
6. **Decide program level vs. project level before publishing, not after.** Put a risk or decision at program level if it affects something shared (a common data model, a shared team, a cross-project dependency); at project level if it only affects that one project's own system. Getting this wrong is the most common mistake here - it makes the space confusing to navigate later. If a project already exists, this just means adding to *that project's own* Brief/RACI/Risk Register page, not creating anything new.
7. **Adding a project after kickoff**: repeat step 5's per-project pattern for just the new project - `getPagesInConfluenceSpace` first confirms nothing with that name already exists, so existing projects are never touched or duplicated.
8. **Re-running/updating is idempotent by construction**: because every create is preceded by a title check via `getPagesInConfluenceSpace`, running this again against an existing space updates pages in place rather than duplicating them - there's no separate registry file to keep in sync, the space itself is the source of truth.

## Output
A Confluence space with three tiers: Space Home, Program Hub, and program-level docs plus per-project docs underneath - all starting as editable templates, not finished content.

## Mechanism checklist (Confluence only — “where docs live”)
- [ ] Space Home + Program Hub published; Hub is a map (links out, registers win)
- [ ] Concept (and optional Brief), Stakeholder Map, RACI, Risk Register, Decision Log pages exist (from their skills)
- [ ] Contested Decisions referenced as “create when needed,” not fake-filled
- [ ] Doc taxonomy clear (Technical / Business / Compliance / Process / Comms as used)
- [ ] Placeholder Quick Link for tracker board (filled by `tpm-tooling-setup`)
- [ ] Placeholder for Spec-Driven `specs/` link when `tpm-sdd-bridge` runs

## Handoff
**PMLC phase:** Mechanism setup / Mechanisms (`tpm-pdlc`) — Confluence step; then `tpm-tooling-setup`, then optional `tpm-sdd-bridge`.
Hub remains the map through Delivery and Close.
Pulls starter content from `tpm-concept` / `tpm-program-brief`, `tpm-stakeholder-map`, `tpm-raci`, `tpm-risk-register`, and `decision-log` to fill the space. A contested decision that graduates out of the Decision Log becomes a row on the program's shared Contested Decisions page (`tpm-contested-decisions`), created the first time it's actually needed, not scaffolded at kickoff alongside the others. Recurring sponsor-facing bi-weekly editions under a Bi-weekly Stakeholder Updates index follow `tpm-biweekly-stakeholder-update` (decision table with Options / Proposed, demos as evidence). Feeds whoever needs a shareable link to the program's documentation (stakeholders, leadership, external reviewers).

## Checklist
- [ ] Space confirmed to exist (via `getConfluenceSpaces`) before any pages
- [ ] Space Home is minimal - not a duplicate of the Hub's content
- [ ] Hub uses the canonical section order, with nothing reordered or dropped per program
- [ ] Business goals, phases, and lanes came from the user, not invented, and were passed as flags so the OKR scaffolding matches the program
- [ ] Blockers table holds every blocker, ranked, with critical-path marked; Timeline names only the driving one
- [ ] Every Ask has a named person, a date, and a stated consequence
- [ ] Dependencies kept separate from Risks; Watch items differ from Blockers
- [ ] Every KR tagged with a goal, or as ENABLER/GUARDRAIL; no delivery milestones sitting in the KR tables
- [ ] Each phase has its own Objective, not just a segment name
- [ ] Goal coverage matrix has no unexplained blanks - every gap stated as a sequencing decision
- [ ] Filtered sections (Open Decisions, Risks, Current Milestones) surface only what needs attention, with the full register linked
- [ ] Conditional sections and empty Document categories deleted rather than left as empty headers
- [ ] Home page updated in place via `updateConfluencePage`, not created as a second page
- [ ] Program-level docs scaffolded from each skill's own generator, not hand-written
- [ ] Every table converted through `md-to-htmlplus.sh` - never legacy storage format, never `data-background`/`data-colwidth` omitted from header cells
- [ ] Program-level and project-level docs kept separate, not mixed
- [ ] Leaf pages created before parent pages that link to them, so no placeholder links were left unresolved
- [ ] Each page checked via `getPagesInConfluenceSpace` before creating, to avoid duplicates on a re-run
- [ ] Contested Decisions page not scaffolded at kickoff - only created once a real contested decision needs it
- [ ] User confirmed before publishing
