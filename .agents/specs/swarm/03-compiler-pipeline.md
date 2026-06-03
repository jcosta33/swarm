# Swarm Kernel Specification v0.1 — Part 03: The compiler pipeline (phases, passes, IR)

<!-- Part 03 of the Swarm Kernel Specification (§9–§13). All parts share one section numbering (§0–§35 + Appendices A–G); cross-references of the form “§N” resolve via the index in [README.md](./README.md). -->

## 9. Phases and passes

Swarm models the journey from a human-authored specification to a promoted, verified change as a **compiler pipeline**. This pipeline is described at two levels of granularity that MUST NOT be conflated:

- A **phase** is a *conceptual compiler stage*. The seven phases are a fixed-order taxonomy that names *where in the pipeline* a piece of work sits. Phases are descriptive grouping, not schedulable units.
- A **pass** is a *schedulable transformation*. The nine passes are the concrete units of work an author, agent, or future tool actually runs. A pass consumes one or more artifacts and produces one or more artifacts.

Several passes MAY map to one phase (for example, both `lower` and `decompose` sit in the `LOWER` phase). No pass spans two phases except where the mapping table below assigns it two (`lint` straddles `PARSE` and `NORMALIZE` because it is partly well-formedness detection and partly the normalization of detected smells into a NORMALIZE-ready spec). Rationale: compiler theory distinguishes phase (a stage) from pass (a traversal), and "several phases can group into one pass" — Swarm inverts the common case so that the small, fixed phase taxonomy is the stable conceptual spine and the larger pass set is the schedulable surface.

This section is normative for the two-level model, the pass→phase mapping, and the per-pass contract. The semantics of the transformations themselves are specified elsewhere: the `improve` operation set in §10; `lower` and `decompose` in §11; the verification model behind `verify` in §14 and §15; promotion in §10 (operation `PROMOTE`) and the promotion protocol; the orchestration graphs that `lower` emits in §18.

### 9.1 The seven phases

The phases are conceptual compiler stages in a single fixed order. A conformant description of the Swarm pipeline MUST present them in exactly this order and MUST NOT add, remove, or reorder them in v0.1.

```text
PARSE -> NORMALIZE -> LOWER -> EXECUTE -> VERIFY -> REVIEW -> PROMOTE
```

| Phase | What the phase establishes | Nature |
| --- | --- | --- |
| `PARSE` | Surface SOL is recognized; blocks, ids, clauses, and modals are identified; well-formedness (`SOL-S###`) is decided. | Deterministic |
| `NORMALIZE` | The recognized spec is brought into canonical, smell-free, semantics-preserving form (prose, semantic, verification, orchestration smells answered). | Deterministic + heuristic |
| `LOWER` | The normalized spec becomes the IR obligation graph and is partitioned into task-sized work packets. | Mostly deterministic |
| `EXECUTE` | Code, docs, and tests are produced against the lowered work packets. | Heuristic |
| `VERIFY` | Each bound proof is run; each obligation receives a core verdict (§14, §15). | Deterministic |
| `REVIEW` | Trace claims are judged against obligations, diffs, and evidence; lifecycle decorators are applied; the merge gate is computed (§14). | Hybrid |
| `PROMOTE` | Durable discoveries become findings, ADRs, memory, or spec amendments (§10 `PROMOTE`, §23). | Hybrid but routable |

### 9.2 The nine passes

The passes are the schedulable transformations, listed in pipeline order. This order is the default sequencing; a launcher MAY interleave passes across multiple specs, but for a single obligation the partial order of passes MUST be respected (an obligation cannot be `verify`-ed before it is `implement`-ed, nor `implement`-ed before it is `lower`-ed).

```text
author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote
```

There is NO runtime that runs these passes (Invariant 1, §2). Each pass is documented as a contract a future tool — or, today, a human or agent following a pass guide — performs by hand.

### 9.3 Pass-to-phase mapping (normative)

| Pass | Phase(s) | Input artifact | Output artifact | What it does | Typical profile (§27) | Lint layer (§8) |
| --- | --- | --- | --- | --- | --- | --- |
| `author` | entry (pre-`PARSE`) | chat, `research.md`, `audit.md`, `bug-report.md`, prior `spec.swarm.md` | `spec.swarm.md` (draft, prose + SOL blocks) | Captures human intent as SOL obligations and APS prose. | Architect (spec), Surveyor/Researcher (research), Auditor (audit), Bug Hunter (bug-report) | — (produces input to lint) |
| `lint` | `PARSE` + `NORMALIZE` | `spec.swarm.md` | lint report `{code, severity, layer, span, message, suggest}[]`, blocking status | Detects defects without changing semantics; decides well-formedness and surfaces smells. | Skeptic | `SOL-S###` (syntax), `SOL-P###` (prose), `SOL-M###` (semantic), `SOL-V###` (verification), `SOL-O###` (orchestration) |
| `improve` | `NORMALIZE` | `spec.swarm.md` + lint report | `spec.swarm.md` (normalized) + spec-improvement report | Applies the closed 10-operation improve set (§10), strictly semantics-preserving. | Architect / Skeptic | answers the lint codes mapped in §10 |
| `lower` | `LOWER` | approved `spec.swarm.md` | `*.swarm.ir.json` (IR obligation graph + the two derived graphs, §11, §18) | Assigns IR node ids, builds typed edges, normalizes `verify_by`, emits the dependency DAG and the write-surface conflict graph. | Lead Engineer | `SOL-O###` (orchestration: cycles, write-conflicts, blocking QUESTION reaching lowering) |
| `decompose` | `LOWER` | `*.swarm.ir.json` | `task.md` work packets (and, named-as-contract, `*.swarm.plan.json`) | Partitions the obligation graph into task-sized, write-disjoint work packets with assigned obligations, write surfaces, and verification bindings (§11). | Lead Engineer | `SOL-O###` (scope/ownership, e.g. `SOL-O005`) |
| `implement` | `EXECUTE` | `task.md` | code/docs/tests changes + `trace.md` (`*.swarm.trace.md` when emitted) | Produces the change for the assigned obligations only; records TRACE claims and runs bound proofs to gather evidence. | Janitor, Migrator, Performance-Surgeon, Builder, Test-Author, Documentarian (by task kind, §28) | — (claims feed `verify`/`review`) |
| `verify` | `VERIFY` | `trace.md` + bound proofs + AGENTS.md > Commands | per-obligation core verdict (`PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED`) | Runs each `VERIFY BY` binding through its resolved adapter; one verdict per binding (§14, §15). | — (executable; profile-independent) | `SOL-V###` (verification) |
| `review` | `REVIEW` | source spec, `trace.md`, diff, verification evidence | `review.md` (verdict matrix, unauthorized-change list, lifecycle decorators, final verdict, merge-gate result, promotion queue) | Judges claims against obligations; applies lifecycle decorators (`WAIVED`/`STALE`/`CONTRADICTED`); computes the merge gate (§14). | Skeptic | `SOL-M###`, `SOL-V###` (contradiction, stale/missing proof surfaced as review findings) |
| `promote` | `PROMOTE` | task discoveries, `trace.md`, `review.md`, promotion protocol, source-authority rules (§22) | `finding.md` / `adr.md` / `audit.md` / spec amendment / `memory/INDEX.md` update + promotion report | Moves durable discoveries out of task-local state into durable, provenance-anchored artifacts (§23). | Lead Engineer / Skeptic | — (routes through source authority §22) |

#### 9.3.1 Pass contract notes

- **`author`** is an entry pass: it precedes `PARSE` because its output (`spec.swarm.md`) is the first compiler-visible artifact. The author pass is not itself analyzable; everything downstream is.
- **`lint` is non-mutating.** It MUST NOT change spec semantics or text; it only emits diagnostics. The only pass permitted to rewrite the spec is `improve`, and only semantics-preservingly (§10).
- **`improve` runs only after `lint`** because each improve operation is triggered by one or more lint codes (§10). Running `improve` with no lint findings to answer is a no-op.
- **`lower` requires an approved, lint-clean spec.** A spec carrying an unresolved BLOCKING diagnostic, or a blocking `QUESTION` block, MUST NOT be lowered; a blocking `QUESTION` reaching the `lower` pass is an orchestration error (§11.4).
- **`decompose` consumes the IR, not the surface spec.** It MUST operate on `*.swarm.ir.json` so that work-packet boundaries are computed from the typed graph (the two derived graphs of §18), not re-parsed from prose.
- **`verify` is the only profile-independent pass.** Because verification is deterministic evidence-gathering, no heuristic profile (§27) alters its outcome. A profile MAY influence which proofs are *demanded* at `author`/`review`, but never whether a run `PASS`-es.

### 9.4 The five stdlib pass guides

