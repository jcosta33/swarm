---
type: adr
id: adr-0110
status: accepted
created: 2026-06-26
updated: 2026-06-26
---

# ADR-0110 — The `## Execution` entry is a structured change-record (a durable evidence digest)

## Context

[ADR-0103](./0103-spec-as-living-form-task-on-demand.md) made the spec's append-only `## Execution`
section the run record; [ADR-0104](./0104-ephemeral-by-default.md) made tasks/reviews ephemeral. The
gap that left: when the review evaporates, the **requirement→evidence linkage** it carried is lost — the
durable residue in `## Execution` was free prose, not a structured map. An external proposal (the
Lean-Corpus disposition, corpus-works DEC-0004) over-reached to *committed per-change evidence files*,
but its one legitimate point holds: the digest is small, durable, and worth keeping. [ADR-0107](./0107-fast-track-staleness-detection.md)
already pins a `reviewed_sha` + `evidence_hash` on the review packet; this carries that residue **into
the living spec at close**, so it survives the ephemeral review.

## Decision

**Each `## Execution` change-cycle entry MAY be a structured change-record, not just prose.** The section
stays append-only (ADR-0103). A structured entry carries, beneath its dated heading:

- **Scope** — the ACs (and/or areas) this change-cycle touched / added / superseded.
- **Coverage** — the AC→evidence digest: each in-scope AC mapped to the evidence that closed it (a test
  pass, a CI link, a named check). The compact, durable form of the review's coverage table.
- **Pins** — `reviewed-sha:` (the code SHA reviewed) + `evidence-hash:` (the ADR-0107 digest over the
  diff + cited evidence). Written by `corpus stamp` at close.

This is **additive and not a frozen contract section** — it amends nothing in the freeze-at-`ready`
block; a spec with a prose Execution entry stays valid (legacy + 1:1-simple work is not forced into the
structured form).

**Tooling — toolable, 0-FP by construction.** A reconcile **advisory** flags an *incomplete* digest: an
Execution entry carrying one pin (`reviewed-sha:` or `evidence-hash:`) but not the other, or a malformed
coverage line. An entry with **no** digest is not flagged (legacy/simple is allowed); an entry with a
**complete** digest passes. Warns, never blocks; no `checks.yaml` rule, no contract bump (ADR-0063).

## Consequences

- The requirement→evidence map + the reviewed SHA survive the ephemeral review — closing the
  audit-trail hole ADR-0104 opened, without committing a per-change `evidence/` tree (no reversal of
  ephemeral-by-default; no new artifact class).
- Reuses ADR-0107's pins + the `Stale` marker — `corpus check --staleness` already flips a review on
  SHA/hash drift; the same pins now live in the spec's Execution.
- `corpus show spec` already surfaces `## Execution` raw (showArtifact `section_body`); the advisory
  rides that parse + the existing pin fields — no new plumbing.
- **Migration tail:** pre-existing prose Execution entries stay valid; the structured form is adopted
  going forward (stamp on the next amendment). Not a bulk rewrite.

## Affected obligations / constraints

- **Refines:** [ADR-0103](./0103-spec-as-living-form-task-on-demand.md) (the `## Execution` record),
  [ADR-0108](./0108-living-specs.md) (the living-spec change history). **Extends:**
  [ADR-0107](./0107-fast-track-staleness-detection.md) (the SHA + evidence-hash pins, now summarized
  into the spec at close).
- **Does NOT change:** the contract sections' freeze-at-`ready`, the verdict model, or the checks
  contract (no `checks.yaml` rule; the advisory is reconcile-only, ADR-0077).
