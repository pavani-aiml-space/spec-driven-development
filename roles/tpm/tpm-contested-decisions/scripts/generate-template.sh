#!/usr/bin/env bash
# Scaffolds a starter Contested Decisions page (CSV + Markdown) for a
# program: one page, one row per contested decision - not one page per
# decision. Mirrors tpm-raci's row-per-item table, with D/A/C/I as columns
# instead of R/A/C/I. New contested decisions get added as rows by editing
# the page directly, the same way tpm-raci/decision-log rows get added -
# this script only scaffolds the starter page, once.
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

# Each row: Question | Driver | Approver | Contributors | Informed | Deadline | Status | Decision | Rationale | Options Considered | Reversibility | Date Decided
ROWS=(
  "Example: does a delegate need to re-confirm consent every 90 days, or is one-time consent valid until revoked?|Product Manager|Compliance Lead|Legal, Engineering Lead, Design Lead|Sponsor, Support Lead, Security Lead|2026-08-08|Decided|One-time consent, valid until explicitly revoked, with a mandatory annual reminder notification|Regulatory counsel confirmed 90-day re-confirmation isn't required for this data category; an annual reminder balances awareness against re-consent fatigue|90-day re-confirmation, one-time with no reminder, one-time with annual reminder|Two-way door - policy can be revised if compliance guidance changes|2026-07-30"
  "TBD, add your own contested decision|TBD|TBD|TBD|TBD|TBD|Open|-|-|-|-|-"
)

CSV_FILE="$OUTPUT_DIR/${SLUG}-contested-decisions.csv"
MD_FILE="$OUTPUT_DIR/${SLUG}-contested-decisions.md"

split_row() {
  IFS='|' read -r -a FIELDS <<< "$1"
}

{
  echo '"Question","Driver","Approver","Contributors","Informed","Deadline","Status","Decision","Rationale","Options Considered","Reversibility","Date Decided"'
  for row in "${ROWS[@]}"; do
    split_row "$row"
    printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' "${FIELDS[0]}" "${FIELDS[1]}" "${FIELDS[2]}" "${FIELDS[3]}" "${FIELDS[4]}" "${FIELDS[5]}" "${FIELDS[6]}" "${FIELDS[7]}" "${FIELDS[8]}" "${FIELDS[9]}" "${FIELDS[10]}" "${FIELDS[11]}"
  done
} > "$CSV_FILE"

{
  echo "# Contested Decisions: $TITLE"
  echo
  echo "## Overview: What this page does"
  echo "- One table per program for every **contested** decision - the exception, not the default. Regular decisions live in \`decision-log\`; this page exists so a contested one gets a real process (Driver, Approver, deadline) instead of being argued out inline or losing track of who has final say."
  echo "- Each row is one decision. D/A/C/I names the roles: Driver runs the process, Approver has final say, Contributors give input, Informed are told after."
  echo "- A decision lands here two ways: **directly** (obviously contested the moment it's raised - add it straight here) or **gradually** (a \`decision-log\` row turns out stuck once people start working it, and graduates here)."
  echo "- One page per program, not one page per decision - new contested decisions get added as new rows by editing this page directly, the same way \`tpm-raci\` rows get added. This script only scaffolds the starter page."
  echo "- Starter template only - replace the example row with real ones before treating this as authoritative."
  echo
  echo "## Best practices"
  echo "1. Write each Question as a specific decision with a clear set of possible answers (yes/no, A/B/C) - not a vague topic like \"figure out our approach to X.\""
  echo "2. Exactly one Approver per row, kept distinct from the Driver wherever possible, so the person facilitating the discussion isn't also the loudest vote in the room."
  echo "3. Set a real Deadline - an undated row just becomes another standing debate that never resolves."
  echo "4. Keep Contributors to people with actual subject-area knowledge - a long Contributors list slows the Driver down without improving the call."
  echo "5. Once decided, fill in Decision, Rationale, Options Considered (including the ones rejected), and Reversibility, then set Status to Decided - don't leave a settled row marked Open."
  echo "6. If a row falls inside an existing \`tpm-raci\` row's scope, check the Approver against that row's Accountable owner before finalizing - see Other notes."
  echo "7. Communicate the decision to everyone in Informed, plus anyone materially affected who wasn't already in the loop."
  echo "8. If this row graduated from \`decision-log\`, go back and update that row's Status to point here instead of leaving it Open there too."
  echo "9. Delete the placeholder row before circulating."
  echo
  echo "| Question | Driver | Approver | Contributors | Informed | Deadline | Status | Decision | Rationale | Options Considered | Reversibility | Date Decided |"
  echo "|---|---|---|---|---|---|---|---|---|---|---|---|"
  for row in "${ROWS[@]}"; do
    split_row "$row"
    echo "| ${FIELDS[0]} | ${FIELDS[1]} | ${FIELDS[2]} | ${FIELDS[3]} | ${FIELDS[4]} | ${FIELDS[5]} | ${FIELDS[6]} | ${FIELDS[7]} | ${FIELDS[8]} | ${FIELDS[9]} | ${FIELDS[10]} | ${FIELDS[11]} |"
  done
  echo
  echo "## Legend"
  echo "- Driver (D): runs the process - gathers input, sets the timeline, keeps it moving toward a resolution. Does not necessarily have final say."
  echo "- Approver (A): exactly one person with final authority on this decision."
  echo "- Contributors (C): give input and expertise before the decision is made; a voice, not a vote."
  echo "- Informed (I): told the outcome afterward; not involved in making it."
  echo "- Status: Open (still being worked) or Decided (Decision/Rationale/Options Considered/Reversibility/Date Decided are filled in)."
  echo
  echo "## Other notes"
  echo "**Long-form rationale**"
  echo "- If a decision needs more than a table cell can hold - a real design doc, a long write-up - link out to it from the Rationale cell rather than expanding this row indefinitely. The row stays the index; the deep detail can live elsewhere."
  echo
  echo "**Contested vs. RACI - avoiding an authority collision**"
  echo "- Once a row is decided, the resulting work should be staffed and tracked in a \`tpm-raci\` matrix, not on this page."
  echo "- If a row falls inside an existing RACI's scope, its Approver should be the same person as that RACI row's Accountable/DRI, or an explicit, documented delegate. A different, unreconciled Approver isn't a second valid owner - it's an authority collision, and it means one of the two pages is wrong."
  echo
  echo "**This page replaces the decision-log entry for these rows - don't write both**"
  echo "- \`decision-log\` and this page are both per-decision records, and once Status is Decided a row here already has everything a log entry needs: context, options considered, the choice, rationale, owner (Approver), date, reversibility."
  echo "- Don't also create a \`decision-log\` entry for a decision that's a row here - that's a duplicate record, and the two will drift. The log row (if one exists from the gradual path) just links to this page instead."
  echo "- Reserve \`decision-log\` entries for regular decisions that were never contested and so never needed a row here."
} > "$MD_FILE"

echo "Wrote $CSV_FILE"
echo "Wrote $MD_FILE"
