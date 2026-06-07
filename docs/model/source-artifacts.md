# Source artifacts and the `.swarm.` infix partition

> Swarm's reference for source artifacts: which files a Swarm repository may contain, the `.swarm.` infix that partitions them into two classes, the canonical filenames per class, and the tiers on which conformance is defined.

This page is the reader's first map of *which files a Swarm repository may contain* and *how the framework tells them apart*. Swarm is markdown-only and provider-neutral, with **no runtime** (Invariant 1): every actor named below ("parser", "linter", "planner", "checker") is a CONTRACT a future tool would build against, never shipped code — every artifact is inert reference data, a copyable template, or a file a human or agent populates by hand.

This page covers the artifact *set*, its two-class partition, and the *tiers* on which conformance is defined. Adjacent material lives on sibling pages: repository layout and the adopted-project workspace model, the per-artifact contracts and copyable templates under [docs/artifacts/](../artifacts/), and the mechanically-checkable conformance procedure in [docs/model/conformance.md](conformance.md).

## 1. Two classes, one discriminator: the `.swarm.` infix

Swarm partitions every repository file that participates in the flow into **exactly two classes**, discriminated solely by whether the filename carries the literal infix `.swarm.` before its final extension.

| Class | Filename rule | Meaning |
| --- | --- | --- |
| **Swarm-format** | MUST contain the `.swarm.` infix (e.g. `auth.swarm.md`, `auth.swarm.ir.json`). | The file is *parsed or emitted by the build steps*. Its bytes are subject to the SOL grammar (see the [SOL reference](../language/SOL.md)) or the structured-form / plan JSON schemas (the [structured form](../reference/structured-form.md)). |
| **Working artifact** | MUST NOT contain `.swarm.`; uses a plain `.md` extension (e.g. `task.md`, `review.md`). | A *human/agent working artifact*: structured Markdown governed by an artifact contract, not by the SOL grammar — though it MAY embed SOL blocks (notably `VERDICT` and `TRACE`) as quoted data. |

A conformant Swarm tool MUST treat the `.swarm.` infix as the **sole, sufficient discriminator** for "do I parse/emit this": it MUST NOT parse a plain `.md` working artifact as SOL source, and MUST NOT emit a build output to a path lacking the infix.

*Design rationale:* the double-extension convention (familiar from `.test.ts`, `.d.ts`) lets tooling select files by a stable, greppable suffix without inspecting their content.

The only **human-authored** `.swarm.` artifact is `*.swarm.md` (the source spec); the `.swarm.*.json` / `.swarm.trace.md` variants are *emitted* artifacts (see §3.1 below).

## 2. The artifact set is built from 7 block types and 7 verdicts

The working artifacts on this page are containers for the language defined elsewhere in Swarm. Two counts are load-bearing here:

- **7 block types** — the SOL surface-language blocks (`REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`, `TRACE`, `VERDICT`) are what a `*.swarm.md` source carries and what working artifacts embed as quoted data.
- **7 verdicts** (4 core + 3 lifecycle) — core ∈ {`PASS`, `FAIL`, `BLOCKED`, `UNVERIFIED`}; lifecycle ∈ {`WAIVED`, `STALE`, `CONTRADICTED`}. A `VERDICT` is a SOL *block*, never a file (see §3.3 below).

This page does not re-enumerate the broader Swarm taxonomies (5 modals, 9 proof types, 7 phases / 9 steps, 10 improve ops, 5 lint layers S/P/M/V/O); they live in their own reference pages. They are named only to anchor that the artifacts here are the *carriers* of that vocabulary, not new vocabulary.

## 3. Canonical filenames by class

### 3.1 Swarm-format artifacts (`.swarm.` infix)

