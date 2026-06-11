# `task-orchestration.md` — the coordination record

`task-orchestration.md` is the single canonical **coordination record** for one parallel decomposition: when a body of work is split across several workers that run concurrently, this is the one file that records who owns which surfaces, what each worker was handed, whether each is still making progress, and how every branch was merged back. It is the execution-tier counterpart of a spec's source-tier scope declarations — where the spec declares `WRITES` / `READS` / `DEPENDS ON` / `AFFECTS` per obligation, the coordination record projects those declarations onto **workers** and records the hand-off, liveness, and merge contract a reviewer can reconstruct the whole run from. Among the obligations it is the node where a partitioned plan becomes a tracked, write-disjoint fan-out: the lead's one place to record the parallel run, not a second place where intent is authored.

Swarm ships **no runtime** (see the [artifacts README](README.md)). Every "the lead spawns…", "the toolchain prepares…", "the worker hands back…" clause on this page is the recorded shape of an action a future launcher MAY one day perform — a **contract a future tool builds against**, not a scheduler this repo runs. A `task-orchestration.md` is inert structured Markdown a human or agent populates by hand; nothing in it executes, detects a stall, or merges a branch on its own.

## Purpose & epistemic stance

A coordination record asserts one kind of knowledge: **the recorded contract of a parallel run** — its worker partition, hand-offs, liveness, and merge history. Its stance is **derived projection plus recorded fact**. The partition it records is *derived*: each worker's owned surfaces are the file/glob projection of that worker's assigned obligations' declared `WRITES` surfaces, structured by the lower and decompose steps (the write-surface model), not authored here. The hand-offs, progress checks, stall decisions, and merge resolutions it records are *facts about the run* — recorded as the run proceeds so the run is reconstructable from the artifact alone rather than held in the lead's head.

The reason the partition is *recorded* rather than *invented* here is the write-surface model. Write-side parallel safety reduces to one invariant: the set of surfaces any two concurrent workers may write MUST be disjoint. That invariant is decided where the write surfaces are known — at the `lower` step, against the obligations' declared `WRITES` — and this file is where the resulting per-worker partition is written down and made reviewable. A coordination record that *chose* a worker's owned paths independently of the obligations would let a hidden write escape the conflict graph the disjointness proof depends on; the record exists to surface that partition, not to author it.

What a `task-orchestration.md` MUST do:

- **Record a disjoint partition.** The set of OWNED paths across all workers MUST be pairwise non-overlapping, and that pairwise-disjointness MUST be confirmed *before* any worker is spawned. Two sub-tasks that need the same file are not independent and MUST be sequenced (a `DEPENDS ON` edge / serial order), never run in the same parallel batch.
- **Record each worker's hand-off** — objective, expected deliverable, acceptance bar, and boundaries — as data, not prose. Vague subtask descriptions and inter-agent misalignment are the dominant multi-agent failure mode; a recorded hand-off contract is Swarm's countermeasure, so it MUST be written down.
- **Record liveness as data** — a per-worker progress marker, a documented stall threshold and status, and the action taken on a stall — because a worker hung in progress or silently diverging is otherwise an invisible state.
- **Record the merge history** — the order branches merged, conflicts seen, and how each was resolved, with an INTENT-PRESERVED-PROOF for every non-trivial conflict.

What a `task-orchestration.md` MUST NOT do:

- **It MUST NOT author intent.** It carries no original `REQ` / `CONSTRAINT` / `INVARIANT` / `INTERFACE`. Behavior a worker discovers it needs but that no assigned obligation covers is a promotion item, routed back to a spec, never silently absorbed into the coordination record.
- **It MUST NOT widen a worker's reach.** A worker's OWNED set MUST be a subset of the union of its assigned obligations' declared `WRITES` surfaces. An OWNED path outside that union is a `SOL-O005` scope/ownership defect — the fix is to re-scope the worker (shrink OWNED) or add the surface to the obligation's `WRITES` clause in the source spec (widen the declared write set), never to let the worker write outside the declared surfaces.
- **It MUST NOT mark a conflicting pair parallel.** Two workers whose OWNED paths overlap are not write-disjoint, hence not parallel-safe; scheduling them into the same parallel batch is a `SOL-O001` ERROR — exactly the silent, hard-to-review merge corruption the disjoint-scope invariant exists to prevent.
- **It MUST NOT be the only home of any durable fact.** On reconciliation the run's durable record is the compacted ledger entry, the updated status, and any promoted findings — never the generated coordination record, which is disposable execution material.

