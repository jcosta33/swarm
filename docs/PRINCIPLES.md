# Principles

> Swarm's reference for the load-bearing invariants and standing principles of the framework: the tiebreakers that decide cases when two design choices collide. The installable files that carry these principles into an adopted project ship under [`starter-kit/`](./starter-kit/). For what Swarm *is* in one paragraph — the spec is the source of truth, agents build from it, nothing runs — read the [root README](./README.md).

Everything below holds in *every* part of the framework — no construct may contradict an invariant.

The single object every principle turns on is **the obligations**: typed obligations (and the verdicts rendered on them), related to each other by typed edges. Specs produce obligations; the agents structure them into a plan and tasks; tasks implement them; traces claim them; verification proves them; reviews judge them; memory records durable discoveries about them.

---

## The five invariants

These are absolute. No later rule, template, pass guide, or profile may weaken them.

### 1. NO RUNTIME

Swarm is **markdown-only**. Everything that "runs" — parser, normalizer, planner, scheduler, differ, checker, LSP, CLI — is documented as a **contract a future tool builds against**, never as software this repository ships.

- **Rationale.** The repository is documentation plus the starter kit. Shipping a runtime would couple Swarm to one environment and break provider-neutrality.
- **Consequence.** Any section describing tool behavior frames it as "the contract a future tool builds against." No file may claim a CLI is required, or that automation already exists. Every "runs" verb resolves to a future-tool contract.

> **Tiebreaker.** When tempted to describe a capability as something Swarm *does*: ask whether this repository ships code that does it. It does not. Restate it as a contract a future tool must satisfy.

### 2. SOFT vs HARD control

Prose, SOL, APS, pass guides, profiles, and `AGENTS.md` are **soft control** — context and guidance. They must not be presented as enforcement. Anything that must hold *regardless of the model* requires a **deterministic check outside the model** (a hook, CI step, permission rule, or schema validator) — the **hard control** lane.

- **Rationale.** Model adherence is probabilistic (prompt-format sensitivity, multi-turn decay, lost-in-the-middle / context-rot); only an external deterministic check can guarantee a property.
- **Consequence.** The spec maps each `CONSTRAINT`, `INVARIANT`, stop-rule, and secret-redaction need to its eventual deterministic home, and states plainly that **today the hard lane is aspirational/manual** — there is no runtime. No file may claim Swarm enforces behavior through code.

> **Tiebreaker.** When a property "must" hold: name the deterministic check outside the model that would enforce it, and mark it aspirational until a tool exists. The markdown layer makes omission conspicuous; it cannot guarantee.

### 3. SURFACE vs STRUCTURED-FORM layering

Swarm has two layers: a **human surface** — English-shaped UPPERCASE space-separated keywords inside `*.md` — and a **machine JSON layer** of snake_case fields (the structured form). The surface is authored; the structured form is emitted.

- **Rationale.** The surface optimizes for human readability and model comprehension; the structured form optimizes for deterministic analysis. Conflating them produces fragile syntax.
- **Consequence.** Surface keywords are space-separated uppercase (`VERIFY BY`, `DEPENDS ON`, `OWNED BY`, `WRITES`, `READS`, `AFFECTS`); structured-form fields are snake_case (`verify_by`, `depends_on`, `writes`, `reads`, `affects`); surface ids are short (`AC-001`), structured-form node ids may be namespaced (`REQ.<spec>.AC-001`).

### 4. CODE IS REALITY

Code and tests are implementation **reality**: they can **falsify** an obligation, but they must not **silently amend** intent.

- **Rationale.** A passing or failing test is evidence about whether intent was met, not a re-statement of what intent *is*. Intent lives only in obligations.
- **Consequence.** When code disagrees with an obligation, the verdict is `STALE` or `CONTRADICTED`, and the conflict routes to an explicit three-way reconcile — re-run the proof, amend/supersede the obligation, or fix the code — never a silent re-bless of either.

### 5. SCHEMA-VALID OUTPUT IS NOT VERIFICATION

A structurally valid artifact — a schema-valid structured form, a well-formed trace — is **not** a verified one. **Shape is not truth.**

