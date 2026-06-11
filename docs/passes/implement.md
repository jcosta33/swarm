# The `implement` step

> Swarm's reference for the `implement` step: the step that produces the change for assigned obligations, records TRACE claims, and gathers proof evidence — its step frame (`task.md`), its claim output (`trace.md`), the COVERAGE gate that guards its entry, and the owned-path containment rule.

`implement` is the sixth of the **nine steps** of the Swarm flow (`author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote`). This page is the reference for that single step.

Like every Swarm step, `implement` has **no runtime**: it is a contract a human, an agent following a step guide, or a future tool performs. Nothing here is shipped code (Invariant 1).

## What the step does

The `implement` step **produces the change for the assigned obligations only, records TRACE claims, and runs bound proofs to gather evidence**. It consumes one `task.md` work packet and emits code/docs/tests changes plus a `trace.md`.

| Aspect | Value |
|---|---|
| Phase | **`EXECUTE`** — "Code, docs, and tests are produced against the lowered work packets" |
| Input artifact | `task.md` (the lowered work packet for one step) |
| Output artifacts | code/docs/tests changes + `trace.md` (`*.trace.md` when emitted) |
| Nature of the phase | **Heuristic** (the deterministic re-check is the [`verify` step](verify.md)) |
| Typical carrier profile | **by task kind**: Janitor, Migrator, Performance-Surgeon, Builder, Test-Author, Documentarian |
| Lint layer | — (`implement` emits no lint codes; its TRACE claims feed `verify`/`review`) |

`implement` is the only step whose carrier profile is selected **by task kind** rather than fixed — the `task_kind` frontmatter enum on the incoming `task.md` parameterizes which profile and procedure run.

## Where it sits in the flow

