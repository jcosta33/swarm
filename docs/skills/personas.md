# Skill (documentation): `personas`

> **For agents:** instructions + all profile bodies → [`/scaffold/.agents/skills/personas/SKILL.md`](../../scaffold/.agents/skills/personas/SKILL.md)

---

## TL;DR

Persona SKILL is delivery vehicle for thirteen mindset bundles the launcher selects — **agents must not freestyle personality** overlaying conflicting proof obligations concurrently.

Formal stance: personas are cognitive configurations not HR roles ([ADR 0009](../adrs/0009-personas-are-mindsets.md)).

## Why one consolidated file (vs thirteen micro-skills initially)

Operational reality: loaders / humans grep less; versioning stays atomic reducing drift mismatches mid-orchestration. Trade-off — size — mitigated via anchored headings consuming agents jump parse.

Consumers may shard later if tooling supports deterministic assembly — scaffold default optimises cohesion.

Documentation pages under [`personas/`](../personas/README.md) articulate **conceptual WHY per mindset** avoiding duplication of HARD/FORBIDDEN tables present only in scaffold to prevent sync skew.

Deliberate switch protocol (Lead→Skeptic) documented at concept layer ([recursion](../concepts/08-recursion-and-delegation.md)).

## Overlay personas discipline

Teams bolt Type-surgeon / Integrator overlays — frameworks remain thirteen canonical rails; overlays extend map in AGENTS conventions.

## Interaction with loaders

Typically first skill after task parse — YAML `description` must stay precise for retrieval ranking in Anthropic/OpenAI compatible harnesses described abstractly (`@cursor`/CodexSkills ecosystem).

Failure: partial adoption (persona name cited without reloading constraints table) ⇒ costume personas — Self-review hardness mitigates partially.

Iron-law pattern rationale: [ADR 0013](../adrs/0013-iron-law-red-flags-pattern.md)

## Related

- [Personas concept](../concepts/04-personas.md)
- [Compatibility matrix](../reference/compatibility-matrix.md)
