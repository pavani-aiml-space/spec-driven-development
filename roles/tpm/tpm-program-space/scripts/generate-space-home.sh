#!/usr/bin/env bash
# Generates the Space Home landing page content (Markdown) for a new
# program space: title, one-line tagline, a link to the Program Hub, Quick
# Links, and Space Contacts. This is deliberately minimal - the detailed
# content (mission/vision/success metrics/key documents/aggregation) belongs
# on the Program Hub page, not here.
set -euo pipefail

TITLE=""
TAGLINE=""
SPACE_URL=""
SPONSOR="TBD"
LEAD="TBD"
OUTPUT_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --tagline) TAGLINE="$2"; shift 2 ;;
    --space-url) SPACE_URL="$2"; shift 2 ;;
    --sponsor) SPONSOR="$2"; shift 2 ;;
    --lead) LEAD="$2"; shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$TITLE" || -z "$TAGLINE" || -z "$SPACE_URL" ]]; then
  echo "Usage: generate-space-home.sh --title \"<Program Name>\" --tagline \"<one-liner>\" --space-url <url> [--sponsor <name>] [--lead <name>] [--output-dir <path>]" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')
OUT_FILE="$OUTPUT_DIR/${SLUG}-space-home.md"

cat > "$OUT_FILE" << EOF
# ${TITLE}

${TAGLINE}

**Go to the [Program Hub](${SPACE_URL}#)** to access mission, vision, success metrics, key documents, risks, decisions, and program status information.

## Quick Links
- [Program Hub](${SPACE_URL}#) - mission, vision, success metrics, key documents
- [Risk Register](${SPACE_URL}#) - program-level risks
- [Decision Log](${SPACE_URL}#) - open questions and regular decisions; contested ones link out to the Contested Decisions page
- [Most Recent Status Update](${SPACE_URL}#) - latest dated entry, not just the Progress Log index

## Space Contacts
- Program Sponsor: ${SPONSOR}
- Program Manager: ${LEAD}
EOF

echo "Wrote $OUT_FILE"
echo "NOTE: the four Quick Links above are placeholders pointing at the space overview - per SKILL.md's process, create the Hub and program-level docs first, then rebuild this Home content with each real webUrl from those createConfluencePage responses before publishing it."
