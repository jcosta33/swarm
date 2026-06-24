---
type: adr
id: adr-0102
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0102 — Lean the artifact surface: intake is an optional pointer; reference material single-sources to docs

## Context

Two leanness wins from the session deliberation (RFC-lean-artifact-set) that stand on their own,
independent of the larger spec-as-living-form change (which stays an open proposal — see that RFC):

- **Intake is presented as a station with a file**, but a spec's source is often a Jira issue or any
  provider with no middleman file, and no notation belongs around it. The spec template already allows
  `sources: self` or a ticket id — the loop docs just over-imply an `intake/` step.
- **The kit duplicates reference material** (`advanced/checks-reference.md`,
  `advanced/sol-reference.md`) that restates the canonical `docs/reference/checks.md` +
  `structured-requirements.md` — and it has been caught **drifting** (stale at C014 in a prior pass).
  Duplicated reference content is a standing drift liability (the anti-duplication concern of
  [ADR-0096](./0096-artifact-lifecycle.md) §3.5).

## Decision

1. **Intake is an optional source pointer, not a required station.** A spec names its origin in
   `sources:` — a Jira URL/id, an `intake/` file, or `self`. The loop is **Spec → Review**; capturing
   a raw request in `intake/` is available but never implied as a step, and no notation surrounds it.
   _Level: convention._

2. **Reference material single-sources to docs.** The kit's `advanced/checks-reference.md` and
   `advanced/sol-reference.md` no longer **duplicate** the canon — their bodies become a one-line
   pointer to `docs/reference/checks.md` (+ `checks/checks.yaml`) and
   `docs/reference/structured-requirements.md` respectively. The **templates** in `advanced/`
   (adr/prd/rfc/audit/bug/research/threat-model) stay — they are blanks nothing else ships. This
   resolves RFC-lean-artifact-set's offline-self-containment open question **in favour of
   single-sourcing**: a drifting copy is worse than a pointer, and the canon is one fetch away.
   _Level: convention._ Full removal of the card files (with inbound-pointer surgery) is a tracked
   follow-up, not required by this ADR.

## Consequences

- No `checks.yaml` rule, no contract bump — conventions, consistent with the honesty framework
  ([ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)).
- The kit stops carrying a drift liability; `spec-check` (which used the checks card as its reference)
  points at the canonical `docs/reference/checks.md`.
- **Scope note:** the larger **spec-as-living-form / task-on-demand** change (RFC-lean-artifact-set
  D1) is **not** decided here — it amends the frozen spec format ([ADR-0058](./0058-two-tier-spec-format.md))
  and touches the parser, C006, and ~50 specs, so it awaits ratification rather than autonomous
  execution (keeping the tree coherent and pristine).

## Propagation

`docs/02-basic-workflow.md`, `docs/03-where-files-live.md`, `docs/ADOPTING.md` (intake optional), and
the kit cards `advanced/checks-reference.md` + `advanced/sol-reference.md` (→ pointers) + the
`spec-check` guide (→ canonical checks doc). corpus-works vendored copies re-sync from the kit.

## Affected obligations / constraints

- **Reaffirms:** [ADR-0096](./0096-artifact-lifecycle.md) (anti-duplication), the spec template's
  `sources` field (already allowed `self`).
- **Does NOT change:** the spec format, the verdict model, the checks contract, or the `advanced/`
  templates.
