---
name: empirical-proof
description: Load for any task that writes code, runs validations, runs benchmarks, or otherwise produces verifiable claims. Enforces "Show, Don't Tell" — every claim in `## Self-review` is backed by verbatim pasted command output, not paraphrased.
---

# Skill: empirical-proof

## Purpose

Eliminate hallucinated completion. Coding agents are pattern-completers; the pattern of "successful task" includes confident-sounding completion language ("✅ all tests pass") that the agent will produce regardless of whether the underlying claim is true. Empirical proof is the structural defence: the agent cannot complete the pattern without first pasting evidence the pattern is true.

## Core rules

### Rule 1: Never assume success

Writing the code is 10% of the job. Verifying it works in *the current environment* is 90%. The agent does not get to assume the test command's output without running it.

### Rule 2: Verbatim pasting

When filling out `## Self-review`, paste the *verbatim* output. No paraphrasing, no summarising, no "✅ passing". Use a fenced code block. Include the last two lines (or more if asked) — the runner's summary plus its timing/exit conditions.

### Rule 3: One verification per claim

Each claim in the task — "the build passes", "the tests pass", "the linter is clean", "no architectural violations", "the migration covers all callsites" — gets its own pasted verification. Bundling claims into a single "all good" hides which check actually ran.

### Rule 4: Re-run after every change

Verifications go stale fast. If the agent makes a change after the verification, the verification is invalid. The agent re-runs and re-pastes. This is especially load-bearing during refactor and migration tasks where the *every-N-files* validation rule fires repeatedly.

### Rule 5: Run yourself; do not trust upstream

When the Skeptic reviews a worker's branch, the Skeptic runs `{{cmdValidate}}` and `{{cmdTest}}` *themselves*, in their own worktree, with the worker's branch checked out. The worker's pasted output does not satisfy the Skeptic's gate — only the Skeptic's *own* run does.

### Rule 6: Paste, don't quote

Use raw fenced code blocks for output. Do not transform the output (no quoting, no Markdown styling, no annotation in the middle of the paste). Treat the output as data: copy it in, leave it alone.

## What proof looks like

### ✅ Good — verbatim pasted output

````markdown
- `{{cmdValidate}}` (last 2 lines):

  ```
  ✓ 247 files passed
  Done in 12.4s
  ```

- `{{cmdTest}}` (last 2 lines):

  ```
  Tests:       189 passed, 189 total
  Time:        4.832 s
  ```
````

### ❌ Bad — paraphrased

```markdown
- `{{cmdValidate}}` (last 2 lines): Everything passes ✅
- `{{cmdTest}}` (last 2 lines): All 189 tests green
```

The paraphrase is *plausible*. It might even be *true*. But the framework treats it as unverified — paraphrase doesn't satisfy the gate.

## What does not belong

- Self-review answers without supporting verification. Every claim about behaviour traces to a pasted output.
- "Should pass" / "expected to work" / "tests should be green" language. These are predictions, not proof.
- A single "all good" entry covering multiple verifications. Each verification gets its own paste.

## Anti-patterns

- "Tests pass; trust me"
- Pasting the *first* two lines instead of the last two (the framework asks for the *summary*)
- Re-using a stale verification output (run before a change; pasting after)
- Trusting the worker's pasted output instead of running yourself (in review tasks)
- Skipping the verification because "the diff is obviously correct"

## Common evasions and the framework's response

| 🚩 Evasion                                                                  | Response                                                                          |
| -------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| "The output is too long to paste."                                         | The framework asks for the last 2 lines, not the whole log.                      |
| "I already ran it earlier in the session."                                 | Re-run after every change. The earlier run is stale.                             |
| "It's obvious from the diff that the test passes."                         | Diff doesn't run tests. Run the tests; paste the output.                         |
| "The CI will catch it."                                                    | The framework's discipline is the agent's gate, not the CI's.                    |
| "It would slow down the session."                                          | The session's value is correctness, not speed.                                   |
| "I'm reviewing in good faith — pasting is performative."                   | The framework treats trust as a vulnerability to remove, not a virtue.           |
| "The test command failed for environmental reasons unrelated to my changes." | Surface the env issue in `## Blockers`. Do not silently mark the task complete. |

## Type-specific applications

The empirical-proof discipline is universal, but each task type emphasises different proofs (see `docs/agents/05-flow-graph.md` for the per-task table):

- **Refactor:** per-checkpoint `{{cmdValidateDeps}}` (every 10 files)
- **Migration:** per-wave `{{cmdValidate}}` and `{{cmdTest}}`
- **Performance:** baseline + target `{{cmdBenchmark}}` under the *same* protocol
- **Bug-report:** the bug actually firing (reproduction output)
- **Testing:** test pass + assertion-flip proof
- **Documentation:** every code example actually run

## See also

- `.agents/skills/adversarial-review/SKILL.md` — the Skeptic's "run yourself" rule
- `.agents/skills/personas/SKILL.md` — every persona's empirical proofs section
- `docs/agents/04-standards.md` — the Self-review hard-gate convention
