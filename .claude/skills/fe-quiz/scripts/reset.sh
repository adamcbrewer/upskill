#!/usr/bin/env bash
set -euo pipefail

PROGRESS="${PROGRESS_FILE:-.progress.json}"
MODE="${1:---help}"

EMPTY='{
  "version": 1,
  "sessions": [],
  "questions": [],
  "nuggets": [],
  "stats": {
    "total_sessions": 0,
    "total_questions": 0,
    "correct": 0,
    "partial": 0,
    "missed": 0,
    "categories_covered": {},
    "streak": 0,
    "last_session": null
  }
}'

case "$MODE" in
  --full)
    echo "$EMPTY" > "$PROGRESS"
    echo "Progress fully reset."
    ;;

  --stats)
    if [ ! -f "$PROGRESS" ]; then
      echo "No progress file found."
      exit 1
    fi
    if ! command -v jq &>/dev/null; then
      echo "Error: jq required"; exit 1
    fi
    jq '.stats = {
      "total_sessions": 0,
      "total_questions": 0,
      "correct": 0,
      "partial": 0,
      "missed": 0,
      "categories_covered": {},
      "streak": 0,
      "last_session": null
    }' "$PROGRESS" > "${PROGRESS}.tmp" && mv "${PROGRESS}.tmp" "$PROGRESS"
    echo "Stats reset. Questions and nuggets preserved."
    ;;

  --review)
    if [ ! -f "$PROGRESS" ]; then
      echo "No progress file found."
      exit 1
    fi
    if ! command -v jq &>/dev/null; then
      echo "Error: jq required"; exit 1
    fi
    jq '.questions |= map(.next_review = null)' "$PROGRESS" > "${PROGRESS}.tmp" && mv "${PROGRESS}.tmp" "$PROGRESS"
    echo "Review queue cleared."
    ;;

  --migrate)
    if [ ! -f "$PROGRESS" ]; then
      echo "No progress file to migrate. Run --full to create one."
      exit 1
    fi
    if ! command -v jq &>/dev/null; then
      echo "Error: jq required"; exit 1
    fi
    jq '
      .version = (.version // 1) |
      .sessions = (.sessions // []) |
      .questions = (.questions // []) |
      .nuggets = (.nuggets // []) |
      .stats.total_sessions = (.stats.total_sessions // 0) |
      .stats.total_questions = (.stats.total_questions // 0) |
      .stats.correct = (.stats.correct // 0) |
      .stats.partial = (.stats.partial // 0) |
      .stats.missed = (.stats.missed // 0) |
      .stats.categories_covered = (.stats.categories_covered // {}) |
      .stats.streak = (.stats.streak // 0) |
      .stats.last_session = (.stats.last_session // null)
    ' "$PROGRESS" > "${PROGRESS}.tmp" && mv "${PROGRESS}.tmp" "$PROGRESS"
    echo "Progress file migrated. Missing fields added with defaults."
    ;;

  --help|*)
    echo "Usage: reset.sh [--full|--stats|--review|--migrate]"
    echo ""
    echo "  --full     Reset everything (fresh start)"
    echo "  --stats    Reset stats only, keep question/nugget history"
    echo "  --review   Clear the review queue"
    echo "  --migrate  Add missing schema fields with defaults"
    ;;
esac
