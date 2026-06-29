---
type: adr
id: adr-0105
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0105 — Stretch and collapse: the artifact set is a dial, not a set of stations

## Context

The artifact set risks two failure modes: too many *stations* (ceremony for a trivial change) or too
*lean* (can't unfold for an 8-PR migration). [ADR-0103](./0103-spec-as-living-form-task-on-demand.md)
started the fix (spec is the unit, task on-demand) but it was never stated as a principle, and the kit
still ships `/examples` + `/advanced` as if every adopter needs every extended-type blank. Ratified
from RFC-stretch-collapse (suspec-works#72 ceremony).

## Decision

1. **The artifact set is a dial.** Default is **spec-only**; stretch **on demand** — `+task` when a
   spec splits into parallel slices, `+change-plan` for multi-wave migrations, `+inventory` for
   brownfield, `+research/audit/bug-report/PRD/RFC/ADR` when that *stance* is needed. **Nothing is a
   mandatory station** — the complexity of the work summons the artifact; the ephemeral stretch
   artifacts collapse away after (ADR-0104). _Level: convention._

2. **Drop `/examples` and `/advanced` from the kit.** The extended-type *shape* belongs in the
   **authoring skills** ([ADR-0042](./0042-skill-carrier-and-standalone-conditioning.md) one skill per
   authored artifact; [ADR-0016](./0016-skills-are-self-contained.md) self-contained bodies), not in
   loose template files; the deep reference lives in `docs/`. This **refines**
   [ADR-0064](./0064-minimal-kit-tiering.md) (drops the advanced tier + the example). _Level: convention._

## Consequences

- The kit slims to the core loop + the skills; **offline self-containment yields to single-sourcing**
  (the shape ships in the skills; the reference is one fetch to `docs/`). `docs/examples/` keeps the
  walkthroughs.
- **Implementation deferred** (later plan): each extended-type authoring skill **inlines its shape
  first**, *then* `/advanced` + `/examples` are deleted (nothing loses the shape). No change ships with
  this ADR.

## Affected obligations / constraints

- **Refines:** [ADR-0064](./0064-minimal-kit-tiering.md) (advanced tier + flagship example). **Builds
  on:** [ADR-0103](./0103-spec-as-living-form-task-on-demand.md). **Relies on:** ADR-0042 / ADR-0016
  (skills carry the shape).
- **Does NOT change:** the core templates (spec/task/review/finding), the verdict model, or the checks
  contract.