A **pass guide** is a lazily-loaded procedural document (a "skill" in legacy vocabulary, §26) that tells an agent how to perform a pass well. Pass guides are SOFT control (Invariant 2, §2): they MUST NOT define SOL/APS semantics, modality, authority order, or verification meaning — those live only in SOL and the IR.

Of the nine passes, exactly five ship with a **stdlib pass guide** in v0.1 — the first passes to be tooled, and a deliberate subset:

| Stdlib pass guide | Pass | Carrier profile (§27) | Rationale |
| --- | --- | --- | --- |
| `lint` | `lint` | Skeptic | Highest leverage: catches defects before any work is committed. |
| `decompose` | `decompose` | Lead Engineer | The new machinery the legacy 18-task-type model lacked; gates safe parallelism (§18). |
| `implement` | `implement` | by task kind (§28) | The most-run pass; benefits most from a written procedure. |
| `review[profile: skeptic]` | `review` | Skeptic (parameter) | Adversarial review folds into the review pass as a profile parameter, not a separate pass. |
| `promote` | `promote` | Lead Engineer | Prevents durable knowledge dying in a transcript (§23). |

The remaining four passes (`author`, `improve`, `lower`, `verify`) are fully specified by this document and the language references; they MAY gain stdlib pass guides in a later framework release without any language-version change (§25). Naming note: the legacy `adversarial-review` skill is not a pass guide of its own — it is `review[profile: skeptic]`.

---

## 10. The improve operation set

`improve` is the `NORMALIZE`-phase pass that rewrites a spec to satisfy SOL and APS. It is defined as a **closed set of exactly ten operations**. The set is closed: a conformant `improve` pass MUST NOT invent operations outside this set, and "improve the spec" with no named operation is not a valid request.

```text
NORMALIZE  ATOMIZE  CONCRETIZE  QUANTIFY  BIND  SCOPE  CLARIFY  DECONFLICT  COMPRESS  PROMOTE
```

### 10.1 The hard rule: improve is semantics-preserving

> **R-IMPROVE.** Every improve operation MUST be strictly semantics-preserving. An improve operation MUST NOT add, remove, weaken, strengthen, or otherwise change the **intent** of any obligation. Any change to obligation intent — a new requirement, a relaxed constraint, a different actor, a changed trigger or response — MUST route to **amendment/review**, never to `improve`.

Rationale: `improve` is the normalization phase; intent change is a `PROMOTE`/amendment decision governed by source authority (§22). Conflating the two would let a "cleanup" silently rewrite what the system builds — a direct violation of "code is reality, not intent" (Invariant 4, §2). The spec-improvement report (§9.3, `improve` output) MUST carry a *Semantic changes* row for any edit the author is unsure preserves intent, flagged `requires approval: yes`; such edits are out of scope for `improve` and belong to amendment.

> **R-DECOMPOSE-NOT-IMPROVE.** `decompose` is a PASS (§9, §11), NOT an improve operation. Splitting a spec into task-sized work packets is lowering work that changes the *artifact partition*, not the *prose*; it MUST NOT appear in the improve set. (The improve operation `ATOMIZE` is distinct: it splits one bundled obligation into multiple obligations *within the same spec*, preserving the spec as the unit.)

### 10.2 The ten operations (normative)

Each operation is triggered by one or more lint codes (§8), has a precondition (what must hold before it applies) and a postcondition (what it guarantees after). The trigger codes use the unified `SOL-<LAYER>###` namespace; legacy `APS-*` codes are retired (§8, Appendix B).

| # | Operation | Trigger lint code(s) | Precondition | Postcondition |
| --- | --- | --- | --- | --- |
| 1 | `NORMALIZE` | `SOL-P003`, `SOL-V###` | A clause uses an informal/lowercase modal or non-canonical phrasing/clause order. | Clause uses an approved uppercase modal in canonical clause order; no meaning changed. |
| 2 | `ATOMIZE` | `SOL-P004` | One block bundles two or more separable obligations. | Each separable obligation is its own block with its own id; bindings distributed. |
| 3 | `CONCRETIZE` | `SOL-P005` | A vague-quality word has no same-line observable criterion. | The word is replaced by observable behavior (actor + action + object). |
| 4 | `QUANTIFY` | `SOL-P005` | An unbounded quality has no measurable threshold. | The quality carries a measurable threshold or named measurable criterion. |
| 5 | `BIND` | `SOL-V001`, `SOL-V###` | An obligation lacks a `VERIFY BY` binding, source, interface, or trace reference. | The obligation carries a valid `VERIFY BY <type>:<adapter>:<artifact>` and required references (merges legacy `Bind` + `Trace`). |
| 6 | `SCOPE` | `SOL-O###` | The spec lacks declared non-goals, applicability, write surfaces, or exclusions. | Explicit non-goals / applicability / `WRITES` / exclusions are present. |
| 7 | `CLARIFY` | `SOL-P008` | Behavioral uncertainty is buried in prose, not lifted to a block. | The uncertainty is an explicit interpretation OR a `QUESTION` block. |
| 8 | `DECONFLICT` | `SOL-M002` | Two obligations (or an obligation and a higher artifact) contradict. | The contradiction is resolved per source authority (§22), or raised to amendment. |
| 9 | `COMPRESS` | `SOL-P054`, `SOL-P055` | Prose carries non-load-bearing noise or redundancy. | Noise/redundancy removed; future agents interpret the text consistently (merges legacy `Compress` + `Stabilize`). |
| 10 | `PROMOTE` | promotion protocol (§23) | A durable fact sits in task-local state. | The fact is moved to `finding.md` / `spec.swarm.md` / `adr.md` / memory with provenance. |

Note that `CONCRETIZE` and `QUANTIFY` share the trigger `SOL-P005` (vague-quality word with no observable criterion). They differ in repair: `CONCRETIZE` substitutes *observable behavior* (qualitative), `QUANTIFY` substitutes a *measurable threshold* (quantitative). The author selects whichever the obligation's nature requires; both exit the same lint code.

### 10.3 Worked before/after for each operation

```sol
NORMALIZE
  before:  WHEN request fails, the client should retry once.
  after:   WHEN the request fails THE client SHOULD retry once BECAUSE transient failures are common.

ATOMIZE
  before:  REQ AC-010: THE API MUST validate input AND log AND retry AND alert.
  after:   REQ AC-010: THE API MUST validate input.
           REQ AC-011: THE API MUST log the validation outcome.
           REQ AC-012: THE API MUST retry once on transient failure.
           REQ AC-013: THE API MUST alert on repeated failure.

CONCRETIZE
  before:  THE response MUST be fast.
  after:   THE service MUST return the first byte within the bound named by VERIFY BY perf:cmdBenchmark:p99.

QUANTIFY
  before:  THE service MUST handle high load.
  after:   THE service MUST sustain 1000 requests per second at p99 < 200ms.

BIND
  before:  REQ AC-020: THE worker MUST persist progress every 100 rows.
  after:   REQ AC-020: THE worker MUST persist progress every 100 rows
           VERIFY BY test:cmdTest:import.progress_checkpointing.

SCOPE
  before:  (spec has no non-goals)
  after:   ## Non-goals — Swarm MUST NOT define a runtime; WRITES src/auth/** only.

CLARIFY
  before:  The session probably clears, but caching behavior is unclear.
  after:   QUESTION Q-003: [blocking] Does session clear evict the token cache? AFFECTS AC-001.

DECONFLICT
  before:  AC-001 THE client MUST send a request; AC-009 THE client MUST NOT send a request (same trigger).
  after:   AC-001 retained per source authority; AC-009 superseded with REASON, or both raised to amendment.

COMPRESS
  before:  THE system, in order to be robust and resilient, MUST very carefully validate.
  after:   THE system MUST validate the request body.

PROMOTE
  before:  (task note: "discovered the refresh endpoint rate-limits at 5/min")
  after:   finding.md: claim + evidence + origin_obligations[] + applies-when.
```

---

### 10.4 Semantic-diff classification

Every spec edit reaching the `improve` or `review` pass MUST be classified into exactly one of the following **twelve categories**. The set is **closed**: a conformant pass MUST NOT invent a thirteenth category, and an edit that appears to fit none of these is itself a defect (an unanalyzable diff) that MUST be split until each part classifies. The classification is the bridge between §10's semantics-preserving rule (R-IMPROVE, §10.1) and §22.6's approval table: it converts a free-form text diff into a typed change whose approval requirement is then mechanical.

