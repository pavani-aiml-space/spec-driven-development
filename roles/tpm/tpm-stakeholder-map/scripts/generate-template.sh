#!/usr/bin/env bash
# Scaffolds a starter stakeholder map (CSV + Markdown) for a new program:
# standard categories and priority groups (Mendelow's Matrix) pre-filled as
# examples, per SKILL.md steps 3-6, for the user to replace with real
# stakeholders.
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

# Each row: Stakeholder/Role | Category | Objective | Power | Interest | Priority Group | Engagement Approach
# Single source of truth - both output formats are generated from this.
# Uses '|' as the field delimiter - none of the field text below contains one.
ROWS=(
  "Executive Sponsor|Sponsor/Decision-maker|Delivers measurable business value within budget and timeline|High|High|Manage Closely|Involve directly in key decisions, regular 1:1 updates"
  "Engineering Lead|Dependent team|Technical feasibility and a sustainable long-term architecture|High|High|Manage Closely|Involve directly in key decisions"
  "Legal/Compliance|Influencer, regulatory if applicable|Regulatory and legal risk identified and mitigated before launch|High|TBD, high if this is regulated|Keep Satisfied or Manage Closely|Periodic updates framed around their specific concern"
  "End Users/Customers|Customer|The problem is actually solved with minimal friction|Low|High|Keep Informed|Regular broadcast updates (release notes, in-product messaging)"
  "Support/CS Team|Operational owner|Manageable support load, a clear runbook, no surprise tickets|Low|High|Keep Informed|Regular broadcast updates, runbook handoff before launch"
  "Adjacent/Unrelated Teams|Monitor|No unexpected impact on their own roadmap or systems|Low|Low|Monitor|Check occasionally, no active management"
  "TBD, add your own stakeholder|TBD|TBD, ask them directly rather than assuming|TBD|TBD|TBD|TBD"
)

CSV_FILE="$OUTPUT_DIR/${SLUG}-stakeholder-map.csv"
MD_FILE="$OUTPUT_DIR/${SLUG}-stakeholder-map.md"

split_row() {
  IFS='|' read -r -a FIELDS <<< "$1"
}

{
  echo '"Stakeholder/Role","Category","Objective","Power","Interest","Priority Group","Engagement Approach"'
  for row in "${ROWS[@]}"; do
    split_row "$row"
    printf '"%s","%s","%s","%s","%s","%s","%s"\n' "${FIELDS[0]}" "${FIELDS[1]}" "${FIELDS[2]}" "${FIELDS[3]}" "${FIELDS[4]}" "${FIELDS[5]}" "${FIELDS[6]}"
  done
} > "$CSV_FILE"

{
  echo "# Stakeholder Map: $TITLE"
  echo
  echo "## Overview: What this page does"
  echo "- Identifies everyone who does the work, is affected by it, influences it, or is needed to support this program/project."
  echo "- Prioritizes how to engage each of them, so no key stakeholder gets discovered mid-way instead of before it starts."
  echo "- Starter template only - replace the example categories and priority groups with real stakeholders before treating this as authoritative."
  echo
  echo "## Best practices"
  echo "1. Replace the starter rows with the real stakeholders for this program/project - use the categories (customers, dependent teams, systems, sponsors, influencers, support) as prompts, not a checklist to leave as-is."
  echo "2. Fill in each stakeholder's actual objective from a real conversation, not a generic guess for their role."
  echo "3. Rate Power and Interest honestly first, then let Priority Group follow from that - don't pick the group and work backward."
  echo "4. Flag anyone high-power/high-interest who isn't engaged yet - that's the gap that causes late-stage surprises."
  echo
  echo "| Stakeholder/Role | Category | Objective | Power | Interest | Priority Group | Engagement Approach |"
  echo "|---|---|---|---|---|---|---|"
  for row in "${ROWS[@]}"; do
    split_row "$row"
    echo "| ${FIELDS[0]} | ${FIELDS[1]} | ${FIELDS[2]} | ${FIELDS[3]} | ${FIELDS[4]} | ${FIELDS[5]} | ${FIELDS[6]} |"
  done
  echo
  echo "## Legend"
  echo "- Manage Closely: high power, high interest."
  echo "- Keep Satisfied: high power, low interest."
  echo "- Keep Informed: low power, high interest."
  echo "- Monitor: low power, low interest."
} > "$MD_FILE"

echo "Wrote $CSV_FILE"
echo "Wrote $MD_FILE"
