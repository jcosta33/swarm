# Swarm

**Swarm is a markdown-only, provider-neutral, obligation-centered specification compiler for agentic software engineering.**

You write human intent as a controlled-markdown specification. A fleet of agents acts as the compiler that turns it into proven work. The specification — not the code — is the authoritative source, the same pattern industry interface and configuration languages already use (OpenAPI, Terraform, Smithy, and Kubernetes' desired-state `spec` reconciled against observed `status`).

This repository ships **markdown only**. Everything described here that "runs" — a parser, linter, planner, scheduler, differ, checker, LSP, or CLI — is defined as a **contract a future tool builds against**, never as software this repository provides.

- **Spec-as-source-code.** Load-bearing meaning is carried as **SOL obligations** (the Swarm Obligation Language) inside ordinary `*.swarm.md` files.
- **Agents-as-compiler.** A fleet of agents compiles intent, through an ordered and named sequence of transformations, into work that is implemented, verified against the original obligations, and promoted into durable project knowledge.
- **The obligation graph** is the central object: a typed graph whose nodes are obligations (and the verdicts rendered on them) and whose edges are their relationships. Every role reduces to an operation on this graph, and the merge gate is a property of the graph — *every required obligation carries a passing verdict.*

For where Swarm sits next to spec-driven tools, agent frameworks, and prompt libraries, see [`docs/positioning.md`](docs/positioning.md). For the full pipeline, see [`docs/model/how-swarm-works.md`](docs/model/how-swarm-works.md).

## The 9-pass flow

Intent flows from upstream sources to durable memory through an ordered pipeline:

```text
sources  →  SOL obligations  →  lower  →  task frames  →  implement  →  trace  →  review/verdict  →  promote
```

Research, audits, and bug reports are normalized into a `*.swarm.md` spec; its obligations lower into the obligation graph and a plan; the plan yields bounded task frames; agents do the work and emit a trace; verification and review render verdicts against the original obligations; durable discoveries fold back into project memory.

Swarm distinguishes **7 phases** (conceptual, fixed-order stages: `PARSE → NORMALIZE → LOWER → EXECUTE → VERIFY → REVIEW → PROMOTE`) from **9 passes** (schedulable transformations: `author → lint → improve → lower → decompose → implement → verify → review → promote`).

The surface is small and closed: **7 block types** decorated by **5 modals**, binding proof with `VERIFY BY <type>:<adapter>:<artifact>` across **9 proof types**, judged by **7 verdicts**. Every closed set (and the exact members) is reconciled in one place — [`docs/reference/cheatsheet.md`](docs/reference/cheatsheet.md).

## Where the files go

Swarm lives in a **spec / documentation repo** — that's where intent is authored and reviewed. **Code repos stay pristine.** ([ADR-0050](docs/adrs/0050-swarm-is-a-spec-repo-discipline.md))

- A **spec repo** takes the **authoring kit** — the `author`/`lint`/`improve`/`review` skills, the rule cards, the templates — and holds the specs (`specs/`) and durable memory (`.agents/memory/`). Desired truth lives here, and one spec can govern **many** code repos (obligation ids are namespaced; `spec-id#AC-001` cross-references them).
- A **code repo** takes **almost nothing**: a good SOL spec is self-legible, so no reference cards and no specs go here. At most the one optional `implement-and-verify` skill, plus a `.gitignore` line so Swarm scratch never lands. The **PR** (naming the obligation ids it satisfies, with CI + review) is the trace and verdict; durable outcomes flow back to the spec repo as linked PRs.
- **Co-located** (solo / single repo) does both in one repo.

There is no `.swarm/` mount and no imposed tree: the framework version is a producer release tag, and you re-copy the starter kit to upgrade. Adoption hands the starter kit to your coding agent, which integrates the *right subset for the repo's role* under `.agents/` (the cross-tool agent directory). Nothing executes — the files are inert reference data and copyable templates.

## How to adopt

**→ [`docs/ADOPTING.md`](docs/ADOPTING.md) is the step-by-step guide** — a copy-paste prompt that hands the adoption to the coding agent you already use (or a human runs the same steps).

## The NO-RUNTIME invariant

Swarm holds five invariants in every part of the framework; the governing one is **NO RUNTIME**. The repository is documentation and the starter kit. Every "runs" verb resolves to a future-tool contract:

1. **No runtime** — markdown-only; everything that "runs" is a contract a future tool builds against, never shipped.
2. **Soft vs hard control** — prose, SOL, APS, pass guides, profiles, and `AGENTS.md` are soft guidance; anything that must hold regardless of the model needs a deterministic check *outside* the model (today that hard lane is aspirational/manual).
3. **Surface-vs-IR layering** — the human surface is UPPERCASE space-separated keywords; the IR is snake_case fields.
4. **Code is reality** — code and tests can falsify an obligation but never silently amend intent.
5. **Schema-valid is not verified** — shape is not truth; a `PASS` verdict requires a bound proof that actually ran and produced inspectable evidence, not merely a structurally valid trace [[REFLEXION]](docs/research/sources.md#REFLEXION).

The five invariants in full are in [`docs/PRINCIPLES.md`](./docs/PRINCIPLES.md).

## Where the docs live

- [`docs/language/`](./docs/language/) — the SOL and APS references, error catalogue, and versioning regime.
- [`docs/model/`](./docs/model/) — the compiler pipeline, source artifacts, source authority, and conformance.
- [`docs/passes/`](./docs/passes/) — one page per pass (`author`, `lint`, `improve`, `lower`, `decompose`, `implement`, `verify`, `review`, `promote`).
- [`docs/reference/`](./docs/reference/) — the flow graph, proof types, promotion protocol, distillation loss budget, and glossary.
- [`docs/artifacts/`](./docs/artifacts/) — the contract for each artifact (spec, task, trace, review, finding, ADR, and the source-document types).
- [`docs/library/`](./docs/library/) — pass guides, heuristic profiles, and overlays (the layers that parameterize a pass).
- [`docs/adrs/`](./docs/adrs/) — the architecture decision ledger.
- [`docs/PRINCIPLES.md`](./docs/PRINCIPLES.md) and [`docs/NON-GOALS.md`](./docs/NON-GOALS.md) — the invariants and the deliberate boundaries.
- [`starter-kit/`](./starter-kit/) — the installable files (the templates, reference cards, and skills — including the persona-* profile stances — an adopter copies into `.agents/`).

Each area is the authoritative reference for what it covers; together with the [`starter-kit/`](./starter-kit/) files, the `docs/` tree **is** Swarm. The references here are complete — there is no separate document a reader must defer to.

---

Swarm **v0.1** · language **SOL/0.1**, **APS 0.1** · the framework package is versioned independently as semver (see [`docs/language/versioning.md`](./docs/language/versioning.md)). This specification is Accepted; it is one self-contained framework.
