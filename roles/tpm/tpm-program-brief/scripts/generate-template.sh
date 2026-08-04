#!/usr/bin/env bash
# Scaffolds a blank starter Program Brief (Markdown) for a new program:
# section headers with prompt placeholders per SKILL.md's Process, not
# pre-written content - the PM fills this in, this just removes the blank
# page problem.
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
OUT_FILE="$OUTPUT_DIR/${SLUG}-program-brief.md"

cat > "$OUT_FILE" << 'EOF'
# Brief: TITLE_PLACEHOLDER

## Problem & Goal
[Why does this program/project exist, and what does success look like in concrete, measurable terms?]

## Scope

### In scope
- [ ]

### Out of scope
- [ ]

## Stakeholders
- Sponsor: [TBD]
- Dependent teams: [TBD]
- Consulted: [TBD]

For systematic stakeholder discovery beyond this summary, see `tpm-stakeholder-map`.

## Timeline
- [Key milestone] - [target date, with honest uncertainty noted if not firm]

## Risks & Dependencies
- [Anything that could derail the timeline or scope - see `tpm-risk-register` for ongoing tracking beyond this summary list]
EOF

sed -i.bak "s/TITLE_PLACEHOLDER/${TITLE}/" "$OUT_FILE" && rm -f "${OUT_FILE}.bak"

echo "Wrote $OUT_FILE"