This stance is held by the write-surface discipline, not by any runtime tool: there is no runtime to detect a stall, prove disjointness, or block a merge. The disjointness, merge order, and gate predicate are recorded so a deterministic check outside the model — where one exists — or a reviewer can evaluate them; a conformant repository MUST NOT claim a live orchestrator runs them.

## Filename & placement

`task-orchestration.md` is a **working artifact**, not a Swarm-format source. Its filename therefore MUST NOT carry the spec.md convention; it uses a plain `.md` extension. The infix is the sole discriminator for "does Swarm parse or emit this":

| Class | Rule | This artifact |
| --- | --- | --- |
| Swarm-format spec | The human-authored spec is `*.md`. | No — a coordination record is not a source spec. |
| Emitted Swarm output | Emitted artifacts carry `.*`  (e.g. `*.ir.json`, `*.plan.json`, `*.trace.md`). | No — a coordination record is not a Swarm-emitted output. |
| **Working artifact** | Plain `.md`, **no** `spec.md` naming (e.g. `task-orchestration.md`). | **Yes** — it is a human/agent-authored coordination record. |

A `task-orchestration.md` MAY embed SOL surface keywords (the `WRITES`-projected OWNED paths, the preserved constraints/invariants) as **quoted data**; embedding them does not make the file a SOL source, and a conformant tool MUST NOT parse a plain `task-orchestration.md` as a spec.

In an adopted project, a coordination record is **generated execution material** — emitted by the lead during the decompose step and recreatable from the source spec's obligations — so it is execution scratch, gitignored or created lazily by a future tool. It sits beside the other recreatable packets a parallel run produces:

- The spec whose obligations the workers cover is a committed source-doc — the coordination record asserts no durable intent, so it is **not** a source-doc itself.
- The per-worker child task frames (each carrying a `## Parent contract`), the trace each worker emits on completion, and the review whose verdicts the per-task merge gate reads are all recreatable execution scratch.

A coordination record is not a durable source-doc (it asserts no durable intent) and it is not kept as a permanent record: it is disposable, and the durable record of the run is compacted into the durable ledger — or flows back to the spec repo as a linked PR — on reconciliation.

A `task-orchestration.md` has **no copyable template among the starter-kit artifact skeletons**: unlike a task, an audit, or a finding, you do not start one from a blank skeleton you fill in. It is *generated* — emitted by the lead during the decompose step and updated as the run proceeds. The schema below is its contract; the worker partition is structured from the obligations, and the hand-offs, progress, and merge rows are recorded as the run unfolds.

## Required sections & fields, in order

A conformant coordination record MUST contain the four recorded contracts below — the worker tracker, the per-worker hand-off, the liveness record, and the merge log — plus a frontmatter discriminator. Each is a contract a reviewer (or a future checker) reads; none is a runtime.

### Frontmatter contract

YAML frontmatter delimited by `---`, with at minimum:

| Field | Meaning |
| --- | --- |
| `type: task-orchestration` | Names the artifact class. Required. |
| `id` | A stable slug identifying this coordination run (conventionally `{{spec-slug}}-orchestration`). Required. |
| `source` | Path to the `spec.md` whose obligations the workers cover. Required. |
| `parallel_group` | The coordination group this run schedules; ties the workers to the disjointness proof. Required. |
| `created` | Creation timestamp. Required. |

### Body sections, in order

| # | Section | Required content | Stance rule |
| --- | --- | --- | --- |
| 1 | `# Orchestration: <title>` + provenance note | The title, then a one-line reminder that this file is the recorded coordination contract for a parallel run, generated by the decompose step and updated as the run proceeds — never a runtime, and never a home for authored intent. | Sets the reader's frame; the note is part of the contract. |
| 2 | `## Worker tracker` | One row per worker, carrying its OWNED and FORBIDDEN paths, hand-off summary, branch, status, liveness marker, and last verdict (schema below). | Records the disjoint partition structured from the obligations; the OWNED sets MUST be pairwise non-overlapping. |
| 3 | `## Decisions` | One row per stall (or other re-plan) event: when, which worker, the trigger, the action taken, and its rationale. | The recorded stall action, so the run is reconstructable. |
| 4 | `## Merge log` | One row per merged branch: merge order, worker, target, conflicts, resolution, and the INTENT-PRESERVED-PROOF for every non-trivial conflict. | The reconstructable merge history; non-trivial conflicts MUST carry their equivalence proof. |

Each worker spawned from the tracker carries its hand-off into its own child `task.md` as a `## Parent contract` section (below) — that section lives in the child task, not in this file, but the boundary it states MUST be the same text the tracker recorded.

### The worker tracker (the disjoint-scope invariant)

The worker tracker is a table with one row per worker. Two columns are load-bearing:

