# How Swarm works: the flow

> What Swarm is and how a spec moves from human intent to durable memory. For the one-paragraph
> overview, see the [root README](././README.md); this page is the reference for the steps, the
> layers they move through, and the two-level phase/step model that schedules them.

Swarm is a **spec format plus the agents that build from it**. Human intent is written as a
controlled-markdown specification; the agents take that spec through an ordered, named sequence of
steps — sharpening it, structuring it, partitioning it into bounded tasks, implementing it,
verifying traces against the original obligations, and promoting durable discoveries back into
project memory — at an *evidenced* level of confidence.

Nothing here is shipped code: there is no runtime that runs these steps (Invariant 1). Every step,
gate, and emitter named below is a **contract** — checkable today by a human or agent following a
written step guide, and enforced by a future tool. A conformant repository MUST frame any emitted
artifact (the structured form, the plan) as "the contract a future tool emits," never as the output
of shipped tooling.

The point is **spec-as-code with verifiable output**: the written specification — not the code — is
the artifact tooling consumes, the established pattern of industry interface and configuration
languages. OpenAPI, Terraform, and Smithy each make a written spec the authoritative source from
which servers, clients, SDKs, and documentation are generated; Kubernetes objects carry a
desired-state `spec` reconciled against an observed-state `status`. Swarm extends that pattern from
interface shapes to behavioral obligations, and closes the loop with verification and promotion. The
output is required behavior that has been **proven, not merely asserted**.

---

## 1. The end-to-end flow

The full journey is an ordered chain of artifact transitions, each produced by a step (§2 below) and
consumed by the next:

```text
*.md  →  structured form (*.ir.json)  →  plan (*.plan.json)
            →  task.md  →  trace (*.trace.md)  →  review.md  →  promotion
   surface      lint/improve         lower/decompose        implement
                                  verify/review        promote
```

Read it as a single sentence: *capture intent as a spec, structure the spec into its obligations and
a plan, partition the plan into bounded task frames, let agents do the work and record what they did
as a trace, prove the trace against the obligations, judge it into a review verdict, then fold
durable discoveries back into memory.* The chain is what makes the output **verifiable**: nothing is
"done" until a bound proof has produced inspectable evidence and a verdict has been rendered against
the originating obligation (Invariant 5 — shape is not truth).

