---
name: <skill-slug>
description: One or two sentences telling the model WHEN to load this skill. Phrase as a trigger, not a content summary. Example — "Load when modifying files in src/db/ or src/api/middleware/. Enforces our connection-pool isolation and idempotent-key contract."
---

# Skill: <Display name>

## Purpose

What this skill protects against. Why it exists. What failure mode it prevents.

## Core rules

Numbered. No hedging.

1.
2.
3.

## What does not belong

Negative space — what to put elsewhere instead.

- (in AGENTS.md instead, because…)
- (in a task template instead, because…)
- (in a spec / audit instead, because…)

## Anti-patterns

Concrete failure modes with corrections.

- ❌ <pattern> → <correction>

## Examples

(Optional. Worked examples illustrating the rules in action. Use code blocks where helpful.)

## See also

- `.agents/skills/<related-skill>/SKILL.md`
- `.agents/templates/<related-template>.md`
- `docs/agents/<related-process-doc>.md`

---

> **Notes for skill authors:**
> - The `description` is the most load-bearing line. It tells the model when to load the skill. Write it for the model, not for humans.
> - Skills can be flat files (`<name>.md`) or folders (`<name>/SKILL.md` plus `references/`, `scripts/`, `examples/` subdirectories). Folder form is preferred when the skill grows beyond one screen.
> - Project-specific skills live under `.agents/skills/domain/`.
> - The pattern is *codify the rule once you've explained it twice*.
