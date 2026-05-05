# Skill (documentation): `adversarial-review`

> **For agents:** instructions → [`/scaffold/.agents/skills/adversarial-review/SKILL.md`](../../scaffold/.agents/skills/adversarial-review/SKILL.md)

---

## TL;DR

Friendly review praises intent; adversarial review **assigns probabilities of latent failure**. This skill biases acceptance toward disproof tries (property edges, concurrency windows, deceptive happy paths).

## Why not fold entirely into Skeptic persona

Persona conveys stance breadth (handoffs, forbiddances across task graph). Skill isolates reusable **attack pattern kit** Skeptic-coded sessions load without duplicating encyclopaedic playbook text across personas docs.

Keeps Skeptic SKILL section readable while allowing expansion of stratified review heuristics.

## Psychological basis (compressed)

Contributor empathy correlates with under-weighting malignant edge cases authored by selves. Scripted scepticism substitutes for emotional distance without mandating hostility prose — focus stays on falsifiable artefacts.

## Design tension vs velocity

Throughput cost: exhaustive reviews don't scale manually. Skill must emphasise **risk-ranked** probes (severity mapping to blast radius surfaces) vs academic completeness — framework encodes pragmatic ordering in template Self-review scaffolding.

Kickback choreography pairs with bounded rounds ([concepts § kickback](../concepts/07-flow-graph.md)).

## Interaction with empirical proof

Adversarial skill guides *thinking* exercises; empirical proof mandates *executable* falsification pathways (tests/commands). Neither replaces the other.

## Failure modes

| Pitfall | Result |
|---------|--------|
| Review becomes tone policing | Misses behavioural holes while appearing thorough. |
| Trust worker logs | Violates rerun independence — defeats adversarial framing. |

## Related

- [Persona docs: Skeptic](../personas/the-skeptic.md) — routing & mindset context only
- [Task: review](../tasks/review.md)
