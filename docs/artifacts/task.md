# `task.md` — the step frame

`task.md` is the bounded work packet of the Swarm flow: the structured, self-contained frame for **one step** over an assigned set of obligation ids, carrying its parent contract, its write surfaces, its verification bindings, and the slots where execution evidence accumulates [[SCRATCHPAD]](../research/sources.md#SCRATCHPAD). Among the obligations it is the node where intent stops being a partitioned plan and becomes a single owned unit of work — the unit one `implement` (or `author`/`review`) run discharges, traces, and verifies. A task frame is a disk-persistent, dependency-aware unit of work, carrying its dependency edges as frontmatter rather than holding them in context [[CCTASKS]](../research/sources.md#CCTASKS).

Swarm ships **no runtime** (see the [artifacts README](README.md)): the "step" a `task.md` frames is a CONTRACT a human, an agent following a step guide, or a future tool performs, never shipped code. A `task.md` is inert structured Markdown that an agent populates by hand; nothing in it executes.

## Purpose & epistemic stance

A task asserts **scoped, derived intent**: it is the projection of an already-authoritative spec onto exactly one step and one disjoint set of obligations. It does not originate behavior — it carries forward obligations a spec already declared, pasted **verbatim**, plus the constraints and invariants that step must preserve.

What a `task.md` MUST do:

- Name its scope as **assigned obligation ids** (e.g. `AC-001`, `REQ-002`), and paste the exact SOL blocks for those obligations into the body — not paraphrases. Distillation that drops an obligation id, modality, actor, trigger, response, constraint, invariant, verification binding, or authority is a distillation error.
- Declare its `write_surfaces` as a **subset** of the assigned obligations' `WRITES` surfaces. An owned path that falls outside any assigned obligation's declared write surface is a `SOL-O005` scope/ownership defect.
- Carry the orchestration scope fields a disjointness proof needs (`parallel_group`, `blocked_by`) so two tasks scheduled in parallel can be shown to own disjoint paths.

What a `task.md` MUST NOT do:

- It MUST NOT author new obligations. A task is not a spec; it carries no original `REQ`/`CONSTRAINT`/`INVARIANT` intent of its own. Behavior the task discovers it needs but that no assigned obligation covers is a **promotion item**, routed back to a spec (or, for a fix, into a new task), never silently implemented.
- It MUST NOT implement unassigned obligations or change behavior outside its declared write surfaces.
- It MUST NOT weaken the constraints, invariants, or non-goals it inherits.
- It MUST NOT close with an unresolved promotion item, and MUST NOT claim completion without evidence.

`task_kind` is a frontmatter **enum that parameterizes which step runs** — it is a dimension, not a step. The nine steps are the fixed transformation set; `task_kind` selects which step guide(s) and profile apply inside two of them. The build/change kinds (`feature`, `fix`, `refactor`, `rewrite`, `migration`, `upgrade`, `performance`, `testing`, `documentation`) all route to the `implement` step. The authoring kinds (`spec-writing`, `research-writing`, `audit-writing`, `bug-report-writing`, `deepen-audit`) route to `author`. `review` selects `review`; `orchestration` and `integration` select `decompose` plus a merge-gate `review` under the Lead Engineer profile. There is no `kickback` kind: kickback is the **re-entry** of the `implement` step on a `FAIL`/`UNVERIFIED` verdict, an edge in the flow graph, not a task type.

## Filename & placement

`task.md` is a **working artifact**, not a Swarm-format one. Its filename therefore MUST NOT carry the `.swarm.` infix; it uses a plain `.md` extension. The infix is the sole discriminator for "does Swarm parse or emit this":

| Class | Rule | This artifact |
| --- | --- | --- |
| Swarm-format spec | The human-authored spec is `*.swarm.md`. | No — a task is not a source spec. |
| Emitted Swarm output | Emitted artifacts carry `.swarm.*` (e.g. `*.swarm.ir.json`, `*.swarm.plan.json`, `*.swarm.trace.md`). | No — a task is not an emitted Swarm output. |
| **Working artifact** | Plain `.md`, **no** `.swarm.` infix (e.g. `task.md`). | **Yes** — `task.md` is a human/agent working artifact. |

A `task.md` MAY embed SOL blocks (the assigned obligations, the constraints and invariants it preserves) as **quoted data**; embedding them does not make the file a SOL source, and a conformant tool MUST NOT parse a plain `task.md` as a spec.

In an adopted project, a task is **generated/derived execution material** — recreatable from sources — so it is execution scratch, gitignored or created lazily by a future tool:

| Layer | Holds | Why the task lives (or does not live) here |
| --- | --- | --- |
| Durable source-docs | Desired truth: specs, PRDs, RFCs, research, audits, bug-reports, findings, ADRs, interfaces, NFRs. | **Not** here — a task carries no original intent. |
| Execution scratch | The structured task frames (alongside the traces and reviews a run produces). | **Here** — a task is recreatable from a spec by the `lower`/`decompose` step. |
| Durable recall | The recall map (`INDEX.md`), glossary, and patterns. | **Not** here — a task is execution material, not durable knowledge. |

Generated task frames are gitignored scratch (the active frames, with their in-flight traces/reviews); on completion the durable summary of a task is compacted into the durable ledger — or flows back to the spec repo as a linked PR — not kept as a permanent scratchpad.

## Required sections & fields, in order

### Frontmatter contract

The frontmatter MUST carry the full field set below — including the orchestration scope fields the `lower` step needs to prove disjointness.

| Field | Meaning |
| --- | --- |
| `type: task` | Fixed discriminator for the artifact class. |
| `id` | The task slug. |
| `status` | `active \| blocked \| done \| abandoned`. `done` is terminal. |
| `task_kind` | The enum that parameterizes which step runs (see Purpose above). |
| `source` | Path to the source doc / `spec.swarm.md` this step structures from. |
| `assigned_obligations` | The obligation ids assigned as this task's scope (`AC-001`, `REQ-002`, …). |
| `constraints` | The `C-` ids this step MUST preserve. |
| `invariants` | The `I-` ids this step MUST preserve. |
| `interfaces` | The `IF-` ids in this step's contract. |
| `write_surfaces` | The paths this step may write; MUST be a subset of the assigned obligations' `WRITES` surfaces (a path outside is `SOL-O005`). |
| `verification_bindings` | Per assigned obligation: obligation id → proof binding (adapter / command reference). |
| `parallel_group` | The coordination group this task runs in, for the disjointness proof; or `none`. |
| `isolation` | `worktree+branch \| in-place` — where this task's work happens, **orthogonal to `parallel_group`** ([ADR-0046](../adrs/0046-isolation-axis-model.md); the rule is in [the `implement` step](../passes/implement.md)). MAY be omitted to let the rule decide: a code task with a `source` spec/audit → `worktree+branch` off the base; ad-hoc/doc/review work → `in-place`. |
| `base` | The branch this task's worktree/branch forks from and merges back to (default `main`; the dev's current HEAD when handed off mid-branch). |
| `blocked_by` | Task / obligation ids this step waits on; `[]` if unblocked. |
| `produces` | Artifact paths this step emits under `generated/` (e.g. the `trace.md` / `review.md` it writes); `[]` when the step emits no durable artifact. |
| `pass` *(optional)* | The named step this task activates. |
| `pass_guides` *(optional)* | The step-guide refs this task activates. |
| `profile` *(optional)* | The profile this task activates (e.g. `skeptic`). |
| `created` | Creation timestamp. |