- **OWNED paths** — the file/glob projection of that worker's assigned obligations' `WRITES` surfaces. The set of OWNED paths across all workers MUST be **pairwise non-overlapping**; this pairwise-disjointness IS the disjoint-scope invariant on which write-side parallel safety rests.
- **FORBIDDEN paths** — the union of every *other* worker's OWNED paths. A worker MUST NOT write outside its OWNED set; the FORBIDDEN column makes that boundary explicit and reviewable rather than implicit.

| Column | Meaning |
| --- | --- |
| `Worker` | The worker's slug. |
| `Source doc` | The `spec.md` this worker's obligations are drawn from. |
| `Task kind` | The kind that parameterizes the worker's step (e.g. `implement`). |
| `Profile` | The carrier profile the worker runs under. |
| `OWNED paths` | The worker's owned write surfaces; a subset of its obligations' declared `WRITES` (else `SOL-O005`). |
| `FORBIDDEN paths` | The union of every other worker's OWNED paths. |
| `Hand-off (deliverable / acceptance bar)` | A one-line summary of the hand-off contract (full form below). |
| `Branch` | The worker's branch (one worktree per task; conventionally `swarm/<spec-slug>/<task-slug>`). A **single** task implementing a whole spec collapses this to `swarm/<spec-slug>`; the two-level form is for one obligation or a fan-out worker — one grammar reconciles both (the per-task isolation rule, including the `base:` it forks from, is the `implement` step [Isolation](./passes/implement.md) section, ADR-0046). |
| `Status` | One of `not-started`, `in-progress`, `stalled`, `awaiting-review`, `kicked-back`, `merged`, `abandoned`. |
| `Last progress` | The liveness marker — updated each time the lead checks the worker. |
| `Last verdict` | The latest review verdict for the worker, or `—`. |

The pairwise-disjointness of OWNED paths MUST be confirmed *before* spawning any worker. If two sub-tasks need the same file they are not independent and MUST be sequenced via a `DEPENDS ON` edge, not parallelized — two tasks that would write the same surface are not write-disjoint, hence not parallel-safe, and the worktrees are the physical enforcement of that one-writer-per-surface discipline.

### The hand-off contract (per worker)

Each worker row carries a **hand-off contract** — the four fields below. This is what defeats vague subtask descriptions; it MUST be recorded as data, not left to prose.

| Hand-off field | Meaning |
| --- | --- |
| **Objective** | The single outcome the worker must produce. |
| **Expected deliverable** | The concrete artifact/branch the worker hands back. |
| **Acceptance bar** | The verdict the lead will review against — the obligations that MUST reach `PASS`. |
| **Boundaries** | The OWNED / FORBIDDEN paths plus any preserved constraints/invariants. |

### The `## Parent contract` a child task carries

When the lead spawns a worker, that worker's child `task.md` MUST contain a `## Parent contract` section carrying the worker's hand-off **verbatim**. This mirrors the Scope In / Scope Out discipline: the child inherits its objective, deliverable, acceptance bar, and boundaries from the parent's worker tracker, so the boundary the lead recorded and the boundary the worker sees are the same text. A worker MUST NOT write outside its `## Parent contract` boundaries; doing so is the execution-tier violation caught by `SOL-O005`.

### The liveness record, STALL threshold, and STALL action

The coordination record MUST record liveness as data, because a worker hung `in-progress` or silently diverging is otherwise invisible state — Swarm has no runtime to detect it.

- **Liveness marker** — the `Last progress` column. The lead updates it each time it checks the worker.
- **STALL threshold** — a worker whose `Last progress` has **not advanced across two consecutive checks** is `stalled`. The two-consecutive-checks threshold is a chosen design constant for the recorded liveness marker; it is the recorded form a future launcher's stall detector reads, not an empirical borrowing.
- **STALL action** — on `stalled`, the lead MUST take one recorded action: **re-plan**, **re-scope**, **escalate**, or **abandon**. The chosen action and its rationale MUST be written to `## Decisions` so the run is reconstructable. This is a recorded contract a future launcher could automate, not a stall detector Swarm runs.

### The merge log and the INTENT-PRESERVED-PROOF column

The merge log records the order branches were merged, conflicts encountered, and how each was resolved — a reconstructable history. It MUST carry an **INTENT-PRESERVED-PROOF** column for every non-trivial conflict resolution.

