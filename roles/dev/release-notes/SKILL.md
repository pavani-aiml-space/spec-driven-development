---
name: release-notes
description: Use when preparing production release notes - diff merged PRs since the previous release, summarize them by theme, and publish a dated entry to the wiki.
---

# Release Notes

## Purpose
Turn a batch of merged PRs going into a production release into a single, user-facing release-notes document - grouped by theme, explaining impact rather than restating diffs - so stakeholders get a readable record of what shipped, without someone hand-summarizing dozens of PRs from scratch each time.

## When to use
- A promote PR (release branch into main) exists - open or already merged - and a production rollout is happening or just happened.
- A dated release-notes entry needs to go into the team wiki as part of that rollout.

## Process
1. **Identify the diff range.** Run `scripts/diff-prs.sh` (defaults to `--base main --head staging`, override if your branch names differ) to find the existing promote PR and pull its file-level diff stats plus every constituent PR's title/body. It picks the most recently created matching PR automatically; if a newer promote PR already exists for the next cycle before these notes are written, pass `--pr <number>` to pin the exact one.
2. **Review that output - including PRs that look like internal `develop`/`staging` promotion merges.** A title like "develop → staging" or "Push X to staging" is not proof the PR is redundant - its body often contains real functional detail (new capabilities, behavior changes) that never surfaces as its own commit-referenced PR. Read every constituent PR's body before deciding it's noise; fall back to the file-level diff stats only where a PR's description is thin or missing.
3. **Group the PRs by theme/category** (e.g. "Styling," "Responsive Design," "Partner Landing Pages") rather than by PR number or merge order.
4. **Draft two versions of the release doc**:
   - **Technical**: an overall summary, then themed sections (grouped by engineering area), each written in user-facing language - what pain point it fixes or what capability it adds, not just a restated diff. Link each item to its source PR(s).
   - **Plain-language** (for non-engineering audiences - customer care, support, sales): reorder by customer impact rather than engineering area; lead with anything support will get asked about (behavior changes, regressions introduced-then-fixed within the same release). Phrase every item as the now-true resolved outcome, not a repeated "Fixed X" - a wall of "Fixed"/"Fix" reads like a bug tracker dump, not notes written for a person. Still link each item back to its source PR(s), so support can hand engineering the exact reference when escalating.
   - In both versions, write with commas, colons, parentheses, or periods instead of em-dashes.
5. **Publish to the wiki** by running `scripts/publish-wiki.sh --title "[Mon D, YYYY] Release Notes" --content-file <drafted-notes.md>` (day, month, and year, e.g. `[Jul 28, 2026]`) - confirm with the user before running this, since it posts visible content to a shared space. Requires `AZDO_PAT`, `AZDO_ORG`, `AZDO_PROJECT`, `AZDO_WIKI_ID` set in the environment. If this fails on a permissions error (e.g. a branch policy blocking direct writes to the wiki's backing repo), that's an ADO configuration issue outside this skill's control - fall back to handing the user the drafted content to paste into the wiki manually, rather than treating it as a dead end.

## Output
A dated release-notes wiki page (technical version) plus a plain-language companion doc for non-engineering audiences - both with themed/impact-ordered sections and links back to source PRs.

## Handoff
Feeds `change-request` (files the production Change Request work item linking to this page). Runs alongside the existing `release` skill's deploy step, once the promote PR is ready or has just been merged.

## Checklist
- [ ] Diff range identified from the actual promote PR (main vs staging), not guessed
- [ ] Every constituent PR reviewed for title/description, including promotion-looking PRs - not dismissed by title alone
- [ ] PRs grouped by theme, not left in merge/PR-number order
- [ ] Each themed section explains user-facing impact, not just restated file changes
- [ ] A plain-language version drafted for non-engineering audiences, ordered by customer impact, phrased as resolved outcomes rather than repeated "Fixed X"
- [ ] Every item in both versions links back to its source PR(s)
- [ ] No em-dashes in either drafted version
- [ ] Wiki page published under Release Notes, titled/dated with the prod release-date, after user confirmation - or, if publish failed on a permissions error, drafted content handed off for manual paste
