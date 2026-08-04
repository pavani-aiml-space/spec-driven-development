#!/usr/bin/env bash
# Scaffolds a starter decision log (CSV + Markdown) for a program: one row
# per decision or open question. Regular rows carry the full record inline;
# contested rows (direct or gradual) stay stubs that point to the program's
# shared Contested Decisions page (tpm-contested-decisions) instead of duplicating its
# content. Replaces the standalone "Open Decisions & Questions" page - this
# log covers both open and decided regular items.
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

# Each row: Question | Status | Raised By | Date Raised | Options Considered | Decision | Rationale | Owner | Date Decided | Reversibility | Contested Decisions Page
ROWS=(
  "Example: which analytics library do we use?|Decided|PM|2026-07-01|Segment, Amplitude, homegrown|Amplitude|Best fit for existing data warehouse, lowest integration cost|PM|2026-07-03|Two-way door - easy to swap later|-"
  "Example: should delegate access require 90-day re-consent?|Contested - see Contested Decisions page|PM|2026-07-10|-|-|-|-|-|-|<link to Contested Decisions page>"
  "TBD, add your own decision or open question|Open|TBD|TBD|-|-|-|-|-|-|-"
)

CSV_FILE="$OUTPUT_DIR/${SLUG}-decision-log.csv"
MD_FILE="$OUTPUT_DIR/${SLUG}-decision-log.md"

split_row() {
  IFS='|' read -r -a FIELDS <<< "$1"
}

{
  echo '"Question","Status","Raised By","Date Raised","Options Considered","Decision","Rationale","Owner","Date Decided","Reversibility","Contested Decisions Page"'
  for row in "${ROWS[@]}"; do
    split_row "$row"
    printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' "${FIELDS[0]}" "${FIELDS[1]}" "${FIELDS[2]}" "${FIELDS[3]}" "${FIELDS[4]}" "${FIELDS[5]}" "${FIELDS[6]}" "${FIELDS[7]}" "${FIELDS[8]}" "${FIELDS[9]}" "${FIELDS[10]}"
  done
} > "$CSV_FILE"

{
  echo "# Decision Log: $TITLE"
  echo
  echo "## Overview: What this page does"
  echo "- One running log per program for every decision and open question - regular ones get the full record right here, contested ones get a status and a link to the program's shared \`tpm-contested-decisions\` Contested Decisions page."
  echo "- Prevents two failure modes: questions getting lost before anyone answers them, and duplicated records once a decision escalates to a contested-decisions row."
  echo "- Covers decisions and open questions across the whole program - not standing role ownership (that's \`tpm-raci\`) and not the resolution process for a genuinely contested call (that's the program's Contested Decisions page, linked from here when needed)."
  echo "- Starter template only - replace the example rows with real ones before treating this as authoritative."
  echo
  echo "## Best practices"
  echo "1. Log a question the moment it surfaces, Status = Open - don't wait until it's urgent or already answered."
  echo "2. Resolve most rows inline: fill in Options Considered (including rejected ones), Decision, Rationale, Owner, Date Decided, and Reversibility, then set Status to Decided. That's a regular decision - no contested-decisions row needed."
  echo "3. The moment a decision turns out contested (real disagreement, no clear final say, stalling), stop filling in this row - add it as a row on the program's Contested Decisions page instead (\`tpm-contested-decisions\`, scaffolding it if this is the first one), set Status here to \"Contested - see Contested Decisions page,\" and paste the link. Leave Options Considered/Decision/Rationale/Reversibility blank here; they live on that row now."
  echo "4. Some decisions are contested from the moment they're raised - skip the Open stage entirely, add it straight to the Contested Decisions page, then add a stub row here (Status = \"Contested - see Contested Decisions page\") purely so it's discoverable from the log."
  echo "5. Never fill in both this row and a Contested Decisions row for the same decision - one is always the record, the other is a pointer."
  echo "6. Delete placeholder rows before circulating."
  echo "7. Revisit Status regularly - Open rows shouldn't sit forever without at least a check-in."
  echo
  echo "| Question | Status | Raised By | Date Raised | Options Considered | Decision | Rationale | Owner | Date Decided | Reversibility | Contested Decisions Page |"
  echo "|---|---|---|---|---|---|---|---|---|---|---|"
  for row in "${ROWS[@]}"; do
    split_row "$row"
    echo "| ${FIELDS[0]} | ${FIELDS[1]} | ${FIELDS[2]} | ${FIELDS[3]} | ${FIELDS[4]} | ${FIELDS[5]} | ${FIELDS[6]} | ${FIELDS[7]} | ${FIELDS[8]} | ${FIELDS[9]} | ${FIELDS[10]} |"
  done
  echo
  echo "## Legend"
  echo "- Open: raised, not yet resolved."
  echo "- Decided: a regular decision - resolved inline, this row is the complete record."
  echo "- Contested - see Contested Decisions page: this decision needed a forcing process; the actual record lives as a row on that shared page, not in this row."
  echo "- Reversibility: one-way door (hard/expensive to undo) or two-way door (easy to change later) - only meaningful on Decided rows."
  echo
  echo "## Other notes"
  echo "**Regular vs. contested - the whole point of this log**"
  echo "- Most decisions in a program are regular: someone (often a \`tpm-raci\` Accountable owner) just decides, you log it, done."
  echo "- A decision is contested when people genuinely disagree and nobody has clear final say - that needs \`tpm-contested-decisions\`'s forcing process (a Driver, a single Approver, a deadline), not just an answer."
  echo "- Contested decisions reach the Contested Decisions page two ways: **directly** (obviously contested the moment it's raised, never sits here as Open) or **gradually** (logged here first, turns out stuck once people start working it)."
  echo "- Either way, exactly one record exists per decision at any time - this row, or the row on the Contested Decisions page - never both."
} > "$MD_FILE"

echo "Wrote $CSV_FILE"
echo "Wrote $MD_FILE"
