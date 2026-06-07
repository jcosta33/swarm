# `verify` — pass-output rubric

> The output-quality predicate for the `verify` pass: a candidate verification record MUST give every required `VERIFY BY` binding exactly one core verdict, report no completion claim on a binding that resolved to no proof artifact, resolve each adapter through `AGENTS.md > Commands` (an unresolved adapter is `SOL-V002` → `BLOCKED`, never a silent `PASS`), and cite the proof type and artifact for each verdict. Each predicate is a boolean a reviewer decides by comparing the obligations' bindings against the recorded verdicts — no runtime.

`verify` is the `VERIFY`-phase pass and the only profile-independent pass: one verdict per `VERIFY BY` binding. Its rubric grades whether **every required binding got a real verdict backed by a real artifact**, with no binding silently passed.

**Input artifact:** the obligations and their `VERIFY BY` bindings + the `trace.md`.
**Output artifact:** the verification record (per-binding verdicts and provenance).

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the pass.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| V1 | **Proof-result completeness** | Every required `VERIFY BY` binding has **exactly one** core verdict — `PASS`, `FAIL`, `BLOCKED`, or `UNVERIFIED`. | A required binding has no verdict (`SOL-V008`) or carries more than one core verdict. |
| V2 | **No unverifiable completion claim** | No obligation is reported satisfied on a binding that resolved to **no proof artifact**. | An obligation is marked satisfied while its binding produced no artifact — a completion claim with nothing under it. |
| V3 | **Adapter-resolved** | Each binding's adapter resolved through `AGENTS.md > Commands` to a real command. | An unresolved adapter yields a silent `PASS` instead of `BLOCKED` (`SOL-V002`). |
| V4 | **Provenance recorded** | Each verdict cites the **proof type** and the **artifact** it ran, with the seven provenance fields (`source_hash`, `per_surface_hash[]`, `adapter`, `verdict`, `tier`, `origin_obligations[]`, `origin_traces[]`). | A verdict omits the proof type, the artifact, or the provenance the drift join later depends on. |

### Adapter-resolution and tier checks a reviewer applies

- For V3, each binding's `<adapter>` (e.g. `cmdTest`) MUST appear as a `Commands` slot in `AGENTS.md` whose entry resolves the binding's proof `<type>`. An adapter naming no `Commands` slot is `SOL-V002` (proof-not-executable) and resolves to `BLOCKED` — recording `PASS` instead is the failure.
- For V4, the provenance `tier` is the proof **type** (one of the nine: `static`/`test`/`contract`/`property`/`model`/`perf`/`security`/`manual`/`monitor`), never a `RISK` value. A `tier` carrying a risk level is a provenance defect.
- A `manual` proof MUST still carry a `REASON` and an `EVIDENCE` ref; a bare `manual: PASS` with no reason fails V2/V4.

## Cross-pass predicates scored here

The suite scores two cross-pass predicates at the `verify` output:

- **Trace-completeness** — every assigned obligation's binding reaches a verdict (the `trace → verdict` link), and every verdict names a binding/obligation that exists upstream.
- **Verdict-correctness** — each verdict is consistent with its proof result against the 7-value model: a `PASS` requires a passing proof artifact, a `FAIL` a failing one, a `BLOCKED`/`UNVERIFIED` an absent or unresolved proof. No core verdict contradicts its recorded proof result.

## Related

- [Proof types and the `VERIFY BY` binding](../../docs/reference/proof-types.md) — the nine proof types and the `VERIFY BY <type>:<adapter>:<artifact>` grammar V1/V3/V4 check against.
- [The `verify` pass guide](../../docs/passes/verify.md) — the one-verdict-per-binding contract this rubric grades.
- [The lint catalogue](../../docs/language/errors.md) — `SOL-V008` (required binding with no verdict), the code V1 cites.
- [Drift and staleness](../../docs/reference/drift-and-staleness.md) — the seven provenance fields V4 records, which feed the later drift join.
