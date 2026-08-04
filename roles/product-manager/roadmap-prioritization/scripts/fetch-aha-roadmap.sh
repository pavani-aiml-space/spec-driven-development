#!/usr/bin/env bash
# Fetches the data needed to run roadmap-prioritization against Aha!:
# candidate initiatives/features for a product (or a specific release), each
# feature's current release/status/native score, its requirements
# (prerequisites) and dependencies, plus open ideas as a stakeholder-input
# source. Read-only - never creates, updates, or deletes anything in Aha!.
#
# Requires AHA_SUBDOMAIN, AHA_PRODUCT_ID (see config.env.example) and
# AHA_API_KEY set in the environment (kept out of config.env on purpose,
# see that file's comments).
#
# Field names below reflect Aha!'s documented API shape as of this writing;
# custom fields and scorecards vary per workspace, so verify against your
# own account's API docs (https://www.aha.io/api) before relying on a field
# that isn't in the standard response.
set -euo pipefail

RELEASE_ID=""
INCLUDE_IDEAS=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --release) RELEASE_ID="$2"; shift 2 ;;
    --no-ideas) INCLUDE_IDEAS=false; shift ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

: "${AHA_SUBDOMAIN:?Set AHA_SUBDOMAIN (see config.env.example)}"
: "${AHA_PRODUCT_ID:?Set AHA_PRODUCT_ID (see config.env.example)}"
: "${AHA_API_KEY:?Set AHA_API_KEY in your shell profile, not config.env}"

BASE_URL="https://${AHA_SUBDOMAIN}.aha.io/api/v1"
AUTH_HEADER="Authorization: Bearer ${AHA_API_KEY}"

aha_get() {
  curl -sS -H "$AUTH_HEADER" -H "Content-Type: application/json" "${BASE_URL}$1"
}

# Initiatives: the strategic groupings candidate features roll up to.
# Read these first so each feature below can be reported with its parent
# initiative's name, not just an ID.
echo "Fetching initiatives..." >&2
INITIATIVES_JSON=$(aha_get "/products/${AHA_PRODUCT_ID}/initiatives")

# Features: the actual candidate initiatives for this prioritization pass.
# Scope to a single release if one was given (e.g. the release representing
# this planning cycle); otherwise pull every feature for the product and let
# the strategic-gates step (SKILL.md step 2) do the filtering.
echo "Fetching features..." >&2
if [[ -n "$RELEASE_ID" ]]; then
  FEATURES_JSON=$(aha_get "/releases/${RELEASE_ID}/features")
else
  FEATURES_JSON=$(aha_get "/products/${AHA_PRODUCT_ID}/features")
fi

# Requirements (prerequisites) and dependencies per feature. These map
# directly to SKILL.md step 7 (sequence by real dependency) - a feature
# blocked on another shouldn't be scored as if it were independently
# startable.
echo "Fetching requirements and dependencies per feature..." >&2
FEATURE_IDS=$(echo "$FEATURES_JSON" | jq -r '.features[].reference_num // empty')
DETAILS_JSON="[]"
for FID in $FEATURE_IDS; do
  REQS=$(aha_get "/features/${FID}/requirements" 2>/dev/null || echo '{"requirements":[]}')
  DEPS=$(aha_get "/features/${FID}/dependencies" 2>/dev/null || echo '{"dependencies":[]}')
  DETAIL=$(jq -n --arg id "$FID" --argjson reqs "$REQS" --argjson deps "$DEPS" \
    '{feature: $id, requirements: $reqs.requirements, dependencies: $deps.dependencies}')
  DETAILS_JSON=$(echo "$DETAILS_JSON" | jq --argjson d "$DETAIL" '. + [$d]')
done

# Ideas: customer/stakeholder-submitted requests not yet promoted to a
# feature. Feeds SKILL.md step 5 (translate each stakeholder ask into the
# need behind it) directly from the source, not a secondhand summary.
IDEAS_JSON="{}"
if [[ "$INCLUDE_IDEAS" == "true" ]]; then
  echo "Fetching open ideas..." >&2
  IDEAS_JSON=$(aha_get "/products/${AHA_PRODUCT_ID}/ideas?sort=votes")
fi

jq -n \
  --argjson initiatives "$INITIATIVES_JSON" \
  --argjson features "$FEATURES_JSON" \
  --argjson details "$DETAILS_JSON" \
  --argjson ideas "$IDEAS_JSON" \
  '{initiatives: $initiatives.initiatives, features: $features.features, feature_details: $details, ideas: ($ideas.ideas // [])}'