- **Rationale.** Structured output constrains form but cannot prove values are correct. "Tests passed" without observable output is not a proof. [[REFLEXION]](research/sources.md#REFLEXION)
- **Consequence.** Every completion claim maps to independent deterministic or evidentiary verification; a `VERDICT` of `PASS` requires a bound proof that actually ran and produced inspectable evidence, not the mere existence of a syntactically valid trace.

> **Tiebreaker.** When a claim rests on "it parsed" or "the tests are green" with nothing pasted: that is shape, not truth. Demand the bound proof and its inspectable evidence.

---

## Standing principles

The invariants are absolute; the principles below are the design stances the specification relies on. They follow from, and never override, the five invariants.

### Provider-neutral

Swarm makes **no assumption about which model or agent** executes it — not Claude, Codex, Cursor, Gemini, Aider, or any specific tool.

- **Rationale.** The contracts must outlive any single vendor and any single capability ceiling.
- **Consequence.** No section may hard-code provider-specific behavior; capability claims must be dated and treated as evidence, not load-bearing assumptions.

### Markdown-only with a self-contained starter kit

Swarm is delivered as markdown, and the starter kit must be **self-contained**: its SOL and APS references must not depend on the repository's `docs/` tree.

- **Rationale.** A vendored starter kit travels into a foreign repository where `docs/` will not exist.
- **Consequence.** The language references are duplicated into the starter kit, and the duplication is kept consistent by the conformance contract.

### Edges are the single source of relationship truth

In the structured form, **relationships live only on `edges[]`** — never duplicated as node scalars.

- **Rationale.** A relationship recorded in two places will drift; one canonical location keeps graph analyses (topo-sort, cycle detection, write-conflict, traceability) sound.
- **Consequence.** `depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, and `preserves` are edge types; a node must not also carry the same relationship as a scalar field.

### Distillation discipline

Meaning must be **preserved across every structuring step**. Each downstream transformation has a fixed budget of *permitted* loss and a fixed set of *forbidden* loss.

- **Rationale.** Dropping obligations, modalities, or verification bindings while structuring intent produces work that does not match it.
- **Consequence.** Dropping an obligation id, modality, actor, trigger, response, constraint, invariant, or verification binding while structuring is a **distillation error**.

### Load-bearing meaning lives only in SOL + the structured form

**All load-bearing meaning** — modality, actor, trigger/state, verification binding, authority order, conflict resolution, trace schema — lives in **SOL and the typed structured form**, and never in prose, pass guides, profiles, or `AGENTS.md`.

- **Rationale.** Prose-delivered semantics are unreliable: model adherence degrades under prompt-format sensitivity, multi-turn reliability decay [[MULTITURN-LOST]](research/sources.md#MULTITURN-LOST), and lost-in-the-middle / context-rot [[LOSTMID]](research/sources.md#LOSTMID), and an always-loaded instruction file behaves as context rather than as enforced configuration.
- **Consequence.** Prose and pass guides are non-authoritative *delivery* layers; a regression check must confirm that no pass guide, profile, or `AGENTS.md` section defines modality, authority order, or verification semantics. Always-loaded normative prose is capped (≤200 lines / ≤25 KB) [[LOSTMID]](research/sources.md#LOSTMID), with everything procedural moved to lazily-loaded pass guides and profiles — to protect adherence and cost, not because models "cannot follow many instructions."

### Unitary at rest, modular in execution

Swarm's organizing slogan is **"unitary at rest, modular in execution."**

- **Unitary at rest.** Swarm installs as one coherent framework. The language, artifact contracts, steps, templates, pass guides, and memory model arrive together and are internally consistent — there is no menu of disconnected features to assemble.
- **Modular in execution.** At run time, only the step, profile, and context a single task needs are loaded. A task names the pass guide and profile it requires; nothing else is in context. This protects instruction-adherence and token cost without fragmenting the framework. [[CTXENG]](research/sources.md#CTXENG)
- **Consequence.** The conceptual model is unitary: every piece is a component of one framework, not an independent gadget. A repository binds the framework as one whole; what varies at run time is only which step, profile, and context a given task loads.

### Evidence discipline — real science, not astrology

Swarm holds itself to the same standard it imposes on agents: **real science, not astrology.** Every load-bearing empirical claim and every standards-grounded normative choice must be grounded in a verified finding, used with its recorded caveats. This is Swarm's own discipline, applied to its own text and to every artifact a conformant repository produces.

- **Rationale.** A fact-shaped claim with no grounding is indistinguishable from invention; treating one as evidence corrupts every downstream verdict that rests on it.
- **Consequence.** A claim that is not backed by a verified finding must be stated as **design rationale**, not as evidence. A finding marked rejected, fabricated, or unverifiable must not be cited as fact — neither in canonical text nor in any produced artifact. A new empirical claim introduced by an amendment must first establish its grounding. **A fact-shaped statement that cites no verified source and is not labelled design rationale is a defect.**

---

## The workspace model (design)

The design principles for how an adopted project lays out on disk — spec repo vs. pristine code repo; SOL as an authoring aid, not a reading burden; the separate `sources/` / `status/` / `generated/` categories; specs own intent while code owns realization; the compacting ledger; and the boundary that has Swarm coordinate agent CLIs as workers rather than replace one — all live in [`model/workspace.md`](model/workspace.md). They follow from the invariants above (chiefly Invariant 1, NO RUNTIME, and Invariant 4, CODE IS REALITY) and are stated once there.

---

## How to use these principles

1. **In an amendment (ADR).** Cite the invariant or principle that motivates the decision. A change to any of these is an amendment that must be recorded as a new ADR and, if it touches the language, must bump the language version.
2. **In review.** Ask which principle a change serves and which (if any) it conflicts with. The five invariants are absolute tiebreakers; the standing principles never override them.
3. **As a skim test.** A doc, template, pass guide, or profile that violates an invariant without explanation is a defect, not a style choice.

## Related

- [Non-goals](./NON-GOALS.md) — what Swarm deliberately is not, the negative space these principles protect.
- [How Swarm works](./model/how-swarm-works.md) — the seven phases and nine steps the obligations flow through.
- [The workspace model](./model/workspace.md) — how the source / status / generated categories lay out on disk.
- [Source authority](./model/source-authority.md) — the amendment and authority rules an ADR cites when changing a principle.
- [Architecture decision records](./adrs/README.md) — the recorded amendments; a change to any invariant or principle lands as a new ADR.
