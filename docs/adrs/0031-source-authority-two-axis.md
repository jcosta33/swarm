---
type: adr
id: 0031-source-authority-two-axis
status: accepted
created: 2026-06-02
updated: 2026-06-02
supersedes:
superseded_by:
---

# ADR-0031: The source-authority two-axis model

## Context

When two artifacts assert conflicting obligations — they constrain the same trigger, state, or surface with incompatible modality — something must decide which one governs. Absent a decision procedure, the only operative rule is the implicit one: the most recently written artifact silently wins. That lets a casual chat remark override an accepted decision, and an observation-only audit override an approved spec, without any recorded authoring act (§22).

A single precedence ladder is also insufficient. Two genuinely independent questions are in play: "how *settled* is the container an obligation was traced back from" and "how much *governing force* does its domain project downstream." A security obligation and a product obligation can sit in artifacts of equal rank yet must not share governing force. Collapsing both questions into one ordering would force a false ranking between them (§22, §22.1).

## Decision

Authority is resolved on **two orthogonal axes, applied lexicographically — domain first, then artifact** — as detailed in the source-authority reference ([`docs/model/source-authority.md`](../model/source-authority.md)).

- **Axis A — artifact authority (backward trace):** ranks an obligation by the kind and lifecycle status of the artifact containing it (accepted `adr.md` highest, down through approved spec, accepted finding, reviewed audit/research, task notes, to chat lowest) (§22.1.1).
- **Axis B — domain authority (forward governing force):** ranks an obligation by its governance domain (`enforced-policy` highest, down through compliance, security, architecture, product, team, task-map, to `memory` lowest), discoverable deterministically from a `DOMAIN` clause, the spec's frontmatter `domain`, or the default `product` (§22.1.2).

The conflict rule combines them with a hard-policy gate (§22.2): domain rank (Axis B) is decisive only when at least one obligation is in the hard-policy band (ranks 1–3) and lives in a durable, reviewed artifact; otherwise artifact authority (Axis A) is the most-significant key and domain rank only breaks ties. If both axes are equal, a conformant tool MUST stop and emit `SOL-M002`, routing the conflict to amendment — resolution is an authoring act, never an inference. This is a deterministic comparison over the typed obligation set, not a runtime: the contract requires a conformant tool to honour the ordering; nothing "runs" it.

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| Let the most recently written artifact win (implicit status quo) | The exact failure §22 exists to prevent — chat or an un-reviewed note silently amends an accepted ADR with no recorded authoring act. |
| One flat precedence ladder collapsing domain and artifact | The two questions are genuinely independent; a single ladder forces a false ranking and would let an equal-artifact security and product obligation share governing force (§22, §22.1). |
| Domain rank decisive everywhere (Axis B always dominates) | Would let a low-criticality domain note (e.g. a `team` remark in a reviewed audit) override a higher-authority artifact (a `product` obligation in an approved spec); the hard-policy gate confines domain-dominance to ranks 1–3 (§22.2). |
| Auto-select a winner when both axes tie | Resolution is an authoring act, not an inference; a tie is a genuine contradiction (`SOL-M002`) that MUST route to review (§22.2 step 3). |
| Treat every source as equally bindable (flat retrieval) | Authority *is* the conflict-resolution complement to the obligation graph; flat retrieval has no answer to "which wins" and rests provenance on recency (§22). |

## Consequences

### Positive

- Conflicts resolve deterministically and provenance-aware: a hard-policy obligation governs by domain even from a lower-ranked artifact, while below that band the settled-ness of the container decides.
- The two axes double as bidirectional traceability — Axis A is the backward trace to provenance, Axis B is the forward governing force over what an obligation rules (§22.5).
- A genuine contradiction surfaces as `SOL-M002` and routes to amendment rather than being silently swallowed (§22.2).

### Negative

- Authors must classify each obligation's domain, and the hard-policy gate adds a band check before the lexicographic compare — more procedure than a single ladder.
- The full rule (gate + two axes + invariants) is more to teach than "most recent wins," and demands the source-authority reference doc state both axes, the rule, the invariants, and the worked tie-break (§22.5).

### Neutral / tradeoffs

- `memory` and `task-map` are axis floors: a promoted finding can inform but never weaken an obligation. Promotion to a spec carries the *new container's* authority — intent acquiring rank, not the floor being breached (§22.4).
- An obligation below `approved`/`accepted` status occupies its draft tier, one rank below its accepted tier (§22.1.1) — a precedence detail authors must track during a migration.

## Status

Accepted (v0.1).

## Affected obligations / constraints

- Adds: the two-axis source-authority procedure — Axis A (artifact), Axis B (domain), the lexicographic rule with hard-policy gate, the three cross-axis invariants, and the `SOL-M002` tie-stop (§22).
- Modifies: the `SOL-M004` authority-conflict diagnostic, now defined as a lower-ranked artifact silently amending a higher-ranked one under this model (§22.1.1).
- Supersedes: none.
