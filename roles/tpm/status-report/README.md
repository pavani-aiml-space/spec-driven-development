# Status Report - quick guide

## What it's for
Keeps stakeholders accurately informed without making them dig for it, and surfaces problems early enough that they're still cheap to fix.

## How to trigger it
- Plain English: "write this week's status report for X" or "give me a status update on the Caregiver Access program"
- Name it directly: "use status-report to summarize progress"
- Slash command: `/status-report`
- No generator script for this one - it's written fresh each time from current progress, not scaffolded from a template
- Meant to be run on a regular cadence (weekly/biweekly/monthly), or any time status changes materially before the next scheduled update

## What you'll be asked for
- The program name and current reporting period
- Overall health: on track, at risk, or off track
- Progress compared to the plan/milestones (not just a list of activity)
- Any blockers, what's needed to unblock them, and from whom
- Any risks worth calling out honestly, even if they're not fully resolved yet

## What happens, step by step
1. Leads with the overall health signal first, before any details.
2. Reports progress against the plan/milestones, not just a list of what happened.
3. Calls out every blocker explicitly, with a concrete ask and who it's needed from.
4. States risk honestly - a report that's always green stops being trusted.
5. Keeps the whole thing scannable: bullet points, most important information first, readable in under a minute.

## What you get
A short, recurring update: overall health, progress vs. plan, blockers with asks, notable risks, next milestone.

## Works well with
Compares progress against `tpm-program-brief`'s milestones and pulls risk visibility from `tpm-risk-register`.
