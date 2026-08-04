#!/usr/bin/env bash
# Writes the outcome of a roadmap-prioritization pass back into Aha!: each
# feature's score and (optionally) its release assignment. This changes
# visible, shared data in Aha! - confirm the drafted changes with the user
# before running this, the same as release-notes' publish-wiki.sh.
#
# Input: a JSON file, one object per feature, produced from the
# prioritization pass (see roadmap-prioritization/template.md for the shape
# a human-readable version of this takes):
#   [{"feature": "PROD-123", "score": 3200, "release_id": "REL-456"}, ...]
#
# Requires AHA_SUBDOMAIN and AHA_API_KEY (see config.env.example / fetch
# script for where each belongs).
set -euo pipefail

INPUT_FILE=""
DRY_RUN=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input) INPUT_FILE="$2"; shift 2 ;;
    --apply) DRY_RUN=false; shift ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

: "${AHA_SUBDOMAIN:?Set AHA_SUBDOMAIN (see config.env.example)}"
: "${AHA_API_KEY:?Set AHA_API_KEY in your shell profile, not config.env}"
: "${INPUT_FILE:?Pass --input <file.json> with the prioritization results}"

BASE_URL="https://${AHA_SUBDOMAIN}.aha.io/api/v1"
AUTH_HEADER="Authorization: Bearer ${AHA_API_KEY}"

# Defaults to a dry run: prints exactly what would be sent to Aha! without
# sending it. Only actually writes when called with --apply, and this
# script should not be run with --apply until the user has explicitly
# confirmed the drafted scores/placements are correct.
COUNT=$(jq 'length' "$INPUT_FILE")
echo "Planned updates for ${COUNT} feature(s):" >&2
jq -r '.[] | "  \(.feature): score=\(.score) release=\(.release_id // "unchanged")"' "$INPUT_FILE" >&2

if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry run only, no changes sent. Re-run with --apply after the user confirms this list." >&2
  exit 0
fi

jq -c '.[]' "$INPUT_FILE" | while read -r ROW; do
  FID=$(echo "$ROW" | jq -r '.feature')
  SCORE=$(echo "$ROW" | jq -r '.score')
  RELEASE_ID=$(echo "$ROW" | jq -r '.release_id // empty')

  curl -sS -X PATCH -H "$AUTH_HEADER" -H "Content-Type: application/json" \
    -d "$(jq -n --argjson v "$SCORE" '{score: $v}')" \
    "${BASE_URL}/features/${FID}/score" > /dev/null
  echo "Updated score for ${FID}" >&2

  if [[ -n "$RELEASE_ID" ]]; then
    curl -sS -X PATCH -H "$AUTH_HEADER" -H "Content-Type: application/json" \
      -d "$(jq -n --arg v "$RELEASE_ID" '{release: {id: $v}}')" \
      "${BASE_URL}/features/${FID}/release" > /dev/null
    echo "Updated release for ${FID} to ${RELEASE_ID}" >&2
  fi
done