The structured form of the spec (the spec's obligations) is the **central object**: specs produce
obligations, the agents structure obligations into a plan and tasks, tasks implement obligations,
traces claim obligations, verification proves obligations, reviews judge obligations, and memory
records durable discoveries about obligations.

### The seven layers

The flow moves through a stack of **seven layers**. Each layer is produced from the one above it by a
named step (§2) and consumed by the one below it. The surface is human-authored; the middle layers
are machine-emitted (today, by an agent following a documented contract; later, by a tool); the JSON
layers are contract-only — reserved names with no shipped emitter (Invariant 1).

| Layer | Artifact(s) | Origin | Role |
| --- | --- | --- | --- |
| **Surface** | `*.md` | **Human-authored** (the only human-authored `.` artifact) | Captures intent as APS prose + SOL obligation blocks. |
| **Structured form** | `*.ir.json` | **Machine-emitted; contract-only name** (reserved; no shipped emitter — Invariant 1) | The spec's obligations: nodes are obligations + judgments, edges are relationships. The central object every step reads and writes. |
| **Plan** | `*.plan.json` | **Machine-emitted; contract-only name** (reserved; no shipped emitter) | The schedulable projection of the structured form: dependency DAG + write-conflict graph + bounded work packets. |
| **Execution** | `task.md` | **Human/agent working artifact** (plain `.md`) | One bounded work packet, one step — the unit handed to a single agent in a single lane. |
| **Trace** | `*.trace.md` | **Machine-emitted instance** (template `trace.md` is human-copyable) | TRACE blocks: IMPLEMENTS / PRESERVES / CHANGED / PROOF — the agent's claims about which obligations it discharged. |
| **Verdict** | `review.md` | **Human/agent working artifact** (`VERDICT` is a language block; `review.md` is its container — there is no `verdict.md`) | VERDICT blocks (core + lifecycle) + the merge gate. |
| **Promotion** | `finding.md`, `adr.md`, `memory/INDEX.md`, `memory/patterns/*.md` | **Human/agent working artifacts** | Durable discoveries anchored with provenance. |

The `spec.md` naming is the discriminator: a `.` filename is parsed or emitted by the agents; a
plain `.md` filename is a human/agent working artifact. The structured-form layer is what every step
operates on: `lint` annotates it with diagnostics, `improve` rewrites nodes without changing their
meaning, `lower`/`decompose` derive the plan's DAG and conflict graph from it, `implement` produces
traces that attach to its obligation nodes, `verify`/`review` attach verdicts to those nodes, and
`promote` reads the judged obligations to emit durable artifacts. The final merge gate is a predicate
over those obligations: every required obligation node carries a verdict of `PASS` or `WAIVED`, and
none is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED`.

---

## 2. Two levels: phases and steps

The flow is described at **two levels of granularity that MUST NOT be conflated**:

- A **phase** is a *conceptual stage*. The seven phases are a fixed-order taxonomy naming *where in
  the flow* a piece of work sits. Phases are descriptive grouping, **not schedulable units**.
- A **step** is a *schedulable transformation*. The nine steps are the concrete units of work an
  author, agent, or future tool actually runs; each consumes one or more artifacts and produces one
  or more artifacts.

Several steps MAY map to one phase (both `lower` and `decompose` sit in `LOWER`). No step spans two
phases except `lint`, which the mapping table assigns to two (`PARSE` + `NORMALIZE`) because it is
partly well-formedness detection and partly normalization of detected smells. The small fixed phase
taxonomy is the stable conceptual spine; the larger step set is the schedulable surface.

### 2.1 The seven phases (fixed order)

A conformant description MUST present them in exactly this order and MUST NOT add, remove, or reorder
them in v0.1:

```text
PARSE -> NORMALIZE -> LOWER -> EXECUTE -> VERIFY -> REVIEW -> PROMOTE
```

| Phase | What the phase establishes | Nature |
| --- | --- | --- |
| `PARSE` | Surface SOL is recognized; blocks, ids, clauses, modals identified; well-formedness (`SOL-S###`) decided. | Deterministic |
| `NORMALIZE` | The recognized spec is brought into canonical, smell-free, semantics-preserving form. | Deterministic + heuristic |
| `LOWER` | The normalized spec becomes the structured form (the obligations) and is partitioned into task-sized work packets. | Mostly deterministic |
| `EXECUTE` | Code, docs, and tests are produced against the structured work packets. | Heuristic |
| `VERIFY` | Each bound proof is run; each obligation receives a core verdict. | Deterministic |
| `REVIEW` | Trace claims judged against obligations, diffs, evidence; lifecycle decorators applied; merge gate computed. | Hybrid |
| `PROMOTE` | Durable discoveries become findings, ADRs, memory, or spec amendments. | Hybrid but routable |

### 2.2 The nine steps (flow order)

```text
author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote
```

This is the default sequencing. A launcher MAY interleave steps across multiple specs, but **for a
single obligation the partial order MUST be respected** — an obligation cannot be `verify`-ed before
it is `implement`-ed, nor `implement`-ed before `lower`-ed. There is no runtime: each step is a
contract performed today by a human or agent following a step guide.

### 2.3 Step-to-phase mapping (normative)

| Step | Phase(s) | Input → Output | What it does | Lint layer touched |
| --- | --- | --- | --- | --- |
| `author` | entry (pre-`PARSE`) | chat / `research.md` / `audit.md` / `bug-report.md` / prior spec → `spec.md` draft | Captures human intent as SOL obligations + APS prose. | — (produces input to lint) |
| `lint` | `PARSE` + `NORMALIZE` | `spec.md` → lint report + blocking status | Detects defects **without changing semantics**; decides well-formedness, surfaces smells. | S / P / M / V / O |
| `improve` | `NORMALIZE` | spec + lint report → normalized spec + improvement report | Applies the closed 10-operation set (§3), strictly semantics-preserving. | answers the codes mapped in §3 |
| `lower` | `LOWER` | approved spec → `*.ir.json` | Assigns node ids, builds typed edges, normalizes `verify_by`, emits the two derived graphs. | `SOL-O###` |
| `decompose` | `LOWER` | `*.ir.json` → `task.md` packets (+ `*.plan.json`) | Partitions the obligations into write-disjoint work packets. | `SOL-O###` (e.g. `SOL-O005`) |
| `implement` | `EXECUTE` | `task.md` → code/docs/tests + `trace.md` | Produces the change for assigned obligations only; records TRACE claims, gathers evidence. | — (claims feed verify/review) |
| `verify` | `VERIFY` | `trace.md` + bound proofs + `AGENTS.md > Commands` → per-obligation core verdict | Runs each `VERIFY BY` binding through its resolved adapter; one verdict per binding. | `SOL-V###` |
| `review` | `REVIEW` | spec + `trace.md` + diff + evidence → `review.md` | Judges claims; applies lifecycle decorators; computes the merge gate. | `SOL-M###`, `SOL-V###` |
| `promote` | `PROMOTE` | discoveries + `trace.md` + `review.md` + source authority → `finding.md` / `adr.md` / amendment / memory update | Moves durable discoveries into provenance-anchored artifacts. | — (routes through source authority) |

**Step contract notes:**

- `author` precedes `PARSE`: its output is the first analyzable artifact and is not itself analyzable.
- `lint` is **non-mutating** — diagnostics only. The **only** step permitted to rewrite the spec is
  `improve`, and only semantics-preservingly.
- `improve` runs **only after** `lint`; with no lint findings to answer it is a no-op.
- `lower` requires an **approved, lint-clean** spec. An unresolved BLOCKING diagnostic or a blocking
  `QUESTION` MUST NOT be lowered (see §4.5).
- `decompose` consumes the **structured form**, not the surface spec, so packet boundaries come from
  the typed obligations.
- `verify` is the **only profile-independent step** — deterministic evidence-gathering; no heuristic
  profile alters whether a run `PASS`-es.

### 2.4 The shipped step guides, implement & author guides, fragments, and profiles

A **step guide** is a lazily-loaded procedural document (Swarm's term for what the broader agent
ecosystem calls a "skill"). Step guides are SOFT control (Invariant 2): they MUST NOT define SOL/APS
semantics, modality, authority order, or verification meaning — those live only in SOL and the
structured form. Swarm ships its conditioning layer as step guides, per-kind implement & author
guides, cross-cutting fragments, and 13 profiles, every one a `SKILL.md` (ADR-0042) — **split by
role** (ADR-0051): the **authoring** set ships in the starter kit (`starter-kit/.agents/skills/`);
the **implement** set is reference in `docs/library/code-skills/`. Across the nine steps: `author` is
served by **six author guides** (`write-spec`, `write-audit`, `write-research`, `write-bug-report`,
`write-prd`, `write-rfc`); `lint`, `improve`, `lower`, `decompose`, `review`, and `promote` each have
a step guide (`pass-lint-spec`, `pass-improve-spec`, `pass-lower-spec`, `pass-decompose-spec`,
`pass-review-trace`, `pass-promote-findings`); `implement` is served by **nine per-kind implement
guides** (`write-feature` … `write-documentation`, plus the narrow `fix-flaky-test`, in
`code-skills/`); `verify` is served by the `empirical-proof` fragment. Every step now has a guide; a
guide is an optional aid, not a conformance gate — the step contract is the binding artifact. (Naming
note: adversarial review is not its own guide — it is `review[profile: skeptic]`, where `skeptic` is
one of the 13 `persona-*` profiles — 6 ship in the kit, 7 are `code-skills/` reference.) Step-guide
bodies follow the established skill-authoring discipline — a ~500-line body cap, a third-person
description, progressive disclosure, and an explain-the-WHY pattern
[[SKILLBP]](./research/sources.md#SKILLBP).

---

## 3. The improve operation set

`improve` is the `NORMALIZE`-phase step that rewrites a spec to satisfy SOL and APS. It is a **closed
set of exactly ten operations** — a conformant step MUST NOT invent operations outside it, and
"improve the spec" with no named operation is not a valid request.

```text
NORMALIZE  ATOMIZE  CONCRETIZE  QUANTIFY  BIND  SCOPE  CLARIFY  DECONFLICT  COMPRESS  PROMOTE
```

### 3.1 The hard rule: improve is semantics-preserving

> **R-IMPROVE.** Every improve operation MUST be strictly semantics-preserving. It MUST NOT add,
> remove, weaken, strengthen, or otherwise change the **intent** of any obligation. Any intent change
> — a new requirement, a relaxed constraint, a different actor, a changed trigger or response — MUST
> route to **amendment/review**, never to `improve`.

Two corollaries:

- The improvement report MUST carry a *Semantic changes* row, flagged `requires approval: yes`, for
  any edit the author is unsure preserves intent; such edits belong to amendment, not `improve`.
- **R-DECOMPOSE-NOT-IMPROVE.** `decompose` is a *step* (§4), not an improve operation — it changes
  the artifact partition, not the prose. `ATOMIZE` is distinct: it splits one bundled obligation into
  multiple obligations *within the same spec*, preserving the spec as the unit.

### 3.2 The ten operations (normative)

Each operation is triggered by one or more lint codes, with a precondition and a postcondition.
Trigger codes use the unified `SOL-<LAYER>###` namespace; APS violations surface as `SOL-P###` codes.

| # | Operation | Trigger code(s) | Repairs |
| --- | --- | --- | --- |
| 1 | `NORMALIZE` | `SOL-P003`, `SOL-V###` | Informal/lowercase modal or non-canonical phrasing → approved uppercase modal in canonical clause order; no meaning changed. |
| 2 | `ATOMIZE` | `SOL-P004` | One block bundling ≥2 separable obligations → each its own block with its own id; bindings distributed. |
| 3 | `CONCRETIZE` | `SOL-P005` | Vague-quality word with no observable criterion → replaced by **observable behavior** (actor + action + object). |
| 4 | `QUANTIFY` | `SOL-P005` | Unbounded quality with no measurable threshold → carries a **measurable threshold** or named measurable criterion. |
| 5 | `BIND` | `SOL-V001`, `SOL-V###` | Obligation lacking a binding/source/interface/trace → valid `VERIFY BY <type>:<adapter>:<artifact>` + required references (covers both the proof binding and its trace references). |
| 6 | `SCOPE` | `SOL-O###` | Missing non-goals / applicability / write surfaces / exclusions → explicit `Non-goals` / applicability / `WRITES` / exclusions present. |
| 7 | `CLARIFY` | `SOL-P008` | Behavioral uncertainty buried in prose → an explicit interpretation **OR** a `QUESTION` block. |
| 8 | `DECONFLICT` | `SOL-M002` | Two obligations (or obligation vs higher artifact) contradict → resolved per source authority, or raised to amendment. |
| 9 | `COMPRESS` | `SOL-P054`, `SOL-P055` | Non-load-bearing noise / redundancy → removed; text interpreted consistently (covers both redundancy removal and consistent-reading stabilization). |
| 10 | `PROMOTE` | promotion protocol | Durable fact in task-local state → moved to `finding.md` / `spec.md` / `adr.md` / memory with provenance. |

`CONCRETIZE` and `QUANTIFY` share trigger `SOL-P005` but differ in repair: `CONCRETIZE` substitutes
*observable behavior* (qualitative), `QUANTIFY` a *measurable threshold* (quantitative). The author
picks whichever the obligation's nature requires; both exit the same code.

### 3.3 Semantic-diff classification (the operational test)

Every spec edit reaching `improve` or `review` MUST be classified into **exactly one of twelve closed
categories**. An edit fitting none is itself a defect (an unanalyzable diff) and MUST be split until
each part classifies. The classification converts a free-form text diff into a typed change whose
approval requirement is then mechanical.

Categories 1–11 are all **amendments** that MUST route to approval: added obligation, removed
obligation, changed trigger, changed actor, changed modality, changed response, changed proof
binding, changed non-goal, changed interface, changed invariant, changed question status. **Category
12 — pure normalization** (formatting, casing, keyword form, canonical clause order, dead-link/proof-ref
completion, redundancy compression, with **no** change to any obligation's
actor/trigger/modality/response/binding/non-goal/interface/invariant/question status) is the **only
auto-approved class**.

> **R-SEMDIFF.** Pure normalization is the only auto-approved class. An unclassified edit MUST NOT be
> promoted. An edit that *combines* normalization with any of categories 1–11 is classified by its
> **strongest (non-normalization) category** — normalization never "absorbs" a semantic change ridden
> in alongside it.

This is the operational test behind R-IMPROVE: an improve operation is legitimate **iff** every edit
it makes classifies as category 12. The moment an edit classifies as 1–11, the work has left
`improve` and entered amendment.

---

## 4. Lowering and decomposition

`LOWER` turns a normalized, approved spec into machine-shaped work. Two steps occupy it: `lower`
(structuring SOL surface → the obligations) and `decompose` (the obligations → task-sized work
packets). They are separate steps — different inputs, outputs, and failure modes; conflating them
would mix building the structured form with work partitioning. Throughout `LOWER`, the
**distillation-loss discipline** is in force: structuring MUST preserve every obligation, modality,
actor, trigger, response, constraint, invariant, verification binding, and the authority of each
obligation. Dropping any is a **distillation error**, not an optimization.

### 4.1 The `lower` step

`lower` consumes an approved `spec.md` and produces `*.ir.json`. Mostly deterministic. It
MUST, in order: **(1)** assign each surface block (e.g. `AC-001`) a node id, stable, optionally
namespaced as `REQ.<spec>.AC-001`; **(2)** emit relationships as `edges[]` `{from, to, type, hard}`
with `type ∈ {depends_on, blocks, conflicts_with, verified_by, affects, implements, preserves}` —
edges are the **single source of relationship truth**, never duplicated as a node scalar
(`AFFECTS <node-id>` → `affects`; `AFFECTS <surface>` → `conflicts_with`, never `affects`; `WRITES`
overlap → `conflicts_with`; each `VERIFY BY` → `verified_by`); **(3)** normalize each surface
`VERIFY BY <type>:<adapter>:<artifact>[#selector]` to `{type, adapter, ref, selector, gate}`, the
adapter recorded as written and resolved through `AGENTS.md > Commands` **at verify time**, not at
structuring time; **(4)** emit the two derived graphs — a **dependency DAG** from `depends_on` edges
and a **write-surface conflict graph** from `WRITES`/`SURFACE` and the READS/WRITES rule below — the
substrate the safe-parallelism predicate (§5) runs on. The per-step page [`lower`](./passes/lower.md)
carries the full procedure.

### 4.2 AND THE chaining

A `REQ` MAY chain obligations with `[AND THE <actor> <MODAL> <response>]*`lower` MUST split each
chained clause into a **distinct obligation node**, one per `THE`/`AND THE` clause, each inheriting
the parent's bindings unless overridden. The *n*-th clause (the leading `THE` is 1, each `AND THE`
thereafter) structures to id `<surface-id>.<n>` (e.g. `AC-001.1`, `AC-001.2`). A surface
`TRACE`/`VERDICT` targeting the parent distributes over all split sub-obligations; the merge gate
requires **every** split sub-obligation to carry `PASS`/`WAIVED`.

> **R-CHAIN.** Chained obligations structure into multiple distinct obligations. When one block chains
> **more than two** obligations (three or more clauses), `lower` MUST emit a `SOL-P004`-adjacent
> **warning** (bundled-obligation smell) suggesting `ATOMIZE`. It MUST NOT be a hard error — chaining
> is permitted; two chained clauses → no warning.

### 4.3 The `decompose` step

`decompose` consumes `*.ir.json` and produces `task.md` work packets. It is the machinery that
partitions the obligations into bounded, write-disjoint work — a deliberate decomposition of the task
rather than a single flat step [[TREEOFTHOUGHTS]](./research/sources.md#TREEOFTHOUGHTS). It MUST
**partition** obligations into work packets (each carrying its assigned obligations,
constraints/invariants in force, interfaces touched, write surfaces, and verification bindings — the
`task.md` contract); **project** each packet's owned paths from its assigned obligations' `WRITES`
surfaces; and **compute merge order** from `depends_on` edges as a partial order, proving owned paths
of any two parallel-scheduled packets pairwise disjoint via the write-surface conflict graph (§5). The
per-step page [`decompose`](./passes/decompose.md) carries the full procedure.

### 4.4 Key structuring rules

- **Owned-path containment — R-OWNED-SUBSET.** An execution-tier owned path MUST be a subset of the
  union of its assigned obligations' `WRITES` surfaces. A path touching a file outside any assigned
  obligation's declared write surface is lint code **`SOL-O005`**.
- **Distillation-loss.** Dropping an obligation id, modality, actor, trigger, response, constraint,
  invariant, or verification binding during structuring is a **hard failure** of the step, not a
  triageable warning. Authority MUST ride onto each structured node so a downstream conflict resolves
  without re-reading the surface. An obligation reaching `decompose` with no `verify_by` is a
  `SOL-V001`-class defect that `BIND` should have answered during `improve`.
- **READS/WRITES conflict rule.** Conflict-serializability: `READS`/`READS` on the same surface is
  parallel-safe (no edge); `READS`/`WRITES` or `WRITES`/`WRITES` on the same surface is a conflict
  (`conflicts_with` edge). A `SURFACE` MAY carry an attribute (`append-only`, `integration`, `shared`)
  so shared/global/append-only surfaces aren't treated as ordinary write conflicts. `lower` only emits
  the edges; the full predicate is §5.

### 4.5 The two `LOWER` gates

`LOWER` is bracketed by two **gates**. A gate is **not a transformation** — it writes no artifact; it
is a precondition predicate over already-emitted state. Both are contracts checkable today by review
and enforced by a future tool (no runtime). A future tool MUST compute both predicates mechanically
from `nodes[]`, `edges[]`, and the plan `packets[]`; until one ships, a conformant repo MUST state
both as review-checkable contracts and MUST NOT claim either is tool-enforced.

> **Gate vs improve-op (normative).** The CLARIFY *gate* and the `CLARIFY` *improve operation* (§3, op
> 7) are distinct and MUST NOT be conflated. The op is a **local edit** in `NORMALIZE` that lifts one
> buried ambiguity (`SOL-P008`) into an interpretation or a `QUESTION`. The gate is a **checkpoint**
> at the `NORMALIZE`→`LOWER` boundary that refuses to advance while any such question is open and
> blocking. The op *creates* the QUESTION; the gate *waits on* it.

**CLARIFY gate (pre-`lower`) — R-CLARIFY-GATE.** `lower` MUST NOT proceed for an obligation while any
of these hold for it:
- an unresolved `[blocking]` `QUESTION` `AFFECTS` it (answered, or downgraded to `[non-blocking]` with
  rationale, clears it);
- a blocking `SOL-M002` (contradiction) names it;
- an unresolved `SOL-P008` (uncaptured behavioral ambiguity) attaches to it.

This is the **named generalization** of R-BLOCKING-Q: a `[blocking]` `QUESTION` reaching `lower` is
orchestration error `SOL-O003`; R-CLARIFY-GATE lifts that into a three-condition checkpoint that also
catches `SOL-M002` and `SOL-P008`. The codes are unchanged — a tripped gate surfaces as the *existing*
code for whichever condition tripped it; the gate aggregates, it is not a new diagnostic.

> Design rationale: the planner-to-coder handoff is the dominant multi-agent failure surface, and
> ambiguity that survives into structuring is what later strands a coder. The gate forces a
> blocking question, a contradiction, or an uncaptured behavioral ambiguity to resolve at the cheapest
> point — before generation — rather than the most expensive one.

**COVERAGE gate (pre-`implement`) — R-COVERAGE-GATE.** Before any `implement` step runs:
1. **Total coverage.** Every structured obligation node (every `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`,
   including each `AND THE`-split sub-obligation) is assigned to **exactly one `implement` packet**.
   Uncovered = `SOL-O007` (BLOCKING; resolves by `SCOPE`). Double-owned = `SOL-O008` (BLOCKING). (An
   obligation legitimately appears in its `implement`, `verify`, and `review` packets across steps; the
   count is per `implement` packet.)
2. **No orphan targets.** Every `verified_by` edge and every TRACE `implements`/`preserves` edge
   resolves to a real node id in `nodes[]`. An unresolved target is `SOL-M003` (unbound-cross-reference,
   surfaced at `review`).

The COVERAGE gate is the structural complement of distillation-loss: distillation-loss forbids
*dropping* an obligation during structuring; COVERAGE forbids *stranding* one afterward. Together they
make the structured work a bijection over obligations — nothing lost, nothing left uncovered or
pointed at a phantom.

| Gate | Boundary | Predicate (MUST hold to advance) | Surfaced as | Carrier (manual today) |
| --- | --- | --- | --- | --- |
| CLARIFY | `NORMALIZE` → `LOWER` | No open `[blocking]` `QUESTION`, no blocking `SOL-M002`, no unresolved `SOL-P008` on an in-scope obligation | `SOL-O003` / `SOL-M002` / `SOL-P008` (existing codes) | `lint` (Skeptic) |
| COVERAGE | `LOWER` → `EXECUTE` | Every obligation covered by exactly one packet; every TRACE/verdict target resolves | `SOL-O007` (uncovered), `SOL-O008` (double-owned), `SOL-M003` (orphan) | `decompose` (Lead Engineer) |

Neither gate is a new step; both reuse the existing step surface and the `SOL-<LAYER><NNN>` namespace,
adding only the two new orchestration codes `SOL-O007` and `SOL-O008`.

---

## 5. The plan

The **plan** is the **schedulable projection of the structured form**: it takes the obligations
(nodes + edges) and groups the work to discharge them into **work packets** — units a launcher could
hand to one agent in one lane. Where the structured form answers "what must hold and how do the
obligations relate," the plan answers "what units of work exist, in what order, on which surfaces, and
which are safe to run at the same time." The plan is Swarm's **static coordination contract** (§5.1) —
*not* a running scheduler. The file uses the spec.md convention: `auth-refresh.ir.json` plans to
`auth-refresh.plan.json`.

> **Contract, not executor (normative).** The plan schema is **documented, versioned data**. **Plan
> derivation is the `decompose` step** — there is no separate "planner" step. What is **out of Swarm's
> scope** is the **scheduler/harness** that would execute the packets live across agents (a launcher
> concern). This repository ships **no running emitter and no scheduler** (Principle 1): frame any
> `.plan.json` as "the contract a future tool emits and a future launcher consumes."

A plan document is a single JSON object with **exactly four top-level keys** (`meta`, `packets`,
`edges`, `provenance`); each **work packet** is one schedulable unit — a single step applied (under an
optional profile) to a selected set of obligations, with declared scope (`writes`/`reads`),
ordering (`depends_on`), and a merge-safety verdict (`merge_safe`). It carries no `locks` field;
lock-set analysis *is* write-set analysis at surface granularity (§5.1). The full envelope, the
per-packet field table, and the JSON Schema are in [the structured-form reference](./reference/structured-form.md).

### 5.1 The safe-parallelism predicate

`merge_safe` is the surface of Swarm's single canonical safe-parallelism predicate:

> Two work packets MAY run in parallel **iff** they are **dependency-independent** (neither reachable
> from the other along `depends_on` edges) **AND write-disjoint** (their `writes` sets share no
> SURFACE, no read/write conflict on a shared surface, no shared interface/migration node). Anything
> unscoped or sharing a surface **serializes by default**.

A packet's `merge_safe` MUST be `false` if it has any unresolved `conflicts_with` edge to a packet in
the same `batch`, or if any input is unscoped (empty `writes` where a write is implied). `merge_safe`
is Swarm's **static** verdict; a launcher MAY further serialize but MUST NOT parallelize two packets
the plan marks unsafe. Review entropy and merge collisions, not agent count, are the binding
constraint on safe parallelism.

---

## Related

Other framework pages that this flow reads, writes, or hands off to:

- **The nine steps in depth** — one page per step: [`author`](./passes/author.md), [`lint`](./passes/lint.md), [`improve`](./passes/improve.md), [`lower`](./passes/lower.md), [`decompose`](./passes/decompose.md), [`implement`](./passes/implement.md), [`verify`](./passes/verify.md), [`review`](./passes/review.md), [`promote`](./passes/promote.md).
- **The surface layer** — the obligation language and prose standard the spec is authored in: [SOL](./language/SOL.md), [APS](./language/APS.md), and the [lint catalogue](./language/errors.md).
- **The structured form and plan in depth** — the JSON envelopes and schemas: [structured form](./reference/structured-form.md).
- **Truth and judgment** — what `verify`/`review` render: [proof types](./reference/proof-types.md) and the [seven-value verdict model](./adrs/0035-seven-value-verdict-model.md).
- **Promotion and memory** — where durable discoveries land: the [promotion protocol](./reference/promotion-protocol.md).
- **Distillation discipline** — the loss budget that structuring MUST respect: [distillation loss budget](./reference/distillation-loss-budget.md).
- **Coordination** — the workspace and authority model the plan and promotion sit inside: [workspace](./workspace.md) and [source authority](./source-authority.md).
- **Conformance** — what makes a valid Swarm repo faithful to this flow: [conformance](./conformance.md).