The seven **phases** are `PARSE -> NORMALIZE -> LOWER -> EXECUTE -> VERIFY -> REVIEW -> PROMOTE`implement` is the single step mapped to the **`EXECUTE`** phase. It runs after `decompose` (which partitions the structured form into write-disjoint `task.md` packets) and before `verify` (which re-runs every bound proof deterministically).

The partial order is mandatory: for a single obligation the step order MUST be respected — an obligation cannot be `verify`-ed before it is `implement`-ed, nor `implement`-ed before it is `lower`-ed. A launcher MAY interleave steps across multiple specs and MAY run write-disjoint `implement` packets in parallel, but it MUST NOT reorder this partial order for one obligation.

Two contract notes bear on `implement`'s position:

- **`implement` consumes a `task.md`, not the surface spec or the structured form.** `decompose` already computed the work-packet boundaries from the typed graph; `implement` works against the packet it was handed.
- **`verify` is the only profile-independent step.** Whatever heuristic profile `implement` runs under (selected by task kind), it does **not** decide whether an obligation passes. `implement` *gathers* evidence (the `PROOF` lines in its TRACE claims); the deterministic `verify` step turns evidence into a core verdict. A profile may influence which proofs are *demanded*, never whether a run `PASS`-es.

## Isolation: worktree+branch, or in-place

Decide *where* the work happens before touching code. It is a binary (a frame `isolation:` field overrides it; it is orthogonal to `parallel_group`):

- **A code task implementing a spec or audit-remediation** (it has a `source:` `*.md` or audit-derived spec) → a **worktree + branch off the base**, named for what it implements: `swarm/<spec-slug>` for a whole spec, `swarm/<spec-slug>/<task-slug>` for one obligation or a fan-out worker (one grammar; `base:` records the merge target, default `main` — or the dev's HEAD when handed off mid-branch). *A spec is implemented off the base, never on it.*
- **Anything else** — a quick ad-hoc edit with no spec, a doc/source-only authoring task, a read-only review → **in-place** on the current branch. No ceremony; the absence of a source artifact is the signal.

Merge + cleanup reuse the orchestration lifecycle at worker-count 1: a lone worktree clears the same merge gate (the cross-worker disjointness condition is vacuous for one writer), merges to `base`, and the worktree is removed (by hand today — the closing session + the `persona-janitor` stance; an in-flight worktree is tracked as execution scratch, gitignored or created lazily by a future tool). NO RUNTIME: nothing creates the worktree or enforces the rule — it is a decision an agent (or a future launcher) applies. Full model: [ADR-0046](./adrs/0046-isolation-axis-model.md).

## The COVERAGE gate guards entry into `implement`

`implement` is gated. The `LOWER -> EXECUTE` boundary (after `decompose`, before any `implement` step runs) carries the **COVERAGE gate** — a precondition predicate over the lowered structured form and the plan, not a transformation. The flow MUST NOT advance an obligation into `implement` while the predicate is unsatisfied. Two conditions MUST hold (**R-COVERAGE-GATE**):

1. **Total coverage.** Every lowered obligation node (every `REQ` / `CONSTRAINT` / `INVARIANT` / `INTERFACE`, including each `AND THE`-split sub-obligation) is assigned to **exactly one `implement` packet** — none unassigned (uncovered), none double-owned. (The same obligation legitimately recurs in its `implement`, `verify`, and `review` packets across steps; the coverage count is per `implement` packet.)
2. **No orphan targets.** Every `verified_by` edge and every TRACE `implements`/`preserves` edge resolves to a real obligation node id in `nodes[]`. A TRACE or VERDICT whose target id does not resolve is an orphan and MUST NOT be admitted.

The diagnostics this gate aggregates:

| Condition | Code | Layer | Status | Resolves by |
|---|---|---|---|---|
| Obligation covered by no packet | `SOL-O007` (uncovered obligation) | O (orchestration) | **BLOCKING** | `SCOPE` — assign it to a packet, or record it as an explicit non-goal |
| Obligation assigned to two `implement` packets | `SOL-O008` (double-owned obligation) | O (orchestration) | **BLOCKING** | re-partition so exactly one packet owns it |
| TRACE/VERDICT target id not in `nodes[]` | `SOL-M003` (unbound cross-reference) | M (semantic) | surfaced at `review` | bind the reference to a real node, or drop the claim |

The gate is the **structural complement of the [distillation-loss rule](./reference/distillation-loss-budget.md)**: distillation-loss forbids *dropping* an obligation during structuring; the COVERAGE gate forbids *stranding* one afterward. Together they make the lowered work a bijection over obligations — nothing lost in structuring, nothing left uncovered or pointed at a phantom. Like every Swarm gate it is a contract **checkable today by review and enforced by a future tool**: today the `decompose` carrier (Lead Engineer) verifies it by hand against the structured form; a future tool computes it mechanically from `nodes[]`, `edges[]`, and `plan.packets[]`. A valid repository MUST NOT claim it is enforced by shipped tooling.

## The owned-path containment rule (G7)

The `task.md` an `implement` run owns declares **owned paths** (its `write_surfaces`). These MUST be derived from, and bounded by, the assigned obligations' declared write surfaces:

> **R-OWNED-SUBSET.** An execution-tier owned path MUST be a subset of the union of its assigned obligations' `WRITES` surfaces.

An owned path that touches a file outside any assigned obligation's declared write surface is lint code **`SOL-O005`** ("owned path outside declared write surface"). This is what keeps parallel `implement` packets write-disjoint — the property [`decompose`](decompose.md) proved using the write-surface conflict graph.

## `implement` ships as nine per-kind step guides

`implement` is not served by a single guide. Because its carrier profile is selected **by task kind**, not fixed, Swarm ships **nine per-kind implement guides** under `./library/code-skills/`, each a `SKILL.md` (ADR-0042): `write-feature`, `write-fix`, `write-refactor`, `write-rewrite`, `write-migration` (covering migration + upgrade), `write-performance`, `write-testing`, `write-documentation`, plus the narrow `fix-flaky-test` (under `task_kind: fix`). The rationale: `implement` runs on nearly every obligation that reaches code, so each task kind benefits from its own written procedure tuned to that kind's discipline. A step guide is SOFT control (Invariant 2): it MUST NOT define SOL/APS semantics, modality, authority order, or verification meaning — those live only in SOL and the structured form.

## The input: the `task.md` step frame

A `task.md` is a *step frame and execution companion*: the lowered work packet for one step over assigned source. Its frontmatter carries the full field set the structuring step needs to prove disjointness, and its body sections bound the work.

**Frontmatter** (MUST carry the full set): `type: task`, `id`, `status` (`active | blocked | done | abandoned`; `done` is terminal), `task_kind` (enum), `source`, `assigned_obligations`, `constraints`, `invariants`, `interfaces`, `write_surfaces`, `verification_bindings`, the coordination fields `parallel_group` and `blocked_by`, `produces` (the artifact paths this step emits under `generated/` — e.g. the `trace.md` it writes; `[]` when the step emits no durable artifact), plus the optional `pass`, `pass_guides`, and `profile` the task activates, and the optional isolation frame fields `isolation` (`worktree+branch | in-place`) and `base` ([ADR-0046](./adrs/0046-isolation-axis-model.md); MAY be omitted to let the rule decide — see the `Isolation` section above).

> **`write_surfaces` MUST be a subset of the assigned obligations' `WRITES` surfaces** — an owned path outside a declared write surface is the `SOL-O005` defect above (G7).

The `task_kind` enum is the parameter that selects which step and profile run:
`feature | fix | refactor | rewrite | migration | upgrade | performance | testing | documentation | spec-writing | research-writing | audit-writing | bug-report-writing | review | orchestration | integration | deepen-audit`.

**Body sections** a valid `task.md` MUST contain:

| Section | Meaning |
|---|---|
| `## Parent contract` | The inherited hand-off: objective + deliverable + acceptance bar + boundaries (owned vs forbidden paths). |
| `## Scope` | An explicit **In / Out** list bounding the step. |
| `## Assigned obligations` | The exact assigned SOL blocks, pasted verbatim. |
| `## Constraints and invariants` | The SOL blocks this task MUST preserve. |
| `## Implementation or pass trace` | What changed, per obligation. |
| `## Verification matrix` | Required proof → actual proof → 7-value status, per obligation. |
| `## Promotion queue` | Discoveries with target + promotion status (resolved at the [`promote` step](promote.md)); all MUST be resolved before task close. |
| `## Self-review` | The **adversarial** self-review block (ADR-0056): before marking the task `done`, adopt the skeptic stance over your *own* output — refute-by-default. Re-run each bound proof from a clean state; hunt the unexercised path (edge/error/concurrency, especially `RISK high\|critical`); check for scope creep and silent semantic drift; treat your own confident prose as a confession, not a proof — then fix what it surfaces and record what you attacked. **A task is not `done` until this is recorded.** It is *necessary but not sufficient*: it yields fixes + a recorded critique, never a verdict, and does **not** satisfy the independent `review` step — a self-issued `PASS` stays inadmissible (the self-preference hazard, `implementer ≠ reviewer`). |

