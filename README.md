# Spec-Driven Development

A reusable, project-agnostic skill pack for building AI-driven applications from concept through delivery, plus developer-role skills that sit alongside the lifecycle.

Product Manager and TPM role skills moved to their own pack: [pm-tpm-skills](https://github.com/pavani-aiml-space/pm-tpm-skills).

## Structure

```
ai-dlc/    Core AI-DLC (AI Development Lifecycle) skills - the concept-to-delivery chain
roles/
  dev/     Developer artifacts that sit alongside the lifecycle (ADR, spike, ...)
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

Dev related skills:

[adr](roles/dev/adr/SKILL.md), [api-contract](roles/dev/api-contract/SKILL.md), [integration-spec](roles/dev/integration-spec/SKILL.md), [technical-spike](roles/dev/technical-spike/SKILL.md), [dependency-upgrade](roles/dev/dependency-upgrade/SKILL.md), [runbook](roles/dev/runbook/SKILL.md), [release-notes](roles/dev/release-notes/SKILL.md), [change-request](roles/dev/change-request/SKILL.md)

## Product Manager and TPM skills

Moved to [pm-tpm-skills](https://github.com/pavani-aiml-space/pm-tpm-skills): PRD generation, roadmap prioritization, success-metrics, build-vs-buy, and the program-management mechanisms (Confluence Program Hub, RACI, risk, decisions, status) a TPM uses to run a cross-team program end to end. `tpm-sdd-bridge` in that pack is what connects a TPM's program artifacts back to the AI-DLC lifecycle here.

## Using these Skills

Claude Code only scans `.claude/skills/<name>/SKILL.md`, one level deep, so symlinking `ai-dlc/` or `roles/` in wholesale won't work: skills would sit one (or for `roles/`, two) levels too deep to be discovered.

Run the installer instead of doing this by hand:

```bash
/path/to/this/pack/scripts/install-skills.sh /path/to/your/project
```

Installs every skill as a symlink under `.claude/skills/<name>/`, one per entry, skipping anything already there rather than overwriting it. Useful flags:
- `--exclude "change-request,runbook"` - install everything except these (comma-separated glob patterns)
- `--only "concept,design,plan"` - install just these
- `--copy` - copy each skill folder instead of symlinking (use this if the target project will be shared with people who won't have this pack checked out at the same path, a symlink would dangle for them)
- `--dry-run` - preview what would happen without touching anything

See [writing-skills](ai-dlc/writing-skills/SKILL.md) before adding or editing a skill so new additions stay consistent with this structure.
