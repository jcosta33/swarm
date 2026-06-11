---
type: adr
id: adr-0067
status: accepted
created: 2026-06-11
updated: 2026-06-11
---

# ADR-0067 — Memory: findings first, the heavier machinery as an advanced model

## Context

Lost context is a top adopter pain, but a multi-tier memory system with promotion protocols is ceremony
ahead of need for most teams (R-003). What survives sessions must be cheap to write and easy to recall.
Externalized state is what makes multi-session agent work tractable
[[CTXENG]](../research/sources.md#CTXENG) [[SCRATCHPAD]](../research/sources.md#SCRATCHPAD).

## Decision

1. **Core = `findings/` + one Close-step rule:** *before closing a task, record anything durable as a
   finding* (template frozen here; shipped at `starter-kit/templates/finding.md`): frontmatter
   `type: finding, id: FINDING-*, status: candidate|accepted|stale, from, date, related[]`; sections
   What we learned / Evidence / Where it applies / Where it does not apply / Future guidance. The status
   board lists findings pending acceptance.
2. **The status board** (template frozen here; `templates/status.md`): a hand-edited `type: status`
   workboard — one row per spec/task/review/finding with state and link, plus a Human-attention list
   (blocking questions · tasks missing review packets · findings pending acceptance). One honest rule
   (checklist level): a "verified" claim on the board links its review packet. The machine-derived
   per-spec coverage read-model is a future-CLI output, not this file.
3. **The advanced memory model** — load-when index, glossary, patterns-from-corroborated-findings, the
   promotion statuses, and the append-only ledger — lives on one reference page
   (`docs/reference/memory.md`) for teams that outgrow the core, with its research basis carried along.

## Alternatives considered

| Alternative | Why weaker |
|---|---|
| Ship the full memory system in the kit | The reports identify exactly this as framework-becomes-the-work |
| Findings only, drop the advanced model | Larger teams hit recall limits the index/patterns model already solves |

## Consequences

Positive: saving a lesson costs one short file. Negative: recall is grep/board-driven until a team adopts
the advanced index. Neutral: the ledger concept survives as reference, not requirement.

## Status

Accepted. Refines ADR-0032.

## Propagation

Templates (finding, status), docs/09, reference/memory.md, kit shell, evals (Close rubric).
