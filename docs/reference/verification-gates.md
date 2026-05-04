# 📖 Reference: Verification gates

> The named gate slots and when each fires. The gates are *what the framework names*; the *commands* are project-bound (see [`template-placeholders.md`](template-placeholders.md)).

---

## 🚦 Gate phases

| Phase                   | When it fires                                                |
| ----------------------- | ------------------------------------------------------------ |
| **Pre-implementation**  | Before the agent edits code                                  |
| **Periodic**            | At checkpoints during execution (e.g., every 10 files)       |
| **Post-implementation** | After all changes                                            |
| **Self-review**         | At task close, pasted into the hard gate                     |

---

## 🌐 Universal gates (every code-producing task)

These slots are present on every task that produces code:

| Slot                | Phase                           | Purpose                                               |
| ------------------- | ------------------------------- | ----------------------------------------------------- |
| `git-status`        | post-implementation, self-review | Only intended files changed; no orphans              |
| `{{cmdLint}}`       | post-implementation             | Lint passes                                           |
| `{{cmdFormat}}`     | post-implementation             | Format check passes                                   |
| `{{cmdTypecheck}}`  | post-implementation             | Static analysis passes                                |
| `{{cmdValidate}}`   | post-implementation, periodic   | Catch-all check (often = lint + format + typecheck)   |

A repo that lacks a particular gate (e.g., no architectural validation tooling) marks the slot `n/a` with a one-line justification rather than silently skipping it.

---

## 💻 Code-producing tasks add

| Slot                  | Phase                           | Tasks                                            |
| --------------------- | ------------------------------- | ------------------------------------------------ |
| `{{cmdTest}}`         | post-implementation, self-review | feature, fix, refactor, rewrite, migration, performance, testing, integration |
| `{{cmdValidateDeps}}` | post + periodic (refactor, migration) | refactor (every 10 files), migration (per wave), `n/a` if no architectural validator |
| `{{cmdBuild}}`        | post                            | upgrade (always), feature (where applicable)     |

---

## 🟨 Performance tasks add

| Slot                | Phase            | Purpose                                                              |
| ------------------- | ---------------- | -------------------------------------------------------------------- |
| `{{cmdBenchmark}}`  | pre (baseline)   | Establish baseline measurement                                        |
| `{{cmdBenchmark}}`  | post (target)    | Verify target hit under same protocol                                 |
| `benchmark-comparison` | self-review   | Verify improvement on targeted metric, no regression elsewhere       |

---

## 🟫 Migration tasks add

| Slot                       | Phase              | Purpose                                                       |
| -------------------------- | ------------------ | ------------------------------------------------------------- |
| `{{cmdValidate}}` per wave | periodic (per wave) | Codebase compiles and passes tests after each wave           |
| `migration-coverage-check` | self-review       | Every callsite listed in the plan was visited                |
| `grep <old-api>`           | self-review       | Zero callsites of the old API remaining outside of shims     |

---

## 🟥 Bug-fix tasks add

| Slot                | Phase                | Purpose                                                            |
| ------------------- | -------------------- | ------------------------------------------------------------------ |
| `regression-test`   | post-implementation  | Test for the specific defect; fails before fix, passes after       |
| `git diff --stat`   | self-review          | Show the patch's shape; help the Skeptic re-review                |

---

## 🟩 Test-authoring tasks add

| Slot                    | Phase            | Purpose                                                            |
| ----------------------- | ---------------- | ------------------------------------------------------------------ |
| `assertion-flip-proof`  | self-review      | Each new test fires when its assertion is flipped (proves it tests something) |

---

## 🟦 Spike (folded into research-writing) replaces with

| Slot                       | Phase            | Purpose                                                            |
| -------------------------- | ---------------- | ------------------------------------------------------------------ |
| `{{cmdLint}}`              | post             | (Spike code is throwaway; only lint matters)                       |
| `{{cmdTypecheck}}`         | post             |                                                                    |
| `report-completeness`      | self-review      | The spike report answers the question                              |

(The framework folds spike work into `research-writing`; see [`tasks/research-writing.md`](../tasks/research-writing.md).)

---

## 📚 Doc-producing tasks use

For research-writing, audit-writing, spec-writing, bug-report-writing, deepen-audit, review, documentation:

| Slot                   | Phase            | Purpose                                                         |
| ---------------------- | ---------------- | --------------------------------------------------------------- |
| `git status`           | post + self-review | Verify read-only constraint (no source/config changes)        |
| `{{cmdMarkdownLint}}`  | post (if doc-linting applies) | Markdown style                                  |
| `{{cmdLinkCheck}}`     | post             | Doc links resolve                                                |
| `{{cmdCitationCheck}}` | post (research-writing only) | Every claim sources a primary                  |

---

## 🟧 Orchestration adds

| Slot                                | Phase                        | Purpose                                                         |
| ----------------------------------- | ---------------------------- | --------------------------------------------------------------- |
| Per-worker `{{cmdValidate}}` (run by Lead Engineer) | per-worker review pass | Validation that the Lead Engineer ran themselves, not the worker |
| Per-worker `{{cmdTest}}` (run by Lead Engineer)     | per-worker review pass | Same                                                           |
| Final merged-branch `{{cmdValidate}}` and `{{cmdTest}}` | post                  | Integrated validation; per-worker validation isn't enough       |
| Merge log                           | self-review                  | Order, conflicts, resolutions                                   |

---

## 🛡️ The hard gate

Every Self-review section in every task template includes:

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. An unanswered question is a skipped check.

The hard gate is the framework's structural defence against hallucinated completion. The agent cannot mark `status: done` without filling in every `[Paste output]` placeholder with verbatim verification output.

See [`concepts/09-empirical-proof.md`](../concepts/09-empirical-proof.md) and [`skills/empirical-proof.md`](../skills/empirical-proof.md).

---

## 🧯 When a gate can't be run

If the agent legitimately can't produce a verification (env issue, missing tool, hardware unavailable):

```markdown
- `{{cmdValidateDeps}}` (last 2 lines):

  > **Could not run** — `dependency-cruiser` not installed in this worktree.
  > See `## Blockers` for follow-up.
```

And in `## Blockers`:

```markdown
- `{{cmdValidateDeps}}` not runnable — `dependency-cruiser` missing. Either install
  it (preferred) or mark the slot `n/a` for this task type with a one-line justification.
```

The blocker is real and visible; the gate isn't bypassed silently.

---

## See also

- [`template-placeholders.md`](template-placeholders.md) — the placeholder contract
- [`flow-graph.md`](flow-graph.md) — the per-task-type gate-firing table
- [`concepts/09-empirical-proof.md`](../concepts/09-empirical-proof.md)
- [`skills/empirical-proof.md`](../skills/empirical-proof.md)
