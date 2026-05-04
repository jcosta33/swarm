---
name: manage-task
description: Load at session start and stay loaded for the entire task. Owns the task file's lifecycle — pre-flight checks (persona loaded, source doc read), in-flight maintenance (progress checklist, decisions log, findings capture), and the pre-close gate (promote durable findings; close blockers; verify Self-review is filled in).
---

# Skill: manage-task

## Purpose

The task file is the agent's resumption record and the trail of work. `manage-task` keeps the file *useful* — current, accurate, and ready for the next session if this one ends mid-stride. It is the discipline that prevents the most common framework failure: knowledge captured during a task evaporating with the worktree.

## Core rules

### 1. Pre-flight before action

Before any substantive work, the agent confirms:

- The task file at `.agents/tasks/<slug>.md` exists and is the current task
- The persona named in the `> **PERSONA:**` blockquote is loaded (the `personas` skill is fired)
- All source docs in `## Linked docs` are read in full
- All required skills in `## Required skills` are loaded

If any pre-flight item fails, the agent halts and surfaces the gap as a `## Blocker`.

### 2. Plan before implementing

The agent fills in `## Plan` before writing code. The plan is a forecast; deviations from it are recorded in `## Decisions`.

### 3. Update the file continuously

Throughout the session:

- Mark items in `## Progress checklist` as they complete
- Capture significant choices in `## Decisions` with rationale
- Capture codebase discoveries in `## Findings`
- Mark assumptions `[pending]` initially; promote to `[confirmed]` when verified
- Surface blockers in `## Blockers` *immediately*, not at the end
- Run periodic verification gates and paste outputs into `## Validation gates` (or directly into `## Self-review` for some templates)

### 4. Promote durable findings before close

The pre-close hook checks `## Findings` for entries that:

- Reveal a structural issue → promote to `.agents/audits/<slug>.md`
- Identify a missing requirement → promote to `.agents/specs/<slug>.md`
- Reveal an external knowledge gap → promote to `.agents/research/<slug>.md`
- Identify a defect → promote to `.agents/bugs/<slug>.md`

Findings marked `[session-only]` with a justification are exempt; findings without that marker block the task from closing.

### 5. The pre-close gate

Before status moves from `active` to `done`, the agent verifies:

- [ ] All `## Progress checklist` items are checked or explicitly marked unfeasible
- [ ] All `[pending]` assumptions are either resolved (`[confirmed]`) or surfaced as blockers
- [ ] All `## Blockers` are either resolved or escalated (with the escalation recorded)
- [ ] All durable `## Findings` are promoted upstream (or marked `[session-only]`)
- [ ] `## Self-review` is fully answered with empirical proof (every `[Paste output]` placeholder filled)
- [ ] `## Next steps` is empty (work complete) OR points to the follow-up task spawned

The agent cannot mark `status: done` until every gate is satisfied.

### 6. Update Next steps before stopping

If the session ends mid-task (out of context, human pauses, model timeout), the *last action* is to update `## Next steps` so a fresh agent in the same worktree can pick up exactly where this one left off. The Next steps should include:

- What's done so far (cite the Progress checklist state)
- What's the next concrete action
- Any verification commands that need re-running to confirm worktree state
- Any open `[pending]` assumptions or blockers that block progress

## What does not belong

- **In `## Findings`:** speculation. Findings are observations with file:line where applicable.
- **In `## Decisions`:** the implementation step-by-step (that's `## Plan`). Decisions are the *significant choices*.
- **In `## Self-review`:** paraphrase. Always paste verbatim output.
- **In the task file at all:** durable architectural insights that should live in an audit; the promotion protocol moves them.

## Anti-patterns

- Closing a task with `[pending]` assumptions (silently resolves to "I think it's true")
- Findings left in the task file at close (lost when worktree is deleted)
- Empty `## Next steps` when the session ends incomplete (next agent re-discovers)
- Self-review with `[Paste output]` placeholders unfilled (the gate is bypassed)
- Plan written *after* implementation (plan-after-the-fact is rationalisation, not planning)

## Lifecycle hooks

`manage-task` fires at these moments:

| Hook                  | Trigger                                  | Action                                                   |
| --------------------- | ---------------------------------------- | -------------------------------------------------------- |
| `pre-flight`          | Session start                            | Verify task file, persona, skills, source docs           |
| `pre-implementation`  | Before any code change                   | Verify `## Plan` is filled in                            |
| `progress-checkpoint` | Periodic (per task type's checkpoint frequency) | Verify checklist updated; verification output pasted |
| `pre-close`           | Agent attempts `status: done`            | Verify all gates satisfied (above)                       |
| `pre-pause`           | Session ends without `done`              | Verify `## Next steps` updated                           |

## See also

- `.agents/skills/documentation-gatekeeper/SKILL.md` — the other always-loaded skill
- `.agents/skills/personas/SKILL.md` — the persona profiles
- `.agents/templates/task-base.md` — the shared task skeleton
- `docs/agents/03-workflow.md` — the session lifecycle
