#!/usr/bin/env bash
# Scaffolds a Program Hub (Markdown) in the canonical section order every
# program uses, so two programs' hubs are read the same way. Prose is left as
# bracketed prompts for the PM; the structure, the tag legend, and the goal
# traceability scaffolding are real content, not prompts.
#
# The hub is a map, not a source of truth: filtered sections (Open Decisions,
# Risks, Current Milestones) surface only what needs attention and link out to
# the register that owns the full list.
#
# Usage:
#   generate-hub-template.sh --title "Caregiver Access Solutions" \
#     --space-url "https://x.atlassian.net/wiki/spaces/CAS" \
#     --goal "Grow prescription volume" --goal "Grow revenue per household" \
#     --phase "Minor dependents, benefit members|GA Sep 15, 2026" \
#     --phase "Adult dependents|GA Mar 2027" \
#     --lane "Access Platform" --lane "Policy and Compliance" \
#     --project "RBAC engine" \
#     --compliance \
#     --model "Access and Permission Model"
set -euo pipefail

TITLE="New Program"
OUTPUT_DIR="."
SPACE_URL=""
MODEL_SECTION=""
INCLUDE_COMPLIANCE=0
PROJECTS=()
GOALS=()
PHASES=()
LANES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    --space-url) SPACE_URL="$2"; shift 2 ;;
    --project) PROJECTS+=("$2"); shift 2 ;;
    --goal) GOALS+=("$2"); shift 2 ;;
    --phase) PHASES+=("$2"); shift 2 ;;
    --lane) LANES+=("$2"); shift 2 ;;
    --model) MODEL_SECTION="$2"; shift 2 ;;
    --compliance) INCLUDE_COMPLIANCE=1; shift ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

# Key Documents/Projects are real markdown links, using the space overview
# as a placeholder target - per SKILL.md's process, create the program-level
# docs first, then regenerate this Hub content with each real webUrl from
# those createConfluencePage responses before publishing it.
PLACEHOLDER="${SPACE_URL}#"

mkdir -p "$OUTPUT_DIR"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')
OUT_FILE="$OUTPUT_DIR/${SLUG}-program-hub.md"

