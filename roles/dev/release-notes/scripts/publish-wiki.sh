#!/usr/bin/env bash
# Publishes a drafted release-notes page to the Azure DevOps wiki.
# Creates a new page each run - never overwrites a prior release's page.
# Requires AZDO_PAT, AZDO_ORG, AZDO_PROJECT, AZDO_WIKI_ID in the environment.
# Org/project/wiki values can instead live in config.env (see
# config.env.example) - git-ignored, kept local. AZDO_PAT must never go in
# that file; it stays in your shell profile.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../config.env" ]]; then
  source "$SCRIPT_DIR/../config.env"
fi

TITLE=""
CONTENT_FILE=""
PATH_PREFIX="${AZDO_RELEASE_WIKI_PATH_PREFIX:-Product Management/Releases}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --content-file) CONTENT_FILE="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

for var in AZDO_PAT AZDO_ORG AZDO_PROJECT AZDO_WIKI_ID; do
  if [[ -z "${!var:-}" ]]; then
    echo "Missing required environment variable: $var" >&2
    exit 1
  fi
done

if [[ -z "$TITLE" || -z "$CONTENT_FILE" ]]; then
  echo "Usage: publish-wiki.sh --title \"[Jul 28] Release Notes\" --content-file notes.md" >&2
  exit 1
fi

PAGE_PATH="${PATH_PREFIX}/${TITLE}"
ENCODED_PATH=$(jq -rn --arg p "$PAGE_PATH" '$p|@uri')

CONTENT_JSON=$(jq -n --rawfile c "$CONTENT_FILE" '{content: $c}')

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -u ":${AZDO_PAT}" \
  -X PUT \
  -H "Content-Type: application/json" \
  "https://dev.azure.com/${AZDO_ORG}/${AZDO_PROJECT}/_apis/wiki/wikis/${AZDO_WIKI_ID}/pages?path=${ENCODED_PATH}&api-version=7.1" \
  -d "$CONTENT_JSON")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" != "200" && "$HTTP_CODE" != "201" ]]; then
  echo "Wiki publish failed (HTTP $HTTP_CODE). Check AZDO_PAT has Wiki Read & Write scope, and AZDO_ORG/AZDO_PROJECT/AZDO_WIKI_ID are correct." >&2
  echo "$BODY" >&2
  exit 1
fi

echo "$BODY" | jq -r '{path: .path, url: .remoteUrl}'
