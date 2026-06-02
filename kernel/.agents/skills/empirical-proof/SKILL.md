---
name: empirical-proof
description: Back every claim with verbatim pasted output. ALWAYS apply this skill on any task that writes code, runs validations, runs benchmarks, or makes verifiable claims about behaviour — every claim in `## Self-review` gets its own pasted command output. Do not paraphrase results, summarise with "✅ all passing", or trust upstream pasted output (re-run yourself when reviewing). Skip this skill only for tasks with no verifiable claims (rare for product-development work; surface as a blocker if you suspect this applies).
---

# Skill: empirical-proof

## Purpose

Eliminate hallucinated completion. Coding agents are pattern-completers; the pattern of "successful task" includes confident-sounding completion language ("✅ all tests pass") that the agent will produce regardless of whether the underlying claim is true. Empirical proof is the structural defence: the agent cannot complete the pattern without first pasting evidence the pattern is true.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`, plus an optional dep-validation command (architectural-rules check) not in the standard contract; ask the user if the project uses one. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before pasting any "verification output" — do not guess.

## Core rules

### 1. Never assume success

Writing the code is 10% of the job. Verifying it works in *the current environment* is 90%. The agent does not get to assume the test command's output without running it.

### 2. Verbatim pasting

When filling out `## Self-review`, paste the *verbatim* output. No paraphrasing, no summarising, no "✅ passing". Use a fenced code block. Include the last two lines (or more if asked) — the runner's summary plus its timing/exit conditions.

### 3. One verification per claim

Each claim in the task — "the build passes", "the tests pass", "the linter is clean", "no architectural violations", "the migration covers all callsites" — gets its own pasted verification. Bundling claims into a single "all good" hides which check actually ran.

### 4. Re-run after every change

Verifications go stale fast. If the agent makes a change after the verification, the verification is invalid. Re-run and re-paste. This is especially load-bearing during refactor and migration tasks where the *every-N-files* validation rule fires repeatedly.

### 5. Run yourself; do not trust upstream

When reviewing another agent's branch, run the project's validation and test commands *yourself*, in your own worktree, with the worker's branch checked out. The worker's pasted output does not satisfy the review gate — only your *own* run does.

### 6. Paste, don't quote

Use raw fenced code blocks for output. Do not transform the output (no quoting, no Markdown styling, no annotation in the middle of the paste). Treat the output as data: copy it in, leave it alone.

## What proof looks like

### ✅ Good — verbatim pasted output

````markdown
- `npm test` (last 2 lines):

  ```
  ✓ 247 files passed
  Done in 12.4s
  ```

- `npx jest` (last 2 lines):

  ```
  Tests:       189 passed, 189 total
  Time:        4.832 s
  ```
````

### ❌ Bad — paraphrased

```markdown
- Validation (last 2 lines): Everything passes ✅
- Tests (last 2 lines): All 189 tests green
```

The paraphrase is *plausible*. It might even be *true*. But treat it as unverified — paraphrase doesn't satisfy the gate.

## What does not belong

- Self-review answers without supporting verification. Every claim about behaviour traces to a pasted output.
- "Should pass" / "expected to work" / "tests should be green" language. These are predictions, not proof.
- A single "all good" entry covering multiple verifications. Each verification gets its own paste.

## Anti-patterns

- "Tests pass; trust me"
- Pasting the *first* two lines instead of the last two (the gate asks for the *summary*)
- Re-using a stale verification output (run before a change; pasting after)
- Trusting the worker's pasted output instead of running yourself (in review tasks)
- Skipping the verification because "the diff is obviously correct"

## Common evasions and the response

The three most frequent evasions are inline below. The full catalogue lives at [`references/evasions.md`](./references/evasions.md) — pull it up if a different evasion surfaces in conversation.

| 🚩 Evasion                                         | Response                                                |
| -------------------------------------------------- | ------------------------------------------------------- |
| "I already ran it earlier in the session."         | Re-run after every change. The earlier run is stale.    |
| "It's obvious from the diff that the test passes." | Diff doesn't run tests. Run the tests; paste the output.|
| "The CI will catch it."                            | The discipline is the agent's gate, not the CI's.       |

## Type-specific applications

The empirical-proof discipline is universal, but each task type emphasises different proofs:

- **Refactor:** per-checkpoint dependency-validation output (every 10 files).
- **Migration:** per-wave validation and test output.
- **Performance:** baseline + target benchmark output under the *same* protocol.
- **Bug-report:** the bug actually firing (reproduction output).
- **Testing:** test pass + assertion-flip proof.
- **Documentation:** every code example actually run.

## Bundled resources

- [`references/evasions.md`](./references/evasions.md) — the full catalogue of common evasions and their responses (the body keeps the top three inline; the rest live here).
