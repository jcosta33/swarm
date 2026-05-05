# Skill (documentation): `documentation-gatekeeper`

> **For agents:** instructions → [`/scaffold/.agents/skills/documentation-gatekeeper/SKILL.md`](../../scaffold/.agents/skills/documentation-gatekeeper/SKILL.md)

---

## TL;DR

Opinionated prose is worthless if **wrong kind → wrong silo**. This skill refuses illegal document mutations (spec-as-audit, research-as-spec, bug-report-containing-fix) — the deterministic routing graph's sheriff.

## Why it isn't just lint

Linters penalise punctuation; gatekeepers penalise **epistemic crossings** that sabotage auditing:

- downhill-only flow ([ADR 0003](../adrs/0003-distillation-is-unidirectional.md))
- refusal to implement straight from exploratory research sans contract step
- multi-source routing confusion hiding primary truth

Humans underestimate how often shortcuts feel virtuous mid-session (`"research is basically the spec"`). Automated kindness enables those shortcuts; scripted refusal costs tokens and saves regressions.

## Relationship to authoring skills (`write-*`)

`write-*` answers **quality inside a lawful doc type**. Gatekeeper decides **whether the artefact qualifies as that type**. Splitting avoids a mega-skill rewriting specs while policing graph edges — separation of authoring vs routing concerns.

## Pairing with `manage-task`

`manage-task` enforces procedural completeness near close; gatekeeper catches semantic illegalities earlier (during captures to `Linked docs`, mid-flight narrative drift). Ideally both invoke same norms — drift between them signals fork rot.

## Customisation stance

Forbidden-edge tables evolve slower than repos. Organisation-specific prohibitions (**PII leakage channels**, forbidden directories) augment via project skills — still expressed as deterministic rows a launcher can cite, not vibes.

## Failure modes

| Miss | Blast radius |
|------|--------------|
| Skip gatekeeper injection | Narrative laundering across doc types destroys traceability audits. |
| Overfit gatekeeper stylistically | Ends up rewriting specs stylistically → duplicates Architect skill; keep scope narrow (legality only). |

## Related

- [Flow graph (conceptual)](../concepts/07-flow-graph.md)
- [Reference tables](../reference/flow-graph.md)
- [Four doc types rationale](../concepts/05-document-types.md)