| # | Category | What changed | Auto-approved? |
| --- | --- | --- | --- |
| 1 | added obligation | A new `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE` block (a new obligation id) appears. | No — amendment (§22.6) |
| 2 | removed obligation | An existing obligation id is deleted or renumbered out of existence. | No — amendment (§22.6) |
| 3 | changed trigger | The `WHEN`/state precondition of an obligation is added, removed, widened, or narrowed. | No — amendment (§22.6) |
| 4 | changed actor | The `THE <actor>` subject of an obligation is replaced. | No — amendment (§22.6) |
| 5 | changed modality | The modal (`MUST`/`MUST NOT`/`SHOULD`/`SHOULD NOT`/`MAY`, §5) is strengthened, weakened, or negated. | No — amendment (§22.6) |
| 6 | changed response | The required action/object (the obligation's effect) is altered. | No — amendment (§22.6) |
| 7 | changed proof binding | A `VERIFY BY <type>:<adapter>:<artifact>[#selector]` is added, removed, or repointed to a different type/adapter/artifact/selector (§15). | No — amendment (§22.6) |
| 8 | changed non-goal | A `Non-goals`/applicability/`WRITES` exclusion is added, removed, or rescoped. | No — amendment (§22.6) |
| 9 | changed interface | An `INTERFACE` (`IF-NNN`) contract is altered. | No — amendment (§22.6); breaking changes are flagged per §22.6 |
| 10 | changed invariant | An `INVARIANT` (`I-NNN`) is added, removed, or restated with different force. | No — amendment (§22.6) |
| 11 | changed question status | A `QUESTION` (`Q-NNN`) changes lifecycle (raised, answered, downgraded `[blocking]`→`[non-blocking]`, or materially resolved). | No — amendment (§22.6) |
| 12 | pure normalization | Formatting, casing, keyword form (§4.10), canonical clause order, dead-link/proof-ref completion, or redundancy compression — with **no** change to any obligation's actor, trigger, modality, response, binding, non-goal, interface, invariant, or question status. | **Yes** — the only approval-free class |

> **R-SEMDIFF.** **Pure normalization is the only auto-approved class.** Every one of categories 1–11 is an **amendment** and MUST route to approval per §22.6. The `improve` and `review` passes MUST classify each edit before the spec is promoted; an unclassified edit MUST NOT be promoted (`PROMOTE`, §10.2). An edit that combines a normalization with any of categories 1–11 is classified by its strongest (non-normalization) category, never as pure normalization — normalization does not "absorb" a semantic change ridden in alongside it.

This is the operational test behind R-IMPROVE (§10.1): an `improve` operation (§10.2) is legitimate **iff** every edit it makes classifies as category 12. The moment an edit classifies as any of 1–11, the work has left `improve` and entered amendment, and the change report (§9.3) MUST record the category and carry `requires approval: yes`. A conformant repo's source-authority reference (§22.5) and the semantic-diff reference (`semantic-diff.md`) MUST state this twelve-category set and the single auto-approved class.

---

## 11. Lowering and decomposition

`LOWER` is the phase that turns a normalized, approved spec into machine-shaped work. Two passes occupy it: `lower` (SOL surface → IR obligation graph) and `decompose` (IR → task-sized work packets). They are separate passes because they have different inputs, different outputs, and different failure modes; conflating them would mix graph construction with work partitioning.

Throughout `LOWER`, the **distillation-loss discipline** (§24) is in force: lowering MUST preserve every obligation, every modality, actor, trigger, and response, every constraint and invariant, every verification binding, and the authority of each obligation (§22). Dropping any of these is a distillation error, not an optimization.

### 11.1 The `lower` pass

`lower` consumes an approved `spec.swarm.md` and produces `*.swarm.ir.json` (the IR envelope of §12). It is mostly deterministic. The pass MUST perform, in order:

1. **Assign IR node ids.** Each surface block (short per-type id, e.g. `AC-001`) becomes an IR node whose id MAY be namespaced as `REQ.<spec>.AC-001` (§4). Surface ids remain stable; the namespaced form is IR-only.
2. **Build typed edges.** Relationships are emitted as `edges[]` entries `{from, to, type, hard}` with `type ∈ {depends_on, blocks, conflicts_with, verified_by, affects, implements, preserves}`. Edges are the **single source of relationship truth** — a relationship MUST NOT be duplicated as a node scalar (§12). `DEPENDS ON` → `depends_on` edges; `AFFECTS <node-id>` → an `affects` edge to that node, while `AFFECTS <surface>` (a surface, not a node) stays in the node's `affects` scope set and contributes `conflicts_with` edges per §18 — never an `affects` edge (§12.5.1); `WRITES` overlap → `conflicts_with` edges; each `VERIFY BY` → a `verified_by` edge.
3. **Normalize `verify_by`.** Each surface `VERIFY BY <type>:<adapter>:<artifact>[#selector]` clause becomes a normalized IR record `{type, adapter, ref, selector, gate}` (§15). The `<adapter>` is recorded as written; it resolves through AGENTS.md > Commands at `verify` time (§15), not at lowering time.
4. **Emit the two derived graphs.** The pass MUST emit (a) a **dependency DAG** from the `depends_on` edges and (b) a **write-surface conflict graph** from `WRITES`/`SURFACE` declarations and the `READS`/`WRITES` conflict rule (§11.5). These two graphs are the substrate the safe-parallelism predicate runs on (§18); the `lower` pass produces them, `decompose` consumes them.

#### 11.1.1 AND THE chaining (G3)

A `REQ` MAY chain obligations with `[AND THE <actor> <MODAL> <response>]*` (§5, §6). The `lower` pass MUST split each chained clause into a **distinct IR obligation node**, one per `THE`/`AND THE` clause, each inheriting the parent's bindings unless overridden. **Sub-id production:** the *n*-th clause (counting the leading `THE` as 1 and each `AND THE` thereafter) lowers to IR node id `<surface-id>.<n>` — e.g. `AC-001.1`, `AC-001.2`. A surface `TRACE`/`VERDICT` that targets the parent id `AC-001` distributes over all of its split sub-obligations (each `AC-001.<n>` inherits the parent target's verdict); the merge gate (§14.4) requires every split sub-obligation to carry a `PASS`/`WAIVED` verdict, whether inherited from the parent target or recorded per sub-id.

> **R-CHAIN.** Chained obligations are lowered into multiple distinct IR obligations. When a single block chains **more than two** obligations (three or more `THE …`/`AND THE …` clauses), the `lower` pass MUST emit a `SOL-P004`-adjacent **warning** (bundled-obligation smell) suggesting `ATOMIZE` (§10). It MUST NOT be a hard error; chaining is permitted.

```sol
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
AND THE client MUST redirect to `/login`
VERIFY BY test:cmdTest:auth-refresh-expired-token
```
lowers to two IR obligations (`AC-001.1` "clear the local session", `AC-001.2` "redirect to /login"), both carrying the `verified_by` edge to the named test. Two chained clauses → no warning. A third `AND THE …` would trip the `SOL-P004`-adjacent warning.

#### 11.1.2 Blocking QUESTION reaching `lower`

> **R-BLOCKING-Q.** A `QUESTION` block tagged `[blocking]` (§6) that is still unresolved when it reaches the `lower` pass MUST halt lowering and emit a `SOL-O###` **orchestration error** (the orchestration layer owns "blocking QUESTION reaching lowering"). The spec MUST NOT be lowered until the blocking question is resolved (answered, or downgraded to `[non-blocking]` with rationale) — a blocking question prevents implementation lowering.

Rationale: a blocking question marks behavioral uncertainty that changes *what* gets built; lowering past it would commit a guess as an obligation.

### 11.2 The `decompose` pass

`decompose` consumes `*.swarm.ir.json` and produces `task.md` work packets (compiled work). It is the new machinery the legacy task-type model lacked. The pass MUST:

1. **Partition obligations into work packets**, each packet carrying its assigned obligations, the constraints/invariants in force, the interfaces it touches, its write surfaces, and its verification bindings (the `task.md` contract, §21).
2. **Project owned paths** for each packet as the file/glob projection of its assigned obligations' `WRITES` surfaces.
3. **Compute merge order** from the `depends_on` edges (the dependency DAG) as a partial order, and prove that the owned paths of any two packets scheduled in parallel are pairwise disjoint using the write-surface conflict graph (§18).

Each produced `task.md` is "the lowered work packet for one pass" — the unit a single `implement` run owns.

### 11.3 The owned-path containment rule (G7)

The execution tier (`task.md` / coordination artifact §19) declares **owned paths**. These MUST be derived from, and bounded by, the obligations' declared write surfaces.

> **R-OWNED-SUBSET.** An execution-tier owned path MUST be a subset of the union of its assigned obligations' `WRITES` surfaces. A violation — an owned path that touches a file outside any assigned obligation's declared write surface — is lint code **`SOL-O005`** ("owned path outside declared write surface"). See §18 and §19 for the coordination detail and the disjoint-scope invariant this rule protects.

```text
AC-001 WRITES src/auth/**
task-packet owns: src/auth/session.ts        -> OK (subset)
task-packet owns: src/billing/charge.ts      -> SOL-O005 (outside declared WRITES)
```