# Default to one unnamed phase so the OKR scaffolding is never empty.
if [[ ${#PHASES[@]} -eq 0 ]]; then
  PHASES=("Phase 1 scope, name it|GA TBD")
fi
if [[ ${#GOALS[@]} -eq 0 ]]; then
  GOALS=("Business goal 1, name it" "Business goal 2, name it")
fi

phase_name() { echo "${1%%|*}"; }
phase_date() {
  if [[ "$1" == *"|"* ]]; then echo "${1#*|}"; else echo "GA TBD"; fi
}

{
  echo "# Program Hub: ${TITLE}"
  echo
  echo "[One or two sentences: what this program gives whom, and what it deliberately does not do.]"
  echo
  echo "| | |"
  echo "|---|---|"
  echo "| **Owner** | [TPM name] |"
  echo "| **Sponsor** | [Exec name and title] |"
  echo "| **Phase 1 GA** | $(phase_date "${PHASES[0]}") |"
  echo "| **Last updated** | [Date, refreshed weekly ahead of program review] |"
  echo
  echo "Entry point for every team on this program. Each section summarizes and links to the artifact that owns it, so update the artifact rather than this page."
  echo

  # ---------- 1. Status ----------
  echo "## Status: [Green / Amber / Red]"
  echo
  echo "| Row | What it carries |"
  echo "|---|---|"
  echo "| **Timeline** | [The date, and what it now depends on. Name the driving constraint from the blocker table, not all of them] |"
  echo "| **Done** | [Closed work, so nobody re-litigates or re-asks] |"
  echo "| **Watch** | [Not blocking yet, would block if ignored. Must be different items from the blocker table below] |"
  echo "| **Known gap** | [Deliberate descope, stated so it is not mistaken for an oversight] |"
  echo
  echo "### Blockers"
  echo
  echo "All of them, ranked by date impact. Most programs have several; only some move the date. Mark which ones sit on the critical path, because a list that treats four blockers as equally urgent tells a reader nothing about what to fix first."
  echo
  echo "| # | Blocker | Owner | Needed by | Blocks | Critical path |"
  echo "|---|---|---|---|---|---|"
  echo "| 1 | [The thing that is not resolved] | [Single name] | [Date] | [What it holds up] | Yes, drives GA |"
  echo "| 2 | [Second] | [Name] | [Date] | [What it holds up] | No, parallel |"
  echo
  echo "**Why the top blocker drives the date.** Bullets, one to three lines each, not prose:"
  echo
  echo "- [Is it a relay or a solo lap? Name who waits on whom.]"
  echo "- [How much cushion does it have? Calendar available minus work required.]"
  echo "- [Why the others absorb a slip: spare days, or an escape hatch like a reduced scope.]"
  echo "- [Rank by cushion, not by due date. A slip only moves the date when nothing is left to absorb it.]"
  echo
  echo "[If more than one blocker is marked as driving the date, say which is worse and why. \"Everything is critical\" is the same as saying nothing is.]"
  echo
  echo "### Asks"
  echo
  echo "One per blocker that needs someone outside the program. Each needs a name, a date, and the consequence of a miss; without all three it is reporting, not escalating."
  echo
  echo "| Ask | Who | By when | If missed |"
  echo "|---|---|---|---|"
  echo "| [What you need them to do] | [Named person, not a team] | [Date] | [The specific consequence, usually a date slip or a descope] |"
  echo

  # ---------- 2. RACI ----------
  echo "## RACI"
  echo
  echo "Who decides what. Read this before escalating."
  echo
  echo "| Deliverable | R | A | C | I |"
  echo "|---|---|---|---|---|"
  echo "| [Deliverable] | [Does the work] | [Single accountable name] | [Consulted] | [Informed] |"
  echo "| [Phase scope and sequencing] | [TPM] | [Sponsor] | [Team leads] | [Org-wide] |"
  echo
  echo "[Full RACI](${PLACEHOLDER})"
  echo

  # ---------- 3. Recent Activity ----------
  echo "## Recent Activity"
  echo
  echo "Most recent first. This is the section that makes the hub worth revisiting rather than bookmarking once."
  echo
  echo "- **[Date]** [What changed, decided, shipped, or newly went at risk]"
  echo "- **[Date]** [Same]"
  echo

  # ---------- 4. Goals and OKRs ----------
  echo "## Goals and OKRs"
  echo
  echo "### 1. Business goals this program serves"
  echo
  echo "This program earns its funding by moving company-level numbers. Every KR below is tagged with the goal it moves."
  echo
  echo "| Goal | How this program moves it | Program measure |"
  echo "|---|---|---|"
  gi=0
  for goal in "${GOALS[@]}"; do
    gi=$((gi + 1))
    echo "| **G${gi}** ${goal} | [The mechanism, in one specific sentence. If you cannot name it, the goal does not belong here] | [The metric that proves it] |"
  done
  echo
  echo "### 2. Program objective"
  echo
  echo "[One sentence naming the business outcome, not the constraint. \"Grow X by doing Y\" beats \"deliver a secure, compliant Z\" - secure and compliant are table stakes, not the objective.]"
  echo
  echo "### 3. North star"
  echo
  echo "**One metric. Not a dashboard.** If a table appears here with five rows, this section is wrong: five north stars means no north star, and the program will report whichever one looks best that month."
  echo
  echo "**[The single metric]:** [X to Y, by when]"
  echo
  echo "- **Why this one.** [What makes it the best single proxy for the program working.]"
  echo "- **How it decomposes.** [\`factor A × factor B\`, and which phase grows which factor. A north star that only one phase can move is scoped too narrowly.]"
  echo
  echo "**Not metrics.** Keep these out of the north star and the metric tree, and say so explicitly so nobody re-adds them:"
  echo
  echo "- **Market sizing (TAM, SAM).** A ceiling on the prize, not a number the program moves. It belongs in the business case."
  echo "- **Revenue targets that are outcomes of the north star**, not drivers of it. Those are KRs."
  echo "- [Anything a team cannot act on this quarter.]"
  echo
  echo "**Watched, not gated.** [Real outcomes that no phase passes or fails on. Listing them here stops them competing for attention with the ones that do gate.]"
  echo
  echo "### 4. Metric tree"
  echo
  echo "Every metric that feeds the north star, in one place. This is the only inventory of metrics in the hub; do not keep a second list under the north star, or the two will drift apart. Adoption is not the goal, it is the earliest signal the goal is reachable, and each tier leads the one below it."
  echo
  echo "| Metric | Tier | Signal in | Baseline to target | Moves |"
  echo "|---|---|---|---|---|"
  echo "| [Who turned it on, how often they return] | Adoption | Weeks | [X to Y] | [Which north-star factor] |"
  echo "| [What they now do differently] | Behavior | One usage cycle | [X to Y] | [Which factor, and flag the causal driver] |"
  echo "| [The G-level numbers from section 1] | Business | 2 to 4 quarters | [X to Y] | [A north-star term, or downstream of it] |"
  echo
  echo "[The Behavior tier is the causal link between adoption and business results, and the tier most programs skip. If it is empty, there is no stated theory for why adoption would produce the business outcome.]"
  echo
  echo "### 5. Phased OKRs"
  echo
  echo "KRs here are outcomes only. Delivery milestones live in Go/No-Go and Program Structure, so shipping a feature is never mistaken for moving a number."
  echo
  echo "Tag every KR. The three tags differ in what you learn from hitting versus missing, and that asymmetry is the point."
  echo
  echo "| Tag | Question it answers | Hitting it tells you | Missing it tells you |"
  echo "|---|---|---|---|"
  echo "| **G1..Gn** goal | Did the business number move? | The phase worked. | The phase failed. |"
  echo "| **ENABLER** | Is anyone actually using it? | Nothing yet. People showed up; whether it helped is a different KR. | The goal KRs could not have moved. Tells you where to look, not that you failed. |"
  echo "| **GUARDRAIL** | Did we break something on the way? | Nothing. This was expected, no credit for it. | The phase failed, even with every goal KR hit. |"
  echo
  echo "[Worked example, strongly recommended: table the two or three realistic end states for this phase and give each a verdict. The pairs worth showing are (a) enabler hit + goal flat, which means used and useless, so the thesis is wrong; (b) enabler missed + goal flat, which is inconclusive because the test never ran; and (c) every goal hit + guardrail missed, which still fails. Untagged, all three read as \"2 of 3 KRs hit\" and lead to the wrong conversation.]"
  echo
  pi=0
  for phase in "${PHASES[@]}"; do
    pi=$((pi + 1))
    echo "#### Phase ${pi}: $(phase_name "$phase") ($(phase_date "$phase"))"
    echo
    echo "**Objective.** [What this phase proves or unlocks. Not the segment name, which is the heading. If the objective is just \"ship phase ${pi}\", the phase has no thesis.]"
    echo
    echo "**Why this phase is sequenced here.** [What is easy here that is hard later, or what this phase de-risks for the next one.]"
    echo
    echo "| KR | Tag | Baseline to target |"
    echo "|---|---|---|"
    echo "| KR1. [Outcome] | [G1] | [X to Y] |"
    echo "| KR2. [Outcome] | [G2] | [X to Y] |"
    echo "| KR3. [Precondition] | ENABLER | [Target] |"
    echo "| KR4. [The thing that must not happen] | GUARDRAIL | [Target 0] |"
    echo
    echo "**Needle moved.** [Which KRs are the actual business movement, which are preconditions, and which one kills the phase if missed.]"
    echo
  done
  echo "### 6. Goal coverage check"
  echo
  echo "Read down a column for what a phase delivers to the business. Read across a row to see whether a goal is ever measured. A row with no KR anywhere is either a missing KR or a goal that does not belong in section 1."
  echo
  header="| Goal |"
  divider="|---|"
  for ((i = 1; i <= ${#PHASES[@]}; i++)); do
    header="${header} Phase ${i} |"
    divider="${divider}---|"
  done
  echo "$header"
  echo "$divider"
  gi=0
  for goal in "${GOALS[@]}"; do
    gi=$((gi + 1))
    row="| **G${gi}** ${goal} |"
    for ((i = 1; i <= ${#PHASES[@]}; i++)); do
      row="${row} [KR refs, or state why not in scope] |"
    done
    echo "$row"
  done
  echo
  echo "[Call out every deliberate gap here in prose. An unexplained blank reads as an oversight; a stated one reads as sequencing.]"
  echo

  # ---------- Optional: program domain model ----------
  if [[ -n "$MODEL_SECTION" ]]; then
    echo "## ${MODEL_SECTION}"
    echo
    echo "The dimensions that cut across every phase rather than belonging to one. Each phase decides how much of each dimension it takes on."
    echo
    echo "| Dimension | Phase 1 scope | Gets harder |"
    echo "|---|---|---|"
    echo "| [Dimension] | [What the MVP handles] | [What is deferred, and why it is harder] |"
    echo
    echo "[Name which rows carry the real exposure, and confirm each is tracked below under Open Decisions, Risks, or Dependencies. A dimension documented here but tracked nowhere is a gap.]"
    echo
  fi

  # ---------- 5. Go/No-Go ----------
  echo "## Go / No-Go Launch Criteria"
  echo
  echo "What has to be true before GA. Reviewed weekly, and a single at-risk row is enough to move the date."
  echo
  echo "| Criterion | Owner | Status |"
  echo "|---|---|---|"
  echo "| [Criterion] | [Owner] | [Met date, or Due date] |"
  echo

  # ---------- 6. Open Decisions ----------
  echo "## Open Decisions"
  echo
  echo "Surfaced: only decisions blocking someone or needing input now. Blocking ones first."
  echo
  echo "| Decision | Approver | Status |"
  echo "|---|---|---|"
  echo "| [Decision, phrased as a question] | [Single name] | [Blocking X / Open / Leaning] |"
  echo
  echo "[Decision Log](${PLACEHOLDER}) - [Contested Decisions](${PLACEHOLDER}) (created once an actual contested decision needs one)"
  echo

  # ---------- 7. Dependencies ----------
  echo "## Dependencies"
  echo
  echo "Blocked-by, not might-happen. A risk might happen; a dependency is someone else's deliverable you are waiting on. Dependencies are where programs actually slip, which is why they are not folded into Risks."
  echo
  echo "| We depend on | For | Status |"
  echo "|---|---|---|"
  echo "| [Team: deliverable] | [What it unblocks] | [Blocking / In progress / Delivered] |"
  echo

  # ---------- 8. Risks ----------
  echo "## Risks"
  echo
  echo "Surfaced: only risks needing visibility, highest exposure first. The scored register lives elsewhere."
  echo
  echo "| Risk | Owner | Status |"
  echo "|---|---|---|"
  echo "| [Risk, stated as the thing that goes wrong rather than a topic] | [Owner] | [High / Mitigated / Managed] |"
  echo
  echo "[Risk Register](${PLACEHOLDER})"
  echo

  # ---------- 9. Compliance (conditional) ----------
  if [[ $INCLUDE_COMPLIANCE -eq 1 ]]; then
    echo "## Compliance and Security"
    echo
    echo "Owner: [name, title]. Tracked separately from Risks because a missed compliance gate blocks launch outright rather than raising a score."
    echo
    echo "| Requirement | Owner | Status |"
    echo "|---|---|---|"
    echo "| [Requirement] | [Owner] | [Signed off / Pending / Not built] |"
    echo
  fi

  # ---------- 10. Program Structure ----------
  echo "## Program Structure"
  echo
  echo "Workstreams and the projects under them. Each lane has one accountable lead; each project is scoped narrowly enough to ship independently. Phase tags show first delivery, not only delivery."
  echo
  if [[ ${#LANES[@]} -eq 0 ]]; then
    echo "### Lane A: [Lane name]"
    echo
    echo "[One line: what this lane owns, and who leads it]"
    echo
    echo "| Project | Phase | Status |"
    echo "|---|---|---|"
    if [[ ${#PROJECTS[@]} -eq 0 ]]; then
      echo "| A1. [Project] - [why it is its own project] | P1 | Not started |"
    else
      n=0
      for project in "${PROJECTS[@]}"; do
        n=$((n + 1))
        echo "| A${n}. ${project} | P1 | Not started |"
      done
    fi
    echo
  else
    letter=A
    for lane in "${LANES[@]}"; do
      echo "### Lane ${letter}: ${lane}"
      echo
      echo "[One line: what this lane owns, and who leads it]"
      echo
      echo "| Project | Phase | Status |"
      echo "|---|---|---|"
      echo "| ${letter}1. [Project] - [why it is its own project] | P1 | Not started |"
      echo
      letter=$(echo "$letter" | tr 'A-Y' 'B-Z')
    done
    if [[ ${#PROJECTS[@]} -gt 0 ]]; then
      echo "Projects given at scaffold time, to be assigned to a lane above:"
      for project in "${PROJECTS[@]}"; do
        echo "- ${project}"
      done
      echo
    fi
  fi
  echo "**Critical path.** [The dependency chain to the next GA, named hop by hop, plus how many working days of slack remain. If you cannot state the slack, the schedule is not yet planned backward from the date.]"
  echo

  # ---------- 11. Current Milestones ----------
  echo "## Current Milestones"
  echo
  echo "At risk or next up, in date order. The full plan lives elsewhere."
  echo
  echo "| Milestone | Target | Status |"
  echo "|---|---|---|"
  echo "| [Milestone] | [Day, date] | [At risk / On track / Scheduled] |"
  echo
  echo "[Full program plan](${PLACEHOLDER})"
  echo

  # ---------- 12. Contacts ----------
  echo "## Contacts and Escalation"
  echo
  echo "| Role | Name | Channel |"
  echo "|---|---|---|"
  echo "| Program Lead (TPM) | [Name] | [#channel] |"
  echo "| [Function] Lead | [Name] | [#channel] |"
  echo
  echo "[Escalation path: what qualifies, where to post, and the response commitment. RACI says who owns what; this says who to wake up.]"
  echo

  # ---------- 13. Documents ----------
  echo "## Documents"
  echo
  echo "Grouped by category. Only categories with real documents appear; do not leave empty headers."
  echo
  echo "**Technical**"
  echo "- [Technical spec](${PLACEHOLDER})"
  echo
  echo "**Business and Strategy**"
  echo "- [Program Brief](${PLACEHOLDER})"
  echo "- [Stakeholder Map](${PLACEHOLDER})"
  echo
  if [[ $INCLUDE_COMPLIANCE -eq 1 ]]; then
    echo "**Compliance and Risk**"
    echo "- [Risk Register](${PLACEHOLDER})"
    echo "- [Compliance checklist](${PLACEHOLDER})"
    echo
  else
    echo "**Compliance and Risk**"
    echo "- [Risk Register](${PLACEHOLDER})"
    echo
  fi
  echo "**Process and Governance**"
  echo "- [RACI](${PLACEHOLDER})"
  echo "- [Decision Log](${PLACEHOLDER})"
  echo "- [Progress Log](${PLACEHOLDER})"
  echo
  echo "**Communications and Enablement**"
  echo "- [Status report template](${PLACEHOLDER})"
  echo
} > "$OUT_FILE"

echo "Wrote $OUT_FILE"
