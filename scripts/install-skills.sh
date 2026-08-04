#!/usr/bin/env bash
# Installs this pack's skills into a project's .claude/skills/, one symlink
# (or copy) per skill, since Claude Code only scans .claude/skills/<name>/SKILL.md
# one level deep and won't discover skills nested inside a wholesale
# ai-dlc/ or roles/ symlink.
#
# Usage:
#   scripts/install-skills.sh <target-project-dir> [options]
#
# Options:
#   --exclude <patterns>   Comma-separated glob patterns to skip (matched
#                          against skill name), e.g. --exclude "tpm-*,change-request"
#   --only <patterns>      Comma-separated glob patterns to install; skips
#                          everything else. Mutually exclusive with --exclude.
#   --copy                 Copy each skill folder instead of symlinking it.
#                          Use this if the target project is shared with
#                          people who won't have this pack checked out at
#                          the same path (symlinks would dangle for them).
#   --dry-run              Print what would happen without touching anything.
#
# Default (no --exclude/--only): installs every skill in the pack.
set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET=""
EXCLUDE=""
ONLY=""
MODE="symlink"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --exclude) EXCLUDE="$2"; shift 2 ;;
    --only) ONLY="$2"; shift 2 ;;
    --copy) MODE="copy"; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) TARGET="$1"; shift ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <target-project-dir> [--exclude patterns] [--only patterns] [--copy] [--dry-run]" >&2
  exit 1
fi
if [[ -n "$EXCLUDE" && -n "$ONLY" ]]; then
  echo "--exclude and --only are mutually exclusive" >&2
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"
SKILLS_DIR="$TARGET/.claude/skills"
mkdir -p "$SKILLS_DIR"

matches_any() {
  local name="$1" patterns="$2"
  local IFS=','
  for pat in $patterns; do
    # shellcheck disable=SC2053
    [[ "$name" == $pat ]] && return 0
  done
  return 1
}

installed=0
skipped_excluded=0
skipped_existing=0

for src in "$PACK_DIR"/ai-dlc/*/ "$PACK_DIR"/roles/dev/*/ "$PACK_DIR"/roles/product-manager/*/ "$PACK_DIR"/roles/tpm/*/; do
  [[ -f "${src}SKILL.md" ]] || continue
  name="$(basename "$src")"

  if [[ -n "$EXCLUDE" ]] && matches_any "$name" "$EXCLUDE"; then
    skipped_excluded=$((skipped_excluded + 1))
    continue
  fi
  if [[ -n "$ONLY" ]] && ! matches_any "$name" "$ONLY"; then
    skipped_excluded=$((skipped_excluded + 1))
    continue
  fi

  dest="$SKILLS_DIR/$name"
  if [[ -e "$dest" || -L "$dest" ]]; then
    echo "Skipping $name: $dest already exists (remove it yourself first if you want it replaced)" >&2
    skipped_existing=$((skipped_existing + 1))
    continue
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would $MODE: $name -> $dest"
  elif [[ "$MODE" == "copy" ]]; then
    cp -R "${src%/}" "$dest"
    echo "Copied $name"
  else
    ln -s "${src%/}" "$dest"
    echo "Linked $name"
  fi
  installed=$((installed + 1))
done

echo
echo "Done: $installed installed, $skipped_existing skipped (already present), $skipped_excluded skipped (excluded/not selected)."
