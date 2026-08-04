# Decision Log - quick guide

## What it's for
The one running log per program for every decision and open question. Most decisions are **regular** - log them, decide them, done. Some are **contested** - real disagreement, no clear final say - those become a row on the program's shared **Contested Decisions** table (`tpm-contested-decisions`, **directly** if obviously contested from the start, or **gradually** if it sat here first and turned out stuck) and get linked back, never duplicated.

## How to trigger it
- Plain English: "log this decision," "we need to decide X eventually," or "record why we chose X over Y"
- Name it directly: "use decision-log to capture this"
- Slash command: `/decision-log`

## What you'll be asked for
- The question or decision, and today's date (to log it as Open the moment it surfaces)
- Once it resolves: whether it was regular or contested
- Regular: every option considered (including rejected ones), the decision, the rationale, the owner, the date, and reversibility (one-way vs. two-way door)
- Contested: nothing inline - just a link to the row on the program's Contested Decisions page

## What happens, step by step
1. Logs the question as Open the moment it surfaces - not once it's urgent.
2. Generates a starter log table if one doesn't exist for this program yet.
3. Once resolved, checks whether it was regular or contested.
4. Regular: fills in options considered, decision, rationale, owner, date, and reversibility directly in the row. Status → Decided.
5. Contested: points to (or adds a row on, scaffolding the page if needed) the program's Contested Decisions page instead, sets Status to "Contested - see Contested Decisions page," and does not duplicate that row's content here.
6. Links the row to related docs, and publishes to the program's Confluence space directly if one exists.

## What you get
One log: regular decisions fully recorded as rows; contested decisions as a status plus a link to their row on the Contested Decisions page.

## Examples
- **Regular**: "Which analytics library do we use?" - PM decides quickly, no disagreement. Logged inline: options considered, decision, rationale, owner, date. Done.
- **Contested, gradual**: "Should the caregiver feature require re-consent every 90 days?" - logged as Open, sits for a week, then Product and Legal turn out to disagree hard. Status updates to "Contested - see Contested Decisions page," a row gets added there, and that row becomes the record.
- **Contested, direct**: "Build or buy the search feature?" - raised for the first time already knowing Eng and Product will disagree. Skips the Open stage entirely; goes straight to a row on the Contested Decisions page.

## Works well with
- Feeds `tpm-contested-decisions`'s Contested Decisions table when a row turns out contested (or is added straight from an obviously-contested decision); receives a link back once that row resolves, not a duplicated record
- Links to `tpm-program-brief`, design docs, or ADRs
- If a Confluence space exists (`tpm-program-space`), this is the log scaffolded there - replaces the separate "Open Decisions & Questions" page
