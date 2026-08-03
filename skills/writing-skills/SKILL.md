---
name: writing-skills
description: Use when creating or editing a SKILL.md in this pack, to keep structure, tone, and scope consistent as the skill library grows across the SDLC and role folders.
---

# Writing Skills

## Purpose
A meta-skill: how to author or edit skills in this pack so the library stays consistent, generic, and genuinely useful as more skills are added — rather than drifting into project-specific or inconsistent formats.

## When to use
- Adding a new skill to `skills/` or `roles/*/`.
- Editing an existing skill because it's unclear, stale, or inconsistent with the others.
- Reviewing whether a proposed skill duplicates or overlaps an existing one.

## Process
1. **Check for overlap first.** Before creating a new skill, check whether it's actually a variant of an existing one (same purpose, different name) — consolidate instead of duplicating. This pack exists specifically to avoid the same skill being reinvented under different names.
2. **Keep it generic.** No project names, company specifics, or one-off tooling. A skill here should work for any AI-driven application, not just the one it was inspired by.
3. **Follow the shape.** Frontmatter (`name`, `description`) + Purpose, When to use, Process, Output, Handoff, Checklist. Consistency across skills makes the pack scannable and composable.
4. **Write the description as a trigger.** The `description` field should make it obvious *when* to reach for this skill — that's what routes work to it.
5. **State the handoff.** Every skill should say what it produces and which skill(s) consume that output — skills in this pack are meant to chain, not stand alone.
6. **Prefer fewer, sharper skills.** A bloated skill that tries to cover too much is harder to trigger correctly than two well-scoped ones — but don't split further than the consolidation table in this pack's design already settled.

## Output
A new or edited `SKILL.md` following the pack's shape, with no project-specific content and a clear handoff to adjacent skills.

## Checklist
- [ ] Checked for an existing skill this might duplicate or overlap
- [ ] No project-, company-, or tool-specific content included
- [ ] Follows the standard shape (frontmatter, Purpose, When to use, Process, Output, Handoff, Checklist)
- [ ] Description clearly signals when to trigger this skill
- [ ] Handoff to the next skill(s) in the chain is stated
