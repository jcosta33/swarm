---
type: adr
id: adr-0120
status: accepted
created: 2026-06-29
updated: 2026-06-29
---

# ADR-0120 — Re-baselining: reconciling when reality has drifted from the artifacts

## Context

Adopters and agents make changes without writing artifacts — a hotfix, a fast
iteration, a design tweak shipped straight to the code. Over time the specs no
longer describe what was built: requirements reality outran, acceptance criteria
that no longer hold, whole features with no spec. The artifacts and the code
disagree.

Corpus has the pieces to recover but never named the procedure. Inventory maps
current code ([ADR-0068](./0068-inventory-and-change-plan.md)). Specs are living
and support supersession ([ADR-0103](./0103-spec-as-living-form-task-on-demand.md),
[ADR-0108](./0108-living-specs.md)). The harness is reconcile-only — it surfaces
drift, it never blocks ([ADR-0077](./0077-corpus-cli-reconcile-only-harness.md)).
The staleness signals catch the mechanical cases — a stale review packet
([ADR-0107](./0107-fast-track-staleness-detection.md)), status/spec incoherence
([ADR-0116](./0116-shipped-spec-invariant.md)). What was missing is the answer to
"the code drifted from the spec — now what?"

## Decision

**Drift is expected, not a failure. When reality and the artifacts disagree, you
re-baseline: trust the code, reconcile the specs to it, and record the gap.**
Corpus never punishes the drift — it gives a procedure to make the artifacts true
again. The re-baseline pass, when you notice the mismatch (or a coherence check
flags it):

1. **Inventory the current reality** ([ADR-0068](./0068-inventory-and-change-plan.md)).
   Map what the code actually is now, with evidence. Read the code, not the stale
   spec.
2. **Audit the gap.** Record what drifted — which specs reality outran, which
   acceptance criteria no longer hold, what shipped with no spec. Observation
   only: severity and evidence, no prescriptions.
3. **Re-baseline the specs.** For each drifted requirement: if the change was
   intended, revise the spec or its `AC` to match what was built, or mark the
   spec `superseded`; if reality is wrong, that is a finding, not a re-baseline.
   The spec is intent — reconciliation makes it describe what is true.
4. **Record the drift as a finding.** The durable lesson — that changes landed
   without artifacts, and what to watch — so the gap is a recorded reconciliation,
   not a silent reset.
5. **Update the board** to the re-baselined state.

The honest scope: Corpus does not auto-detect semantic code-vs-spec drift — that
is review and human judgment. The mechanical cases (a stale evidence hash, a
status/spec mismatch) are flagged by the existing signals; the rest is a
triggered, human-run reconciliation. _Level: convention._

## Consequences

- The brownfield doc gains a re-baseline note: Inventory → Audit → re-baseline the
  specs → record the finding is the recovery path when reality has drifted.
- Re-baselining is the same machinery as adoption into an existing codebase
  (Inventory first), pointed at a workspace whose own specs went stale.
- It stays reconcile-only: the procedure recovers truth; it never gates the work
  that caused the drift.

## Status

Accepted. Extends [ADR-0068](./0068-inventory-and-change-plan.md) and the living
specs ([ADR-0103](./0103-spec-as-living-form-task-on-demand.md),
[ADR-0108](./0108-living-specs.md)); relates
[ADR-0096](./0096-artifact-lifecycle.md),
[ADR-0116](./0116-shipped-spec-invariant.md).
