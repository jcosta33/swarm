# `decompose` — step-output rubric

> The output-quality predicate for the `decompose` step: a candidate task partition MUST give parallel packets pairwise-disjoint write surfaces, respect the obligation DAG with no cycle, assign every lowered obligation to exactly one task, keep each task's owned set ⊆ its declared writes, and carry each obligation's exact blocks rather than paraphrases. Each predicate is a boolean a reviewer decides by comparing the structured form against the emitted `task.md` packets — no runtime.

`decompose` is a `LOWER`-phase step. It partitions the obligations into write-disjoint work packets (`task.md`), consuming the structured form — not the surface prose. Its rubric grades whether the partition is **safe to parallelize, total, and context-complete**.

**Input artifact:** the typed structured form (`<domain>.swarm.ir.json`).
**Output artifact:** the set of `task.md` work packets.

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| D1 | **Write-disjoint packets** | Tasks placed in the same `parallel_group` have **pairwise-disjoint** `write_surfaces`. | Two parallel tasks share a write surface with no serializing `DEPENDS ON` — `SOL-O001`. |
| D2 | **Dependency-ordered** | The partition respects the obligation DAG (a task's `blocked_by` covers every upstream dependency) and contains **no cycle**. | A task runs before an obligation it depends on, or the dependency graph contains a cycle. |
| D3 | **Total coverage** | Every lowered obligation is assigned to **exactly one** task — no obligation dropped, none assigned twice. | A lowered obligation appears in no task's `assigned_obligations`, or in more than one. |
| D4 | **Ownership ⊆ writes** | Each task's `OWNED` set is a subset of its declared `WRITES` surface. | A task owns a path outside its declared write surface — `SOL-O005`. |
| D5 | **Context complete** | Each `task.md` carries its **exact** assigned obligation blocks, preserved constraints/invariants, and verification bindings — not paraphrases. | A task paraphrases an obligation, omits a preserved invariant, or drops a verification binding it is responsible for. |

### Disjointness check a reviewer applies

For each `parallel_group`, take the union-intersection of member tasks' `write_surfaces`: any non-empty pairwise intersection without a serializing `DEPENDS ON` edge fails D1. The safe-parallelism predicate is: *write surfaces planned to run in parallel must be pairwise disjoint, or serialized by an explicit dependency edge.* Giving two obligations disjoint surfaces, **or** a `DEPENDS ON` edge serializing them, both satisfy D1.

## Cross-step predicates scored here

The suite scores two cross-step predicates at the `decompose` output:

- **Parse-validity** — every emitted `task.md` frontmatter and obligation block re-parses clean; no packet is structurally invalid.
- **Trace-completeness** — the partition opens the backward chain correctly: every assigned obligation in a packet names an obligation that exists in the upstream structured form, and the union of all packets' assignments equals the lowered obligation set (the forward half of `obligation → task`). D3 is the decompose-stage expression of trace-completeness.

## Related

- [The `decompose` step guide](../docs/passes/decompose.md) — the two-tier lowering rule (D4), the write-disjointness predicate (D1), and the packet-frame contract this rubric grades.
- [The lint catalogue](../docs/language/errors.md) — `SOL-O001` (shared-write-surface-planned-parallel) and `SOL-O005` (owned-path-outside-write-surface), the codes D1 and D4 cite.
- [The structured-form schema](../docs/reference/structured-form.md) — the obligation DAG and scope fields D2/D3/D5 are decided against.
