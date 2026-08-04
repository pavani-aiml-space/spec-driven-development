#!/usr/bin/env bash
# Creates a Confluence space for a program. Read-write, but idempotent-ish:
# if a space with this key already exists, reports its URL instead of
# failing, so re-running this doesn't error on a program already set up.
# Requires CONFLUENCE_SITE, CONFLUENCE_EMAIL, CONFLUENCE_API_TOKEN in the
# environment. Non-secret site/email can instead live in config.env (see
# config.env.example) - git-ignored, kept local. CONFLUENCE_API_TOKEN must
# never go in that file; it stays in your shell profile.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../config.env" ]]; then
  source "$SCRIPT_DIR/../config.env"
fi

KEY=""
NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --key) KEY="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

for var in CONFLUENCE_SITE CONFLUENCE_EMAIL CONFLUENCE_API_TOKEN; do
  if [[ -z "${!var:-}" ]]; then
    echo "Missing required environment variable: $var" >&2
    exit 1
  fi
done

if [[ -z "$KEY" || -z "$NAME" ]]; then
  echo "Usage: create-space.sh --key <SPACEKEY> --name \"<Program Name>\"" >&2
  exit 1
fi

BASE_URL="https://${CONFLUENCE_SITE}/wiki"

# Check if the space already exists first, to keep this safely re-runnable.
EXISTING=$(curl -s -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
  "${BASE_URL}/rest/api/space/${KEY}")

if echo "$EXISTING" | jq -e '.key' >/dev/null 2>&1; then
  echo "Space '$KEY' already exists."
  jq -n --arg url "${BASE_URL}/spaces/${KEY}" '{key: "'"$KEY"'", url: $url, alreadyExisted: true}'
  exit 0
fi

BODY=$(jq -n --arg key "$KEY" --arg name "$NAME" \
  '{key: $key, name: $name, description: {plain: {value: ("Program space for " + $name), representation: "plain"}}}')

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
  -X POST \
  -H "Content-Type: application/json" \
  "${BASE_URL}/rest/api/space" \
  -d "$BODY")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESP_BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" != "200" && "$HTTP_CODE" != "201" ]]; then
  echo "Space creation failed (HTTP $HTTP_CODE). Check CONFLUENCE_API_TOKEN is valid, and that '$KEY' isn't already taken by a different space." >&2
  echo "$RESP_BODY" >&2
  exit 1
fi

echo "$RESP_BODY" | jq -r '{key: .key, url: ("'"$BASE_URL"'/spaces/" + .key)}'
