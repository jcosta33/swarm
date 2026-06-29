---
type: adr
id: adr-0106
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0106 — Keep-clean tooling: make zero-noise structural, not a convention

## Context

Ephemeral-by-default ([ADR-0104](./0104-ephemeral-by-default.md)) and collapse-by-default
([ADR-0105](./0105-stretch-and-collapse.md)) stop the *flow* artifacts from piling up. But the
**durable** set (specs, findings, decisions) still grows over years, and at scale its dominant failure
is **duplication, not absence** ([ADR-0096](./0096-artifact-lifecycle.md) §3.5). Single-sourcing,
age-out, and freshness are all discipline-dependent — and discipline drifts. A *guarantee* of zero
durable noise can only come from **tooling**. Ratified from RFC-keep-clean-tooling (suspec-works#72
items 2/5/6/8; suspec-cli#1).

## Decision

**Specify the keep-clean tooling as the stated anti-bloat forcing function** (build is a later plan;
this ADR fixes the shape + honesty posture):

1. **Derived index/board** — `suspec status` derives the board from live artifacts; never a
   hand-maintained list. _Toolable (already partly shipped)._
2. **`suspec clean` / gc** — **delete** the gitignored ephemeral past its window; **archive** any
   committed-transitory under `archive/`; report what changed. _Toolable._
3. **Dedup / single-sourcing check** — flag a finding or spec section that restates another. _Toolable
   when measured._
4. **Freshness / supersede check** — realizes ADR-0096's specified-not-shipped item (every
   `superseded_by` resolves; the index lists it; past-freshness artifacts flagged). _Toolable; the
   spec-side gates on the living-specs ADR._
5. **Spec-coverage drift** (suspec-cli#1) — advisory now, a check once measured 0-FP.
6. **Promotion-or-die** — at Close, a durable discovery promotes to its home or evaporates with the
   ephemeral scratch. _Toolable as a close-gate._

**Cost/usage visibility** (suspec-works#72.8) **splits to its own RFC** — it crosses the reconcile-only
boundary ([ADR-0077](./0077-suspec-cli-reconcile-only-harness.md): suspec-cli has no token data; the
runner must feed it). Honesty framework ([ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)):
each item ships only when it clears the measurement bar; until then it is named, not enforced.

## Consequences

- The human authors only durable truth; the tooling keeps everything else from accumulating — bloat
  becomes structurally impossible, not a weekly fight.
- **Build deferred** to a later plan, sequenced by the 0-FP bar. Composes with ADR-0104 (gc prunes the
  gitignored set) and ADR-0105 (a derived index makes the dial navigable).
- Items 4 (spec freshness/supersede) and 6 (promotion for specs) **gate on the living-specs ADR**
  (the spec status/supersede lifecycle must be decided first).

## Affected obligations / constraints

- **Realizes:** ADR-0096's specified-not-shipped supersede/index check. **Honors:** ADR-0063
  (level every claim). **Bounded by:** ADR-0077 (reconcile-only — cost visibility is out-of-band).
- **Does NOT change:** the checks contract here (no `checks.yaml` rule lands with this ADR).
