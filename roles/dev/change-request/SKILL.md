---
name: change-request
description: Use after release notes are published, to file the formal change-management work item for a production release - linking back to the release notes and source PR for approval and audit trail.
---

# Change Request

## Purpose
Give change-approvers and auditors a single, formal record of what's going into production - what changed, what was tested, and what operational impact to expect - separate from the user-facing release notes, since approval and audit needs differ from stakeholder communication.

## When to use
- A release-notes wiki page has just been published for a production rollout.
- Your organization's change-management process requires a formal work item before or alongside deploying to production.

## Process
1. **Gather the inputs.** The published release-notes wiki page URL (from `release-notes`) and the source PR link(s).
2. **Draft the work item body as HTML**, not Markdown - the target field renders HTML. Structure: Summary, Changes (bug fixes/features and user impact), Testing & Validation (what was verified), Additional Notes (migrations/config impact, or none), links to the release notes page and PR. Write with commas, colons, parentheses, or periods instead of em-dashes.
3. **Include an approvals checklist** as plain text/checkboxes in the description (e.g. role names with empty checkboxes) - approvers check these off in the work item after creation; the script does not set real approver identities.
4. **Confirm with the user before filing** - this creates a visible, tracked work item in a shared system.
5. **File it** by running `scripts/create-change-request.sh --title "Production Change Request: <one-line description>" --description-file <drafted-body.html>`. Requires `AZDO_PAT`, `AZDO_ORG`, `AZDO_PROJECT` set in the environment; `AZDO_CR_WORK_ITEM_TYPE` overrides the work item type name if it differs from "Production Change Request" in your org.
6. **Share the resulting work item link** back with whoever needs to approve the release.

## Output
A filed Change Request work item: title, HTML description (summary, changes, testing, operational notes), links to the release notes page and PR, and an approvals checklist.

## Handoff
Consumes the wiki page link produced by `release-notes`. Feeds the organization's own change-approval process; approval status should be confirmed before or alongside the `release` skill's deploy step for the same rollout.

## Checklist
- [ ] Release notes page already published before filing this
- [ ] Description written as HTML, not Markdown
- [ ] Testing & Validation section reflects what was actually verified, not boilerplate
- [ ] Migrations/config impact stated explicitly, even if "none"
- [ ] Release notes and PR links included
- [ ] Approvals checklist included
- [ ] No em-dashes in the drafted description
- [ ] User confirmed before the work item was filed
