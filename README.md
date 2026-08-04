# Spec-Driven Development

A reusable, project-agnostic skill pack for building AI-driven applications end to end - concept through delivery - plus the role skills three different people on that effort actually need: a Developer producing artifacts like ADRs and integration specs, a Product Manager owning the roadmap and build-vs-buy calls, and a Technical Program Manager running the cross-team program those two roles sit inside of.

## Structure

```
ai-dlc/    Core AI-DLC (AI Development Lifecycle) skills - the concept-to-delivery chain
roles/
  dev/               Developer artifacts that sit alongside the lifecycle (ADR, spike, ...)
  product-manager/   Roadmap prioritization, success-metrics, and build-vs-buy artifacts
  tpm/               Program-management mechanisms (Confluence Program Hub, RACI, risk, decisions, status)
```

Each skill is a standalone `SKILL.md` (frontmatter `name` + `description`, then Purpose, When to use, Process, Output, Handoff, Checklist) so it can be copied individually into a project's `.claude/skills/` or referenced from this pack directly.

## AI-DLC flow (`ai-dlc/`)

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
| [concept](ai-dlc/concept/SKILL.md) | Concept | Idea → problem statement, requirements, user stories, via Socratic Discovery, Discovery Lenses, and verifiable requirements |
| [design](ai-dlc/design/SKILL.md) | Concept | Requirements → architecture, NFRs, diagrams, and documented design tradeoffs |
| [plan](ai-dlc/plan/SKILL.md) | Plan | Design → sequenced, sized units of work, with no-orphans requirement traceability |
| [build](ai-dlc/build/SKILL.md) | Construction | Implement a unit of work |
| [test](ai-dlc/test/SKILL.md) | Construction | Verify a unit against its acceptance criteria, including strict TDD and scenario-sensitivity checks |
| [debug](ai-dlc/debug/SKILL.md) | Construction | Classify, root-cause, and fix a defect with rigorous evidence |
| [review](ai-dlc/review/SKILL.md) | Construction | Correctness/quality gate before merge, plus Critical Review for pre-approval decisions |
| [security-review](ai-dlc/security-review/SKILL.md) | Construction | Dedicated security gate before merge/release |
| [refactor](ai-dlc/refactor/SKILL.md) | Construction | Improve structure without changing behavior |
| [log](ai-dlc/log/SKILL.md) | Delivery | Record progress and decisions as they happen |
| [release](ai-dlc/release/SKILL.md) | Delivery | Deploy, verify, and hand off operationally |
| [closeout](ai-dlc/closeout/SKILL.md) | Delivery | Confirm delivery against original acceptance criteria |
| [kaizen](ai-dlc/kaizen/SKILL.md) | Cross-cutting | Continuous improvement pass every cycle, using the 3Ms of waste |
| [writing-skills](ai-dlc/writing-skills/SKILL.md) | Meta | How to add/edit skills in this pack consistently |

## Role skills (`roles/dev/`)

These aren't lifecycle stages - they're artifacts the Dev role produces that support the lifecycle above.

[adr](roles/dev/adr/SKILL.md), [api-contract](roles/dev/api-contract/SKILL.md), [integration-spec](roles/dev/integration-spec/SKILL.md), [technical-spike](roles/dev/technical-spike/SKILL.md), [dependency-upgrade](roles/dev/dependency-upgrade/SKILL.md), [runbook](roles/dev/runbook/SKILL.md), [release-notes](roles/dev/release-notes/SKILL.md), [change-request](roles/dev/change-request/SKILL.md)

## Role skills (`roles/product-manager/`)

Artifacts the Product Manager role produces: owning and prioritizing a roadmap across the product areas you're responsible for, defining/reporting the metrics that prove an initiative worked, and deciding whether a capability should be built, bought, or extended.

[roadmap-prioritization](roles/product-manager/roadmap-prioritization/SKILL.md), [success-metrics](roles/product-manager/success-metrics/SKILL.md), [build-vs-buy](roles/product-manager/build-vs-buy/SKILL.md)

## Role skills (`roles/tpm/`)

Artifacts and mechanisms a Technical Program Manager uses to run a cross-team program end to end: framing the Program Management Lifecycle, standing up the Confluence Program Hub, and keeping ownership, decisions, risk, and status current as the program runs. Several of these publish directly into Confluence/Jira via the Atlassian MCP connector rather than just producing local markdown.

[tpm-pdlc](roles/tpm/tpm-pdlc/SKILL.md), [tpm-concept](roles/tpm/tpm-concept/SKILL.md), [tpm-program-brief](roles/tpm/tpm-program-brief/SKILL.md), [tpm-program-space](roles/tpm/tpm-program-space/SKILL.md), [tpm-tooling-setup](roles/tpm/tpm-tooling-setup/SKILL.md), [tpm-stakeholder-map](roles/tpm/tpm-stakeholder-map/SKILL.md), [tpm-raci](roles/tpm/tpm-raci/SKILL.md), [tpm-contested-decisions](roles/tpm/tpm-contested-decisions/SKILL.md), [tpm-risk-register](roles/tpm/tpm-risk-register/SKILL.md), [decision-log](roles/tpm/decision-log/SKILL.md), [status-report](roles/tpm/status-report/SKILL.md), [tpm-biweekly-stakeholder-update](roles/tpm/tpm-biweekly-stakeholder-update/SKILL.md), [tpm-sdd-bridge](roles/tpm/tpm-sdd-bridge/SKILL.md)

## Design principles

- **No project-specific content.** Every skill here should apply to any AI-driven application, not just the one that inspired it.
- **Consolidated, not duplicated.** Where multiple projects had overlapping skills under different names (e.g. `audit` / `code-review` / `pr-review`), they were merged into one canonical skill rather than kept as near-duplicates.
- **Each skill states its handoff.** Skills are meant to chain - the Handoff section says what feeds in and what it feeds out to, so the pack composes into a full lifecycle rather than being a set of disconnected checklists.

## Using this pack

Claude Code only scans `.claude/skills/<name>/SKILL.md`, one level deep, so symlinking `ai-dlc/` or `roles/` in wholesale won't work: skills would sit one (or for `roles/`, two) levels too deep to be discovered.

Run the installer instead of doing this by hand:

```bash
/path/to/this/pack/scripts/install-skills.sh /path/to/your/project
```

Installs every skill as a symlink under `.claude/skills/<name>/`, one per entry, skipping anything already there rather than overwriting it. Useful flags:
- `--exclude "tpm-*,change-request"` - install everything except these (comma-separated glob patterns)
- `--only "concept,design,plan"` - install just these
- `--copy` - copy each skill folder instead of symlinking (use this if the target project will be shared with people who won't have this pack checked out at the same path, a symlink would dangle for them)
- `--dry-run` - preview what would happen without touching anything

See [writing-skills](ai-dlc/writing-skills/SKILL.md) before adding or editing a skill so new additions stay consistent with this structure.
