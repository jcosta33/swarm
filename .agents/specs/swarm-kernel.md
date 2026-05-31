# Swarm — The Kernel Specification (v0.1)

This document is the single authoritative, consolidated **kernel specification** for Swarm: an obligation-centered specification-compiler framework for agentic software engineering. It defines the Swarm Obligation Language (SOL), the Agent Prose Semantics standard (APS), the unified lint taxonomy, the phase/pass model, the lowering and intermediate-representation contracts, the verification and verdict model, the orchestration and coordination contracts, the artifact set and conformance definition, the source-authority and memory models, and the versioning regime. It is the artifact the entire Swarm repository will be reworked from. It is a *specification of contracts*, not a runtime: Swarm ships markdown only, and everything described here as something that "runs" (a parser, planner, scheduler, differ, checker, or CLI) is defined as a contract a future tool builds against — never as software this repository provides.

## 0. Preamble, status, and how to read this document

### 0.1 Status

| Field | Value |
|-------|-------|
| Title | Swarm — The Kernel Specification |
| Language version | SOL/0.1 (and APS 0.1) |
| Document status | **Accepted** |
| Document role | Single canonical kernel; the source the entire repository is reworked from |
| Supersedes | The four source files listed in §0.2 |
| Resolution log | `.agents/research/swarm-kernel-decisions.md` |

This document is **Accepted** as the v0.1 kernel. Once accepted, every Swarm document, template, scaffold artifact, pass guide, profile, and ADR MUST be consistent with this specification; where any existing repository file disagrees, this specification governs and that file MUST be reworked to conform (§34).

### 0.2 What this document supersedes

Swarm's design was previously distributed across four working documents that contained overlapping and, in places, contradictory detail. This specification consolidates them. Their roles are now fixed:

| Source file | Prior role | Status under this spec |
|-------------|------------|------------------------|
| `.agents/specs/swarm-rework.md` | The build brief | **Authoritative on INTENT.** Its templates, examples, and section prose are adapted here where the decision record affirms them. Superseded as a normative reference only where this spec restates the same material. |
| `.agents/research/sol.md` | SOL research | **Superseded detail.** Reconciled into §5–§16. |
| `.agents/research/swarm-sol.md` | SOL/compiler research | **Superseded detail.** Reconciled into §5–§19. |
| `.agents/research/compiler.md` | Compiler-model research | **Superseded detail.** Reconciled into §9–§13. |

Every contradiction across these four files was resolved once, globally, in the decision record `.agents/research/swarm-kernel-decisions.md`. That record is the authority of last resort: it carries four cross-cluster conflict resolutions (X1–X4), one canonical answer per design question (Q1.1–Q9.31), the canonical vocabulary cheat-sheet (reproduced normatively in §4), and twelve residual gaps (G1–G12) whose recommended resolutions this v0.1 adopts as normative (Appendix E). A settled decision MUST NOT be re-opened by any author or tool; a change to a settled decision is an amendment that MUST be recorded as a new ADR (§30) and, if it touches the language, MUST bump the language version (§25).

### 0.3 The meta-convention: two layers of modal language

This document operates on two distinct languages, and the reader MUST keep them separate.

- **The meta-language** is the language *this specification* speaks about conformant Swarm repositories, tools, and authors. Its normative keywords — **MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, REQUIRED, OPTIONAL** — are to be interpreted per RFC 2119 and RFC 8174, and carry force *only* when in uppercase. Example: "An `INTERFACE` block MUST carry a `VERIFY BY contract:` binding."
- **The object-language** is SOL itself — the language Swarm authors write inside `*.swarm.md` files. SOL has its own modals (MUST, MUST NOT, SHOULD, SHOULD NOT, MAY; §4.2) which decorate obligations. When this document quotes SOL, those modals are **data being specified**, not directives of this document. Example: in the SOL line `THE client MUST clear the local session`, the word `MUST` is an SOL token whose semantics §6 defines; it is not a requirement levied on the reader of this specification.

To reduce ambiguity, every SOL fragment, grammar production, JSON shape, and template skeleton in this document appears inside a fenced code block tagged `sol`, `ebnf`, `json`, or `text`. Modal words appearing in such fences are object-language. Modal words in running prose are meta-language.

### 0.4 Reading order

This document is exhaustive and may be read front to back, but the following order builds the mental model fastest:

1. **§1–§3** — the thesis ("spec as code, agents as compiler"), the five invariants, and the layer-cake architecture. Read these first; they frame everything else.
2. **§4** — the canonical vocabulary. This is the reference card every later section points to. Skim it, then return as needed.
3. **§5–§8** — the surface: SOL syntax, the seven block types, the APS prose standard, and the unified lint taxonomy.
4. **§9–§13** — the machinery: phases, passes, the improve operation set, lowering/decomposition, the IR, and the plan.
5. **§14–§17** — truth and control: verdicts, the proof taxonomy, drift, and the soft/hard control boundary.
6. **§18–§24** — orchestration, the artifact set, conformance, source authority, memory, and the distillation loss budget.
7. **§25–§35** — versioning, the recast subsystems (skills, personas, task types, documents, ADRs, the bootloader), the conformance contract, the golden corpus, acceptance criteria, and non-goals.
8. **Appendices A–F** — the consolidated grammar, the full lint catalogue, the IR schema, the auth-refresh worked example, the residual-gap judgment calls, and the glossary.

A newcomer who reads only §1–§4 should be able to hold the whole framework in their head; the remaining sections make every construct precise.

### 0.5 The two version axes (labelling convention)

Swarm carries **two independent version numbers**, and this document is versioned on the first of them. This convention is normative throughout and specified in full in §25.

- **Language version** — the SOL+APS grammar, block set, modal set, clause keywords, and lint codes. Slow-moving: `0.1` (this document), then `0.2`, `1.0`. Carried in `*.swarm.md` frontmatter as the discriminator `swarm_language: SOL/0.1` and in the IR as `meta.language`.
- **Framework / package version** — the scaffold, templates, pass guides, and profiles, versioned as semver in `.agents/.swarm-version`. Fast-moving and independent.

This document is **language v0.1**. The framework package that delivers it carries its own semver. The one-way trigger (§25): any language change forces at least a framework MINOR release; the framework MAY release many versions without changing the language version.

## 1. What Swarm is — the specification-compiler thesis

### 1.1 The thesis

Swarm treats a **specification as source code** and a **fleet of agents as the compiler**. Human intent is written as a controlled-markdown specification; that specification is compiled — through an ordered, named sequence of transformations — into work that is implemented, verified against the original obligations, and promoted into durable project knowledge, at an extremely high and *evidenced* level of confidence.

> **Swarm is an obligation-centered specification compiler framework for agentic software engineering. It turns human intent into verifiable obligations, lowers those obligations into bounded agent tasks, verifies traces against obligations, and promotes durable discoveries back into project memory.**

The pipeline, end to end:

```text
human intent
  → source artifacts (research / audit / bug-report)
  → *.swarm.md specification (prose + SOL blocks)
  → obligation graph (the IR)
  → plan
  → task frames (bounded work packets)
  → agent execution
  → trace
  → verification (proofs → verdicts)
  → review verdict
  → promotion
  → durable memory update
```

The goal is **spec-as-code with verifiable output**. Swarm is explicitly *not* a chat assistant, not a prompt library, and not a set of canned instructions: it is a manual-to-automatable *compiler architecture* whose output is required behavior that has been proven, not merely asserted.

### 1.2 The obligation graph is the central object

The single object every part of Swarm reads and writes is the **obligation graph**: a typed graph whose nodes are *obligations* (and the judgments rendered on them) and whose edges are the *relationships* among them. The graph is the SOL specification's intermediate representation (the IR, §12). Every role in the framework reduces to an operation on this graph:

```text
Specs           produce obligations.
The compiler    lowers obligations into a plan and tasks.
Tasks           implement obligations.
Traces          claim obligations were implemented.
Verification    proves obligations (or fails to).
Reviews         judge obligations (render verdicts).
Memory          records durable discoveries about obligations.
Orchestration   schedules obligations without write-conflict.
```

Because the graph — not prose, and not any agent's recollection — is the source of truth, every pass can be checked against it, and the final merge gate (§14) reduces to a property of the graph: *every required obligation carries a passing verdict.*

### 1.3 "Unitary at rest, modular in execution"

Swarm's organizing slogan is **"unitary at rest, modular in execution."**

- **Unitary at rest** — Swarm installs as one coherent framework. The language, artifact contracts, passes, templates, pass guides, and memory model arrive together and are internally consistent. There is no menu of disconnected features to assemble.
- **Modular in execution** — at run time, only the pass, profile, and context a single task needs are loaded. A task names the pass guide and profile it requires; nothing else is in context. This protects instruction-adherence and token cost (§2.10) without fragmenting the framework.

### 1.4 What this supersedes: the buffet framing is retired

Earlier Swarm framing presented the system as a **buffet** — a pick-your-own library of skills, personas, task types, and templates, adopted incrementally, "until it stops earning its keep." That framing is **superseded**. Skills, personas, and task types are no longer independent products to be selected; they are unified under the compiler model:

| Earlier (buffet) framing | Kernel (compiler) framing | Specified in |
|--------------------------|---------------------------|--------------|
| Skills you pick à la carte | **Pass guides** — reusable methods for executing a named pass | §26 |
| Personas / characters | **Heuristic profiles** — cognitive stances parameterizing a pass | §27 |
| 18 task types | **Pass frames** — a `task_kind` enum that parameterizes `implement`/`author` | §28 |
| 4 core docs + extended types | One **unified artifact set** centered on the obligation graph | §29 |
| "Recommended routing" prose | Deterministic **lowering** + a **plan** the launcher executes | §11, §13 |

Adoption may still be incremental at the *repository* level (a team may vendor a subset), but the *conceptual model* is unitary: every piece is a component of one compiler, not an independent gadget. A skill never owns language semantics (§26.2); a persona is never a character (§27); a task type is never an open-ended prompt log (§28).

### 1.5 What Swarm is not

| Swarm is | Swarm is not |
|----------|--------------|
| A specification compiler whose output is verified, promoted work | A chat assistant or autonomous "magic" |
| A markdown-only set of contracts a future tool builds against | A CLI, SDK, scheduler, or runtime this repo ships (§2.6) |
| Provider-neutral (no assumption about which model/agent runs it) | Tied to any specific agent tool or vendor |
| A formal spine (SOL) inside readable markdown | A general-purpose programming language |

## 2. Foundational principles and invariants

Five invariants hold in **every** section of this document; no later section may contradict them. They are followed by the standing principles the decision record relies on. Each is stated tightly: name, rationale (one clause), and the one-line consequence for authors and tools.

### 2.1 The five invariants

#### 2.1.1 Invariant 1 — NO RUNTIME

Swarm is **markdown-only**. Everything that "runs" — parser, normalizer, planner, scheduler, differ, checker, CLI — is documented as a **contract a future tool builds against**, and is never shipped by this repository.

- *Rationale:* the repository is documentation and scaffold; shipping a runtime would couple Swarm to one environment and contradict provider-neutrality.
- *Consequence:* any section describing tool behavior MUST frame it as "the contract a future tool builds against," never as "a tool Swarm provides." No file MAY claim a CLI is required or that automation already exists.

#### 2.1.2 Invariant 2 — SOFT vs HARD control

Prose, SOL, APS, skills, profiles, and `AGENTS.md` are **SOFT control** (context and guidance). They MUST NOT be presented as enforcement. Anything that must hold *regardless of the model* requires a **deterministic check OUTSIDE the model** (a hook, CI step, permission rule, or schema validator) — the **HARD control** lane.

- *Rationale:* model adherence is probabilistic (prompt-format sensitivity, multi-turn decay, context-rot; §2.10); only an external deterministic check can guarantee a property.
- *Consequence:* the spec maps each `CONSTRAINT`, `INVARIANT`, stop-rule, and secret-redaction need to its eventual deterministic home (§17), and states plainly that **today the hard lane is aspirational/manual** (no runtime). No file MAY claim Swarm enforces behavior through code.

#### 2.1.3 Invariant 3 — Surface-vs-IR layering

Swarm has two layers: a **human surface** (English-shaped UPPERCASE space-separated keywords inside `*.swarm.md`) and a **machine IR/JSON layer** (snake_case fields). The surface is authored; the IR is emitted.

- *Rationale:* the surface optimizes for human readability and model comprehension; the IR optimizes for deterministic analysis — conflating them produces fragile syntax.
- *Consequence:* surface keywords are space-separated uppercase (`VERIFY BY`, `DEPENDS ON`, `OWNED BY`, `WRITES`, `READS`, `AFFECTS`); IR fields are snake_case (`verify_by`, `depends_on`, `writes`, `reads`, `affects`); surface ids are short (`AC-001`), IR node ids MAY be namespaced (`REQ.<spec>.AC-001`). See §4.10.

#### 2.1.4 Invariant 4 — CODE IS REALITY

Code and tests are implementation **reality**: they can **falsify** an obligation, but they MUST NOT **silently amend** intent.

- *Rationale:* a passing or failing test is evidence about whether intent was met, not a re-statement of what intent *is*; intent lives only in obligations.
- *Consequence:* when code disagrees with an obligation, the verdict is `STALE` or `CONTRADICTED` and the conflict MUST route to an explicit three-way reconcile — re-run the proof, amend/supersede the obligation, or fix the code — never a silent re-bless of either (§16, §22).

#### 2.1.5 Invariant 5 — Schema-valid output is NOT verification

A structurally valid artifact (schema-valid IR, well-formed trace) is **not** a verified one. **Shape is not truth.**

- *Rationale:* structured output constrains form but cannot prove that values are correct; "tests passed" without observable output is not a proof.
- *Consequence:* every completion claim MUST map to independent deterministic or evidentiary verification (§14, §15); a `VERDICT` of `PASS` requires a bound proof that actually ran and produced inspectable evidence, not the mere existence of a syntactically valid trace.

### 2.2 Provider-neutral

Swarm makes **no assumption about which model or agent** executes it (not Claude, Codex, Cursor, Gemini, Aider, or any specific tool).

- *Rationale:* the contracts must outlive any single vendor and any single capability ceiling.
- *Consequence:* no section MAY hard-code provider-specific behavior, and capability claims MUST be dated and treated as evidence, not as load-bearing assumptions.

### 2.3 Markdown-only with a self-contained scaffold

Swarm is delivered as markdown, and the scaffold MUST be **self-contained**: the scaffold's SOL and APS references MUST NOT depend on the repository's `docs/` tree.

- *Rationale:* a vendored scaffold travels into a foreign repository where `docs/` will not exist.
- *Consequence:* the language references are duplicated into the scaffold (§20, §21), and the duplication is kept consistent by the conformance contract (§32).

### 2.4 Edges are the single source of relationship truth

In the IR, **relationships live only on `edges[]`** — never duplicated as node scalars.

- *Rationale:* a relationship recorded in two places will drift; one canonical location keeps graph analyses (topo-sort, cycle detection, write-conflict, traceability) sound.
- *Consequence:* `depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, and `preserves` are edge types; a node MUST NOT also carry the same relationship as a scalar field (§12).

### 2.5 Distillation discipline

Meaning MUST be **preserved across every lowering**. Each downstream transformation has a fixed budget of *permitted* loss and a fixed set of *forbidden* loss.

- *Rationale:* a compiler that drops obligations, modalities, or verification bindings during lowering produces work that does not match intent.
- *Consequence:* dropping an obligation id, modality, actor, trigger, response, constraint, invariant, or verification binding during lowering is a **distillation error** (§24).

### 2.6 Load-bearing meaning lives only in SOL + IR

**All load-bearing meaning** — modality, actor, trigger/state, verification binding, authority order, conflict resolution, trace schema — lives in **SOL and the typed IR**, and never in prose, skills, personas, or `AGENTS.md`.

- *Rationale:* prose-delivered semantics are unreliable under **prompt-format sensitivity** (±40% on identical content), **multi-turn reliability decay** (~−39%), and **lost-in-the-middle / context-rot** (20–50% degradation); Anthropic gives "no guarantee of strict compliance" for always-loaded prose.
- *Consequence:* prose and skills are non-authoritative *delivery* layers; a regression check (§32) MUST confirm that **no skill, persona, or `AGENTS.md` section defines modality, authority order, or verification semantics**. Always-loaded normative prose is capped (≤200 lines / ≤25 KB; §17, §31), with everything procedural moved to lazily-loaded pass guides and profiles — to minimize always-on density and protect adherence and cost, *not* because models "cannot follow many instructions."

## 3. Architecture overview — the obligation graph and the layer cake

### 3.1 The layer cake

Swarm is a stack of layers. Each layer is produced from the one above it by a named pass (§9) and consumed by the one below it. The surface is human-authored; the middle layers are machine-emitted (today, by an agent following a documented contract; later, by a tool); the JSON layers are contract-only (reserved names, no shipped emitter — Invariant 1).

```text
        ┌─────────────────────────────────────────────────────────────┐
HUMAN   │  SURFACE                                                      │
AUTHORED│  *.swarm.md  =  APS prose  +  SOL blocks                      │
        │  (REQ, CONSTRAINT, INVARIANT, INTERFACE, QUESTION, TRACE,     │
        │   VERDICT)                                                    │
        └─────────────────────────────────────────────────────────────┘
                         │  lint  (PARSE + NORMALIZE)   →  diagnostics
                         │  improve (NORMALIZE)         →  semantics-preserving repair
                         ▼
        ┌─────────────────────────────────────────────────────────────┐
MACHINE │  IR  —  THE OBLIGATION GRAPH                                  │
EMITTED │  *.swarm.ir.json = { meta, nodes[], edges[], diagnostics[],   │
(contract)│                     provenance }                            │
        └─────────────────────────────────────────────────────────────┘
                         │  lower + decompose (LOWER)
                         ▼
        ┌─────────────────────────────────────────────────────────────┐
MACHINE │  PLAN                                                         │
EMITTED │  *.swarm.plan.json = dependency DAG + write-conflict graph    │
(contract)│                     + bounded work packets                 │
        └─────────────────────────────────────────────────────────────┘
                         │  implement (EXECUTE)
                         ▼
        ┌─────────────────────────────────────────────────────────────┐
HUMAN/  │  EXECUTION                                                    │
AGENT   │  task.md  —  one bounded work packet, one pass               │
        └─────────────────────────────────────────────────────────────┘
                         │  (agent does the work; records claims)
                         ▼
        ┌─────────────────────────────────────────────────────────────┐
MACHINE │  TRACE                                                        │
EMITTED │  *.swarm.trace.md  —  TRACE blocks: IMPLEMENTS / PRESERVES /  │
        │                       CHANGED / PROOF                         │
        └─────────────────────────────────────────────────────────────┘
                         │  verify + review (VERIFY + REVIEW)
                         ▼
        ┌─────────────────────────────────────────────────────────────┐
HUMAN/  │  VERDICT                                                      │
AGENT   │  review.md  —  VERDICT blocks (PASS/FAIL/BLOCKED/UNVERIFIED   │
        │                + lifecycle) + merge gate                      │
        └─────────────────────────────────────────────────────────────┘
                         │  promote (PROMOTE)
                         ▼
        ┌─────────────────────────────────────────────────────────────┐
HUMAN/  │  PROMOTION                                                    │
AGENT   │  finding.md · adr.md · memory/INDEX.md · memory/patterns/*    │
        └─────────────────────────────────────────────────────────────┘
```

### 3.2 Which layers are authored, emitted, or contract-only

| Layer | Artifact(s) | Origin |
|-------|-------------|--------|
| Surface | `*.swarm.md` | **Human-authored** (the only human-authored `.swarm.` artifact) |
| IR | `*.swarm.ir.json` | **Machine-emitted; contract-only name** (reserved; no shipped emitter — Invariant 1) |
| Plan | `*.swarm.plan.json` | **Machine-emitted; contract-only name** (reserved; no shipped emitter) |
| Execution | `task.md` | **Human/agent working artifact** (plain `.md`) |
| Trace | `*.swarm.trace.md` | **Machine-emitted instance** (template `trace.md` is human-copyable) |
| Verdict | `review.md` | **Human/agent working artifact** (VERDICT is a language block; `review.md` is its container — there is no `verdict.md`) |
| Promotion | `finding.md`, `adr.md`, `memory/INDEX.md`, `memory/patterns/*.md` | **Human/agent working artifacts** |

The `.swarm.` infix is the discriminator: a `.swarm.` filename is parsed or emitted by the compiler; a plain `.md` filename is a human/agent working artifact (§4.7, §20).

### 3.3 The obligation graph is what every pass reads and writes

The IR layer is the **obligation graph**: `nodes[]` are obligations and the judgments rendered on them; `edges[]` are the relationships among them (Invariant 4 — edges are the single source of relationship truth). Every pass is an operation on this graph: `lint` annotates it with diagnostics, `improve` rewrites nodes without changing their meaning, `lower`/`decompose` derive the plan's DAG and conflict graph from it, `implement` produces traces that attach to its obligation nodes, `verify`/`review` attach verdicts to those nodes, and `promote` reads the judged graph to emit durable artifacts. The final merge gate (§14) is a predicate over the graph: every required obligation node carries a verdict of `PASS` or `WAIVED`, and none is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED`.

### 3.4 Phases vs passes at a glance

Swarm distinguishes **phases** (conceptual compiler *stages*, fixed and ordered) from **passes** (schedulable *transformations*, in pipeline order). Several passes may share one phase. The full mapping and per-pass detail are in §9.

```text
PHASES (7, conceptual stages):
  PARSE → NORMALIZE → LOWER → EXECUTE → VERIFY → REVIEW → PROMOTE

PASSES (9, schedulable):
  author → lint → improve → lower → decompose → implement → verify → review → promote

mapping:
  author     → (entry, pre-parse)
  lint       → PARSE + NORMALIZE
  improve    → NORMALIZE
  lower      → LOWER
  decompose  → LOWER
  implement  → EXECUTE
  verify     → VERIFY
  review     → REVIEW
  promote    → PROMOTE
```

A newcomer's mental model: *write a spec (surface) → check and tidy it (lint, improve) → compile it into a graph and a plan (lower, decompose) → do the bounded work (implement) → prove and judge it (verify, review) → fold what you learned back into memory (promote).*

## 4. Canonical vocabulary (normative)

This section is the document's canonical reference card. It reproduces the decision record's vocabulary cheat-sheet exactly. Every other section points here; where two layers use different spellings for the same construct, this section's split (surface vs IR) governs. Each group ends with a "see §N" pointer to the section that specifies it in full.

### 4.1 Block types (7)

| Type | Surface id prefix | Role | Carries binding force? |
|------|-------------------|------|------------------------|
| `REQ` | `AC-NNN` | Required behavior (obligation) | **Yes** |
| `CONSTRAINT` | `C-NNN` | Restriction on how obligations may be satisfied | **Yes** |
| `INVARIANT` | `I-NNN` | Property that must remain preserved | **Yes** |
| `INTERFACE` | `IF-NNN` | Declares a boundary / API / schema / contract | No (declares) |
| `QUESTION` | `Q-NNN` | Marks unresolved ambiguity | No (marks) |
| `TRACE` | `T-NNN` | Claims obligations were implemented | No (claims) |
| `VERDICT` | reuses the judged obligation's id | Judges an obligation | No (judges) |

Header form: `TYPE PREFIX-NNN:` — the trailing colon is **mandatory**. The **obligation blocks** that carry binding force are `REQ`, `CONSTRAINT`, and `INVARIANT` only. *See §6.*

### 4.2 Modals (5)

| Modal | Force | Requirement |
|-------|-------|-------------|
| `MUST` | Required | — |
| `MUST NOT` | Forbidden | — |
| `SHOULD` | Strong default | Requires an accompanying `BECAUSE` or `EXCEPT` |
| `SHOULD NOT` | Strong prohibition | Requires an accompanying `BECAUSE` or `EXCEPT` |
| `MAY` | Optional | — |

Uppercase only. **Removed:** `SHALL`, `SHALL NOT` (redundant with `MUST`/`MUST NOT`). **Forbidden in binding clauses** (lint warning): `CAN`, `WILL` (non-modal). Lowercase `must`/`should`/`may` carry no force (plain prose). *See §5.4, §6.*

### 4.3 Clause keywords by block (uppercase, case-sensitive)

| Block | Ordered clause keywords |
|-------|-------------------------|
| `REQ` | `WHERE` → `WHILE` → `WHEN` → `IF [THEN]` → `THE <actor> <MODAL> <response>` → `[AND THE <actor> <MODAL> <response>]*` → `[BECAUSE]` → `[EXCEPT]` → `VERIFY BY` → trailing metadata `DEPENDS ON / TOUCHES / WRITES / READS / AFFECTS / RISK <low\|medium\|high\|critical>` |
| `INVARIANT` | `<property> MUST\|MUST NOT <hold>` (no `ALWAYS`/`NEVER`) |
| `INTERFACE` | `RETURNS`, `ACCEPTS`, `ERRORS`, `OWNED BY` |
| `QUESTION` | `[blocking\|non-blocking]` tag, `AFFECTS` |
| `TRACE` | `IMPLEMENTS`, `PRESERVES`, `CHANGED`, `PROOF` |
| `VERDICT` | `REASON`, `EVIDENCE` |

`THEN` is optional sugar **after `IF` only** — never after `WHEN`/`WHILE`. **Deferred to v0.2** (timing): `WITHIN`, `BEFORE`, `UNTIL`, `IMMEDIATELY`, `EVENTUALLY`. *See §5, §6.*

### 4.4 Verdicts (7 = 4 core + 3 lifecycle)

| Kind | Value | Meaning |
|------|-------|---------|
| Core | `PASS` | Bound proof ran and succeeded |
| Core | `FAIL` | Bound proof ran and failed |
| Core | `BLOCKED` | Proof could not run (prereq/tool/env missing) |
| Core | `UNVERIFIED` | No acceptable proof bound or none executed |
| Lifecycle | `WAIVED` | A `FAIL`/`UNVERIFIED` accepted with named authority + reason + expiry |
| Lifecycle | `STALE` | Prior `PASS` whose evidence no longer matches the current source/surface hash |
| Lifecycle | `CONTRADICTED` | Two proofs disagree, or trace/code disagrees with the obligation |

Verdict line: `VERDICT <id>: <CORE> [(<lifecycle> by <authority>: <reason>)]`. **Merge gate:** merge iff every required obligation is `PASS` or `WAIVED`; none `STALE`/`CONTRADICTED`/`FAIL`/`BLOCKED`/`UNVERIFIED`. *See §14.*

### 4.5 Proof types (9, closed)

| Type | Notes |
|------|-------|
| `static` | resolves to `cmdLint`/`cmdTypecheck`/`cmdValidate` |
| `test` | scope qualifiers: `test:unit:`, `test:integration:`, `test:e2e:` |
| `contract` | **required** for every `INTERFACE` block |
| `property` | preferred for `INVARIANT` |
| `model` | model-checking or economical proof |
| `perf` | resolves to `cmdBenchmark` |
| `security` | integration-boundary commands |
| `manual` | the honest escape hatch |
| `monitor` | (was `runtime`) |

Binding clause: `VERIFY BY <type>:<adapter>:<artifact>[#selector]`. The `<adapter>` resolves through `AGENTS.md` > Commands (the `cmd*` placeholder slots are the adapters). Proof-strength order (CONTRADICTED tie-break): `model > property/contract > test > static > manual/monitor`. *See §15.*

### 4.6 Phases, passes, and improve operations

| Group | Members |
|-------|---------|
| **Phases (7, conceptual, fixed order)** | `PARSE → NORMALIZE → LOWER → EXECUTE → VERIFY → REVIEW → PROMOTE` |
| **Passes (9, schedulable, pipeline order)** | `author → lint → improve → lower → decompose → implement → verify → review → promote` |
| **Stdlib pass guides (5, first tooled — a subset)** | `lint`, `decompose`, `implement`, `review[profile: skeptic]`, `promote` |
| **Improve ops (10, closed, strictly semantics-preserving)** | `NORMALIZE · ATOMIZE · CONCRETIZE · QUANTIFY · BIND · SCOPE · CLARIFY · DECONFLICT · COMPRESS · PROMOTE` |

`decompose` is a **pass**, not an improve op. Any intent change routes to amendment/review, never to `improve`. *See §9 (phases/passes), §10 (improve ops).*

### 4.7 Artifact filenames

| Category | Files |
|----------|-------|
| Compiler-visible (`.swarm.` infix) | `*.swarm.md` (the source spec — the **only** human-authored `.swarm.` artifact) · `*.swarm.ir.json` (emitted IR) · `*.swarm.plan.json` (emitted plan) · `*.swarm.trace.md` (emitted trace) |
| Plain `.md` working artifacts | `task.md · review.md · finding.md · adr.md · audit.md · research.md · bug-report.md · memory/INDEX.md · memory/glossary.md · memory/patterns/*.md` |
| Kernel-required core templates (7) | `spec.swarm.md · task.md · trace.md · review.md · finding.md · adr.md · memory/INDEX.md` |

There is **no `verdict.md`**: `VERDICT` is a language block and `review.md` is its container. *See §20, §21.*

### 4.8 Lint namespace (one prefix, five layers)

`SOL-<LAYER><NNN>`, each layer a 100-block, append-only with tombstoning:

| Layer | Letter | Scope |
|-------|--------|-------|
| Syntax | `S` | Parser-detectable well-formedness |
| Prose | `P` | Controlled-prose / requirement-smell (the former APS layer; also absorbs old `SOL-L` codes) |
| Semantic | `M` | Cross-reference: duplicate id, contradiction, unbound ref |
| Verification | `V` | Proof-binding: missing / stale / non-observable proof |
| Orchestration | `O` | Planning / parallelism: write-conflict-marked-parallel, dep cycle, blocking QUESTION reaching lowering |

`APS-` is retired as a *code* prefix (APS survives only as the name of the prose standard). Every diagnostic record is `{code, severity, layer, span, message, suggest}`. *See §8, Appendix B.*

### 4.9 IR envelope

```json
{ "meta": {}, "nodes": [], "edges": [], "diagnostics": [], "provenance": {} }
```

| Component | Notes |
|-----------|-------|
| `edges[].type` | `depends_on · blocks · conflicts_with · verified_by · affects · implements · preserves` — the **single source of relationship truth** (relationships are NOT also node scalars) |
| `meta.language` | the SOL discriminator, e.g. `SOL/0.1` |
| `meta.version` | spec content version |
| `provenance.compiler_version` | tool version when one exists |

The three version fields are distinct and MUST NOT be merged. *See §12, Appendix C.*

### 4.10 Surface-vs-IR casing

| Surface (in `*.swarm.md`) | IR (in `*.swarm.ir.json`) |
|---------------------------|---------------------------|
| `VERIFY BY` | `verify_by` |
| `DEPENDS ON` | `depends_on` |
| `OWNED BY` | `owned_by` |
| `WRITES` | `writes` |
| `READS` | `reads` |
| `AFFECTS` | `affects` |
| surface id `AC-001` | IR node id MAY be `REQ.<spec>.AC-001` |

Surface = English-shaped UPPERCASE space-separated keywords. IR = snake_case. Lock groups are named `SURFACE`s (`SURFACE <name> = …`); there is **no `locks` primitive**. *See §5, §12, §18.*

### 4.11 Version axes (2)

| Axis | What it versions | Where it lives | Cadence |
|------|------------------|----------------|---------|
| **Language** | SOL+APS grammar, blocks, modals, lint codes | frontmatter `swarm_language: SOL/0.1` (+ `aps_version`); IR `meta.language` | Slow: `0.1`, `0.2`, `1.0` |
| **Framework / package** | scaffold, templates, pass guides, profiles | `.agents/.swarm-version` (semver) | Fast |

**One-way trigger:** any language change forces at least a framework MINOR release; the framework MAY release many versions without touching the language version. *See §25.*

### 4.12 The five invariants

| # | Name | One-line statement |
|---|------|--------------------|
| 1 | **No runtime** | Markdown-only; everything that "runs" is a contract a future tool builds against, never shipped. |
| 2 | **Soft vs hard control** | Prose/SOL/APS/skills/`AGENTS.md` are soft guidance; anything that must hold needs a deterministic check outside the model (today aspirational/manual). |
| 3 | **Surface-vs-IR layering** | Human surface = UPPERCASE space-separated keywords; IR = snake_case fields. |
| 4 | **Code is reality** | Code/tests can falsify an obligation but never silently amend intent. |
| 5 | **Schema-valid is not verified** | Shape is not truth; every completion claim maps to independent verification. |

*Specified in full in §2; consequences for the control lane in §17, for verification in §14–§15, for drift in §16.*


## 5. SOL surface syntax

### 5.1 Scope and layering

This section specifies the *surface syntax* of SOL (Swarm Obligation Language): the concrete, human-authored form that appears inside `*.swarm.md` files. SOL surface syntax is the only SOL form a human writes; the snake_case IR/JSON layer (§12) is *emitted*, never authored. This is the master layering of the language: **surface is English-shaped UPPERCASE keywords; IR is snake_case fields.** Where this section gives a surface keyword (`VERIFY BY`, `DEPENDS ON`, `OWNED BY`), the corresponding IR field name (`verify_by`, `depends_on`, `owned_by`) is reserved for §12 and MUST NOT appear at the surface.

A conformant SOL document is a Markdown document (`*.swarm.md`) in which obligation content is expressed as SOL *blocks* interleaved with APS-controlled prose (§7). The full normative grammar lives in Appendix A; this section fixes the lexical and block-delimiting rules that grammar presupposes, and §6 gives the per-block clause grammars.

> Rationale (Q1.7): a single line-oriented EBNF supersedes all three competing research grammars. This section and §6 are that grammar's prose form; Appendix A is its formal form. The two MUST agree.

### 5.2 The block header — the one normative delimiter

A SOL block is introduced by a **bare header line** of the exact form:

```ebnf
block_header = block_type , ws , id , ":" , nl ;
block_type   = "REQ" | "CONSTRAINT" | "INVARIANT" | "INTERFACE"
             | "QUESTION" | "TRACE" | "VERDICT" ;
```

The header is a single line consisting of the block-type keyword, one or more spaces, the block id, and a **mandatory trailing colon**. Example:

```sol
REQ AC-001:
```

The trailing colon is REQUIRED. A header without it (`REQ AC-001`) is not a block header; it is prose, and any obligation clauses that follow are unparsed. A parser MUST treat the colon as the delimiter that opens a block body.

> Rationale (Q1.1): EARS, FRETish, and Gherkin all use leading-keyword bare lines; the build brief uses bare headers throughout. The mandatory colon (from `compiler.md`) makes the header unambiguously machine-detectable inside free Markdown.

A QUESTION header additionally carries a blocking tag *before* the colon (§6.5); this is the only header variation:

```sol
QUESTION Q-001 [blocking]:
```

### 5.3 Body line-grouping rule

A block **body** is the maximal run of contiguous non-blank lines immediately following the header, terminated by the first of:

1. the next block header (any of the seven `block_type` keywords beginning a line, with a trailing colon);
2. a **blank line** (one or more consecutive newline-only lines);
3. a **Markdown heading** line (a line beginning with one or more `#` followed by a space).

No other construct closes a body. This rule replaces both the fenced `:::TYPE … :::END` delimiter and significant indentation (see §5.4). Worked example — three blocks separated by blank lines and a heading:

```sol
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
VERIFY BY test:cmdTest:auth-refresh-expired-token

CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
VERIFY BY static:cmdLint:dependency-boundary-check

## Invariants

INVARIANT I-001:
A user MUST NOT have more than one active refresh token family
VERIFY BY property:cmdTest:token-family-invariant
```

Here the blank line after `… local session` would also have closed `AC-001`; the `VERIFY BY` line is part of `AC-001` because it is contiguous. The `## Invariants` heading closes nothing that was still open (a blank line already closed `C-001`), and a parser MUST NOT absorb a heading into a body.

A conformant author MUST NOT place a blank line *inside* a block body, because the blank line terminates the body. Multi-item clauses (e.g. INTERFACE `ERRORS:`) therefore use contiguous indented bullet continuation lines, never blank-separated lists (§6.4).

### 5.4 Rejected surface forms (and why)

The following alternative surface forms are **rejected** for SOL v0.1. Each MAY be revisited only as noted.

| Rejected form | Example | Rationale (one clause) | Future status |
|---|---|---|---|
| Fenced block delimiter | `:::REQ AC-001 … :::END` | A second nested fence is fragile to parse inside Markdown and redundant with the bare-header rule. | MAY become an OPTIONAL editor-robustness alias in a later version; never normative in v0.1. |
| In-block YAML metadata | `verify: …` as a YAML key inside a block | Metadata-as-YAML splits one obligation across two syntaxes and breaks line-grouping; clauses are inline keyword lines instead. | Rejected; metadata is expressed as surface clauses (§6.8). |
| Significant indentation (Indent/Dedent) | indentation level encoding block nesting | Markdown renderers collapse and reflow indentation, so indentation cannot carry meaning. | Rejected; structure is carried by the line-grouping rule (§5.3). |

> Rationale (Q1.1): `:::`+in-block YAML is malformed in source and fragile to parse; significant indentation is destroyed by Markdown rendering. Indentation that *does* appear (e.g. bullet continuation under `ERRORS:`) is decorative continuation, not semantic nesting.

### 5.5 Keywords, case, and prose

SOL keywords are **UPPERCASE and case-sensitive**. The keyword set is closed (block types §5.2, modals §5.6, clause keywords per block in §6). A token that is not an uppercase keyword in keyword position is treated as one of:

- **prose** — free APS-controlled text (§7) outside any block, or
- **opaque condition text** — the lowercase text following a condition keyword (`WHERE`/`WHILE`/`WHEN`/`IF`) or forming an actor/response.

Lowercase `must`, `should`, `may`, `can`, `will` are **plain prose** and carry no normative force. Only the uppercase modals (§5.6) bind.

**Conditions are opaque text in v0.1.** The text after `WHEN`, `WHILE`, `WHERE`, or `IF` is captured verbatim as a string; SOL v0.1 defines no expression sublanguage, operators, or boolean structure over conditions. Example:

```sol
REQ AC-002:
WHILE the user is unauthenticated
WHEN the user opens `/settings`
THE client MUST redirect to `/login`
VERIFY BY test:cmdTest:unauthenticated-settings-redirect
```

`the user is unauthenticated` and ``the user opens `/settings` `` are opaque strings; a tool MUST NOT attempt to evaluate them.

> Rationale (Q1.7): the expression sublanguage is DEFERRED to v0.2. Treating conditions as opaque keeps v0.1 parseable without committing to semantics that timing/expression work (§35) will define.

### 5.6 The modal set

SOL v0.1 defines exactly **five modals**, uppercase only:

| Modal | Force |
|---|---|
| `MUST` | Required; non-satisfaction is non-compliance. |
| `MUST NOT` | Forbidden. |
| `SHOULD` | Strong default; non-satisfaction REQUIRES a same-block `BECAUSE` or `EXCEPT`. |
| `SHOULD NOT` | Strong prohibition; REQUIRES a same-block `BECAUSE` or `EXCEPT`. |
| `MAY` | Optional; carries no obligation. |

`SHALL` and `SHALL NOT` are **REMOVED** from SOL: RFC 8174 makes `MUST` ≡ `SHALL`, so `SHALL` is redundant, and courts/plain-language standards read "shall" inconsistently. A parser MUST reject `SHALL`/`SHALL NOT` as modals (lint: invalid modal).

`CAN` and `WILL` are **non-modal** (capability and prediction, respectively) and are **forbidden in binding clauses**; their use where a modal is expected is a `SOL-P003` warning (informal/missing modality).

`SHOULD` and `SHOULD NOT` without an accompanying `BECAUSE` or `EXCEPT` in the same block is a defect (`SOL-P003`-family; grammar-level `SOL-S006`).

```sol
REQ AC-010:
WHEN a request lacks a correlation id
THE gateway SHOULD generate one
BECAUSE downstream tracing requires a stable id per request
VERIFY BY test:cmdTest:gateway-correlation-id
```

> Rationale (Q1.4): MUST/MUST NOT/SHOULD/SHOULD NOT/MAY are the RFC 2119/8174 force-bearing words; `SHALL` is redundant; `CAN`/`WILL` carry no force and invite ambiguity.

### 5.7 The ID convention

Each block carries a **per-type short id** of the form `PREFIX-NNN`, where the prefix is fixed by block type:

| Block type | ID prefix | Example |
|---|---|---|
| `REQ` | `AC-` | `AC-001` |
| `CONSTRAINT` | `C-` | `C-001` |
| `INVARIANT` | `I-` | `I-001` |
| `INTERFACE` | `IF-` | `IF-001` |
| `QUESTION` | `Q-` | `Q-001` |
| `TRACE` | `T-` | `T-001` |
| `VERDICT` | — (reuses the judged obligation's id) | `VERDICT AC-001:` |

`NNN` is one or more decimal digits. A prefix that does not match its block type is a `SOL-S005` error (prefix↔type mismatch). IDs MUST be unique within a single `*.swarm.md` spec (an intra-spec duplicate is `SOL-S004`; a cross-spec collision is `SOL-M001`).

A **cross-spec reference** qualifies the id with the source spec id: `spec-id:AC-001`. Example: a TRACE in one spec referencing an obligation in `auth-refresh`:

```sol
TRACE T-003:
IMPLEMENTS auth-refresh:AC-001
CHANGED src/auth/client.ts
PROOF test:cmdTest:auth-refresh-expired-token passed
```

Dotted / namespaced ids (`REQ.auth-refresh.AC-001`) are **IR-only** (§12); they MUST NOT appear at the surface. The single-spec-prefix form `CO-NNN` is rejected at the surface.

> Rationale (Q1.5): per-type prefixes give stable, opaque traceability keys decoupled from text; the dotted form belongs to the IR namespace.

### 5.8 Frontmatter

Every `*.swarm.md` source spec MUST begin with a YAML frontmatter block. The version fields are normalized (G10) as:

| Field | Form | Meaning |
|---|---|---|
| `swarm_language` | `SOL/0.1` | The SOL language discriminator (the "which grammar/blocks/modals/lint-codes" axis, §25). MUST be present. |
| `aps_version` | `0.1` | The APS prose-standard version (§7). MUST be present. |
| `spec_version` | `0.1.0` | The spec *content* version (semver of this document's intent). MUST be present. |
| `title` | string | Human title. |
| `status` | `draft \| approved \| superseded` | Lifecycle status of the spec. |
| `owners` | list | Accountable owners. |
| `imports` | list of spec ids | Specs whose obligations this spec may reference cross-spec (§5.7). |

```sol
---
swarm_language: SOL/0.1
aps_version: 0.1
spec_version: 0.1.0
title: Auth refresh
status: draft
owners: [auth-team]
imports: [session-core]
---

# Spec: Auth refresh
```

> Rationale (Q9.30/G10): three distinct version axes MUST never be merged — `swarm_language` is the language discriminator, `spec_version` is content, and (when a tool exists) `provenance.compiler_version` is the tool version. The frontmatter carries the first two; the IR echoes all three (§12).

### 5.9 Interleaving SOL and prose

SOL blocks and APS prose coexist in one `*.swarm.md`. Prose is **commentary**; a typed obligation block is **binding** (G2): a span is *binding* iff it lies inside a `REQ`, `CONSTRAINT`, or `INVARIANT` block, and *commentary* otherwise. This boundary governs which lint codes apply (a high-risk word is blocking in a binding clause, advisory in commentary — §7, §8). Load-bearing meaning (modality, actor, trigger, verification binding) MUST live in SOL blocks, never in surrounding prose.

---

## 6. SOL block-type reference

SOL v0.1 defines exactly **seven block types**. Three carry **binding force** (they are *obligation blocks*): `REQ`, `CONSTRAINT`, `INVARIANT`. The remaining four declare boundaries (`INTERFACE`), mark ambiguity (`QUESTION`), claim implementation (`TRACE`), or judge an obligation (`VERDICT`). `TASK-MAP`, `FINDING`, and `ADR` are **not** SOL block types — they are downstream artifacts (§21).

This section gives, per block: purpose; whether it binds; the clause grammar in canonical order; semantics; and at least one worked example. Clause keywords are uppercase and case-sensitive (§5.5). The trailing **metadata clauses** `DEPENDS ON`, `TOUCHES`, `WRITES`, `READS`, `AFFECTS`, and `RISK <low|medium|high|critical>` are available on obligation blocks (REQ/CONSTRAINT/INVARIANT) and feed orchestration (§18); they are space-separated uppercase at the surface and lower to snake_case edges/scalars in the IR (§12).

### 6.1 REQ — required behavior

**Purpose.** A `REQ` declares a required behavior: under stated conditions, an actor must produce an observable response. **Binding: yes** (obligation block).

**Clause grammar (canonical order).** Clauses MUST appear in this order; bracketed clauses are optional:

```ebnf
req_block = "REQ" , ws , ac_id , ":" , nl ,
            [ "WHERE" , ws , cond , nl ] ,
            [ "WHILE" , ws , cond , nl ] ,
            [ "WHEN"  , ws , cond , nl ] ,
            [ "IF" , ws , cond , [ ws , "THEN" ] , nl ] ,
            actor_clause , { and_actor_clause } ,
            [ "BECAUSE" , ws , prose , nl ] ,
            [ "EXCEPT"  , ws , prose , nl ] ,
            verify_line ,
            { metadata_clause } ;
actor_clause     = "THE" , ws , actor , ws , modal , ws , response , nl ;
and_actor_clause = "AND" , ws , "THE" , ws , actor , ws , modal , ws , response , nl ;
verify_line      = "VERIFY BY" , ws , verify_ref , nl ;
metadata_clause  = depends_on | touches | writes | reads | affects | risk ;
```

Notes on the order and keywords:

- `WHERE` (optional ubiquitous context) → `WHILE` (state/precondition) → `WHEN` (trigger/event) → `IF` (fault/error condition). These four are the EARS condition keywords; their text is opaque (§5.5).
- **`THEN` is optional sugar after `IF` only** (the EARS unwanted-behavior pattern). It MUST NOT appear after `WHEN`, `WHILE`, or `WHERE`. `IF … THEN …` and `IF … <newline> THE …` are equivalent.
- `THE <actor> <MODAL> <response>` is the mandatory consequence. A condition keyword with no following actor clause is `SOL-S001` (dangling condition); an actor clause with no modal is `SOL-S003`.
- **`AND THE` chaining is permitted.** Each `AND THE …` adds a second consequence; on lowering, each `THE …`/`AND THE …` becomes a **separate IR obligation** (§11). More than two chained consequences emits a **warning** (`SOL-P004`-adjacent, atomize suggested), never a hard error (G3).
- `BECAUSE` (rationale) and `EXCEPT` (exception) are optional, but one of them is REQUIRED whenever any consequence uses `SHOULD`/`SHOULD NOT` (§5.6).
- `VERIFY BY` is REQUIRED for a binding REQ; its absence is `SOL-V001`. The reference grammar is `<type>:<adapter>:<artifact>[#selector]` (§15).

**Worked example — multi-consequence with trigger:**

```sol
REQ AC-001:
WHEN the user submits the signup form
AND the email field is empty
THE client MUST show "Email is required"
AND THE client MUST NOT send a signup request
VERIFY BY test:cmdTest:signup-empty-email
DEPENDS ON AC-000
WRITES src/signup/**
RISK medium
```

This lowers to two IR obligations (one per `THE`/`AND THE`), both carrying the same `WHEN … AND …` conditions and the same `verify_by`. `the email field is empty` is opaque condition text appended to the `WHEN` trigger.

**Worked example — `IF … THEN` unwanted-behavior:**

```sol
REQ AC-003:
IF the payment provider times out THEN
THE server MUST NOT create an order
AND THE server MUST record a retryable payment attempt
VERIFY BY test:cmdTest:payment-timeout
```

### 6.2 CONSTRAINT — restriction on the solution space

**Purpose.** A `CONSTRAINT` restricts *how* obligations may be satisfied — it bounds the solution space rather than requesting a behavior. **Binding: yes** (obligation block).

There is no separate `POLICY` block type. Authority and enforcement attributes of a constraint are **metadata** (e.g. `OWNED BY` on the surface, `authority` in the IR), not a distinct block type.

**Clause grammar (canonical order).**

```ebnf
constraint_block = "CONSTRAINT" , ws , c_id , ":" , nl ,
                   [ "WHERE" , ws , cond , nl ] ,
                   actor_clause , { and_actor_clause } ,
                   [ "BECAUSE" , ws , prose , nl ] ,
                   [ "EXCEPT" , ws , prose , nl ] ,
                   verify_line ,
                   { metadata_clause } ;
```

**Semantics.** A CONSTRAINT identifies the actor/surface being constrained and the forbidden or required limit, using a modal (typically `MUST NOT`). It is not a behavior request; it persists across tasks as a guard. A CONSTRAINT MUST carry a `VERIFY BY` binding (a static check, a contract, or `manual:` review); its absence is `SOL-V001`.

**Worked example:**

```sol
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
BECAUSE the client bundle must not embed server-only secrets
VERIFY BY static:cmdLint:dependency-boundary-check
AFFECTS src/auth/**
```

### 6.3 INVARIANT — always-held property

**Purpose.** An `INVARIANT` declares a property that MUST hold at all times, not a one-time behavior. **Binding: yes** (obligation block).

**Clause grammar (canonical order).**

```ebnf
invariant_block = "INVARIANT" , ws , i_id , ":" , nl ,
                  property , ws , ( "MUST" | "MUST NOT" ) , ws , predicate , nl ,
                  [ "BECAUSE" , ws , prose , nl ] ,
                  verify_line ,
                  { metadata_clause } ;
```

**Semantics.** The invariant body is `<property> MUST|MUST NOT <hold>`. The words `ALWAYS` and `NEVER` are **removed** (redundant with the always-held semantics of the block; ASD-STE100 one-word-one-meaning); an author MUST NOT write `ALWAYS`/`NEVER`. An INVARIANT MUST NOT describe a one-time triggered behavior (that is a `REQ`).

An INVARIANT **PREFERS** a `property`, `model`, or `static` proof, because those proof types can assert a property over all states. Binding an INVARIANT *only* to a non-observable unit `test` is a **`SOL-V` warning** (a single example execution does not establish an always-held property) — see §15 for the proof taxonomy and §16 for why a once-green test is not perpetually valid.

**Worked example:**

```sol
INVARIANT I-001:
A user MUST NOT have more than one active refresh token family
VERIFY BY property:cmdTest:token-family-invariant
```

> Rationale (Theme-5 gap-fill): proof strength `model > property/contract > test > static > manual/monitor` (§15) is why an INVARIANT prefers the upper end; a bare unit test understates the obligation.

### 6.4 INTERFACE — declared boundary

**Purpose.** An `INTERFACE` names a boundary, API, function, schema, command, module, or contract. It declares the surface other obligations reference. **Binding: no** (it declares boundaries; it does not by itself command behavior), but it **REQUIRES a verification binding** (see below).

**Clause grammar (canonical order).**

```ebnf
interface_block = "INTERFACE" , ws , if_id , ":" , nl ,
                  signature , ws , "RETURNS" , ws , return_type , nl ,
                  [ "ACCEPTS" , ":" , nl , bullet_list ] ,
                  [ "ERRORS"  , ":" , nl , bullet_list ] ,
                  [ "OWNED BY" , ws , owner , nl ] ,
                  verify_line ;
bullet_list = { ws , "-" , ws , item , nl } ;
```

`ACCEPTS:` and `ERRORS:` introduce contiguous bullet continuation lines (not blank-separated — a blank line would close the body, §5.3). `OWNED BY` records the owning surface/team/module.

**Semantics and the required contract binding.** An INTERFACE **MUST carry a `VERIFY BY contract:` binding** — a `contract`-type proof asserting that the named boundary's shape (signature, accepted inputs, returned type, declared errors) matches reality. Omitting it is `SOL-V001`. This resolves the Theme-1 INTERFACE-verification gap: an undeclared interface referenced by an obligation is `SOL-M004`, and a declared interface with no `contract` binding is unverifiable.

**Worked example:**

```sol
INTERFACE IF-001:
`refreshSession()` RETURNS `Session | AuthExpired`
ACCEPTS:
  - `refreshToken: string`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
VERIFY BY contract:cmdContract:refresh-session-contract
```

### 6.5 QUESTION — marked ambiguity

**Purpose.** A `QUESTION` records an explicit unresolved ambiguity. **Binding: no.**

**Clause grammar (canonical order).** The blocking tag appears in the header, before the colon:

```ebnf
question_block = "QUESTION" , ws , q_id , ws , blocking_tag , ":" , nl ,
                 question_text , nl ,
                 "AFFECTS" , ws , affects_ref , nl ;
blocking_tag = "[blocking]" | "[non-blocking]" ;
```

The `[blocking|non-blocking]` tag is REQUIRED. `AFFECTS` names the obligation ids or surfaces the answer would change.

**Semantics.** A **blocking** QUESTION prevents lowering of any obligation it `AFFECTS`. A blocking QUESTION that reaches the lower pass (§11) is an **orchestration error** (`SOL-O`-class): it means an unresolved decision is being compiled into tasks. A **non-blocking** QUESTION may remain open if it does not affect assigned obligations. Behavioral uncertainty MUST be lifted into a QUESTION rather than left as hedged prose (`SOL-P008`).

**Worked example:**

```sol
QUESTION Q-001 [blocking]:
Should expired sessions redirect to `/login` or show an inline re-auth modal?
AFFECTS AC-001
```

### 6.6 TRACE — implementation claim

**Purpose.** A `TRACE` records a claim that obligations were implemented, naming the changed surfaces and the proofs run. **Binding: no** (it claims; it is judged by VERDICT). A TRACE is the input to the review pass (§14).

**Clause grammar (canonical order).**

```ebnf
trace_block = "TRACE" , ws , t_id , ":" , nl ,
              "IMPLEMENTS" , ws , id_list , nl ,
              [ "PRESERVES" , ws , id_list , nl ] ,
              "CHANGED" , ws , path_list , nl ,
              { "PROOF" , ws , proof_claim , nl } ;
```

**Semantics.** `IMPLEMENTS` lists the REQ ids the change satisfies; `PRESERVES` lists the CONSTRAINT/INVARIANT ids the change must not violate; `CHANGED` names the modified surfaces (the basis for staleness detection, §16); each `PROOF` line names a verification reference and its observed result. A TRACE referencing an unknown obligation is `SOL-S009`; a TRACE that claims implementation with no `PROOF` is `SOL-M007`. A `PROOF` line MUST reference real output — an unqualified "tests passed" is not an admissible proof (§15, §17).

**Worked example:**

```sol
TRACE T-001:
IMPLEMENTS AC-001, AC-002
PRESERVES C-001
CHANGED src/auth/client.ts, src/auth/session-store.ts
PROOF test:cmdTest:auth-refresh-expired-token passed
PROOF test:cmdTest:auth-refresh-no-loop passed
PROOF static:cmdLint:dependency-boundary-check passed
```

### 6.7 VERDICT — judgment of an obligation

**Purpose.** A `VERDICT` records the review judgment of one obligation. **Binding: no.** A VERDICT **reuses the judged obligation's id** (it does not mint a new id); its container is `review.md` (§21) — there is no `verdict.md`.

**Clause grammar (canonical order).**

```ebnf
verdict_block = "VERDICT" , ws , judged_id , ":" , ws , core_value ,
                [ ws , "(" , lifecycle , " by " , authority , ": " , reason_txt , ")" ] , nl ,
                [ "REASON" , ws , prose , nl ] ,
                [ "EVIDENCE" , ws , reference , nl ] ;
core_value = "PASS" | "FAIL" | "BLOCKED" | "UNVERIFIED" ;
lifecycle  = "WAIVED" | "STALE" | "CONTRADICTED" ;
```

**Semantics.** A VERDICT carries exactly one **core** value plus an optional **lifecycle decorator** in parentheses (the full 7-value model and the merge gate are specified in §14). The four core values:

| Core | Meaning |
|---|---|
| `PASS` | A bound proof ran and succeeded; evidence satisfies the obligation. |
| `FAIL` | A bound proof ran and failed, or the diff contradicts the obligation. |
| `BLOCKED` | The proof could not run (prerequisite, tool, or environment missing). |
| `UNVERIFIED` | No acceptable proof was bound, or none was executed. |

A value outside the core four is a lint error (was `SOL-S010`, now `SOL-V`-family). The lifecycle decorators `WAIVED`, `STALE`, `CONTRADICTED` and their mandatory fields (authority/reason/expiry, etc.) are specified in §14 and §16. `REASON` gives the human justification; `EVIDENCE` references the inspected proof output.

**Worked example — plain PASS:**

```sol
VERDICT AC-001: PASS
REASON The branch clears the local session and redirects to `/login` when token expiry is simulated.
EVIDENCE test:cmdTest:auth-refresh-expired-token output in review log
```

**Worked example — waived FAIL (lifecycle decorator):**

```sol
VERDICT AC-002: FAIL (WAIVED by auth-team: flaky e2e env, expires 2026-07-01)
REASON The e2e proof could not be stabilized this cycle.
EVIDENCE test:cmdTest:auth-refresh-no-loop intermittent failure log
```

### 6.8 Metadata clauses (orchestration inputs)

The following clauses MAY trail any obligation block (REQ/CONSTRAINT/INVARIANT). They carry no behavioral force themselves; they feed orchestration and the safe-parallelism predicate (§18). Surface form is space-separated uppercase; IR form is snake_case (§12).

| Surface clause | Meaning | IR lowering |
|---|---|---|
| `DEPENDS ON <id-list>` | Hard ordering against other obligations. | `depends_on` edges |
| `TOUCHES <surface-list>` | Surfaces incidentally affected (weaker than `WRITES`). | `touches` scalar |
| `WRITES <surface-list>` | Write surfaces this obligation owns. | `writes` set / conflict edges |
| `READS <surface-list>` | Read set. | `reads` set |
| `AFFECTS <surface-or-id-list>` | Impact set (downstream effect). | `affects` edges |
| `RISK <low\|medium\|high\|critical>` | Risk tier. | `risk` scalar |

```sol
REQ AC-005:
WHEN a checkout completes
THE server MUST emit an `order.created` event
VERIFY BY test:cmdTest:order-created-event
DEPENDS ON AC-004
WRITES src/orders/**
READS src/catalog/**
AFFECTS analytics-pipeline
RISK high
```

A lock group is expressed as a named `SURFACE` (`SURFACE x = …`), never a `locks` primitive (§18); `WRITES`/`READS` over surfaces is the basis of write-disjointness analysis.


## 7. APS — Agent Prose Semantics (the controlled-prose standard)

APS (Agent Prose Semantics) is the controlled-prose standard that governs every word of natural-language prose that surrounds, introduces, or accompanies SOL blocks in a Swarm spec or working artifact. SOL (§5, §6) is the obligation language; APS is the standard for everything that is *not* a SOL block. This section defines APS normatively: its doctrine (§7.1), the binding-clause vs commentary boundary (§7.2), the high-risk word catalogue (§7.3), the "same line makes it observable" rule (§7.4), the mapping from APS rule families to `SOL-P` lint codes (§7.5), and the durable rationale that anchors the whole standard (§7.6).

### 7.1 Doctrine: prose is a non-authoritative delivery layer

> Decision record: Q-semantics-1, Q5.16, Q5.17.

#### 7.1.1 The authority rule (normative)

All **load-bearing meaning** in a Swarm repo — modality, actor, trigger/state, verification binding, authority order, conflict resolution, and trace schema — MUST live in SOL blocks (§6) and the typed IR (§12). Prose, skills (§26), personas (§27), and `AGENTS.md` (§31) are **non-authoritative delivery layers**: they carry context and guidance, never binding force.

A Swarm tool, author, or downstream agent MUST NOT treat any prose span as a source of an obligation, a verdict, a verification requirement, an authority ranking, or any other load-bearing fact. If a fact is load-bearing, it MUST be expressed as (or promoted into) a typed SOL block; until it is, it has no force.

*Rationale (terse):* prompt-format sensitivity (±40% on identical content), multi-turn reliability decay (≈−39%), and lost-in-the-middle / context-rot degradation (20–50%) make prose an unreliable carrier of meaning across turns and agents; only the typed surface and its IR are stable enough to bind on (see §7.6).

#### 7.1.2 The word-economy rule (normative)

Every word of Swarm prose SHOULD do at least one of the following jobs. A word that does none of them is prose noise and SHOULD be removed (advisory `SOL-P054`, see §8.4).

| Job | Meaning |
|---|---|
| constrain behavior | states or qualifies what something must do |
| clarify context | supplies the situation an obligation answers |
| define scope | bounds what is and is not in play |
| identify evidence | names how a claim is checked |
| bind traceability | links to a stable id (`AC-001`, `T-001`, a finding) |
| aid retrieval | a keyword a future agent will search for |
| mark uncertainty | flags a gap to be lifted to a `QUESTION` (§6) |
| explain rationale | records *why*, durably |

#### 7.1.3 Properties of conformant prose (normative)

Good Swarm prose is **concrete, observable, atomic, scoped, verifiable, traceable, non-decorative, and low-entropy**. An author MUST prefer observable verbs (`return`, `show`, `reject`, `record`, `persist`, `redirect`, `retry`, `deny`, `notify`, `log`, …) over vague action verbs (`handle`, `support`, `manage`, `improve`, `optimize`, `streamline`, `enhance`, `modernize`, `clean up`, `make robust`). A vague action verb in prose is governed by the high-risk word rules (§7.3, §7.4).

```text
Bad (decorative, vague verb, no observable behavior):
  Improve checkout so it handles failures gracefully.

Good (every clause observable; the load-bearing meaning is in SOL):
  REQ AC-001:
  IF the payment provider times out
  THEN THE server MUST NOT create an order
  AND THE server MUST record a retryable payment attempt
  AND THE client MUST show "Payment temporarily unavailable"
  VERIFY BY test:cmdTest:payment-timeout.test#no-order
```

### 7.2 The binding-clause vs commentary boundary (normative)

> Decision record: G2 (recommended resolution, confirmed normative here); Theme-2 residual gaps.

The force of every APS rule depends on **where** a prose span sits. The boundary is mechanical and parser-decidable:

- A span is **BINDING** if and only if it is inside a typed obligation block — `REQ`, `CONSTRAINT`, or `INVARIANT` (the three obligation block types that carry binding force, §4, §6).
- A span is **COMMENTARY** in every other position: ordinary Markdown prose; headings; `INTERFACE`, `QUESTION`, `TRACE`, and `VERDICT` block bodies; the `BECAUSE` rationale of an obligation; and any `## Context` section.

APS prose rules apply **with full force** (BLOCKING where the rule is blocking) inside BINDING spans, and **as advisories only** inside COMMENTARY spans. One consequence is pinned explicitly: a comparative or superlative without a baseline is BLOCKING (`SOL-P056` promoted) inside a binding clause and ADVISORY (`SOL-P056` default) in commentary.

*Rationale (terse):* commentary explains and may be loose; a binding clause *is* the obligation, so an unobservable word inside it directly changes what gets built (§8.2). The boundary is decidable from block type alone, so a future linter needs no heuristic to apply it.

```text
COMMENTARY (advisory only — "messy" is tolerated, it explains):
  ## Context
  The existing auth flow is messy and users see repeated failed refresh calls.

BINDING (full force — an unobservable word here is blocking SOL-P005):
  REQ AC-001:
  WHEN the session is expired
  THE client MUST redirect to `/login`
  VERIFY BY test:cmdTest:expired-session-redirect.test
```

### 7.3 The high-risk word catalogue (normative)

> Decision record: Q5.17 ("HIGH-RISK WORD list = union of brief's subjective/promotional list + Femmer loopholes & comparatives + Tjong/Berry quantifiers/connectives").

A **high-risk word** is a word or phrase that, used in a binding clause without a same-line observable criterion, leaves *what gets built* underdetermined. The catalogue below is the canonical union of three research vocabularies. It is **closed for v0.1** in the sense that these families are the lint-checked set; a project MAY extend its own list via configuration (§8.6), but MUST NOT shrink the kernel set.

| Family | High-risk words / phrases (non-exhaustive within family) | Source | Default lint |
|---|---|---|---|
| Subjective / promotional | `robust`, `clean`, `simple`, `intuitive`, `user-friendly`, `easy to use`, `modern`, `seamless`, `flexible`, `elegant`, `beautiful`, `polished`, `nice`, `flamboyant`, `innovative`, `world-class`, `correct`, `appropriate`, `proper`, `reasonable` | brief §8.2 + Femmer subjective | `SOL-P005` |
| Non-verifiable quality | `fast`, `performant`, `scalable`, `secure`, `safe`, `reliable`, `consistent`, `graceful`, `sufficient`, `adequate` | brief §8.2 + Femmer open-ended | `SOL-P005` |
| Vague action verbs | `handle`, `support`, `manage`, `improve`, `optimize`, `enhance`, `streamline`, `modernize`, `clean up`, `make robust` | brief §8.3 | `SOL-P005` |
| Loopholes | `as far as possible`, `if practical`, `where feasible`, `if possible`, `to the extent practicable` | Femmer loopholes | `SOL-P005` |
| Ambiguous qualifiers | `significant`, `minimal`, `almost always`, `as needed`, `where appropriate` | Femmer / Tjong | `SOL-P005` |
| Comparatives / superlatives | `better`, `faster`, `more efficient`, `higher`, `best`, `highest`, `most`, `optimal` | Femmer comparatives | `SOL-P056` (blocking in binding clause) |
| Quantifiers (ambiguous scope) | `all`, `any`, `every`, `some`, `each`, plural nouns used as the actor | Tjong / Berry | `SOL-P005` (scope) |
| Connectives (ambiguous bundling) | `and`, `or`, `and/or`, `but`, `also` joining separable obligations | Tjong / Berry | `SOL-P004` (bundling) |
| Ambiguous exceptions | `unless`, `except where` (without a positive reformulation) | Berry | `SOL-P005` / prefer `IF`/`WHEN` |
| Vague references | `it`, `they`, `this`, `that`, `the above`, `the previous one`, `this thing` (no unique antecedent) | Femmer pronouns | `SOL-P050` (advisory) / `SOL-P002` (if it hides the actor) |

A bare `MUST NOT` prohibition with no paired affirmative behavior is a related negation hazard (`SOL-P007`, §8.3): the author MUST state what the actor does instead, because negated instructions are a documented model-inversion risk (§7.6).

### 7.4 The "same line makes it observable" rule (normative)

> Decision record: Q5.17 ("adopted verbatim"); G2.

A high-risk word (§7.3) appearing in a **binding** clause is permitted **if and only if** the same sentence, the same bullet, or the immediately-following line converts it into observable behavior by supplying at least one of:

1. an **actor + action + object** triple (who does what to what), or
2. a **measurable threshold** (a number, bound, rate, or comparison with units), or
3. a **named verification target** (a `VERIFY BY` binding, §15, or a named test/contract/metric).

If none of these is present on the same line, the word is a **blocking `SOL-P005`** (or `SOL-P056` for an unbaselined comparative, or `SOL-P004` for a bundling connective).

The repair MUST be a **named improve operation** (§10) — `CONCRETIZE` (replace the vague word with observable behavior) or `QUANTIFY` (replace an unbounded quality with a threshold) — with an explicit exit condition. An author or tool MUST NOT resolve `SOL-P005` by open-ended stylistic rewriting; the defect is a missing observable criterion, and only `CONCRETIZE`/`QUANTIFY` close it.

```text
Blocking (high-risk "fast" in a binding clause, no same-line criterion):
  REQ AC-002:
  THE search endpoint MUST be fast        -> SOL-P005 (blocking)

Permitted via QUANTIFY (same-line measurable threshold):
  REQ AC-002:
  WHEN the index holds <= 1,000,000 rows
  THE search endpoint MUST return results within a 200 ms p95 latency
  VERIFY BY perf:cmdBenchmark:search-latency.bench#p95
```

### 7.5 APS rule families mapped to `SOL-P` codes (normative)

Every APS rule family resolves to exactly one prose-layer lint code in the unified taxonomy (§8). `APS-` codes are retired (§8.5); the mapping below is canonical and supersedes the brief's §8.8 `APS-*` table. Full definitions live in §8.2–§8.4; the legacy translation table lives in Appendix B.

| APS rule family | `SOL-P` code | Severity | Repair op (§10) |
|---|---|---|---|
| Dangling condition (trigger, no modal consequence) | `SOL-P001` | BLOCKING | author rewrite / `NORMALIZE` |
| Missing actor | `SOL-P002` | BLOCKING | `CONCRETIZE` |
| Missing / informal modality (`should`→`SHOULD`) | `SOL-P003` | BLOCKING | `NORMALIZE` |
| Bundled / overloaded obligation (connectives) | `SOL-P004` | BLOCKING | `ATOMIZE` |
| Vague-quality word, no same-line observable | `SOL-P005` | BLOCKING | `CONCRETIZE` / `QUANTIFY` |
| Undefined term in a binding clause | `SOL-P006` | BLOCKING | `CLARIFY` / `BIND` (glossary) |
| Negation ambiguity (bare `MUST NOT`) | `SOL-P007` | BLOCKING | `CLARIFY` (pair affirmative) |
| Uncaptured behavioral uncertainty not lifted to `QUESTION` | `SOL-P008` | BLOCKING | `CLARIFY` |
| Pronoun / vague reference | `SOL-P050` | ADVISORY | `CONCRETIZE` |
| Passive voice | `SOL-P051` | ADVISORY | `NORMALIZE` |
| Sentence length (> ~20 words) | `SOL-P052` | ADVISORY | `ATOMIZE` / `COMPRESS` |
| Non-present / non-active tense | `SOL-P053` | ADVISORY | `NORMALIZE` |
| Prose noise (decorative phrase) | `SOL-P054` | ADVISORY | `COMPRESS` |
| Redundancy (repeated context, no new constraint) | `SOL-P055` | ADVISORY | `COMPRESS` |
| Comparative / superlative without baseline | `SOL-P056` | ADVISORY in commentary, **BLOCKING in a binding clause** | `QUANTIFY` |

Cross-layer companions an APS reviewer commonly meets (defined in §8): `SOL-M001` actor/object incompleteness, `SOL-M002` contradiction, `SOL-V001` no verification path.

### 7.6 Rationale anchor (normative framing) and the superseded figure

> Decision record: Q-density-1, Q-semantics-1, Theme-3 currency note.

APS exists because of a **durable mechanism**, not a transient capability ceiling. Specifications, refs, and ADRs that justify APS MUST anchor on the following four properties, and MUST NOT anchor on any dated model-accuracy number:

1. **Format sensitivity** — identical content reformatted can change model output by up to ±40%; controlled, predictable prose shape reduces this variance.
2. **Multi-turn decay** — reliability drops ≈39% across multi-turn generation as early loose assumptions compound; stable artifacts beat accumulating chat.
3. **Context rot / lost-in-the-middle** — relevant content buried in long inputs is used 20–50% less reliably; low-entropy prose keeps the load-bearing signal legible.
4. **Minimize always-on density to protect adherence and control cost** — every always-loaded normative line competes for adherence and is paid for on every turn; APS removes non-load-bearing words so the surviving instructions are followed and cheap.

**Superseded figure (MUST NOT cite as a ceiling).** The IFScale "68% accuracy at 500 instructions" figure MUST NOT be cited as a capability ceiling or as the justification for APS density limits. It is superseded by a 2026 re-run (≈99% at 5,000 instructions, inflection ≈2,000). Any numeric capability claim that survives MUST carry an "evidence as of <date>" caveat. The density discipline rests on adherence-and-cost economics (#4), not on a claim that models cannot follow many instructions.

---

## 8. The unified lint taxonomy (SOL-<LAYER><NNN>)

> Decision record: X1 (global namespace), Q5.16, Q5.17, G1.

### 8.1 Namespace, layers, and the diagnostic record

#### 8.1.1 One prefix, five layers (normative)

Every Swarm diagnostic code MUST use the single namespace `SOL-<LAYER><NNN>`: the literal prefix `SOL`, a hyphen, one uppercase **layer letter**, and a three-digit number. There are exactly five layers, each mirroring a compiler pass 1:1 (§9), and each a **100-block** (codes numbered within `001`–`099`, `100`–`199`, … per layer), **append-only with tombstoning**: a retired code is marked tombstoned in the catalogue (Appendix B) and its number is never reused.

| Layer | Letter | Domain | Mirrors pass / phase | Block range |
|---|---|---|---|---|
| SYNTAX | `S` | Parser-detectable well-formedness | `lint` / `PARSE` | `SOL-S001…` |
| PROSE | `P` | Controlled-prose / requirement-smell, single-obligation-local (the former APS layer; absorbs old `SOL-L`) | `lint` / `NORMALIZE` | `SOL-P001…` |
| SEMANTIC | `M` | Cross-reference: duplicate id, contradiction, unbound ref | `improve` / `NORMALIZE` | `SOL-M001…` |
| VERIFICATION | `V` | Proof-binding: missing / stale / non-observable proof | `verify` / `VERIFY` | `SOL-V001…` |
| ORCHESTRATION | `O` | Planning / parallelism: write-conflict, dep cycle, blocking `QUESTION` reaching lowering | `decompose` / `LOWER` | `SOL-O301…` |

*Rationale (terse):* one tool, one greppable namespace; layers partition along the ISO 29148 characteristic families and map 1:1 to passes, so a code's letter tells you which pass raised it and which guide repairs it.

#### 8.1.2 The diagnostic record shape (normative)

Every emitted diagnostic MUST be the object `{ code, severity, layer, span, message, suggest }`. This is the surface contract; the IR carries the same data SARIF-shaped in `diagnostics[]` (§12), with `code` identical across both.

| Field | Type | Meaning |
|---|---|---|
| `code` | string | A `SOL-<LAYER><NNN>` code from this taxonomy / Appendix B |
| `severity` | enum | `error` (blocking) \| `warning` (advisory) \| `off` (after a recorded waiver, §8.6) |
| `layer` | enum | `S` \| `P` \| `M` \| `V` \| `O` (redundant with `code`'s letter; explicit for filtering) |
| `span` | object | Source location: `{ file, line_start, line_end }`, or a node id (`AC-001`) |
| `message` | string | One-line human-readable defect statement |
| `suggest` | string \| null | The named repair: an improve op (§10) or a concrete fix; `null` if none |

```json
{
  "code": "SOL-P005",
  "severity": "error",
  "layer": "P",
  "span": { "file": "auth-refresh.swarm.md", "line_start": 22, "line_end": 22 },
  "message": "Vague-quality word 'gracefully' in a binding clause with no same-line observable criterion.",
  "suggest": "CONCRETIZE: replace with actor+action+object, or bind a VERIFY BY target."
}
```

### 8.2 BLOCKING vs ADVISORY (normative)

A rule is **BLOCKING** if and only if its defect changes **what gets built** — the obligation is incomplete, non-binding, untestable, ambiguous, contradictory, or unsafe to parallelize. A blocking diagnostic carries `severity: error`, and the merge gate (§14) MUST NOT pass an artifact while any blocking diagnostic is unresolved (unless waived, §8.6).

A rule is **ADVISORY** if and only if its defect affects only **how it reads** — style, length, voice, redundancy — without changing the built behavior. An advisory diagnostic carries `severity: warning` and does not block on its own.

The binding-clause vs commentary boundary (§7.2) re-classifies position-sensitive codes: `SOL-P056` (comparative without baseline) is BLOCKING inside an obligation block and ADVISORY in commentary; the high-risk word rules of §7.3–§7.4 are BLOCKING only inside binding clauses.

### 8.3 Principal BLOCKING codes (inline)

The codes below are the canonical blocking set. One-line definitions follow; the full catalogue is Appendix B.

**S layer — well-formedness:**

| Code | Defect |
|---|---|
| `SOL-S001` | Precondition (`WHEN`/`IF`/`WHILE`) with no actor clause / no modal consequence (dangling condition). |
| `SOL-S003` | Actor clause (`THE <actor> …`) with no modal verb. |
| `SOL-S005` | ID prefix does not match block type (e.g. `REQ C-001:`). |
| `SOL-S006` | `SHOULD` / `SHOULD NOT` used without an accompanying `BECAUSE` or `EXCEPT`. |

**P layer — controlled prose (the blocking set `SOL-P001`–`SOL-P008`):**

| Code | Defect |
|---|---|
| `SOL-P001` | Dangling condition: trigger present, no modal consequence (prose-layer companion of `SOL-S001`). |
| `SOL-P002` | Missing actor: an action with no `THE <actor>` subject. |
| `SOL-P003` | Missing / informal modality (e.g. lowercase `should` where a binding modal is intended). |
| `SOL-P004` | Bundled / overloaded obligation: separable obligations joined by `and`/`or`/`and/or` in one clause. |
| `SOL-P005` | Vague-quality / high-risk word in a binding clause with no same-line observable criterion (§7.3–§7.4). |
| `SOL-P006` | Undefined term used in a binding clause (no `TERM` / `memory/glossary.md` definition). |
| `SOL-P007` | Negation ambiguity: bare `MUST NOT` not paired with the affirmative behavior that should happen instead. |
| `SOL-P008` | Uncaptured behavioral uncertainty: an ambiguity stated in prose that should be lifted to a `QUESTION` block. |

**M layer — semantic:**

| Code | Defect |
|---|---|
| `SOL-M001` | Actor / object incompleteness: the obligation names a modal but not a resolvable actor *and* object. |
| `SOL-M002` | Contradiction: two obligations bind opposite outcomes to the same trigger/state, or trace/code disagrees with an obligation. |

**V layer — verification:**

| Code | Defect |
|---|---|
| `SOL-V001` | Missing verification path: a binding obligation (`REQ`/`CONSTRAINT`/`INVARIANT`) with no `VERIFY BY` (§15). |

**O layer — orchestration:**

| Code | Defect |
|---|---|
| `SOL-O301` | Write-conflict marked parallel: two work packets sharing a write surface scheduled to run in parallel (§18). |
| `SOL-O305` | Owned path outside declared write surface: a `task-orchestration.md` owned path not a subset of the assigned obligations' `WRITES` (§18, §19). |

### 8.4 Principal ADVISORY codes (inline)

The advisory prose set is `SOL-P050`–`SOL-P056`. They emit `warning` and never block on their own (subject to strict mode, §8.6).

| Code | Defect (style only) |
|---|---|
| `SOL-P050` | Pronoun / vague reference without a unique antecedent. |
| `SOL-P051` | Passive voice where an active actor+action is clearer. |
| `SOL-P052` | Sentence length exceeds ~20 words. |
| `SOL-P053` | Non-present or non-active tense. |
| `SOL-P054` | Prose noise: a decorative phrase that adds no constraint, context, or evidence. |
| `SOL-P055` | Redundancy: repeated context that adds no new constraint. |
| `SOL-P056` | Comparative / superlative without a baseline — **advisory in commentary, blocking in a binding clause** (§7.2). |

### 8.5 `APS-` retirement and the full catalogue

`APS-` is **retired as a code prefix.** "APS" survives only as the *name* of the prose standard (§7); it MUST NOT appear in any diagnostic code. Every legacy `APS-*` code, every flat `sol.md` code (`SOL101`/`SOL201`/`SOL301`), and every `swarm-sol.md SOL-L###` code is remapped into the `SOL-<LAYER><NNN>` namespace. The complete per-layer catalogue and the full legacy translation table (e.g. `APS-A001→SOL-P005`, `APS-O001→SOL-P004`, `APS-P001→SOL-P054`, `APS-R001→SOL-P055`, `APS-Q001→SOL-P008`, `APS-V001→SOL-V001`, `APS-X001→SOL-M002`, `SOL-L###→SOL-P###`) live in **Appendix B**. Tools and authors MUST cite only the unified codes; the legacy codes are non-normative aliases retained for migration only.

### 8.6 Severity override and the waiver record (normative)

> Decision record: G1 (judgment call: schema + waiver-recording format).

Default severities (§8.2–§8.4) are fixed by this specification. A project MAY adjust them only through a single configuration file, `swarm.config.json` (or `swarm.config.yaml`), validated against the schema below. There are exactly two legal adjustments:

1. **Promote (strict mode):** raise an ADVISORY code to `error`. Always permitted; no record required beyond the config entry.
2. **Demote (waiver):** lower a BLOCKING code to `warning` or `off`. Permitted **only** with a recorded waiver carrying an authority, a reason, and an expiry. A demotion without a complete waiver record is itself a conformance defect.

A `swarm.config` MUST NOT redefine, rename, or invent codes; it MUST NOT change a code's `layer`; and it MUST NOT demote a blocker by any means other than a waiver record.

```json
{
  "$schema": "swarm.config/0.1",
  "language": "SOL/0.1",
  "severity_overrides": {
    "SOL-P052": "error",        // strict: promote advisory -> error
    "SOL-P056": "error"
  },
  "waivers": [
    {
      "code": "SOL-V001",
      "scope": "AC-014",                 // code OR a specific obligation id / glob
      "to": "warning",                   // warning | off
      "authority": "spec-owner:j.costa", // human or spec owner (see §14 / G5)
      "reason": "Upstream metrics adapter not yet wired; manual check tracked in TASK-22.",
      "expiry": "2026-07-01",            // ISO date; auto-expires (see below)
      "recorded_at": "2026-05-31"
    }
  ]
}
```

The **waiver-record fields** are: `code` (required), `scope` (required — a code applies repo-wide; an obligation id/glob narrows it), `to` (required, `warning` or `off`), `authority` (required), `reason` (required), `expiry` (required, ISO date), `recorded_at` (required). A waiver with any required field missing is invalid and the demotion does not take effect. Consistent with the verdict model (§14) and G5, a waiver **auto-expires** at its `expiry` date *and* on the next change to the waived obligation's source content-hash (whichever comes first), preventing zombie waivers; on expiry the code returns to its default severity. A severity demotion at the lint layer is distinct from a `WAIVED` verdict at the verification layer (§14): the former silences a *diagnostic*, the latter accepts a *failing proof* — both require the same authority+reason+expiry discipline.

*Rationale (terse):* one config, two legal moves — strict-up freely, blocking-down only on the record — keeps every relaxation of the kernel's defaults auditable, time-boxed, and attributable.


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
| `decompose` | `LOWER` | `*.swarm.ir.json` | `task.md` work packets (and, named-as-contract, `*.swarm.plan.json`) | Partitions the obligation graph into task-sized, write-disjoint work packets with assigned obligations, write surfaces, and verification bindings (§11). | Lead Engineer | `SOL-O###` (scope/ownership, e.g. `SOL-O305`) |
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

## 11. Lowering and decomposition

`LOWER` is the phase that turns a normalized, approved spec into machine-shaped work. Two passes occupy it: `lower` (SOL surface → IR obligation graph) and `decompose` (IR → task-sized work packets). They are separate passes because they have different inputs, different outputs, and different failure modes; conflating them would mix graph construction with work partitioning.

Throughout `LOWER`, the **distillation-loss discipline** (§24) is in force: lowering MUST preserve every obligation, every modality, actor, trigger, and response, every constraint and invariant, every verification binding, and the authority of each obligation (§22). Dropping any of these is a distillation error, not an optimization.

### 11.1 The `lower` pass

`lower` consumes an approved `spec.swarm.md` and produces `*.swarm.ir.json` (the IR envelope of §12). It is mostly deterministic. The pass MUST perform, in order:

1. **Assign IR node ids.** Each surface block (short per-type id, e.g. `AC-001`) becomes an IR node whose id MAY be namespaced as `REQ.<spec>.AC-001` (§4). Surface ids remain stable; the namespaced form is IR-only.
2. **Build typed edges.** Relationships are emitted as `edges[]` entries `{from, to, type, hard}` with `type ∈ {depends_on, blocks, conflicts_with, verified_by, affects, implements, preserves}`. Edges are the **single source of relationship truth** — a relationship MUST NOT be duplicated as a node scalar (§12). `DEPENDS ON` → `depends_on` edges; `AFFECTS` → `affects` edges; `WRITES` overlap → `conflicts_with` edges; each `VERIFY BY` → a `verified_by` edge.
3. **Normalize `verify_by`.** Each surface `VERIFY BY <type>:<adapter>:<artifact>[#selector]` clause becomes a normalized IR record `{type, adapter, ref, selector, gate}` (§15). The `<adapter>` is recorded as written; it resolves through AGENTS.md > Commands at `verify` time (§15), not at lowering time.
4. **Emit the two derived graphs.** The pass MUST emit (a) a **dependency DAG** from the `depends_on` edges and (b) a **write-surface conflict graph** from `WRITES`/`SURFACE` declarations and the `READS`/`WRITES` conflict rule (§11.5). These two graphs are the substrate the safe-parallelism predicate runs on (§18); the `lower` pass produces them, `decompose` consumes them.

#### 11.1.1 AND THE chaining (G3)

A `REQ` MAY chain obligations with `[AND THE <actor> <MODAL> <response>]*` (§5, §6). The `lower` pass MUST split each chained clause into a **distinct IR obligation node**, one per `AND THE` clause, each inheriting the parent block's id stem with a distinct sub-id and the parent's bindings unless overridden.

> **R-CHAIN.** Chained obligations are lowered into multiple distinct IR obligations. When a single block chains **more than two** obligations (three or more `THE …`/`AND THE …` clauses), the `lower` pass MUST emit a `SOL-P004`-adjacent **warning** (bundled-obligation smell) suggesting `ATOMIZE` (§10). It MUST NOT be a hard error; chaining is permitted.

```sol
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
AND THE client MUST redirect to `/login`
VERIFY BY test:cmdTest:auth-refresh-expired-token
```
lowers to two IR obligations (`AC-001.a` "clear the local session", `AC-001.b` "redirect to /login"), both carrying the `verified_by` edge to the named test. Two chained clauses → no warning. A third `AND THE …` would trip the `SOL-P004`-adjacent warning.

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

> **R-OWNED-SUBSET.** An execution-tier owned path MUST be a subset of the union of its assigned obligations' `WRITES` surfaces. A violation — an owned path that touches a file outside any assigned obligation's declared write surface — is lint code **`SOL-O305`** ("owned path outside declared write surface"). See §18 and §19 for the coordination detail and the disjoint-scope invariant this rule protects.

```text
AC-001 WRITES src/auth/**
task-packet owns: src/auth/session.ts        -> OK (subset)
task-packet owns: src/billing/charge.ts      -> SOL-O305 (outside declared WRITES)
```

### 11.4 Lowering preserves obligations, bindings, and authority

The `lower` and `decompose` passes are subject to the distillation-loss rule (§24):

> If lowering drops an obligation id, modality, actor, trigger, response, constraint, invariant, or verification binding, that is a **distillation error** (not a lint warning to be triaged later — a hard failure of the pass).

Authority (§22) MUST be carried onto each lowered node so that, downstream, a conflict can still be resolved by the two-axis source-authority rule without re-reading the surface spec. Verification bindings MUST survive lowering intact so that the `verify` pass (§9, §15) has a `verified_by` edge for every required obligation — an obligation that reaches `decompose` with no `verify_by` is a `SOL-V001`-class defect that should have been answered by `BIND` (§10) during `improve`.

### 11.5 READS/WRITES conflict rule (referenced by §18)

The conflict graph that `lower` emits uses conflict-serializability semantics: a `READS`/`READS` pair on the same surface is parallel-safe (no edge); a `READS`/`WRITES` or `WRITES`/`WRITES` pair on the same surface is a conflict (`conflicts_with` edge). A `SURFACE` MAY carry an attribute (`append-only`, `integration`, `shared`) so that shared/global/append-only surfaces are not treated as ordinary write conflicts. The full predicate and `SURFACE` attribute mechanism are specified in §18; `lower` is responsible only for emitting the edges that predicate consumes.


## 12. The intermediate representation (IR)

### 12.1 Purpose and status

The **intermediate representation** (IR) is the typed, machine-checkable form of a SOL specification: a single JSON document that re-expresses every obligation, relationship, diagnostic, and provenance fact carried by one `*.swarm.md` source. The IR is the substrate every downstream analysis reads — topological sort over dependencies, cycle detection, write-surface conflict detection, traceability join, merge-gate evaluation, drift recomputation (see §16). The surface (`.swarm.md`) is what a human authors; the IR is what a tool would reason over (§3 establishes the surface-vs-IR layering as the master distinction of the architecture).

The IR file is named with the compiler-visible `.swarm.` infix: a source `auth-refresh.swarm.md` lowers to `auth-refresh.swarm.ir.json` (see §20 for the artifact-name rules). The `.json` form signals that the IR is *emitted*, not human-authored — it is the only legal producer of an `.ir.json` file is a future compiler.

> **Contract, not executor (normative).** This document specifies the IR as a **versioned data contract**: the shape an IR document MUST have so that any future tool can produce or consume it interoperably. This repository ships **no emitter, no parser, and no validator** for the IR. The formal JSON Schema (Appendix C) is documentation and a conformance fixture, not running code. A conformant Swarm repository MUST include the documented IR Schema; it MUST NOT claim that any `.swarm.ir.json` file is produced by a shipped tool. *Rationale: Principle 1 — no runtime; everything that "runs" is a contract a future tool builds against (Q3.11, §2, §17).*

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

The IR layer is snake_case throughout. Every surface keyword that is English-shaped UPPERCASE space-separated (`VERIFY BY`, `DEPENDS ON`, `OWNED BY`, `WRITES`, `READS`, `AFFECTS`) maps to a snake_case IR field (`verify_by`, `depends_on`, `owned_by`/`owner`, `writes`, `reads`, `affects`). This casing split is normative and is never mixed (X4, §4).

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
| `id` | string | MUST | Stable spec identifier; matches the surface frontmatter `spec`. |
| `title` | string | MUST | Human-readable spec title. |
| `language` | string | MUST | The SOL language discriminator, exactly `SOL/0.1` for this version (§12.7, §25). Answers "which grammar/blocks/modals/lint codes." |
| `version` | string | MUST | The **spec content** version (semver-shaped, e.g. `0.1.0`). Distinct from `language`. |
| `status` | string | MUST | Spec lifecycle state; one of `draft`, `active`, `deprecated`. |
| `owners` | array of string | MUST | Accountable maintainers (handles). MAY be empty only for a `draft`. |
| `imports` | array of string | MUST (MAY be empty) | Relative paths to imported `*.swarm.md` specs whose nodes are in scope for cross-spec reference resolution. |

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
| `id` | string | MUST | IR node id. MAY be namespaced as `<KIND>.<spec>.<surface-id>` (e.g. `REQ.auth-refresh.AC-001`); the surface id (`AC-001`) MUST be recoverable from it. Surface ids are short per-type; IR ids MAY be dotted (§4, Q1.5). |
| `kind` | string | MUST | One of `REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`, `TRACE`, `VERDICT`. |
| `authority` | string | MUST for obligation kinds | The resolved domain-authority rank governing this node (e.g. `security`, `architecture`, `product`); see §22. MAY be `null` for QUESTION/TRACE. |
| `modality` | string\|null | MUST for REQ/CONSTRAINT/INVARIANT | The binding modal: one of `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY`. `null` for kinds that carry no modal (INTERFACE, QUESTION, TRACE, VERDICT). Mirrors `clauses.modal`. |
| `clauses` | object | MUST | The structured decomposition of the control sentence (§12.4.2). |
| `owner` | string\|null | SHOULD | The accountable owner (surface `OWNED BY`). |
| `risk` | string\|null | MAY | One of `low`, `medium`, `high`, `critical` (surface `RISK`). |
| `reads` | array of string | MUST (MAY be empty) | The **read scope set** (§12.6). Surface `READS`. |
| `writes` | array of string | MUST (MAY be empty) | The **write scope set** (§12.6). Surface `WRITES`; surface names are SURFACE ids, never `locks`. |
| `affects` | array of string | MUST (MAY be empty) | The **impact scope set** (§12.6). Surface `AFFECTS`. |
| `verify_by` | array of object | MUST (MAY be empty) | Normalized proof bindings (§12.4.3). Surface `VERIFY BY`. |
| `status` | string | MUST | The node's current verdict in the 7-value model (§12.4.4). |
| `source` | object | MUST | Origin span and content hash (§12.4.5). |
| `provenance` | array of object | MUST (MAY be empty) | Per-node provenance trail: prior verdicts, lowering ancestry, promotion lineage. Free-form objects whose minimal pinned shape is the trace-provenance schema of §16; not re-specified here. |

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

For a chained obligation (`THE … MUST … AND THE … MUST …`), the lowering pass MUST split it into multiple nodes, one per `THE <actor> <MODAL> <response>` clause (G3); each resulting node has a single-obligation `clauses` object. An INVARIANT lowers `<property> MUST|MUST NOT <hold>` into `subject` = the property and `predicate` = the held condition. An INTERFACE has no `subject`/`modal`/`predicate`; its `RETURNS`/`ACCEPTS`/`ERRORS`/`OWNED BY` are carried as the surface block requires and MAY be modeled as extension fields (out of this version's pinned shape, but the `contract` proof binding of §15 is still MUST-present in `verify_by`).

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

`node.status` consumes the full **7-value** verdict model (X2, §14): the four mutually-exclusive **core** outcomes plus, where applicable, a **lifecycle** decorator. In the IR, `status` is one of the four core string values, optionally carrying a lifecycle in a parenthetical-free structured form via the node's latest VERDICT node/edge:

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

> **Edges are the single source of relationship truth.** A relationship between two nodes MUST be represented exactly once, as an edge. A relationship MUST NOT also be duplicated as a node scalar. There is no `depends_on`, `blocks`, `conflicts_with`, `verified_by`, `implements`, or `preserves` field on a node. A consumer computing dependency order, conflict, or traceability MUST read `edges[]` and MUST NOT reconstruct relationships from node fields. *Rationale: a relationship stored twice can disagree; one representation cannot (Q3.12).*

This is distinct from the three **scope sets** on a node — `reads`, `writes`, `affects`:

- A **scope set** answers "what region of the world does this single obligation touch?" It is a property *of one node*, an unordered set of opaque SURFACE identifiers. It is intrinsic node data and correctly lives on the node.
- A **relationship edge** answers "how do two nodes relate?" It connects *two* node ids and correctly lives in `edges[]`.

The two are connected but not redundant. The lowering pass *derives* `conflicts_with` and `affects` edges *from* scope sets — e.g. if node A and node B both list write surface `web.http.client`, the lowering pass MUST emit a `conflicts_with` edge between them; if A's `affects` set names a surface that B `writes`, an edge MAY be derived per the read/write conflict rule (§18, G7). The scope set is the raw declaration; the edge is the computed relationship. Keeping the raw set on the node and the computed relationship in the graph means the derivation is auditable and re-runnable, and the two never silently disagree. Note the special case: `affects` exists *both* as a node scope set (the declared impact region) *and* as an edge type (a concrete node→node impact link). They are not duplicates: the set is the declaration, the edge is one resolved consequence of it.

### 12.6 Scope sets in detail

The three scope sets carry the coordination contract that §18 lowers into the dependency DAG and write-conflict graph:

| Scope set | Surface clause | Semantics |
|---|---|---|
| `reads` | `READS` | Surfaces this obligation reads but does not modify. read/read is always parallel-safe; read/write on the same surface is a conflict (§18, G7). |
| `writes` | `WRITES` | Surfaces this obligation modifies. Shared write surface ⇒ `conflicts_with` ⇒ not parallel-safe (§18). Surface names are SURFACE ids (`SURFACE <name> = …`); there is no `locks` field (§4, §18). |
| `affects` | `AFFECTS` | Surfaces impacted indirectly (blast radius). Contributes conflict edges; does not by itself imply a write. |

Surface identifiers in scope sets are the SURFACE names declared in the spec (a lock group is a named coarse write surface, never a `locks` primitive — X4). They are opaque strings to the IR; their resolution to files/globs is an orchestration concern (§18).

### 12.7 The three version fields (never merged)

The IR echoes **three distinct version axes** (Q9.30, §25). They occupy three distinct fields and a consumer MUST NOT collapse, merge, or infer one from another:

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
| `level` | string | MUST | SARIF level: `error`, `warning`, or `note`. Maps to the §8 BLOCKING/ADVISORY split (BLOCKING ⇒ `error`). |
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
| `compiled_at` | string | MUST | ISO-8601 timestamp of emission. |

### 12.10 Conformance and the formal schema

A document is a conformant SOL/0.1 IR iff it: (1) has exactly the five top-level keys of §12.2; (2) populates every MUST field of §12.3–§12.9; (3) uses only the closed enumerations (7 kinds, 5 modals, 9 proof types, 7 edge types, 7 verdict values, the `SOL-<LAYER>NNN` code space); (4) represents every relationship once, as an edge (§12.5.1); (5) keeps the three version fields distinct (§12.7). The normative machine-readable form is the JSON Schema in **Appendix C**; where this prose and Appendix C disagree, Appendix C governs the shape and this section governs the intent.

## 13. The plan

### 13.1 Purpose and status

The **plan** is the schedulable projection of the IR: it takes the obligation graph (nodes + edges) and groups the work needed to discharge those obligations into **work packets** — units a launcher could hand to one agent in one lane. Where the IR answers "what must hold and how do the obligations relate," the plan answers "what units of work exist, in what order, on which surfaces, and which of them are safe to run at the same time." The plan is the kernel's static coordination contract (§18); it is *not* a running scheduler.

The plan file uses the compiler-visible infix: `auth-refresh.swarm.ir.json` plans to `auth-refresh.swarm.plan.json` (§20).

> **Contract, not executor (normative).** The plan schema is **documented, versioned data** — the shape a launcher/harness would consume. This repository ships **no planner and no scheduler**. The planner that would derive a plan from an IR, and the scheduler/harness that would execute the plan's work packets across agents, are **launcher concerns and MUST NOT be shipped by the kernel** (Q3.11, Q8.27, §18). A conformant repository MUST include the documented plan schema and MUST frame any `.swarm.plan.json` as "the contract a future launcher builds against," never as the output of a shipped tool. *Rationale: Principle 1 — no runtime; and Q8.27 — the kernel owns the static coordination contract, never the live scheduler.*

### 13.2 Resolution method (G8)

The two source files disagreed on the plan shape: one offered a flat `{ plan_id, max_parallel, tasks[] }` with per-task `lane/writes/locks/depends/merge_safe`; the other offered a `task` record with `pass/profile/inputs/outputs/batch`. G8 resolves this with the **same method used for the IR (Q3.12)**: a graph envelope plus a rich per-unit payload, snake_case throughout, with two normative subtractions:

- **Drop `locks` entirely.** A lock group is a named coarse write `SURFACE`; lock-set analysis *is* write-set analysis at surface granularity (X4, §18). The plan carries `writes[]` (write surfaces), never a `locks` field.
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

The plan reuses the IR's structural discipline: relationships between packets live only in `edges[]` (never duplicated as packet scalars), and the three version fields stay distinct (§12.7). The `depends_on[]` array on a packet (§13.5) is the surface declaration of ordering; the planner MUST also emit a `depends_on`-type edge for each, so that ordering is computable from the graph (the same scope-set-vs-edge relationship as §12.5.1).

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
| `writes` | array of string | MUST (MAY be empty) | The **write surfaces** this packet modifies — SURFACE ids, derived from the `writes` scope sets of its `inputs`. The lowering rule requires every write surface here to be a subset of its obligations' declared `WRITES` (§18, lint `SOL-O305`). No `locks` field (§13.2). |
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

A packet's `merge_safe` MUST be `false` if it has any unresolved `conflicts_with` edge to a packet in the same `batch`, or if any of its `inputs` is unscoped (empty `writes` where a write is implied). `merge_safe` is the kernel's *static* verdict; a launcher MAY further serialize for its own reasons but MUST NOT parallelize two packets the plan marks unsafe. *Rationale: review entropy and merge collisions, not agent count, are the binding constraint on safe parallelism (Q8.27, §18).*

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
      "inputs": ["REQ.auth-refresh.AC-001"], "outputs": ["web/src/http/client.ts"],
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

A document is a conformant SOL/0.1 plan iff it: (1) has exactly the four top-level keys of §13.3; (2) populates every MUST field of §13.4–§13.5; (3) carries no `locks` field anywhere (§13.2); (4) uses only the closed pass set (§9) in `packets[].pass` and the closed edge-type set (§12.5) in `edges[]`; (5) represents inter-packet relationships once, as edges (§13.5.1); (6) keeps the three version fields distinct (§12.7). The plan schema is documented data only — no planner ships (§13.1). The formal JSON Schema for the plan is companion to **Appendix C**.

Both sections are drafted above. They cover §12 (the IR — full envelope, node record with all specified fields, the edges-as-single-relationship-truth rule with the scope-set distinction, SARIF diagnostics, three version fields, contract-not-executor rule, Appendix C pointer) and §13 (the plan — G8 resolution via the IR method, graph envelope plus work-packet payload with the exact field set, `locks` dropped, safe-parallelism predicate cross-referencing §18, launcher-not-kernel framing), with worked examples for both. Combined length is in the ~280–360 line target range.


---

## 14. The verification model — verdicts and the merge gate

This section defines how Swarm judges whether an obligation has been satisfied. The verdict model is the **confidence backbone** of the framework: it is the only place where the question "did this actually get done?" is answered, and it is the gate every change MUST pass before promotion. Everything that follows is a *contract a future tool builds against* — Swarm ships no runtime (§2, Principle 1), so today every verdict is recorded by a human or agent in a markdown `review.md` and re-checked by hand or by CI scaffolding that does not yet exist.

A **verdict** is the recorded judgment of one *required* verification binding on one obligation. An **obligation** here means a `REQ`, `CONSTRAINT`, `INVARIANT`, or `INTERFACE` block (the blocks that carry binding force or declare a verifiable boundary — see §6). A `QUESTION` is never judged; a `TRACE` is the *input* to judgment; a `VERDICT` *is* the recorded judgment and reuses the judged obligation's id (per §4).

### 14.1 The seven-value model (4 core + 3 lifecycle)

Swarm's verdict vocabulary is **exactly seven values**, partitioned into two disjoint roles. This resolves cross-cluster conflict X2: the earlier 4-value enum is *upgraded*, never replaced. A verdict carries exactly one **CORE** value and zero or more **LIFECYCLE** decorators.

#### 14.1.1 The four CORE run results (mutually exclusive)

Exactly one core value MUST be assigned to every required binding. The four are mutually exclusive: a single bound proof, on a single run, lands in exactly one.

| CORE value | Meaning | Precise condition |
| --- | --- | --- |
| `PASS` | A bound proof ran and succeeded. | A proof was bound via `VERIFY BY` (§15), it executed, and its observed result satisfies the obligation. |
| `FAIL` | A bound proof ran and failed. | A bound proof executed and its observed result contradicts the obligation. |
| `BLOCKED` | A bound proof could not run. | A proof was bound but could not execute: a prerequisite, tool, adapter, environment, or fixture was missing. The truth is *unknown*, not false. |
| `UNVERIFIED` | No acceptable proof, or none executed. | No acceptable proof was bound to the obligation, or a binding exists but no run was attempted. |

> Rationale (Q4.13): `BLOCKED` and `UNVERIFIED` are kept distinct because they route differently — `BLOCKED` is an environment fix, `UNVERIFIED` is a binding or execution gap. Collapsing them hides which one is owed.

`BLOCKED` and `UNVERIFIED` MUST NOT be conflated. A reviewer who cannot tell whether a proof *ran and was prevented* (`BLOCKED`) versus *was never attempted or never bound* (`UNVERIFIED`) MUST record `UNVERIFIED`, because the absence of an attempt is the weaker, more honest claim.

#### 14.1.2 The three LIFECYCLE decorators

A lifecycle decorator annotates a core value with a status that arises *after* (or *around*) the run. Lifecycle decorators are not run results; they are governance facts.

| LIFECYCLE value | Decorates | Meaning | Mandatory fields |
| --- | --- | --- | --- |
| `WAIVED` | `FAIL` or `UNVERIFIED` | A failing or unverified obligation is explicitly accepted as an exception. | authority, reason, expiry |
| `STALE` | a prior `PASS` | A previously-passing proof's evidence no longer matches the current source/surface hashes (drift — see §16). | prior-verdict ref, changed-surface |
| `CONTRADICTED` | any core | Two proofs disagree, or a `TRACE`/code disagrees with the obligation. | two conflicting evidence refs |

`WAIVED` MUST decorate only `FAIL` or `UNVERIFIED` — there is no reason to waive a `PASS`. `STALE` MUST decorate only a prior `PASS` — a `FAIL`, `BLOCKED`, or `UNVERIFIED` was never trusted, so it cannot go stale. `CONTRADICTED` MAY decorate any core value, because contradiction is a relationship between *two* evidence sources regardless of either's individual result.

### 14.2 The VERDICT line grammar

A `VERDICT` block (§6) records one judgment. Its first line is the **verdict line**; subsequent `REASON` and `EVIDENCE` clauses supply the justification.

```ebnf
verdict_block   = verdict_line , nl ,
                  "REASON" , ws , prose , nl ,
                  "EVIDENCE" , ws , evidence_ref , { nl , "EVIDENCE" , ws , evidence_ref } ;
verdict_line    = "VERDICT" , ws , obligation_id , ":" , ws , core_value ,
                  [ ws , lifecycle_decorator ] ;
core_value      = "PASS" | "FAIL" | "BLOCKED" | "UNVERIFIED" ;
lifecycle_decorator
                = "(" , lifecycle , ws , "by" , ws , authority , ":" , ws , reason ,
                  [ ";" , ws , lifecycle_fields ] , ")" ;
lifecycle       = "WAIVED" | "STALE" | "CONTRADICTED" ;
authority       = ident | quoted_string ;
reason          = prose ;
lifecycle_fields= field , { ";" , ws , field } ;
```

The verdict line is `VERDICT <id>: <CORE>` optionally followed by a single parenthetical `(<lifecycle> by <authority>: <reason>)`. The `<id>` reuses the judged obligation's surface id (`AC-001`, `C-001`, `I-001`, `IF-001`).

Worked examples:

```sol
VERDICT AC-001: PASS
REASON The client clears the session store and issues a redirect to `/login`
       when the refresh token expiry is simulated.
EVIDENCE test:cmdTest:auth-refresh-expired-token#it_clears_session — exit 0, 1 passed
```

```sol
VERDICT AC-014: FAIL (WAIVED by spec-owner@example: known flaky upstream sandbox; expiry 2026-06-30)
REASON The payment sandbox returns 502 intermittently; the obligation is unmet
       but accepted for this release window.
EVIDENCE test:cmdTest:payment-timeout#retryable_attempt — exit 1, 1 failed
```

```sol
VERDICT I-001: PASS (STALE by drift-check: prior-verdict T-009; changed-surface src/auth/session-store.ts)
REASON The token-family invariant last passed at trace T-009; src/auth/session-store.ts
       was modified after that PASS, so the evidence no longer matches the current code.
EVIDENCE property:cmdTest:token-family-invariant#single_active_family — last PASS 2026-05-20
```

```sol
VERDICT AC-022: PASS (CONTRADICTED by review: contract proof and e2e test disagree)
REASON The contract proof reports the boundary honoured; the e2e test observes a 500.
EVIDENCE contract:cmdContract:refresh-session.pact#refreshSession — pass
EVIDENCE test:cmdTest:refresh-e2e#happy_path — exit 1, 1 failed
```

### 14.3 Lint enforcement of verdict well-formedness

The lint layer responsible for verdict well-formedness is `SOL-V` (VERIFICATION). The following diagnostics MUST be raised by a conformant linter (today: by hand or by the documented `lint-spec` pass guide — §26):

| Code | Severity | Condition |
| --- | --- | --- |
| `SOL-V005` | BLOCKING | `VERDICT` core value is not one of `PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED` (the former `SOL-S010`), OR a lifecycle decorator is missing its mandatory fields. |
| `SOL-V007` | BLOCKING | `WAIVED` decorates a `PASS` or `BLOCKED` (waiver is only meaningful on `FAIL`/`UNVERIFIED`), OR `STALE` decorates anything other than a prior `PASS`. |
| `SOL-V008` | BLOCKING | A required obligation has no `VERDICT` at the merge gate (see §14.4). |

The mandatory-field rule (`SOL-V005`) is enforced per lifecycle value:

- `WAIVED` MUST carry **authority** (a named human or the spec owner — §17.3), a **reason**, and an **expiry**. A `WAIVED` without all three is `SOL-V005`.
- `STALE` MUST carry a **prior-verdict ref** (the trace or verdict that last recorded the `PASS`) and the **changed-surface** that triggered staleness (§16).
- `CONTRADICTED` MUST carry **two conflicting evidence refs** (one `EVIDENCE` line per disagreeing proof).

> Rationale: the mandatory fields are what make a lifecycle decorator auditable. A `WAIVED` without an expiry is a zombie waiver (§17.3); a `STALE` without a changed-surface cannot be reconciled (§16.3); a `CONTRADICTED` without both refs cannot be tie-broken (§17.4).

### 14.4 The merge gate

The **merge gate** is the single normative predicate that decides whether a change set may be promoted. It is evaluated over the set of **required** obligations — every `REQ`, `CONSTRAINT`, `INVARIANT`, and `INTERFACE` in scope for the change, each with its required `VERIFY BY` bindings (§15.7, "one VERDICT per required VERIFY BY binding").

> **Merge gate (normative).** A change set MAY be promoted **if and only if** every required obligation's latest verdict is `PASS` or `WAIVED`, **and no** required obligation's latest verdict is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED`.

Equivalently, expressed as the disposition of each core value under the gate:

| Latest verdict | Merge gate disposition |
| --- | --- |
| `PASS` (no lifecycle) | Passes the gate. |
| `WAIVED` (on `FAIL`/`UNVERIFIED`, fields valid, not expired) | Passes the gate. |
| `FAIL` | Blocks. Fix code or amend obligation. |
| `BLOCKED` | Blocks. Fix the environment/adapter, then re-run. |
| `UNVERIFIED` | Blocks. Bind a proof and run it, or `WAIVE`. |
| `PASS (STALE)` | Blocks. Forces 3-way reconcile (§16.3). |
| any `(CONTRADICTED)` | Blocks. Routes to review with stronger oracle authoritative (§17.4). |

A conformant repo MUST NOT promote a change while any required obligation is in a blocking disposition. Because Swarm has no runtime, this gate is **enforced by a deterministic check outside the model** when one exists (CI, a PreToolUse hook, a merge-blocking status — see §17), and is **manual today**. The spec MUST NOT claim the gate is automatically enforced (§17.1).

A `WAIVED` verdict is treated as gate-passing **only while its waiver is live**. A waiver auto-expires on the next source-hash change (§17.3); an expired waiver reverts to its underlying `FAIL`/`UNVERIFIED` and the gate blocks again.

### 14.5 `review.md` is the verdict container (there is no `verdict.md`)

A `VERDICT` is a **SOL language block**, not a file (per Q2.9 and §4). The kernel ships **no** `verdict.md` template. The container for verdicts is the **`review.md`** artifact (§21), which when filled *is* the verdict record. A conformant `review.md` MUST contain, at minimum:

```text
- Claimed coverage (which TRACE claims which obligations, with evidence refs)
- Per-obligation VERDICT blocks (one per required binding)
- An obligation-verdict matrix (id × core × lifecycle)
- Constraint / invariant / interface verdicts
- An unauthorized-change list (diff entries not authorized by any obligation)
- A final merge-gate verdict (PASS / FAIL / BLOCKED at the change-set level)
- The promotion queue
```

A repo that records verdicts in a standalone `verdict.md` is **non-conformant** (§20). The reference page `docs/.../verdict` (if present) documents the `VERDICT` block and the taxonomy; it is *documentation*, not a copyable template.

---

## 15. The proof taxonomy and VERIFY BY binding

A verdict (§14) is only as trustworthy as the proof behind it. This section fixes the **closed set of nine proof types**, the **binding syntax** that attaches a proof to an obligation, the **two-layer resolution** through `AGENTS.md`, the **type-selection rules** per block type, the **proof-strength order**, and the **per-task-type default suites**. The governing invariant is **CODE IS REALITY** (§2): a proof can falsify an obligation but may never silently amend its intent, and **schema-valid output is not a proof** (shape is not truth).

### 15.1 The nine proof types (closed)

`VERIFY BY` binds an obligation to exactly one of nine proof types. The set is **closed**: a conformant linter MUST reject any `<type>` outside this set as `SOL-V009` (unknown-proof-type). This resolves the earlier 11-type and 7-type proposals into one canonical set (Q4.14).

| Proof type | One-line definition |
| --- | --- |
| `static` | A non-executing analysis of source: type-check, lint, dependency-boundary check, schema validation of source. |
| `test` | An executable test that drives the system and asserts an observable outcome. |
| `contract` | A verification that a declared boundary (an `INTERFACE`) honours its `RETURNS`/`ACCEPTS`/`ERRORS` shape — a consumer/provider contract test, pact, or schema-conformance check at a boundary. |
| `property` | A generative/property-based check that asserts a universally-quantified property over many generated inputs. |
| `model` | Model-checking OR an economical proof of a property — **not** a full theorem per obligation (see 15.5). |
| `perf` | A measured performance/throughput/latency assertion against a threshold. |
| `security` | A security-specific oracle: SAST/DAST, secret scan, authz/authn test, dependency-vuln gate. |
| `manual` | A recorded human judgment against the obligation — the **honest escape hatch** when no executable oracle exists. |
| `monitor` | A runtime/production observation (logs, metrics, alerts, canary). Runtime evidence maps here. |

Two normative notes:

- **`unit`/`integration`/`e2e` are scope qualifiers under `test`, not separate types.** They are written `test:unit:`, `test:integration:`, `test:e2e:` in the binding (15.2). A conformant linter MUST treat `unit`, `integration`, `e2e` appearing as a top-level `<type>` as `SOL-V009` (unknown-proof-type; use the qualifier form instead).
- **`runtime` maps to `monitor`.** There is no `runtime` proof type; any "verified in production / observed at runtime" claim binds as `monitor`.

### 15.2 The VERIFY BY binding syntax

The surface clause is `VERIFY BY` (two words, uppercase — §5) followed by a typed reference. This composes the §5 keyword with the reference grammar (conflict X3).

```ebnf
verify_line  = "VERIFY BY" , ws , verify_ref , nl ;
verify_ref   = proof_type , ":" , adapter , ":" , artifact , [ "#" , selector ] ;
proof_type   = "static" | "test" | "contract" | "property" | "model"
             | "perf" | "security" | "manual" | "monitor" ;
adapter      = ident ;            (* resolves through AGENTS.md > Commands, see 15.3 *)
artifact     = path | ident | quoted_string ;
selector     = ident | path-fragment ;   (* a case/scenario/property name *)
```

- `<type>` is the **closed**, lint-typed, IR-typed dimension. For `test`, a scope qualifier MAY be inserted as `test:unit`, `test:integration`, `test:e2e` (the qualifier is part of the type segment, before the first `:` separating type from adapter — written `test:unit:cmdTest:...`).
- `<adapter>` is a **project free-string** that resolves to a command slot in `AGENTS.md > Commands` (15.3).
- `<artifact>` is a **project free-string**: a file, test id, suite name, or contract file.
- `<selector>` (optional, after `#`) narrows the artifact to a single case, scenario, or property.

Worked examples:

```sol
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
VERIFY BY test:unit:cmdTest:auth-refresh-expired-token#clears_session
```

```sol
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
VERIFY BY static:cmdLint:dependency-boundary#no-server-imports
```

```sol
INTERFACE IF-001:
`refreshSession()` RETURNS `Session | AuthExpired`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
VERIFY BY contract:cmdContract:refresh-session.pact#refreshSession
```

The IR field name for this clause is `verify_by[]` (snake_case — §12), normalized to `{type, adapter, ref, selector, gate}`. The surface form is always `VERIFY BY`; `VERIFY_BY` is surface-illegal (§5).

### 15.3 Two-layer unification: obligation binding + project adapter

`VERIFY BY` participates in a **two-layer** model (Q4.15), which keeps the obligation portable while letting each project name its own commands:

1. **Obligation layer (SOL, in `*.swarm.md`).** The `VERIFY BY <type>:<adapter>:<artifact>` clause declares *what kind of proof* and *which logical command + artifact* prove the obligation. The `<type>` is closed and analyzable; the `<adapter>` and `<artifact>` are free strings.
2. **Project layer (`AGENTS.md > Commands`).** The `<adapter>` resolves through the `AGENTS.md` Commands table, whose `cmd*` placeholder slots **are the adapters**. A future tool (or a human today) looks up `<adapter>` in that table to find the concrete command line for *this* repo.

The default proof-type → `cmd*` slot mapping:

| Proof type | Default `cmd*` slot(s) |
| --- | --- |
| `static` | `cmdLint`, `cmdTypecheck`, `cmdValidate` |
| `test` (any scope) | `cmdTest` |
| `contract` | integration-boundary command (e.g. `cmdContract`) |
| `property` | `cmdTest` (property runner) or a dedicated `cmdProperty` |
| `model` | `cmdModel` (model checker) or `cmdTest` for an economical proof |
| `perf` | `cmdBenchmark` |
| `security` | `cmdSecurity` / `cmdScan` (integration-boundary command) |
| `manual` | no command — resolves to a recorded human review |
| `monitor` | `cmdMonitor` / dashboard ref — no merge-time execution |

> Rationale (Q4.15): keeping the proof *type* in the obligation and the *command* in `AGENTS.md` means the same `spec.swarm.md` ports across repos: only the Commands table changes. A binding whose `<adapter>` has no matching `AGENTS.md > Commands` row is `SOL-V002` (proof-not-executable), which surfaces as `BLOCKED` at run time, not `PASS`.

### 15.4 Type-selection rules per block type

A conformant linter MUST apply the following block-type → proof-type rules:

| Block type | Rule | Lint on violation |
| --- | --- | --- |
| `REQ` | Any of the nine types is acceptable; `test` is the typical default. | `SOL-V001` if no `VERIFY BY` at all. |
| `CONSTRAINT` | Any type; `static` and `test` are typical. | `SOL-V001` if no `VERIFY BY` and no explicit `manual`. |
| `INVARIANT` | **Prefers `property` \| `model` \| `static`.** Binding an `INVARIANT` only to a non-observable unit `test` is a `SOL-V003` **warning** (ADVISORY by default; BLOCKING in strict mode). | `SOL-V003` (invariant bound test-only). |
| `INTERFACE` | **Requires a `contract` proof.** | `SOL-V006` (interface without a `contract` binding). |

> Rationale: an `INVARIANT` asserts a universally-quantified property ("for all states, P holds"); a single example-based unit `test` cannot establish a universal, so `property`/`model`/`static` are preferred and a test-only binding is flagged but not blocked (Theme-5 gap-fill). An `INTERFACE` is a boundary contract, so its proof MUST be a `contract` check that exercises `RETURNS`/`ACCEPTS`/`ERRORS` (resolves the Theme-1 INTERFACE-verification gap).

### 15.5 `model` does not mean a theorem per obligation

`model` means **model-checking OR an economical proof** of a property. It MUST NOT be read as a requirement to discharge a full mechanized theorem for each obligation.

> Rationale (Q4.14): mechanized end-to-end proof success rates are far too low (single-digit percent in current tooling) to mandate per obligation. `model` covers bounded model checking, an SMT-discharged property, an exhaustive small-scope check, or any economical argument an oracle can replay. When even that is infeasible, `manual` is the honest type.

### 15.6 The proof-strength order

When two proofs disagree (`CONTRADICTED`, §14.1.2, §17.4), the tie-break uses a fixed total preorder over proof types:

```text
model  >  property | contract  >  test  >  static  >  manual | monitor
```

| Rank | Types | Why this rank |
| --- | --- | --- |
| 1 (strongest) | `model` | Establishes a universal property, not an example. |
| 2 | `property`, `contract` | Generative coverage / boundary-shape conformance. |
| 3 | `test` | Example-based executable oracle. |
| 4 | `static` | Source analysis without execution. |
| 5 (weakest) | `manual`, `monitor` | Human judgment / observational signal — fallible and lagging. |

The stronger proof is treated as **authoritative pending reconciliation** at the merge gate (§17.4). This places executable oracles above an LLM-judge `manual` verdict, which is why `manual` and `monitor` sit at the bottom.

### 15.7 One VERDICT per required VERIFY BY binding

Each required `VERIFY BY` binding produces **exactly one** `VERDICT`. The hard gate (§14.4) is "one `VERDICT` per required `VERIFY BY` binding": if an obligation declares three required bindings, the merge gate expects three verdicts, and *all* must be `PASS`/`WAIVED`. A missing verdict for a required binding is `SOL-V008` (and counts as `UNVERIFIED` at the gate).

### 15.8 Per-task-type default suites

Each task kind (the `task_kind:` enum — §28) carries a **default suite**: a set of `(proof-type, phase)` requirements that recommend which proofs SHOULD be bound and at which phase they run. This reframes the legacy per-task verification matrix as default suites that bind to `cmd*` slots; the suites are **recommendations**, not a closed law — an author MAY override per obligation.

*(task_kind enum: §28)*

| `task_kind` | Default suite `(proof-type @ phase)` |
| --- | --- |
| `feature` | `test @ VERIFY`, `static @ VERIFY`; `contract @ VERIFY` if any `INTERFACE` touched |
| `fix` | `test @ VERIFY` (a regression test that reproduces the defect), `static @ VERIFY` |
| `refactor` | `test @ VERIFY` (behaviour-preservation), `property\|contract @ VERIFY` for invariants/boundaries |
| `rewrite` | `test @ VERIFY`, `static @ VERIFY`; `contract @ VERIFY` if any `INTERFACE` touched |
| `migration` | `test @ VERIFY`, `static @ VERIFY`, `contract @ VERIFY` (boundary conformance) |
| `upgrade` | `test @ VERIFY`, `static @ VERIFY`, `contract @ VERIFY` (dependency contracts) |
| `performance` | `perf @ VERIFY`, `test @ VERIFY`, `static @ VERIFY` |
| `testing` | `test @ VERIFY`, `static @ VERIFY` |
| `documentation` | `static @ VERIFY` (lint/APS); `manual @ REVIEW` for accuracy |
| `integration` | `contract @ VERIFY`, `test @ VERIFY`, `static @ VERIFY` |
| `spec-writing` | `static @ NORMALIZE` (lint/APS); no executable suite (no code yet) |
| `research-writing` | `static @ NORMALIZE` (lint/APS); no executable suite |
| `audit-writing` | `static @ NORMALIZE` (lint/APS); no executable suite |
| `bug-report-writing` | `static @ NORMALIZE` (lint/APS); no executable suite |
| `deepen-audit` | `static @ NORMALIZE` (lint/APS); `manual @ REVIEW` for evidence |
| `review` | `manual @ REVIEW` over the recorded evidence; re-run of bound `cmd*` proofs |
| `orchestration` | `static @ LOWER` (disjointness check); `manual @ REVIEW` |

A binding-completeness check (the `SOL-V` layer) verifies that an obligation's bound proofs cover its task kind's default suite, or that any omission is explicitly justified.

### 15.9 What is NOT a proof

The following MUST be rejected as invalid proofs and MUST NOT yield `PASS`:

- **Schema-valid output is not a proof.** That a tool emitted well-formed JSON, or that a structured-output call validated against its schema, says nothing about whether the *value* is correct. Shape is not truth (§2). A binding whose only evidence is "output matched the schema" is `UNVERIFIED`.
- **"Tests passed" without output is an invalid proof.** A `PASS` whose `EVIDENCE` is the bare phrase "tests passed" (no command, no exit code, no run output, no selector resolution) is `UNVERIFIED`; a conformant review MUST reject it.
- **A `manual` verdict without recorded reasoning** is `UNVERIFIED` — `manual` is an *honest* escape hatch, not a blank cheque; it MUST carry a `REASON` and an `EVIDENCE` ref to the recorded judgment.

---

## 16. Drift and staleness

A proof's `PASS` is a statement about a *moment*: the obligation said X, the code did Y, and the proof confirmed Y satisfies X. The instant either the obligation text or the code changes, that confirmation may no longer hold. **Drift** is the divergence between an obligation and its implementation after a recorded `PASS`; **staleness** is drift made machine-detectable. Because Swarm has **no runtime** (§2), drift is detected from **content hashes recorded in the trace/IR**, and the differ that compares them is a **harness/CLI concern, not shipped by this repo**.

### 16.1 What each PASS records (trace-provenance schema, G11)

Every `VERIFY BY` binding's **last `PASS`** MUST record enough provenance to detect later drift. This is **the one trace-provenance schema** that §14, §16, and §23 all reference — there is exactly one, so the verdict model, the drift check, and the memory model never diverge.

```json
{
  "source_hash": "sha256:…",
  "per_surface_hash": [
    { "surface": "src/auth/client.ts", "hash": "sha256:…" },
    { "surface": "src/auth/session-store.ts", "hash": "sha256:…" }
  ],
  "adapter": "cmdTest",
  "verdict": "PASS",
  "tier": "test",
  "origin_obligations": ["AC-001", "I-001"],
  "origin_traces": ["T-001"]
}
```

| Field | Meaning |
| --- | --- |
| `source_hash` | Content hash of the *obligation source* (the exact bytes of the obligation block in `*.swarm.md`) at the time of the `PASS`. |
| `per_surface_hash[]` | One `{surface, hash}` per **declared write surface** (the obligation's `WRITES` set — §18) at the time of the `PASS`. |
| `adapter` | The `cmd*` slot the proof resolved through (§15.3). |
| `verdict` | The core verdict recorded (`PASS` for a drift-trackable binding). |
| `tier` | The proof type (§15.1) — used for the proof-strength tie-break (§15.6). |
| `origin_obligations[]` | The obligation ids this PASS judged. |
| `origin_traces[]` | The trace(s) that produced the change being judged. |

Hashes are recorded in markdown (`*.swarm.trace.md`) and/or the emitted IR (`*.swarm.ir.json`). Computing them is a future-tool concern; the **schema is the kernel contract** today.

### 16.2 The staleness rule

A prior `PASS` becomes `STALE` (the lifecycle decorator of §14.1.2) when **either** of two conditions holds:

> **(a)** the obligation **source content-hash** changes (the obligation text was edited after the last `PASS`); **or**
> **(b)** any declared **write surface** is modified after the last `PASS` (its current hash differs from the recorded `per_surface_hash`).

Condition (a) means *intent moved*: the proof confirmed an obligation that no longer reads the same. Condition (b) means *code moved*: the proof confirmed code that has since changed. In both cases the recorded `PASS` is no longer trustworthy, and the verdict MUST be decorated `STALE` (with the prior-verdict ref and the changed-surface, per `SOL-V005`).

```sol
VERDICT AC-001: PASS (STALE by drift-check: prior-verdict T-001; changed-surface src/auth/client.ts)
REASON src/auth/client.ts changed after the last PASS at T-001; the recorded
       per-surface hash no longer matches the working tree.
EVIDENCE prior PASS recorded 2026-05-20 against source_hash sha256:ab12…
```

`STALE` **blocks the merge gate** (§14.4): a `PASS (STALE)` is treated as not-`PASS` until reconciled. A conformant tool (or a human, today) MUST recompute staleness before evaluating the gate and MUST NOT promote on a stale binding.

### 16.3 The 3-way reconcile

A `STALE` verdict forces an explicit **3-way reconcile**. Exactly one of three resolutions MUST be chosen and recorded; the system MUST NOT silently re-bless either the obligation or the code.

| # | Resolution | When | Effect |
| --- | --- | --- | --- |
| 1 | **Re-run the proof** | The change is compatible; intent and code still agree. | Bound `cmd*` re-runs; a fresh `PASS` with new hashes replaces the stale record. |
| 2 | **Amend / supersede the obligation** | Intent changed; the code is the new desired behaviour. | The obligation is amended (or superseded via ADR — §22), then re-verified. This is an *intent* change and routes to amendment/review, never to `improve` (§10). |
| 3 | **Fix the code** | Intent stands; the code drifted away from it. | The code is corrected to satisfy the unchanged obligation, then re-verified. |

> Rationale (Q9.29): **code is reality, not intent.** Code can *falsify* an obligation (forcing resolution 2 or 3) but may never *silently amend* it (which is why resolution 1 requires a genuine re-run, not a hash-rewrite). Re-stamping the hash without re-running the proof is forbidden — it manufactures a false `PASS`.

### 16.4 Drift coverage as a first-class metric

**Drift coverage** — the percentage of obligations whose **latest verdict is `STALE`** — is a first-class Swarm metric. A conformant repo SHOULD track and report it (manually today; via tooling when it exists). High drift coverage signals that verification has fallen behind change velocity and that the merge gate is, in aggregate, blocking.

```text
drift_coverage = ( count of required obligations whose latest verdict is STALE )
                 / ( count of required obligations )
```

### 16.5 Drift granularity for shared global surfaces (note)

Some write surfaces are shared and global (lockfiles, CI config, manifests, schemas). A naive per-surface hash would mark *every* obligation that declares such a surface `STALE` on any unrelated edit. v0.1 records the surface hashes as above; whether shared/global/append-only surfaces are exempted from blanket staleness (versus proof-exercised staleness) is governed by the `SURFACE` attribute mechanism (§18) and is refined in v0.2. v0.1 default: a declared write surface participates in the staleness check unless its `SURFACE` is attributed `append-only` or `shared`, in which case modification alone does not force `STALE` (the obligation's own `source_hash` change still does).

---

## 17. The soft/hard control boundary and the enforcement lane

This section states the single most important honesty constraint in Swarm. Everything Swarm ships is **markdown**. Markdown cannot stop an agent from doing anything. Therefore Swarm MUST be precise about what is *guidance* and what is *enforcement*, and MUST NOT dress up the former as the latter.

### 17.1 The hard boundary (normative)

> **Soft control.** Swarm prose, SOL, APS, skills/pass guides, heuristic profiles, and `AGENTS.md` are **SOFT control**: they are context and guidance for a model. They influence behaviour; they do not constrain it. They **MUST NEVER** be presented as enforcement.

> **Hard control.** Anything that must hold **regardless of the model** — a `CONSTRAINT`, an `INVARIANT`, a stop-rule, secret redaction, a write-surface gate, a proof-required merge gate — MUST be specified as a **deterministic check OUTSIDE the model**: a PreToolUse hook, a CI gate, a permission deny-rule, or a schema validator.

> **No runtime today.** Swarm is markdown-only (§2, Principle 1). The enforcement lane is therefore **aspirational/manual today**. The spec MUST NOT claim any deterministic check *exists* or *runs*. Every enforcement statement is framed as "the deterministic home a future harness MUST provide," never "Swarm enforces."

Three corollaries, each normative:

- **Structured/schema-valid output is not verification.** That a model emitted JSON matching a schema constrains *shape*, not *truth* (§15.9). Schema validation MAY be a gate input; it MUST NOT be presented as proof an obligation is met.
- **Every completion claim maps to independent verification.** No obligation is `PASS` on the model's say-so; it is `PASS` only against an independent deterministic or evidentiary oracle (§14, §15).
- **A SOFT-control artifact MUST NOT define hard semantics.** No skill, persona/profile, or `AGENTS.md` section may define modality, authority order, or verification semantics — those live in SOL and the typed IR (Q-semantics-1, §2). A regression check MUST confirm this (§34).

> Rationale (Q-enforcement-1): Anthropic's own guidance frames memory/instructions as "context, not enforced configuration" and points to a PreToolUse hook for anything that must hold. Multi-turn reliability decay and prompt-format sensitivity make a model an unsound enforcement substrate. Honesty about this boundary is what lets Swarm be trusted.

### 17.2 The enforcement-lane artifact (G4)

Swarm specifies a **first-class, currently-manual** artifact — the **enforcement lane** — that maps each hard-control obligation to its **eventual deterministic home**. It is the explicit ledger of "this is soft today; here is where it becomes hard." It MUST be maintained as a markdown table (no runtime).

Each row maps one `CONSTRAINT` / `INVARIANT` / stop-rule / secret-redaction rule to its deterministic home and current status:

```text
| Obligation / rule | Kind        | Deterministic home (eventual) | Status today |
| ----------------- | ----------- | ----------------------------- | ------------ |
| C-001 (no server/* import) | CONSTRAINT  | CI: cmdLint dependency-boundary  | manual review |
| I-001 (one token family)   | INVARIANT   | CI: property test in cmdTest     | manual review |
| stop-rule: no force-push    | stop-rule   | PreToolUse hook (git deny)       | aspirational  |
| secret redaction            | redaction   | PreToolUse hook + CI secret scan | aspirational  |
```

| Column | Meaning |
| --- | --- |
| Obligation / rule | The id or name of the hard-control item. |
| Kind | `CONSTRAINT` \| `INVARIANT` \| `stop-rule` \| `redaction`. |
| Deterministic home (eventual) | The PreToolUse hook / CI gate / permission deny / schema validator that WILL enforce it when a harness exists. |
| Status today | `manual review`, `aspirational`, or (when a harness exists) `enforced by <mechanism>`. |

The enforcement lane MUST NOT mark any row `enforced` unless a deterministic check outside the model genuinely runs it. Until then every hard-control obligation is honestly `manual review` or `aspirational`. The four deterministic-home categories are exactly: **PreToolUse hook**, **CI gate**, **permission deny-rule**, **schema validator**.

### 17.3 The WAIVER lifecycle (G5)

A `WAIVED` verdict (§14.1.2) is a recorded, accountable exception. Its lifecycle is normative:

- **Authority.** Waiver authority is a **human or the spec owner**. A skill, persona/profile, or the implementing agent acting on its own MUST NOT self-issue a waiver. The `authority` field names the issuing human or the spec owner.
- **Mandatory fields.** A `WAIVED` MUST carry **authority + reason + expiry** (`SOL-V005`, §14.3). An expiry is mandatory — there are **no permanent waivers**.
- **Auto-expiry on source-hash change.** A `WAIVED` verdict **auto-expires on the next source-hash change** of the waived obligation (the same `source_hash` tracked in §16.1). Once the obligation text changes, the prior acceptance no longer applies, and the verdict reverts to its underlying `FAIL`/`UNVERIFIED`. This is in addition to the explicit `expiry` date; whichever comes first wins.

> Rationale (G5): auto-expiry on source-hash change prevents **zombie waivers** — an exception granted against one version of an obligation silently carrying forward onto a materially different obligation. A waiver is consent to a *specific* failure of a *specific* obligation, not a standing exemption.

An expired or source-changed waiver MUST be re-evaluated: re-run the proof, re-issue the waiver against the new text (with a new reason), or fix the underlying `FAIL`/`UNVERIFIED`. The merge gate (§14.4) treats an expired waiver as its underlying blocking core value.

### 17.4 The CONTRADICTED resolution protocol (G6)

`CONTRADICTED` (§14.1.2) arises when two proofs disagree, or when a `TRACE`/code disagrees with the obligation. Its resolution is normative:

1. **Block at the merge gate.** A `CONTRADICTED` verdict on any required obligation blocks promotion (§14.4). Contradiction is never resolved by picking the more convenient result.
2. **Route to review.** The contradiction routes to the `review` pass (§9, §26). The reviewer MUST record both conflicting evidence refs (the two `EVIDENCE` lines required by `SOL-V005`).
3. **The stronger oracle is authoritative pending reconciliation.** Using the proof-strength order (§15.6, `model > property|contract > test > static > manual|monitor`), the **stronger** proof's result is treated as authoritative *while the contradiction is open*. This does not close the contradiction; it sets the working assumption so review is not paralysed. Example: if a `contract` proof says `PASS` and a `manual` judgment says `FAIL`, the `contract` result is presumptively authoritative, but the obligation stays `CONTRADICTED` (and gate-blocking) until reconciled.
4. **Reconcile.** Reconciliation re-runs the disagreeing proofs, fixes the weaker oracle (e.g. a misbuilt manual judgment or a flaky test), corrects the code, or amends the obligation — the same not-silent discipline as the 3-way reconcile (§16.3). Only when both proofs agree (or one is withdrawn as invalid with a recorded reason) is the `CONTRADICTED` decorator removed.

> Rationale (G6): blocking-plus-stronger-oracle keeps the gate honest (no silent pick-the-pass) while keeping review actionable (a working assumption exists). Placing executable oracles above an LLM-judge `manual` verdict reflects that judge bias is a known failure mode; an executable `model`/`contract`/`test` result is harder to fool than a narrative judgment.


## 18. Multi-agent orchestration and safe parallelism

### 18.1 Scope: the kernel owns a coordination contract, not a scheduler

Swarm MUST treat multi-agent coordination as a **static, recorded contract** that a reviewer or a future checker reads, never as a live scheduler the kernel executes. This is the orchestration projection of Principle 1 (NO RUNTIME, see §2): everything that would "run" agents — batching, dispatch, stall detection, replanning — is documented as a CONTRACT a future launcher builds against, and is never shipped by this repo.

Concretely, the kernel owns exactly four things and nothing more:

| # | Kernel-owned artifact | Where specified |
|---|---|---|
| 1 | Obligation-level scope declarations (`WRITES`, `READS`, `DEPENDS ON`, `AFFECTS`) as SOL surface fields | §18.2 |
| 2 | Two derived graphs the `lower` pass MUST emit (dependency DAG + write-surface conflict graph) | §18.4 |
| 3 | The single canonical safe-parallelism predicate | §18.5 |
| 4 | The recorded coordination artifact schema (`task-orchestration.md`) | §19 |

The boundary is fixed by decision-record Theme 6 / Q8.27 with one clause of rationale each: agents are **not yet reliable at real-time coordination** and coding parallelizes worse than research; the **write side stays single-threaded** (ADR 0010); safe concurrency reduces to **conflict-serializability** over declared access sets; and Magentic-One's `>2-cycle` replan is the runtime analogue of the recorded liveness marker (§19.5). The kernel records the contract those mechanisms operate on; it does not operate them.

Depth split (normative):

| Layer | Owns |
|---|---|
| **Kernel** | The four artifacts above: declarations, two graphs, the predicate, the artifact schema. |
| **Stdlib** | The `decompose` pass guide and the lead-engineer profile (§26, §27) that apply the contract. |
| **Launcher/harness (OUT of kernel)** | Anything that *runs* agents (§18.8). |

### 18.2 Obligation-level scope declarations (surface fields)

Every obligation block (REQ, CONSTRAINT, INVARIANT — see §6) MAY carry the four scope-declaration metadata clauses below. They are SOL **surface** syntax: UPPERCASE, space-separated, English-shaped, appended after the obligation body in the trailing-metadata position fixed by §5 (`DEPENDS ON / TOUCHES / WRITES / READS / AFFECTS / RISK`). The corresponding IR field is `snake_case` (§12); the surface↔IR split is master layering (conflict X4).

| Surface clause | IR field | Meaning | Graph contribution |
|---|---|---|---|
| `WRITES <surface-list>` | `writes[]` | The write surfaces (named SURFACEs or paths/globs) the obligation mutates. | Write-surface conflict graph (§18.4). |
| `READS <surface-list>` | `reads[]` | The read set the obligation depends on but does not mutate. | Read/write conflict edges (§18.6). |
| `DEPENDS ON <id-list>` | `depends_on[]` | Hard ordering: this obligation MUST be satisfied after the listed obligations. | Dependency DAG (§18.4). |
| `AFFECTS <id-list-or-surface>` | `affects[]` | The impact set: obligations or surfaces that may be perturbed but are not directly written. | Soft conflict edge (`affects`, §18.6). |

`AFFECTS` MUST be lowered to an `affects` edge in the IR, never folded into `writes` or `depends_on`. `DEPENDS_ON` (underscore) is **not** a surface keyword; it is a transcription of the IR edge type, and any source author writing `DEPENDS_ON` in `.swarm.md` MUST be flagged `SOL-S005`-adjacent (keyword-form error). The surface keyword is exactly `DEPENDS ON` (two words).

Worked example (surface):

```sol
REQ AC-014:
  WHEN refresh.token IS expired
  THE auth-client MUST request a new access token
  VERIFY BY test:cmdTest:tests/auth/test_refresh.py#test_expired_triggers_refresh
  DEPENDS ON AC-010
  WRITES auth.client.code
  READS auth.config
  AFFECTS AC-022
  RISK high
```

Lowered IR fragment (snake_case, §12):

```json
{
  "id": "REQ.auth-refresh.AC-014",
  "kind": "REQ",
  "writes": ["auth.client.code"],
  "reads": ["auth.config"],
  "depends_on": ["AC-010"],
  "affects": ["AC-022"]
}
```

with the relationships emitted as edges (the single source of relationship truth, §12), never duplicated as node scalars in the conflict analysis:

```json
{"from": "REQ.auth-refresh.AC-014", "to": "REQ.auth-refresh.AC-010", "type": "depends_on", "hard": true},
{"from": "REQ.auth-refresh.AC-014", "to": "REQ.auth-refresh.AC-022", "type": "affects", "hard": false}
```

### 18.3 Named SURFACEs and the no-`locks`-primitive rule

A **write surface** is a named coarse region declared with the SOL `SURFACE` statement. There is **no** `locks` primitive on either the surface or IR layer (conflict X4); a lock group **is** a named SURFACE, so lock-set analysis reduces to write-set analysis at surface granularity.

```ebnf
surface_def = "SURFACE" , ws , surface_name , ws , "=" , ws , surface_expr , [ ws , surface_attr ] , nl ;
surface_expr = glob | path | surface_name , { "," , surface_expr } ;
surface_attr = "[" , ( "append-only" | "integration" | "shared" ) , "]" ;
```

Example:

```sol
SURFACE auth.client.code = src/auth/client/**
SURFACE auth.config      = config/auth.yaml
SURFACE repo.lockfile    = package-lock.json [append-only]
SURFACE ci.config        = .github/workflows/** [shared]
SURFACE db.migrations    = migrations/** [integration]
```

An obligation's `WRITES` clause SHOULD reference named SURFACEs rather than raw globs, BECAUSE named surfaces make the conflict graph stable under file moves and let one attribute govern many obligations. An obligation MAY write a raw path; raw paths are treated as anonymous singleton surfaces for conflict analysis.

#### 18.3.1 SURFACE attributes (gap G7)

The optional `[attr]` tag changes how the safe-parallelism predicate (§18.5) and staleness (§16) treat the surface. This resolves gap G7; it is NORMATIVE in v0.1.

| Attribute | Conflict treatment | Staleness treatment | Typical surfaces |
|---|---|---|---|
| *(none)* | Ordinary exclusive write surface: any two obligations that both `WRITES` it conflict and serialize. | Modification after last PASS → `STALE` (§16). | Feature source, test files. |
| `append-only` | Concurrent appends do **not** conflict (no shared mutable region); the surface MUST NOT be edited in place. | An append MUST NOT mark unrelated proofs STALE; only a non-append edit triggers blanket staleness. | Lockfiles, changelogs, manifests. |
| `integration` | Writes serialize through a single dedicated integration step rather than blocking feature work; treated as a high-conflict surface routed to one worker/pass. | Modification marks STALE only obligations whose proof exercised the integration surface. | Migrations, shared schemas. |
| `shared` | Treated as a hidden high-conflict surface: writes serialize by default; never co-scheduled in a parallel batch. | Does NOT trigger blanket staleness across the whole spec; staleness is scoped to proof-exercised obligations. | CI config, project-wide manifests, global config. |

Rationale (terse): shared/global/append-only files (lockfiles, CI definitions, manifests) function as hidden high-conflict surfaces even when the visible feature work is disjoint; without an attribute the predicate would either over-serialize honest feature work or, worse, treat a lockfile touch as an ordinary write conflict and force a blanket re-verification. The attribute lets the predicate be correct in both directions.

### 18.4 The two derived graphs (lowering obligation)

The `lower` pass (§9, §11) MUST emit, from a parsed and normalized spec, exactly two coordination graphs into the IR `edges[]`:

1. **The dependency DAG** — built from every `DEPENDS ON` clause as `depends_on` edges. It MUST be acyclic; a cycle is an ORCHESTRATION-layer error (`SOL-O3xx`, see §8). Topologically sorting it yields the legal partial order of work.
2. **The write-surface conflict graph** — an undirected graph whose nodes are obligations and whose edges connect any two obligations that are **not write-disjoint** under the surface rules of §18.3 and the read rules of §18.6. Two obligations share an edge iff they write the same non-attribute surface, or write a `shared`/`integration` surface, or stand in a read/write conflict on the same surface.

These two graphs are the entire mechanical substrate of safe parallelism. The kernel emits them; it MUST NOT schedule against them. Any document or tool that presents these graphs as a live scheduler violates Principle 1 and §17.

```text
spec.swarm.md
   │  (lower)
   ├──► dependency DAG          (from DEPENDS ON)        → legal order
   └──► write-surface graph     (from WRITES / SURFACEs / READS) → safe batches
```

### 18.5 The safe-parallelism predicate (single, canonical)

There is exactly one safe-parallelism predicate in Swarm. Conformant tools and authors MUST use it verbatim; no alternative or relaxed predicate is permitted in v0.1.

> **Two work packets MAY run in parallel if and only if they are dependency-independent AND write-disjoint** — that is: neither is reachable from the other in the dependency DAG, **and** they share no write surface and no interface or migration node in the write-surface conflict graph. Anything unscoped or shared **serializes by default**.

Formally, for work packets `a` and `b`:

```text
parallel_safe(a, b)  ⇔
      ¬reachable_DAG(a, b) ∧ ¬reachable_DAG(b, a)        # dependency-independent
   ∧  writes(a) ∩ writes(b) = ∅                          # no shared write surface
   ∧  ¬shares_interface_or_migration(a, b)               # no shared boundary node
   ∧  ¬readwrite_conflict(a, b)                           # §18.6
```

Two defaults are normative and MUST NOT be weakened:

- **Unscoped serializes.** An obligation with no `WRITES` clause MUST be treated as conflicting with every other obligation (its write set is unknown, hence assumed maximal). It MUST NOT be co-scheduled in a parallel batch. Rationale: a missing scope is a hidden conflict, and the write side stays single-threaded by default (ADR 0010).
- **Shared serializes.** Any obligation touching a `shared` or `integration` SURFACE, or any INTERFACE/migration node, MUST serialize (§18.3.1).

Read-only passes (`lint`, `review`, and any pass that declares only `READS`) MAY run broadly in parallel, because read/read never conflicts (§18.6).

### 18.6 The READS conflict rule (gap G7)

Read/write coordination follows **conflict-serializability** semantics. This resolves gap G7 and is NORMATIVE in v0.1.

| Pair on the same surface | Conflict? | Edge emitted |
|---|---|---|
| read / read | No — always parallel-safe | none |
| read / write | **Yes** — conflict | conflict edge in the write-surface graph |
| write / write | **Yes** — conflict | conflict edge in the write-surface graph |

That is: two obligations that both only `READS` a surface MUST be schedulable in parallel; but if one `READS` a surface that another `WRITES`, they MUST be connected by a conflict edge and serialized (the reader either runs strictly before or strictly after the writer in the DAG order). Reads on *different* surfaces never conflict. `AFFECTS` contributes a soft `affects` edge that the predicate treats as advisory (a reviewer signal), not as a hard conflict, unless the affected surface also appears in a `WRITES` set.

Worked example: `AC-014` (`READS auth.config`) and `AC-031` (`WRITES auth.config`) MUST be serialized; `AC-014` (`READS auth.config`) and `AC-040` (`READS auth.config`) MAY run in parallel.

### 18.7 Orchestration lint codes

Two ORCHESTRATION-layer lint codes (`SOL-O3xx`, §8) govern the coordination contract. Both are NORMATIVE in v0.1.

| Code | Layer | Severity | Triggers when |
|---|---|---|---|
| `SOL-O301` | ORCHESTRATION | **ERROR** | Two obligations sharing a write surface (a conflict edge in the write-surface graph) are marked for, or scheduled into, the same parallel batch. |
| `SOL-O305` | ORCHESTRATION | **ERROR** | A worker's OWNED path in `task-orchestration.md` falls outside the union of that worker's assigned obligations' declared `WRITES` surfaces (the two-tier lowering check, §19.7). |

`SOL-O301` is raised from Warning to **ERROR** in this kernel (decision-record Theme 6): a write-conflict marked parallel is the precise failure that produces silent, hard-to-review merge corruption, so it MUST block. `SOL-O305` is the new code that enforces the disjoint-scope invariant between the source tier and the execution tier (§19).

```text
SOL-O301  ERROR  AC-014 and AC-031 both WRITES auth.config but share parallel_group "g1"
          suggest: serialize (add DEPENDS ON), split the surface, or drop the shared group
SOL-O305  ERROR  worker "auth-core" owns src/auth/server/** which is outside its obligations'
          declared WRITES {auth.client.code}; either re-scope the worker or add the WRITES surface
```

### 18.8 Out of the kernel (the optional launcher/harness)

The following are explicitly OUT of the kernel and MUST be documented, where they appear at all, as launcher/harness concerns a future tool MAY build against the kernel contract — never as something this repo ships (Principle 1, §17):

| Out-of-kernel concern | Why deferred |
|---|---|
| Live scheduling / batching of work packets | Requires a runtime; the kernel emits the graphs a scheduler would consume, not the scheduler. |
| Real-time stall detection and automatic replan | The kernel records the liveness marker + threshold + action (§19.5); detecting and acting on it in real time is the Magentic-One-style runtime analogue, deferred. |
| Inter-agent wire protocols (A2A / MCP) | Transport between running agents; no markdown artifact, no kernel surface. |
| SDK delegation primitives | Spawning/handing off live agents; agents are not yet reliable at real-time coordination, so the kernel records the *contract*, not the call. |

A conformant Swarm repo MUST NOT claim any of the above exists. It MUST present the dependency DAG, conflict graph, and predicate as *inputs a launcher could one day consume*, and the coordination artifact (§19) as the recorded contract a human (or eventual checker) reads.

---

## 19. The coordination artifact

### 19.1 Purpose and identity

`task-orchestration.md` is the single canonical **recorded coordination contract** for any multi-agent (orchestration) task. It is a plain `.md` working artifact (§20, §21): it is human/agent-authored, not compiler-emitted, and carries no `.swarm.` infix. It is the execution-tier counterpart of the source-tier scope declarations (§18.2): where the source spec declares `WRITES`/`READS`/`DEPENDS ON`/`AFFECTS` per obligation, the coordination artifact projects those declarations onto **workers** and records the hand-off, liveness, and merge contract a reviewer can reconstruct the whole run from. It is governed by ADR 0025.

A conformant orchestration task file MUST contain the sections in §19.2–§19.6. Each is a recorded contract a reviewer (or a future checker, §32) reads; none is a runtime.

### 19.2 Worker tracker: OWNED and FORBIDDEN paths (the disjoint-scope invariant)

The worker tracker is a table with one row per worker. Two columns are load-bearing:

- **OWNED paths** — the file/glob projection of that worker's assigned obligations' `WRITES` surfaces (§18.2). The set of OWNED paths across all workers MUST be **pairwise non-overlapping**. This pairwise-disjointness IS the disjoint-scope invariant on which write-side parallel safety rests (ADR 0010, §18.5).
- **FORBIDDEN paths** — the union of every *other* worker's OWNED paths. A worker MUST NOT write outside its OWNED set; the FORBIDDEN column makes the boundary explicit and reviewable rather than implicit.

```markdown
## Worker tracker

| Worker | Source doc | Task kind | Profile | OWNED paths | FORBIDDEN paths | Hand-off (deliverable / acceptance bar) | Branch | Status | Last progress | Last verdict |
| ------ | ---------- | --------- | ------- | ----------- | --------------- | --------------------------------------- | ------ | ------ | ------------- | ------------ |
| auth-client | auth-refresh.swarm.md | implement | builder | src/auth/client/** | src/auth/server/**, migrations/** | refresh-on-expiry works; AC-014 PASS | feat/auth-client | in-progress | 2026-05-31 grafted token store | — |
| auth-server | auth-refresh.swarm.md | implement | builder | src/auth/server/** | src/auth/client/**, migrations/** | issuer rotation; AC-021 PASS | feat/auth-server | awaiting-review | 2026-05-31 endpoint done | PASS |
```

Status values MUST be drawn from: `not-started`, `in-progress`, `stalled`, `awaiting-review`, `kicked-back`, `merged`, `abandoned`. The pairwise-disjointness of OWNED paths MUST be confirmed *before* spawning any worker; if two sub-tasks need the same file they are not independent and MUST be sequenced (a `DEPENDS ON` edge / serial order), not parallelized.

### 19.3 The hand-off contract (per worker)

Each worker row carries a **hand-off contract** — the four fields below. This is what defeats "vague subtask descriptions," the field's named #1 multi-agent failure mode (MAST: specification + verification account for ~79% of multi-agent failures), so it MUST be recorded, not left to prose.

| Hand-off field | Meaning |
|---|---|
| **Objective** | The single outcome the worker must produce. |
| **Expected deliverable** | The concrete artifact/branch the worker hands back. |
| **Acceptance bar** | The verdict the lead will review against (the obligations that MUST reach PASS, §14). |
| **Boundaries** | The OWNED/FORBIDDEN paths (§19.2) plus any preserved constraints/invariants. |

### 19.4 The `## Parent contract` section (inherited into each child task)

When the lead spawns a worker, the worker's task file MUST contain a `## Parent contract` section carrying that worker's hand-off contract verbatim. This mirrors the existing Scope In / Scope Out discipline: the child inherits its objective, deliverable, acceptance bar, and boundaries from the parent's worker tracker, so the boundary the lead recorded and the boundary the worker sees are the same text.

```markdown
## Parent contract

- Objective: implement refresh-on-expiry in the auth client.
- Expected deliverable: branch `feat/auth-client` with AC-014 implemented.
- Acceptance bar: AC-014 reaches VERDICT PASS (VERIFY BY test:cmdTest:...).
- Boundaries:
  - OWNED: `src/auth/client/**`
  - FORBIDDEN: `src/auth/server/**`, `migrations/**`
  - PRESERVE: I-003 (no unbounded retry), IF-002 (token-store interface)
```

A worker MUST NOT write outside its `## Parent contract` boundaries; doing so is the execution-tier violation caught by `SOL-O305` (§18.7, §19.7).

### 19.5 Liveness marker, STALL threshold, and STALL action

The coordination artifact MUST record liveness as data, because a worker hung `in-progress` or silently diverging is otherwise an invisible state (the kernel has no runtime to detect it).

- **LIVENESS marker** — the `Last progress` column. The lead updates it each time it checks the worker.
- **STALL threshold** — a worker whose `Last progress` has **not advanced across two consecutive checks** is `stalled`. The two-consecutive-checks rule mirrors Magentic-One's `>2-cycle` replan heuristic; it is the recorded form of that runtime signal.
- **STALL action** — on `stalled`, the lead MUST take one recorded action: **re-plan**, **re-scope**, **escalate**, or **abandon**. The chosen action and its rationale MUST be written to a `## Decisions` section so the run is reconstructable.

```markdown
## Decisions

| When | Worker | Trigger | Action | Rationale |
| ---- | ------ | ------- | ------ | --------- |
| 2026-05-31 | auth-server | stalled (2 checks, no progress) | re-scope | endpoint coupling was underestimated; split into AC-021a/b |
```

This is a recorded contract a future launcher could automate, not a stall detector the kernel runs (§18.8).

### 19.6 The merge log and the INTENT-PRESERVED-PROOF column

The merge log records the order branches were merged, conflicts encountered, and how each was resolved — a reconstructable history. It MUST carry an **INTENT-PRESERVED-PROOF** column for every non-trivial conflict resolution.

```markdown
## Merge log

| Order | Worker | Merged into | Conflicts | Resolution | INTENT-PRESERVED-PROOF |
| ----- | ------ | ----------- | --------- | ---------- | ---------------------- |
| 1 | auth-server | main | none | fast-forward | suite green (no conflict) |
| 2 | auth-client | main | token-store init | kept both init paths, guarded by config | property check on token-store equivalence + AC-014/AC-021 re-run PASS |
```

The INTENT-PRESERVED-PROOF column MUST show that the conflict resolution kept **both** sides' intent — not merely that the suite passed. "Tests pass on the merged branch" is necessary but, where the suite may not cover the interaction, **not sufficient** (this is the §14 rule that schema-valid/green output is not verification, applied to merges). For refactor, migration, and merge conflicts the recommended equivalence oracle is a **property**, **differential**, or **metamorphic** check (a `property` or `contract` proof type, §15) on the conflicted region, BECAUSE these check behavioral equivalence directly rather than relying on a suite that may miss the interaction. A trivial (no-conflict / fast-forward) merge MAY record the green suite alone.

### 19.7 The lowering rule tie (OWNED ⊆ WRITES; violation = `SOL-O305`)

The execution tier and the source tier are tied by one normative lowering rule:

> A worker's OWNED paths MUST be a subset of the union of its assigned obligations' declared `WRITES` surfaces (lowered to file/glob projection).

A violation — a worker owning a path outside its obligations' declared write surfaces — is `SOL-O305` (§18.7), an ERROR. The fix is either to re-scope the worker (shrink OWNED) or to add the surface to the obligation's `WRITES` clause in the source spec (widen the declared write set). The lead MUST NOT silently let a worker write outside the declared surfaces, BECAUSE that is exactly the hidden write that the conflict graph cannot see and the disjoint-scope invariant cannot protect.

The relationship between the tiers, end to end:

```text
source tier (.swarm.md)         execution tier (task-orchestration.md)
  obligation.WRITES  ──project──► worker.OWNED   (subset; else SOL-O305)
  obligation.DEPENDS ON ─────────► merge order (partial order from the DAG, §18.4)
  write-surface conflict graph ──► OWNED paths pairwise disjoint (§18.2)
```

`DEPENDS ON` edges lower to the **merge-order partial order** (a branch MUST be merged after the branches it depends on); the write-surface conflict graph is the proof that the workers' OWNED paths are pairwise disjoint. Together these make the decomposition correctness — the property that makes parallel writes safe — re-derivable from the artifact alone rather than held in the lead's head.


## 20. The artifact set and conformance definition

This section defines the complete set of files a Swarm repository may contain, partitions them into two normative classes by the `.swarm.` filename infix, enumerates the canonical filenames in each class, and fixes the tiered required-artifact set on which conformance is defined. The per-artifact *contracts* and copyable *templates* are specified in §21; the mechanically-checkable conformance procedure is specified in §32.

### 20.1 The `.swarm.` infix rule (normative)

Swarm partitions every repository file that participates in the pipeline into exactly two classes, discriminated by whether the filename carries the literal infix `.swarm.` before its final extension.

| Class | Rule | Meaning |
| --- | --- | --- |
| Compiler-visible | The filename MUST contain the `.swarm.` infix (e.g. `auth.swarm.md`, `auth.swarm.ir.json`). | The file is *parsed or emitted by the compiler*. It is either the human-authored SOL source or a contract-shaped output a future tool produces. Its byte content is subject to the SOL grammar (§5–§6) or the IR/plan JSON schemas (§12–§13, Appendix C). |
| Working artifact | The filename MUST NOT contain `.swarm.` and uses a plain `.md` extension (e.g. `task.md`, `review.md`). | The file is a *human/agent working artifact*: a lowered work packet, a verdict record, a durable fact, a decision, or a recall map. It is structured Markdown governed by an artifact contract (§21), not by the SOL grammar, though it MAY embed SOL blocks (notably VERDICT and TRACE) as quoted data. |

A conformant Swarm tool MUST treat the `.swarm.` infix as the sole, sufficient discriminator for "do I parse/emit this": it MUST NOT attempt to parse a plain `.md` working artifact as a SOL source, and it MUST NOT emit a compiler output to a path lacking the infix. *Rationale (Q2.8):* the double-extension convention (`.test.ts`, `.d.ts`) lets tooling select files by a stable, greppable suffix without content inspection.

The only human-authored `.swarm.` artifact is `*.swarm.md` (the source spec). The three `.swarm.*.json`/`.swarm.trace.md` variants are *emitted* artifacts; see §20.2.2.

### 20.2 Canonical filenames by class

#### 20.2.1 Compiler-visible artifacts (`.swarm.` infix)

| Filename pattern | Role | Authored by | Schema / grammar | Status in v0.1 |
| --- | --- | --- | --- | --- |
| `*.swarm.md` | Source spec — prose (APS) interleaved with SOL blocks. | Human / authoring agent | SOL surface grammar (§5–§6), APS prose standard (§7) | Live; the only hand-written `.swarm.` file. |
| `*.swarm.ir.json` | Emitted intermediate representation (the obligation graph). | Compiler (future tool) | IR envelope (§12, Appendix C) | **Reserved contract name.** Not written by any shipped tool in v0.1. |
| `*.swarm.plan.json` | Emitted plan (lowered, schedulable work packets + graphs). | Compiler/planner (future tool) | Plan envelope (§13) | **Reserved contract name.** Not written by any shipped tool in v0.1. |
| `*.swarm.trace.md` | Emitted/instantiated trace for a built spec. | Implement/verify pass (today: agent by hand) | Trace contract (§21.4) + §16 provenance | Copyable template is `trace.md` (plain); built *instances* MAY take the `*.swarm.trace.md` name. |

The `.json` variants are **documented-as-contract names only** (Q3.11): the kernel pins their shape so a future launcher can build against a stable target, but Swarm ships no parser, emitter, planner, or checker (Invariant 1, NO RUNTIME — see §2). A v0.1 repository MUST NOT claim that any `*.swarm.ir.json` or `*.swarm.plan.json` is produced by a Swarm tool; it MAY contain hand-written examples in the golden corpus (§33).

#### 20.2.2 Working artifacts (plain `.md`)

| Filename | Role | Template tier (§20.3) |
| --- | --- | --- |
| `task.md` | Lowered work packet / pass frame for one pass (§28). | Core (required) |
| `trace.md` | Implementation/preservation claims + evidence against obligations. | Core (required) |
| `review.md` | The verdict record: per-obligation VERDICT blocks + matrix + final verdict. | Core (required) |
| `finding.md` | One durable, provenance-anchored project fact. | Core (required) |
| `adr.md` | An immutable architecture decision record (Nygard form). | Core (required) |
| `memory/INDEX.md` | Compact recall map (links + a "Load when" per entry). | Core (required) |
| `memory/glossary.md` | One-word-one-meaning term store. | Memory model (§23) |
| `memory/patterns/*.md` | Recurring multi-finding knowledge. | Memory model (§23) |
| `audit.md` | Observation-only source artifact; promotes to a spec. | Stdlib source-doc (conditional) |
| `research.md` | Investigation source artifact; promotes to a spec. | Stdlib source-doc (conditional) |
| `bug-report.md` | Diagnosis-only source artifact; promotes into a fix *task*. | Stdlib source-doc (conditional) |

#### 20.2.3 There is NO `verdict.md` (normative)

A repository MUST NOT contain a standalone `verdict.md` artifact, and no tool MAY emit one. `VERDICT` is a SOL *language block* (§6), not a file; `review.md` is its canonical *container* (§21.5). *Rationale (Q2.9):* a verdict is the output of the review pass, exactly as a SARIF `result` lives inside a `run` and never as a free-standing file. The kernel ships documentation of the VERDICT block and the verdict taxonomy (§14) as a reference page, not as a copyable artifact template.

### 20.3 The tiered required-artifact set

The required set is partitioned into three tiers. Only Tiers 1 and 2 are load-bearing for conformance; Tier 3 is shipped but conditional.

#### 20.3.1 Tier 1 — kernel-required pipeline core (contract + copyable template each)

Seven artifacts. Each MUST ship both (a) a documented contract (the required sections/fields and their meaning) and (b) a copyable template skeleton. All seven contracts and templates are given in §21.

| # | Artifact | Class | Pipeline role |
| --- | --- | --- | --- |
| 1 | `spec.swarm.md` | compiler-visible | Source of obligations. |
| 2 | `task.md` | working | Lowered pass frame. |
| 3 | `trace.md` | working | Implementation claims + evidence. |
| 4 | `review.md` | working | Verdict record (verdict container). |
| 5 | `finding.md` | working | Durable fact (memory Tier-2 evidence). |
| 6 | `adr.md` | working | Immutable decision. |
| 7 | `memory/INDEX.md` | working | Recall map (memory Tier-1). |

#### 20.3.2 Tier 2 — kernel-required language / reference docs (not templates)

Six reference documents. These are *prose-and-table reference pages*, not copyable artifact templates; a conformant repo MUST contain a self-contained copy of each so the repository explains its own language without external dependency.

| # | Reference doc | Defines | Spec home |
| --- | --- | --- | --- |
| 1 | SOL reference | Surface syntax + block-type reference. | §5–§6 |
| 2 | APS reference | The controlled-prose standard. | §7 |
| 3 | Error / lint taxonomy | The `SOL-<LAYER><NNN>` catalogue with stable codes + severities. | §8, Appendix B |
| 4 | Source-authority | The two-axis authority model + tie-break. | §22 |
| 5 | Promotion-protocol | The promotion statuses + workflow. | §23 |
| 6 | Distillation-loss-budget | The Preserved/Dropped/Still-uncertain discipline + loss accounting. | §24 |

#### 20.3.3 Tier 3 — stdlib source-doc templates (shipped, conditional)

Three source-document templates the stdlib ships so common authoring entry points exist. They are *conditional*: a repo need not have instantiated any of them to be conformant, but a conformant scaffold MUST ship the templates.

| # | Template | Epistemic stance | Promotes to |
| --- | --- | --- | --- |
| 1 | `audit.md` | Observation-only (records what *is*, never prescribes). | a `spec.swarm.md` (via author pass). |
| 2 | `research.md` | Investigation (open questions + findings). | a `spec.swarm.md` (via author pass). |
| 3 | `bug-report.md` | Diagnosis-only (root cause, never fix). | a fix `task.md` (`task_kind: fix`). |

### 20.4 The conformance definition (normative)

A repository is **Swarm-conformant** if and only if all of the following hold:

1. It contains a self-contained copy of all six **Tier-2 language/reference docs** (§20.3.2).
2. It contains a copyable template for each of the seven **Tier-1 core artifacts** (§20.3.1), and each template satisfies its §21 contract.
3. It contains a **populated `AGENTS.md` bootloader** (§31) — not an empty placeholder — within the ≤200-line / ≤25 KB density cap (§2, §17).
4. It contains the framework version file **`.agents/.swarm-version`** (§25), carrying a valid semver.

A repository that omits any of the four MUST NOT be described as Swarm-conformant. Conditional artifacts (Tier 3) and the reserved `.swarm.*.json` contract files are **not** required for conformance. The full mechanically-checkable conformance contract — the exact checks, their inputs, and the deferral of an automated checker to a future CLI — is given in §32; the golden corpus that exercises it is given in §33.

---

## 21. Artifact contracts and templates

This section gives, for each of the seven Tier-1 core artifacts, (a) its **contract** — the required sections/fields and what each means — and (b) a copyable **template skeleton** as a fenced block. Brief notes follow for the three Tier-3 stdlib source-docs. Surface fields in templates use the canonical space-separated uppercase SOL keywords; frontmatter uses the normalized field names fixed in G10 (`swarm_language: SOL/0.1`, `aps_version: 0.1`, `spec_version: 0.1.0`). Templates reuse the swarm-rework.md skeletons (§17–§23 there) wherever the decision record affirms them, upgraded to the canonical vocabulary of §4 (7-value verdicts, `VERIFY BY <type>:<adapter>:<artifact>`, provenance fields).

### 21.1 General template conventions (normative)

- Every artifact MUST carry YAML frontmatter delimited by `---` with at minimum a `type` field naming the artifact and an `id`.
- Placeholder tokens use `{{...}}`. A shipped, *uninstantiated* template MUST NOT leave a binding clause as a `{{...}}` placeholder inside a populated artifact; an unfilled `VERIFY BY` placeholder in a built artifact is a `SOL-V001` defect (§8).
- Tables are the required carrier for every matrix (verification, obligation-verdict, promotion queue). A row whose status cell is empty in a *built* artifact is treated as `UNVERIFIED`.
- Surface SOL blocks embedded in a working artifact (TRACE in `trace.md`, VERDICT in `review.md`) are quoted SOL data and MUST obey the SOL block grammar (§6).

### 21.2 `spec.swarm.md` — the source spec

#### 21.2.1 Contract

A spec is a behavioral contract: APS prose interleaved with SOL obligation blocks, which compiles into the obligation graph. A conformant `spec.swarm.md` MUST contain the following sections, in order:

| Section | Meaning | Carries |
| --- | --- | --- |
| frontmatter | Identity + the two version axes. | `type: spec`, `id`, `swarm_language: SOL/0.1`, `aps_version`, `spec_version`, `status`, `created`, `updated`. |
| `## Intent` | One paragraph: the user- or system-visible outcome. | APS prose. |
| `## Non-goals` | Explicit out-of-scope, to bound interpretation. | APS prose / bullets. |
| `## Context` | Only load-bearing background; links, not pastes. | APS prose + links to findings/ADRs/audits. |
| `## Interfaces` | Boundary declarations. | `INTERFACE` blocks (each MUST bind `VERIFY BY contract:…`, §15). |
| `## Obligations` | The binding behavioral requirements. | `REQ` blocks. |
| `## Constraints` | Forbidden actions / restrictions. | `CONSTRAINT` blocks. |
| `## Invariants` | Properties that must hold. | `INVARIANT` blocks (prefer `property\|model\|static` proofs). |
| `## Questions` | Captured ambiguity. | `QUESTION` blocks (`blocking` ones MUST be resolved before lowering, §11). |
| `## Verification coverage` | Per-obligation proof binding, at a glance. | Table: ID → `VERIFY BY` reference. |
| `## Downstream tasks` | Which task frames cover which obligations. | Table: Task → Covers. |
| `## Distillation loss statement` | Preserved / Dropped / Still-uncertain (§24). | Three subsections. |

#### 21.2.2 Template

```markdown
---
type: spec
id: {{slug}}
swarm_language: SOL/0.1
aps_version: 0.1
spec_version: 0.1.0
status: draft
created: {{createdAt}}
updated: {{createdAt}}
---

# Spec: {{title}}

## Intent

State the user-visible or system-visible outcome in one paragraph.

## Non-goals

- Explicitly out of scope.

## Context

Only load-bearing background. Link research, findings, ADRs, audits — do not paste them.

## Interfaces

INTERFACE IF-001:
RETURNS <type>
ACCEPTS <type>
ERRORS <error-set>
OWNED BY <owner>
VERIFY BY contract:<adapter>:<artifact>

## Obligations

REQ AC-001:
WHEN <trigger>
THE <actor> MUST <observable response>
VERIFY BY test:<adapter>:<artifact>[#selector]
WRITES <surface>
RISK medium

## Constraints

CONSTRAINT C-001:
THE <actor/surface> MUST NOT <forbidden action>
VERIFY BY static:<adapter>:<artifact>

## Invariants

INVARIANT I-001:
<state/property> MUST <hold>
VERIFY BY property:<adapter>:<artifact>

## Questions

QUESTION Q-001 [blocking]:
<question>
AFFECTS <id-or-surface>

## Verification coverage

| ID     | VERIFY BY                          |
| ------ | ---------------------------------- |
| AC-001 | test:<adapter>:<artifact>          |
| C-001  | static:<adapter>:<artifact>        |
| I-001  | property:<adapter>:<artifact>      |
| IF-001 | contract:<adapter>:<artifact>      |

## Downstream tasks

| Task | Covers |
| ---- | ------ |
|      |        |

## Distillation loss statement

### Preserved

### Dropped

### Still uncertain
```

### 21.3 `task.md` — the pass frame

#### 21.3.1 Contract

A task is a *pass frame and execution companion*: the lowered work packet for one pass over assigned source. `task_kind` is a frontmatter enum that parameterizes which pass runs (forward-ref §28). The frontmatter MUST carry the orchestration scope fields so the lowering pass can prove disjointness (§18): `assigned_obligations`, `write_surfaces`, `verification_bindings`, plus the coordination fields `parallel_group`, `blocked_by`. A conformant `task.md` MUST contain:

| Section | Meaning |
| --- | --- |
| frontmatter | `type: task`, `id`, `status`, `task_kind` (enum), `source`, `assigned_obligations`, `constraints`, `invariants`, `interfaces`, `write_surfaces`, `verification_bindings`, `parallel_group`, `blocked_by`, `produces`. |
| `## Parent contract` | The inherited hand-off contract (Q8.27): objective + deliverable + acceptance bar + boundaries (owned vs forbidden paths). |
| `## Scope` | An explicit **In / Out** list bounding the pass. |
| `## Assigned obligations` | The exact assigned SOL blocks, pasted verbatim. |
| `## Constraints and invariants` | The SOL blocks this task MUST preserve. |
| `## Implementation or pass trace` | What changed, per obligation. |
| `## Verification matrix` | Required proof → actual proof → 7-value status, per obligation. |
| `## Promotion queue` | Discoveries with target + promotion status (§23); all MUST be resolved before task close. |
| `## Self-review` | The structured self-review block (did I do only this pass; preserve semantics; map every claim to evidence). |

`write_surfaces` MUST be a subset of the assigned obligations' `WRITES` surfaces; an owned path outside a declared write surface is a `SOL-O305` defect (§8, G7).

#### 21.3.2 Template

```markdown
---
type: task
id: {{slug}}
status: active
task_kind: feature | fix | refactor | rewrite | migration | upgrade | performance | testing | documentation | spec-writing | research-writing | audit-writing | bug-report-writing | review | orchestration | integration | deepen-audit
source:
assigned_obligations:
constraints:
invariants:
interfaces:
write_surfaces:
verification_bindings:
parallel_group:
blocked_by:
produces:
created: {{createdAt}}
---

# Task: {{title}}

## Parent contract

| Field        | Value |
| ------------ | ----- |
| Objective    |       |
| Deliverable  |       |
| Acceptance bar |     |
| Owned paths  |       |
| Forbidden paths |    |

## Scope

### In

-

### Out

- Do not implement unassigned obligations.
- Do not change behavior outside the assigned write surfaces.
- Do not weaken constraints, invariants, or non-goals.

## Assigned obligations

Paste the exact assigned SOL blocks here.

## Constraints and invariants

Paste all constraints and invariants this task must preserve.

## Implementation or pass trace

| Obligation / target | Files changed | How satisfied |
| ------------------- | ------------- | ------------- |
|                     |               |               |

## Verification matrix

| Obligation / C / I | Required proof | Actual proof | Status |
| ------------------ | -------------- | ------------ | ------ |
|                    |                |              | PASS / FAIL / BLOCKED / UNVERIFIED |

## Promotion queue

| Item | Target | Status |
| ---- | ------ | ------ |
|      |        | pending / promoted / deferred / rejected / blocked |

## Self-review

<self_review>

- Did I perform only the assigned pass?
- Did I preserve all assigned SOL semantics?
- Did I map every completion claim to evidence?
- Did I avoid changes outside the declared write surfaces?
- Did I resolve every promotion item?
- What remains BLOCKED or UNVERIFIED?

</self_review>
```

### 21.4 `trace.md` — implementation claims

#### 21.4.1 Contract

A trace records implementation *claims* against obligations and binds them to *evidence*. Its core payload is one or more `TRACE` blocks (`IMPLEMENTS` / `PRESERVES` / `CHANGED` / `PROOF`, §6) plus the drift-provenance fields from §16 that the staleness join depends on. A conformant `trace.md` MUST contain:

| Section | Meaning |
| --- | --- |
| frontmatter | `type: trace`, `id`, `source_task`, `source_spec`, `created`. |
| `## Claimed implementation` | The `TRACE` blocks. |
| `## Provenance` | The §16 / G11 fields **per binding**: `source_hash` (obligation content hash at PASS), `per_surface_hash[]` (each declared `WRITES` file hash/SHA), `adapter`, `verdict`, `tier`, `timestamp`. These are what flips a PASS to `STALE` when source or surface drifts (§16). |
| `## Verification matrix` | ID → required proof → actual proof → 7-value status. |
| `## Unassigned changes` | Any change outside assigned obligations, with reason + authorizing ID or `none`. |
| `## Promotion items` | Discoveries to promote, with target + status. |

#### 21.4.2 Template

```markdown
---
type: trace
id: {{slug}}-trace
source_task: .agents/tasks/{{slug}}.md
source_spec: {{spec-id}}.swarm.md
created: {{createdAt}}
---

# Trace: {{title}}

## Claimed implementation

TRACE T-001:
IMPLEMENTS AC-001
PRESERVES C-001
CHANGED <path>
PROOF <verification output reference>

## Provenance

| Binding | source_hash | per_surface_hash[] | adapter | verdict | tier | timestamp |
| ------- | ----------- | ------------------ | ------- | ------- | ---- | --------- |
| AC-001  |             |                    |         | PASS    |      |           |

## Verification matrix

| ID     | Required proof | Actual proof | Status |
| ------ | -------------- | ------------ | ------ |
| AC-001 |                |              | PASS / FAIL / BLOCKED / UNVERIFIED |

## Unassigned changes

| Change | Reason | Authorized by |
| ------ | ------ | ------------- |
|        |        | AC/C/I/IF ID or `none` |

## Promotion items

| Discovery | Target | Status |
| --------- | ------ | ------ |
```

### 21.5 `review.md` — the verdict record

#### 21.5.1 Contract

A review compares trace claims against obligations, constraints, invariants, diffs, and verification evidence. **This artifact IS the verdict record** (Q2.9): it is the canonical container of `VERDICT` blocks, and there is no `verdict.md` (§20.2.3). A conformant `review.md` MUST contain:

| Section | Meaning |
| --- | --- |
| frontmatter | `type: review`, `id`, `source_trace`, `source_spec`, `reviewed_output`, `pass`, `profile` (e.g. `skeptic`), `created`. |
| `## Per-obligation verdicts` | One `VERDICT` block per judged obligation, using the canonical verdict line: `VERDICT <id>: <CORE> [(<lifecycle> by <authority>: <reason>)]` plus `REASON` / `EVIDENCE`. Core ∈ {PASS, FAIL, BLOCKED, UNVERIFIED}; lifecycle ∈ {WAIVED, STALE, CONTRADICTED} (§14). |
| `## Obligation-verdict matrix` | A compact table of every obligation ID → core verdict → lifecycle → evidence checked. |
| `## Constraint and invariant verdicts` | The same, for `C-` and `I-` IDs. |
| `## Unauthorized changes` | Every change not traceable to an authorizing obligation, judged allowed / suspect / reject. |
| `## Final verdict` | The merge-gate result: merge iff every required obligation is `PASS` or `WAIVED`, none `STALE`/`CONTRADICTED`/`FAIL`/`BLOCKED`/`UNVERIFIED` (§14). |
| `## Promotion queue` | Items to promote, with target + status. |

A WAIVED verdict MUST name authority + reason + expiry; a STALE verdict MUST cite the prior-verdict ref + changed surface; a CONTRADICTED verdict MUST cite the two conflicting evidence refs (§14).

#### 21.5.2 Template

```markdown
---
type: review
id: {{slug}}-review
source_trace: {{slug}}-trace
source_spec: {{spec-id}}.swarm.md
reviewed_output:
pass: review
profile: skeptic
created: {{createdAt}}
---

# Review: {{title}}

## Per-obligation verdicts

VERDICT AC-001: PASS
REASON <why this core verdict>
EVIDENCE <proof artifact / output reference>

VERDICT AC-002: FAIL (WAIVED by {{authority}}: {{reason}}; expires {{date}})
REASON <why>
EVIDENCE <reference>

## Obligation-verdict matrix

| Obligation | Core verdict | Lifecycle | Evidence checked |
| ---------- | ------------ | --------- | ---------------- |
| AC-001     | PASS         | —         |                  |
| AC-002     | FAIL         | WAIVED    |                  |

## Constraint and invariant verdicts

| ID    | Core verdict | Lifecycle | Evidence checked |
| ----- | ------------ | --------- | ---------------- |
| C-001 | PASS         | —         |                  |
| I-001 | PASS         | —         |                  |

## Unauthorized changes

| Change | Authorized by          | Verdict |
| ------ | ---------------------- | ------- |
|        | AC/C/I/IF ID or `none` | allowed / suspect / reject |

## Final verdict

Merge gate: PASS / BLOCKED
(merge iff every required obligation is PASS or WAIVED; none STALE/CONTRADICTED/FAIL/BLOCKED/UNVERIFIED)

## Promotion queue

| Item | Target | Status |
| ---- | ------ | ------ |
```

### 21.6 `finding.md` — a durable fact

#### 21.6.1 Contract

A finding is one durable, provenance-anchored project fact discovered during work; it is the Tier-2 evidence store the memory index (§23) links into. Every promoted finding MUST carry the full provenance set (Q8.26) so its staleness can be computed and its applicability scoped. A conformant `finding.md` MUST contain:

| Field / section | Meaning |
| --- | --- |
| `status` (frontmatter enum) | `candidate \| accepted \| promoted \| rejected \| stale \| superseded`. Goes `stale` when `content_hash` no longer matches the cited source/surfaces (§16). |
| `## Claim` | The one durable fact. |
| `## Evidence` | File / command / output / source references. |
| provenance fields | `origin_obligations[]`, `origin_traces[]`, `pass` + `profile`, `reviewer_or_tool`, `timestamp`, `content_hash`, `confidence`. |
| `## Applies when` / `## Does not apply when` | Scope conditions (mandatory; if it cannot name when it applies, it MUST NOT be promoted). |
| `## Promotion target` | The promotion route (spec / audit / ADR / memory pattern / keep-scoped / stale). |
| `## Status history` | Append-only status transitions. |

#### 21.6.2 Template

```markdown
---
type: finding
id: {{slug}}
status: candidate
created: {{createdAt}}
updated: {{createdAt}}
origin_obligations:
origin_traces:
pass:
profile:
reviewer_or_tool:
content_hash:
confidence: high | medium | low
---

# Finding: {{title}}

## Claim

One durable project fact.

## Evidence

- File:
- Command:
- Output:
- Source:

## Applies when

-

## Does not apply when

-

## Related obligations

-

## Promotion target

- [ ] Keep as scoped finding
- [ ] Promote into spec
- [ ] Promote into audit
- [ ] Promote into ADR
- [ ] Promote into memory pattern
- [ ] Mark stale / superseded

## Status history

- {{createdAt}} — candidate — created during {{pass}} pass
```

### 21.7 `adr.md` — an immutable decision

#### 21.7.1 Contract

An ADR records one architecture decision in Nygard form. ADRs are **immutable** (Q7.24): an accepted ADR is never edited in place; "amending" it means writing a *new* superseding ADR and setting the old one's status to `superseded`. A conformant `adr.md` MUST contain the four Nygard elements — context, decision, consequences, status — plus the supersession link fields:

| Section | Meaning |
| --- | --- |
| frontmatter | `type: adr`, `id`, `status` (`proposed \| accepted \| superseded \| rejected`), `supersedes`, `superseded_by`, `created`, `updated`. |
| `## Context` | What forced the decision. |
| `## Decision` | What was chosen. |
| `## Consequences` | Positive / negative / neutral tradeoffs. |
| status linkage | An amended ADR gets only a `Superseded by ADR-00XX` status line; its body stays immutable. |

#### 21.7.2 Template

```markdown
---
type: adr
id: {{slug}}
status: proposed
created: {{createdAt}}
updated: {{createdAt}}
supersedes:
superseded_by:
---

# ADR: {{title}}

## Context

What forced the decision.

## Decision

What we chose.

## Alternatives considered

| Alternative | Why rejected |
| ----------- | ------------ |

## Consequences

### Positive

### Negative

### Neutral / tradeoffs

## Status

proposed | accepted | superseded | rejected
(if superseded: Superseded by ADR-00XX — body below stays immutable)

## Affected obligations / constraints

- Adds:
- Modifies:
- Supersedes:
```

### 21.8 `memory/INDEX.md` — the recall map

#### 21.8.1 Contract

The memory index is a compact **MAP** — links, not explanations (Q8.26). It is the Tier-1 entry point that links into the Tier-2 evidence store (findings, ADRs, patterns, glossary). Every entry MUST carry a `Load when` condition; an entry that cannot name when it matters MUST be removed. A conformant `memory/INDEX.md` MUST contain:

| Section | Meaning |
| --- | --- |
| frontmatter | `type: memory-index`, `id: memory-index`, `status: active`, `updated`. |
| `## Always-relevant project facts` | The few facts loaded every task. |
| `## Topic files` | Table: Topic → file → **Load when**. |
| `## Durable findings` | Table: Finding → status → **Load when**. |
| `## Decisions` | Table: ADR → status → **Load when**. |
| `## Stale or superseded memory` | Table: Item → replacement → action. |

#### 21.8.2 Template

```markdown
---
type: memory-index
id: memory-index
status: active
updated: {{createdAt}}
---

# Memory index

## Purpose

The compact map of durable project knowledge. Read before tasks that may depend
on prior discoveries; follow links to topic files only when the Load-when matches.

## Always-relevant project facts

-

## Topic files

| Topic                 | File                       | Load when                                |
| --------------------- | -------------------------- | ---------------------------------------- |
| Architecture patterns | `patterns/architecture.md` | Editing module boundaries or ownership   |
| Testing patterns      | `patterns/testing.md`      | Adding, moving, or interpreting tests    |
| Debugging patterns    | `patterns/debugging.md`    | Investigating repeated failures          |

## Durable findings

| Finding | Status | Load when |
| ------- | ------ | --------- |
|         |        |           |

## Decisions

| ADR | Status | Load when |
| --- | ------ | --------- |
|     |        |           |

## Stale or superseded memory

| Item | Replacement | Action |
| ---- | ----------- | ------ |
|      |             |        |
```

### 21.9 Tier-3 stdlib source-doc templates (brief notes)

The stdlib ships three source-document templates (§20.3.3). Each is plain `.md`, carries `type` + `id` frontmatter, and preserves a fixed *epistemic stance* enforced by the distillation-loss + source-authority discipline (§22, §24), not by a gatekeeper skill.

| Template | Required sections | Stance rule | Promotion |
| --- | --- | --- | --- |
| `audit.md` | `## Scope`, `## Observations` (evidence-cited), `## Risks`, `## Recommended obligations`. | Observation-only: records what *is*; MUST NOT prescribe a fix inline. | Promotes to a `spec.swarm.md` via the author pass. |
| `research.md` | `## Question`, `## Findings` (each → a `finding.md`), `## Open questions`, `## Recommendation`. | Investigation: open questions remain `QUESTION` candidates until resolved. | Promotes to a `spec.swarm.md` via the author pass. |
| `bug-report.md` | `## Symptom`, `## Reproduction`, `## Root cause`, `## Affected obligations`. | Diagnosis-only: MUST NOT contain the fix; states the broken obligation. | Promotes into a fix `task.md` (`task_kind: fix`), never directly into code. |


Key sources used: `/Users/josecosta/dev/swarm/.agents/research/swarm-kernel-decisions.md` (Q2.8–Q2.10, Q7.23, the vocabulary cheat-sheet, gaps G10/G11/G7) and `/Users/josecosta/dev/swarm/.agents/specs/swarm-rework.md` (§12 contracts and §17–§23 templates).

Decisions I locked in as normative for v0.1:
- Frontmatter normalization per G10: `swarm_language: SOL/0.1`, `aps_version: 0.1`, `spec_version: 0.1.0` (upgraded the rework brief's `swarm_language: 0.1`).
- Trace provenance section per G11/§16: `{source_hash, per_surface_hash[], adapter, verdict, tier, timestamp}` per binding.
- Verdict templates upgraded from the brief's 4-value `PASS/FAIL/UNVERIFIED/BLOCKED` to the canonical core+lifecycle 7-value model with the `VERDICT <id>: <CORE> (<lifecycle> by <authority>: <reason>)` line.
- `VERIFY BY` upgraded everywhere to the typed `<type>:<adapter>:<artifact>[#selector]` form; INTERFACE templates bind `contract:` per the Theme-5 gap-fill.
- task.md template adds the `## Parent contract` hand-off section and `## Scope` In/Out, and ties `write_surfaces ⊆ WRITES` with `SOL-O305` per G7/Q8.27-fields.
- finding.md frontmatter extended with `origin_obligations/origin_traces/pass/profile/reviewer_or_tool/content_hash/confidence` per Q8.26.

Forward-references used (all exist in the outline): §28 (task_kind enum), §32 (conformance contract), §33 (golden corpus), plus §2/§14/§15/§16/§17/§18/§22/§23/§24/§25/§31 and Appendices B/C.


```text
## 22. Source authority

Source authority is the deterministic procedure a conformant Swarm repo MUST use to decide, when two artifacts assert conflicting obligations, **which obligation governs**. It is the conflict-resolution complement to the obligation graph (§3): the graph records *what* obligations exist and how they relate; source authority records *which wins* when they disagree. Authority is **not** a planning hint and **not** a confidence score; it is the binding precedence order, and it is the only sanctioned alternative to silently letting the most recently written artifact win.

The model has **two orthogonal axes** that MUST be applied **lexicographically — domain first, then artifact**. Rationale (Q8.25): a security obligation and a product obligation may share artifact rank yet must not share governing force; the two questions ("how authoritative is the *container*" and "how authoritative is the *domain*") are genuinely independent, so they MUST be ranked independently and combined in a fixed order rather than collapsed into one ladder.

### 22.1 The two axes

#### 22.1.1 Axis A — artifact authority (backward trace)

Axis A ranks an obligation by **the kind of artifact that contains it** and that artifact's lifecycle status. It answers "how settled is the container this obligation was traced back *from*." It is therefore the **backward-trace** axis: follow an obligation back to its source artifact and read its rank.

| Rank | Artifact (with required status) | Notes |
| ---- | ------------------------------- | ----- |
| 1 (highest) | accepted `adr.md` | Nygard-immutable decision (§30); the strongest recorded intent. |
| 2 | approved `spec.swarm.md` | The behavioral contract; `status: approved` in frontmatter. |
| 3 | accepted `finding.md` | A durable project fact whose `status` is `accepted` or `promoted` (§23). |
| 4 | reviewed `audit.md` | Present-state observation that has passed a `review` pass. |
| 5 | reviewed `research.md` | External/exploratory evidence that has passed a `review` pass. |
| 6 | task notes (`task.md`) | Execution-local; durable only after promotion (§23.4). |
| 7 (lowest) | chat | Conversational context; never authoritative on its own. |

A conformant tool MUST reject (lint `SOL-M002`, see §22.3) any claim that a lower-ranked artifact silently amended a higher-ranked one. An artifact below `approved`/`accepted` status occupies the rank of its **draft tier**, which is one step below its accepted tier; e.g. a `proposed` ADR does not outrank an `approved` spec.

#### 22.1.2 Axis B — domain authority (forward governing force)

Axis B ranks an obligation by **the governance domain it belongs to**, independent of where it is written. It answers "how much *forward* governing force this obligation projects over everything downstream." It is therefore the **forward-governing-force** axis.

| Rank | Domain | Examples |
| ---- | ------ | -------- |
| 1 (highest) | enforced-policy | Deterministic, externally-enforced rules (the enforcement lane, §17): write-surface gates, secret redaction, permission denies. |
| 2 | compliance | Regulatory / legal obligations (data residency, retention, audit trails). |
| 3 | security | Authn/authz, secret handling, attack-surface constraints. |
| 4 | architecture | Module boundaries, ownership, layering, public interfaces. |
| 5 | product | User-visible behavior, acceptance criteria. |
| 6 | team | Conventions, style, process agreements. |
| 7 | task-map | Per-task execution scoping (§19). |
| 8 (lowest) | memory | Promoted findings/patterns (§23). |

An obligation's domain MUST be discoverable from its container or an explicit domain tag; where a `spec.swarm.md` is single-domain its domain MAY be declared once in frontmatter (`domain: security`), otherwise each obligation block carries the governing domain in its `AFFECTS`/owner metadata as lowered into the IR (§12). The two lowest domains, `task-map` and `memory`, are also the two axis **floors** (§22.4).

### 22.2 The conflict rule (normative)

When two obligations conflict (they constrain the same trigger/state/surface with incompatible modality), a conformant tool MUST resolve them by this exact procedure, in order:

1. **Compare DOMAIN rank (Axis B) first.** The obligation in the higher-ranked domain wins **regardless of artifact rank**. Domain dominates: a `security` obligation governs over a `product` obligation even when the security obligation lives in a lower-ranked artifact.
2. **If — and only if — the two obligations are in the same domain, compare ARTIFACT authority (Axis A).** The obligation in the higher-ranked artifact wins.
3. **If both axes are equal, STOP.** A conformant tool MUST NOT auto-select a winner. It MUST emit `SOL-M002` (semantic-layer contradiction, §8) and route the conflict to amendment/review (§14). Resolution is an authoring act, never an inference.

This ordering is **lexicographic with domain as the most-significant digit**. The pair `(domain_rank, artifact_rank)` is compared left-to-right; a difference in `domain_rank` is decisive before `artifact_rank` is ever consulted.

### 22.3 Worked tie-break example

> A reviewed `audit.md` records a `security` obligation: *the refresh endpoint MUST reject reuse of a rotated refresh token*. An approved `spec.swarm.md` records a `product` obligation: *the refresh endpoint MUST accept the most recent token presented, for a seamless re-login*. They conflict on the same trigger (reuse of a prior refresh token).

Applying §22.2:

1. **Axis B (domain).** `security` (rank 3) vs `product` (rank 5). Security outranks product. **Resolution stops here: the security obligation governs.**
2. Axis A is **never consulted**, even though the product obligation sits in a higher-ranked artifact (approved spec, rank 2) than the security obligation (reviewed audit, rank 4).

```sol
CONSTRAINT C-014:                  # from reviewed audit.md, domain: security
THE refresh endpoint MUST NOT accept a refresh token that has already been rotated
VERIFY BY security:cmdScan:auth-replay#rotated-token
AFFECTS auth.refresh
```

```sol
REQ AC-031:                        # from approved spec.swarm.md, domain: product
WHEN a client presents the most recent refresh token
THE refresh endpoint MUST issue a new access token
VERIFY BY test:cmdTest:auth-refresh#happy-path
AFFECTS auth.refresh
```

`C-014` (security) governs. The product REQ `AC-031` is not deleted; it is routed to amendment so its trigger can be narrowed to exclude rotated tokens. Had both obligations been `product`, the procedure would fall to Axis A and the approved spec would win over the reviewed audit.

### 22.4 Invariants on both axes

These hold on Axis A and Axis B simultaneously, and a conformant tool MUST NOT let any precedence computation violate them:

| Invariant | Statement |
| --------- | --------- |
| Code is reality, not intent | Code and tests are implementation reality. They MAY **falsify** an obligation (producing `FAIL`/`CONTRADICTED`/`STALE`, §14, §16) but MUST NOT **silently amend** intent. A divergence routes to the §16 three-way reconcile, never to a quiet edit of the obligation. |
| Memory and task-map are a floor | `memory` (Axis B rank 8) and `task-map` (rank 7) are the lowest domains and never outrank any governing domain; equivalently, a promoted finding or a task scoping note can **inform** but never **weaken** an obligation. A promotion that would weaken an obligation is itself a `SOL-M002` contradiction (§23). |
| Planning hints reorder, never weaken | `DEPENDS ON`, `parallel_group`, and other planning metadata (§13, §18) change the **order** work runs in. They MUST NOT change modality, scope, or verification bindings of any obligation. |

### 22.5 Bidirectional traceability framing

The two axes are the two directions of requirements traceability:

- **Axis A is the backward trace.** Given an obligation, you trace it *back* to the artifact it came from; the artifact's rank tells you how settled the provenance is.
- **Axis B is the forward governing force.** Given an obligation, you trace its domain *forward* over everything it governs; the domain's rank tells you how much force it projects downstream.

A conformant repo's source-authority reference (`docs/language/source-authority.md`, a kernel-required reference per §20) MUST state both axes, the lexicographic rule, the three invariants, and at least the §22.3 worked tie-break.

---

## 23. The memory model

Memory is Swarm's durable feedback loop: the mechanism by which a discovery made during one task becomes reliably available to a future task without bloating the always-loaded bootloader (§31). The model is **two-tier and provenance-anchored**. It is markdown-only (Principle 1, §2): nothing here describes a retrieval engine; it describes the *files and the discipline* a future retrieval tool would build against.

Rationale (Q8.26): chat transcripts and inline prose are not memory — they are unindexed, unprovenanced, and unfalsifiable. Memory MUST be a **promotion system** (a fact earns durability through a recorded promotion) backed by an **immutable evidence store**, with a compact index over it.

### 23.1 Tier-1 — the compact map (kernel)

Tier-1 is what an agent reads *first* and *cheaply*. It is a map, not the territory.

#### 23.1.1 `memory/INDEX.md`

`memory/INDEX.md` is a kernel-required core artifact (§20). It is a **compact map of links, not explanations**. Each entry MUST carry a **`Load when` condition** — the trigger that tells a future agent the entry is relevant to its current task.

Normative rule (the **load-when discipline**): if an entry cannot name *when it matters*, it MUST be removed from the index. An entry without a usable `Load when` is dead weight against the §24 loss budget and the §31 density cap.

```text
## Durable findings

| Finding                          | Status   | Load when                                              |
| -------------------------------- | -------- | ------------------------------------------------------ |
| finding-refresh-token-replay.md  | promoted | Touching auth token rotation or refresh endpoints      |
| finding-bq-cost-explosion.md     | accepted | Writing or reviewing analytics queries against BigQuery |

## Topic files

| Topic                 | File                       | Load when                                              |
| --------------------- | -------------------------- | ------------------------------------------------------ |
| Architecture patterns | `patterns/architecture.md` | Editing module boundaries, ownership, or cross-cutting flows |
```

The INDEX **links into** Tier-2 artifacts; it MUST NOT duplicate their bodies. A conformant tool MAY treat a divergence between an INDEX summary line and the linked artifact as advisory drift.

#### 23.1.2 `memory/glossary.md`

`memory/glossary.md` enforces **one word, one meaning** (ASD-STE100 discipline, also referenced by APS §7 and the `SOL-P006` undefined-term rule, §8). Each entry binds exactly one term to exactly one definition. A term whose meaning is contested MUST be split into distinct terms, never overloaded. The glossary is the project-level fallback for term resolution; an in-file `TERM` definition in a `spec.swarm.md` takes precedence over the glossary for that spec (per Q8.26 term-resolution precedence).

### 23.2 Tier-2 — the immutable evidence store (kernel)

Tier-2 is the **territory**: the durable artifacts the INDEX points at.

| Artifact | Role in memory | Mutability |
| -------- | -------------- | ---------- |
| `finding.md` | One durable project fact + its evidence | Immutable once `accepted`/`promoted`; status may advance, body does not silently change |
| `adr.md` | Architectural/product decision + rationale | Nygard-immutable (§30); amend only by superseding ADR |
| `audit.md` | Present-state risk/debt observation | Immutable record of an observation at a point in time |
| `bug-report.md` | Reproducible-defect diagnosis | Immutable record of a reproduction |
| `memory/patterns/*.md` | Recurring knowledge spanning **multiple** findings | Append-on-supersession |

`memory/patterns/*.md` exists for knowledge that recurs across more than one finding — a pattern is the distillation of several findings into reusable guidance, and it MUST cite the findings it generalizes. A single finding MUST NOT be promoted directly to a pattern; promote it to a `finding.md` first, and to a pattern only once a second corroborating finding exists.

### 23.3 Provenance (mandatory on every promoted finding)

Every finding that reaches `accepted` or `promoted` status MUST carry the full provenance record. Provenance is what makes a finding *falsifiable* and *staleness-checkable*; a finding without it is chat, not memory.

| Field | Meaning |
| ----- | ------- |
| `claim` | The one durable fact, stated as a single proposition. |
| `evidence` | The file/command/output/source that grounds the claim. |
| `origin_obligations[]` | The obligation IDs (`AC-/C-/I-…`) the finding was discovered against. |
| `origin_traces[]` | The `*.swarm.trace.md` entries that produced the evidence. |
| `pass+profile` | The pass and heuristic profile under which it was found (e.g. `review[profile: skeptic]`, §26–§27). |
| `reviewer_or_tool` | The human reviewer or tool/adapter that confirmed it. |
| `timestamp` | When it was promoted. |
| `content_hash` | Hash of the cited source/surfaces at promotion time (drives staleness, §23.5). |
| `confidence` | `high` \| `medium` \| `low`. |
| `applies-when` / `does-not-apply-when` | The scope envelope; mirrors the `Load when` of the INDEX entry. |

```text
---
type: finding
id: finding-refresh-token-replay
status: promoted
confidence: high
origin_obligations: [C-014]
origin_traces: [auth-refresh.swarm.trace.md#C-014]
pass: review
profile: skeptic
reviewer_or_tool: cmdScan / human reviewer jdoe
timestamp: 2026-05-31T09:14:00Z
content_hash: sha256:7f1c…a02b
applies_when: "auth token rotation, refresh endpoints"
does_not_apply_when: "single-use opaque session cookies (no rotation)"
---

## Claim
Reusing a rotated refresh token MUST be rejected; the rotation store is the oracle, not the JWT exp.
```

### 23.4 Promotion

A discovery during a task does not become memory by being written down; it becomes memory by being **promoted**. The kernel references the promotion protocol (`docs/language/promotion-protocol.md`, §20) and its status enum. Every promotion item raised during a task MUST resolve to one of these before the task closes:

| Promotion status | Meaning |
| ---------------- | ------- |
| `pending` | Raised, not yet dispositioned. |
| `promoted` | Written to its durable target and indexed. |
| `deferred` | Recorded for a future task with reason. |
| `rejected` | Judged non-durable with reason. |
| `blocked` | Cannot promote yet (e.g. needs an ADR) with reason. |

Normative rule: a task MUST NOT close while any promotion item is `pending`. A `promoted` finding MUST appear in `memory/INDEX.md` with a `Load when` condition (§23.1.1) and carry full provenance (§23.3). A promotion that would *weaken* an obligation is forbidden — it is a `SOL-M002` contradiction routed to amendment, because `memory` is the floor domain on Axis B (§22.4).

#### 23.4.1 G9 tie-break — "universal workflow rule" promotions

The promotion table (§23.4, adapted from the build brief) routes a *universal workflow rule* toward `AGENTS.md`. This collides with the ≤200-line bootloader cap and ADR 0017 (only persistent **facts** belong in `AGENTS.md`; **procedures** belong in pass guides). The kernel resolves the collision normatively (G9):

A "universal workflow rule" promotion MUST become **a pass-guide edit (the procedure) PLUS at most a one-line `AGENTS.md` pointer (the fact that the guide exists and when to load it).** It MUST NOT inline the procedure into `AGENTS.md`.

| Where it goes | What goes there |
| ------------- | --------------- |
| Pass guide (`docs/skills/…`, §26) | The actual procedure / steps. |
| `AGENTS.md` | One line: the pointer + its load-when, nothing procedural. |

> Example — promoting "always run the migration dry-run before applying": the dry-run procedure is added to the `implement` pass guide; `AGENTS.md` gains only `- Before applying a migration, load the implement pass guide (migration section).`

This keeps the bootloader a map (consistent with §31) and the procedure lazily loaded.

### 23.5 Staleness

A finding's `status` enum is `candidate | accepted | promoted | rejected | stale | superseded`. A finding becomes **`stale`** when its `content_hash` (§23.3) no longer matches the cited source/surfaces — the same drift signal that produces the `STALE` verdict lifecycle decorator (§14) and the spec↔code drift reconcile (§16). A `stale` finding MUST NOT be relied on as authority; it is routed to re-verification or supersession. A `superseded` finding records its replacement in `memory/INDEX.md`'s stale/superseded table.

The kernel ships the **fields** that make staleness computable (`content_hash`, `origin_traces`); it does **not** ship the comparator. Recomputing the hash and flipping `accepted → stale` is a harness/CLI concern (§16, §17), aspirational/manual today (Principle 1).

### 23.6 Deferred to post-v0.1

The following are explicitly **out of scope for v0.1** (Q8.26), because each requires a runtime Swarm does not ship:

| Deferred | Reason |
| -------- | ------ |
| Embedding / dense-vector retrieval | Needs an index engine and runtime. |
| LRU (or any automatic) eviction | Needs a runtime memory manager. |
| Automatic staleness hashing | Needs a differ/checker (§16); fields shipped, comparator deferred. |
| Cross-session agent identity | Needs persistent runtime state. |
| Memory dashboards / analytics | Needs a runtime UI. |

v0.1 ships the two-tier file model, the provenance fields, the promotion statuses, and the `Load when` discipline. Automation builds against them later.

---

## 24. The distillation loss budget

Distillation is the deliberate **dropping of detail** that happens whenever information crosses a boundary in the pipeline — most acutely at the **spec → task lowering boundary** (§11) and the **promotion boundary** (§23.4). The loss budget is the discipline governing *what may be dropped* versus *what must survive*. Its purpose is to let lowering and promotion compress aggressively without ever silently losing binding force.

Rationale (Q7.23): a distillation that drops an obligation, its modality, or its verification binding has not compressed the spec — it has **changed what gets built**. The loss budget makes that the bright line.

### 24.1 What MAY be abstracted or dropped

At any distillation boundary, the following MAY be abstracted, summarized, or dropped entirely, because none of it carries binding force:

| Droppable | Where it survives instead |
| --------- | ------------------------- |
| Commentary and narrative prose | The source artifact (linked, not copied). |
| Redundant restatements | The single canonical statement. |
| Rationale already recorded elsewhere | The ADR / finding / research it came from. |
| Rejected options, source digressions, low-confidence observations | The `research.md` (§24.4 table). |
| Step-by-step execution logs | The `task.md` and the trace. |

### 24.2 What MUST survive every distillation

The following MUST survive intact across **every** boundary. Dropping or weakening any of them is a **distillation error** (lint `SOL-V001`/`SOL-M…` family, §8), not a stylistic choice:

| Must survive | Why |
| ------------ | --- |
| The obligation itself (its ID) | The traceability key (§4); losing it severs backward trace (§22.5). |
| Its modality (`MUST`/`MUST NOT`/`SHOULD`/…) | Modality *is* the binding force (§4); losing it neutralizes the obligation. |
| Its verification bindings (`VERIFY BY …`) | An obligation with no proof path is `UNVERIFIED` (§14, §15). |
| Its authority and scope | The domain/artifact rank (§22) and `WRITES`/`READS`/`AFFECTS` scope (§18). |
| Constraints, invariants, non-goals, unresolved `QUESTION`s | These bound the build; dropping a non-goal silently widens scope. |

The build brief's loss-budget matrix is canonical and reproduced here as the per-boundary specialization of these two lists:

| From | To | Permitted loss | Forbidden loss |
| ---- | -- | -------------- | -------------- |
| `research.md` | `spec.swarm.md` | Source digressions, rejected options, low-confidence observations | Constraints, unresolved ambiguity, decision-changing evidence |
| `audit.md` | `spec.swarm.md` | Low-priority cleanup details | Observed risks affecting target behavior |
| `bug-report.md` | fix task | Duplicate failed reproduction attempts | Reliable reproduction, expected/actual behavior, root-cause evidence |
| `spec.swarm.md` | task | Rationale not needed for execution | Obligation IDs, modality, constraints, invariants, verification bindings, non-goals |
| `finding.md` | task | Historical discussion | Actionable claim, applicability, evidence |
| `task.md` | `finding.md` | Step-by-step execution log | Evidence for the durable claim |
| task output | trace | Narrative detail | Obligation ID, changed files, proof |
| trace | review verdict | Implementation chatter | Claim, evidence, pass/fail reason |

### 24.3 The budget is a discipline, not a gatekeeper

The loss budget is **enforced by source authority (§22) plus lint (§8)** — it is not, and MUST NOT be implemented as, a "documentation-gatekeeper" skill or persona. Rationale: a gatekeeper is soft control (a model deciding whether to allow a passage, §2 / §17), so it can be talked past; a lint rule plus an authority comparison are deterministic checks against the typed obligation set.

Concretely:
- **Lint** catches a distillation error structurally: a lowered task that omits an obligation ID its source spec declares, or a `VERIFY BY` binding present in the spec but absent in the task, is a `SOL-V001`/`SOL-M…` diagnostic.
- **Source authority** catches it semantically: a distilled artifact that contradicts its higher-authority source is a `SOL-M002` contradiction (§22.2), routed to amendment — the distillation cannot silently win.

The **`spec.swarm.md` distillation loss statement** (the `Preserved / Dropped / Still uncertain` section, §21) is the human-authored declaration the lint checks against. It records what the author *intends* to be droppable, so the loss is auditable rather than accidental.

### 24.4 Forbidden compositions

A **forbidden composition** is the silent mixing of two distinct epistemic stances — most dangerously, an **observation-only artifact silently becoming intent**. Examples: an `audit.md` (observation of present state) read as if it were an approved `spec.swarm.md` (intended behavior); a `research.md` (exploratory) treated as a decision; a `bug-report.md` (diagnosis) treated as a fix authorization.

These compositions are prevented by the **loss budget + source authority**, NOT by a documentation-gatekeeper (Q7.23):

- The **loss budget** forces the crossing to be explicit: an audit *promotes to* a spec through the `audit.md → spec.swarm.md` row of §24.2, which is an authoring act that re-states observations as obligations with their own IDs, modality, and verification bindings. There is no path by which an audit's prose becomes binding without that re-statement.
- **Source authority** ranks the stances: an `audit` (Axis A rank 4, observation) cannot silently amend an approved `spec` (rank 2); if it appears to, that is a `SOL-M002` contradiction routed to review (§22.2).

> Worked example — an `audit.md` notes "the refresh endpoint currently accepts rotated tokens." This is an **observation**, not intent. To affect the build it must promote into `spec.swarm.md` as a re-stated obligation (`CONSTRAINT C-014`, §22.3) carrying modality and `VERIFY BY`. The audit prose alone has Axis-A rank 4 and `audit`/`security` domain; it never silently overwrites the product spec — the §22 conflict procedure governs, and the loss budget forces the explicit re-statement. The epistemic stance is preserved end-to-end: an observation stayed labeled an observation until an author deliberately turned it into intent.

The conformant repo's distillation-loss-budget reference (`docs/language/distillation-loss-budget.md`, §20) MUST state both lists (§24.1, §24.2), the per-boundary matrix, the discipline-not-gatekeeper rule, and the forbidden-composition treatment.

---

## 25. Versioning

Swarm has **two independent version axes**. Conflating them is a category error: one tracks the *meaning of the language*, the other tracks *the package that delivers it*. A conformant repo MUST track both and MUST NOT merge them into a single number.

### 25.1 The two axes

| Axis | What it versions | Where it lives | Cadence |
| ---- | ---------------- | -------------- | ------- |
| **Language version** | The SOL + APS feature set: grammar, the 7 block types, the 5 modals, the clause keywords, the `SOL-<LAYER>NNN` lint codes (§4–§8) | Per-file frontmatter: `swarm_language` + `aps_version` | Small, slow-moving: `0.1`, `0.2`, `1.0` |
| **Framework / package version** | The scaffold, templates, skills/pass guides, personas/profiles, flow-graph (§20, §21, §26–§29) | `.agents/.swarm-version` (semver) | Ordinary semver; may move many times between language bumps |

Rationale (Q9.30): this mirrors C# `LangVersion` vs the SDK/compiler, and Rust editions vs `rust-version` vs cargo/rustc — the *language API* (grammar + lint codes) and the *package API* (template sections + skills + flow-graph) evolve on independent clocks, and SemVer is only meaningful when each public API is named explicitly.

#### 25.1.1 Language version

The language version answers "**which grammar, blocks, modals, and lint codes does this file speak?**" It is carried **per file** so that a single repo MAY contain `spec.swarm.md` files at different language versions during a migration.

- `swarm_language` is the **SOL discriminator**, written `SOL/0.1`.
- `aps_version` is the **APS prose-standard version**, written `0.1`.

#### 25.1.2 Framework / package version

The framework version answers "**which scaffold, templates, and pass guides shipped this repo?**" It is a single semver string in `.agents/.swarm-version`. This **extends ADR 0015** (which established `.agents/.swarm-version`); ADR 0015 is *extended, not replaced* (§30) — it is scoped to the package axis and the language axis is added alongside it.

### 25.2 The one-way trigger

The axes are independent, but coupled by exactly **one** directional rule:

> **Any change to the SOL/APS language version MUST force at least a framework MINOR release** — additive language change → framework MINOR; breaking language change → framework MAJOR. The framework MAY release any number of versions (PATCH/MINOR/MAJOR) **without** changing the language version.

```text
language change ──(MUST)──▶ framework MINOR (additive) or MAJOR (breaking)
framework change ──(MAY)──▶ no language change required
```

Rationale: a new keyword or lint code changes what the templates and pass guides must teach, so the package that ships them MUST move; but fixing a template typo or adding a skill never changes the grammar, so the language MUST stay pinned. The trigger is **one-way**: language ⇒ framework, never framework ⇒ language.

### 25.3 Three distinct version fields in the IR/plan

The emitted IR (§12) and plan (§13) MUST echo **three distinct fields**, and a conformant tool MUST NOT merge any two of them:

| Field | Axis / meaning | Example |
| ----- | -------------- | ------- |
| `meta.language` | The SOL **discriminator** (which grammar this IR was parsed under) | `"SOL/0.1"` |
| `meta.version` | The **spec content version** (the semver of *this spec's intent*, independent of language and framework) | `"0.1.0"` |
| `provenance.compiler_version` | The **tool version** that emitted the IR, when a tool exists | `"0.0.0"` / unset today (no runtime, §2) |

```json
{
  "meta": {
    "language": "SOL/0.1",
    "version": "0.1.0",
    "title": "auth-refresh"
  },
  "provenance": {
    "compiler_version": null
  }
}
```

These answer three different questions — *which grammar* (`meta.language`), *which revision of this spec's intent* (`meta.version`), *which tool produced this* (`provenance.compiler_version`) — and a single number cannot answer all three.

### 25.4 G10 — frontmatter normalization (normative)

To unblock the §25.3 three-field mapping, the kernel pins one canonical frontmatter vocabulary across **all** `.swarm.md` and template files (G10):

```text
---
swarm_language: SOL/0.1     # SOL discriminator (= meta.language in the IR)
aps_version: 0.1            # APS prose-standard version
spec_version: 0.1.0         # spec content version (= meta.version in the IR)
---
```

| Frontmatter field | Maps to IR field | Axis |
| ----------------- | ---------------- | ---- |
| `swarm_language: SOL/0.1` | `meta.language` | Language (discriminator) |
| `aps_version: 0.1` | (not echoed in IR; governs prose lint layer `SOL-P…`) | Language |
| `spec_version: 0.1.0` | `meta.version` | Spec content |

Conformance note: the build brief's templates currently write `swarm_language: 0.1` (a bare number). The normalized form is `swarm_language: SOL/0.1` (with the `SOL/` discriminator) and a separate `spec_version`. A conformant repo MUST use the normalized form; a bare `swarm_language: 0.1` is a `SOL-S…`-class frontmatter diagnostic. The framework version is **never** written in per-file frontmatter — it lives only in `.agents/.swarm-version`.
```

I have completed drafting my four assigned sections (§22 Source authority, §23 The memory model, §24 The distillation loss budget, §25 Versioning) as a single continuous block of GitHub-flavored Markdown, ready to be assembled into the canonical spec.

Key resolutions encoded, all marked NORMATIVE per the decision record:
- **§22**: two orthogonal axes applied lexicographically (domain first via Axis B, then artifact via Axis A), the three-step conflict rule terminating in `SOL-M002`, the worked security-audit-beats-product-spec tie-break, the three cross-axis invariants, and the backward-trace/forward-governing-force framing.
- **§23**: two-tier provenance-anchored model (Tier-1 INDEX map + glossary with the load-when discipline; Tier-2 immutable evidence store + patterns), full mandatory provenance field set, promotion status enum with task-close gate, the **G9** tie-break (pass-guide edit + one-line AGENTS.md pointer, never inline procedure), `candidate|accepted|promoted|rejected|stale|superseded` staleness tied to §16, and the post-v0.1 deferral table.
- **§24**: MAY-drop vs MUST-survive lists, the per-boundary matrix, the discipline-not-gatekeeper rule (lint + source authority), and forbidden-compositions prevention via loss budget + source authority.
- **§25**: the two axes, the one-way trigger (language ⇒ framework MINOR/MAJOR), the three never-merged IR fields, and the **G10** frontmatter normalization (`swarm_language: SOL/0.1`, `aps_version: 0.1`, `spec_version: 0.1.0`).

Combined length is approximately 360 lines, within the 320–400 target. Source file consulted: `/Users/josecosta/dev/swarm/.agents/research/swarm-kernel-decisions.md` (Q8.25, Q8.26, Q7.23, Q9.30, G9, G10) and `/Users/josecosta/dev/swarm/.agents/specs/swarm-rework.md` (§9–§12, §21, §23 templates).


Now I'll draft my six sections (§26–§31). Writing the final canonical specification text.

## 26. Skills as pass guides

This section recasts the framework's 24 shipped skills onto the compiler model. A *skill* in the legacy framework was a self-contained procedural module a model loaded to perform a unit of work. Under the kernel, that role is renamed and re-scoped: a skill is a **pass guide** — a procedural module that documents *how* to perform one of the nine canonical passes (§9), and nothing more. The recast preserves every skill's procedural value while removing one specific failure mode: skills MUST NOT own language semantics.

### 26.1 The semantic-ownership prohibition

> **The load-bearing rule of this section.** No pass guide, profile, fragment, or any other skill-shaped file MAY define, redefine, or be required to interpret SOL or APS semantics.

A conformant Swarm repo MUST satisfy all of the following:

- No skill file defines a block type, a modal, a clause keyword, a verdict value, a proof type, a lint code, or any IR field. These live exclusively in the language reference (`docs/language/`) and the typed IR (§12), per the binding invariant that all load-bearing meaning lives in SOL + IR (decision record Q-semantics-1).
- A correctly written `*.swarm.md` file MUST be understandable to a strong model *without* any skill loaded, because it uses controlled natural language (§5–§7) and stable formal blocks (§6).
- A skill MAY cite, link to, or quote the language reference, but the citation is non-authoritative delivery; the authoritative text is the language reference itself.

Rationale (decision record Q7.20): skills are *procedural modules, not semantic homes*; placing semantics in a skill would make meaning depend on a non-authoritative, lazily-loaded layer whose adherence is not guaranteed.

A regression check (§32, §34) MUST confirm that no skill, profile, or `AGENTS.md` section defines modality, authority order, or verification semantics.

### 26.2 The 24-skill → ~9-pass recast

The 24 shipped skills recast onto the nine passes of §9. The mapping is *many-skills-to-one-pass*: a pass MAY carry more than one pass guide (e.g. `implement` carries one guide per implementation kind), and every pass carries **at least one** pass guide. Two cross-cutting fragments (§26.3) are shared across passes rather than owned by one.

| Legacy skill | Recast role | Owning pass |
|---|---|---|
| `write-spec` | author guide | `author` (spec) |
| `write-research` | author guide | `author` (research) |
| `write-audit` | author guide | `author` (audit) |
| `write-bug-report` | author guide | `author` (bug-report) |
| `write-feature` | implement guide | `implement` |
| `write-fix` | implement guide | `implement` |
| `write-refactor` | implement guide | `implement` |
| `write-rewrite` | implement guide | `implement` |
| `write-migration` | implement guide | `implement` |
| `write-performance` | implement guide | `implement` |
| `write-testing` | implement guide | `implement` |
| `write-documentation` | implement guide | `implement` |
| `fix-flaky-test` | narrow implement guide | `implement` |
| `adversarial-review` | **folds into** the review pass as a profile (Skeptic, §27) — no longer a skill | `review` |
| `empirical-proof` | cross-cutting fragment | shared (behind `verify`) |
| `distillation-discipline` | cross-cutting fragment | shared (behind `lower`/`promote`) |
| `persona-architect` | becomes a profile (§27) | `author` (spec) |
| `persona-auditor` | becomes a profile (§27) | `author` (audit) |
| `persona-janitor` | becomes a profile (§27) | `implement` |
| `persona-migrator` | becomes a profile (§27) | `implement` |
| `persona-performance-surgeon` | becomes a profile (§27) | `implement` |
| `persona-skeptic` | becomes a profile (§27) | `review`/`verify` |
| `persona-surveyor` | becomes a profile (§27) | `author` (research) |
| `persona-lead-engineer` | becomes a profile (§27) | `decompose`/merge-gate |

Three transformations in that table are normative and called out individually:

- **`adversarial-review` folds into `review`.** It MUST NOT survive as a standalone skill. Its adversarial method becomes the **Skeptic profile** (§27) applied to the `review` and `verify` passes. Rationale (Q7.20): skepticism is a *profile parameter to a pass*, not a separate pass.
- **`fix-flaky-test` survives as a narrow `implement` guide.** It is the one legacy skill that maps to a sufficiently specific procedure (de-flaking a non-deterministic test) to remain its own guide rather than collapse into `write-fix`.
- **The eight `persona-*` skills become profiles (§27).** Their carrier (standalone file vs inlined in a pass guide) is an implementation detail; what matters is that a profile is a heuristic stance, not a procedure module.

The resulting pass-guide set carried by `docs/passes/` (and the scaffold copy under `scaffold/.agents/skills/`) MUST cover the nine passes; the five **stdlib pass guides** that are tooled first (decision record Q6.18) are `lint`, `decompose`, `implement`, `review[profile: skeptic]`, and `promote`.

### 26.3 The two cross-cutting fragments

Two procedural disciplines apply across multiple passes and are therefore packaged as **fragments**, not pass guides. A fragment is a pass guide that a pass guide composes (it has the same shape, §26.5, but is named by another guide rather than by a task `task_kind`).

| Fragment | Discipline it carries | Passes that compose it |
|---|---|---|
| `empirical-proof` | the proof / `VERIFY BY` discipline — every completion claim maps to an independent, re-runnable proof; "tests passed" without output is not a proof (§15) | `verify`, `review` |
| `distillation-discipline` | the loss-budget discipline — what MUST be preserved and what MAY be dropped when meaning crosses an artifact boundary (§24) | `lower`, `decompose`, `promote` |

Neither fragment defines semantics: `empirical-proof` does not define the proof taxonomy (that is §15); `distillation-discipline` does not define the loss budget table (that is §24). Each is the *procedure* for applying a discipline the language and reference layers own.

### 26.4 Activation doctrine (ADR 0020, reframed)

ADR 0020's self-activating `description` field is **retained but reframed**. The canonical doctrine is:

> **Load the pass guide or profile that the task file names.** Description-matching is the launcher-less fallback, not the primary mechanism.

Normatively:

- A `task.md` (§28) SHOULD name, in its frontmatter or assignment block, the pass guide(s) and profile(s) it activates for the pass it frames. When named, the agent MUST load exactly those, and SHOULD NOT load others. BECAUSE always-on density harms adherence and cost (§31, decision record Q-density-1).
- When no launcher and no explicit naming is present, an agent MAY fall back to matching a guide's self-activating `description` against the task. This is a degraded mode, not the contract.
- A skill MUST NOT be always-loaded (ADR 0017, kept verbatim). Pass guides and profiles are lazily loaded.

Example task-to-guide binding (the recommended primary path):

```text
task.md frontmatter:
  task_kind: fix
  pass: implement
  pass_guides: [write-fix, fix-flaky-test]
  profiles: [skeptic]
```

The agent loads `write-fix`, `fix-flaky-test`, and the Skeptic profile for this `implement` pass, and nothing else.

### 26.5 Pass-guide contract

Every pass guide MUST declare the following sections; this is the contract a conformant pass guide satisfies (adapted from build brief §14):

```markdown
# Pass guide: <name>

## Purpose
## Consumes
## Produces
## Preserves
## Rejects
## Procedure
1.
2.
3.
## Output contract
## Self-review delta
```

Dependency direction MUST be one-way and acyclic:

```text
language definitions → artifact contracts → pass contracts → pass guides → heuristic profiles → project overlays
```

A pass guide MAY depend on shared language, artifact, and pass contracts. A pass guide MUST NOT introduce a circular dependency, MUST NOT be required to interpret SOL, and MUST NOT override an approved SOL obligation. These constraints are recorded in ADR 0017 (kept), ADR 0016 (kept, self-contained skill bodies), and a new kernel ADR for the 9-pass model (§30).

## 27. Personas as heuristic profiles

This section recasts the framework's 13 persona mindsets into **heuristic profiles**. A persona was never an org role (ADR 0009, kept verbatim — "personas are mindsets"); the recast makes that explicit and binds each mindset to the pass it parameterizes rather than to a task type or document type.

### 27.1 What a heuristic profile is

A **heuristic profile** is an optional cognitive stance applied to a pass. It is not a character, not an actor, and not a procedure. A profile changes *what an agent looks for and refuses* while performing a pass; the procedure itself stays in the pass guide (§26).

Normatively:

- A profile MUST NOT define language or artifact semantics (the §26.1 prohibition applies identically: a profile is a skill-shaped file).
- A profile is **optional**: a pass is well-defined without any profile loaded. A profile sharpens a pass; it is never required for the pass to be valid.
- A profile's **carrier is an implementation detail.** A profile MAY ship as a standalone file (e.g. `scaffold/.agents/skills/persona-skeptic/`) OR be inlined into a pass guide. Conformance checks the *contract* (§27.2), not the carrier. Rationale (decision record Q7.21): the mindset is the kernel object; the file is incidental.

### 27.2 The canonical profile contract

Every heuristic profile MUST declare exactly these seven sections, in this order:

```markdown
# Heuristic profile: <name>

## Prevents
## Default questions
## Required evidence
## Refuses          <!-- the red-flag table (ADR 0013) -->
## Self-review delta
## Applies when
## Does not apply when
```

Section semantics:

| Section | Content |
|---|---|
| `## Prevents` | the one failure class this stance exists to catch (single clause) |
| `## Default questions` | the questions the stance forces the agent to ask while performing the pass |
| `## Required evidence` | the evidence the stance demands before it accepts a claim |
| `## Refuses` | the **red-flag table** (ADR 0013, amended): each row is a pattern the stance rejects on sight, replacing the legacy "iron law" with an enumerated refusal set |
| `## Self-review delta` | what the agent additionally checks in its self-review when this profile is active |
| `## Applies when` | the pass/`task_kind` conditions under which the profile is appropriate |
| `## Does not apply when` | the conditions under which the profile MUST NOT be loaded (prevents misapplication) |

The `## Refuses` red-flag table is the home of what ADR 0013 called the "iron law." ADR 0013 is amended via a superseding ADR (§30): the iron law is recast as a profile's `Refuses` rows.

Worked example (the Skeptic profile, the canonical reference profile per build brief §15):

```markdown
# Heuristic profile: Skeptic

## Prevents
Premature acceptance of plausible but unverified claims.

## Default questions
- What would falsify this?
- Does the evidence prove the exact obligation, by ID?
- Did the branch change behavior outside the assigned obligations?

## Required evidence
- Proof mapped to obligation IDs, with re-runnable artifact references.
- Diff review for unauthorized changes.
- Constraint/invariant preservation evidence.

## Refuses
| Red flag | Action |
| --- | --- |
| Summary-only proof | reject; demand the proof artifact |
| "Tests passed" with no output | reject; UNVERIFIED |
| A trace passing an obligation with missing evidence | reject; UNVERIFIED |

## Self-review delta
- Re-check every PASS verdict against the cited evidence before closing.

## Applies when
- pass ∈ {review, verify}; task_kind ∈ {review, fix}.

## Does not apply when
- The pass is author/lint/improve (no claims exist to falsify yet).
```

### 27.3 The profile → pass mapping

The 13 personas map to passes as follows. This table is normative; it is the routing that **profile × pass replaces** the legacy persona × task-type and persona × document-type matrices (decision record Q7.21).

| Profile (legacy persona) | Pass(es) it parameterizes |
|---|---|
| Skeptic | `review` / `verify` |
| Architect | `author` (spec) |
| Auditor | `author` (audit) |
| Surveyor | `author` (research) |
| Researcher | `author` (research) |
| Bug Hunter | `author` (bug-report) |
| Janitor | `implement` (by kind: refactor/cleanup) |
| Migrator | `implement` (by kind: migration/upgrade) |
| Performance Surgeon | `implement` (by kind: performance) |
| Builder | `implement` (by kind: feature/rewrite) |
| Test Author | `implement` (by kind: testing) |
| Documentarian | `implement` (by kind: documentation) |
| Lead Engineer | `decompose` / merge-gate (`review` over the obligation set) |

### 27.4 Profile × pass routing replaces the persona matrices

The legacy framework routed work through two matrices: persona × task-type (ADR 0002, already superseded by ADR 0020) and persona × document-type. Both are retired.

> A conformant repo MUST express routing as **profile × pass**: a task names a pass (§28) and MAY name the profile that sharpens it (§26.4). A repo MUST NOT reintroduce a persona-per-task-type or persona-per-document-type matrix.

Rationale (decision record Q7.21): the old matrices duplicated the same mindset across many cells; collapsing them onto the pass axis removes the duplication and the 8/5 "persona vs profile" asymmetry the legacy docs carried. The `8/5` split is dropped: all 13 are uniformly heuristic profiles.

## 28. Task types as pass frames

This section recasts the framework's 18 task types onto the nine-pass model. The unifying statement is that a **task is a pass frame**: a `task.md` is the lowered work packet that frames exactly one pass over an assigned set of obligations (build brief §24.4). The 18 types do not disappear; they become a frontmatter **enum** that parameterizes two passes.

### 28.1 `task_kind` is a parameter, not a pass

A task carries a `task_kind:` frontmatter field whose value is one of the **17** canonical kinds — the 18 legacy task types minus the banned `kickback` (§28.2, which is a re-entry edge, not a type). `task_kind` **parameterizes** the `implement` and `author` passes — it selects which pass guide(s) (§26) and profile (§27) apply — but it is not itself a pass. The nine passes (§9) are the fixed transformation set; `task_kind` is a dimension that varies inside two of them.

```text
task_kind:  feature | fix | refactor | rewrite | migration | upgrade
          | performance | testing | documentation        ← parameterize `implement`
          | spec-writing | research-writing | audit-writing
          | bug-report-writing                            ← parameterize `author`
          | review                                        ← selects `review`
          | orchestration | integration                  ← select `decompose` + merge-gate
          | deepen-audit                                  ← parameterizes `author` (audit)
```

### 28.2 The 18 → pass mapping

The mapping is normative (verbatim from decision record Q7.22):

| Legacy task type | Family | Pass(es) | Follow-on passes |
|---|---|---|---|
| `feature` | implementation | `implement` | `verify` → `review` |
| `fix` | implementation | `implement` | `verify` → `review` |
| `refactor` | implementation | `implement` | `verify` → `review` |
| `rewrite` | implementation | `implement` | `verify` → `review` |
| `migration` | implementation | `implement` | `verify` → `review` |
| `upgrade` | implementation | `implement` | `verify` → `review` |
| `performance` | implementation | `implement` | `verify` → `review` |
| `testing` | implementation | `implement` | `verify` → `review` |
| `documentation` | implementation | `implement` | `verify` → `review` |
| `spec-writing` | authoring | `author` (spec) | `lint` → `improve` → `lower` |
| `research-writing` | authoring | `author` (research) | `lint` → `improve` → `lower` |
| `audit-writing` | authoring | `author` (audit) | `lint` → `improve` → `lower` |
| `deepen-audit` | authoring | `author` (audit) | `lint` → `improve` → `lower` |
| `bug-report-writing` | authoring | `author` (bug-report) | `lint` → `improve` → `lower` |
| `review` | process | `review` | — |
| `orchestration` | process | `decompose` + merge-gate `review` | — |
| `integration` | process | `decompose` + merge-gate `review` | — |

Normative consequences:

- **All build/change kinds route to `implement`.** The nine implementation kinds differ only in `task_kind` (which guide/profile applies), never in pass.
- **All source-authoring kinds route to `author`,** then through the canonical authoring chain `lint → improve → lower` (a spec is authored, linted, improved, and lowered before it produces tasks).
- **`review` routes to the `review` pass.** **`orchestration` and `integration`** route to `decompose` plus a merge-gate `review`, performed under the **Lead Engineer profile** (§27).
- `documentation` is an `implement` kind (it changes a surface — docs — and is traced and verified like any other change), not an `author` kind.

`lower` and `decompose` are the two passes the legacy 18-type model lacked entirely; they are the new machinery that turns an authored spec into bounded, write-disjoint tasks (§11, §18).

### 28.3 Kickback is re-entry, not a task type

> **Normative.** `kickback` is **not** a task type. Kickback is the **re-entry of the `implement` pass** triggered by a `FAIL` or `UNVERIFIED` verdict (§14) from a `review` or `verify` pass.

A conformant repo MUST NOT define a `kickback` task type or a `kickback` value in the `task_kind` enum (build brief §26). When `review`/`verify` returns `FAIL` or `UNVERIFIED` for a required obligation, the obligation re-enters `implement` (the same task frame, re-opened, or a new `implement` task naming the failed obligation IDs); the loop is `implement → verify → review → (FAIL/UNVERIFIED) → implement` until the merge gate (§14) is satisfiable. Rationale (Q7.22): kickback describes the *control-flow edge* re-entering a pass, and modeling it as a separate task type duplicated the `implement` frame and obscured that the obligation set is unchanged.

### 28.4 The flow-graph survives as recommended routing

The legacy flow-graph (`docs/reference/flow-graph.md`, ADR 0020) survives as **recommended routing**, not as a required control structure (no runtime — Principle 1). Its nodes are relabeled onto the compiler model:

| Legacy flow-graph node | Relabeled as |
|---|---|
| document / artifact | **artifact** (the source `spec.swarm.md`, audit, research, bug-report) |
| task type | **pass** (`implement`/`author`/`review`/`decompose`) |
| lead persona | **profile** (§27) |
| recommended skill set | **pass guide(s)** (§26) |

A conformant repo SHOULD ship the flow-graph as `artifact → pass → profile → pass-guide` routing and MUST frame it as a *recommendation an agent re-assesses against the work in front of it*, never as enforcement. The per-task-type verification matrix in the legacy flow-graph is re-expressed as the default `(proof-type, phase)` suite per `task_kind`, binding through `AGENTS.md > Commands` (§15, decision record Q4.15).

### 28.5 Task-template consolidation

The 18 legacy per-type templates consolidate onto a single task template (build brief §18), which a `task_kind` value specializes. The template's load-bearing fields are `assigned_obligations`, `constraints`, `invariants`, `interfaces`, `write_surfaces`, `verification_bindings`, the promotion queue, and the self-review block (full template in §21). A task MUST paste the *exact* assigned SOL blocks (not paraphrases) into its assignment section, BECAUSE distillation that drops an obligation ID, modality, or verification binding is a distillation error (§24).

## 29. Documents as the unified artifact set

This section recasts the framework's four core document types (ADR 0001, kept verbatim) and their extended types onto the unified artifact set of the kernel (§20, §21). The recast adds the artifacts the four-document model lacked — **trace**, the **VERDICT block**, **finding**, and **memory** — and preserves each source document's **epistemic stance** (what kind of knowledge it is allowed to assert).

### 29.1 Epistemic stances are preserved

Each source document carries an epistemic stance that constrains what it may assert and where its content may be promoted (decision record Q7.23). These stances are normative and MUST be preserved by the recast:

| Artifact | Epistemic stance | Promotes to |
|---|---|---|
| `spec.swarm.md` | **intent** — declares required behavior as SOL obligations | (is the authority; lowers to tasks) |
| `audit.md` | **observation-only** — describes present state and risk; asserts no new intended behavior | a `spec.swarm.md` (via `author`) |
| `bug-report.md` | **diagnosis-only** — reproduces and root-causes a defect; prescribes no fix | a **fix task** (`implement`) |
| `research.md` | **inquiry** — surveys options and evidence; commits to no decision | a `spec.swarm.md` (via the `author` pass) |

Normative consequence: an `audit.md` MUST NOT contain `REQ`/`CONSTRAINT`/`INVARIANT` obligation blocks of its own intent — observed risk is promoted *into* a spec, where it acquires obligation force. A `bug-report.md` MUST NOT prescribe an implementation — its diagnosis promotes *into* a fix task. These are the epistemic-stance invariants of ADR 0007 (kept) and ADR 0001 (kept).

### 29.2 spec.md becomes spec.swarm.md

The legacy `spec.md` is renamed `spec.swarm.md` — the `.swarm.` infix marks it as the one human-authored compiler-visible artifact (decision record Q2.8, §20). It carries prose (under APS, §7) plus SOL blocks (§6), and it is the source that the obligation graph is built from. Everything else in the artifact set is plain `.md` (working artifacts) or an emitted `*.swarm.*` artifact (§20). A conformant repo MUST rename every `spec.md` template/reference to `spec.swarm.md` and MUST NOT introduce per-artifact `.swarm.*` names for audit/research/bug-report/finding/adr (those are plain `.md`).

### 29.3 The four artifacts the four-document model lacked

The unified artifact set adds four artifacts the four-document model had no place for. Each is specified in full by another section; this section only records that they join the catalogue and why:

| New artifact | What it is | Owning section |
|---|---|---|
| **trace** (`*.swarm.trace.md`) | an implementation claim mapped to obligation IDs + proof references; consumed by `review` | §12 (IR `implements`/`preserves` edges), §21 (template) |
| **VERDICT** (a SOL *block*, not a file) | the judged outcome of an obligation; lives inside `review.md` (there is no `verdict.md`) | §6, §14 |
| **finding** (`finding.md`) | one durable, evidenced project fact discovered during work | §21, §23 |
| **memory** (`memory/INDEX.md` + glossary + patterns) | the compact recall map + provenance store | §23 |

The VERDICT entry is load-bearing: a verdict is the *output* of a `review` pass, so it is a language block inside the review container, never a standalone artifact (decision record Q2.9). A conformant repo MUST NOT ship a `verdict.md`.

### 29.4 Extended types remain specializations

The extended document types are **specializations** of the four core artifacts, not new artifact kinds (decision record Q7.23). They reuse the parent artifact's template, frontmatter, and epistemic stance; they differ only in conventional content.

| Extended type | Specialization of | Notes |
|---|---|---|
| `constitution` | `spec.swarm.md` | project-wide obligations of highest domain authority (§22) |
| `migration-plan` | `spec.swarm.md` | obligations + ordering for a migration/upgrade |
| `benchmark` (report) | `audit.md` | observation-only performance measurement |
| `cleanup` (report) | `audit.md` | observation-only debt/risk inventory |

A conformant repo MAY ship these as named variants but MUST NOT give them their own block types, lint codes, or IR node kinds; they parse exactly as their parent artifact.

### 29.5 Forbidden compositions are distillation + authority discipline

The legacy framework enforced "forbidden compositions" (e.g. a single file that is simultaneously a spec and an audit, or content that smuggles intent into an observation-only artifact) through a gatekeeper skill. The kernel retires the gatekeeper and re-expresses the same prohibition as two existing disciplines:

- The **distillation loss budget** (§24): when content crosses an artifact boundary, the permitted/forbidden-loss table governs what may be dropped and what MUST be carried. A composition that would smuggle obligation force into an observation-only artifact is a distillation error.
- **Source authority** (§22): the two-axis authority model determines which artifact governs when two assert overlapping content; a lower-authority artifact MUST NOT silently override a higher one.

> **Normative.** Forbidden compositions are enforced by §24 (distillation) and §22 (source authority), not by a gatekeeper skill. A conformant repo MUST NOT reintroduce a skill whose job is to police artifact composition; the discipline lives in the language/reference layer.

Rationale (Q7.23): a gatekeeper skill would be a semantic owner (forbidden, §26.1) and a soft-control mechanism presented as enforcement (forbidden, §17). Routing the prohibition through distillation + authority keeps it in the authoritative layer.

## 30. ADR disposition and new kernel ADRs

This section records the disposition of every existing ADR under the kernel and lists the new kernel ADRs the rework introduces. It is governed by one rule.

### 30.1 Nygard immutability

> **Normative (ADR governance).** An accepted ADR MUST NOT be edited in place. "Amending" an ADR means publishing a **new, superseding ADR**; the original keeps its body and gains only a `Superseded by ADR-NNNN` status line. The truth of any decision is the **full chain** of ADRs, not the latest one alone.

Rationale (Nygard/Fowler): an ADR is a dated record of a decision in its context; rewriting it destroys the historical record that makes the chain auditable. ADR numbers `0011` and `0012` remain **intentionally vacant** (vacated in an earlier consolidation; left unfilled so higher references do not shift).

### 30.2 Per-ADR disposition

The 26 existing ADRs fall into three groups.

**Group A — Kept verbatim** (body unchanged; still authoritative as written):

| ADR | Title |
|---|---|
| 0001 | Four core document types |
| 0003 | Distillation flows downhill only |
| 0004 | Task files are gitignored |
| 0005 | Template placeholder syntax `{{name}}` |
| 0007 | Bug report is diagnosis-only |
| 0008 | Empirical proof is framework-level |
| 0010 | Writes single-thread through orchestrator |
| 0014 | Delegation vs internal recursion |
| 0015 | Framework versioning (**extended**, not replaced — gains the language axis + one-way trigger, §25) |
| 0016 | Skill bodies are self-contained |
| 0017 | No always-loaded skills |
| 0021 | Verification contract |
| 0022 | Acceptance criteria are executable checks |
| 0023 | Harness-enforcement contract |
| 0026 | Machine-readable conformance contract + fixtures |

0015 is annotated "extended": its body is unchanged, but a new ADR (§30.3) scopes it to the package axis and adds the language axis. ADRs 0021/0022/0023/0026 are kept verbatim and additionally gain a one-line note that they are *verification layers of the single SOL `VERIFY BY` model* (decision record Q4.15); the note is a status annotation, not a body edit.

**Group B — Amended via a new superseding ADR** (original body immutable; superseded by a 0027+ ADR that carries the recast):

| ADR | Original decision | Superseded by (new ADR) recasts it as |
|---|---|---|
| 0006 | Skeptic owns `fix` tasks | Skeptic is a **profile** on `fix`/`review` passes (§27) |
| 0009 | Personas are mindsets | personas are **heuristic profiles** (§27) |
| 0013 | Iron law + red-flags pattern | the iron law becomes a profile's `Refuses` table (§27.2) |
| 0018 | Commands resolve through `AGENTS.md` | `VERIFY BY` adapters resolve through `AGENTS.md > Commands` (§15, §31.3) |
| 0019 | Personas ship as individual skills | a standalone file is **one carrier option** for a profile (§27.1) |
| 0020 | Activation by self-assessment | doctrine is **load what the task names**; description-match is the fallback (§26.4) |
| 0024 | Self-reviewed vs reviewed confidence tiers | confidence tiers **map to the verdict taxonomy** (§14, the 7-value model) |
| 0025 | Orchestration coordination artifact | owned/forbidden paths become the **write-surface model** lowered by `lower`/`decompose` (§18, §19) |

**Group C — Already superseded** (no new action; recorded for completeness):

| ADR | Status |
|---|---|
| 0002 | Personas pair 1:1 with task types — **superseded by 0020** (and now by the profile × pass model, §27.4) |

### 30.3 New kernel ADRs (0027+)

The rework introduces the following new ADRs. Each records a kernel decision that MUST NOT be left implicit in prose; the parenthetical names the section that specifies the decision in full.

| New ADR (topic) | Records |
|---|---|
| SOL is the obligation language | SOL is the single home of obligation semantics (§5, §6) |
| APS is the prose standard | APS is the controlled-prose standard around SOL (§7) |
| The 9-pass model | `author → lint → improve → lower → decompose → implement → verify → review → promote` (§9) |
| The unified artifact set | the kernel artifact set incl. trace, VERDICT block, finding, memory (§20, §29) |
| The source-authority two-axis model | domain axis × artifact axis, lexicographic (§22) |
| The memory model | two-tier, provenance-anchored promotion (§23) |
| The golden corpus | positive + negative conformance fixtures over the three domains (§33) |
| The unified `SOL-<LAYER><NNN>` lint namespace | one prefix, five layers; APS- retired as a *code* prefix (conflict X1, §8) |
| The 7-value verdict model | 4 core + 3 lifecycle verdicts (conflict X2, §14) |

The last two are explicitly added (decision record Q7.24) because the X1 namespace unification and the X2 verdict model are kernel-level decisions that must be recorded as ADRs, not buried in the language reference. A conformant repo MUST carry these ADRs (or equivalents) so the chain explains why the lint namespace and verdict set have their shape.

## 31. The AGENTS.md bootloader

`AGENTS.md` is the **always-loaded bootloader**: the one file every task reads first. Because it is always on, its content is the most expensive context in the system and the most exposed to adherence decay. The kernel therefore caps it hard and restricts what may live in it.

### 31.1 The density cap

> **Normative.** `AGENTS.md` (and any always-loaded kernel bootloader prose) MUST NOT exceed a **hard cap of 200 lines / 25 KB**. It SHOULD target **~50–150 lines**. It MUST contain only persistent facts and gap-filling content; everything procedural or conditional MUST move to lazily-loaded pass guides (§26), profiles (§27), or reference docs.

Rationale (decision record Q-density-1): **minimize always-on density to protect adherence and control cost.** The cap is *not* anchored on a claim that models cannot follow many instructions — the legacy "IFScale 68%@500" figure is **superseded** (2026 re-runs show ≈99% adherence at far higher instruction counts) and MUST NOT be cited as the load-bearing rationale. The durable mechanism is the bloat-versus-gap-filling tradeoff: bloat costs success rate and tokens; gap-filling content (facts the model genuinely lacks) earns its place.

A conformant repo MUST include a regression check that fails when `AGENTS.md` exceeds the hard cap.

### 31.2 What goes in vs what stays out

| Belongs in `AGENTS.md` (facts) | MUST move out (procedures/conditionals) |
|---|---|
| persistent project facts the model cannot infer | step-by-step pass procedures → pass guides (§26) |
| the **Commands** contract — `cmd*` binding rows (§31.3) | how to perform a review/audit/migration → pass guides |
| one-line **pointers** into memory (`memory/INDEX.md`) | full memory content → `memory/` (§23) |
| the language-reference pointer (where SOL/APS live) | the SOL/APS manual itself → `docs/language/` |
| a small set of universal startup + universal "do not" rules | conditional, task-kind-specific rules → task templates / profiles |

The startup block names the **load-what-the-task-names** doctrine (§26.4) and the universal invariants (assigned-scope-only, evidence-for-every-claim, handle-promotions-before-close, no chat-over-spec authority). A representative compliant bootloader:

```markdown
# AGENTS.md

## Swarm startup
1. Read the task file first.
2. Treat `.swarm.md` blocks as authoritative over prose summaries.
3. Use obligation IDs as scope.
4. Load only the pass guides / profiles the task names.
5. Map every completion claim to evidence.
6. Promote durable discoveries before closing.
7. If the task needs SOL/APS rules, read `.agents/language/SOL.md` and `.agents/language/APS.md`.

## Universal rules
- Do not implement behavior outside assigned obligations.
- Do not treat chat as higher authority than an approved spec or ADR.
- Do not close a task with unhandled promotion items.
- Do not claim completion without evidence.

## Commands
<!-- cmd* bindings, §31.3 -->
```

The full SOL or APS manual MUST NOT be pasted into `AGENTS.md`. A "universal workflow rule" promotion (the §10 / §23 promotion target) resolves, per the G9 tie-break (decision record), to a **pass-guide edit plus at most a one-line pointer in `AGENTS.md`** — never an inline procedure. Rationale: ADR 0017 and the density cap reserve `AGENTS.md` for persistent *facts*; procedures live in pass guides.

### 31.3 The Commands contract

`AGENTS.md` holds the **Commands** contract: the project-level table of `cmd*` slots that `VERIFY BY` adapters resolve through (§15, ADR 0018 / its superseding ADR, decision record Q4.15). A `VERIFY BY <type>:<adapter>:<artifact>` clause names a proof type and an `<adapter>`; the adapter is a `cmd*` slot defined here.

```markdown
## Commands
| Slot          | Command                  | Resolves proof types  |
| ------------- | ------------------------ | --------------------- |
| cmdTest       | `npm test`               | test                  |
| cmdLint       | `npm run lint`           | static                |
| cmdTypecheck  | `npm run typecheck`      | static                |
| cmdBenchmark  | `npm run bench`          | perf                  |
```

Normatively:

- A `VERIFY BY` adapter MUST resolve to a `cmd*` slot present in the `AGENTS.md` Commands table; an unresolved adapter is a verification-layer lint defect (`SOL-V002`, §8) and a `BLOCKED` verdict at the gate (§14).
- The Commands table is **soft control** (§17): it names what a future launcher would run; the kernel ships no runtime that executes it. `AGENTS.md` MUST NOT claim it enforces or runs these commands.
- The Commands contract is a *fact* (a binding), which is why it is one of the few procedural-adjacent things permitted in the bootloader: it is data the model and a future launcher both need, not a procedure.

A conformant repo MUST populate the Commands table for every proof type any of its `VERIFY BY` clauses reference; a missing required `cmd*` row is one of the negative conformance-fixture classes (§33).

I have sufficient grounding. Drafting §32-§35 now.

## 32. The conformance contract

### 32.1 Purpose and placement

This section specifies the machine-readable conformance encoding that a Swarm repository MUST ship under `scaffold/.agents/conformance/`. The encoding is **inert versioned DATA**: it is the precise, testable definition that a future checker would honour, and the artifact a human uses to validate a repository by hand today. Per Invariant 1 (NO RUNTIME, see §2), nothing under `scaffold/.agents/conformance/` executes; Swarm ships the contract, never the checker (§32.7).

The conformance directory MUST contain exactly:

| Path | Kind | Role |
|---|---|---|
| `scaffold/.agents/conformance/conformance.yaml` | manifest (data) | the task-file schema, command rows, placeholder set, lint scheme, required-suite matrix |
| `scaffold/.agents/conformance/README.md` | prose | states inertness, provenance, and the "checker is deferred" framing |
| `scaffold/.agents/conformance/fixtures/` | fixture suite | the golden corpus (§33) |

Rationale: ADR 0026 makes the conformance contract a framework artifact; SARIF precedent (an OASIS JSON-schema contract independent of any analyzer) establishes that a contract is publishable and useful without a shipped tool.

### 32.2 The conformance DEFINITION (restated from §20, normative)

A repository is **Swarm-conformant** if and only if it satisfies all four clauses below. This restates §20; §32 is the machine-readable encoding of clauses (b)–(d).

| # | Clause | Checkable evidence |
|---|---|---|
| (a) | **Language references present** | the kernel-required language/reference docs exist: SOL ref, APS ref, the lint/error taxonomy (`SOL-<LAYER>NNN`), source-authority, promotion-protocol, distillation-loss-budget |
| (b) | **The 7 core templates exist** | `spec.swarm.md`, `task.md`, `trace.md`, `review.md`, `finding.md`, `adr.md`, `memory/INDEX.md` are present as copyable templates |
| (c) | **Populated `AGENTS.md` bootloader** | `AGENTS.md` exists, is ≤200 lines / ≤25 KB, and its `Commands` table binds at least the required command rows (§32.4) |
| (d) | **`.agents/.swarm-version` present** | the framework/package version file exists and holds a semver string (ADR 0015) |

A repo that fails any clause is **non-conformant**. The checker (§32.7) consumes this definition; the `conformance.yaml` manifest encodes the mechanically-checkable parts of (b)–(d).

### 32.3 The task-file schema (`conformance.yaml > task_file`)

The manifest MUST encode, as inert data, the structural and content rules a well-formed `task.md` satisfies. The schema is keyed to the §21 `task.md` template.

```yaml
# conformance.yaml — task-file schema (excerpt; inert data, Swarm runs nothing)
version: 0.1.0
language: SOL/0.1                 # the discriminator this manifest targets (§25, meta.language)
task_file:
  required_sections:             # H2 headings that MUST be present
    - Objective
    - Linked docs
    - Plan
    - Self-review
  required_subsections:
    - parent: Self-review
      heading: Verification outputs
  content_rules:
    - id: non-empty-paste
      applies_to: "Self-review > Verification outputs"
      rule: >-
        every required paste slot holds non-empty, non-placeholder text — a fenced
        command-output block, or `n/a` with a one-line reason — never a bare
        `[Paste output]` placeholder.
    - id: no-open-critical
      applies_to: Open questions
      rule: "no blocking QUESTION (or [CRITICAL] open question) remains unresolved when status: done."
```

A conformant `task.md` MUST present every `required_sections` heading and every `required_subsections` entry, and MUST satisfy every `content_rules` entry. `content_rules.non-empty-paste` is the single most load-bearing rule: it surfaces the hallucinated-completion hole (a "tests passed" claim with no pasted output is an invalid proof, per §15 and Invariant 5 — schema-valid output is NOT verification).

### 32.4 Required command rows (`conformance.yaml > agents_md`)

The manifest MUST enumerate the `AGENTS.md > Commands` rows a conformant repo binds. `<adapter>` slots in SOL `VERIFY BY` bindings resolve through this table (§15); a binding whose adapter has no row is unresolvable.

```yaml
agents_md:
  required_command_rows: [cmdValidate, cmdTest, cmdFormat]
  extended_command_rows: [cmdInstall, cmdTypecheck, cmdLint, cmdBuild, cmdValidateDeps, cmdBenchmark]
  out_of_contract:       [cmdMarkdownLint, cmdLinkCheck, cmdCitationCheck]
```

| Tier | `cmd*` slots (§31.3) | Conformance force |
|---|---|---|
| required | `cmdValidate`, `cmdTest`, `cmdFormat` | MUST be present; absence is non-conformant. These are the `cmd*` slots that VERIFY BY adapters in §15.3 MUST be able to resolve. |
| extended | `cmdInstall`, `cmdTypecheck`, `cmdLint`, `cmdBuild`, `cmdValidateDeps`, `cmdBenchmark` | SHOULD be present when the project's required-suite (§32.6) references them BECAUSE an unbound adapter makes the suite unresolvable |
| out-of-contract | `cmdMarkdownLint`, `cmdLinkCheck`, `cmdCitationCheck` | MAY be present; never required |

For the full `cmd*` slot vocabulary and resolver contract see §31.3 and §15.3.

### 32.5 The legal placeholder set (`conformance.yaml > placeholders`)

Templates use placeholder tokens (e.g. `{{cmdTest}}`) that a runner substitutes. The manifest MUST encode the legal placeholder namespaces.

```yaml
placeholders:
  legal_prefixes: ["cmd", "", "swarm:", "project:"]   # "" = framework scaffolding names
  rule: >-
    a runner substitutes every required placeholder and leaves unrecognised ones
    untouched; it does not introduce names in the cmd*/no-prefix namespace without an ADR.
```

| Namespace | Example | Status |
|---|---|---|
| `cmd*` | `{{cmdValidate}}`, `{{cmdTest}}` | reserved; resolves to an `AGENTS.md > Commands` row; new `cmd*` names require an ADR (ADR 0005/0018) |
| `""` (no prefix) | `{{title}}`, `{{slug}}` | framework scaffolding names; reserved as above |
| `swarm:` | `{{swarm:version}}` | framework-owned values |
| `project:` | `{{project:name}}` | consumer-owned values; free to define |
| `vendor:` (any other prefix) | `{{vendor:frobnicate}}` | legal vendor extension; a runner leaves it untouched |

A template introducing a new `cmd*` or no-prefix name without an ADR is non-conformant (illegal-placeholder class, §33).

### 32.6 The unified lint scheme and required-suite matrix

The manifest MUST encode the unified lint scheme (§8) as inert data so the checker and corpus reference one namespace: a single prefix `SOL`, five layers, form `SOL-<LAYER>NNN`. Every diagnostic record has the shape `{code, severity, layer, span, message, suggest}`.

```yaml
lint:
  scheme: "SOL-<LAYER>NNN"
  layers: { S: SYNTAX, P: PROSE, M: SEMANTIC, V: VERIFICATION, O: ORCHESTRATION }
  record_shape: [code, severity, layer, span, message, suggest]
  catalogue_ref: docs/language/errors.md      # the full catalogue is the source of truth (Appendix B)
  retired_prefixes: [APS-]                     # APS- is no longer a code prefix
```

The manifest MUST also encode the per-task-type required verification suite (the `(proof-type, phase)` defaults of §15, resolving to `cmd*` slots). The canonical matrix lives in `docs/reference/flow-graph.md`; the manifest is its machine-readable shadow.

```yaml
required_suite:
  feature:            [Validation, Test, ValidateDeps, acceptance-criteria-coverage]
  fix:                [Validation, Test, regression-test]
  refactor:           [ValidateDeps, Typecheck, Test, behaviour-preservation]
  # … one row per task_kind; full matrix mirrors flow-graph.md …
  orchestration:      [merged-Validation, merged-Test, scope-disjointness, merge-intent]
```

### 32.7 The CLI command surface (documented contract only, not shipped)

Swarm documents the verb set a future launcher would expose. This is **what a future launcher would expose**, never **a tool Swarm provides** (Q3.11, Invariant 1). The surface MUST appear in `docs/language/` as a one-page "tooling contract (not shipped)" note carrying that banner.

| Verb | Phase(s) it would drive | Documented contract |
|---|---|---|
| `lint` | PARSE, NORMALIZE | emit `diagnostics[]` of `SOL-<LAYER>NNN` records against a `*.swarm.md` source |
| `build-ir` | PARSE → NORMALIZE | emit `*.swarm.ir.json` (the §12 envelope) |
| `plan` | LOWER | emit `*.swarm.plan.json` (the §13 plan) |
| `verify` | VERIFY | run resolved `cmd*` adapters, record core verdicts + lifecycle decorators |
| `promote` | PROMOTE | apply the §23 promotion protocol to findings |

```text
# Tooling contract (NOT SHIPPED). Swarm is markdown-only (Invariant 1).
# This is the surface a future launcher would build against, not a tool Swarm provides.
swarm lint      <spec>.swarm.md            -> diagnostics[] (SOL-<LAYER>NNN)
swarm build-ir  <spec>.swarm.md            -> <spec>.swarm.ir.json
swarm plan      <spec>.swarm.ir.json       -> <spec>.swarm.plan.json
swarm verify    <task>.md                  -> verdicts (core + lifecycle)
swarm promote   <finding>.md               -> memory/INDEX.md update
```

The checker that would consume `conformance.yaml` is itself part of this deferred surface (a `swarm conform`-class verb). Until a launcher exists, the contract still serves: a human validates a repo against it by hand, and the fixtures (§33) pin the expected verdicts independently of any tool.

## 33. The golden corpus

### 33.1 Purpose and placement

The golden corpus is the conformance suite that pins expected verdicts **independent of any tool**, satisfying compiler-conformance practice (SuperTest/OpenJDK/SpecTest: a suite needs both allowed and disallowed productions whose conformity is known without the tool under test). It MUST ship in two locations:

| Location | Holds | Audience |
|---|---|---|
| `scaffold/.agents/conformance/fixtures/` | positive + negative fixtures with expected verdicts | the checker's regression suite (§32) |
| `docs/examples/` | the three pipeline-complete positive walkthroughs | human readers / authors learning the pipeline |

The corpus is built on the three recurring domains — **auth-refresh**, **checkout**, **payment-5xx** — each with positive (must-compile) and negative (must-be-rejected) fixtures.

### 33.2 The full pipeline chain (every positive fixture)

Each positive domain fixture MUST ship the complete pipeline chain, one file per stage, so the corpus exercises the whole `intent → promotion` arc (§27 of the brief):

```text
spec.swarm.md  →  expected obligation list  →  task frame  →  trace  →  verdict  →  promotion
```

| Stage | Fixture file | Asserts |
|---|---|---|
| source spec | `<domain>.swarm.md` | parses clean; only `MUST`-class modals; INVARIANT present |
| expected obligations | `<domain>.expected-obligations.md` | the obligation list a correct `build-ir` would emit (ids, kinds, edges) |
| task frame | `<domain>.task.md` | assigned obligations, write surfaces, verification bindings |
| trace | `<domain>.swarm.trace.md` | `IMPLEMENTS`/`PRESERVES`/`PROOF` claims with content hashes |
| verdict | `<domain>.review.md` | per-obligation `VERDICT` blocks; final verdict reaches the merge gate |
| promotion | `<domain>.finding.md` | the durable finding the pass promotes |

The expected end-state verdict is recorded in the spec fixture's header and is known independent of any tool.

### 33.3 Canonical defect class per domain

Each domain carries one canonical defect class (or small cluster), encoded with unified `SOL-<LAYER>NNN` codes (§8). The positive variant proves the obligation the negative violates.

#### 33.3.1 auth-refresh — dangling condition, SHOULD-without-BECAUSE, missing verification

| Variant | Construct | Expected |
|---|---|---|
| negative | dangling condition (trigger with no modal consequence) | reject, `SOL-S001` |
| negative | `SHOULD` with no `BECAUSE`/`EXCEPT` | reject, `SOL-S006` |
| negative | obligation with no `VERIFY BY` | reject, `SOL-V001` |
| positive | a bound `VERIFY BY test:…` proving a no-unbounded-retry `INVARIANT` | PASS |

```sol
# auth-refresh.swarm.md — NEGATIVE (expected: REJECTED)

REQ AC-001:
  WHEN the refresh token is expired      # dangling: trigger with no THE <actor> <MODAL> consequence
                                         # -> SOL-S001 (precondition with no actor clause)

REQ AC-002:
  WHEN a 401 is returned
  THE client SHOULD retry the request    # SHOULD with no BECAUSE/EXCEPT -> SOL-S006
  VERIFY BY test:cmdTest:auth.retry.test

REQ AC-003:
  WHEN the access token is refreshed
  THE client MUST persist the new token  # no VERIFY BY -> SOL-V001 (no verification path)
```

```sol
# auth-refresh.swarm.md — POSITIVE (expected: PASS)

INVARIANT I-001:
  the number of automatic refresh attempts per request MUST NOT exceed 1
  VERIFY BY test:cmdTest:auth.refresh.bounded.test#no_unbounded_retry

REQ AC-001:
  WHEN the access token is expired AND a request is attempted
  THE client MUST refresh the token once before retrying
  BECAUSE an unbounded retry loop drains the auth service
  VERIFY BY test:cmdTest:auth.refresh.test#single_attempt
```

#### 33.3.2 checkout — bundled obligation atomized, write-surface conflict marked parallel

| Variant | Construct | Expected |
|---|---|---|
| negative | one REQ bundling multiple obligations | reject, `SOL-P004`; `ATOMIZE` repair |
| negative | two obligations sharing a write surface marked parallel | reject, `SOL-O301` |
| positive | the same obligations atomized + serialized on the shared surface | PASS |

```sol
# checkout.swarm.md — NEGATIVE (expected: REJECTED)

REQ AC-010:
  WHEN the cart is submitted
  THE service MUST validate the cart AND charge the card AND email the receipt
  # bundled/overloaded: 3 obligations in one -> SOL-P004 (ATOMIZE into AC-010/011/012)
  VERIFY BY test:cmdTest:checkout.test

REQ AC-011:
  THE service MUST write the order record
  WRITES db/orders
REQ AC-012:
  THE service MUST write the inventory ledger
  WRITES db/orders          # same write surface as AC-011, planned parallel -> SOL-O301
```

The positive variant splits `AC-010` into three single-obligation REQs and gives `AC-011`/`AC-012` disjoint write surfaces (or a `DEPENDS ON` edge serializing them), satisfying the §18 safe-parallelism predicate.

#### 33.3.3 payment-5xx — blocking QUESTION, MUST-vs-MUST-NOT contradiction, high-risk word

| Variant | Construct | Expected |
|---|---|---|
| negative | a `blocking` `QUESTION` still unresolved at lowering | reject, `SOL-O` (orchestration; blocking QUESTION reaching lowering) |
| negative | `MUST` and `MUST NOT` on the same trigger | reject, `SOL-M002` (contradiction) |
| negative | "handle failures gracefully" with no observable criterion | reject, `SOL-P005` (vague-quality high-risk word) |
| positive | the QUESTION resolved, contradiction deconflicted, the vague clause concretized | PASS |

```sol
# payment-5xx.swarm.md — NEGATIVE (expected: REJECTED)

QUESTION Q-001: blocking
  Should a 503 from the processor be retried or surfaced to the user?
  AFFECTS AC-020                       # blocking QUESTION reaching lowering -> SOL-O

REQ AC-020:
  WHEN the processor returns a 5xx
  THE service MUST retry the charge
  AND THE service MUST NOT retry the charge   # MUST vs MUST NOT, one trigger -> SOL-M002
  VERIFY BY test:cmdTest:payment.5xx.test

REQ AC-021:
  WHEN a payment fails
  THE service MUST handle failures gracefully  # "gracefully" -> SOL-P005 (no observable criterion)
  VERIFY BY test:cmdTest:payment.fail.test
```

### 33.4 Negative fixtures: task-file classes and one syntax negative per error family

Beyond the domain defects, the corpus MUST include the ADR 0026 task-file classes and one SOL syntax negative per error-code family.

| Class | Fixture | Rule broken | Expected |
|---|---|---|---|
| empty paste | a `task.md` whose `Verification outputs` slots are bare | `content_rules.non-empty-paste` | FAIL |
| missing required verification slot | a `refactor` task with no `behaviour-preservation` evidence | `required_suite.refactor` | FAIL |
| illegal placeholder | a template introducing `{{cmdFrobnicate}}` without an ADR | `placeholders.rule` | FAIL |
| missing `Commands` row | an `AGENTS.md` omitting `Format` | `agents_md.required_command_rows` | FAIL |
| unresolved blocking QUESTION at close | `status: done` with an open blocking QUESTION | `content_rules.no-open-critical` | FAIL |

Additionally, the corpus MUST ship at least one minimal syntax negative for each `SOL-S` error family (e.g. `SOL-S001` dangling condition, `SOL-S003` actor clause with no modal, `SOL-S005` prefix↔type mismatch, `SOL-S006` SHOULD-without-BECAUSE), so every error-code family has a guarding fixture.

### 33.5 Prose precision/recall baseline (G12)

The `SOL-P` prose rules are heuristic and so carry a measurable false-positive risk. The corpus MUST ship a **labeled good/bad prose fixture set** so the high-risk-word list's accuracy is measurable. The baseline targets are normative for v0.1:

| Metric | Target | Meaning |
|---|---|---|
| precision | ≥ 0.90 | of spans a `SOL-P` rule flags, ≥90% are true defects (few false positives) |
| recall | ≥ 0.85 | of true prose defects present, ≥85% are flagged (few misses) |

```yaml
# fixtures/prose/labels.yaml — labeled SOL-P corpus (inert data)
- id: P-001
  text: "THE service MUST handle failures gracefully"
  label: bad
  expect: SOL-P005      # high-risk word, no observable criterion
- id: P-002
  text: "THE service MUST return HTTP 503 within the 30s budget"
  label: good
  expect: none          # observable criterion present on the same line
```

The labeled set lets a future linter's precision/recall be computed against ground truth without running on production specs; until a linter exists, the labels document the intended accuracy bar.

## 34. Acceptance criteria for the repo rework

This section is the checkable acceptance checklist for when this specification drives the repository rework. Each item is phrased as a verifiable check (a search, a file-existence test, or a count reconciliation). The rework is complete only when every check passes.

### 34.1 Source-file reconciliation

| # | Check | How to verify |
|---|---|---|
| A1 | Every `*sources change*` note in the decision record is applied | `sol.md`, `swarm-sol.md`, `compiler.md`, and the build brief reflect each per-question reconciliation (Q1.1–Q9.31); no file retains a superseded construct |
| A2 | The four cross-cluster conflicts (X1–X4) are resolved one way each | one lint namespace (X1), one verdict set (X2), one `VERIFY BY` form (X3), surface/IR casing split (X4) appear consistently across all docs |

### 34.2 Template and catalogue existence

| # | Check | How to verify |
|---|---|---|
| A3 | The 7 core templates exist in `scaffold/.agents/templates/` | `spec.swarm.md`, `task.md`, `trace.md`, `review.md`, `finding.md`, `adr.md`, `memory/INDEX.md` are each present and copyable |
| A4 | No `verdict.md` template exists anywhere in the scaffold | a search for `verdict.md` returns no scaffold template; VERDICT lives as a block inside `review.md` |
| A5 | The lint catalogue is published | `docs/language/errors.md` lists every `SOL-<LAYER>NNN` code with `{code, severity, layer, span, message, suggest}` and the legacy translation table (Appendix B) |

### 34.3 Conformance and corpus shipping

| # | Check | How to verify |
|---|---|---|
| A6 | The conformance manifest ships | `scaffold/.agents/conformance/conformance.yaml` encodes the task-file schema, command rows, placeholder set, lint scheme, and required-suite matrix (§32) |
| A7 | The golden corpus ships | `scaffold/.agents/conformance/fixtures/` holds positive + negative fixtures for auth-refresh, checkout, payment-5xx, plus the task-file classes (§33) |
| A8 | The three pipeline-complete positives ship | `docs/examples/` holds the full `spec → obligations → task → trace → verdict → promotion` chain for each of the three domains |
| A9 | The labeled prose corpus ships with stated targets | a good/bad `SOL-P` fixture set exists with the 0.90 precision / 0.85 recall baseline recorded (§33.5, G12) |

### 34.4 Count reconciliation

Every enumerated count MUST reconcile identically across the language docs, the skills/pass-guide docs, and `docs/reference/flow-graph.md`.

| # | Count | Value | Reconciles across |
|---|---|---|---|
| A10 | block types | 7 | SOL ref, IR schema, conformance manifest |
| A11 | modals | 5 | SOL ref, APS ref, lint catalogue |
| A12 | verdicts | 7 (4 core + 3 lifecycle) | SOL ref, review template, IR `status` enum |
| A13 | proof types | 9 | proof taxonomy, `VERIFY BY` grammar, flow-graph |
| A14 | phases / passes | 7 / 9 | pass model, flow-graph, skills README |
| A15 | improve operations | 10 | improve-op set, improve pass guide, lint mapping |
| A16 | lint layers | 5 (S/P/M/V/O) | lint catalogue, conformance manifest, IR `diagnostics[]` |

A count that differs between any two of these documents is a failing check.

### 34.5 ADR ledger

| # | Check | How to verify |
|---|---|---|
| A17 | The ADR ledger is updated per §30 | `docs/adrs/README.md` carries rows for every kept/amended/superseded/new ADR; amended ADRs show only a "Superseded by ADR-00XX" status line, bodies immutable (Nygard) |
| A18 | New kernel ADRs (0027+) are recorded | SOL-as-obligation-language, APS-as-prose-standard, the 9-pass model, the artifact set, source-authority, memory model, golden corpus, the unified lint namespace (X1), and the 7-value verdict model (X2) each have an ADR |

### 34.6 Zero surviving retired constructs

Each retired construct MUST have zero surviving instances. Each row is a search that MUST return no matches in any shipped file.

| # | Retired construct | Search pattern (MUST return nothing) | Replaced by |
|---|---|---|---|
| A19 | `SHALL` / `SHALL NOT` | `\bSHALL\b` | `MUST` / `MUST NOT` |
| A20 | `ALWAYS` / `NEVER` in invariants | `\b(ALWAYS\|NEVER)\b` in INVARIANT clauses | `MUST` / `MUST NOT` |
| A21 | fenced `:::END` / `:::TYPE` SOL blocks | `:::END` and `:::REQ`/`:::CONSTRAINT`/… | bare-header `TYPE PREFIX-NNN:` form |
| A22 | `VERIFY_BY` underscore (surface) | `VERIFY_BY` outside IR/JSON context | `VERIFY BY` (two words) |
| A23 | `APS-` lint-code prefix | `APS-[A-Z]?[0-9]` | `SOL-<LAYER>NNN` |
| A24 | `POLICY` / `INV` block types | `\b(POLICY\|INV)\b` as a block header | `CONSTRAINT` / `INVARIANT` (full words) |
| A25 | `locks` primitive | `\blocks\b` as a SOL/IR field | named `SURFACE` write groups |
| A26 | `verdict.md` artifact | `verdict\.md` | VERDICT block inside `review.md` |
| A27 | "kickback task type" | `kickback` as a task type | re-entry of `implement` after FAIL/UNVERIFIED |
| A28 | "CLI required" / "tests passed" framing | the §26 forbidden-framing list | "future launcher / not shipped"; pasted proof output |

### 34.7 Acceptance gate

The rework MUST satisfy A1–A28. The gate is the merge-gate analogue (§14): every check is the conformance equivalent of a required obligation, and the rework promotes only when all are satisfied. A single failing check blocks acceptance; there is no partial-conformance state.

## 35. Non-goals and deferred-to-v0.2

### 35.1 Non-goals (out of scope for every version unless a future ADR reopens them)

These are not omissions to be filled later; they are deliberate boundaries that follow from the invariants (§2).

| # | Non-goal | Rationale |
|---|---|---|
| N1 | **No shipped CLI, runtime, scheduler, differ, or parser** | Invariant 1 (NO RUNTIME). Everything that "runs" is documented as a contract a future tool builds against (§32.7), never shipped by this repo |
| N2 | **No checker shipped** | the conformance contract (§32) and corpus (§33) are inert data; the checker is a deferred launcher concern |
| N3 | **Provider-neutral** | the spec makes no assumption about which model or agent runs it; SOFT control is context, not enforcement (Invariant 2). No section names a vendor as load-bearing |
| N4 | **Output reproducibility is a non-goal** | sampling, temperature, and determinism are launcher concerns; Swarm specifies obligations and proofs, not the generative process that satisfies them |
| N5 | **No live multi-agent orchestration** | the kernel ships the static coordination contract (declarations + two graphs + the safe-parallelism predicate + the artifact schema, §18); live scheduling, stall detection, and inter-agent wire protocols (A2A/MCP) are launcher concerns |
| N6 | **No enforcement claim** | Invariant 2: prose/SOL/APS/skills/`AGENTS.md` are SOFT control and MUST NOT be presented as enforcement; the deterministic enforcement lane (§17) is today aspirational/manual |

### 35.2 Deferred to v0.2 (recorded now, specified later)

These features are explicitly deferred. v0.1 conformance MUST NOT depend on them, and a v0.1 spec MUST NOT use the deferred surface syntax (it is a syntax error today).

| # | Deferred feature | Why deferred | v0.2 direction |
|---|---|---|---|
| D1 | **Timing semantics** — `WITHIN`, `BEFORE`, `UNTIL`, `IMMEDIATELY`, `EVENTUALLY` | sound timing needs real temporal-logic semantics, not opaque keywords | FRETish-style temporal logic binding to proofs (needs the §15 proof model) |
| D2 | **Expression sublanguage for conditions** | v0.1 treats the `WHERE`/`WHILE`/`WHEN`/`IF` condition body as opaque text | a typed expression grammar so conditions are machine-evaluable |
| D3 | **Cross-spec ID import syntax** | v0.1 qualifies a cross-spec reference inline as `spec-id:AC-001` but has no import declaration | a declared import/namespace mechanism |
| D4 | **The fenced `:::TYPE` editor alias** | bare-header `TYPE PREFIX-NNN:` is the only normative form (Q1.1); fenced blocks are fragile to parse | an OPTIONAL editor-robustness alias that lowers to the bare form |
| D5 | **Memory automation** — embedding/dense retrieval, LRU eviction, automatic staleness hashing, cross-session identity, dashboards | Invariant 1 (NO RUNTIME); the kernel ships the provenance/staleness *fields* (§23), automation needs a runtime | a launcher that computes hashes, evicts, and retrieves against the shipped fields |

```sol
# v0.2-DEFERRED syntax — REJECTED in a v0.1 spec (illustrative)
REQ AC-099:
  WHEN a 503 is returned
  THE service MUST retry WITHIN 200ms     # WITHIN is timing -> deferred (D1); SOL-S syntax error in v0.1
  VERIFY BY test:cmdTest:retry.test
```

Each deferred feature is recorded so v0.2 authors inherit the intent without reopening a settled v0.1 decision (§30). The one-way version trigger (§25) applies: adding any of D1–D4 is a language change that forces at least a framework MINOR release.

---


Here is the final content.

## Appendix A — Consolidated SOL grammar (EBNF)

This appendix is the single normative grammar for the SOL surface syntax (the human-authored `.swarm.md` language). It supersedes the three competing grammars in the research corpus (the fenced `:::TYPE … :::END` + in-block YAML form, the significant-indentation `Indent`/`Dedent` form, and the colon-less header form); each of those is non-conformant. A conformant `.swarm.md` parser MUST accept exactly the language this grammar generates and MUST reject any input outside it. The IR/JSON layer is NOT specified here — see §12 and Appendix C; surface keywords are space-separated uppercase, IR fields are snake_case (per the master surface-vs-IR layering, §3, §4).

The grammar is **line-oriented**: a block is a bare header line `TYPE PREFIX-NNN:` followed by contiguous non-blank body lines, terminated by the next block header, a blank line, or a Markdown heading (`#`). There is no closing delimiter and no significant indentation. Keywords are UPPERCASE and case-sensitive; lowercase `must`/`should`/`may` and lowercase keywords carry no force and are parsed as prose (§5, §7). In v0.1 the arguments of conditions (`WHERE`/`WHILE`/`WHEN`/`IF`) are **opaque text** (`condition_text` below): the structured expression sublanguage and the timing keywords (`WITHIN`, `BEFORE`, `UNTIL`, `IMMEDIATELY`, `EVENTUALLY`) are deferred to v0.2 (Q1.6, Q1.7; see §35, Appendix E).

### A.1 Normative EBNF

```ebnf
(* ===== Document and frontmatter ===== *)
document          = [ frontmatter ] , { markdown_line | blank | surface_decl | block } ;

frontmatter       = "---" , nl ,
                    fm_language , fm_aps , fm_spec_version ,
                    { fm_other } ,
                    "---" , nl ;
fm_language       = "swarm_language" , ":" , ws , "SOL/" , version_num , nl ; (* discriminator, e.g. SOL/0.1 *)
fm_aps            = "aps_version" , ":" , ws , version_num , nl ;             (* e.g. 0.1 *)
fm_spec_version   = "spec_version" , ":" , ws , semver , nl ;                 (* content version, e.g. 0.1.0 *)
fm_other          = yaml_key , ":" , ws , yaml_scalar , nl ;                  (* spec id, title, status, owners, imports *)

markdown_line     = ? any line not beginning a block header and not "---" ? , nl ;
blank             = ws , nl ;

(* ===== Surface declarations (lock groups are named SURFACEs; there is no `locks` primitive) ===== *)
surface_decl      = "SURFACE" , ws , surface_name , ws , "=" , ws ,
                    glob , { ws , "," , ws , glob } ,
                    [ ws , "[" , surface_attr , "]" ] , nl ;     (* attr per G7: append-only|integration|shared *)
surface_attr      = "append-only" | "integration" | "shared" ;

(* ===== Block: bare header dispatches to a type-specific, line-grouped body =====
   The body of any block is the maximal run of contiguous non-blank lines after the
   header, terminated by the next block_header, a blank line, or a Markdown heading.
   The header type selects which body production those grouped lines MUST satisfy. *)
block             = ( req_header        , nl , req_body        )
                  | ( constraint_header , nl , constraint_body )
                  | ( invariant_header  , nl , invariant_body  )
                  | ( interface_header  , nl , interface_body  )
                  | ( question_header   , nl , question_body   )
                  | ( trace_header      , nl , trace_body      )
                  | ( verdict_header    , nl , verdict_body    ) ;

req_header        = "REQ"        , ws , req_id        , ":" ;
constraint_header = "CONSTRAINT" , ws , constraint_id , ":" ;
invariant_header  = "INVARIANT"  , ws , invariant_id  , ":" ;
interface_header  = "INTERFACE"  , ws , interface_id  , ":" ;
question_header   = "QUESTION"   , ws , question_id   , ws , question_tag , ":" ;
trace_header      = "TRACE"      , ws , trace_id      , ":" ;
verdict_header    = "VERDICT"    , ws , obligation_id , ":" , ws , verdict_value ; (* value on header line *)

(* ===== Identifiers: per-type short prefixes (Q1.5). Surface ids only; IR ids may be namespaced. ===== *)
req_id            = "AC-" , digits ;
constraint_id     = "C-"  , digits ;
invariant_id      = "I-"  , digits ;
interface_id      = "IF-" , digits ;
question_id       = "Q-"  , digits ;
trace_id          = "T-"  , digits ;
obligation_id     = req_id | constraint_id | invariant_id ;   (* VERDICT reuses the judged obligation id *)
cross_spec_ref    = spec_id , ":" , ( req_id | constraint_id | invariant_id
                                    | interface_id | question_id | trace_id ) ;
digits            = digit , { digit } ;

(* ===== REQ clause grammar, in canonical order (Q1.6) ===== *)
req_body          = [ where_clause ]
                    [ while_clause ]
                    [ when_clause ]
                    [ if_clause ]
                    actor_clause
                    { and_actor_clause }      (* AND THE …: permitted; lowered to multiple IR obligations (G3) *)
                    [ because_clause ]
                    [ except_clause ]
                    verify_line
                    { metadata_clause } ;

where_clause      = "WHERE" , ws , condition_text , nl ;
while_clause      = "WHILE" , ws , condition_text , nl ;
when_clause       = "WHEN"  , ws , condition_text , nl ;        (* THEN forbidden after WHEN *)
if_clause         = "IF"    , ws , condition_text , [ ws , "THEN" ] , nl ; (* THEN optional sugar after IF only *)
condition_text    = ? opaque free text, one line (no structured expression in v0.1) ? ;

actor_clause      = "THE" , ws , actor , ws , modal , ws , response , nl ;
and_actor_clause  = "AND" , ws , "THE" , ws , actor , ws , modal , ws , response , nl ;
actor             = ? noun phrase naming the responsible agent/system ? ;
response          = ? verb phrase: the required behavior ? ;

because_clause    = "BECAUSE" , ws , prose_text , nl ;          (* mandatory companion to SHOULD/SHOULD NOT *)
except_clause     = "EXCEPT"  , ws , prose_text , nl ;          (* alternative companion to SHOULD/SHOULD NOT *)

(* ===== CONSTRAINT ===== *)
constraint_body   = actor_clause
                    { and_actor_clause }
                    [ because_clause ]
                    [ except_clause ]
                    verify_line
                    { metadata_clause } ;

(* ===== INVARIANT: <property> MUST|MUST NOT <hold> (no ALWAYS/NEVER) ===== *)
invariant_body    = property , ws , inv_modal , ws , hold_text , nl ,
                    verify_line ,
                    { metadata_clause } ;
property          = ? noun phrase naming the invariant property/state ? ;
inv_modal         = "MUST" | "MUST NOT" ;                       (* only these two for INVARIANT *)
hold_text         = ? verb phrase asserting the held property ? ;

(* ===== INTERFACE: RETURNS, ACCEPTS, ERRORS, OWNED BY; requires VERIFY BY contract (Theme-5 gap-fill) ===== *)
interface_body    = signature , ws , "RETURNS" , ws , type_ref , nl ,
                    [ accepts_block ]
                    [ errors_block ]
                    verify_line ,                                (* MUST be a contract: proof (lint SOL-V…) *)
                    [ owned_by_clause ]
                    { metadata_clause } ;
signature         = "`" , ? function/endpoint signature ? , "`" ;
type_ref          = "`" , ? type expression ? , "`" | bare_type ;
accepts_block     = "ACCEPTS:" , nl , list_item , { list_item } ;
errors_block      = "ERRORS:"  , nl , list_item , { list_item } ;
list_item         = ws , "-" , ws , prose_text , nl ;
owned_by_clause   = "OWNED BY" , ws , owner_ref , nl ;

(* ===== QUESTION: tag + AFFECTS ===== *)
question_tag      = "[" , ( "blocking" | "non-blocking" ) , "]" ;  (* lowercase tag, on the header line *)
question_body     = question_text , nl ,
                    "AFFECTS" , ws , ref_list , nl ;
question_text     = ? opaque free text stating the ambiguity ? ;

(* ===== TRACE: IMPLEMENTS, PRESERVES, CHANGED, PROOF ===== *)
trace_body        = "IMPLEMENTS" , ws , ref_list , nl ,
                    [ "PRESERVES" , ws , ref_list , nl ]
                    [ "CHANGED" , ws , path_list , nl ]
                    proof_line , { proof_line } ;
proof_line        = "PROOF" , ws , verify_ref , ws , proof_result , nl ;
proof_result      = "passed" | "failed" | "blocked" | "unverified" ;

(* ===== VERDICT: core value on header; REASON, EVIDENCE in body ===== *)
verdict_body      = "REASON"   , ws , prose_text , nl ,
                    "EVIDENCE" , ws , evidence_ref , nl ;
verdict_value     = verdict_core , [ ws , verdict_lifecycle ] ;
verdict_core      = "PASS" | "FAIL" | "BLOCKED" | "UNVERIFIED" ;
verdict_lifecycle = "(" , lifecycle , " by " , authority , ": " , reason , ")" ;
lifecycle         = "WAIVED" | "STALE" | "CONTRADICTED" ;

(* ===== VERIFY BY binding (X3 / Q4.14): typed, closed 9-set ===== *)
verify_line       = "VERIFY BY" , ws , verify_ref , nl ;
verify_ref        = proof_type , ":" , adapter , ":" , artifact , [ "#" , selector ] ;
proof_type        = "static" | "test" | "contract" | "property" | "model"
                  | "perf"   | "security" | "manual" | "monitor" ;          (* closed; no other type is legal *)
adapter           = ? project free-string; resolves through AGENTS.md > Commands (cmd* slot) ? ;
artifact          = ? project free-string; file/target the adapter runs ? ;
selector          = ? optional sub-target, e.g. a test name or invariant name ? ;
(* test scope qualifiers are spelled in the adapter position: test:unit:… test:integration:… test:e2e:… *)

(* ===== Trailing metadata clauses (surface = space-separated UPPERCASE, X4) ===== *)
metadata_clause   = depends_on | touches | writes | reads | affects | risk ;
depends_on        = "DEPENDS ON" , ws , ref_list  , nl ;
touches           = "TOUCHES"    , ws , surface_list , nl ;
writes            = "WRITES"     , ws , surface_list , nl ;
reads             = "READS"      , ws , surface_list , nl ;
affects           = "AFFECTS"    , ws , ref_list  , nl ;
risk              = "RISK" , ws , ( "low" | "medium" | "high" | "critical" ) , nl ;

(* ===== Modal terminals (Q1.4): exactly five. SHALL / SHALL NOT removed; CAN / WILL are NOT modals. ===== *)
modal             = "MUST NOT" | "MUST" | "SHOULD NOT" | "SHOULD" | "MAY" ; (* longest-match: NOT before bare *)
(* "SHALL", "SHALL NOT" : illegal as modals (lint SOL-S003-family / removed).                              *)
(* "CAN", "WILL"        : non-modal; if used as a modal in a binding clause, lint SOL-P003 (informal force). *)

(* ===== Shared lexical productions ===== *)
ref_list          = ref , { ws , "," , ws , ref } ;
ref               = req_id | constraint_id | invariant_id | interface_id
                  | question_id | trace_id | cross_spec_ref ;
surface_list      = surface_ref , { ws , "," , ws , surface_ref } ;
surface_ref       = surface_name | glob ;
path_list         = path , { ws , "," , ws , path } ;
surface_name      = ident , { ".", ident } ;          (* e.g. auth.code, checkout.tests *)
owner_ref         = ident , { ( "-" | ":" | "/" ) , ident } ; (* surface / team / module *)
evidence_ref      = ? reference to proof output, log, or artifact ? ;
authority         = ? human name or spec-owner / profile id ? ;
reason            = ? one-line justification text ? ;
prose_text        = ? free APS-governed prose (§7) ? ;
spec_id           = ident ;
ident             = letter , { letter | digit | "-" | "_" } ;
bare_type         = ident ;
glob              = ? path glob, e.g. src/auth/** ? ;
path              = ? repository-relative file path ? ;
semver            = digits , "." , digits , "." , digits ;
version_num       = digits , "." , digits ;
digit             = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
letter            = ? Unicode letter ? ;
yaml_key          = ident ;
yaml_scalar       = ? YAML scalar value ? ;
ws                = ( " " | "\t" ) , { " " | "\t" } ;
nl                = "\n" | "\r\n" ;
```

### A.2 Lint constraints attached to grammar productions

Each grammar production carries one or more well-formedness checks from the unified lint namespace `SOL-<LAYER><NNN>` (§8, Appendix B). The codes below are the canonical, renumbered identifiers (per X1 / Q1.7); the legacy `SOL-S007`/`SOL-S010` syntax codes are remapped into the `SOL-V` verification layer because a missing or malformed proof binding is a verification defect, not a parse defect. A `SOL-S###` code is raised when the input cannot be parsed by the production; a `SOL-P###`/`SOL-V###` code is raised when the input parses but violates a higher-layer rule.

| Code | Layer | Severity | Production / trigger | Diagnostic |
|------|-------|----------|----------------------|------------|
| `SOL-S001` | SYNTAX | BLOCKING | `where_clause`/`while_clause`/`when_clause`/`if_clause` present with no following `actor_clause` | Precondition (`WHERE`/`WHILE`/`WHEN`/`IF`) with no actor clause; add `THE <actor> <MODAL> <response>`. |
| `SOL-S002` | SYNTAX | BLOCKING | `actor_clause` missing the `THE <actor>` head after a trigger | Missing actor after trigger; use `THE <actor>`. |
| `SOL-S003` | SYNTAX | BLOCKING | `actor_clause`/`and_actor_clause` with no `modal` terminal | Actor clause with no modal; use `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, or `MAY` (`SHALL`/`CAN`/`WILL` are not modals). |
| `SOL-S004` | SYNTAX | BLOCKING | Two `block_header` productions share the same `*_id` within one spec file | Duplicate block ID (intra-spec); renumber the second block. (Cross-spec collisions are `SOL-M001`.) |
| `SOL-S011` | SYNTAX | BLOCKING | `block_header` with no `*_id` | Missing obligation ID after the block type; add `PREFIX-NNN:`. |
| `SOL-S005` | SYNTAX | BLOCKING | `*_id` prefix does not match `block_header` type (e.g. `CONSTRAINT AC-001:`) | ID prefix/block-type mismatch; `REQ→AC-`, `CONSTRAINT→C-`, `INVARIANT→I-`, `INTERFACE→IF-`, `QUESTION→Q-`, `TRACE→T-`. |
| `SOL-S006` | SYNTAX | BLOCKING | `actor_clause` modal is `SHOULD`/`SHOULD NOT` with no `because_clause` or `except_clause` in the same block | `SHOULD`/`SHOULD NOT` used without `BECAUSE` or `EXCEPT`. |
| `SOL-S009` | SYNTAX | BLOCKING | `trace_body` `IMPLEMENTS`/`PRESERVES` `ref` resolving to no known obligation | `TRACE` references an unknown obligation ID. |
| `SOL-P003` | PROSE | BLOCKING | `modal` slot filled by `CAN`/`WILL` or a lowercase/informal modal in a binding clause | Missing or informal modality in a binding clause; use a real uppercase modal. |
| `SOL-P004` | PROSE | ADVISORY (warning) | `req_body`/`constraint_body` with more than two chained `and_actor_clause` (per G3) | Bundled/overloaded obligation; `AND THE` chaining beyond two — consider `ATOMIZE` into separate obligations (permitted, lowered to multiple IR obligations). |
| `SOL-V001` | VERIFICATION | BLOCKING | binding obligation (`REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`) with no `verify_line` (was `SOL-S007`) | Missing `VERIFY BY` for a binding obligation. |
| `SOL-V009` | VERIFICATION | BLOCKING | `verify_ref` whose `proof_type` is outside the closed 9-set | Unknown proof type; use one of `static, test, contract, property, model, perf, security, manual, monitor`. |
| `SOL-V005` | VERIFICATION | BLOCKING | `verdict_value` `verdict_core` outside the four core values, or `verdict_lifecycle` missing a mandatory field (was `SOL-S010`) | `VERDICT` value outside `PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED`, or a lifecycle decorator missing authority/reason (`WAIVED` also requires expiry). |
| `SOL-V006` | VERIFICATION | BLOCKING | `INTERFACE` `verify_line` whose `proof_type` ≠ `contract` (Theme-5 gap-fill) | `INTERFACE` MUST be verified by a `contract:` binding. |

Notes on opacity and deferral (normative for v0.1):

1. `condition_text`, `question_text`, `response`, `hold_text`, and `prose_text` are **opaque single-line text** in v0.1. No structured expression grammar (operators, comparisons, `AND`/`OR`) is defined; a parser MUST NOT attempt to tokenize their interior. The expression sublanguage is deferred to v0.2 (Q1.7, §35).
2. Timing keywords `WITHIN`, `BEFORE`, `UNTIL`, `IMMEDIATELY`, `EVENTUALLY` are **not productions in this grammar**; they are reserved for v0.2 (FRETish temporal semantics, Q1.6). Their appearance in a `.swarm.md` is parsed as opaque prose and SHOULD raise an advisory pointing to the deferral.
3. `ALWAYS`/`NEVER` (legacy INVARIANT openers), `EXPOSES`/`INPUT`/`OUTPUT` (legacy INTERFACE), and `MAP`/`TO`/`ORDER`/`ASK` (legacy TASK-MAP/QUESTION) are removed and have no production; they MUST be rejected (Q1.6).
4. `THEN` is legal only as the optional trailing sugar of `if_clause`; after `WHEN`/`WHILE` it MUST be rejected as a parse error.

Drafted file at `/Users/josecosta/dev/swarm/.agents/research/swarm-kernel-decisions.md` was the authority consulted; my section output is above (also staged at `/tmp/appendix_a.md`). 218 lines; EBNF validated for zero undefined and zero orphan nonterminals.


## Appendix B — Full lint-code catalogue and legacy translation table

This appendix is the normative catalogue of every v0.1 lint diagnostic. It is the authority for tool authors who build a `lint-spec` checker (a CONTRACT, never shipped by this repo — see §17) and for the conformance corpus (§33). Section numbers in cross-references resolve against the document outline (for example §8 is the lint-taxonomy chapter that frames these codes; §10 the improve ops; §14 verdicts; §18 orchestration).

### B.1 Namespace, layers, and the diagnostic record

A conformant Swarm lint code MUST match the single grammar:

```ebnf
lint_code = "SOL-" , layer , number ;
layer     = "S" | "P" | "M" | "V" | "O" ;
number    = digit , digit , digit ;          (* zero-padded, 3 digits *)
```

There is exactly one prefix (`SOL-`) and exactly five layer letters. `APS-` is retired as a *code* prefix; `APS` survives only as the name of the controlled-prose standard (§7). The five layers and their 1:1 mapping to compiler phases (§9) are fixed:

| Layer | Name | Detects | Phase it guards |
|---|---|---|---|
| `S` | SYNTAX | Parser-detectable well-formedness of a single block | `PARSE` |
| `P` | PROSE | Controlled-prose / requirement-smell, single-obligation-local (the former APS layer; absorbs `SOL-L###`) | `NORMALIZE` (`lint`/`improve`) |
| `M` | SEMANTIC | Cross-reference defects: duplicate id, contradiction, unbound ref | `NORMALIZE` |
| `V` | VERIFICATION | Proof-binding defects: missing / stale / non-observable proof | `VERIFY` |
| `O` | ORCHESTRATION | Planning / parallelism defects: write-conflict-marked-parallel, dep cycle, blocking QUESTION reaching lowering | `LOWER` |

#### B.1.1 100-block allocation, append-only, tombstoning

Each layer is a 100-block. Within `SOL-P###`, codes `001`–`049` are reserved for BLOCKING prose rules and `050`–`099` for ADVISORY prose rules; this split is normative for the P layer only. The catalogue is **append-only**: a code, once published, MUST NOT be renumbered, MUST NOT change layer, and MUST NOT have its meaning silently repurposed. A retired code MUST be **tombstoned** — its row is retained with the marker `TOMBSTONED` in the short-name column, a `superseded-by` pointer where one exists, and the number MUST NOT be reissued. Rationale: one tool, one greppable namespace, stable across versions (ESLint/Clippy append-only-with-tombstone convention).

#### B.1.2 Diagnostic record shape

Every diagnostic a checker emits MUST be a record of exactly this shape, and the IR `diagnostics[]` array (§12) MUST carry records of this shape:

```json
{
  "code": "SOL-P005",
  "severity": "BLOCKING",
  "layer": "P",
  "span": { "file": "auth.swarm.md", "block": "AC-001", "line": 12, "col": 9 },
  "message": "vague-quality word 'fast' with no same-line observable criterion",
  "suggest": "CONCRETIZE or QUANTIFY: bind a measurable threshold on the same line"
}
```

| Field | Type | Meaning |
|---|---|---|
| `code` | string | The `SOL-<LAYER><NNN>` code (B.1). |
| `severity` | `"BLOCKING"` \| `"ADVISORY"` | Effect on the build, per B.1.3. |
| `layer` | `"S"`\|`"P"`\|`"M"`\|`"V"`\|`"O"` | MUST equal the code's layer letter (redundant-but-checkable). |
| `span` | object | Source location: at minimum `{file, block}`; `line`/`col` SHOULD be present when available. |
| `message` | string | Human-readable one-line defect description. |
| `suggest` | string | The improve op (§10) or fix that resolves it; MUST name a closed op where one applies, never an open-ended rewrite. |

#### B.1.3 Severity model

Severity is **binary and intrinsic**: a rule is `BLOCKING` iff the defect changes *what* gets built (incomplete / non-binding / untestable / ambiguous / unschedulable); `ADVISORY` iff it only affects *how the text reads*. BLOCKING diagnostics MUST fail the relevant gate (lint gate for S/P/M, merge gate for V/O — §14); ADVISORY diagnostics MUST NOT block by default.

- The legacy `Error`/`Warning` axis maps onto this: legacy `Error` → `BLOCKING`, legacy `Warning` → `ADVISORY` (with the X1 re-layerings overriding the *code*, not the severity intent).
- **Project severity overrides** (G1) are permitted: a project MAY promote an ADVISORY to BLOCKING (strict mode) or demote a BLOCKING via a recorded waiver, through the `swarm.config` waiver schema (deferred-precise to v0.2; the default severities in this appendix are normative until overridden).
- **Binding-clause vs commentary** (G2): a span is *binding* iff it lies inside a typed obligation block (REQ / CONSTRAINT / INVARIANT); otherwise it is *commentary*. Codes flagged "binding-only" below fire as BLOCKING in a binding span and are suppressed (or downgraded to ADVISORY where noted) in commentary.

### B.2 Layer S — SYNTAX (parser well-formedness)

These fire at `PARSE`; all are BLOCKING (a malformed block cannot be parsed into a node). Resolution is a direct edit to fix the structure — no improve op applies (improve ops operate on already-parseable obligations).

| Code | Severity | Short name | Definition | Resolves by |
|---|---|---|---|---|
| `SOL-S001` | BLOCKING | dangling-precondition (syntax) | A trigger clause (`WHERE`/`WHILE`/`WHEN`/`IF`) is present but no `THE <actor> <MODAL> <response>` actor-clause follows in the block. | Edit: add the missing actor-clause. (Prose-layer companion: `SOL-P001`.) |
| `SOL-S002` | BLOCKING | unknown-block-or-keyword | Block header is not one of the 7 types, or a body line uses an unknown/malformed clause keyword. | Edit: use a valid block type (§6) / clause keyword (§5). |
| `SOL-S003` | BLOCKING | actor-clause-no-modal | An actor-clause is present with no modal (`MUST`/`MUST NOT`/`SHOULD`/`SHOULD NOT`/`MAY`). | Edit: insert a valid modal (§5). (Note: multiple chained `AND THE` modals are *permitted* and lowered to several IR obligations, G3; only total absence of a modal trips S003.) |
| `SOL-S004` | BLOCKING | duplicate-block-id | Two blocks share the same surface id within one spec (intra-spec duplicate). | Edit: renumber. (Cross-spec collisions are `SOL-M001`.) |
| `SOL-S011` | BLOCKING | missing-obligation-id | A block header is present but carries no `*_id` after the block type (block type is recognized but ID is absent). | Edit: add a valid `PREFIX-NNN` id after the block type. |
| `SOL-S005` | BLOCKING | prefix↔type-mismatch | The id prefix does not match the block type (e.g. `REQ C-001:`). | Edit: use the canonical prefix (REQ→`AC-`, CONSTRAINT→`C-`, INVARIANT→`I-`, INTERFACE→`IF-`, QUESTION→`Q-`, TRACE→`T-`). |
| `SOL-S006` | BLOCKING | should-without-because | `SHOULD`/`SHOULD NOT` used without an accompanying `BECAUSE` or `EXCEPT` clause in the same block (§5.6). | Edit: add a `BECAUSE` or `EXCEPT` clause, or strengthen to `MUST`/`MUST NOT`. |
| `SOL-S007` | BLOCKING | malformed-header | Block header is missing the mandatory trailing colon, or the id is malformed (spaces, illegal characters). | Edit: write `TYPE PREFIX-NNN:`. |
| `SOL-S008` | BLOCKING | non-control-first-line | The first non-empty line of a block is not a control sentence (metadata or prose appears before the obligation sentence). | Edit: lead with the actor-clause / control sentence. |
| `SOL-S010` | BLOCKING | unknown-metadata-field | A trailing metadata field is not one of the closed set (`DEPENDS ON`/`TOUCHES`/`WRITES`/`READS`/`AFFECTS`/`RISK`/`OWNED BY`). | Edit: use a valid field (§5) or move the text to commentary. |

Note: legacy `SOL-S007`/`SOL-S010` (verification / verdict-value checks) and legacy `SOL-S008` (planner parallelism) do **not** keep these S-numbers — they re-layer to V and O respectively (see B.6). The S007/S008 rows above are the *re-allocated* v0.1 syntax meanings; `SOL-S010` is re-allocated from the legacy verdict-value check (now `SOL-V005`) to `unknown-metadata-field`.

### B.3 Layer P — PROSE (controlled-prose / requirement-smell)

P-layer rules are single-obligation-local. `001`–`049` are BLOCKING; `050`–`099` are ADVISORY. Each maps to a closed improve op (§10), never an open rewrite.

#### B.3.1 Blocking prose rules

| Code | Severity | Short name | Definition | Resolves by |
|---|---|---|---|---|
| `SOL-P001` | BLOCKING | dangling-condition | A trigger with no modal *consequence* at the prose level (semantically empty even if syntactically a sentence). | `CLARIFY` / `ATOMIZE`: supply the consequence. |
| `SOL-P002` | BLOCKING | missing-actor | The obligation has no responsible actor. | `CONCRETIZE`: name the actor. |
| `SOL-P003` | BLOCKING | missing/informal-modality | No modal, or lowercase `should`/`must`/`may` used where binding force is intended. | `NORMALIZE`: uppercase to the correct modal (was `APS-M001`). |
| `SOL-P004` | BLOCKING | bundled/overloaded-obligation | One sentence carries multiple separable obligations. | `ATOMIZE`: split into one obligation per block (was `APS-O001`; >2 chained `AND THE` also warns, G3). |
| `SOL-P005` | BLOCKING | vague-quality-no-criterion | A vague-quality / high-risk word in a binding clause with no same-line observable criterion. | `CONCRETIZE` or `QUANTIFY` (was `APS-A001`). |
| `SOL-P006` | BLOCKING | undefined-term | An undefined term used in a binding clause (not resolvable via in-file `TERM` or `memory/glossary.md`). | `CLARIFY` / `BIND`: define the term. |
| `SOL-P007` | BLOCKING | negation-ambiguity | A bare `MUST NOT` whose scope is ambiguous; not paired with the affirmative behavior. | `CLARIFY`: state the affirmative alongside the prohibition. |
| `SOL-P008` | BLOCKING | uncaptured-uncertainty | Behavioral uncertainty left in prose, not lifted to a `QUESTION` block. | `CLARIFY`: raise a `QUESTION` (was `APS-Q001`). |

The **high-risk-word list** (the union of the brief's subjective/promotional list + Femmer loopholes & comparatives + Tjong/Berry quantifiers/connectives) and the **same-line-makes-it-observable rule** govern `SOL-P005`/`SOL-P056`: a high-risk word is permitted only when the same sentence, bullet, or immediately-following line converts it to observable behavior (actor+action+object, a measurable threshold, or a named verification target); otherwise the rule fires BLOCKING and is fixed by `CONCRETIZE`/`QUANTIFY` — never an open-ended rewrite.

#### B.3.2 Advisory prose rules

| Code | Severity | Short name | Definition | Resolves by |
|---|---|---|---|---|
| `SOL-P050` | ADVISORY | pronoun | Vague pronoun with non-unique antecedent. | `CLARIFY` (was `APS-A002` / `SOL-L103`). |
| `SOL-P051` | ADVISORY | passive-voice | Passive voice in an obligation sentence. | `NORMALIZE` (was `SOL-L105`). |
| `SOL-P052` | ADVISORY | sentence-length | Obligation sentence exceeds ~20 words. | `COMPRESS` / `ATOMIZE`. |
| `SOL-P053` | ADVISORY | non-present-non-active | Non-present-tense or non-active phrasing. | `NORMALIZE`. |
| `SOL-P054` | ADVISORY | prose-noise | Decorative phrase that adds no constraint. | `COMPRESS` (was `APS-P001`). |
| `SOL-P055` | ADVISORY | redundancy | Repeated context that adds no constraint. | `COMPRESS` (was `APS-R001`). |
| `SOL-P056` | ADVISORY / BLOCKING | comparative-no-baseline | Comparative/superlative with no baseline. **BLOCKING in a binding clause, ADVISORY in commentary** (G2). | `QUANTIFY`: supply the baseline. |

### B.4 Layer M — SEMANTIC (cross-reference)

M-layer rules fire at `NORMALIZE` after all blocks are parsed; they are cross-obligation. All BLOCKING (a broken reference or a contradiction changes what is built).

| Code | Severity | Short name | Definition | Resolves by |
|---|---|---|---|---|
| `SOL-M001` | BLOCKING | actor/object-incompleteness | A referenced actor, object, or surface is unresolved across the spec / imports (also catches cross-spec id collision). | `BIND` / `CONCRETIZE`: resolve or declare the referent (was `APS-C001` completeness + `SOL-M201`/`SOL202`). |
| `SOL-M002` | BLOCKING | contradiction | Two obligations contradict on the same normalized subject/action/object/trigger key (e.g. `MUST` vs `MUST NOT`). | `DECONFLICT` (was `APS-X001` / `SOL207` / `SOL-M202`). |
| `SOL-M003` | BLOCKING | unbound-cross-reference | A `DEPENDS ON` / `IMPLEMENTS` / `PRESERVES` reference names an id that does not exist. | `BIND`: fix the reference (was `SOL202` unresolved-dependency, kept in M). |
| `SOL-M004` | BLOCKING | authority-conflict | A lower-authority block attempts to weaken a higher-authority obligation (source-authority order, §22). | `DECONFLICT` / amendment (was `SOL206`). |

Note: legacy `SOL-M003`/`SOL-M007`/`SOL-M008` (proof-binding semantics) and `SOL-M009` (planner) do **not** retain M-numbers — they re-layer to V and O (B.6). The M003 row above is the re-allocated v0.1 meaning (unbound cross-reference), not the legacy proof-binding meaning.

### B.5 Layer V — VERIFICATION (proof-binding)

V-layer rules fire at `VERIFY`; they gate the merge gate (§14). The `VERIFY BY <type>:<adapter>:<artifact>[#selector]` binding (§15) is the subject.

| Code | Severity | Short name | Definition | Resolves by |
|---|---|---|---|---|
| `SOL-V001` | BLOCKING | no-verification-path | An obligation block (REQ/CONSTRAINT/INVARIANT) or an INTERFACE has no `VERIFY BY` binding. | `BIND`: attach a `VERIFY BY` (was `APS-V001` / `SOL204` / `SOL-V401` / `SOL-M203`). |
| `SOL-V002` | BLOCKING | proof-not-executable | The bound adapter does not resolve through AGENTS.md > Commands, or the artifact is missing. | `BIND`: point at a resolvable cmd* adapter (§15). |
| `SOL-V003` | ADVISORY / BLOCKING | non-observable-proof | The bound proof is non-observable (e.g. an INVARIANT bound only to a non-observable unit `test`). ADVISORY by default; BLOCKING under strict mode. | `BIND`: prefer `property`/`model`/`static` for INVARIANT; `contract` for INTERFACE (was `SOL-V403`). |
| `SOL-V004` | BLOCKING | stale-proof | A prior `PASS` whose evidence no longer matches the current source content-hash or a changed write-surface; surfaces as the `STALE` verdict (§16). | 3-way reconcile (re-run / amend / fix code) — never silent re-bless (was `SOL-V402` / `SOL-S007`-staleness). |
| `SOL-V005` | BLOCKING | bad-verdict-value | A `VERDICT` core value is not one of `PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED`, OR a lifecycle decorator is missing its mandatory fields (WAIVED→authority+reason+expiry; STALE→prior-verdict ref+changed-surface; CONTRADICTED→two conflicting evidence refs). (was `SOL-S010`) | Edit: use a valid verdict line (§14) (was `SOL-S010`). |
| `SOL-V006` | BLOCKING | interface-without-contract | An `INTERFACE` whose `VERIFY BY` proof_type is not `contract`. | `BIND`: use `contract:` as the proof type for INTERFACE bindings (was `SOL-V403`-family). |
| `SOL-V007` | BLOCKING | invalid-lifecycle-decoration | A lifecycle decorator applied to the wrong core value (e.g. `WAIVED` on a `PASS`/`BLOCKED`, or `STALE` on anything other than a prior `PASS`). | Edit: remove or correct the lifecycle decorator per §14.1.2. |
| `SOL-V008` | BLOCKING | missing-verdict-at-merge-gate | A required `VERIFY BY` binding has no `VERDICT` at the merge gate (counts as `UNVERIFIED` at the gate; see §14.4). | `BIND`: run the proof and record a verdict, or `WAIVE`. |
| `SOL-V009` | BLOCKING | unknown-proof-type | A `verify_ref` whose `proof_type` is outside the closed 9-set (`static`, `test`, `contract`, `property`, `model`, `perf`, `security`, `manual`, `monitor`). | Edit: use one of the nine canonical proof types (§15.1). |

### B.6 Layer O — ORCHESTRATION (planning / parallelism)

O-layer rules fire at `LOWER`; they gate plan emission (§13) and safe parallelism (§18).

| Code | Severity | Short name | Definition | Resolves by |
|---|---|---|---|---|
| `SOL-O301` | BLOCKING | conflicting-tasks-parallel | The plan marks two work packets parallel that share a write surface or an interface/migration node (violates the safe-parallelism predicate, §18). Raised from Warning to ERROR per the kernel decision. | `SCOPE`: serialize, or split write surfaces (was `SOL208` / `SOL-M009` / legacy `SOL-O301` Warning). |
| `SOL-O302` | BLOCKING | dependency-cycle | A `DEPENDS ON` cycle exists in the lowered DAG. | `SCOPE` / `DECONFLICT`: break the cycle (was `SOL203` / `SOL-M205`). |
| `SOL-O303` | BLOCKING | blocking-question-reaches-lowering | An unresolved `blocking` `QUESTION` reaches the `LOWER` pass (lowering MUST NOT proceed past an open blocking question). | `CLARIFY`: answer/close the QUESTION before lowering (was `SOL-S008` / `SOL205`). |
| `SOL-O304` | ADVISORY | scope-too-broad | An obligation has no `WRITES`/`READS`/`AFFECTS`, leaving it unscoped (serializes by default and harms planning). | `SCOPE`: declare write/read/affect surfaces (was `SOL305`). |
| `SOL-O305` | BLOCKING | owned-path-outside-write-surface | A work packet writes a path outside its declared `WRITES` surface (the two-tier lowering check, G7). | `SCOPE`: declare the path, or stop writing it (new in v0.1). |
| `SOL-O306` | ADVISORY | import-policy-overlap | An imported file creates a duplicate/overlapping policy obligation. | `DECONFLICT` / `COMPRESS` (was `SOL306`). |

### B.7 Improve-op ↔ lint-code map (normative)

The closed 10-op improve set (§10) is wired to the codes above; this is the canonical detect→repair mapping (Q5.17 × Q6.19). Each op is strictly semantics-preserving; any intent change routes to amendment/review, never improve.

| Improve op | Resolves codes |
|---|---|
| `NORMALIZE` | `SOL-P003`, `SOL-P051`, `SOL-P053` |
| `ATOMIZE` | `SOL-P004` (and `SOL-P052` by splitting) |
| `CONCRETIZE` | `SOL-P005`, `SOL-P002`, `SOL-M001` |
| `QUANTIFY` | `SOL-P005`, `SOL-P056` |
| `BIND` | `SOL-V001`, `SOL-V002`, `SOL-V003`, `SOL-V006`, `SOL-V009`, `SOL-M003`, `SOL-P006` |
| `SCOPE` | `SOL-O304`, `SOL-O305`, `SOL-O301`, `SOL-O302` |
| `CLARIFY` | `SOL-P008`, `SOL-P001`, `SOL-P007`, `SOL-P050`, `SOL-O303` |
| `DECONFLICT` | `SOL-M002`, `SOL-M004`, `SOL-O306` |
| `COMPRESS` | `SOL-P054`, `SOL-P055`, `SOL-O306` |
| `PROMOTE` | (no lint code — routes through the promotion protocol, §23/§30) |

### B.8 Legacy translation table (old → new)

This is the authoritative mapping per conflict **X1** and the decision record's §2/§10a remaps. Every legacy code cited anywhere in the source corpus MUST be rewritten to its v0.1 code. The mapping is one-way; legacy codes MUST NOT appear in any conformant artifact.

#### B.8.1 APS family (retired prefix)

| Legacy code | v0.1 code | Note |
|---|---|---|
| `APS-A001` | `SOL-P005` | vague-quality, no observable criterion |
| `APS-A002` | `SOL-P050` | pronoun ambiguity |
| `APS-C001` | `SOL-M001` | actor/object incompleteness |
| `APS-M001` | `SOL-P003` | informal modality |
| `APS-O001` | `SOL-P004` | bundled/overloaded obligation |
| `APS-P001` | `SOL-P054` | prose noise |
| `APS-Q001` | `SOL-P008` | uncaptured behavioral uncertainty |
| `APS-R001` | `SOL-P055` | redundancy |
| `APS-S001` | `SOL-O304` / scope | missing scope/non-goals → orchestration scope (also surfaces in §3 spec completeness) |
| `APS-T001` | `SOL-M001` | traceability id → semantic completeness |
| `APS-V001` | `SOL-V001` | no verification path |
| `APS-X001` | `SOL-M002` | contradiction |

#### B.8.2 `sol.md` flat scheme (SOL00x / 10x / 20x / 30x)

| Legacy code | v0.1 code | Note |
|---|---|---|
| `SOL001` | `SOL-S010` | invalid/missing frontmatter (metadata) |
| `SOL002` | `SOL-S002` | unknown block type |
| `SOL003` | `SOL-S007` | invalid block id |
| `SOL004` | — (TOMBSTONED) | `:::END` removed; bare-header form (§5) makes this moot |
| `SOL005` | `SOL-S008` | first line not a control sentence |
| `SOL006` | `SOL-S010` | unknown metadata field |
| `SOL007` | `SOL-S010` | duplicate scalar field |
| `SOL101` | `SOL-S001` / `SOL-P001` | `WHEN`/`IF` without consequence (syntax + prose companion) |
| `SOL102` | `SOL-S001` | `THEN` without modal obligation |
| `SOL103` | `SOL-S003` / `SOL-P003` | REQ lacks modal |
| `SOL104` | — (TOMBSTONED) | `ALWAYS`/`NEVER` removed from INVARIANT (§5/§6) |
| `SOL105` | `SOL-S002` | malformed QUESTION |
| `SOL201` | `SOL-S004` / `SOL-M001` | duplicate id (intra-spec → S004; cross-spec → M001) |
| `SOL202` | `SOL-M003` | unresolved dependency reference |
| `SOL203` | `SOL-O302` | dependency cycle |
| `SOL204` | `SOL-V001` | missing verification binding |
| `SOL205` | `SOL-O303` | blocking QUESTION unresolved at lowering |
| `SOL206` | `SOL-M004` | authority conflict |
| `SOL207` | `SOL-M002` | contradiction |
| `SOL208` | `SOL-O301` | planner marks conflicting tasks parallel |
| `SOL301` | `SOL-P005` | ambiguous adjective/adverb |
| `SOL302` | `SOL-P005` | unverifiable wording |
| `SOL303` | `SOL-P004` | low singularity (multiple obligations) |
| `SOL304` | `SOL-O304` | missing owner/priority (scope/governance) |
| `SOL305` | `SOL-O304` | scope too broad for planning |
| `SOL306` | `SOL-O306` | imported-file policy overlap |
| `SOL307` | `SOL-P052` / `SOL-P054` | overlong block body |

Allocation rule applied above (per X1): flat `SOL00x/10x → SOL-S`; `SOL20x → SOL-M` (cross-ref) / `SOL-V` (proof) / `SOL-O` (planner); `SOL30x → SOL-P`.

#### B.8.3 `swarm-sol.md` scheme (SOL-S00x / SOL-L1xx / SOL-M2xx / SOL-O3xx / SOL-V4xx)

| Legacy code | v0.1 code | Note |
|---|---|---|
| `SOL-S001` | `SOL-S001` | trigger, no consequence (unchanged) |
| `SOL-S002` | `SOL-S002` | unknown keyword / malformed block (unchanged) |
| `SOL-S003` | `SOL-S003` | actor-clause modal check (singularity warning is now `SOL-P004`, G3) |
| `SOL-S004` | `SOL-S004` | duplicate id (unchanged) |
| `SOL-L101` | `SOL-P005` | subjective/promotional term (`SOL-L → SOL-P`) |
| `SOL-L102` | `SOL-P005` | ambiguous qualifier / loophole |
| `SOL-L103` | `SOL-P050` | vague pronoun |
| `SOL-L104` | `SOL-P004` | bundled obligation |
| `SOL-L105` | `SOL-P051` | passive voice |
| `SOL-M201` | `SOL-M001` | unresolved actor/term/surface |
| `SOL-M202` | `SOL-M002` | contradiction |
| `SOL-M203` | `SOL-V001` | missing `VERIFY BY` (re-layered S/M → V) |
| `SOL-M204` | `SOL-O305` / `SOL-V001` | declared write surface missing |
| `SOL-M205` | `SOL-O302` | dependency cycle |
| `SOL-O301` | `SOL-O301` | parallel write-surface conflict (severity raised to BLOCKING) |
| `SOL-V401` | `SOL-V001` | proof missing / not executable |
| `SOL-V402` | `SOL-V004` | stale proof (→ `STALE` verdict, §16) |
| `SOL-V403` | `SOL-V003` | non-observable proof |

#### B.8.4 Cross-layer re-layerings called out in X1

| Legacy code | v0.1 code | Re-layering |
|---|---|---|
| `SOL-S007` | `SOL-V001` | verification → V |
| `SOL-S010` (legacy) | `SOL-V005` | verdict-value check → V (the v0.1 `SOL-S010` slot is re-allocated to `unknown-metadata-field`, B.2) |
| `SOL-S008` | `SOL-O303` | planner / blocking-QUESTION → O |
| `SOL-M003` | `SOL-V001` | proof-binding → V |
| `SOL-M007` | `SOL-V003` | proof-observability → V |
| `SOL-M008` | `SOL-V004` | proof-staleness → V |
| `SOL-M009` | `SOL-O301` | planner parallelism → O |

Where a single legacy code maps to two v0.1 codes (e.g. `SOL101 → SOL-S001`/`SOL-P001`, `SOL201 → SOL-S004`/`SOL-M001`), the split is by phase: the syntactic facet fires at `PARSE` (S), the semantic/prose facet at `NORMALIZE` (P/M). A migration tool MUST emit both where both facets are present and MUST NOT collapse them.

### B.9 Conformance note

A conformant `lint-spec` checker (a CONTRACT, never shipped per Principle 1, §17) MUST: (1) emit only `SOL-<LAYER><NNN>` codes; (2) emit the diagnostic record of B.1.2; (3) apply the default severities in this appendix, overridable only through the recorded `swarm.config` waiver schema (G1); (4) never reuse a tombstoned number; (5) name a closed improve op in `suggest` wherever B.7 supplies one. The golden corpus (§33, G12) labels good/bad prose so the `SOL-P` rules' precision/recall (target ≥0.90 / ≥0.85) is measurable.


## Appendix C — IR JSON Schema

This appendix is the normative, contract-only data definition of the `*.swarm.ir.json` envelope first introduced in §12 (the intermediate representation) and bound to the surface language in §4–§6. It realises decision-record **Q3.12** (the envelope shape), **Q9.30** (the three independent version fields), and **Q4.14** (the normalized `verify_by[]` element).

**Contract-not-executor rule (normative).** This schema is *versioned, inert data*, per Invariant 1 (NO RUNTIME, §2) and decision **Q3.11**. The kernel ships this schema and conformant example instances; it ships **no emitter, parser, validator, or CLI** that produces `*.swarm.ir.json`. A conformant Swarm repo MUST carry this schema verbatim under `docs/language/` (with a self-contained copy in the scaffold); a tool, when one exists, MAY validate against it. The schema is "the contract a future tool builds against," never "a tool Swarm provides." `*.swarm.ir.json` is therefore a *reserved, documented* filename (§20), not an artifact any shipped process writes.

**Surface-vs-IR rule (normative).** Every field name in this schema is `snake_case` (the IR layer). It is the lowering of an English-shaped uppercase SOL surface keyword (§5): `verify_by` ← `VERIFY BY`, `depends_on` ← `DEPENDS ON`, `writes` ← `WRITES`, `reads` ← `READS`, `affects` ← `AFFECTS`, `owner` ← `OWNED BY`. There is **no `locks` field on either layer**; a lock group is a named `SURFACE` whose member paths appear in `writes[]` (§18, X4). Relationships (`depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, `preserves`) live **only** in `edges[]`; they MUST NOT be duplicated as node scalars — `edges[]` is the single source of relationship truth (Q3.12).

**Three-version rule (normative).** The envelope carries exactly three version fields and they MUST NOT be merged (Q9.30): `meta.language` is the **SOL language discriminator** (e.g. `SOL/0.1`) — which grammar, blocks, modals, and lint codes apply; `meta.version` is the **spec content version** — the SemVer of the authored `*.swarm.md` source; `provenance.compiler_version` is the **tool version** that emitted this IR, recorded only when a tool exists. A tool MUST NOT infer either of the other two from any one of them.

### C.1 The envelope schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://swarm.dev/schema/0.1/swarm.ir.json",
  "title": "Swarm IR envelope (*.swarm.ir.json)",
  "type": "object",
  "additionalProperties": false,
  "required": ["meta", "nodes", "edges", "diagnostics", "provenance"],
  "properties": {
    "meta": {
      "type": "object",
      "additionalProperties": false,
      "required": ["id", "title", "language", "version", "status"],
      "properties": {
        "id":      { "type": "string", "description": "Spec id (slug); e.g. auth-refresh" },
        "title":   { "type": "string" },
        "language":{ "const": "SOL/0.1", "description": "SOL language discriminator (Q9.30); never merged with version" },
        "version": { "type": "string", "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$", "description": "Spec content SemVer; never merged with language" },
        "status":  { "enum": ["draft", "review", "approved", "superseded"] },
        "owners":  { "type": "array", "items": { "type": "string" }, "default": [] },
        "imports": { "type": "array", "items": { "type": "string", "description": "Path to an imported *.swarm.md" }, "default": [] }
      }
    },

    "nodes": {
      "type": "array",
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["id", "kind", "source"],
        "properties": {
          "id":   { "type": "string", "description": "IR node id; MAY be namespaced, e.g. REQ.auth-refresh.AC-001 (surface id is the short AC-001)" },
          "kind": { "enum": ["REQ", "CONSTRAINT", "INVARIANT", "INTERFACE", "QUESTION", "TRACE", "VERDICT"] },
          "authority": { "type": "string", "description": "Domain authority rank label (Axis B, §22): e.g. security, architecture, product" },
          "modality":  { "enum": ["MUST", "MUST NOT", "SHOULD", "SHOULD NOT", "MAY"], "description": "Binding force; obligation kinds (REQ/CONSTRAINT/INVARIANT) only" },
          "clauses": {
            "type": "object",
            "additionalProperties": false,
            "description": "Lowered SOL clauses (§6); null/absent for inapplicable slots",
            "properties": {
              "where":     { "type": ["string", "null"] },
              "while":     { "type": ["string", "null"] },
              "trigger":   { "type": ["string", "null"], "description": "Lowering of WHEN/IF [THEN]" },
              "subject":   { "type": ["string", "null"], "description": "The actor in THE <actor> <MODAL> <response>" },
              "modal":     { "enum": ["MUST", "MUST NOT", "SHOULD", "SHOULD NOT", "MAY", null] },
              "predicate": { "type": ["string", "null"], "description": "The response/predicate" },
              "timing":    { "type": ["string", "null"], "description": "RESERVED; timing keywords deferred to SOL/0.2 (§35)" }
            }
          },
          "owner":  { "type": ["string", "null"], "description": "Lowering of OWNED BY" },
          "risk":   { "enum": ["low", "medium", "high", "critical", null] },
          "reads":  { "type": "array", "items": { "type": "string" }, "default": [] },
          "writes": { "type": "array", "items": { "type": "string", "description": "Write surface path/glob or named SURFACE member" }, "default": [] },
          "affects":{ "type": "array", "items": { "type": "string" }, "default": [] },
          "verify_by": {
            "type": "array",
            "default": [],
            "items": {
              "type": "object",
              "additionalProperties": false,
              "required": ["type", "adapter", "ref"],
              "properties": {
                "type":     { "enum": ["static", "test", "contract", "property", "model", "perf", "security", "manual", "monitor"], "description": "Closed 9-type proof taxonomy (Q4.14)" },
                "adapter":  { "type": "string", "description": "Resolves through AGENTS.md > Commands (a cmd* slot); free string" },
                "ref":      { "type": "string", "description": "Artifact reference; free string" },
                "selector": { "type": ["string", "null"], "description": "Lowering of #selector; e.g. a test name or invariant name" },
                "gate":     { "enum": ["required", "advisory"], "default": "required" }
              }
            }
          },
          "status": { "enum": ["PASS", "FAIL", "BLOCKED", "UNVERIFIED", "WAIVED", "STALE", "CONTRADICTED"], "description": "4 core + 3 lifecycle (X2/Q4.13); UNVERIFIED is the default before a verdict exists" },
          "source": {
            "type": "object",
            "additionalProperties": false,
            "required": ["file", "line_start", "line_end"],
            "properties": {
              "file":         { "type": "string" },
              "line_start":   { "type": "integer", "minimum": 1 },
              "line_end":     { "type": "integer", "minimum": 1 },
              "content_hash": { "type": ["string", "null"], "description": "Hash of the obligation source span; drives STALE drift (§16/Q9.29)" }
            }
          },
          "provenance": { "type": "array", "items": { "type": "string" }, "default": [], "description": "Per-node trace/finding references (§23)" }
        }
      }
    },

    "edges": {
      "type": "array",
      "description": "Single source of relationship truth; relationships are NOT also node scalars (Q3.12)",
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["from", "to", "type"],
        "properties": {
          "from": { "type": "string", "description": "Source node id" },
          "to":   { "type": "string", "description": "Target node id" },
          "type": { "enum": ["depends_on", "blocks", "conflicts_with", "verified_by", "affects", "implements", "preserves"] },
          "hard": { "type": "boolean", "default": true, "description": "true = hard ordering/conflict; false = soft/advisory" }
        }
      }
    },

    "diagnostics": {
      "type": "array",
      "description": "SARIF-shaped (Q3.12); attach to a node or a source span",
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["code", "level", "message"],
        "properties": {
          "code":    { "type": "string", "pattern": "^SOL-[SPMVO][0-9]{3}$", "description": "Unified lint namespace (§8, X1)" },
          "level":   { "enum": ["error", "warning", "info"] },
          "node":    { "type": ["string", "null"], "description": "Node id the diagnostic is bound to, if any" },
          "source": {
            "type": ["object", "null"],
            "additionalProperties": false,
            "properties": {
              "file":       { "type": "string" },
              "line_start": { "type": "integer", "minimum": 1 },
              "line_end":   { "type": "integer", "minimum": 1 }
            }
          },
          "message": { "type": "string" },
          "suggest": { "type": ["string", "null"], "description": "Optional fix hint (the improve op or repair)" }
        }
      }
    },

    "provenance": {
      "type": "object",
      "additionalProperties": false,
      "required": ["hash"],
      "properties": {
        "hash":             { "type": "string", "description": "Hash of the source *.swarm.md this IR was emitted from" },
        "compiler_version": { "type": ["string", "null"], "description": "Tool version; null until a tool exists (Q9.30); never merged with meta.language or meta.version" },
        "compiled_at":      { "type": ["string", "null"], "format": "date-time" }
      }
    }
  }
}
```

### C.2 Annotated example instance

A minimal 3-node graph: one `REQ` (verified by a test and a property), one `INTERFACE` it depends on (which MUST itself carry a `contract` proof, §15), and one diagnostic. `edges[]` carries every relationship; no relationship is repeated as a node scalar.

```json
{
  "meta": {
    "id": "auth-refresh",
    "title": "Access token refresh",
    "language": "SOL/0.1",
    "version": "0.1.0",
    "status": "draft",
    "owners": ["@auth-platform"],
    "imports": ["shared/security.swarm.md"]
  },
  "nodes": [
    {
      "id": "REQ.auth-refresh.AC-001",
      "kind": "REQ",
      "authority": "security",
      "modality": "MUST",
      "clauses": {
        "where": null, "while": null,
        "trigger": "response.status == 401 AND refresh_token present",
        "subject": "web-client",
        "modal": "MUST",
        "predicate": "retry original_request once",
        "timing": null
      },
      "owner": "@web-platform",
      "risk": "medium",
      "reads": [], "writes": ["web/src/http/client.ts"], "affects": [],
      "verify_by": [
        { "type": "test",     "adapter": "cmdTest", "ref": "web/tests/auth-refresh-401.spec.ts", "selector": null, "gate": "required" },
        { "type": "property", "adapter": "cmdTest", "ref": "web/tests/auth-refresh.properties.ts", "selector": "no_unbounded_retry", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "auth-refresh.swarm.md", "line_start": 18, "line_end": 29, "content_hash": "sha256:9f1c…" },
      "provenance": []
    },
    {
      "id": "INTERFACE.auth-refresh.IF-001",
      "kind": "INTERFACE",
      "authority": "architecture",
      "owner": "@auth-platform",
      "verify_by": [
        { "type": "contract", "adapter": "cmdValidate", "ref": "openapi/auth.yaml", "selector": "POST /token/refresh", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "auth-refresh.swarm.md", "line_start": 31, "line_end": 38, "content_hash": "sha256:2ab7…" },
      "provenance": []
    }
  ],
  "edges": [
    { "from": "REQ.auth-refresh.AC-001", "to": "INTERFACE.auth-refresh.IF-001", "type": "depends_on", "hard": true },
    { "from": "INTERFACE.auth-refresh.IF-001", "to": "REQ.auth-refresh.AC-001", "type": "verified_by", "hard": false }
  ],
  "diagnostics": [
    { "code": "SOL-V001", "level": "warning", "node": "REQ.auth-refresh.AC-001", "source": null,
      "message": "INVARIANT-class property bound to a unit test; prefer property|model|static.", "suggest": "BIND a property: or model: proof" }
  ],
  "provenance": {
    "hash": "sha256:c0ffee…",
    "compiler_version": null,
    "compiled_at": "2026-05-31T12:00:00Z"
  }
}
```

Notes on the instance: `meta.language` (`SOL/0.1`), `meta.version` (`0.1.0`), and `provenance.compiler_version` (`null`, no tool exists) are the three distinct version fields and are never collapsed; the `verify_by[].adapter` values (`cmdTest`, `cmdValidate`) are AGENTS.md > Commands slots, not commands the kernel runs (§15, §31); node `status` is `UNVERIFIED` because no `VERDICT` block has judged either obligation yet (§14); the diagnostic `code` matches `^SOL-[SPMVO][0-9]{3}$` (§8).


## Appendix D — Worked example: auth-refresh, full pipeline

This appendix carries the `auth-refresh` obligation set through every pass of the pipeline (§9), in order: authored source, lint, improve, IR, task frame, trace, review with merge gate, and promotion. Identifiers, hashes, and verdicts are stable across stages so the chain reads as a single run. It is the positive (`must-compile`) `auth-refresh` golden-corpus fixture (§33, Q9.31), exercising a dangling-condition defect (`SOL-S001`), a `SHOULD` without `BECAUSE` (`SOL-P003`), a missing-verification defect (`SOL-V001`), the no-unbounded-retry `INVARIANT`, and a blocking `QUESTION`. Terms are defined in Appendix F; the IR conforms to Appendix C; the grammar to Appendix A.

### D.1 Stage 1 — authored `spec.swarm.md` (pass: `author`)

The human-authored source artifact (the only `.swarm.` artifact a human writes, §20). Frontmatter is normalized per G10 (§25): `swarm_language` is the language discriminator, `aps_version` the prose-standard version, `spec_version` the spec content version.

```sol
---
type: spec
swarm_language: SOL/0.1
aps_version: 0.1
spec_version: 0.1.0
id: auth-refresh
status: draft
---

# Spec: Silent token refresh on 401

## Intent
When an access token expires mid-session the client transparently refreshes it
and replays the original request, without ever looping.

## Interfaces

INTERFACE IF-001:
`refreshSession()` RETURNS `Session | AuthExpired`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client

## Obligations

REQ AC-001:
WHEN a request returns 401 AND a refresh token is present
THE auth client MUST call `refreshSession()` once
AND THE auth client MUST replay the original request with the new session
VERIFY BY test:cmdTest:web/tests/auth-refresh-401.spec.ts#replays-after-refresh
DEPENDS ON IF-001
WRITES web/src/http/client.ts
RISK high

REQ AC-002:
WHEN the refresh token is expired
THE auth client SHOULD clear the local session
AND THE auth client MUST redirect to `/login`

## Invariants

INVARIANT I-001:
the retry count for a single original request MUST NOT exceed one

## Questions

QUESTION Q-001 [blocking]:
Should an expired refresh token redirect to `/login` or open an inline re-auth modal?
AFFECTS AC-002
```

### D.2 Stage 2 — lint diagnostics (pass: `lint`)

The `lint` pass emits SARIF-shaped diagnostic records `{code, severity, layer, span, message, suggest}` in the unified `SOL-<LAYER><NNN>` namespace (§8). Three diagnostics fire on the authored source; each names the closed `improve` op (§10) that repairs it. All three are BLOCKING because each changes *what* gets built (§8.4 binding-clause rule, G2).

```text
SOL-V001  ERROR  layer=V  AC-002:L1-L4
  message: obligation AC-002 has no VERIFY BY binding; no verification path.
  suggest: improve op BIND — add VERIFY BY <type>:<adapter>:<artifact>.

SOL-P003  ERROR  layer=P  AC-002:L2 ("THE auth client SHOULD clear the local session")
  message: SHOULD without an accompanying BECAUSE or EXCEPT clause.
  suggest: improve op NORMALIZE — add BECAUSE <reason>, or raise to MUST.

SOL-S001  ERROR  layer=S  I-001:L1
  message: INVARIANT predicate uses the bare noun phrase "MUST NOT exceed one"
           with no observable subject binding; reads as a dangling condition.
  suggest: improve op CONCRETIZE — name the measured quantity and threshold.
```

A fourth, non-blocking note records that `Q-001` is `[blocking]` and `AFFECTS AC-002`, so `AC-002` MUST NOT reach the `lower` pass until the question is resolved (`SOL-O…` orchestration class; see §9, §18).

### D.3 Stage 3 — improved `spec.swarm.md` (pass: `improve`)

The `improve` pass applies the named ops — `BIND`, `NORMALIZE`, `CONCRETIZE` — strictly preserving intent (§10). `Q-001` is resolved out-of-band by the spec owner (decision: redirect to `/login`); the resolution is recorded and `Q-001` is removed, unblocking `AC-002`. Only the changed blocks are shown.

```sol
REQ AC-002:
WHEN the refresh token is expired
THE auth client MUST clear the local session
AND THE auth client MUST redirect to `/login`
VERIFY BY test:cmdTest:web/tests/auth-refresh-expired.spec.ts#clears-and-redirects
DEPENDS ON IF-001
WRITES web/src/http/client.ts
RISK medium

INVARIANT I-001:
the retry count for a single original request MUST NOT exceed 1
VERIFY BY property:cmdTest:web/tests/auth-refresh.properties.ts#no_unbounded_retry
```

`NORMALIZE` resolved `SHOULD` to `MUST` (the spec owner judged the session-clear mandatory, so no `BECAUSE` is needed); `CONCRETIZE` fixed the threshold to the literal `1` and named the measured quantity; `BIND` attached a `test` proof to `AC-002` and a `property` proof to `I-001` (an `INVARIANT` prefers `property|model|static`, §15). All three diagnostics now clear.

### D.4 Stage 4 — IR excerpt (pass: `lower`)

The `lower` pass emits the typed IR (`auth-refresh.swarm.ir.json`) conforming to Appendix C: surface keywords become snake_case fields, relationships move into `edges[]` (the single source of relationship truth — never node scalars), and node ids are namespaced. A 3-node slice is shown.

```json
{
  "meta": {
    "id": "auth-refresh",
    "title": "Silent token refresh on 401",
    "language": "SOL/0.1",
    "version": "0.1.0",
    "status": "draft"
  },
  "nodes": [
    {
      "id": "INTERFACE.auth-refresh.IF-001",
      "kind": "INTERFACE",
      "clauses": { "returns": "Session | AuthExpired" },
      "owner": "auth-client",
      "verify_by": [
        { "type": "contract", "adapter": "cmdValidate",
          "ref": "openapi/auth-refresh.yaml", "selector": null, "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "auth-refresh.swarm.md", "line_start": 9, "line_end": 15,
                  "content_hash": "sha256:1f4a…c0" }
    },
    {
      "id": "REQ.auth-refresh.AC-001",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": "a request returns 401 AND a refresh token is present",
                   "subject": "auth client",
                   "predicate": "call refreshSession() once and replay the original request" },
      "risk": "high",
      "writes": ["web/src/http/client.ts"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "web/tests/auth-refresh-401.spec.ts",
          "selector": "replays-after-refresh", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "auth-refresh.swarm.md", "line_start": 19, "line_end": 27,
                  "content_hash": "sha256:9b2e…41" }
    },
    {
      "id": "INVARIANT.auth-refresh.I-001",
      "kind": "INVARIANT",
      "modality": "MUST NOT",
      "clauses": { "predicate": "retry count for a single original request exceeds 1" },
      "verify_by": [
        { "type": "property", "adapter": "cmdTest",
          "ref": "web/tests/auth-refresh.properties.ts",
          "selector": "no_unbounded_retry", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "auth-refresh.swarm.md", "line_start": 39, "line_end": 42,
                  "content_hash": "sha256:7d10…aa" }
    }
  ],
  "edges": [
    { "from": "REQ.auth-refresh.AC-001", "to": "INTERFACE.auth-refresh.IF-001",
      "type": "depends_on", "hard": true },
    { "from": "REQ.auth-refresh.AC-001", "to": "INVARIANT.auth-refresh.I-001",
      "type": "affects", "hard": false }
  ],
  "diagnostics": [],
  "provenance": { "hash": "sha256:c33b…9e", "compiler_version": null,
                  "compiled_at": "2026-05-31T00:00:00Z" }
}
```

`compiler_version` is `null` because no tool is shipped (Invariant 1, NO RUNTIME, §2); the IR here is the contract a future tool emits against (§12), produced by hand for the fixture.

### D.5 Stage 5 — `task.md` work packet (passes: `decompose`, `implement`)

The `decompose` pass projects the IR into a work packet whose write surfaces are a subset of the assigned obligations' `WRITES` (the two-tier lowering rule, §11.4, §18; violation = `SOL-O305`, G7). The `implement` pass executes it. Only the load-bearing frame is shown.

```text
---
type: task
id: auth-refresh-client
status: active
task_kind: feature
source: .agents/specs/auth-refresh.swarm.md
assigned_obligations: [AC-001, AC-002]
invariants: [I-001]
interfaces: [IF-001]
write_surfaces: [web/src/http/client.ts]
verification_bindings:
  - AC-001: test:cmdTest:web/tests/auth-refresh-401.spec.ts#replays-after-refresh
  - AC-002: test:cmdTest:web/tests/auth-refresh-expired.spec.ts#clears-and-redirects
  - I-001:  property:cmdTest:web/tests/auth-refresh.properties.ts#no_unbounded_retry
parallel_group: client-edits
blocked_by: []
---

# Task: Implement auth-refresh client behavior

## 3. Do not do
- Do not implement unassigned obligations.
- Do not change behavior outside web/src/http/client.ts.

## 6. Verification matrix
| Obligation | Required proof              | Actual proof                          | Status |
| ---------- | --------------------------- | ------------------------------------- | ------ |
| AC-001     | test:#replays-after-refresh | auth-refresh-401.spec.ts passed       | pass   |
| AC-002     | test:#clears-and-redirects  | auth-refresh-expired.spec.ts passed   | pass   |
| I-001      | property:#no_unbounded_retry| auth-refresh.properties.ts passed     | pass   |
```

### D.6 Stage 6 — `trace.md` excerpt (pass: `verify`)

The `verify` pass records a `TRACE` block plus the provenance the drift join depends on (§16, G11): per-binding `source_hash` (echoing the IR node `content_hash`), per-surface file hash, adapter, core verdict, and confidence tier.

```text
---
type: trace
id: auth-refresh-client-trace
source_task: .agents/tasks/auth-refresh-client.md
source_spec: .agents/specs/auth-refresh.swarm.md
---

# Trace: auth-refresh client

TRACE T-001:
IMPLEMENTS AC-001, AC-002
PRESERVES I-001
CHANGED web/src/http/client.ts
PROOF test:cmdTest:web/tests/auth-refresh-401.spec.ts#replays-after-refresh passed
PROOF test:cmdTest:web/tests/auth-refresh-expired.spec.ts#clears-and-redirects passed
PROOF property:cmdTest:web/tests/auth-refresh.properties.ts#no_unbounded_retry passed

## Provenance
| binding | source_hash      | per_surface_hash               | adapter | verdict | tier   |
| ------- | ---------------- | ------------------------------ | ------- | ------- | ------ |
| AC-001  | sha256:9b2e…41   | client.ts=sha256:5510…b3       | cmdTest | PASS    | high   |
| AC-002  | sha256:e8f7…2d   | client.ts=sha256:5510…b3       | cmdTest | PASS    | high   |
| I-001   | sha256:7d10…aa   | properties.ts=sha256:aa90…1c   | cmdTest | PASS    | high   |
```

### D.7 Stage 7 — `review.md` excerpt and merge-gate outcome (pass: `review`)

The `review` pass (run under the `skeptic` profile, §27) consumes the trace and emits per-obligation `VERDICT` lines carrying a core value optionally decorated with a lifecycle value (§14). `AC-001` and `I-001` are clean `PASS`. `AC-002` is shown with a lifecycle decorator: its bound test PASSed, but `web/src/http/client.ts` was edited after the recorded PASS, so its source no longer matches — it is decorated `STALE` (§16). Per the merge gate, a STALE required obligation is NOT mergeable until reconciled.

```text
---
type: review
id: auth-refresh-client-review
source_trace: .agents/traces/auth-refresh-client-trace.md
source_spec: .agents/specs/auth-refresh.swarm.md
---

# Review: auth-refresh client

## Obligation verdicts

VERDICT AC-001: PASS
REASON Replay-after-refresh test exercises a 401 with a present refresh token and asserts one replay.
EVIDENCE auth-refresh-401.spec.ts output in review log

VERDICT AC-002: PASS (STALE by source-hash: client.ts modified after last PASS at sha256:5510…b3)
REASON Prior PASS evidence no longer matches current write-surface hash; requires 3-way reconcile.
EVIDENCE prior verdict + changed-surface diff in review log

VERDICT I-001: PASS
REASON Property test fails on any path producing retry_count > 1; current run is green.
EVIDENCE auth-refresh.properties.ts output in review log

## Merge gate
Gate: every required obligation is PASS or WAIVED; none STALE/CONTRADICTED/FAIL/BLOCKED/UNVERIFIED.
Result: BLOCKED — AC-002 is STALE. Re-run the bound proof against the current surface
(reconcile option 1), then re-evaluate. After re-run AC-002 → PASS, the gate opens.
```

### D.8 Stage 8 — promotion (pass: `promote`)

After reconcile (`AC-002` re-run → PASS, gate open), a durable discovery from the task is promoted into a `finding.md` carrying full provenance (§23, Q8.26; schema G11): `origin_obligations`, `origin_traces`, the pass+profile that produced it, reviewer/tool, `content_hash`, confidence, and applies-when bounds. The `memory/INDEX.md` MAP gains one link with a "Load when" condition; no procedure is inlined there (§23, §31).

```text
---
type: finding
id: refresh-storm-on-shared-401
status: promoted
related_obligations: [AC-001, I-001]
confidence: high
---

# Finding: A single expired token can fan out to N concurrent 401s

## Claim
Concurrent in-flight requests each see the 401 and independently call refreshSession();
without a single-flight guard this violates I-001 in aggregate even though each request
retries at most once.

## Provenance
- origin_obligations: [REQ.auth-refresh.AC-001, INVARIANT.auth-refresh.I-001]
- origin_traces: [auth-refresh-client-trace#T-001]
- pass: verify; profile: skeptic
- reviewer_or_tool: review.md (human review)
- content_hash: sha256:9b2e…41
- confidence: high

## Applies when
- Multiple requests can be in flight when a token expires.

## Does not apply when
- The client serializes all auth-bearing requests.
```

```text
# memory/INDEX.md  (excerpt)
- [Refresh storm on shared 401](../findings/refresh-storm-on-shared-401.md)
  — Load when: implementing or reviewing concurrent token-refresh paths.
```

---

## Appendix E — Residual gaps and v0.1 judgment calls (G1–G12)

The decision record (§(b) of `.agents/research/swarm-kernel-decisions.md`) enumerates twelve residual gaps requiring an author's judgment. This appendix states each as the NORMATIVE v0.1 position, using the recommended resolution, and cross-references the body section that owns it. Nothing here is left implicit; an item is "Revisit in v0.2?" only where this specification expects the resolution to deepen (it does not reopen the v0.1 disposition).

| Gap | The question | v0.1 disposition (normative) | Owner | Revisit in v0.2? |
| --- | --- | --- | --- | --- |
| **G1** | Is there a config schema to promote advisories→errors (strict mode) or demote a blocker with a recorded waiver? | A `swarm.config` file MAY carry a `severity_overrides` map (`code → BLOCKING\|ADVISORY\|OFF`) and a `waivers[]` list; each waiver MUST record `{code, span_or_obligation, authority, reason, expires_on, source_hash}`. A demotion-to-OFF without a waiver record is itself a lint error. Absent the file, the default severities (§8) hold. | §8, §17 | Yes — add inheritance/profile layering. |
| **G2** | Where is the binding-clause vs commentary boundary that gates many `SOL-P` codes? | A span is **binding iff it lies inside a typed obligation block** (`REQ`, `CONSTRAINT`, `INVARIANT`); every other span is **commentary**. Comparatives, loopholes, and high-risk words are BLOCKING in binding spans and ADVISORY in commentary. This is normative, not heuristic. | §7, §8 | No. |
| **G3** | Does `AND THE` chaining violate single-obligation discipline? | `AND THE <actor> <MODAL> <response>` chaining is **permitted**; the `lower` pass MUST split each conjunct into a distinct IR obligation. More than two chained obligations in one block emits a non-blocking `SOL-P004`-adjacent **warning** suggesting `ATOMIZE`; it is never a hard error. | §6, §10, §11 | No. |
| **G4** | What is the enforcement-lane artifact mapping each CONSTRAINT/INVARIANT/stop-rule to its deterministic home? | The kernel defines a first-class **enforcement-lane artifact** (one table) mapping each `CONSTRAINT`/`INVARIANT`/stop-rule/secret-redaction obligation to its eventual deterministic home (`PreToolUse` hook, CI step, permission deny, schema validator). It is **aspirational/manual today** (Invariant 1/2) and MUST be labeled as such; it claims no live enforcement. | §17 | Yes — bind each row to a shipped hook/CI contract. |
| **G5** | Who holds waiver authority, and does WAIVED auto-expire? | Waiver authority is **human or spec-owner only** (never a tool, never an agent profile acting alone). A `WAIVED` decorator **auto-expires on the next source-hash change** of the waived obligation (preventing zombie waivers); an expired waiver reverts the obligation to its undecorated core verdict and re-closes the merge gate. | §14 | No. |
| **G6** | What is the action on `CONTRADICTED` at the merge gate, beyond the proof-strength ordering? | On `CONTRADICTED`, the merge gate **blocks and routes to review**; the obligation's core verdict is taken from the **stronger oracle** per the proof-strength order (`model > property/contract > test > static > manual/monitor`), and the weaker proof is recorded as superseded evidence. A tie at equal strength escalates to `manual`. | §14, §15 | Yes — formal weighting for LLM-judge proofs. |
| **G7** | What is the READS conflict rule, and how are shared/global surfaces handled? | read/read is **always parallel-safe**; read/write on the same surface is a **conflict edge** (conflict-serializability). A `SURFACE` MAY carry an attribute — `SURFACE <name> = … [append-only\|integration\|shared]` — so shared/global/append-only surfaces (lockfiles, CI config, manifests) are not treated as ordinary write conflicts and do not trigger blanket staleness. A new lint code **`SOL-O305`** ("owned path outside declared write surface") enforces the two-tier lowering check. | §8, §16, §18 | No. |
| **G8** | What is the full `*.swarm.plan.json` schema, given the unreconciled source field sets? | The plan schema follows the **same method as the IR (Q3.12)**: a **graph envelope** plus a **rich task payload**. Each task carries `{id, pass, profile, derived_from[], reads[], writes[], depends_on[], verify_by[], merge_safe}`. There is **no `locks` field** — a lock group is a named `SURFACE`. The plan is **documented-as-contract only**; no tool emits it (Invariant 1). | §13 | Yes — batching/lane fields once a launcher exists. |
| **G9** | What does a "universal workflow rule" promotion actually become, given the ≤200-line AGENTS.md cap? | A workflow-rule promotion becomes a **pass-guide edit plus a one-line AGENTS.md pointer**, never inline procedure in the bootloader. Only persistent *facts* (ADR 0017) live in `AGENTS.md`; the procedure lives in the named pass guide the pointer references. | §23, §26, §31 | No. |
| **G10** | What is the canonical frontmatter field-name and value vocabulary? | Frontmatter is normalized to three fields: **`swarm_language: SOL/0.1`** (language discriminator), **`aps_version: 0.1`** (prose-standard version), **`spec_version: 0.1.0`** (spec content version, SemVer). These map one-to-one onto the three IR version fields (`meta.language`, n/a, `meta.version`) and MUST NOT be merged. | §25 | No. |
| **G11** | What is the exact trace-provenance schema the drift join and conformance checker depend on? | Every recorded PASS MUST carry `{source_hash, per_surface_hash[], adapter, verdict, tier, origin_obligations[], origin_traces[]}`. This single schema is referenced identically by drift/staleness (§16), the memory model's promotion provenance (§23), and the verdict model (§14). | §14, §16, §23 | No. |
| **G12** | What baseline measures the SOL-P high-risk-word false-positive rate? | The golden corpus (§33) ships a **labeled good/bad prose fixture set** with a stated **precision/recall baseline of 0.90 precision / 0.85 recall** for the `SOL-P` rules, so the high-risk-word list's false-positive rate is measurable rather than asserted. | §33 | Yes — raise the recall target as the corpus grows. |

---

## Appendix F — Glossary

One crisp definition per term, consistent with the body. Each entry cross-references the owning section. Terms are alphabetized.

| Term | Definition |
| --- | --- |
| **adapter** | The project-specific tool an obligation's proof resolves to; the `<adapter>` slot of `VERIFY BY <type>:<adapter>:<artifact>` resolves through `AGENTS.md` > Commands `cmd*` placeholder slots (§15, §31). |
| **AGENTS.md** | The always-loaded bootloader of persistent facts and pointers, hard-capped at ≤200 lines / ≤25 KB; carries the Commands table the adapters resolve through but never defines modality, authority, or verification semantics (§31). |
| **APS** | Agent Prose Semantics — the controlled-prose standard governing the readable prose around SOL blocks; the name survives, but `APS-` is retired as a lint-code prefix (the rules now live under `SOL-P###`) (§7). |
| **block type** | One of the seven SOL block kinds (`REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`, `TRACE`, `VERDICT`), each with a fixed id prefix and clause grammar (§4, §6). |
| **conformance** | The property of a repository that ships the language reference docs, the seven core templates, a populated `AGENTS.md` bootloader, and `.agents/.swarm-version` (§20, §32). |
| **CONSTRAINT** | An obligation block (id `C-NNN`) that restricts *how* obligations may be satisfied rather than requesting behavior; carries binding force (§6). |
| **decompose** | The pass that projects the IR into work packets (`task.md`), enforcing that owned write surfaces are a subset of assigned obligations' `WRITES`; a pass, not an improve op (§9, §11). |
| **distillation loss budget** | The discipline that names what each compilation step Preserved, Dropped, and left Still-uncertain, bounding the meaning lost when prose intent is lowered toward code (§24). |
| **drift** | The condition where an obligation's source or a declared write surface changes after its last PASS, detected by content-hash comparison and surfaced as the `STALE` lifecycle decorator (§16). |
| **EARS** | Easy Approach to Requirements Syntax — the trigger/condition keyword family (`WHEN`, `WHILE`, `WHERE`, `IF [THEN]`) that shapes the SOL `REQ` clause order (§5, §6). |
| **edge** | A typed relationship in the IR (`depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, `preserves`); edges are the single source of relationship truth, never duplicated as node scalars (§12). |
| **enforcement lane** | The first-class (today aspirational/manual) mapping of each CONSTRAINT/INVARIANT/stop-rule to its eventual deterministic home outside the model — hook, CI, permission, or schema (§17). |
| **finding** | A plain `.md` artifact recording one durable project fact with mandatory provenance; the unit of promotion into spec, ADR, audit, or memory (§23, §29). |
| **IR** | The intermediate representation — the typed `{meta, nodes[], edges[], diagnostics[], provenance}` JSON envelope (`*.swarm.ir.json`) emitted from the surface spec; documented as a contract, not shipped by any tool (§12, Appendix C). |
| **INVARIANT** | An obligation block (id `I-NNN`) asserting a property that must remain preserved over time; prefers `property\|model\|static` proofs; carries binding force (§6, §15). |
| **kickback** | The re-entry of the `implement` pass after a `FAIL` or `UNVERIFIED` verdict; a control-flow event, never a task type (§28). |
| **lifecycle decorator** | One of `WAIVED`, `STALE`, `CONTRADICTED` — a parenthetical that decorates a core verdict to record its status over time (§14). |
| **lint layer** | One of the five letters in `SOL-<LAYER><NNN>` — `S` syntax, `P` prose, `M` semantic, `V` verification, `O` orchestration — each a 100-block, append-only with tombstoning (§8). |
| **lower** | The pass (and conceptual phase) that translates the improved surface spec into the typed IR (§9, §11). |
| **merge gate** | The pass/fail decision that permits a merge iff every required obligation is `PASS` or `WAIVED` and none is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED` (§14). |
| **obligation** | A binding clause carried by a `REQ`, `CONSTRAINT`, or `INVARIANT` block; the unit that is verified, traced, and gated (§4, §6). |
| **obligation graph** | The dependency-and-conflict graph the IR encodes via `edges[]`, over which Swarm's core analyses (topo-sort, cycle detection, write-conflict, traceability) run (§3, §12). |
| **pass** | One of the nine schedulable transformations (`author → lint → improve → lower → decompose → implement → verify → review → promote`) that a task performs over its source artifacts (§9). |
| **pass guide** | A skill reframed as procedural guidance for performing a pass; it never owns SOL or APS semantics, which must be understandable without it (§26). |
| **phase** | One of the seven conceptual compiler stages (`PARSE → NORMALIZE → LOWER → EXECUTE → VERIFY → REVIEW → PROMOTE`) onto which passes map (§9). |
| **plan** | The `*.swarm.plan.json` artifact — a graph envelope plus rich task payload derived from the IR; documented as a contract only, with no `locks` primitive (§13). |
| **profile** | A persona reframed as a heuristic parameter on a pass (e.g. `review[profile: skeptic]`), carrying Prevents/Default-questions/Required-evidence/Refuses/Applies-when (§27). |
| **promotion** | The protocol that moves a durable discovery out of task-local state into a finding, spec amendment, ADR, audit, or memory entry, with provenance, before task close (§23, §29). |
| **proof type** | One of the nine closed verification kinds (`static, test, contract, property, model, perf, security, manual, monitor`) that types a `VERIFY BY` binding (§15). |
| **REQ** | An obligation block (id `AC-NNN`) defining a required behavior in EARS-shaped clause order; carries binding force (§6). |
| **SOL** | The obligation language — the English-shaped, uppercase-keyword controlled notation, embedded in Markdown, in which obligations are authored (§4, §5, Appendix A). |
| **source authority** | The two-orthogonal-axis ordering (domain first, then artifact) that resolves which obligation governs when two conflict; code and tests may falsify but never silently amend intent (§22). |
| **STALE** | The lifecycle decorator marking a prior PASS whose recorded source or write-surface hash no longer matches current state; blocks the merge gate and forces a 3-way reconcile (§14, §16). |
| **surface** | The human-authored layer — English-shaped uppercase space-separated keywords in `.swarm.md` — as distinct from the snake_case IR layer (§4, §5). |
| **SURFACE** | A named coarse write-surface group (`SURFACE <name> = …`), optionally attributed `append-only\|integration\|shared`; replaces any `locks` primitive (§4, §18, G7). |
| **task_kind** | The frontmatter enum that parameterizes the `implement`/`author` passes (e.g. `feature`, `fix`, `refactor`, `review`, `spec-writing`, `orchestration`); the 18 canonical values are defined in §28. |
| **trace** | The emitted artifact (`*.swarm.trace.md`) recording a `TRACE` block — implementation claims, changed surfaces, proof references — plus the provenance the drift join consumes (§16, §21). |
| **VERDICT** | The judgment block (reusing the judged obligation's id) carrying one core value (`PASS`, `FAIL`, `BLOCKED`, `UNVERIFIED`) optionally decorated with a lifecycle value; lives inside `review.md`, never a standalone file (§14). |
| **VERIFY BY** | The surface clause binding an obligation to its proof: `VERIFY BY <type>:<adapter>:<artifact>[#selector]`; the IR field name is `verify_by` (§15). |
| **write surface** | A file or glob an obligation declares it may modify via `WRITES`; the unit of write-conflict and parallel-safety analysis, and the projection an owned path must be a subset of (§18). |
