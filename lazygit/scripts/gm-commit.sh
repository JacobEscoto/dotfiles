#!/usr/bin/env bash

set -e

if ! command -v gum >/dev/null 2>&1; then
  echo "[ERROR] Gum is not installed."
  exit 1
fi

TYPE=$(gum choose "feat" "fix" "docs" "style" "refactor" "test" "chore" "perf")

SCOPE=$(gum input --placeholder "Affected scope (optional)")
if [ -n "$SCOPE" ]; then
  SCOPE="($SCOPE)"
fi

SUMMARY=$(gum input --placeholder "Short summary...")

if [ -z "$SUMMARY" ]; then
  echo "Cancelled commit"
  exit 0
fi

COMMIT_MSG="${TYPE}${SCOPE}: ${SUMMARY}"

git commit -m "$COMMIT_MSG"
