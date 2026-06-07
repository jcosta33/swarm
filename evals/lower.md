# `lower` — pass-output rubric

> The output-quality predicate for the `lower` pass: a candidate IR MUST carry every obligation as a node with its id/modality/actor/trigger/response intact, preserve every `VERIFY BY` binding and authority scope, invent no edge, and emit **no IR at all** while a blocking diagnostic or blocking `QUESTION` is unresolved. Each predicate is a boolean a reviewer decides by comparing the normalized spec against the emitted IR JSON — no runtime.

`lower` is a `LOWER`-phase pass. It projects the normalized, approved spec into the typed intermediate representation (`<domain>.swarm.ir.json`): uppercase SOL surface keywords become `snake_case` IR fields, every relationship moves into `edges[]` (the single source of relationship truth), and node ids become namespaced. Its rubric grades whether the projection is **total and faithful** — nothing dropped, nothing invented.

**Input artifact:** the normalized, approved `spec.swarm.md`.
**Output artifact:** the typed IR (`<domain>.swarm.ir.json`).

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the pass.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| W1 | **Total obligation preservation** | Every obligation appears as an IR node with its **id, modality, actor, trigger, and response** intact (an `AND THE` chain may split into `AC-NNN.1`/`AC-NNN.2`, each carrying its own predicate but sharing trigger/surface/binding). | A dropped obligation, a dropped/changed modality, or a missing actor/trigger/response — a hard fail. |
| W2 | **Binding preservation** | Every `VERIFY BY` binding survives onto its obligation node as a `verify_by[]` entry with `type`/`adapter`/`ref`/`selector`/`gate`. | A `VERIFY BY` binding is absent from the node it was attached to in the spec. |
| W3 | **Authority preserved** | Each obligation's domain/artifact authority and its `WRITES` / `READS` / `AFFECTS` scope survives into the IR (`writes[]`, the scope edges). | A write surface, read scope, or affects-edge present in the spec is missing from the IR. |
| W4 | **Halts on blocker** | The pass produces **NO IR** while any blocking diagnostic or blocking `QUESTION` is unresolved (a blocking `QUESTION` reaching `lower` is `SOL-O003`). | An IR is emitted while a blocking diagnostic or `[blocking]` `QUESTION` is still open — lowering proceeded past a gate. |
| W5 | **Edges sound** | Every dependency edge in `edges[]` derives from a `DEPENDS ON`, a shared interface, or a preserved constraint/invariant. | An edge appears with no upstream `DEPENDS ON`/shared-interface/constraint justification — an invented edge. |

### IR shape conventions a reviewer checks

- Surface keywords are lowered to `snake_case` (`VERIFY BY` → `verify_by`, `DEPENDS ON` → a `depends_on` edge); a surface keyword left uppercase in the IR, or a relationship duplicated as a node scalar instead of living in `edges[]`, is a faithfulness defect against W1/W5.
- Every node enters `lower` at `status: UNVERIFIED` (the default before any verdict exists).
- The emitted JSON MUST be valid JSON; a malformed IR fails parse-validity below.

## Cross-pass predicates scored here

The suite scores one cross-pass predicate at the `lower` output:

- **Parse-validity** — the emitted IR is valid JSON and every node round-trips against the IR schema; no node is structurally invalid.

## Related

- [The IR schema](../../docs/reference/ir-schema.md) — the node/edge shape W1–W5 and parse-validity check against.
- [The `lower` pass guide](../../docs/passes/lower.md) — the projection contract and the `edges[]` single-source-of-truth rule this rubric grades.
- [The lint catalogue](../../docs/language/errors.md) — `SOL-O003` (blocking-question-reaches-lowering), the condition W4 enforces.
