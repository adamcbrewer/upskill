# upskill

Daily senior frontend/fullstack quiz powered by Claude Code. Interview-style questions with spaced repetition to keep skills sharp.

## Getting Started

1. **Clone & enter the repo**
   ```bash
   git clone <repo-url> && cd upskill
   ```

2. **Copy the topic pool**
   ```bash
   cp .topics.example.yml .topics.yml
   ```

3. **Customize your topics** — open `.topics.yml` and adjust weights (1-5) to focus on your weak areas. Add or remove sub-topics as needed. This file is gitignored so it's personal to you.

4. **Start a quiz** — open Claude Code in the project root and say `quiz me`.

That's it. Progress is tracked in `.progress.json` (also gitignored).

## How it works

This is a Claude Code skill. When you say `quiz me` in a session, it runs a quiz:

1. **3 questions** — senior-level, framed as interview questions. Topics pulled from your personal `.topics.yml`.
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
.claude/skills/fe-quiz/
├── SKILL.md                    # skill definition
└── scripts/
    ├── stats.sh                # parse progress → readable stats
    └── reset.sh                # reset / migrate progress data
.topics.example.yml             # default topic pool (committed, copy this)
.topics.yml                     # your personal topic pool (gitignored)
.progress.json                  # quiz history & stats (gitignored)
```

## Topic Pool

Each dev maintains their own `.topics.yml` with weighted categories and sub-topics:

```yaml
topics:
  react:
    weight: 5          # 1-5, higher = quizzed more often
    subtopics:
      - Server Components (RSC) patterns
      - Suspense & streaming SSR
      - custom hooks design patterns
  typescript:
    weight: 3
    subtopics:
      - generics & generic constraints
      - satisfies operator vs type annotation
```

Bump the weight on categories you want to drill. Drop it on stuff you've got covered.

## Scripts

Requires `jq` (`sudo apt install jq`).

```bash
# view your stats
bash .claude/skills/fe-quiz/scripts/stats.sh

# reset everything
bash .claude/skills/fe-quiz/scripts/reset.sh --full

# reset stats only, keep question history
bash .claude/skills/fe-quiz/scripts/reset.sh --stats

# clear review queue
bash .claude/skills/fe-quiz/scripts/reset.sh --review

# fix missing fields after schema changes
bash .claude/skills/fe-quiz/scripts/reset.sh --migrate
```

## Setup

Requires [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Clone this repo and run Claude Code from the project root — the skill is picked up automatically.
