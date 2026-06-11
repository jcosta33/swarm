---
type: adr
id: adr-0068
status: accepted
created: 2026-06-11
updated: 2026-06-11
---

# ADR-0068 — Inventory and Change Plan: the transformation tier

## Context

A spec answers "what behavior should exist"; structural work — refactors, rewrites, migrations, upgrades,
performance and schema changes — needs an answer to "how does the codebase change *safely*", and brownfield
work needs a map of what exists before anyone draws new boundaries (the adopter audit's O-011: audits find
violations, but the contract map had to be reconstructed by hand). Planned, composite refactoring work is
markedly safer than ad-hoc single refactorings (external survey, lane E — EASE 2025 finding recorded in
`.agents/plans/plan-validation-survey.md` V-052; design rationale pending source promotion); mature
migration ecosystems converge on waves, before/after examples, bridge releases, rollback and cutover
guidance (React/Next codemods, OpenRewrite, Angular update guides); and the strangler-fig pattern is the
canonical shape for incremental replacement. The observable-behavior trap is Hyrum's Law: with enough
users, every observable behavior will be depended on by someone — so a change plan must *enumerate* what
it preserves rather than gesture at "no behavior change".

## Decision

1. **Change Plan** (`type: change-plan`, `id: CHANGE-*`) is a first-class artifact for structural
   transformations. Frontmatter: `title, status, kind, owner, sources[] (inventory/audit/spec/finding),
   preserves[] (SPEC-*#AC-*/C-*/I-*), created`. Kinds: refactor · rewrite · migration ·
   dependency-upgrade · performance · test-infra · mechanical-cleanup · architecture-cleanup ·
   schema-change. Sections: Intent / Why / Baseline / Target state / **Behavioral preservation
   guarantees** (table `ID | Behavior | Verify with`) / Non-goals / Affected surfaces / Risk areas /
   **Transformation waves** (each wave leaves the codebase green; name its verify step; bridge releases
   where consumers exist) / Cutover conditions / Rollback criteria / Verification strategy / Review
   focus / **Task split** (table `Task | Wave | Scope ids`). Preservation guarantees use the same one
   verification field as requirements and review consumes the same `{id, verify_ref, result}` triple;
   guarantee rows reuse the spec's own ids via `preserves[]` — a guarantee with no spec id gets `PG-NNN`
   and usually signals a spec amendment is owed. The artifact's benefit is a **convention** (no controlled
   study of the document itself exists; the rationale above is the recorded ground).
2. **Inventory** (`type: inventory`, `id: INV-*`) is the brownfield prerequisite: a reconstructive map —
   Scope / Current modules / Current interfaces (callers, observed contracts) / Observed behavior (with
   evidence) / Known risks / Existing tests / Unknowns (the Hyrum surface). It observes and maps; it never
   judges (audit) or prescribes (change plan).
3. **Both are conditionally-core:** templates ship in the kit core; the artifacts are written when the
   work is structural/brownfield and skipped otherwise. When-to-write thresholds (and the negative lists —
   no change plan for an obvious bug fix; no inventory for a single-file cleanup) are part of the
   happy-path docs: indiscriminate process measurably hurts
   [[HUMANEVALCOMM]](../research/sources.md#HUMANEVALCOMM) [[ASKORASSUME]](../research/sources.md#ASKORASSUME).
4. **Ripples:** a task's `source[]` may name a spec and/or a change plan and its Scope reads "implement or
   preserve"; the review packet carries an optional Change-plan coverage table (ADR-0060); the workspace
   gains `inventory/` and `change-plans/` folders; a change-plan wave decomposes into N tasks, each
   worktree-isolated exactly as any task (ADR-0046 unchanged).
5. **Guide lineage:** the planning halves of the per-kind implementation guides (wave planning, equivalence
   oracles, behavior-delta tables, baseline/target protocol) consolidate into the `write-change-plan`
   advanced guide; execution halves remain implementation guidance in the code-skills library.

## Alternatives considered

| Alternative | Why weaker |
|---|---|
| Spec-only, transformation expressed as requirements | Preservation guarantees, waves, rollback and cutover have no home; reviewers lose the intended-code-movement view |
| Task-kind parameterization instead of an artifact | A frontmatter enum cannot carry waves/rollback/cutover; the reviewer needs a document, not a tag |
| Always-core | Violates scale-down; most feature work needs neither |

## Consequences

Positive: refactors get the missing reviewer's map; brownfield work starts from reconstruction, not
guesswork. Negative: two more templates to maintain. Neutral: the per-kind execution disciplines survive
unchanged in the library.

## Status

Accepted. Partially supersedes the per-kind transformation-routing clauses of ADR-0029 and ADR-0042;
refines ADR-0030 and ADR-0046.

## Propagation

Templates (change-plan, inventory), docs/05, review template ripple (0060), examples (large-pr-review),
conformance fixtures, code-skills consolidation, evals.
