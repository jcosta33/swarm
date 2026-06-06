# Backlog — a checkable-document layer (parked)

> **Status: parked, not built.** The direction is recorded in ADR-0043 (status: *proposed*). The live
> lint pass is unchanged — `SOL-P` still scopes to spec prose only. This file is the short backlog if/when
> we pick the direction up. Don't expand it into a program; build the smallest checkable thing first, or not
> at all. The supporting evidence is already in `docs/research/sources.md` (ported, web-verified).

## The one realization worth keeping

Extending lint to *other* agent docs (audits, findings, research) should be **subtractive + checkable**,
not additive structure. The strongest measured evidence says adding structured agent prose is net-negative
(over-specified context costs more for less; most added skill docs are inert/stale). What helps is a
**deterministic external check**, never an LLM judge or a vote. So: keep obligation-blocks spec-only; for
other docs, the only things worth checking are **provenance-resolves, evidence-before-conclusion,
staleness, minimality** — and only where a check is deterministic (a `file:line`/citation that resolves, a
content-hash that matches). Smell checks stay advisory (~40%+ false-positive floor).

## If picked up — candidate items (smallest first)

- **Provenance-resolves check** — a fact-shaped claim in an audit/finding carries a resolving anchor
  (the `file:line` exists, the citation/URL resolves). Advisory `SOL-P` family; blocks only when the
  referent is deterministically checkable.
- **Evidence-before-conclusion + reason-then-emit** — author rule: reason free-form, then emit the
  structured doc; place evidence before the verdict.
- **Staleness/conflict** — a finding/memory entry whose cited surface moved is flagged via the
  existing `content_hash` join.
- **Minimality** — flag bloat / restated-from-elsewhere; reinforce "load what the task names."

## Honesty line (§0.7)

- Stance-separation is threat-motivated *design* (MINJA measures the attack, not the defense) — not a
  measured reliability gain. Don't claim "spec-first measurably wins" — no controlled study in the
  confirmed sources. Keep any check **cheap and load-bearing, never ceremonial.**

*No framework changes. Evidence: `docs/research/sources.md`. Decision record: ADR-0043 (proposed).*
