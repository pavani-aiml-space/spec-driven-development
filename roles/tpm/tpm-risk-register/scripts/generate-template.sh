#!/usr/bin/env bash
# Scaffolds a starter risk register (CSV + Markdown) for a new program:
# example risks across each systematic lens (People/Technology/Compliance/
# Resource) pre-filled per SKILL.md steps 3-7, for the user to replace with
# real risks. Risk score is computed here (likelihood x impact), not
# hardcoded per row, so it can't drift out of sync with the two ratings.
set -euo pipefail

TITLE="New Program"
OUTPUT_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$OUTPUT_DIR"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')

# Each row: Risk | Category | Threatens | Likelihood | Impact | Mitigation | Trigger | Contingency | Owner | Status
# Likelihood/Impact are 1-5; Risk Score is computed below, not stored here.
# Single source of truth - both output formats are generated from this.
# Uses '|' as the field delimiter - none of the field text below contains one.
ROWS=(
  "Only one engineer understands the legacy integration; work stalls if they leave|People|Schedule|2|5|Document integration knowledge and cross-train a second engineer|Lead gives notice or is unavailable more than a week|Pause dependent workstreams, bring in a contractor with the documented runbook|Engineering Manager|Open"
  "Chosen vendor API is new or unproven at this scale and may not handle production load|Technology|Quality|3|4|Load-test the integration before committing to it in production|Load test fails or vendor reports scaling limits|Fall back to the previous vendor or build the capability in-house|Tech Lead|Open"
  "New data-sharing flow may not meet regulatory requirements in the affected jurisdiction|Compliance|Scope|2|5|Legal/Compliance review before scope is finalized|Legal flags a requirement not currently met|Descope the affected jurisdiction until compliant|Compliance Lead|Open"
  "This competes for the same engineering team as a higher-priority initiative|Resource|Schedule|4|3|Confirm staffing commitment with the Sponsor before kickoff|Engineering gets pulled onto a competing initiative|Re-baseline the timeline and escalate to Sponsor for a resourcing decision|Sponsor|Open"
  "Only one vendor supplies a required data feed, with no fallback source - single point of failure, flag regardless of score|Technology|Schedule|1|5|Identify and qualify a backup data source|Vendor outage or contract lapse|Manual data entry until the backup source is live|Data/Formulary Team|Open, flagged SPOF"
  "TBD, add your own risk|TBD|TBD|TBD|TBD|TBD|TBD|TBD|TBD|TBD"
)

CSV_FILE="$OUTPUT_DIR/${SLUG}-risk-register.csv"
MD_FILE="$OUTPUT_DIR/${SLUG}-risk-register.md"

split_row() {
  IFS='|' read -r -a FIELDS <<< "$1"
}

# Computes likelihood x impact when both are integers 1-5; otherwise "TBD".
risk_score() {
  local likelihood="$1" impact="$2"
  if [[ "$likelihood" =~ ^[1-5]$ && "$impact" =~ ^[1-5]$ ]]; then
    echo $((likelihood * impact))
  else
    echo "TBD"
  fi
}

{
  echo '"Risk","Category","Threatens","Likelihood","Impact","Risk Score","Mitigation","Trigger","Contingency","Owner","Status"'
  for row in "${ROWS[@]}"; do
    split_row "$row"
    score=$(risk_score "${FIELDS[3]}" "${FIELDS[4]}")
    printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' \
      "${FIELDS[0]}" "${FIELDS[1]}" "${FIELDS[2]}" "${FIELDS[3]}" "${FIELDS[4]}" "$score" "${FIELDS[5]}" "${FIELDS[6]}" "${FIELDS[7]}" "${FIELDS[8]}" "${FIELDS[9]}"
  done
} > "$CSV_FILE"

{
  echo "# Risk Register: $TITLE"
  echo
  echo "## Overview: What this page does"
  echo "- Turns \"things that could go wrong\" into a tracked, owned, scored list."
  echo "- Risks get mitigated proactively instead of becoming surprises."
  echo "- Risk Score (likelihood x impact) is computed automatically, not entered by hand."
  echo "- Starter template only - replace the example risks with real ones before treating this as authoritative."
  echo
  echo "## Best practices"
  echo "1. Replace the example risks with real ones for this program/project - use the four lenses (People, Technology, Compliance, Resource) as prompts, and map dependencies/integration points first, asking \"what if this doesn't deliver\" for each."
  echo "2. Every risk needs a concrete mitigation, a trigger, a contingency, and a named owner - a risk with no mitigation is just a complaint."
  echo "3. Flag single points of failure explicitly, regardless of their computed score - a rare-but-catastrophic risk gets under-weighted by likelihood alone."
  echo "4. Review this on a cadence, and fully re-validate every risk (not just new ones) if this pauses and restarts."
  echo
  echo "| Risk | Category | Threatens | Likelihood | Impact | Risk Score | Mitigation | Trigger | Contingency | Owner | Status |"
  echo "|---|---|---|---|---|---|---|---|---|---|---|"
  for row in "${ROWS[@]}"; do
    split_row "$row"
    score=$(risk_score "${FIELDS[3]}" "${FIELDS[4]}")
    echo "| ${FIELDS[0]} | ${FIELDS[1]} | ${FIELDS[2]} | ${FIELDS[3]} | ${FIELDS[4]} | $score | ${FIELDS[5]} | ${FIELDS[6]} | ${FIELDS[7]} | ${FIELDS[8]} | ${FIELDS[9]} |"
  done
  echo
  echo "## Legend"
  echo "- Lens: People, Technology, Compliance, Resource."
  echo "- Threatens: Scope, Schedule, or Quality."
  echo "- Risk Score: Likelihood (1-5) x Impact (1-5); single points of failure are flagged regardless of score."
} > "$MD_FILE"

echo "Wrote $CSV_FILE"
echo "Wrote $MD_FILE"
