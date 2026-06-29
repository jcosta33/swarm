---
type: adr
id: adr-0104
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0104 — Ephemeral by default: gitignore the working set, commit only durable truth

## Context

Flow artifacts — intake, task, review — accumulate one set per change; most are read once and never
again. Committed ([ADR-0060](./0060-suspec-workspace.md)) and aged-out by convention
([ADR-0096](./0096-artifact-lifecycle.md)), they depend on discipline that drifts at scale, so the
live tree bloats into an unread landfill. [ADR-0103](./0103-spec-as-living-form-task-on-demand.md)
moved the durable **evidence** into the spec's `## Execution` and **lessons** into `findings/` — so
the flow artifacts no longer hold the record; they are working state. Ratified from RFC-ephemeral-default
(suspec-works#73).

## Decision

1. **Gitignore the working set; commit only durable truth.** The test: *will it be re-read by future
   work?* **Durable (committed):** the spec (contract + `## Execution`), `findings/`, `decisions/` +
   ADRs, and the board (`status.md`). **Ephemeral (gitignored):** `intake/`, `tasks/`, `reviews/`,
   `suspec check` output, run logs, agent scratch. Noise never committed cannot accumulate — the
   structural guarantee a convention can't give. _Level: convention (the gitignore is the enforcement)._

2. **Reviews are configurable.** Ephemeral by default; a documented opt-in keeps `reviews/` committed
   (and aged out) for audit/regulated teams that need the standing independent-verification trail.
   _Level: convention._

3. **Topology-agnostic.** This is a per-artifact-*class* decision, independent of where the workspace
   lives (the topology question is parked separately).

## Consequences

- **Reverses** [ADR-0060](./0060-suspec-workspace.md)'s commit-the-flow-artifacts decision — re-adopting
  the spirit of [ADR-0004](./0004-task-files-are-gitignored.md) (gitignored flow artifacts), now
  *earned* by ADR-0103 putting the evidence in the spec. **Amends** [ADR-0096](./0096-artifact-lifecycle.md):
  the ephemeral classes are gitignored, not commit-then-age-out.
- The audit-trail subtraction (gitignored reviews) is **named and accepted**, mitigated by the
  configurable opt-in; post-ADR-0103 the spec's Execution + findings + the PR carry most of the record.
- **Implementation deferred** (later plan): the kit `.gitignore.additions` gains the ephemeral classes;
  `docs/03-where-files-live` / `02-basic-workflow` / ADOPTING describe the partition. No change ships
  with this ADR (decision only).

## Affected obligations / constraints

- **Reverses:** ADR-0060 (committed flow artifacts). **Amends:** ADR-0096 (lifecycle). **Builds on:**
  ADR-0103 (evidence in the spec).
- **Does NOT change:** the durable artifacts (spec/findings/decisions/board stay committed), the
  verdict model, or the checks contract.