### 11.4 Lowering preserves obligations, bindings, and authority

The `lower` and `decompose` passes are subject to the distillation-loss rule (§24):

> If lowering drops an obligation id, modality, actor, trigger, response, constraint, invariant, or verification binding, that is a **distillation error** (not a lint warning to be triaged later — a hard failure of the pass).

Authority (§22) MUST be carried onto each lowered node so that, downstream, a conflict can still be resolved by the two-axis source-authority rule without re-reading the surface spec. Verification bindings MUST survive lowering intact so that the `verify` pass (§9, §15) has a `verified_by` edge for every required obligation — an obligation that reaches `decompose` with no `verify_by` is a `SOL-V001`-class defect that should have been answered by `BIND` (§10) during `improve`.

### 11.5 READS/WRITES conflict rule (referenced by §18)

The conflict graph that `lower` emits uses conflict-serializability semantics: a `READS`/`READS` pair on the same surface is parallel-safe (no edge); a `READS`/`WRITES` or `WRITES`/`WRITES` pair on the same surface is a conflict (`conflicts_with` edge). A `SURFACE` MAY carry an attribute (`append-only`, `integration`, `shared`) so that shared/global/append-only surfaces are not treated as ordinary write conflicts. The full predicate and `SURFACE` attribute mechanism are specified in §18; `lower` is responsible only for emitting the edges that predicate consumes.


### 11.6 The clarify gate and the coverage gate

`LOWER` is bracketed by two **pipeline gates**: a checkpoint that guards entry *into* `lower`, and a checkpoint that guards exit from `decompose` *into* `implement`. A gate is not a transformation — it transforms nothing and writes no artifact. It is a precondition predicate over already-emitted state: the pipeline MUST NOT advance the affected obligation past the gate while the predicate is unsatisfied. Mature spec-driven-development tools make these checkpoints explicit rather than implicit: GitHub Spec Kit runs `/clarify` (interactive disambiguation) and `/analyze` (cross-artifact consistency) as standard quality gates positioned around planning, before `implement` [SPECKIT]; AWS Kiro gates the requirements → design → tasks progression so a later artifact is not produced from an unsettled earlier one [KIRO]. Swarm names these two checkpoints normatively here.

Both gates are **contracts checkable today by review** and **enforced by a future tool** — there is no runtime that runs them (Invariant 1, §2). Today a human or a `lint`/`decompose` carrier verifies the predicate by hand against the IR; a future compiler computes it from `nodes[]`, `edges[]`, and the plan `packets[]`.

> **Gate vs improve-op (reconciliation, normative).** The CLARIFY *gate* (this section) and the `CLARIFY` *improve operation* (§10.2, op 7) are distinct and MUST NOT be conflated. The `CLARIFY` op is a **local edit** in the `NORMALIZE` phase: it lifts one buried prose ambiguity (`SOL-P008`) into an explicit interpretation or a `QUESTION` block. The CLARIFY gate is a **pipeline checkpoint** at the `NORMALIZE`→`LOWER` boundary: it refuses to advance the spec while any such question is still open and blocking. The op *creates* the QUESTION; the gate *waits on* it. One is the repair; the other is the precondition that the repair has been discharged.

#### 11.6.1 The CLARIFY gate (pre-`lower`)

> **R-CLARIFY-GATE.** The `lower` pass MUST NOT proceed for any obligation while, for that obligation, any of the following holds:
> - an unresolved `[blocking]` `QUESTION` (§6.5) `AFFECTS` it — answered, or downgraded to `[non-blocking]` with rationale, clears it;
> - a blocking `SOL-M002` (contradiction) names it (§8.3, §10.2 `DECONFLICT`);
> - an unresolved `SOL-P008` (uncaptured behavioral ambiguity) attaches to it (§8.3, §10.2 `CLARIFY`).
>
> A spec carrying any of these for an in-scope obligation is **not lowerable**; lowering past it would commit a guess as an obligation.

This is the **named generalization** of the existing halt-on-blocking-`QUESTION` rule (R-BLOCKING-Q, §11.1.2): R-BLOCKING-Q says a `[blocking]` `QUESTION` reaching `lower` is the orchestration error `SOL-O003`; R-CLARIFY-GATE lifts that single rule into a three-condition pre-lowering checkpoint that also catches unresolved contradiction (`SOL-M002`) and uncaptured ambiguity (`SOL-P008`). The codes are unchanged — a tripped CLARIFY gate surfaces as the *existing* code for the condition that tripped it (`SOL-O003` for the blocking question, `SOL-M002` for the contradiction, `SOL-P008` for the buried ambiguity); the gate is the checkpoint that aggregates them, not a new diagnostic.

Rationale (cite): the planner→coder handoff is the dominant failure surface in multi-agent code generation — the planner-coder gap "accounts for 75.3% of failures," driven by underspecified plans and coder misinterpretation [PLANCODER]; and agents do not reliably ask: with messy/ambiguous specs the best model solves only ~24% of tasks even when handed a tool to ask for help [HILBENCH]. A clarification checkpoint *before* the spec is lowered into task packets is therefore a precondition for safe handoff, not a nicety — it forces selective escalation at the boundary where ambiguity is cheapest to resolve. The cost is measured: ambiguous descriptions drop Pass@1 by 25–30% and contradictory ones by up to 40% (GPT-4 HumanEval 73.8%→6.7%) [AMBIGCODE], with >30% degradation on frontier models across a 1,304-task benchmark [ORCHID]; conversely a clarify-then-generate loop raises GPT-4 Pass@1 from 70.96% to 80.80% [CLARIFYGPT], and a lightweight finetuned detector flags these defects more reliably than frontier LLMs do [SPECVALIDATOR].

#### 11.6.2 The COVERAGE gate (pre-`implement`)

After `decompose` emits work packets (§11.2) and before any `implement` pass runs, a **coverage check** MUST hold over the lowered IR and the plan:

> **R-COVERAGE-GATE.** For the lowered spec, the following MUST hold before `implement`:
> 1. **Total coverage.** Every lowered obligation node (every `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`, including each `AND THE`-split sub-obligation, §11.1.1) is assigned to **exactly one `implement` packet** (`packets[].inputs`, §13.5) — no obligation is unassigned (uncovered) and none is assigned to two `implement` packets (double-owned). (An obligation legitimately appears in its `implement`, `verify`, and `review` packets across passes; the coverage count is per `implement` packet.)
> 2. **No orphan targets.** Every `verified_by` edge and every TRACE `implements`/`preserves` edge (§12.5) resolves to a real obligation node id present in `nodes[]`. A TRACE or VERDICT whose target id does not resolve is an orphan and MUST NOT be admitted.

An obligation that satisfies neither (1) — i.e. an obligation no packet covers — is lint code **`SOL-O007`** ("uncovered obligation: a lowered obligation assigned to no task packet") in the orchestration layer (the O-block previously ran `SOL-O001`–`SOL-O006`; this reconciliation adds `SOL-O007` and `SOL-O008`, §8.3, Appendix B.6). `SOL-O007` is **BLOCKING** and resolves by `SCOPE` (assign the obligation to a packet, or record it as an explicit non-goal). A double-owned obligation (assigned to two `implement` packets) is `SOL-O008` (double-owned-obligation, Appendix B.6); an orphan TRACE/VERDICT target is the unbound-reference surface owned by the M layer (`SOL-M003`, unbound-cross-reference, surfaced at `review`, §9.3). The COVERAGE gate aggregates these into one pre-`implement` checkpoint.

```text
COVERAGE gate (manual today, tool-enforced later):
  for each node N in IR.nodes where N.kind ∈ {REQ, CONSTRAINT, INVARIANT, INTERFACE} (incl. AND THE-split sub-obligations):
      count = | { p in plan.packets : p.pass == "implement" ∧ N.id in p.inputs } |
      count == 0  -> SOL-O007  (uncovered obligation)        [BLOCKING]
      count > 1   -> SOL-O008  (double-owned obligation)     [BLOCKING]
  for each verified_by / implements / preserves edge E:
      E.to NOT in IR.nodes  -> orphan target (SOL-M003 unbound-cross-reference, at review)
```

This gate is the structural complement of the distillation-loss discipline (§11.4, §24): distillation-loss forbids *dropping* an obligation, modality, binding, or authority during lowering; the COVERAGE gate forbids *stranding* one afterward — an obligation that survived lowering intact but that no packet picks up, or a trace/verdict that claims an obligation that does not exist. Together they make the lowered work a bijection over obligations: nothing lost in lowering (§11.4), nothing left uncovered or pointed at a phantom (§11.6.2).

#### 11.6.3 Gate placement in the pipeline

