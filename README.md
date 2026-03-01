# upskill

Daily senior frontend/fullstack quiz powered by Claude Code. Interview-style questions with spaced repetition to keep skills sharp.

## How it works

This is a Claude Code skill. When you say `quiz me` in a session, it runs a quiz:

1. **3 questions** — senior-level, framed as interview questions. Covers React, Next.js, TypeScript, system design, security, performance, and more.
2. **Grading** — each answer scored as correct, partial, or missed with concise explanations.
3. **3 knowledge nuggets** — practical tips targeted at gaps in your history.

Missed questions come back via spaced repetition until you nail them.

## Commands

| Command | What it does |
|---|---|
| `quiz me` | Full session (3 questions + 3 nuggets) |
| `quick quiz` | Questions only, skip nuggets |
| `review` | Only re-ask missed/partial questions |
| `nuggets only` | Skip questions, just nuggets |
| `hard mode` | All questions target weak categories |
| `stats` | Show progress summary |
| `topics` | Show category coverage |
| `reset` | Clear progress and start fresh |

## Files

```
.claude/skills/fe-quiz/SKILL.md   # skill definition
.progress.json                     # quiz history (gitignored)
```

## Setup

Requires [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Clone this repo and run Claude Code from the project root — the skill is picked up automatically.
