#!/usr/bin/env bash
# Fetches the data needed to draft release notes: the promote PR's file-level
# diff stats, plus title/body for every constituent PR merged into it.
# Read-only - never creates, merges, or comments on anything.
set -euo pipefail

BASE="main"
HEAD="staging"
REPO=""
PR_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) BASE="$2"; shift 2 ;;
    --head) HEAD="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    --pr) PR_OVERRIDE="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
fi

if [[ -n "$PR_OVERRIDE" ]]; then
  # Explicit PR pinned by the caller - skips the newest-by-creation-date lookup below.
  PROMOTE_PR_JSON=$(gh pr view "$PR_OVERRIDE" --repo "$REPO" \
    --json number,title,body,url,mergedAt,state | jq '[.]')
else
  # The promote PR: gh pr list with no --sort returns newest-created first, so
  # --limit 1 picks the most recently created PR from HEAD into BASE, open or
  # merged. This assumes release-notes runs before the *next* promote PR gets
  # created - if that assumption ever breaks, pass --pr <number> explicitly.
  PROMOTE_PR_JSON=$(gh pr list --repo "$REPO" --base "$BASE" --head "$HEAD" \
    --state all --limit 1 \
    --json number,title,body,url,mergedAt,state)
fi

PROMOTE_PR_NUMBER=$(echo "$PROMOTE_PR_JSON" | jq -r '.[0].number // empty')

if [[ -z "$PROMOTE_PR_NUMBER" ]]; then
  echo "No PR found from $HEAD into $BASE in $REPO" >&2
  exit 1
fi

# File-level diff stats for the promote PR (paths, +/- counts) - no full patch text.
# NOTE: --jq must not be combined with --paginate here - gh applies --jq to
# each page separately, so a diff spanning multiple pages (>100 files) would
# produce several concatenated JSON arrays instead of one. Paginate raw, then
# filter the merged result in a separate jq call.
FILES_CHANGED_JSON=$(gh api "repos/$REPO/pulls/$PROMOTE_PR_NUMBER/files" --paginate \
  | jq '[.[] | {filename, status, additions, deletions}]')

# Walk the promote PR's commits and pull out any "#123" references to
# constituent PRs merged into staging, then fetch each one's title/body.
# Same --jq/--paginate caveat as above applies here.
COMMIT_MESSAGES=$(gh api "repos/$REPO/pulls/$PROMOTE_PR_NUMBER/commits" --paginate \
  | jq -r '[.[].commit.message] | join("\n")')

CONSTITUENT_NUMBERS=$(echo "$COMMIT_MESSAGES" \
  | grep -oE '#[0-9]+' | tr -d '#' | sort -un | grep -v "^${PROMOTE_PR_NUMBER}$" || true)

CONSTITUENT_PRS="[]"
for num in $CONSTITUENT_NUMBERS; do
  pr_json=$(gh pr view "$num" --repo "$REPO" \
    --json number,title,body,url,author,mergedAt 2>/dev/null || echo "")
  if [[ -n "$pr_json" ]]; then
    CONSTITUENT_PRS=$(echo "$CONSTITUENT_PRS" | jq --argjson pr "$pr_json" '. + [$pr]')
  fi
done

jq -n \
  --argjson promotePR "$(echo "$PROMOTE_PR_JSON" | jq '.[0]')" \
  --argjson filesChanged "$FILES_CHANGED_JSON" \
  --argjson constituentPRs "$CONSTITUENT_PRS" \
  '{promotePR: $promotePR, filesChanged: $filesChanged, constituentPRs: $constituentPRs}'
