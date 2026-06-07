# `promote` — step-output rubric

> The output-quality predicate for the `promote` step: a candidate set of promoted artifacts MUST leave nothing durable task-local, carry full provenance on each promoted item, route promotion through source authority (an observation promotes into intent only by explicit re-statement), and promote no task-local execution chatter. Each predicate is a boolean a reviewer decides by comparing the task's discoveries against the emitted `finding.md`/`adr.md`/amendment/`memory/INDEX.md` entries — no runtime.

`promote` is the `PROMOTE`-phase step. It moves durable discoveries out of task-local state into provenance-anchored artifacts. Its rubric grades whether **every durable discovery survives the task** with **complete provenance** and **correct authority routing**, and whether **only** durable discoveries are promoted.

**Input artifact:** the task's discoveries (trace, review, transcript) + the existing artifact set.
**Output artifact:** the promoted `finding.md` / `adr.md` / `audit.md` / spec amendment / `memory/INDEX.md` entry.

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| P1 | **Nothing durable left task-local** | Every discovery that outlives the task is promoted to a `finding.md` / `adr.md` / `audit.md` / spec amendment / `memory/INDEX.md` entry. | A durable fact (a finding, a decision, an invariant violation) is left only in the transcript or task-local state. |
| P2 | **Provenance complete** | Each promoted artifact carries its mandatory provenance — source pass, evidence (`origin_obligations[]`/`origin_traces[]`), and applicability (`applies when` / `does not apply when`). | A promoted artifact omits a mandatory provenance field. |
| P3 | **Stance & authority honored** | Promotion routes through source authority — an observation promotes into intent by **explicit re-statement** (acquiring its own id/modality/binding), never by silently outranking an approved spec. | An observation is folded into intent silently, or a promotion overrides an approved spec/ADR without going through amendment. |
| P4 | **No spurious promotion** | Task-local execution chatter (scratch notes, transient debugging, one-off command output) is **not** promoted. | Ephemeral task-local chatter is promoted as if durable, polluting the durable artifact set. |

### Provenance and routing checks a reviewer applies

- For P2, a promoted `finding.md` MUST carry `origin_obligations`, `origin_traces`, the `pass`/`profile` that produced it, the reviewer-or-tool, a `content_hash`, a `confidence`, and `applies when` / `does not apply when` bounds. A memory `MAP` line MUST carry a "Load when" condition and point at the finding — no procedure inlined, the index staying a thin router.
- For P3, a reviewer checks the direction of authority: a finding or observation that *contradicts* an approved obligation is **memory drift** and MUST be surfaced for reconcile, not promoted as if it outranks the spec. Promotion into intent is legitimate only as an explicit re-statement through amendment.

## Cross-step predicates scored here

The suite scores two cross-step predicates at the `promote` output:

- **Parse-validity** — every emitted SOL-bearing artifact (a spec amendment, an `adr.md` constraint) re-parses clean; no promotion emits a structurally invalid block.
- **Drift-detection** — promote classifies and surfaces **memory drift** (a memory item contradicted by a higher-authority source) rather than silently promoting or silently passing it. A memory-drift condition present in the fixture but unflagged fails this predicate even if P1–P4 all hold; this is the predicate the stale-memory fixture guards.

## Related

- [The promotion protocol](../docs/reference/promotion-protocol.md) — the routing rules (P1/P3) and the mandatory provenance fields (P2) this rubric grades.
- [Source authority](../docs/model/source-authority.md) — the stance/authority order P3 enforces.
- [Drift and staleness](../docs/reference/drift-and-staleness.md) — the memory-drift condition the drift-detection predicate scores here.