| Gate | Sits at boundary | Predicate (MUST hold to advance) | Surfaced as | Carrier (manual today) |
| --- | --- | --- | --- | --- |
| CLARIFY gate | `NORMALIZE` → `LOWER` (before `lower`) | No open `[blocking]` `QUESTION`, no blocking `SOL-M002`, no unresolved `SOL-P008` on an in-scope obligation | `SOL-O003` / `SOL-M002` / `SOL-P008` (existing codes) | `lint` (Skeptic, §9.4) |
| COVERAGE gate | `LOWER` → `EXECUTE` (after `decompose`, before `implement`) | Every obligation covered by exactly one packet; every TRACE/verdict target resolves | `SOL-O007` (uncovered), `SOL-O008` (double-owned), `SOL-M003` (orphan target) | `decompose` (Lead Engineer, §9.4) |

Neither gate is a new pass; both reuse the existing pass surface (`lint` decides the CLARIFY predicate, `decompose` decides the COVERAGE predicate) and the existing `SOL-<LAYER><NNN>` namespace, adding two new orchestration codes `SOL-O007` and `SOL-O008`. A future tool MUST compute both predicates mechanically from the IR and plan; until one ships, a conformant repository MUST state both gates as review-checkable contracts and MUST NOT claim either is enforced by shipped tooling (Principle 1, §2; §12.1, §13.1).

## 12. The intermediate representation (IR)

### 12.1 Purpose and status

The **intermediate representation** (IR) is the typed, machine-checkable form of a SOL specification: a single JSON document that re-expresses every obligation, relationship, diagnostic, and provenance fact carried by one `*.swarm.md` source. The IR is the substrate every downstream analysis reads — topological sort over dependencies, cycle detection, write-surface conflict detection, traceability join, merge-gate evaluation, drift recomputation (see §16). The surface (`.swarm.md`) is what a human authors; the IR is what a tool would reason over (§3 establishes the surface-vs-IR layering as the master distinction of the architecture). A structured intermediate measurably outperforms free-form prose for downstream code work: structured chain-of-thought (a sequence/branch/loop intermediate) beats free-form chain-of-thought by up to 13.79% Pass@1 [SCOT] — empirical support for binding analysis to a typed IR rather than to prose.

The IR file is named with the compiler-visible `.swarm.` infix: a source `auth-refresh.swarm.md` lowers to `auth-refresh.swarm.ir.json` (see §20 for the artifact-name rules). The `.json` form signals that the IR is *emitted*, not human-authored; the only legal producer of an `.ir.json` file is a future compiler — this repository ships none (Invariant 1).

> **Contract, not executor (normative).** This document specifies the IR as a **versioned data contract**: the shape an IR document MUST have so that any future tool can produce or consume it interoperably. This repository ships **no emitter, no parser, and no validator** for the IR. The formal JSON Schema (Appendix C) is documentation and a conformance fixture, not running code. A conformant Swarm repository MUST include the documented IR Schema; it MUST NOT claim that any `.swarm.ir.json` file is produced by a shipped tool. *Rationale: Principle 1 — no runtime; everything that "runs" is a contract a future tool builds against (§2, §17).*

### 12.2 Top-level envelope

A SOL IR document MUST be a single JSON object with exactly these five top-level keys, in this order:

```json
{
  "meta":        { },
  "nodes":       [ ],
  "edges":       [ ],
  "diagnostics": [ ],
  "provenance":  { }
}
```

| Key | JSON type | Cardinality | Purpose |
|---|---|---|---|
| `meta` | object | exactly 1 | Spec-level identity, language discriminator, version, status, ownership, imports. |
| `nodes` | array of node objects | 0..n | The merged obligation records — one per surface block. |
| `edges` | array of edge objects | 0..n | The typed relationships between nodes — the single source of relationship truth (§12.5). |
| `diagnostics` | array of diagnostic objects | 0..n | SARIF-shaped lint/compile findings keyed to the unified `SOL-<LAYER>NNN` taxonomy (§8). |
| `provenance` | object | exactly 1 | Emission facts: source hash, compiler version, compile timestamp. |

A conformant IR document MUST contain all five keys. An empty spec (no blocks) still emits `nodes: []`, `edges: []`, `diagnostics: []` and fully-populated `meta` and `provenance`. No additional top-level keys are permitted in SOL/0.1; unknown top-level keys MUST be rejected by a validating consumer.

The IR layer is snake_case throughout. Every surface keyword that is English-shaped UPPERCASE space-separated (`VERIFY BY`, `DEPENDS ON`, `OWNED BY`, `WRITES`, `READS`, `AFFECTS`) maps to a snake_case IR field (`verify_by`, `depends_on`, `owner`, `writes`, `reads`, `affects`). This casing split is normative and is never mixed (§4).

### 12.3 `meta`

`meta` carries spec-level identity and the three version fields (§12.7).