### Body sections (in order)

| # | Section | Meaning |
| --- | --- | --- |
| 1 | `# Task: <title>` | The task heading. |
| 2 | `## Parent contract` | The inherited hand-off contract as a table: **Objective**, **Deliverable**, **Acceptance bar**, **Owned paths**, **Forbidden paths**. The boundaries the task must respect. |
| 3 | `## Scope` | An explicit **In / Out** list bounding the step. The `Out` list MUST restate the universal prohibitions: do not implement unassigned obligations; do not change behavior outside the declared write surfaces; do not weaken constraints, invariants, or non-goals. |
| 4 | `## Assigned obligations` | The exact assigned SOL blocks, pasted **verbatim** — not paraphrased. |
| 5 | `## Constraints and invariants` | All constraints and invariants this task MUST preserve, pasted verbatim. |
| 6 | `## Implementation or pass trace` | What changed, per obligation: a table of `Obligation / target` → `Files changed` → `How satisfied`. |
| 7 | `## Verification matrix` | Required proof → actual proof → status, per obligation/constraint/invariant. Status is one of the 7 verdict values (4 core `PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED` + 3 lifecycle `WAIVED`/`STALE`/`CONTRADICTED`). Proof bindings take the `VERIFY BY <type>:<adapter>:<artifact>` shape. |
| 8 | `## Promotion queue` | Discoveries with target + promotion status. Every item MUST be resolved (`promoted` / `deferred` / `rejected` / `blocked` / `validated` / `rolled-back`) before the task closes; an unresolved item blocks close. |
| 9 | `## Self-review` | The structured `<self_review>` block: did I perform only the assigned step; preserve all assigned SOL semantics; map every completion claim to evidence; avoid changes outside the declared write surfaces; resolve every promotion item; and what remains `BLOCKED` or `UNVERIFIED`. |

## Copyable template

The copyable skeleton for this artifact is the **code-side** template at:

```
docs/library/code-skills/templates/task.md
```

(`task.md` is implement-side execution scratch, so its skeleton ships with the code-skills reference, not the authoring starter kit — a pristine code repo needs none.)

That template is the skeleton you copy to start a task; **this page is its contract**. Where the template gives empty slots and the field enum, this page gives the meaning of each slot and the rules a conformant `task.md` MUST satisfy. There is **one** task template for every kind of work; a `task_kind` value specializes it.

## Related

- **`docs/passes/lower.md`** and **`docs/passes/decompose.md`** — the steps that *produce* a `task.md`: `lower` builds the structured form, `decompose` partitions it into write-disjoint task frames with their write surfaces and verification bindings.
- **`docs/passes/implement.md`** — the step most task frames *activate* (the build/change `task_kind`s route here).
- **`docs/passes/author.md`** — the step the source-authoring `task_kind`s activate.
- **`docs/passes/verify.md`** and **`docs/passes/review.md`** — the steps that consume a task's claimed work and fill the verdict side of its verification matrix; a `FAIL`/`UNVERIFIED` here re-enters `implement` (kickback).
- **`docs/passes/promote.md`** — the step that drains a task's promotion queue into specs, ADRs, or memory.
- **`docs/model/source-artifacts.md`** — the full artifact set, the `.swarm.` infix partition, and the conformance tiers in which `task.md` is a Tier-1 core artifact.
- **`docs/model/workspace.md`** — the adopted-project layout (durable sources / execution scratch / durable recall) where the task frame lives as gitignored execution scratch.
