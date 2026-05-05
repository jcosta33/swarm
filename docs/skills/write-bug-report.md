# Skill (documentation): `write-bug-report`

> **For agents:** instructions → [`/scaffold/.agents/skills/write-bug-report/SKILL.md`](../../scaffold/.agents/skills/write-bug-report/SKILL.md)

---

## TL;DR

Bug reports crystallize **minimal reproduction + causal story** excluding remedy — cognitive firewall preventing patch-before-understanding pathology.

Formal separation rationale: [ADR 0007](../adrs/0007-bug-report-as-meta-task.md).

## Psychological mechanism

Providing fix suggestions feels helpful; SKILL deliberately blocks dopamine shortcut so fix task evidence stays uncompromised.

## Quality markers

Strong reports shrink fix task fan-out dimensions:

| Dimension | Benefit |
|-----------|---------|
| Repro deterministic | Skeptic verifies failure before patch coherence |
| Root cause hypotheses ranked | Saves parallel blind alleys |
| Blast radius fenced | Targets regression suite design |

Bug Hunter persona operationalises forbiddance on patching.

## Relation to auditing

Structural defects surface via audits — bug-report stays incident scoped; framework punishes creeping architecture essays inside incident template.

## Related

- [Bug report document](../documents/bug-report.md)
- [Bug Hunter persona](../personas/the-bug-hunter.md)
