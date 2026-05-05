# Skill (documentation): `write-refactor`

> **For agents:** instructions → [`/scaffold/.agents/skills/write-refactor/SKILL.md`](../../scaffold/.agents/skills/write-refactor/SKILL.md)

---

## TL;DR

Structural moves under observable invariance — skill encodes shim contracts & batch validations because humans mis-estimate behavioural blast radius continuously.

Checkpoint frequency rationale: errors compound super-linearly with touched module coupling — early graph validation cheaper than rewind.

## Separation from rewrite / migration / performance

| Neighbour task | Divergence |
|----------------|------------|
| `rewrite` | Permits semantics shift — refactor forbids externally visible deltas |
| `migration` | Mechanical API replacement wave — refactor targets internal cohesion |
| `performance` | Metric targeted — refactor targets clarity only unless audit explicitly nests perf |

Elevated documentation-gatekeeper coupling: forbid behaviour drift narrative smuggling renamed as refactor.

Janitor persona embodies temperament.

## Architectural discovery handling

Structural insight mid-refactor ⇒ promote audit/issue — resisting new feature camouflage maintains scope hygiene.

## Related

- [Refactor task rationale](../tasks/refactor.md)
