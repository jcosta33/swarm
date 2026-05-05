# Skill (documentation): `manage-task`

> **For agents:** verbatim instructions → [`/scaffold/.agents/skills/manage-task/SKILL.md`](../../scaffold/.agents/skills/manage-task/SKILL.md) (YAML `description` is what loaders match).

---

## TL;DR

Without a ruthless task-file steward, ephemeral worktrees **forget** validated truth. `manage-task` exists so *state* survives model resets — not chat summaries, but structured sections a stranger can resume.

## Why Swarm separates this concern

Agents excel at patching code and weak at bookkeeping. Folding lifecycle rules into personas would duplicate thirteen copies drifting apart. A **cross-cutting lifecycle skill** aligns every persona with the same close gates (`Findings`, `Next steps`, `Self-review`), which is prerequisite for deterministic review and promotion.

## Design rationale (what problems it encodes)

1. **Pre-flight** — Routing already chose persona + upstream docs; the executor must **not** pay the exploration tax twice or start from a hallucinated checklist.
2. **Plan-before-write** — Prevents retrospective rationalisation pretending to be foresight (`## Decisions` holds honest deltas).
3. **Continuous deltas** — `Findings` vs `Decisions` split stops architectural observations masquerading as implementation trivia (and vice versa).
4. **Promotion** — Gitignored surfaces are lossy-by-design ([ADR 0004](../adrs/0004-task-files-are-gitignored.md)); promotion is Swarm's memory write through audits/specs/bugs/research buckets.
5. **Pre-close** — Mirrors CI philosophy locally: completeness is procedural, not tonal.

## How it interacts with sibling skills

| Skill | Boundary |
|-------|----------|
| `documentation-gatekeeper` | *Can* — flow-graph legality vs doc-type purity. |
| `manage-task` | *Must* — section hygiene, blocker surfacing, close checklist. |
| `empirical-proof` | Paste discipline inside `Self-review`; `manage-task` ensures blanks block completion narration. |

## What you should **not** copy from this page into a consumer repo

Operational bullet lists belong in scaffold only. Updating behaviour **without** patching `/scaffold/.agents/skills/manage-task/SKILL.md` forks the framework silently.

## Failure modes (Skeptic view)

| Symptom | Likely betrayal |
|---------|----------------|
| Gorgeous code, empty `Findings` | Discoveries never promoted — next task rediscovers expense. |
| `status: done` with untouched `[Paste output]` | Gate bypass renders empirical proof ceremonial. |
| Plan appears after edits | Rationalisation laundering; defeats audit trail for scope creep suspicions. |

## Related concepts

- [Session lifecycle](../concepts/11-session-lifecycle.md)
- [Distillation & promotion](../concepts/03-distillation.md)
- [Reference: task skeleton](../reference/task-base.md)
