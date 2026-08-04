#!/usr/bin/env bash
# Scaffolds a starter RACI matrix (CSV + Markdown) for a new initiative:
# standard roles pre-filled per SKILL.md step 5's typical mapping, as
# placeholders to replace with real names - not a finished matrix.
set -euo pipefail

TITLE="New Initiative"
OUTPUT_DIR="."
SPONSOR="TBD"
LEAD=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    --sponsor) SPONSOR="$2"; shift 2 ;;
    --lead) LEAD="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$OUTPUT_DIR"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')
OWNER="${LEAD:-Program Manager}"

# Each row: Deliverable/Decision | Responsible | Accountable (DRI) | Consulted | Informed
# Single source of truth - both output formats are generated from this.
# Uses '|' as the field delimiter - none of the field text below contains one.
ROWS=(
  "Business case / investment proposal approval|Product/TPM|${SPONSOR}|Finance, Legal/Privacy, Eng Leadership|Broader org, Support/CS"
  "Scope & priority decisions|${OWNER}|${OWNER}|Engineering, Design|Support/CS"
  "Technical delivery|Engineering|Eng Manager|Security, ${OWNER}|Support/CS"
  "Design deliverables|Design/UX|${OWNER}|Design, Engineering|Support/CS"
  "Security review (mandatory - customer data or PII in scope)|Security|Security|Engineering|${OWNER}, ${SPONSOR}"
  "Legal/Privacy sign-off|Legal/Privacy|Legal/Privacy|Engineering, Security, ${OWNER}|${SPONSOR}"
  "Launch readiness (go/no-go review)|${OWNER}|${OWNER}|Engineering, Support/Ops, ${SPONSOR}|Broader org"
  "TBD, add your own deliverable|TBD|TBD|TBD|TBD"
)

CSV_FILE="$OUTPUT_DIR/${SLUG}-raci.csv"
MD_FILE="$OUTPUT_DIR/${SLUG}-raci.md"

split_row() {
  IFS='|' read -r -a FIELDS <<< "$1"
}

{
  echo '"Deliverable/Decision","Responsible","Accountable (DRI)","Consulted","Informed"'
  for row in "${ROWS[@]}"; do
    split_row "$row"
    printf '"%s","%s","%s","%s","%s"\n' "${FIELDS[0]}" "${FIELDS[1]}" "${FIELDS[2]}" "${FIELDS[3]}" "${FIELDS[4]}"
  done
} > "$CSV_FILE"

{
  echo "# RACI: $TITLE"
  echo
  echo "**Sponsor**: $SPONSOR"
  echo
  echo "## Overview: What this page does"
  echo "- Names exactly one Accountable/DRI owner per deliverable or standing decision-making role (an ongoing category of choices, or an approval gate with an already-known owner), plus who does the work, who's consulted, and who's kept informed."
  echo "- Prevents two failure modes: no owner (work stalls) and too many owners (nothing moves without a meeting)."
  echo "- Covers ongoing delivery ownership, not a single decision - a single high-stakes decision inside any row below should become a row on the program's Contested Decisions page (\`tpm-contested-decisions\`) instead of being resolved in this table (see Other notes)."
  echo "- Starter template only - replace pre-filled roles with real names before treating this as authoritative."
  echo
  echo "## Best practices"
  echo "1. Replace the starter rows with real deliverables/decisions - don't edit around them."
  echo "2. Name real people, not roles, once you know who they are - check the Stakeholder Map first."
  echo "3. Exactly one Accountable/DRI per row, never zero, never more than one - resolve conflicts now, not after circulation."
  echo "4. Keep Consulted/Informed short - \"everyone\" isn't an answer."
  echo "5. Legal/regulatory/data-privacy rows: Legal/Privacy is Accountable or joint-Approver, not Consulted."
  echo "6. Gate launch on a real go/no-go review - this table names the owner, the review confirms they're ready."
  echo "7. Delete placeholder rows before circulating; get explicit agreement from everyone named."
  echo "8. Revisit after material scope changes or any postmortem that surfaces an ownership gap."
  echo "9. If a decision inside one of these rows becomes a row on the Contested Decisions page (\`tpm-contested-decisions\`), check its Approver against this row's Accountable before treating the decision as settled - see Other notes."
  echo
  echo "| Deliverable/Decision | Responsible | Accountable (DRI) | Consulted | Informed |"
  echo "|---|---|---|---|---|"
  for row in "${ROWS[@]}"; do
    split_row "$row"
    echo "| ${FIELDS[0]} | ${FIELDS[1]} | ${FIELDS[2]} | ${FIELDS[3]} | ${FIELDS[4]} |"
  done
  echo
  echo "## Legend"
  echo "- Responsible: completes the task; at least one person required, others may assist."
  echo "- Accountable/DRI: ultimately answerable for correct completion, ensures prerequisites are met and delegates the work to Responsible; exactly one person per task, never zero, never shared."
  echo "- Consulted: subject-matter experts whose opinions are sought before the task is finalized; two-way communication."
  echo "- Informed: kept up to date on progress or completion; one-way communication."
  echo
  echo "## Other notes"
  echo "**Sponsor role**"
  echo "- Sits outside the grid above."
  echo "- Approves the business case/investment proposal."
  echo "- Resolves resourcing/priority conflicts between Accountable owners."
  echo "- Accountable on the business case row."
  echo
  echo "**Program Manager vs. TPM**"
  echo "- Program Manager owns the outcome and roadmap for their area, typically the DRI on execution rows."
  echo "- TPM drives cross-team execution and coordination, typically Responsible, not Accountable, unless there's no dedicated Program Manager, in which case name that explicitly."
  echo
  echo "**RACI vs. Contested Decisions - avoiding an authority collision**"
  echo "- This matrix governs ongoing deliverable/decision ownership. A single high-stakes decision inside any row here (contested, expensive to reverse, or stalling because too many people are weighing in) should become a row on the program's Contested Decisions page (\`tpm-contested-decisions\`) rather than being argued out in this table."
  echo "- When it does, that row's Approver should be the same person as this row's Accountable/DRI, or an explicit, documented delegate. A different, unreconciled Approver isn't a second valid owner - it's an authority collision, and it means one of the two pages is wrong."
  echo
  echo "**RACI is the default, Contested Decisions is the exception**"
  echo "- Example, stays in RACI: a \"Scope & priority decisions\" row - the Accountable owner just decides as things come up, indefinitely. No Contested Decisions row, ever."
  echo "- Example, escalates then folds back: a \"Launch readiness (go/no-go)\" row - the Accountable owner usually just declares it. But if two functions hit a real standoff over one specific call (e.g. does a P1 bug block this launch), that one question becomes a row on the Contested Decisions page - Approver matching this row's Accountable - and the outcome folds back into this same row once decided."
} > "$MD_FILE"

echo "Wrote $CSV_FILE"
echo "Wrote $MD_FILE"
