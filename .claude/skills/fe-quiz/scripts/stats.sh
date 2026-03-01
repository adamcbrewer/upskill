#!/usr/bin/env bash
set -euo pipefail

PROGRESS="${1:-.progress.json}"

if [ ! -f "$PROGRESS" ]; then
  echo "No progress file found at $PROGRESS"
  echo "Run a quiz session first to generate one."
  exit 0
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install with: sudo apt install jq"
  exit 1
fi

echo "==============================="
echo " FE Quiz Progress"
echo "==============================="
echo ""

total_sessions=$(jq '.stats.total_sessions // 0' "$PROGRESS")
streak=$(jq '.stats.streak // 0' "$PROGRESS")
last=$(jq -r '.stats.last_session // "never"' "$PROGRESS")
echo "Sessions: $total_sessions | Streak: $streak | Last: $last"
echo ""

total_q=$(jq '.stats.total_questions // 0' "$PROGRESS")
correct=$(jq '.stats.correct // 0' "$PROGRESS")
partial=$(jq '.stats.partial // 0' "$PROGRESS")
missed=$(jq '.stats.missed // 0' "$PROGRESS")

if [ "$total_q" -gt 0 ]; then
  correct_pct=$((correct * 100 / total_q))
  partial_pct=$((partial * 100 / total_q))
  missed_pct=$((missed * 100 / total_q))
else
  correct_pct=0
  partial_pct=0
  missed_pct=0
fi

echo "Questions: $total_q total"
echo "  correct: $correct ($correct_pct%)"
echo "  partial: $partial ($partial_pct%)"
echo "  missed:  $missed ($missed_pct%)"
echo ""

echo "Category Coverage:"
jq -r '
  .stats.categories_covered // {} |
  to_entries |
  sort_by(-.value) |
  .[] |
  "  \(.key): \(.value)"
' "$PROGRESS"
echo ""

review_count=$(jq '[.questions[] | select(.next_review != null)] | length' "$PROGRESS")
if [ "$review_count" -gt 0 ]; then
  echo "Review Queue ($review_count):"
  jq -r '
    .questions[] |
    select(.next_review != null) |
    "  \(.id): \(.category) — \(.question) (due: session \(.next_review))"
  ' "$PROGRESS"
else
  echo "Review Queue: empty"
fi
echo ""

nugget_count=$(jq '.nuggets | length' "$PROGRESS")
echo "Nuggets Delivered: $nugget_count"

if jq -e '.preferences' "$PROGRESS" &>/dev/null; then
  echo ""
  echo "Preferences:"
  jq -r '.preferences | to_entries[] | "  \(.key): \(.value)"' "$PROGRESS"
fi