| Filename pattern | Role | Authored by | Schema / grammar | Status in v0.1 |
| --- | --- | --- | --- | --- |
| `*.swarm.md` | Source spec — APS prose interleaved with SOL blocks. | Human / authoring agent | SOL grammar + APS prose standard | Live; the only hand-written `.swarm.` file. |
| `*.swarm.ir.json` | Emitted structured form (the spec's obligations). | Build step (future tool) | structured-form envelope | **Reserved contract name.** Not written by any shipped tool. |
| `*.swarm.plan.json` | Emitted plan (structured, schedulable work packets + graphs). | Build step (future tool) | plan envelope | **Reserved contract name.** Not written by any shipped tool. |
| `*.swarm.trace.md` | Emitted/instantiated trace for a built spec. | Implement/verify step (today: agent by hand) | trace contract + provenance | Copyable template is `trace.md` (plain); built *instances* MAY take the `*.swarm.trace.md` name. |

The two `.json` variants are **documented-as-contract names only**: Swarm pins their shape so a future launcher can build against a stable target, but Swarm ships no parser, emitter, planner, or checker (Invariant 1). A v0.1 repository MUST NOT claim that any `*.swarm.ir.json` or `*.swarm.plan.json` is *produced* by a Swarm tool; it MAY hold hand-written examples in the golden corpus.

### 3.2 Working artifacts (plain `.md`)

| Filename | Role | Tier (see §4) |
| --- | --- | --- |
| `task.md` | Structured work packet / step frame for one step. | Tier 1 — core (required) |
| `trace.md` | Implementation/preservation claims + evidence against obligations. | Tier 1 — core (required) |
| `review.md` | The verdict record: per-obligation `VERDICT` blocks + matrix + final verdict. | Tier 1 — core (required) |
| `status.md` | Observed-state read-model: per-obligation latest verdict + drift, for one spec. | Execution — derived (conditional) |
| `task-orchestration.md` | Coordination record for one parallel decomposition: owned surfaces, hand-offs, liveness, merge log. | Execution — orchestration (conditional) |
| `finding.md` | One durable, provenance-anchored project fact. | Tier 1 — core (required) |
| `adr.md` | An immutable architecture decision record (Nygard form). | Tier 1 — core (required) |
| `memory/INDEX.md` | Compact recall map (links + a "Load when" per entry). | Tier 1 — core (required) |
| `memory/glossary.md` | One-word-one-meaning term store. | Memory model |
| `memory/patterns/*.md` | Recurring multi-finding knowledge. | Memory model |
| `audit.md` | Observation-only source artifact; promotes to a spec. | Tier 3 — stdlib source-doc (conditional) |
| `research.md` | Investigation source artifact; promotes to a spec. | Tier 3 — stdlib source-doc (conditional) |
| `bug-report.md` | Diagnosis-only source artifact; promotes into a fix *task*. | Tier 3 — stdlib source-doc (conditional) |

### 3.3 There is NO `verdict.md` (normative)

A repository MUST NOT contain a standalone `verdict.md`, and no tool MAY emit one. `VERDICT` is a SOL *language block*, not a file; `review.md` is its canonical *container*.

*Rationale:* a verdict is the output of the `review` step, and like a SARIF `result` that lives inside a `run` rather than as a free-standing file, it belongs inside its container record, not on its own. Swarm ships documentation of the `VERDICT` block and the verdict taxonomy as a reference page, not as a copyable artifact template.

## 4. The tiered required-artifact set

The required set is partitioned into **three tiers**. Only Tiers 1 and 2 are load-bearing for conformance; Tier 3 is shipped but conditional.

### 4.1 Tier 1 — Swarm-required core (7 artifacts)

Seven artifacts. Each MUST ship both (a) a documented contract and (b) a copyable template skeleton; all seven contracts live under [docs/artifacts/](../artifacts/).

| # | Artifact | Class | Role |
| --- | --- | --- | --- |
| 1 | `spec.swarm.md` | Swarm-format | Source of obligations. |
| 2 | `task.md` | working | Structured step frame. |
| 3 | `trace.md` | working | Implementation claims + evidence. |
| 4 | `review.md` | working | Verdict record (verdict container). |
| 5 | `finding.md` | working | Durable fact (memory Tier-2 evidence). |
| 6 | `adr.md` | working | Immutable decision. |
| 7 | `memory/INDEX.md` | working | Recall map (memory Tier-1). |

### 4.2 Tier 2 — Swarm-required language / reference docs (6 docs)

Six *prose-and-table reference pages* (not copyable templates). A conformant repo MUST contain a self-contained copy of each, so the repository explains its own language without external dependency.

| # | Reference doc | Defines | Where it lives |
| --- | --- | --- | --- |
| 1 | SOL reference | Surface syntax + block-type reference. | [`../language/SOL.md`](../language/SOL.md) |
| 2 | APS reference | The controlled-prose standard. | [`../language/APS.md`](../language/APS.md) |
| 3 | Error / lint taxonomy | The `SOL-<LAYER><NNN>` catalogue with stable codes + severities. | [`../language/errors.md`](../language/errors.md) |
| 4 | Source-authority | The two-axis authority model + tie-break. | [`source-authority.md`](source-authority.md) |
| 5 | Promotion-protocol | The promotion statuses + workflow. | [`../reference/promotion-protocol.md`](../reference/promotion-protocol.md) |
| 6 | Distillation-loss-budget | The Preserved / Dropped / Still-uncertain discipline + loss accounting. | [`../reference/distillation-loss-budget.md`](../reference/distillation-loss-budget.md) |

### 4.3 Tier 3 — stdlib source-doc templates (shipped, conditional)

These are *source documents* that promote into the flow. They are **conditional**: a repo need not have instantiated any of them to be conformant, but a conformant repository MUST ship the templates.

| # | Template | Epistemic stance | Promotes to |
| --- | --- | --- | --- |
| 1 | `audit.md` | Observation-only (records what *is*, never prescribes). | a `spec.swarm.md` (via `author` step). |
| 2 | `research.md` | Investigation (open questions + findings). | a `spec.swarm.md` (via `author` step). |
| 3 | `bug-report.md` | Diagnosis-only (root cause, never fix). | a fix `task.md` (`task_kind: fix`). |

A conformant repository SHOULD also ship `prd.md` (stance: **intent**) and `rfc.md` (stance: **proposal**) templates alongside the three above — extending the Tier-3 set to five — and MAY additionally ship a `use-case.md` or `nfr.md` template. None of these is ever conformance-required.

Beyond these, the stdlib SHOULD make available a **conditional `threat-model.md`** source-doc for changes whose domain is `security` or that touch an attack surface (mapped to OWASP-LLM01). It sits **outside** the five-template Tier-3 inventory the conformance definition counts — it is never conformance-required, so the starter kit MAY ship it as an optional security extension and a conformant repo MAY have zero instances. Like the other source-docs it is plain `.md` with `type` + `id` frontmatter, holds **no obligation blocks** (stance: *threat observation*, not intent), and promotes forward only through an `author` step that re-states each modelled threat as a `CONSTRAINT`/`INVARIANT` with its own id, modality, and a (typically `security`) `VERIFY BY` — subject, as an externally-informed observation, to the source-authority rule for untrusted sources before any obligation it implies becomes binding. Its contract is [`docs/artifacts/threat-model.md`](../artifacts/threat-model.md).

### 4.4 The recognized parents of a spec

A spec is not born only from research. Swarm normalizes many requirements-practice artefacts into one obligation-bearing `spec.swarm.md` rather than pretending every intent begins as research. The distinction this projection carries forward is:

- **Shipped Tier-3 source-doc templates** (conditional, never required): `audit.md`, `research.md`, `bug-report.md`, `prd.md`, and `rfc.md`.
- **Recognized inputs that normalize INTO a spec** during the `author` step, emitting `REQ` / `CONSTRAINT` / `INVARIANT` / `INTERFACE` blocks plus verification-matrix rows directly, and not necessarily shipped as separate templates: `use-case.md` / examples (scenario), `nfr.md` / SLOs (quality attributes), and interface sources (OpenAPI / GraphQL / DB schema).

`research.md` holds a special role as Swarm's **detached first-class evidence store**: it is not bound to one downstream artefact — one research artefact MAY feed many PRDs, specs, ADRs, findings, or audits at once — which minimizes copying, preserves provenance, and reduces distillation loss when upstream facts evolve.

## 5. What conformance requires (pointer)

A **spec/authoring repo** is **Swarm-conformant** iff *all three* hold: (1) self-contained copies of all six Tier-2 docs; (2) a copyable template for each of the seven Tier-1 artifacts, each satisfying its contract; (3) a populated `AGENTS.md` bootloader within the ≤200-line / ≤25 KB density cap. There is no version-file clause (an adopted project keeps no per-repo version marker — [ADR-0050](../adrs/0050-swarm-is-a-spec-repo-discipline.md)), and a **code repo** that only consumes specs is not measured against (1)/(2). Conditional Tier-3 artifacts and the reserved `.swarm.*.json` contract files are **not** required for conformance. The full mechanically-checkable contract and the golden corpus that exercises it live in [conformance.md](conformance.md). This projection states the artifact set those checks range over; it does not restate the checks themselves.

## Related

- [docs/model/source-authority.md](source-authority.md) — the two-axis authority model + tie-break that governs which artifact wins when sources disagree.
- [docs/model/conformance.md](conformance.md) — the full mechanically-checkable conformance procedure and golden corpus that range over the artifact set defined here.
- [docs/artifacts/](../artifacts/) — the per-artifact contracts and copyable template skeletons for the Tier-1 core artifacts and the Tier-3 source-doc templates.