The default `## Scope > Out` list is itself a boundary statement of the step: *do not implement unassigned obligations; do not change behavior outside the assigned write surfaces; do not weaken constraints, invariants, or non-goals.*

## The output: the `trace.md` claim contract

`implement` emits a `trace.md` that records implementation *claims* against obligations and binds them to *evidence* — externalising the run's intermediate work into a durable, inspectable artifact rather than leaving it in the agent's context [[SCRATCHPAD]](./research/sources.md#SCRATCHPAD). Its core payload is one or more `TRACE` blocks (`IMPLEMENTS` / `PRESERVES` / `CHANGED` / `PROOF`) plus the drift-provenance fields the staleness join depends on. A valid `trace.md` MUST contain:

| Section | Meaning |
|---|---|
| frontmatter | `type: trace`, `id`, `source_task`, `source_spec`, `created`. |
| `## Claimed implementation` | The `TRACE` blocks. |
| `## Provenance` | The seven G11 fields **per binding**: `source_hash`, `per_surface_hash[]` (one `{surface, hash, exercised}` per declared `WRITES` and proof-exercised `READS` surface), `adapter`, `verdict`, `tier`, `origin_obligations[]`, `origin_traces[]`. These flip a PASS to `STALE` when source or surface drifts. |
| `## Verification matrix` | ID → required proof → actual proof → 7-value status. |
| `## Unassigned changes` | Any change outside assigned obligations, with reason + authorizing ID or `none`. |
| `## Promotion items` | Discoveries to promote, with target + status. |

How a TRACE block records the claim:

- `IMPLEMENTS` lists the `REQ` ids the change satisfies; `PRESERVES` lists the `CONSTRAINT`/`INVARIANT` ids it must not violate; `CHANGED` names the modified surfaces (the basis for staleness detection); each `PROOF` line names a verification reference plus its observed `proof_result` — `passed | failed | blocked | unverified`.
- The lowercase `proof_result` is the *observed run outcome*; it maps **1:1** to the uppercase VERDICT core value at the `verify`/`review` step: `passed -> PASS`, `failed -> FAIL`, `blocked -> BLOCKED`, `unverified -> UNVERIFIED`. The verdict has **7 values total — 4 core** (`PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED`) **+ 3 lifecycle** (`WAIVED`/`STALE`/`CONTRADICTED`) — but `implement` only ever produces the core observation; the lifecycle decorators are applied later at `review`.
- A TRACE that claims `IMPLEMENTS` **MUST carry at least one `PROOF` line** — the grammar makes `PROOF` mandatory in a trace body, so a no-`PROOF` trace is a structural parse error (`SOL-S014`), not a missing-evidence lint. A `PROOF` line MUST reference real output: an unqualified "tests passed" is not admissible [[REFLEXION]](./research/sources.md#REFLEXION).
- A TRACE whose `IMPLEMENTS`/`PRESERVES` names an unknown obligation is `SOL-M003` (unbound cross-reference) — the same orphan-target condition the COVERAGE gate guards against.

In the structured form, these claims become `implements` and `preserves` edges in the single relationship store `edges[]` — the input the downstream `verify` and `review` steps join against the obligations.

## What `implement` MUST NOT do

The step frame and the trace contract together fence the change:

- **Only the assigned obligations.** `implement` produces the change for *the assigned obligations only*. Any change that is not traceable to an assigned obligation is an `## Unassigned changes` row in the trace (with reason + authorizing ID or `none`), to be judged at `review`.
- **Only within the declared write surfaces.** Owned paths MUST stay a subset of the assigned `WRITES` surfaces (G7 / `SOL-O005`).
- **No weakening of intent.** Constraints, invariants, and non-goals are preserved, not relaxed — changing obligation intent is an amendment decision (R-IMPROVE, at the [`improve` step](improve.md)), never an `implement` action.
- **No fabricated evidence.** A `PROOF` line references real verification output; schema-valid shape is not a proof.

## Task-kind contracts

`implement` is the one step whose carrier profile is selected **by task kind**, and that choice is not cosmetic: each `task_kind` carries a distinct *discipline* — a specific failure mode the step is built to prevent and a specific shape of evidence it must gather. The defaults below are design rationale, not gates; load what the task names, and where the work in front of you diverges from the shape, record the divergence in the task frame and pick the discipline whose description matches. The proof side of every one of these lives at the deterministic [`verify` step](verify.md) — these contracts say *what evidence to gather*; `verify` says *whether it counts*.

| `task_kind` | The discipline | The oracle it demands |
|---|---|---|
| `refactor` | **Behaviour-preservation.** The change restructures internals; it MUST NOT alter any observable behaviour. The whole risk is a behaviour delta smuggled in under the "purely internal" label — if behaviour moves, it is a `rewrite` or a `migration`, relabel it. | An equivalence (characterization) check that would *fail if behaviour changed* — property-based, differential, or golden-output. A green suite is necessary but not sufficient; it only covers what was already tested, so where no stronger check exists the trace records *why* the existing suite is a sufficient oracle for this change. |
| `rewrite` | **Two-surface verification.** A rewrite *deliberately* changes some behaviour, so unintended changes hide where intentional ones are permitted. Two surfaces must both be proven: the **delta** (the behaviour that was meant to change) and the **preserved surface** (everything else). | The delta is proven against its acceptance checks (each changed behaviour bound to a `test`/`command`/`manual` proof); the non-delta is proven by the same equivalence check `refactor` demands. The delta proves the intended change was built; preservation proves nothing else moved. |
| `migration` | **Wave-planning.** The implementation moves from API A to API B while the surface stays put; the failure modes are the permanent half-migration and the phantom completion (old-API callsites surviving in dynamic dispatch, registries, generated code, reflection). Plan the waves up front; migrate each file deliberately, never with a bulk codemod that silently breaks the one unusual callsite. | A callsite inventory taken up front, per-wave verification (validate + test green at every wave, never accumulating drift to the end), and a `git grep` of the old API driven to zero across the *whole* codebase — plus an explicit audit beyond grep for the references a text search cannot reach. Every shim carries a verifiable removable-when criterion. |
| `performance` | **Measure-first.** Optimisation of a *measured* bottleneck under a *stated* numeric target — never opportunistic tinkering, never a faster wrong answer. The discipline is numbers over vibes and correctness over speed. | A baseline measured *before* touching code, then a target measured under the **same protocol** — identical warmup, sample count, aggregate, hardware, environment — or the comparison is meaningless. Every change is benchmarked individually and the full suite runs after each, because a speedup that broke correctness is still a defect. |
| `fix` (flaky test) | **Reproduce-the-flake-first.** Non-deterministic failure is almost always a *real* signal about timing, ordering, shared state, or environmental coupling. The single most tempting non-fix — re-run until green, then ship the bug — is exactly what the discipline forbids; masking the flake (sleeps, widened assertions, quarantine-as-resolution) suppresses the signal instead of removing the cause. | Reproduce the flake *before* claiming to understand it (loop the test until it fires), root-cause it in production code or test setup rather than the assertion, then prove the fix by loop-running and pasting the pass/fail summary — every run passes, or it is not fixed. Swarm's `fix-flaky-test` step guide (`./library/code-skills/fix-flaky-test/SKILL.md`, under `task_kind: fix`) carries this as a narrow `implement` guide. |

## Related

- [`decompose` step](decompose.md) — partitions the structured form into write-disjoint `task.md` packets; the upstream step that hands `implement` its work and proves the COVERAGE gate.
- [`verify` step](verify.md) — the profile-independent step that turns `implement`'s TRACE `PROOF` evidence into a core verdict.
- [`review` step](review.md) — judges `## Unassigned changes`, resolves promotion items, and applies the three lifecycle verdict decorators (`WAIVED` / `STALE` / `CONTRADICTED`).
- [`promote` step](promote.md) — closes out the `## Promotion queue` discoveries before a task is allowed to close.
- [SOL language reference](./language/SOL.md) — the TRACE block grammar, `IMPLEMENTS`/`PRESERVES`/`CHANGED`/`PROOF`, and the lint codes referenced here.
- [`errors.md`](./language/errors.md) — the lint codes (`SOL-O005` / `SOL-O007` / `SOL-O008` / `SOL-M003` / `SOL-S014`) this step's gate and trace contract reference.
- [`task.md` artifact](./artifacts/task.md) — the `task.md` step-frame contract: frontmatter field set, `task_kind` enum, and the eight body sections.
- [`trace.md` artifact](./artifacts/trace.md) — the `trace.md` claim-contract: sections, per-binding provenance fields, and TRACE block structure.
- The **nine per-kind implement guides** — `write-feature`, `write-fix`, `write-refactor`, `write-rewrite`, `write-migration`, `write-performance`, `write-testing`, `write-documentation`, and the narrow `fix-flaky-test` — each a standalone procedure for one `task_kind` (SOFT control).
- The carrier-profile stances selected by task kind — `persona-janitor`, `persona-builder`, `persona-researcher` (and the other persona stances) — pick which discipline runs.
- The `empirical-proof` fragment — the no-fabricated-evidence discipline behind the `PROOF`-line rule.
