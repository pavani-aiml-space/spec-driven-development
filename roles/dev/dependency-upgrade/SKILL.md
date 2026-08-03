---
name: dependency-upgrade
description: Use when evaluating or rolling out an upgrade to a library, framework, runtime, or other external dependency, to do it safely and deliberately rather than reactively.
---

# Dependency Upgrade

## Purpose
Upgrade external dependencies (libraries, frameworks, runtimes, base images) deliberately — weighing risk and benefit — instead of reactively (only upgrading when forced by a vulnerability or breakage) or carelessly (upgrading without checking impact).

## When to use
- A dependency has a known vulnerability requiring an upgrade.
- A new version offers a needed feature, performance improvement, or fix.
- Routine maintenance to avoid falling far enough behind that upgrades become high-risk.

## Process
1. **Check what changed.** Read the changelog/release notes between current and target version — breaking changes, deprecations, behavior changes, not just the version number.
2. **Assess blast radius.** How widely is this dependency used in the codebase, and which of those usages touch changed behavior?
3. **Upgrade incrementally when possible.** Prefer stepping through intermediate major versions over jumping several majors at once — smaller diffs are easier to attribute if something breaks.
4. **Test thoroughly**, especially around the specific areas the changelog flagged as changed — don't rely solely on the existing suite if it doesn't cover the changed behavior.
5. **Check transitive dependencies.** Confirm the upgrade doesn't pull in conflicting or vulnerable transitive versions.
6. **Have a rollback plan** before rolling out broadly, same as any `release`.

## Output
An upgraded dependency, verified against changed behavior, with a documented rollback path.

## Handoff
Goes through the normal `build` → `test` → `review` → `release` loop like any other change; a security-driven upgrade should also go through `security-review`.

## Checklist
- [ ] Changelog/release notes were actually read, not just the version bump
- [ ] Usage sites touching changed behavior were identified and checked
- [ ] Tests specifically cover the areas flagged as changed
- [ ] Transitive dependency impact was checked
- [ ] Rollback plan exists before broad rollout
