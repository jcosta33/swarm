---
type: adr
id: 0055-close-the-gate-soft-control-gaps
status: accepted
created: 2026-06-07
updated: 2026-06-07
supersedes:
superseded_by:
---

# ADR-0055: Close the gate's soft-control gaps (empty-set coverage, adequacy gating for high-RISK, uncovered-bug amendment)

## Context

The 10-aspect simulation audit ([`.agents/audits/critical-review-aspects.md`](../../.agents/audits/critical-review-aspects.md))
— five developer-journey simulations read against the actual repo, validated firsthand — surfaced three places
where the merge gate's **default** behavior is weaker than the framework's deepest claim, all fixable in the
contract layer with **no runtime**:

- **#4 — empty-set edge.** The gate quantifies over "every **required** obligation in scope." A change whose
  behavior **no obligation covers** yields an **empty in-scope set**, so the universal is **vacuously true** and
  an uncovered change ships "verified" with no contract and no proof.
- **#3 — adequacy advisory by default.** [`verify` §6.2](../passes/verify.md) says a `RISK high|critical`
  obligation demands a stronger oracle than a bare example — yet `SOL-V011` was advisory-by-default and the
  **gate predicate ignored adequacy entirely**, so a high-consequence obligation could clear the gate on a green
  `test` the author self-reported adequate. "Schema is not verification" was a claim the default did not enforce.
- **#8 — uncovered-bug seam.** A `bug-report` records "no existing obligation covers the broken behavior" as a
  gap "the fix task must reconcile" ([`bug-report.md`](../artifacts/bug-report.md)), but the reconciliation
  *mechanism* was under-specified — which is exactly the empty-set case (#4) on the fix-task path.

These are soft-control gaps (Invariant 1: NO RUNTIME — every gate here is manual-today, a contract a future
harness enforces). The fix sharpens **what the contract says**, not what is shipped.

## Decision

1. **An empty in-scope set does not pass by vacuity.** ([`review` merge gate](../passes/review.md)) A change set
   whose in-scope required-obligation set is empty **MUST NOT** be promoted on the vacuous-truth of the
   universal. An edit no obligation covers is an **uncovered change**: it `BLOCK`s the gate until either a spec
   amendment authors the covering obligation, the edit is reverted, or it is recorded as an allowed entry in
   `review.md`'s `## Unauthorized changes` table with a reason. The gate's universal-over-obligations is
   conjoined with this **non-vacuity floor**.

2. **Oracle adequacy is gating for `RISK high|critical`.** ([`verify` §6.2](../passes/verify.md) +
   [`review`](../passes/review.md)) For a `RISK high|critical` obligation, an **inadequate oracle** — a bare
   concrete `test` with no `mutation`/`metamorphic` adequacy evidence — is `SOL-V011` **BLOCKING**, not advisory.
   Adequacy stays **advisory for `RISK low|medium`** (strict mode extends blocking to them). The gate predicate
   therefore consults adequacy **for high-consequence obligations**, closing the "deepest-claim vs default" gap
   exactly where the cost of a missed defect is highest, without forcing mutation/metamorphic evidence onto
   trivial obligations.

3. **An uncovered bug forces a spec amendment before its fix clears the gate.**
   ([`bug-report.md`](../artifacts/bug-report.md) + [`author`](../passes/author.md)) The **fix task** a
   `bug-report` promotes into takes its `assigned_obligations` from the report's `## Affected obligations` (the
   existing violated obligation). Where that section records "no obligation covers this," the fix task's **first
   obligation is the spec amendment** authoring the covering obligation — which is what makes the empty-set case
   (decision 1) resolvable on the fix path rather than a silent pass.

