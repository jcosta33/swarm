# ADR 0002: Personas pair 1:1 with task types

## Status

Accepted

## Context

Free-form persona choice lets models pick whichever stance flatters continuation bias ("helpful reviewer who approves"). That collapses empirical discipline and mixes incompatible proofs in one session.

## Decision

Every **task type** maps to **exactly one default lead persona**. The launcher sets persona from task type + flow graph; the agent does not self-assign.

Overlay personas remain **project-local** additions; they extend, not splinter, the canonical map.

## Consequences

- Positive: deterministic conditioning; Skeptic proofs never blend with Builder improvisation in the same task by default.
- Negative: occasional misfit when reality straddles types — resolved by **re-tasking**, not persona blending mid-session.
