# Program Space - quick guide

## What it's for
Sets up a brand-new Confluence space for a program in one pass - a landing Home page, a content-rich Program Hub, and every artifact page (Brief, RACI, Risk Register, Stakeholder Map, Decision Log, Progress Log) pre-filled with starter content, instead of a blank space.

## What to expect from this skill
Claude publishes this directly through the Atlassian MCP connector - no terminal command, no personal API token to manage. That connector just needs to already be authorized (a one-time connection in Claude's settings; if it isn't, Claude will tell you). The one exception: creating the *empty space itself* isn't something the connector can do - either create it yourself in the Confluence UI (Spaces → Create space, ~30 seconds) and tell Claude the key, or use the legacy `scripts/create-space.sh` (curl + your own token) if you'd rather script that one step. Everything after the space exists, Claude does directly.

## How to trigger it
- Plain English: "create a program space for the Caregiver Access program" or "set up Confluence for X"
- Name it directly: "use tpm-program-space to scaffold this program"
- Slash command: `/tpm-program-space`

## What you'll be asked for
- Program name (required)
- A one-line tagline describing the program (optional)
- Sponsor's name (optional - defaults to "TBD")
- Program Manager's name (optional)
- Whether the program breaks down into distinct projects, and if so, their names (optional - only needed if there's more than one workstream underneath the program)
- A space key that isn't already in use, and confirmation the space exists (or exists yet to be created - see above)

## What happens, step by step
1. Asks you for the details it needs - name, tagline, sponsor, program manager, projects, space key - rather than guessing or inventing any of them.
2. Confirms with you before publishing anything - this creates real, visible pages in a shared space.
3. Checks the space exists; if not, asks you to create it first (Claude can't create the space itself).
4. Publishes a minimal Home page (title, tagline, a link to the Hub, quick links, contacts) by updating Confluence's auto-created homepage.
5. Creates each program-level doc first (Program Brief, Stakeholder Map, RACI, Risk Register, Decision Log, an empty Progress Log) - each from its own skill's generator - checking first whether a page with that title already exists, so nothing gets duplicated on a re-run.
6. Builds the Program Hub last, now that every child page's real link is known - no placeholder-link cleanup pass needed.
7. If there's more than one project, creates a Projects page, then each project's own page with its own scoped Brief/RACI/Risk Register underneath - kept separate from the program-level versions.

## What you get
A full Confluence space: Home, Program Hub, program-level docs, and (if applicable) a Projects section with each project's own scoped docs - all pre-filled as editable starter templates, not finished content.

## A few things worth knowing
- **This skill's job ends once the space is created.** Editing content afterward - a new risk, an ownership change - just means opening that page in Confluence directly, like any wiki page.
- **Adding a brand-new project later** (one that wasn't there at kickoff): re-run the same setup with the new project added, or ask Claude to create just that project's page and its scoped docs directly, without touching the existing ones.
- **Program level vs. project level:** put something on the shared program pages if it affects more than one project (a shared system, a shared team); put it on that project's own page if it only affects that one project. Getting this backwards is the most common mistake - it makes the space confusing to navigate later.
- **Table formatting**: headers get a light background and balanced column widths via `data-background`/`data-colwidth` - a real Confluence HTML+ feature, not CSS. If a table ever looks skewed (one column huge, others collapsed), that's `scripts/md-to-htmlplus.sh`'s width-balancing logic to check, not something to hand-fix on the page.

## Works well with
Pulls starter content from `tpm-program-brief`, `tpm-stakeholder-map`, `tpm-raci`, `tpm-risk-register`, and `decision-log` to fill the space. A contested decision that graduates out of the Decision Log becomes a row on the program's Contested Decisions page (`tpm-contested-decisions`), created the first time it's actually needed, not scaffolded at kickoff. Feeds anyone who needs a shareable link to the program's documentation - stakeholders, leadership, external reviewers.
