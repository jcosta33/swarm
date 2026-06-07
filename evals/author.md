# `author` — pass-output rubric

> The output-quality predicate for the `author` pass: a candidate `spec.swarm.md` correctly authored from its upstream sources MUST preserve every source span's stance, invent no behaviour, and surface every behavioral ambiguity as a block rather than burying it in prose. Each predicate below is a boolean a reviewer decides by reading the source artifacts and the authored spec — no runtime.

`author` is the entry pass: a human (or agent following the source-artifact rules) writes the first compiler-visible `spec.swarm.md` from chat, `research.md`, `audit.md`, or `bug-report.md`. It is the only stage where a `.swarm.` artifact is written directly, so its rubric grades fidelity to the upstream source, not grammar — grammar is the `lint` pass's concern.

**Input artifact:** the upstream source(s) (chat transcript, `research.md`, `audit.md`, `bug-report.md`).
**Output artifact:** `spec.swarm.md`.

## Output-grading predicates

Each predicate MUST hold. Any single failing predicate fails the pass.

| # | Predicate | Holds when | Fails when |
| --- | --- | --- | --- |
| A1 | **Source fidelity** | Every obligation in the spec traces to an upstream source span (chat, `research.md`, `audit.md`, `bug-report.md`) **or** is marked an explicit authoring decision. | An obligation asserts behaviour that appears in no source span and is not flagged as an authoring decision — behaviour is invented and presented as sourced fact. |
| A2 | **Stance preserved** | An observation-only source is re-stated as an obligation with its **own id, modality, and binding**. | An observation is borrowed verbatim as prose, or an observation silently acquires binding force without being re-stated as a typed block with its own id. |
| A3 | **Uncertainty surfaced** | Every behavioral ambiguity is lifted to a `QUESTION` block or recorded as an explicit interpretation. | A behavioral ambiguity is left buried in prose, neither raised as a `QUESTION` nor resolved as an explicit interpretation. |

### Provenance citation (fan-out fixtures)

For a fixture whose source is a `research.md` with citable spans (`R-001`, `R-002`, …), A1 is sharpened: **every derived obligation MUST cite its originating span** with the cross-file reference `research#R-NNN` in its `BECAUSE` clause, and every cited span MUST exist in the named `research.md`. A citation whose span id is absent from the named source, or whose stem names no shipped source, is a provenance failure of A1. One research source legitimately fans out into multiple `*.swarm.md` specs plus an `adr.md`; the fan-out itself is not a defect — an unresolved citation is.

## Cross-pass predicates scored here

The suite scores one cross-pass predicate at the `author` output:

- **Parse-validity** — the authored spec re-parses clean against the grammar; no block is structurally invalid. (Seeded authoring defects of the *prose/verification/semantic* layers are expected on a draft and are the `lint` pass's job to catch; a *structural* `SOL-S` malformation that prevents parsing fails parse-validity here.)

## What this rubric does not grade

- **Grammar smells** (`SOL-S`/`SOL-P`/`SOL-V` on the draft) — those are `lint`'s output, scored by [lint.md](lint.md). A draft spec is *expected* to carry seeded defects; `author` is not faulted for them.
- **Normalization** — raising `SHOULD` to `MUST`, concretizing a vague phrase, or binding a missing proof is `improve`'s job, scored by [improve.md](improve.md).

## Related

- [The golden corpus](../../docs/reference/golden-corpus.md) — the `author` predicates and the research-fanout provenance fixture this rubric draws from.
- [The `author` pass guide](../../docs/passes/author.md) — the contract this rubric grades.
- [Source artifacts](../../docs/model/source-artifacts.md) and [source authority](../../docs/model/source-authority.md) — the stance and authority rules predicates A1–A2 enforce.
