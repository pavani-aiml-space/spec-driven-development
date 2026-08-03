#!/usr/bin/env bash
# Files a Change Request work item in Azure DevOps, linking back to the
# already-published release-notes wiki page and the source PR.
# Requires AZDO_PAT, AZDO_ORG, AZDO_PROJECT in the environment.
# Org/project values can instead live in config.env (see
# config.env.example) - git-ignored, kept local. AZDO_PAT must never go in
# that file; it stays in your shell profile.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../config.env" ]]; then
  source "$SCRIPT_DIR/../config.env"
fi

TITLE=""
DESCRIPTION_FILE=""
WORK_ITEM_TYPE="${AZDO_CR_WORK_ITEM_TYPE:-Production Change Request}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --description-file) DESCRIPTION_FILE="$2"; shift 2 ;;
    --type) WORK_ITEM_TYPE="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

for var in AZDO_PAT AZDO_ORG AZDO_PROJECT; do
  if [[ -z "${!var:-}" ]]; then
    echo "Missing required environment variable: $var" >&2
    exit 1
  fi
done

if [[ -z "$TITLE" || -z "$DESCRIPTION_FILE" ]]; then
  echo "Usage: create-change-request.sh --title \"Production Change Request: ...\" --description-file body.html" >&2
  exit 1
fi

# Description must be HTML - ADO work item Description fields render HTML,
# not Markdown (unlike wiki pages).
PATCH_JSON=$(jq -n \
  --arg title "$TITLE" \
  --rawfile desc "$DESCRIPTION_FILE" \
  '[
    {op: "add", path: "/fields/System.Title", value: $title},
    {op: "add", path: "/fields/System.Description", value: $desc}
  ]')

ENCODED_TYPE=$(jq -rn --arg t "$WORK_ITEM_TYPE" '$t|@uri')

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -u ":${AZDO_PAT}" \
  -X POST \
  -H "Content-Type: application/json-patch+json" \
  "https://dev.azure.com/${AZDO_ORG}/${AZDO_PROJECT}/_apis/wit/workitems/\$${ENCODED_TYPE}?api-version=7.1" \
  -d "$PATCH_JSON")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" != "200" && "$HTTP_CODE" != "201" ]]; then
  echo "Change Request creation failed (HTTP $HTTP_CODE). Check AZDO_PAT has Work Items Read & Write scope, AZDO_ORG/AZDO_PROJECT are correct, and \"$WORK_ITEM_TYPE\" matches the exact work item type name in ADO." >&2
  echo "$BODY" >&2
  exit 1
fi

echo "$BODY" | jq -r '{id: .id, url: ._links.html.href}'