```json
{
  "id": "auth-refresh",
  "title": "Access-token refresh",
  "language": "SOL/0.1",
  "version": "0.1.0",
  "status": "draft",
  "owners": ["@auth-platform"],
  "imports": ["shared/security.swarm.md"]
}
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `id` | string | MUST | Stable spec identifier; matches the surface frontmatter `id` (§5.8). |
| `title` | string | SHOULD | Human-readable spec title. |
| `language` | string | MUST | The SOL language discriminator, exactly `SOL/0.1` for this version (§12.7, §25). Answers "which grammar/blocks/modals/lint codes." |
| `version` | string | MUST | The **spec content** version (semver-shaped, e.g. `0.1.0`). Distinct from `language`. |
| `status` | string | MUST | Spec lifecycle state; one of `draft`, `review`, `approved`, `superseded` (the same enum as §5.8 / Appendix C — `source-authority` keys on `approved`, §22). |
| `owners` | array of string | SHOULD | Accountable maintainers (handles). MAY be empty. |
| `imports` | array of string | SHOULD (MAY be empty) | Relative paths to imported `*.swarm.md` specs whose nodes are in scope for cross-spec reference resolution. |

### 12.4 `nodes[]` — the merged obligation record

Each element of `nodes[]` is one **merged obligation record**: the fully normalized form of a single surface block (REQ, CONSTRAINT, INVARIANT, INTERFACE, QUESTION, TRACE, or VERDICT — the seven block types of §6). "Merged" means every clause, modal, scope set, proof binding, status, and source span for that block is collected into one record; nothing about a block is scattered across other structures except its *relationships*, which live in `edges[]` (§12.5).

```json
{
  "id": "REQ.auth-refresh.AC-001",
  "kind": "REQ",
  "authority": "product",
  "modality": "MUST",
  "clauses": {
    "where":     null,
    "while":     null,
    "trigger":   { "kw": "WHEN", "expr": "response.status == 401 AND refresh_token.present" },
    "subject":   "the web-client",
    "modal":     "MUST",
    "predicate": "retry the original request exactly once",
    "timing":    null
  },
  "owner": "@web-platform",
  "risk": "medium",
  "reads":   ["api.auth.session-store"],
  "writes":  ["web.http.client"],
  "affects": ["web.http.retry-policy"],
  "verify_by": [
    {
      "type": "test",
      "adapter": "cmdTest",
      "ref": "web/tests/auth-refresh-401.spec.ts",
      "selector": "retries once after refresh",
      "gate": "required"
    }
  ],
  "status": "UNVERIFIED",
  "source": {
    "file": "auth-refresh.swarm.md",
    "line_start": 18,
    "line_end": 27,
    "content_hash": "sha256:9f2c…"
  },
  "provenance": []
}
```

#### 12.4.1 Node field reference

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `id` | string | MUST | IR node id. MAY be namespaced as `<KIND>.<spec>.<surface-id>` (e.g. `REQ.auth-refresh.AC-001`); the surface id (`AC-001`) MUST be recoverable from it. Surface ids are short per-type; IR ids MAY be dotted (§4). |
| `kind` | string | MUST | One of `REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`, `TRACE`, `VERDICT`. |
| `authority` | string | MUST for obligation kinds | The resolved domain-authority rank governing this node (e.g. `security`, `architecture`, `product`), lowered from the obligation's `DOMAIN` clause or the spec `domain:` frontmatter (§22.1.2). MAY be `null` for QUESTION/TRACE. |
| `modality` | string\|null | MUST for REQ/CONSTRAINT/INVARIANT | The binding modal: one of `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY`. `null` for kinds that carry no modal (INTERFACE, QUESTION, TRACE, VERDICT). Mirrors `clauses.modal`. |
| `clauses` | object | MUST | The structured decomposition of the control sentence (§12.4.2). |
| `owner` | string\|null | SHOULD | The accountable owner (surface `OWNED BY`). |
| `risk` | string\|null | MAY | One of `low`, `medium`, `high`, `critical` (surface `RISK`). |
| `reads` | array of string | MUST (MAY be empty) | The **read scope set** (§12.6). Surface `READS`. |
| `writes` | array of string | MUST (MAY be empty) | The **write scope set** (§12.6). Surface `WRITES`; surface names are SURFACE ids, never `locks`. |
| `touches` | array of string | MUST (MAY be empty) | The **incidental scope set** (§12.6): surfaces this obligation incidentally touches but does not own or write — advisory documentation only, weaker than `writes`. **Not consumed by the safe-parallelism predicate** (§18) and never a conflict or staleness signal. Surface `TOUCHES` (§6.8). (`AFFECTS` is **not** a node field — it lowers to `affects` edges, §12.5.) |
| `verify_by` | array of object | MUST (MAY be empty) | Normalized proof bindings (§12.4.3). Surface `VERIFY BY`. |
| `status` | string | MUST | The node's **core** verdict: one of `PASS`, `FAIL`, `BLOCKED`, `UNVERIFIED` (§12.4.4). Closed over the four core values only. |
| `lifecycle` | array of string | MUST (MAY be empty) | Lifecycle decorators in effect on the core verdict — a subset of `{WAIVED, STALE, CONTRADICTED}` (§12.4.4, §14). Empty for a plain core verdict. |
| `source` | object | MUST | Origin span and content hash (§12.4.5). |
| `provenance` | array of object | MUST (MAY be empty) | Per-node provenance trail: prior verdicts, lowering ancestry, promotion lineage. Free-form objects whose minimal pinned shape is the trace-provenance schema of §16; not re-specified here. |

*On the Required column.* "MUST" marks a field's **intent** (it carries a value); "MUST for `<kind>`" is conditional on node kind; "MUST (MAY be empty)" means the field **defaults** (to `[]`, or `UNVERIFIED` for `status`) when absent. The validatable JSON shape is Appendix C, which marks only `id`/`kind`/`source` as `required` and encodes the rest as optional-with-`default`. Per §12.10, Appendix C governs the shape and this table governs intent.

#### 12.4.2 `clauses{}`

`clauses` is the structured form of the surface control sentence (the REQ clause order of §5/§6). Every key is present; an absent surface clause is `null`. This sub-object is identical in shape across kinds; kinds that do not use a given clause leave it `null`.

| Clause key | Source surface clause | JSON type | Notes |
|---|---|---|---|
| `where` | `WHERE <expr>` | string\|null | Precondition / state qualifier; opaque text in v0.1. |
| `while` | `WHILE <expr>` | string\|null | Sustained-state qualifier; opaque text. |
| `trigger` | `WHEN`/`IF [THEN] <expr>` | object\|null | `{ "kw": "WHEN"\|"IF", "expr": <string> }`. `THEN` is sugar after `IF` only and is not represented as data. |
| `subject` | `THE <actor>` | string\|null | The bound actor. |
| `modal` | `<MODAL>` | string\|null | The binding modal (mirrors top-level `modality`). |
| `predicate` | `<response>` | string\|null | The required behaviour, opaque text. |
| `timing` | (deferred) | null | RESERVED. Timing keywords (`WITHIN`/`BEFORE`/`UNTIL`/`IMMEDIATELY`/`EVENTUALLY`) are **deferred to v0.2**; in SOL/0.1 this MUST be `null` (§4, §35). |

For a chained obligation (`THE … MUST … AND THE … MUST …`), the lowering pass MUST split it into multiple nodes, one per `THE <actor> <MODAL> <response>` clause (G3); each resulting node has a single-obligation `clauses` object. An INVARIANT lowers `<property> MUST|MUST NOT <hold>` into `subject` = the property and `predicate` = the held condition. An INTERFACE has no `subject`/`modal`/`predicate`; its `RETURNS`/`ACCEPTS`/`ERRORS` lower into the pinned `clauses` slots `signature`/`returns`/`accepts`/`errors` (Appendix C.1), `OWNED BY` into the node `owner`, and the `contract` proof binding of §15 is MUST-present in `verify_by`.

#### 12.4.3 `verify_by[]` — normalized proof bindings

Each surface `VERIFY BY <type>:<adapter>:<artifact>[#selector]` clause (§15) normalizes to one object:

```json
{ "type": "test", "adapter": "cmdTest", "ref": "web/tests/auth.spec.ts", "selector": "retries once", "gate": "required" }
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `type` | string | MUST | One of the 9 closed proof types: `static`, `test`, `contract`, `property`, `model`, `perf`, `security`, `manual`, `monitor` (§15). Test scope qualifiers (`test:unit`, `test:integration`, `test:e2e`) are carried verbatim in `type`. |
| `adapter` | string | MUST | The AGENTS.md > Commands slot the type resolves through (a `cmd*` placeholder, e.g. `cmdTest`, `cmdLint`); §15, §31. |
| `ref` | string | MUST | The project artifact (test file, contract file, model, checklist id). |
| `selector` | string\|null | MAY | The `#selector` fragment (a specific case/property within `ref`). |
| `gate` | string | MUST | `required` or `advisory`; `required` bindings participate in the merge gate (§14). |

#### 12.4.4 `status` — the 7-value verdict model

In the IR the verdict model is carried as **two orthogonal fields, never fused**: `status` is the **core** verdict (one of the four mutually-exclusive values) and `lifecycle[]` is the set of decorators in effect (a subset of `{WAIVED, STALE, CONTRADICTED}`). This separation keeps the merge gate and verdict lint closed over the four core values while lifecycle state evolves independently; the authoritative machine form of both is the node's latest VERDICT node/edge (§12.5). The values:

| `status` value | Class | Meaning |
|---|---|---|
| `PASS` | core | A bound required proof ran and succeeded. |
| `FAIL` | core | A bound proof ran and failed. |
| `BLOCKED` | core | A bound proof could not run (missing prereq/tool/env). |
| `UNVERIFIED` | core | No acceptable proof bound, or none executed. |
| `WAIVED` | lifecycle | A FAIL/UNVERIFIED accepted with authority + reason + expiry (§14). |
| `STALE` | lifecycle | A prior PASS whose evidence no longer matches the current source/surface hashes (§16). |
| `CONTRADICTED` | lifecycle | Two proofs disagree, or trace/code disagrees with the obligation (§14, §16). |

A node MAY carry both a core value and a lifecycle decorator; the canonical machine form is the VERDICT node it is `verified_by` (see §12.5). For a freshly-lowered, never-executed obligation, `status` is `UNVERIFIED`. A QUESTION node's `status` reflects resolution state and MAY be `UNVERIFIED` (open) — the merge-gate treatment of blocking QUESTIONs is an orchestration concern (§8, §18).

#### 12.4.5 `source{}`

```json
{ "file": "auth-refresh.swarm.md", "line_start": 18, "line_end": 27, "content_hash": "sha256:9f2c…" }
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `file` | string | MUST | Relative path to the originating `*.swarm.md`. |
| `line_start` | integer | MUST | First line of the block (1-based). |
| `line_end` | integer | MUST | Last line of the block. |
| `content_hash` | string | MUST | Content hash of the block's source text (e.g. `sha256:…`). This is the obligation-source hash the drift model joins against (§16). |

### 12.5 `edges[]` — the single source of relationship truth

Every relationship between two nodes is an edge. An edge is a typed directed link.

```json
{ "from": "REQ.auth-refresh.AC-001", "to": "INTERFACE.auth-refresh.IF-001", "type": "depends_on", "hard": true }
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `from` | string | MUST | Source node id. |
| `to` | string | MUST | Target node id. |
| `type` | string | MUST | One of the 7 closed edge types below. |
| `hard` | boolean | MUST | `true` = a hard relationship (mandatory ordering, hard conflict, required proof); `false` = soft/advisory. |

The closed edge-type set:

| `type` | Derived from | Direction semantics | Used by |
|---|---|---|---|
| `depends_on` | surface `DEPENDS ON` | `from` requires `to` first | dependency DAG; merge ordering (§18). |
| `blocks` | inverse / explicit | `from` blocks `to` | scheduling; blocking-QUESTION gating (§18). |
| `conflicts_with` | write-surface overlap, `AFFECTS`, read/write overlap (§18, G7) | symmetric conflict | write-conflict graph; safe-parallelism predicate (§18). |
| `verified_by` | `VERIFY BY` / VERDICT | obligation `from` is verified by proof/verdict `to` | verification model (§14, §15). |
| `affects` | surface `AFFECTS` | `from` impacts `to` | impact analysis; conflict derivation. |
| `implements` | TRACE `IMPLEMENTS` | trace `from` claims to implement obligation `to` | traceability (§11). |
| `preserves` | TRACE `PRESERVES` | trace `from` claims to preserve invariant `to` | traceability (§11). |

#### 12.5.1 Relationship truth vs scope sets (normative)

> **Edges are the single source of relationship truth.** A relationship between two nodes MUST be represented exactly once, as an edge. A relationship MUST NOT also be duplicated as a node scalar. There is no `depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, or `preserves` field on a node. A consumer computing dependency order, conflict, or traceability MUST read `edges[]` and MUST NOT reconstruct relationships from node fields. *Rationale: a relationship stored twice can disagree; one representation cannot.*

This is distinct from the three **scope sets** on a node — `reads`, `writes`, `touches`:

- A **scope set** answers "what region of the world does this single obligation touch?" It is a property *of one node*, an unordered set of opaque SURFACE identifiers. It is intrinsic node data and correctly lives on the node.
- A **relationship edge** answers "how do two nodes relate?" It connects *two* node ids and correctly lives in `edges[]`.

The two are connected but not redundant. The lowering pass *derives* `conflicts_with` and `affects` edges *from* the scope sets and the `AFFECTS` clause — e.g. if node A and node B both list write surface `web.http.client`, the lowering pass MUST emit a `conflicts_with` edge between them; if node A's `AFFECTS` clause names a surface that B `writes`, an `affects` edge (and, per §18 G7, a `conflicts_with` edge) MAY be derived. The declaration is the raw input; the edge is the computed relationship. Keeping the raw declaration and the computed relationship apart means the derivation is auditable and re-runnable, and the two never silently disagree. Note: `affects` is **purely an edge type** — the `AFFECTS` surface clause lowers directly to `affects` edges (a concrete node→node impact link), *not* to a node field; it is never also a node scope set. (The node's third scope set is `touches`, the advisory incidental-surface set of §12.6, which the safe-parallelism predicate ignores.)

### 12.6 Scope sets in detail

The three scope sets carry the coordination contract that §18 lowers into the dependency DAG and write-conflict graph:

| Scope set | Surface clause | Semantics |
|---|---|---|
| `reads` | `READS` | Surfaces this obligation reads but does not modify. read/read is always parallel-safe; read/write on the same surface is a conflict (§18, G7). |
| `writes` | `WRITES` | Surfaces this obligation modifies. Shared write surface ⇒ `conflicts_with` ⇒ not parallel-safe (§18). Surface names are SURFACE ids (`SURFACE <name> = …`); there is no `locks` field (§4, §18). |
| `touches` | `TOUCHES` | Surfaces incidentally affected, weaker than `WRITES`. Advisory/documentation only: **not** consumed by the safe-parallelism predicate (§18) and never a conflict or staleness signal. |

The `AFFECTS` clause is **not** a node scope set: it lowers to `affects` edges (the impact relationship of §12.5), which contribute conflict edges but do not by themselves imply a write.

Surface identifiers in scope sets are the SURFACE names declared in the spec (a lock group is a named coarse write surface, never a `locks` primitive). They are opaque strings to the IR; their resolution to files/globs is an orchestration concern (§18).

### 12.7 The three version fields (never merged)

The IR echoes **three distinct version axes** (§25). They occupy three distinct fields and a consumer MUST NOT collapse, merge, or infer one from another:

| Field | Axis | Answers | Example |
|---|---|---|---|
| `meta.language` | LANGUAGE version | Which SOL+APS grammar / block set / modal set / lint codes apply | `SOL/0.1` |
| `meta.version` | SPEC CONTENT version | Which revision of this spec's obligations | `0.1.0` |
| `provenance.compiler_version` | TOOL version | Which emitter produced this IR (when one exists) | `null` in this repo (no shipped tool) |

A language change forces at least a framework MINOR release, but the framework MAY release many versions without changing `meta.language` (the one-way trigger, §25). These three values therefore drift independently and MUST remain three fields.

### 12.8 `diagnostics[]`

Each diagnostic is a SARIF-shaped finding (§8 owns the taxonomy; §12 owns its IR shape):

```json
{
  "code": "SOL-V001",
  "level": "error",
  "node": "REQ.auth-refresh.AC-002",
  "source": { "file": "auth-refresh.swarm.md", "line_start": 31, "line_end": 33 },
  "message": "Obligation has no VERIFY BY binding; no verification path."
}
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `code` | string | MUST | A unified lint code `SOL-<LAYER>NNN` where `<LAYER>` ∈ {`S`,`P`,`M`,`V`,`O`} (§8). |
| `level` | string | MUST | SARIF level: `error`, `warning`, or `note`. Maps to the §8 BLOCKING/ADVISORY split (BLOCKING ⇒ `error`; ADVISORY ⇒ `warning`); `note` has no surface producer in v0.1 — it is reserved for informational annotations a future emitter MAY attach and MUST NOT be produced by a conformant v0.1 checker (§8.2). `off` is **not** a level: a waiver that demotes a code to `off` (§8.6) suppresses the diagnostic — it is omitted from `diagnostics[]` entirely, not emitted with an `off` level or downgraded into a `note`. |
| `node` | string\|null | one of `node`/`source` MUST be present | The node id the finding attaches to, if node-scoped. |
| `source` | object\|null | one of `node`/`source` MUST be present | A source span (same shape as §12.4.5 minus `content_hash`), for findings with no resolved node (e.g. a parse error). |
| `message` | string | MUST | Human-readable finding text. The §8 `suggest` field MAY also appear. |

Diagnostics live only in `diagnostics[]`; they are never folded into node `status` (a node's `status` is its verdict, not its lint state).

### 12.9 `provenance`

```json
{ "hash": "sha256:source-file-digest…", "compiler_version": null, "compiled_at": "2026-05-31T12:00:00Z" }
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `hash` | string | MUST | Content hash of the whole source `*.swarm.md` at emission. |
| `compiler_version` | string\|null | MUST (MAY be `null`) | The emitting tool's version. `null` in this repo because no emitter ships (§12.1). The third version axis (§12.7). |
| `compiled_at` | string\|null | MUST (MAY be `null` until a tool emits) | ISO-8601 timestamp of emission; `null` in this repo (no emitter, §12.1). |

### 12.10 Conformance and the formal schema

A document is a conformant SOL/0.1 IR iff it: (1) has exactly the five top-level keys of §12.2; (2) populates every field Appendix C marks `required`, and supplies the documented `default` for any optional field it omits (§12.4.1 note); (3) uses only the closed enumerations (7 kinds, 5 modals, 9 proof types, 7 edge types, 7 verdict values, the `SOL-<LAYER>NNN` code space); (4) represents every relationship once, as an edge (§12.5.1); (5) keeps the three version fields distinct (§12.7). The normative machine-readable form is the JSON Schema in **Appendix C**; where this prose and Appendix C disagree, Appendix C governs the shape and this section governs the intent.

## 13. The plan

### 13.1 Purpose and status

The **plan** is the schedulable projection of the IR: it takes the obligation graph (nodes + edges) and groups the work needed to discharge those obligations into **work packets** — units a launcher could hand to one agent in one lane. Where the IR answers "what must hold and how do the obligations relate," the plan answers "what units of work exist, in what order, on which surfaces, and which of them are safe to run at the same time." The plan is the kernel's static coordination contract (§18); it is *not* a running scheduler.

The plan file uses the compiler-visible infix: `auth-refresh.swarm.ir.json` plans to `auth-refresh.swarm.plan.json` (§20).

> **Contract, not executor (normative).** The plan schema is **documented, versioned data** — the shape a launcher/harness would consume. **Plan derivation is the `decompose` kernel pass** (§9.3, §11): the plan is the kernel's static coordination contract, derived from the IR by the same pass that emits the work packets — there is no separate "planner" step. What is **out of the kernel** is the **scheduler/harness** that would execute the plan's work packets live across agents (a launcher concern, §18.8). As with every pass, this repository ships **no running emitter and no scheduler** (Principle 1 — no runtime): a conformant repository MUST include the documented plan schema and MUST frame any `.swarm.plan.json` as "the contract a future tool emits and a future launcher consumes," never as the output of a shipped tool. *Rationale: Principle 1; the kernel owns the static coordination contract (including plan derivation), never the live scheduler.*

### 13.2 Resolution method (G8)

The two source files disagreed on the plan shape: one offered a flat `{ plan_id, max_parallel, tasks[] }` with per-task `lane/writes/locks/depends/merge_safe`; the other offered a `task` record with `pass/profile/inputs/outputs/batch`. G8 resolves this with the **same method used for the IR**: a graph envelope plus a rich per-unit payload, snake_case throughout, with two normative subtractions:

- **Drop `locks` entirely.** A lock group is a named coarse write `SURFACE`; lock-set analysis *is* write-set analysis at surface granularity (§18). The plan carries `writes[]` (write surfaces), never a `locks` field.
- **Reconcile the two payloads** into one work-packet record that carries both the *pass/profile* dimension (which transformation, under which heuristic profile) and the *scope/dependency* dimension (`writes`/`reads`/`depends_on`/`merge_safe`).

### 13.3 Top-level envelope

A SOL plan document MUST be a single JSON object with exactly these keys:

```json
{
  "meta":      { },
  "packets":   [ ],
  "edges":     [ ],
  "provenance":{ }
}
```

| Key | JSON type | Cardinality | Purpose |
|---|---|---|---|
| `meta` | object | exactly 1 | Plan-level identity, the spec/IR it derives from, the three version fields. |
| `packets` | array of work-packet objects | 0..n | The schedulable work units (§13.5). |
| `edges` | array of edge objects | 0..n | Inter-packet relationships — the same single-source-of-relationship-truth rule as the IR (§12.5.1). |
| `provenance` | object | exactly 1 | Emission facts; same shape as §12.9. |

The plan reuses the IR's structural discipline: relationships between packets live only in `edges[]` (never duplicated as packet scalars), and the three version fields stay distinct (§12.7). The `depends_on[]` array on a packet (§13.5) is the surface declaration of ordering; the `decompose` pass MUST also emit a `depends_on`-type edge for each, so that ordering is computable from the graph (the same scope-set-vs-edge relationship as §12.5.1).

### 13.4 `meta`

```json
{
  "id": "auth-refresh",
  "derived_from": "auth-refresh.swarm.ir.json",
  "language": "SOL/0.1",
  "version": "0.1.0",
  "max_parallel": null
}
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `id` | string | MUST | Spec/plan identifier; matches `meta.id` of the source IR. |
| `derived_from` | string | MUST | Path to the `*.swarm.ir.json` this plan was lowered from. |
| `language` | string | MUST | The SOL discriminator (`SOL/0.1`); same axis as `meta.language` of the IR (§12.7). |
| `version` | string | MUST | The spec content version this plan reflects. |
| `max_parallel` | integer\|null | MAY | An advisory parallelism hint for a launcher; `null` = unspecified. The kernel computes *safety* (§13.6); concurrency *limits* are a launcher policy. |

### 13.5 `packets[]` — work packets

A **work packet** is one schedulable unit: a single pass applied (under an optional profile) to a selected set of obligations, with declared scope, ordering, and a merge-safety verdict.

```json
{
  "id": "WP-002",
  "pass": "implement",
  "profile": "default",
  "inputs":  ["REQ.auth-refresh.AC-001"],
  "outputs": ["web/src/http/client.ts", "auth-refresh.swarm.trace.md"],
  "writes":  ["web.http.client"],
  "reads":   ["api.auth.session-store"],
  "depends_on": ["WP-001"],
  "lane": "agent-a",
  "batch": 1,
  "merge_safe": true
}
```

| Field | JSON type | Required | Meaning |
|---|---|---|---|
| `id` | string | MUST | Packet identifier, unique within the plan. |
| `pass` | string | MUST | The pass this packet runs: one of the 9 passes `author`, `lint`, `improve`, `lower`, `decompose`, `implement`, `verify`, `review`, `promote` (§9). |
| `profile` | string\|null | MAY | The heuristic profile parameterizing the pass (e.g. `skeptic` on `review`, `lead-engineer` on `decompose`); §27. `null` = the pass's default profile. |
| `inputs` | array of string | MUST | The node ids (obligations/questions/traces) this packet consumes. |
| `outputs` | array of string | MUST | The artifacts this packet is expected to produce (code paths, `*.swarm.trace.md`, `review.md`, `finding.md`, …). |
| `writes` | array of string | MUST (MAY be empty) | The **write surfaces** this packet modifies — SURFACE ids, derived from the `writes` scope sets of its `inputs`. The lowering rule requires every write surface here to be a subset of its obligations' declared `WRITES` (§18, lint `SOL-O005`). No `locks` field (§13.2). |
| `reads` | array of string | MUST (MAY be empty) | The read surfaces this packet touches. |
| `depends_on` | array of string | MUST (MAY be empty) | Packet ids that MUST complete before this packet; the merge-order partial order (§18). Each entry MUST also appear as a `depends_on` edge (§13.3). |
| `lane` | string\|null | MAY | A suggested execution lane/worker label. Purely a launcher hint; absence does not affect safety. |
| `batch` | integer\|null | MAY | A suggested wave/round index for staged fan-out. Launcher hint only. |
| `merge_safe` | boolean | MUST | The kernel's verdict on whether this packet may run concurrently with its batch-mates: `true` iff it is dependency-independent of and write-disjoint from every other packet it would run alongside (§13.6). |

#### 13.5.1 Packet edges

Inter-packet relationships use the same edge object as the IR (§12.5): `{ from, to, type, hard }`. The relevant types for a plan are `depends_on` (ordering, from a packet's `depends_on[]` and from lowered obligation `DEPENDS ON`) and `conflicts_with` (a shared write surface, or a read/write conflict on one surface — §18, G7). `conflicts_with` edges are what make a packet `merge_safe: false` against its conflict-mates. As in the IR, these relationships MUST live only in `edges[]`; the per-packet `depends_on[]` array is the declaration, the edge is the computed graph relationship (§12.5.1).

### 13.6 The safe-parallelism predicate

The plan's `merge_safe` flag is the surface of the kernel's single canonical safe-parallelism predicate, defined normatively in §18 and restated here for the plan's purposes:

> Two work packets MAY run in parallel **iff** they are **dependency-independent** (neither is reachable from the other along `depends_on` edges) **AND write-disjoint** (their `writes` sets share no SURFACE, and there is no read/write conflict on a shared surface, and they share no interface/migration node). Anything unscoped or sharing a surface **serializes by default** (§18, G7).

A packet's `merge_safe` MUST be `false` if it has any unresolved `conflicts_with` edge to a packet in the same `batch`, or if any of its `inputs` is unscoped (empty `writes` where a write is implied). `merge_safe` is the kernel's *static* verdict; a launcher MAY further serialize for its own reasons but MUST NOT parallelize two packets the plan marks unsafe. *Rationale: review entropy and merge collisions, not agent count, are the binding constraint on safe parallelism (§18).*

### 13.7 Worked fragment

For the auth-refresh spec (one INTERFACE, one REQ depending on it, one INVARIANT), a conformant plan fragment:

```json
{
  "meta": { "id": "auth-refresh", "derived_from": "auth-refresh.swarm.ir.json",
            "language": "SOL/0.1", "version": "0.1.0", "max_parallel": null },
  "packets": [
    { "id": "WP-001", "pass": "implement", "profile": "default",
      "inputs": ["INTERFACE.auth-refresh.IF-001"], "outputs": ["openapi/auth-refresh.yaml"],
      "writes": ["api.auth.contract"], "reads": [], "depends_on": [],
      "lane": "shared", "batch": 0, "merge_safe": false },
    { "id": "WP-002", "pass": "implement", "profile": "default",
      "inputs": ["REQ.auth-refresh.AC-001", "INVARIANT.auth-refresh.I-001"], "outputs": ["web/src/http/client.ts"],
      "writes": ["web.http.client"], "reads": ["api.auth.contract"],
      "depends_on": ["WP-001"], "lane": "agent-a", "batch": 1, "merge_safe": true },
    { "id": "WP-003", "pass": "verify", "profile": "default",
      "inputs": ["INVARIANT.auth-refresh.I-001"], "outputs": ["auth-refresh.swarm.trace.md"],
      "writes": ["web.http.tests"], "reads": ["web.http.client"],
      "depends_on": ["WP-002"], "lane": "agent-b", "batch": 2, "merge_safe": true }
  ],
  "edges": [
    { "from": "WP-002", "to": "WP-001", "type": "depends_on", "hard": true },
    { "from": "WP-003", "to": "WP-002", "type": "depends_on", "hard": true }
  ],
  "provenance": { "hash": "sha256:…", "compiler_version": null, "compiled_at": "2026-05-31T12:00:00Z" }
}
```

`WP-001` is `merge_safe: false` (it freezes a shared interface contract; consumers serialize behind it); `WP-002` and `WP-003` are write-disjoint from their batch-mates and depend only on completed prior batches, so they are `merge_safe: true`. The full pipeline for this spec appears in Appendix D.

### 13.8 Conformance and the formal schema

A document is a conformant SOL/0.1 plan iff it: (1) has exactly the four top-level keys of §13.3; (2) populates every field Appendix C.3 marks `required` (defaulting optional fields), per §13.4–§13.5; (3) carries no `locks` field anywhere (§13.2); (4) uses only the closed pass set (§9) in `packets[].pass` and the closed edge-type set (§12.5) in `edges[]`; (5) represents inter-packet relationships once, as edges (§13.5.1); (6) keeps the three version fields distinct (§12.7). The plan schema is documented data only — no running emitter or scheduler ships (§13.1). The formal JSON Schema for the plan is **Appendix C.3**.

---
