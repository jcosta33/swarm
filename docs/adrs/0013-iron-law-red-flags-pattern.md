# ADR 0013: Iron-law + red-flags persona format

## Status

Accepted

## Context

Soft guidance bullet lists degrade under LLM optimisation — models reinterpret "should avoid" as "unless inconvenient".

Borrowing clarity from hostile-review pattern libraries, Swarm personas pair **Hard constraints / Forbidden actions** (**iron-law style absolutes**) with explicit **Red flags** tables mapping rationalisations to refusals.

## Decision

Canonical persona payloads live inside [`/scaffold/.agents/skills/personas/SKILL.md`](../../scaffold/.agents/skills/personas/SKILL.md); documentation **explains** why this shape works (see [`docs/concepts/04-personas.md`](../concepts/04-personas.md)).

## Consequences

- Positive: mechanistic refusal of comforting shortcuts; aligns with empirical gates.
- Negative: verbosity — compensated by skim-friendly TL;DR at each profile head.
