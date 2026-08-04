# Spec-Driven Development

A reusable, project-agnostic skill pack for building AI-driven applications end to end - concept through delivery - plus dev-role skills for the artifacts that sit alongside that lifecycle.

## Structure

```
skills/    Core SDLC lifecycle skills - the concept-to-delivery chain
roles/
  dev/     Developer artifacts that sit alongside the lifecycle (ADR, spike, ...)
```

Each skill is a standalone `SKILL.md` (frontmatter `name` + `description`, then Purpose, When to use, Process, Output, Handoff, Checklist) so it can be copied individually into a project's `.claude/skills/` or referenced from this pack directly.

## Lifecycle flow (`skills/`)

```
concept → design → plan → ┌────────────────────────────────┐ → log → release → closeout → kaizen
                           │  build ↔ test ↔ debug ↔ review  │
                           │      ↔ security-review          │
                           │      ↔ refactor                 │
                           └────────────────────────────────┘
                           (looped per unit of work from plan)
```

| Skill | Phase | One-line purpose |
|---|---|---|
| [concept](skills/concept/SKILL.md) | Concept | Idea → problem statement, requirements, user stories, via Socratic Discovery, Discovery Lenses, and verifiable requirements |
| [design](skills/design/SKILL.md) | Concept | Requirements → architecture, NFRs, diagrams, and documented design tradeoffs |
| [plan](skills/plan/SKILL.md) | Plan | Design → sequenced, sized units of work, with no-orphans requirement traceability |
| [build](skills/build/SKILL.md) | Construction | Implement a unit of work |
| [test](skills/test/SKILL.md) | Construction | Verify a unit against its acceptance criteria, including strict TDD and scenario-sensitivity checks |
| [debug](skills/debug/SKILL.md) | Construction | Classify, root-cause, and fix a defect with rigorous evidence |
| [review](skills/review/SKILL.md) | Construction | Correctness/quality gate before merge, plus Critical Review for pre-approval decisions |
| [security-review](skills/security-review/SKILL.md) | Construction | Dedicated security gate before merge/release |
| [refactor](skills/refactor/SKILL.md) | Construction | Improve structure without changing behavior |
| [log](skills/log/SKILL.md) | Delivery | Record progress and decisions as they happen |
| [release](skills/release/SKILL.md) | Delivery | Deploy, verify, and hand off operationally |
| [closeout](skills/closeout/SKILL.md) | Delivery | Confirm delivery against original acceptance criteria |
| [kaizen](skills/kaizen/SKILL.md) | Cross-cutting | Continuous improvement pass every cycle, using the 3Ms of waste |
| [writing-skills](skills/writing-skills/SKILL.md) | Meta | How to add/edit skills in this pack consistently |

## Role skills (`roles/dev/`)

These aren't lifecycle stages - they're artifacts the Dev role produces that support the lifecycle above.

[adr](roles/dev/adr/SKILL.md), [api-contract](roles/dev/api-contract/SKILL.md), [integration-spec](roles/dev/integration-spec/SKILL.md), [technical-spike](roles/dev/technical-spike/SKILL.md), [dependency-upgrade](roles/dev/dependency-upgrade/SKILL.md), [runbook](roles/dev/runbook/SKILL.md), [release-notes](roles/dev/release-notes/SKILL.md), [change-request](roles/dev/change-request/SKILL.md)

## Role skills (`roles/product-manager/`)

Artifacts the Product Manager role produces: owning and prioritizing a roadmap across the product areas you're responsible for, and defining/reporting the metrics that prove an initiative worked.

[roadmap-prioritization](roles/product-manager/roadmap-prioritization/SKILL.md), [success-metrics](roles/product-manager/success-metrics/SKILL.md)

## Design principles

- **No project-specific content.** Every skill here should apply to any AI-driven application, not just the one that inspired it.
- **Consolidated, not duplicated.** Where multiple projects had overlapping skills under different names (e.g. `audit` / `code-review` / `pr-review`), they were merged into one canonical skill rather than kept as near-duplicates.
- **Each skill states its handoff.** Skills are meant to chain - the Handoff section says what feeds in and what it feeds out to, so the pack composes into a full lifecycle rather than being a set of disconnected checklists.

## Using this pack

Copy the skill(s) you need into a project's `.claude/skills/<name>/SKILL.md` (or symlink the whole `skills/`/`roles/` tree in). See [writing-skills](skills/writing-skills/SKILL.md) before adding or editing a skill so new additions stay consistent with this structure.

Unlike the TPM skills in `AI-DLC Skills`, none of these are symlinked into `.claude/skills/` yet - do that per-project as needed (Claude Code only scans `.claude/skills/`, not `skills/`/`roles/` directly).
