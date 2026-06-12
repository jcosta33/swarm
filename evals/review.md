# Review — step rubric

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bar for the Review step: every scoped requirement has a coverage row, every result matches
> its evidence, every exception is routed to a human, the suggested decision follows the table,
> and the reviewer spot-checked at least one green row. Each predicate is a boolean a scorer
> decides by comparing the spec, the diff, and the run record against the review packet.

Review is the wedge: it turns a large diff into requirement coverage, evidence, and a short list
of what needs human attention. This rubric grades whether the packet earns that trust.

**Input artifact:** the source spec (the scoped requirements), the diff or PR, and the run
summary with its pasted output.
**Output artifact:** the review packet ([template](../starter-kit/templates/review.md)).

## Predicates

Each predicate must hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
|---|---|---|---|
| V1 | **Coverage complete** | Every requirement in the task's scope has a row in the coverage table — plus one row per preservation guarantee when the task executes a change plan. | A scoped requirement has no row; it can neither pass nor route to a human. |
| V2 | **Empty evidence means Unverified** | Every Pass row carries pasted output or a CI link; a row with an empty Evidence cell is recorded Unverified, never Pass. | A Pass stands on no evidence — "tests passed" with nothing under it is not evidence [[REFLEXION]](../docs/research/sources.md#REFLEXION). |
| V3 | **Exceptions routed** | Every exception trigger present in the work has a Human attention entry — the trigger list is in the review template, from unverified requirements through out-of-scope changes to blocked questions. | A triggering condition exists in the inputs (an Unverified row, an undeclared edit, a risky file) with no entry routing it. |
| V4 | **Gate honest** | The packet's status and Suggested decision follow the table: no merge suggestion while any row shows Fail, or Unverified without a routed exception. | The decision contradicts the table — asserted past a Fail or an unrouted Unverified. |
| V5 | **Spot-check recorded** | The reviewer re-checked at least one green row's evidence and the packet says so. | No spot-check is recorded — the table was rubber-stamped. |

## Notes for the scorer

- Independence is the spine of V2–V4: results are judged against the spec, the diff, and the
  pasted evidence — never against the run summary's self-assessment alone. Reviewers favor
  their own and agent output without structure
  [[SELFPREFER]](../docs/research/sources.md#SELFPREFER)
  [[JUDGEBIAS]](../docs/research/sources.md#JUDGEBIAS); V5 is the standing countermeasure.
- A Blocked row is honest, not a defect: the check could not run. What V4 forbids is treating
  Blocked as Pass. Teams running the full lifecycle also apply the extended result values here —
  scored by [advanced-lifecycle.md](advanced-lifecycle.md).
- Drafting the packet and computing the gate is toolable — a future `swarm review` in swarm-cli;
  until then every predicate on this page is a checklist a scorer reads by hand.

## Cross-step predicates scored here

- **Chain unbroken** — every scoped requirement reaches a row (V1 is its expression here), and
  every row names a requirement that exists upstream.
- **Result consistent with evidence** — V2 and V4 are its expressions here.
- **Drift surfaced** — a requirement the code no longer matches, or behavior the spec never
  asked for, is named in a row or a Human attention entry — never silently re-blessed.
- **Re-parses clean** — the packet reads as `type: review` with the template's frontmatter and
  sections, and every coverage row carries a result from the four-value enum.

## Not graded here

Whether findings were saved and the board updated — that is the Close step, scored by
[close.md](close.md).

## Related

- [Review template](../starter-kit/templates/review.md) — the frozen format and the exception-trigger list.
- [Reviewing output](../docs/08-reviewing-output.md) — the guide for the step under test.
- [Advanced-lifecycle rubrics](advanced-lifecycle.md) — the extended result model and merge gate for high-risk work.
