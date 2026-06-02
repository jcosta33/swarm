# `implement` — pass-output rubric

> The output-quality predicate for the `implement` pass: a candidate change MUST touch only files inside the task's declared write surface, record an `IMPLEMENTS` claim for every assigned obligation and a `PRESERVES` claim for every preserved invariant, name changed files and a `PROOF` artifact per claim, and never assert an obligation done with no evidence gathered. Each predicate is a boolean a reviewer decides by comparing the task packet, the diff, and the emitted trace — no runtime.

`implement` is the `EXECUTE`-phase pass. It produces the change for the task's assigned obligations only and records `TRACE` claims. Its rubric grades whether the change stayed **inside scope** and whether the trace is an **honest** record of what was built and proven.

**Input artifact:** the `task.md` work packet + the diff it produced.
**Output artifact:** the `trace.md` (the `TRACE` block and its claims).

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the pass.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| M1 | **Scope-faithful** | The diff changes only files inside the task's declared `WRITES` surface. | A diff hunk touches a path outside the task's `write_surfaces` — an out-of-scope edit. |
| M2 | **Obligation coverage** | The trace records an `IMPLEMENTS` claim for **every** assigned obligation and a `PRESERVES` claim for **every** preserved constraint/invariant. | An assigned obligation has no `IMPLEMENTS` claim, or a preserved invariant has no `PRESERVES` claim. |
| M3 | **Trace honesty** | Each claim names the **changed files** and a `PROOF` artifact, and the claimed `CHANGED` scope is **not narrower** than the diff actually touches. | A claim cites no proof artifact, omits changed files, or the `CHANGED` set understates what the diff modified (a hidden edit). |
| M4 | **No premature completion** | The trace asserts an obligation implemented only where evidence has been gathered (a `PROOF` line exists for it). | The trace asserts an obligation done with no proof gathered — a hallucinated completion. |

### Scope check a reviewer applies

For M1, take the set of files in the diff and subtract the task's `write_surfaces`; a non-empty remainder is an out-of-scope edit. For M3, take the set of files in the diff and subtract the trace's `CHANGED` set; a non-empty remainder is an under-declared scope (a hidden edit), which is the dangerous direction — the implementer claiming a smaller footprint than reality.

## Cross-pass predicates scored here

The suite scores one cross-pass predicate at the `implement` output:

- **Trace-completeness** — the trace continues the backward chain `obligation → task → trace`: every assigned obligation reaches an `IMPLEMENTS`/`PRESERVES` claim (the forward half, M2), and every claim names an obligation that exists in the task packet (no claim invents an obligation id). A trace that claims an obligation absent from the packet breaks the chain.

## Related

- [The `implement` pass guide](../../docs/passes/implement.md) — the `TRACE` claim contract (`IMPLEMENTS`/`PRESERVES`/`CHANGED`/`PROOF`) this rubric grades.
- [Drift and staleness](../../docs/reference/drift-and-staleness.md) — the trace-provenance schema (`source_hash`, `per_surface_hash[]`) the claims feed, which later detects staleness.
- [The golden corpus](../../docs/reference/golden-corpus.md) — the empty-paste / no-evidence fixture class M4 guards against.