Two **accompanying single-source reconciliations** ride in this change but carry **no normative force** (no ADR
of their own needed): `SOL-M001` is aligned to its canonical broad definition (#7), and the hash-bearing
provenance fields are marked **by-hand placeholders** (#5) — both described under *Consequences*.

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| Leave adequacy fully advisory (status quo) | Makes "schema is not verification" a slogan the default contradicts exactly where consequence is highest — the audit's #3. |
| Make adequacy blocking for **all** `RISK` levels | Forces mutation/metamorphic evidence onto trivial obligations. The graduated design (advisory `low|medium`, blocking `high|critical`, strict-mode extends) matches oracle cost to consequence. |
| Treat an uncovered change as a silent pass / reviewer discretion | That **is** the vacuity hole (#4). A coverage gap must be visible and gate-blocking, not left to whether a reviewer happens to notice an empty set. |
| Record the seam in a new artifact / role | Out of scope and against ADR-0053 (adds no artifacts/roles/runtime). The fix reuses `SOL-V011`, the existing amendment path, and the `## Unauthorized changes` table. |

## Consequences

- **Positive:** the gate's **default** now matches the framework's deepest claim where it matters most
  (high-RISK obligations, uncovered changes); the empty-set hole is closed; the bug-fix path can no longer ship
  an uncovered change by vacuity. No new artifacts, dirs, roles, or runtime — it refines an existing predicate
  and reuses `SOL-V011`.
- **Negative:** a `RISK high|critical` obligation now needs recorded adequacy evidence to clear the gate **by
  default** (previously strict-mode only) — slightly more work, on exactly the obligations that warrant it.
- **Neutral / accompanying reconciliations (no normative change):**
  - **`SOL-M001` (#7):** [`SOL.md`](../language/SOL.md)'s error-table row is aligned to the **canonical**
    definition in [`errors.md`](../language/errors.md) / [`lint.md`](../passes/lint.md) — *actor/object/surface
    incompleteness, which also catches cross-spec id collision* — removing the dual definition. No code added;
    the closed set is unchanged.
  - **Uncomputable hashes (#5):** `content_hash` / `per_surface_hash[]` / `source_hash` are **tool-emitted**;
    under NO RUNTIME a by-hand author records a **documented placeholder** (not a fabricated digest), and a
    hand-recorded hash is **untrusted** until a tool recomputes it — the same honesty already applied to
    `tool_version: null`. The drift comparator remains a future-tool contract.
- **No closed-set change:** still 7 verdicts, 5 lint layers, 9 proof types, 9 steps, …; `SOL-V011` already
  existed; the gate predicate is refined, not replaced.

## Status

Accepted (v0.1). The `review` gate edits, the `verify` §6.2 high|critical-blocking edit, the `bug-report`/`author`
seam edit, and the two accompanying reconciliations are this change.

## Affected obligations / constraints

- **Refines:** [0053](./0053-structured-spec-and-review-system.md) (review-as-exceptions is the merge-gate
  payoff), [0043](./0043-checkable-documents.md) (checkable documents; lint stays spec-only).
- **Grounded by:** the 10-aspect simulation audit (this session), aspects #3 / #4 / #8; oracle inadequacy is
  measured, not hypothetical — [[SWEBENCH-ADQ]](../research/sources.md#SWEBENCH-ADQ) (7.8% of suite-passing
  patches are wrong) and [[UTBOOST]](../research/sources.md#UTBOOST) (40.9% of SWE-bench Lite entries mislabeled
  passing).
- **Changes:** the [`review`](../passes/review.md) merge-gate predicate (non-vacuity floor + adequacy-for-high-RISK);
  [`verify` §6.2](../passes/verify.md) (high|critical adequacy BLOCKING); [`bug-report.md`](../artifacts/bug-report.md)
  + [`author`](../passes/author.md) (uncovered-bug → amendment seam). Accompanying: [`SOL.md`](../language/SOL.md)
  `SOL-M001` row; the hash-field contracts in [`trace.md`](../artifacts/trace.md), [`lower.md`](../passes/lower.md),
  [`structured-form.md`](../reference/structured-form.md).
- **Does NOT change:** any closed set, the SOL grammar, the nine steps, the verdict model, or the artifact set.
