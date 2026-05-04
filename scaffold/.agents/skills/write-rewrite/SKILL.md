---
name: write-rewrite
description: Load when re-implementing a module with explicit behaviour changes. Encodes the discipline — make the behaviour delta explicit before changing code, preserve everything not in the delta, identify all affected callers, halt and update the spec if a behaviour change emerges that wasn't planned.
---

# Skill: write-rewrite

## Purpose

Rewrites are riskier than refactors precisely because behaviour is *permitted* to change. Without discipline, unintended changes hide. This skill forces the behaviour delta to be explicit — the contract between the spec and the implementation about what changes and what doesn't.

## Core rules

### 1. Behaviour delta is explicit

Before writing code, fill in the `<behavior_delta>` table with every aspect that changes:

| Aspect | Before | After |
| ------ | ------ | ----- |
|        |        |       |

Anything *not* in the delta must be preserved. The table is the contract.

### 2. Acceptance criteria include preservation criteria

Acceptance criteria cover both:

- The *new* behaviour (what changed)
- The *preserved* behaviour (what stayed the same — explicitly stated)

A rewrite that only tests the new behaviour misses the regression risk.

### 3. Identify all affected callers

For every changed behaviour, grep for callers. Update each one for the new behaviour, or verify each one still works under the preserved behaviour.

### 4. Halt and update the spec on emergent behaviour changes

If during implementation you discover a behaviour change that *isn't* in the delta — stop. Update the spec to authorise the change (or revise to keep the original behaviour). Silent emergent changes are the failure mode.

### 5. Module plan documented

The `<module_plan>` table lists which modules will be touched and what changes in each. The reviewer can use this to verify the diff matches the plan.

### 6. Run validation after every batch

Same discipline as refactor: per-batch validation catches drift early.

## What does not belong

- **In a rewrite:** behaviour changes that aren't in the delta, scope expansion to "redesign while we're here".
- **In `## Module plan`:** modules with `Behavior change?` left blank — make the call.

## Anti-patterns

- Behaviour changes that aren't in the delta table
- Treating "rewrite" as a license to redesign
- Not updating callers for behaviour changes
- Calling it a refactor when behaviour changes (mislabelling)
- Calling it a rewrite when behaviour is preserved (over-marking; should be refactor)

## See also

- `.agents/templates/task-rewrite.md` — the rewrite task template
- `.agents/templates/task-refactor.md` — sibling for behaviour-preserved restructuring
- `.agents/templates/spec.md` — the spec doc this task implements from
- `.agents/skills/empirical-proof/SKILL.md`
- `.agents/skills/personas/SKILL.md` — The Builder persona