The INTENT-PRESERVED-PROOF column MUST show that the conflict resolution kept **both** sides' intent — not merely that the suite passed. "Tests pass on the merged branch" is necessary but, where the suite may not cover the interaction, **not sufficient** — the rule that schema-valid / green output is not verification, applied to merges. For refactor, migration, and merge conflicts the recommended equivalence oracle is a **property**, **differential**, or **metamorphic** check (a `property` or `contract` proof type) on the conflicted region, because these check behavioral equivalence directly rather than relying on a suite that may miss the interaction. A trivial (no-conflict / fast-forward) merge MAY record the green suite alone.

## The task lifecycle, worktrees, and the per-task merge gate

A worker the coordination record tracks is one **task**, and it moves through four recorded phases. Per the no-runtime invariant, every "the toolchain prepares… / removes…" clause below is the recorded shape of an action a future launcher MAY one day perform; Swarm fixes the artifacts and the gate predicate that action must respect, and nothing more. The branch/worktree/commit conventions are design rationale, not normative grammar.

### The four phases

| Phase | What is read | What is produced | Where |
| --- | --- | --- | --- |
| **1. Creation** | the source spec (`spec.md`) | the structuring chain source spec → structured form → task graph → generated task frame | task frame as gitignored execution scratch (`<task-slug>.task.md`) |
| **2. Execution** | the task frame + the source spec | the toolchain prepares the task frame, a worktree, a branch, the agent startup context (the `## Parent contract` carried verbatim into the child task), the verification matrix, and the promotion queue | worktree at `.worktrees/swarm/<spec-slug>/<task-slug>`, branch `swarm/<spec-slug>/<task-slug>` |
| **3. Completion** | the worktree diff + proof evidence | the worker emits a **trace**; review emits a **review** with one verdict per required `VERIFY BY` binding | trace and review as execution scratch (or, in a code repo, the PR itself) |
| **4. Reconciliation** | the trace + review | compact trace/review into the ledger; drain the promotion queue; update the status read-model; remove or archive the scratch files; remove the worktree | durable ledger entry (or a linked PR back to the spec repo) and updated status, worktree removed |

Reconciliation is the only phase that produces durable record. A task MUST NOT be treated as closed while any promotion-queue item is still pending.

### Worktree & git etiquette (single-writer discipline)

The worktree convention makes the single-writer discipline concrete on disk. The mapping is exact and load-bearing:

> **Every worktree maps to exactly one task; every task maps to its assigned obligations; every worker writes only its OWNED surfaces.**

The write side stays single-threaded: one writer per surface, and the worktrees are the physical enforcement of the OWNED-paths pairwise-disjointness invariant — two tasks that would write the same surface are not write-disjoint, hence not parallel-safe, hence MUST NOT be given concurrent worktrees but sequenced via a `DEPENDS ON` edge. A worktree MUST NOT be reused across tasks, and on completion the toolchain removes the worktree so a stale worktree never masquerades as a live writer.

> **Scope of the worktree guarantee.** A worktree enforces **file/path** disjointness (the OWNED-paths invariant), not **runtime-resource** disjointness: two write-disjoint parallel tasks can still collide on shared ports, dev databases, caches, secrets, or test state. Runtime-resource isolation is out of scope for Swarm's write-surface model and is a launcher concern.

### The per-task merge gate

The per-task merge gate is **not a second gate**. It is the one merge gate — the predicate "every required obligation's required `VERIFY BY` bindings are all `PASS` / `WAIVED`" — evaluated at the moment a task's branch would merge into its base. This page only fixes the scope (the task's assigned obligations) and the orchestration-specific blocking conditions layered on top of it.

A task **MUST NOT merge** if any of the following holds:

