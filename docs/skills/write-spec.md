# Skill (documentation): `write-spec`

> **For agents:** instructions → [`/scaffold/.agents/skills/write-spec/SKILL.md`](../../scaffold/.agents/skills/write-spec/SKILL.md)

---

## TL;DR

Specs are executable contracts pretending to be Markdown. `write-spec` encodes completeness heuristics so downstream Builder sessions rarely invent missing behavioural atoms.

## Why authoring skills exist separately from gatekeeper

Authoring seeks **density + testability**. Gatekeeping only asks "is this still a spec, not an audit pretending?" Divergent optimisation targets merged skills historically bloat gates or soften rhetorical vigilance against ambiguous acceptance criteria.

## Philosophical hinges

| Choice | Reason |
|--------|--------|
| Acceptance criteria must map to assertions | Bridges automatic Test Author wave without interpretive leaps. |
| Alternatives-log section mandatory | Surfaced rejections constrain future yak-shaving reopen battles. |
| Distillation linkage | Signals inherited research deltas honestly — aligns with sibling distillation-discipline |

## Architectural vs product prose trap

Architect persona must resist narrating triumphant saga instead of pinning interface truth. Skill text encodes bans on speculation masquerading as requirements.

## Downstream ergonomics bias

Anything vague becomes Builder `## Blocker` tax multiplied by sceptic cycles. Investing crispness upfront cheaper than iterative kickback churn.

## Failure modes

- Spec bundling retrospective observations ⇒ audit leakage (gatekeeper catches; still wastes review).
- Acceptance criteria marrying implementation details duplicates future refactor rigidity — skill balances specificity vs layering.

## Related

- [Document: spec](../documents/spec.md)
- [Task: spec-writing](../tasks/spec-writing.md)
