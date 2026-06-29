---
type: adr
id: adr-0119
status: accepted
created: 2026-06-29
updated: 2026-06-29
---

# ADR-0119 — Independent review is the invariant; the formal review is risk-weighted

## Context

The loop marks intake (Pull) and the task packet (Task) as optional formalities, but "Review"
read as one mandatory station. That conflates two things: the *act* of an independent party
judging the work, and the *formal review artifacts* — a `reviews/` packet, a review lead
running independent lenses ([ADR-0086](./0086-deterministic-review-scanning-decision.md)).
Requiring the artifacts on every change adds ceremony to a trivial one
([ADR-0105](./0105-stretch-and-collapse.md)) and overstates risk-weighted review
([ADR-0094](./0094-decomposition-and-risk-weighted-review.md)), which scales scrutiny and only
forbids skipping review on a large or high-diffusion change.

## Decision

Independent review is the invariant; the formal review is the formality that scales.

- **Invariant — never skipped for code-changing work.** The implementer does not render the
  verdict; a non-implementer judges the result against its intent, on evidence
  ([ADR-0056](./0056-adversarial-self-review-completion-discipline.md),
  [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) D8). For a trivial change the owner
  verifies directly, the owner is that non-implementer.
- **Optional — risk-weighted.** The formal review artifacts (a `reviews/` packet, a review
  lead orchestrating independent lenses) are the form for a substantial or high-diffusion
  change, not a requirement for a trivial, low-diffusion one whose owner has verified it.
  "Small" never excuses skipping review on a large or high-diffusion change (the Hindle
  caveat, [ADR-0094](./0094-decomposition-and-risk-weighted-review.md)).

The loop's optional formalities are therefore Pull, Task, and the formal Review; the spine is
Spec, Run, Close. The no-self-certify floor holds throughout.

_Level: convention._

## Consequences

- `02-basic-workflow.md` and the website mark the formal review as optional/risk-weighted,
  beside intake and the task packet — not a break with "what not to skip," because the
  independent judgment still happens.
- "What not to skip → independent review" reads as the *judgment by a non-implementer*, not
  the *packet*.

## Status

Accepted. Refines [ADR-0094](./0094-decomposition-and-risk-weighted-review.md); relates
[ADR-0056](./0056-adversarial-self-review-completion-discipline.md),
[ADR-0105](./0105-stretch-and-collapse.md).
