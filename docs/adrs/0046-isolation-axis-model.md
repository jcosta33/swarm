---
type: adr
id: 0046-isolation-axis-model
status: accepted
created: 2026-06-05
updated: 2026-06-05
supersedes:
superseded_by:
---

# ADR-0046: The isolation axis — when a task gets a worktree+branch, and the honest in-place default

## Context

Swarm fully specifies worktree + branch + merge-gate + cleanup **only inside the parallel-decomposition
coordination record** (`task-orchestration.md`, scoped to "one parallel decomposition"). The **single-task
load path** — `AGENTS.md` startup → `task.md` frame → `write-*` guide → `implement.md` → verify/review —
carries **no isolation signal**: the `task.md` frontmatter has no isolation/branch/base field, `implement.md`
(the pass every code task runs) never mentions worktree/branch, and only 3 of 12 per-kind templates carry a
Branch placeholder — while the spec-bearing `write-feature`/`write-rewrite` carry none, the *inverse* of the
intended signal. So "implement this spec" gives an agent no reason to leave the base branch.

The root gap: the **isolation axis lacks its explicit "honest default" rung.** The proof axis has `manual`,
the surface axis has `observed` — isolation has no equivalent, so today the ad-hoc developer's in-place
freedom survives only **by silence** (worktrees never trigger absent a `parallel_group`). Any naive
"spec ⇒ isolate" tightening that did not *first* grant the no-source-artifact case would break that freedom.

## Decision

Establish a **three-rung isolation axis** — `worktree+branch` · `branch-only` · `in-place` — with
**`in-place` as the explicit, granted ad-hoc default** (the analogue of `manual`/`observed`). The normative
rule: **a spec or audit-remediation is implemented *off the base*, not on it; a quick ad-hoc edit is not.**

### The decision rule (deterministic, NO RUNTIME — the agent reads the frame + the request; first match wins)

0. **Escape hatch (checked FIRST):** if the request is ad-hoc — `isolation: in-place` in the frame, OR the
   dev said "quick"/"ad-hoc"/"in place"/"on my branch", OR **there is no `task.md` frame and no
   `*.swarm.md`/audit source named** — → **`in-place`**, on the branch the dev is already on. *The absence of
   a source artifact IS the signal; the dev types nothing extra.* (Checked first so no tightening below can
   gate a quick edit behind worktree setup.)
1. **Explicit declaration wins:** the frame's `isolation:` value is used verbatim (lead/dev override,
   recorded for resumption).
2. **Doc/source-only authoring:** `task_kind ∈ {spec-writing, research-writing, audit-writing,
   bug-report-writing, deepen-audit}`, OR every `write_surface` is under `.swarm/sources/` → **`in-place`**
   (a lone doc writer conflicts with nothing; the `decompose` READS-only / source-only parallel-safety rule
   already exempts it).
3. **Review / orchestration:** `review` → **`branch-only`**; `orchestration` → **`branch-only`** on the
   coordination record, and it *mints* the per-worker `worktree+branch` children (the existing model).
4. **Tracked code work (the isolate default):** a code-producing kind
   (`feature|fix|refactor|rewrite|migration|upgrade|performance|testing|integration`) **with a source
   artifact present** (`source:` resolves to a `*.swarm.md` spec or an audit-derived spec) → **`worktree+branch`**.
   This is the "a spec/audit is implemented off the base" rule.
5. **Fallthrough** (code kind, no source, no ad-hoc flag) → **dev-choice**, defaulting to `in-place`; the
   agent should ask, or record the chosen `isolation:`.

The composing axes are exactly four: **has-source-artifact** (4 vs 5), **code-vs-doc** (2 vs 4), **task_kind**
(2/3/4), and the **ad-hoc flag** (0). **`parallel_group` is NOT an input** — isolation is orthogonal to it: a
single task with `parallel_group: none` still isolates via step 4; a fan-out still mints per-worker worktrees
via step 3. This decoupling is the key fix — isolation stops being a silent side effect of parallelism.

### Branch nomenclature + `base:`

Extend the one existing pattern (`swarm/<spec-slug>/<task-slug>`, the worker form in `task-orchestration.md`)
with a single-task collapse so a lone task and a fan-out worker reconcile under one grammar:

- **Single task implementing a whole spec:** branch `swarm/<spec-slug>`, worktree `.worktrees/swarm/<spec-slug>`.
- **Single task for one obligation/sub-scope:** `swarm/<spec-slug>/<task-slug>` (identical to a fan-out worker — by design).
- **Audit remediation:** keyed on the **promoted** spec slug (the `author` pass turns the audit into a spec).
- **Fan-out workers:** unchanged (`swarm/<spec-slug>/<task-slug>`).

