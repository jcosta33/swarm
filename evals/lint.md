# `lint` — pass-output rubric

> The output-quality predicate for the `lint` pass: a candidate lint report over a known-defective fixture MUST report every seeded defect with its correct `SOL-<LAYER>NNN` code, span, and severity; MUST detect every blocking defect; and MUST leave the spec text byte-identical. Each predicate is a boolean a reviewer decides by comparing the fixture's pinned diagnostics against the candidate report — no runtime.

`lint` is the `PARSE` + `NORMALIZE`-phase pass — the only pass that straddles two phases (well-formedness plus smell detection). It is **non-mutating**: it emits diagnostics in the unified `SOL-<LAYER>NNN` namespace and changes not one character of the spec. Its rubric grades whether the diagnostic set is *complete and correct against the fixture's pinned expected diagnostics*, not whether the spec is clean.

**Input artifact:** a `spec.swarm.md` carrying pinned expected diagnostics (in its fixture header / `EXPECTED.md`).
**Output artifact:** the lint report (SARIF-shaped diagnostic records).

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the pass.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| L1 | **Parse-validity decided** | Every `SOL-S###` defect pinned in the fixture is reported with its **correct code and span**; a known-defective fixture is never reported clean. | A pinned `SOL-S###` defect is missed, reported with the wrong code, or the fixture is reported "clean" while a seeded defect remains — a false negative. |
| L2 | **Blocking recall complete** | Every **blocking** defect — `SOL-S`, `SOL-M`, `SOL-V`, and every blocking `SOL-P` — pinned in the fixture is detected. | Any blocking diagnostic the fixture pins is absent from the report. |
| L3 | **Non-mutating** | The spec text and semantics in the report's view are **byte-identical** to the input; `lint` reports, never rewrites. | The report alters, reorders, or normalizes any spec text — lint has overstepped into `improve`. |
| L4 | **Severity-correct** | Each diagnostic's `severity` (`BLOCKING`/`ADVISORY`) matches the [lint catalogue](../../docs/language/errors.md) entry for its code. | A diagnostic's severity disagrees with the catalogue (e.g. a catalogued-BLOCKING code emitted ADVISORY). |

### Blocking-QUESTION note

Beyond the coded diagnostics, `lint` MUST record the blocking-`QUESTION` risk as a note: a `[blocking]` `QUESTION` that `AFFECTS` an obligation gates that obligation out of `lower` until resolved. A blocking `QUESTION` that *does* reach `lower` is the hard error `SOL-O003`. A report that omits this note when the fixture carries an open blocking `QUESTION` fails L2 (it is the recall of a blocking condition).

## Precision caveat for the heuristic `SOL-P` family

The deterministic `SOL-S` family is decided exactly. The heuristic `SOL-P` family carries a measurable false-positive risk and is scored against the labeled prose corpus (`fixtures/prose/labels.yaml`) at the design bars **precision ≥ 0.90, recall ≥ 0.85**, with an inter-annotator agreement floor of Cohen's κ ≥ 0.6. A `SOL-P` flag on a span the labels mark `good` is a precision failure; a missed span the labels mark `bad` is a recall failure. Single-judge `SOL-P` scores are not internally reliable and should be replicated or aggregated. The `SOL-S` family is exempt from this caveat.

## Cross-pass predicates scored here

None of the four cross-pass predicates are scored at the `lint` output: `lint` emits no SOL artifact (parse-validity is scored on the artifact-emitting passes), reaches no verdict, and detects no drift. Its rubric is fully covered by L1–L4 above.

## Related

- [The lint catalogue](../../docs/language/errors.md) — the `{code, severity, layer, span, message, suggest}` record shape and the catalogued severity L4 checks against.
- [The `lint` pass guide](../../docs/passes/lint.md) — the non-mutation contract L3 enforces.
- [The golden corpus](../../docs/reference/golden-corpus.md) — the per-domain seeded defects and the labeled prose corpus this rubric is scored over.
