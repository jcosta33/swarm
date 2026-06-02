# The Pass-Output Rubrics

> Swarm's producer-side self-tests: nine per-pass quality predicates that score whether an agent-as-compiler actually *performed* a pass, plus the four cross-pass predicates the suite scores wherever the relevant artifact appears. These rubrics measure the framework's own behaviour. They are not installed into any adopted project.

Swarm is markdown-only, provider-neutral, and has **no runtime**. These rubrics are **inert scoring data**: each predicate is a boolean assertion a human reviewer (or a future eval harness) decides by reading a pass's input artifact and its output artifact, never by running a tool. Nothing here executes.

## What these rubrics are — and are not

The golden corpus pins *what a correct pipeline produces* — the expected obligations, traces, and verdicts of each fixture. The **pass-output rubrics** are the complementary half: the scoring criteria the suite runs *against a candidate pass's actual output* to decide whether the transformation was performed correctly. They exist because **schema-validity is not correctness**. A `task.md` can be perfectly well-formed and still drop an obligation; a `review.md` can carry every required `VERDICT` block and still be summary-only. The grammar checks (the `SOL-S` lint family and the task-file violation classes) already cover well-formedness; these rubrics grade *compiler behaviour* — did the transformation preserve the obligations, bindings, scopes, authorities, and verdicts it was contracted to preserve.

Each rubric is a small set of **checkable predicates**, not a Likert or quality score. A predicate either holds or it does not. The suite reports the count of failing predicates per pass, and **a single failing predicate fails the pass**. Every predicate is decidable against the pass's input artifact plus its output artifact alone — no runtime, no tool under test is presumed.

These are **producer-side self-tests**. They measure the Swarm framework's own conformance fixtures and any agent-as-compiler executing the pipeline. They are deliberately *not* part of the kernel payload an adopter installs into `.swarm/`: an adopted project gets the language reference, the pass guides, and the lint catalogue, but not these rubrics, because an adopter does not re-grade the framework. That is why these pages live under `evals/` and may freely link sibling `docs/` pages.

## The nine rubrics, one per pass

The rubrics are indexed in pipeline order. Each page states that pass's output-grading predicates (what a correct output MUST exhibit) and re-states the cross-pass predicates the suite scores at that stage.

| Pass | Phase(s) | Rubric | Grades |
| --- | --- | --- | --- |
| `author` | entry | [author.md](author.md) | source fidelity, stance, surfaced uncertainty |
| `lint` | PARSE + NORMALIZE | [lint.md](lint.md) | parse-validity decided, blocking recall, non-mutation, severity |
| `improve` | NORMALIZE | [improve.md](improve.md) | intent preserved, no distillation loss, closed op set |
| `lower` | LOWER | [lower.md](lower.md) | total obligation preservation, binding/authority survival, edge soundness |
| `decompose` | LOWER | [decompose.md](decompose.md) | write-disjoint packets, DAG order, total coverage, context |
| `implement` | EXECUTE | [implement.md](implement.md) | scope-faithful diff, obligation coverage, trace honesty |
| `verify` | VERIFY | [verify.md](verify.md) | proof-result completeness, adapter resolution, provenance |
| `review` | REVIEW | [review.md](review.md) | verdict completeness/correctness, sceptical independence, gate |
| `promote` | PROMOTE | [promote.md](promote.md) | nothing durable left task-local, provenance, stance, no spurious |

The nine passes and their phase mapping are the canonical set fixed in the [flow graph](../../docs/reference/flow-graph.md); these rubrics add no pass and remove none.

## The four cross-pass predicates

Four predicates are not owned by a single pass. The suite scores them **wherever the relevant artifact appears**, because they are the pipeline-wide correctness invariants the corpus exists to defend. Each per-pass rubric page re-states the cross-pass predicates that apply at its stage; this table is the single definition.

| Cross-pass predicate | What it asserts | Scored at the output of |
| --- | --- | --- |
| **Parse-validity** | Every emitted SOL artifact re-parses clean against the grammar; no pass emits a structurally invalid block. | `author`, `improve`, `lower`, `decompose`, `promote` |
| **Trace-completeness** | The backward chain `obligation → task → trace → verdict` is unbroken: every assigned obligation reaches a verdict, and every verdict names an obligation that exists upstream. | `decompose`, `implement`, `verify`, `review` |
| **Verdict-correctness** | Each `VERDICT` is consistent with its evidence and the 7-value verdict model (4 core + 3 lifecycle decorators); no decorator is applied without its condition, no core verdict contradicts its proof result. | `verify`, `review` |
| **Drift-detection** | The pass classifies and surfaces each drift class — stale spec drift, undocumented implementation drift, stale proof drift, and memory drift — rather than silently passing it. | `review`, `promote`; the stale-memory and unauthorized-change fixtures |

Drift-detection is defined without a runtime: drift is found by the `review` and `promote` passes comparing the approved obligation set against the recorded evidence and the higher-authority sources, never by observing a running system. A pass that fails to flag a drift class present in its fixture fails the drift-detection predicate **even if every other predicate holds**.

## How a rubric is scored (no runtime)

For a candidate pass output, a reviewer (or future harness):

1. Reads the pass's **input artifact** and its **output artifact**.
2. Evaluates each predicate on that rubric page as a boolean, citing the span that decides it.
3. Re-evaluates the cross-pass predicates listed for that stage.
4. Reports the count of failing predicates. **Any failing predicate fails the pass.**

Because every predicate is decidable from the two artifacts alone, the score is reproducible by hand today and automatable by a future harness without either trusting or running the tool under test. The held-out mutated variants in the corpus are the contamination guard: a pass that satisfies a rubric on the canonical fixture but not on its semantically equivalent mutated twin has memorized the label, not executed the transformation, and is scored a fail on that pass.

## Related references

- [The golden corpus](../../docs/reference/golden-corpus.md) — the inert fixture suite these rubrics are scored over; defines the nine rubrics and the cross-pass predicates this directory expands.
- [The flow graph](../../docs/reference/flow-graph.md) — the canonical counts (7 blocks, 5 modals, 7 verdicts, 9 proof types, 9 passes, 10 improve operations, 5 lint layers) every rubric cites.
- [The pass guides](../../docs/passes/) — the per-pass contracts each rubric grades against.
- [The lint catalogue](../../docs/language/errors.md) — every `SOL-<LAYER>NNN` code a rubric references.
- [Drift and staleness](../../docs/reference/drift-and-staleness.md) — the four staleness conditions the drift-detection cross-pass predicate scores.