| # | Blocking condition |
| --- | --- |
| 1 | The **trace is missing** or the **review is missing** for the task (a verdict justified only by the worker's own summary fails). |
| 2 | Any **assigned obligation's verdict is `FAIL` or `UNVERIFIED`** — including a required binding with no verdict (`SOL-V008`), and a `PASS (STALE)`, which is treated as not-`PASS`. |
| 3 | A **blocking `QUESTION` affects assigned work** — an unresolved `[blocking]` `QUESTION` whose `AFFECTS` set reaches an obligation the task covers. |
| 4 | The **promotion queue is unhandled** — any promotion-queue item for the task is still pending. |
| 5 | A **write-surface conflict remains** — a worker's OWNED path overlaps that of another worker still scheduled concurrently (`SOL-O001`), or a worker owns a path outside its obligations' declared `WRITES` (`SOL-O005`), or an unmerged `DEPENDS ON` dependency in the merge order remains. |
| 6 | The **base branch is dirty or out of policy** — uncommitted changes on the base, or the base violates a branch-protection / merge policy. |

Conditions 1–4 are the merge gate read at task scope. Condition 5 is the orchestration overlay: the per-task gate additionally requires that the write-disjoint invariant still holds at merge time, because two tasks that have silently drifted into the same surface produce exactly the hard-to-review merge corruption that `SOL-O001` was raised to ERROR to prevent. When all conditions clear, the branch merges, its resolution is recorded in `## Merge log` (with an INTENT-PRESERVED-PROOF for every non-trivial conflict), and the task advances to reconciliation. This is a recorded contract a future launcher (or eventual checker) reads and could one day enforce — it is not a gate Swarm runs.

## Observed shape

The contract shape the lead emits and updates (the worker partition structured from the obligations; hand-offs, progress, decisions, and merges recorded as the run proceeds):

```markdown
---
type: task-orchestration
id: {{spec-slug}}-orchestration
source: specs/<feature>/spec.md
parallel_group: {{group}}
created: {{createdAt}}
---

# Orchestration: {{title}}

Recorded coordination contract for a parallel run over `specs/<feature>/spec.md`.
Generated by the decompose step and updated as the run proceeds — not a runtime, and never a
home for authored intent. The authoritative obligations live in the spec; each worker's OWNED
set is structured from its assigned obligations' WRITES surfaces.

## Worker tracker

| Worker | Source doc | Task kind | Profile | OWNED paths | FORBIDDEN paths | Hand-off (deliverable / acceptance bar) | Branch | Status | Last progress | Last verdict |
| ------ | ---------- | --------- | ------- | ----------- | --------------- | --------------------------------------- | ------ | ------ | ------------- | ------------ |
| auth-client | auth-refresh.md | implement | builder | src/auth/client/** | src/auth/server/**, migrations/** | refresh-on-expiry works; AC-014 PASS | swarm/auth-refresh/auth-client | in-progress | 2026-05-31 grafted token store | — |
| auth-server | auth-refresh.md | implement | builder | src/auth/server/** | src/auth/client/**, migrations/** | issuer rotation; AC-021 PASS | swarm/auth-refresh/auth-server | awaiting-review | 2026-05-31 endpoint done | PASS |

## Decisions

| When | Worker | Trigger | Action | Rationale |
| ---- | ------ | ------- | ------ | --------- |
| 2026-05-31 | auth-server | stalled (2 checks, no progress) | re-scope | endpoint coupling underestimated; split into AC-021a/b |

## Merge log

| Order | Worker | Merged into | Conflicts | Resolution | INTENT-PRESERVED-PROOF |
| ----- | ------ | ----------- | --------- | ---------- | ---------------------- |
| 1 | auth-server | main | none | fast-forward | suite green (no conflict) |
| 2 | auth-client | main | token-store init | kept both init paths, guarded by config | property check on token-store equivalence + AC-014/AC-021 re-run PASS |
```

And the `## Parent contract` each child task carries verbatim:

```markdown
## Parent contract

- Objective: implement refresh-on-expiry in the auth client.
- Expected deliverable: branch `swarm/auth-refresh/auth-client` with AC-014 implemented.
- Acceptance bar: AC-014 reaches VERDICT PASS (VERIFY BY test:cmdTest:..).
- Boundaries:
  - OWNED: `src/auth/client/**`
  - FORBIDDEN: `src/auth/server/**`, `migrations/**`
  - PRESERVE: I-003 (no unbounded retry), IF-002 (token-store interface)
```

## Copyable template

**There is no copyable skeleton for this artifact.** A coordination record is not started from a blank template you fill in — it is *generated* by the lead during the decompose step and updated as the parallel run proceeds, and it is gitignored execution scratch (`task-orchestration.md`), created lazily by a future tool. The worker partition is structured from the obligations' declared `WRITES` surfaces; the hand-offs, liveness, decisions, and merge log are recorded as the run unfolds. The observed shape above is the **contract** every generated coordination record MUST satisfy; this page is that contract. Do not hand-author it as intent, and do not introduce a `task-orchestration.md` form — it is generated execution material, never a Swarm-format source.

## Related

- [The `decompose` step](./passes/decompose.md) — the step that *produces* a coordination record: it partitions the obligations into write-disjoint workers, projects each worker's OWNED paths from its obligations' `WRITES` surfaces, and computes the merge order from the `DEPENDS ON` DAG.
- [`task.md`](task.md) — the per-worker child frame the lead spawns from the tracker; it carries the worker's hand-off verbatim as its `## Parent contract`, and its `write_surfaces` are the OWNED set this record assigns.
- [The `review` step](./passes/review.md) — the step that emits the per-task verdicts the merge gate reads; a missing review, or a `FAIL` / `UNVERIFIED` verdict on assigned work, blocks the per-task merge.
