# Code-implementation skills — framework reference (not in the starter kit)

These are the **implement-side** skills. Per [ADR-0051](././adrs/0051-complete-the-spec-repo-pivot.md) they
are **not** bundled in the spec-repo starter kit — a docs/spec repo never runs the `implement` step, so
shipping them there would be dead weight. They live here as **framework reference**.

A **code repo stays pristine** and works from a self-legible spec (the spec is the interface). The **one**
optional skill it may copy is **[`implement-and-verify/`](implement-and-verify/)** — the trust backbone for
running agents in parallel worktrees (implement only the assigned obligation; prove each with its `VERIFY BY`;
the PR is the trace). A developer who wants more conditioning can lift a specific guide or code persona from
here, but nothing here is shipped or required.

## Contents

- **Per-kind `implement` guides:** `write-feature/`, `write-fix/`, `write-refactor/`, `write-rewrite/`,
  `write-migration/` (migration + upgrade), `write-performance/`, `write-testing/`, `write-documentation/`,
  and the narrow `fix-flaky-test/` (`task_kind: fix`).
- **`implement-and-verify/`** — the one optional code-repo skill.
- **Code-work profiles:** `persona-builder/`, `persona-bug-hunter/`, `persona-test-author/`,
  `persona-performance-surgeon/`, `persona-migrator/`, `persona-lead-engineer/`, `persona-janitor/`.
- **`templates/`** — the `task.md` and `trace.md` skeletons (implement/trace artifacts; code-side).

See [`././passes/implement.md`](././passes/implement.md) for the `implement` step contract and
[`./heuristic-profiles.md`](./heuristic-profiles.md) for the persona model (the closed set is thirteen —
six authoring profiles ship in the kit, these seven are here).