`base:` is recorded on the frame — default `main`, but **the dev's current HEAD** when they hand off
mid-stream on a feature branch (the nested-branch case). These remain **design rationale, not parsed
grammar** — a loose convention an agent re-derives — so they cost nothing against NO RUNTIME.

### Where it is encoded (NO-RUNTIME, agent-readable)

- This ADR — the model + the escape-hatch grant.
- `isolation:` + `base:` fields on the canonical `task.md` frame (the artifact contract + the kernel
  template), decoupled from `parallel_group` — the recording home for resumption.
- The decision rule in `implement.md` (the pass every code task runs; inherited by all per-kind guides
  without duplication) — with a one-line pointer in the `kernel/AGENTS.md` startup so a bare ad-hoc request
  is caught before any guide loads.

### Merge / cleanup — one lifecycle, two cardinalities

A lone task clears the **same merge gate** as a fan-out worker, with the cross-worker write-disjointness
condition **vacuously true** for one writer; `base:` supplies the merge target. Cleanup mirrors the
orchestration reconciliation (merge → remove worktree → compact into `.swarm/ledger/` → drain the promotion
queue); with no launcher, the closing session + the `persona-janitor` profile own by-hand cleanup. A
single-task run is the orchestration lifecycle with worker-count 1 — same branch grammar, same gate, same
cleanup — not a second mechanism.

Refines [0039](./0039-write-surface-model.md) (which scoped isolation to parallel decomposition only) and
operationalizes the single-fork escape clause of [0010](./0010-write-side-single-threaded.md). Relates to
[0029](./0029-nine-pass-compiler-model.md) (the `task_kind`s) and [0044](./0044-kernel-is-derived-and-self-contained.md)/[0045](./0045-overlays-are-project-owned.md)
(the kernel/twin + ownership discipline the encoding respects).

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| Leave isolation specified only for parallel decomposition | The status quo — the single-task path has no signal, so "implement this spec" lands on the base; and the per-kind templates give the *inverse* signal. |
| "Spec ⇒ isolate" with no explicit in-place rung | Breaks the ad-hoc escape hatch the moment isolation stops being silent — a quick 3-file rename would be gated behind worktree setup. The honest default rung (checked first) is what preserves the freedom. |
| Key isolation off `parallel_group` | Conflates two orthogonal axes; a single non-parallel task implementing a spec still needs isolation. Decoupling them is the fix. |
| A new top-level frontmatter object / parsed branch grammar | Over-formalizes against NO RUNTIME; a `task_kind`-keyed rule + a recorded `isolation:`/`base:` field + a loose naming convention an agent re-derives is sufficient and cheaper. |

## Consequences

### Positive

- An agent can decide worktree-or-not for any task **deterministically, with no runtime**, and name the
  branch to reflect the spec/audit it implements.
- A spec/audit is no longer implemented on the base by default; the quick ad-hoc case stays zero-ceremony.
- Single-task and parallel isolation are **one story, two cardinalities** — no second mechanism, no fork.

### Negative

- The `.swarm/` frame frontmatter gains two fields (`isolation:`, `base:`) and the per-kind templates need
  reconciling (the 3-of-12 inversion); a small twin-sync surface.
- The rule is closed only over the well-formed cases the four axes cover; the dev-choice fallthrough (step 5)
  asks at the genuine edges (a sourceless-but-tracked "fix"; a "documentation" kind editing code comments).

### Neutral / tradeoffs

- This adds an *axis vocabulary* and a decision rule, not a new construct; no canonical closed set changes.
- **NO RUNTIME means nothing enforces it** — an agent *can* ignore `isolation:` and land a spec on the base.
  This is specification completeness, not an operational guarantee (the same soft-control limit as every
  Swarm gate; a future launcher reads the rule). The escape-hatch ordering (step 0 first) is normative prose,
  re-derivable but ignorable.

## Status

Accepted (v0.1).

## Affected obligations / constraints

- Adds: the three-rung isolation axis; the deterministic step-0–5 decision rule; `in-place` as the explicit
  ad-hoc default; the single-task branch-naming collapse + `base:`; the orthogonality of isolation and
  `parallel_group`.
- Modifies: the `task.md` frame (adds `isolation:`/`base:`); `implement.md` (a new `## Isolation` section);
  the `kernel/AGENTS.md` startup (a one-line trigger); the per-kind templates (reconcile the field set).
- Refines: [0039](./0039-write-surface-model.md); operationalizes [0010](./0010-write-side-single-threaded.md).
- Does NOT change: the merge gate, the write-surface conflict model, any canonical closed set.
