# 🛠️ Skill: manage-task

> **Always loaded.** Owns the task file's lifecycle: scaffolding, progress tracking, durable-finding promotion, and the pre-close gate that prevents silent loss.

---

## 📦 Frontmatter

```yaml
---
name: manage-task
description: Load at session start and stay loaded for the entire task. Owns the task file's lifecycle — pre-flight checks (persona loaded, source doc read), in-flight maintenance (progress checklist, decisions log, findings capture), and the pre-close gate (promote durable findings; close blockers; verify Self-review is filled in).
---
```

---

## 🎯 Purpose

The task file is the agent's resumption record and the trail of work. `manage-task` keeps the file *useful* — current, accurate, and ready for the next session if this one ends mid-stride. It is the discipline that prevents the most common framework failure: knowledge captured during a task evaporating with the worktree.

---

## 🔒 Core rules

### 1. Pre-flight before action

Before any substantive work, the agent confirms:

- The task file at `.agents/tasks/{{slug}}.md` exists and is the current task
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

The agent cannot mark `status: done` until every gate is satisfied. If the agent tries to close prematurely, `manage-task` refuses and prompts for the missing piece.

### 6. Update Next steps before stopping

If the session ends mid-task (out of context, human pauses, model timeout), the *last action* is to update `## Next steps` so a fresh agent in the same worktree can pick up exactly where this one left off. The Next steps should include:

- What's done so far (cite the Progress checklist state)
- What's the next concrete action
- Any verification commands that need re-running to confirm worktree state
- Any open `[pending]` assumptions or blockers that block progress

---

## 🚫 What does not belong

- **In `## Findings`:** speculation. Findings are observations with file:line where applicable.
- **In `## Decisions`:** the implementation step-by-step (that's `## Plan`). Decisions are the *significant choices*.
- **In `## Self-review`:** paraphrase. Always paste verbatim output.
- **In the task file at all:** durable architectural insights that should live in an audit; the promotion protocol moves them.

---

## ⚠️ Anti-patterns

- Closing a task with `[pending]` assumptions (silently resolves to "I think it's true")
- Findings left in the task file at close (lost when worktree is deleted)
- Empty `## Next steps` when the session ends incomplete (next agent re-discovers)
- Self-review with `[Paste output]` placeholders unfilled (the gate is bypassed)
- Plan written *after* implementation (plan-after-the-fact is rationalisation, not planning)

---

## 🛠️ Worked examples

### Example 1: Promotion in action

The Builder is implementing a feature. Mid-task, they notice that the `paymentService.create()` function returns `null` instead of throwing on idempotent collision, and three callers depend on the `null` semantic.

This is not a feature concern — it's an architectural issue. The Builder's response under `manage-task`:

```markdown
## Findings

- `src/payments/service.ts:88` — `paymentService.create()` returns `null` on idempotent collision;
  3 callers depend on this. The contract is undocumented. Promoted to `.agents/audits/payments-api.md`
  for a separate refactor task to address.
```

And in `.agents/audits/payments-api.md`, the Builder appends:

```markdown
## Issue 4 — paymentService.create() return contract is undocumented [MAJOR]

- **File:line:** `src/payments/service.ts:88`
- **Observation:** `paymentService.create()` returns `null` on idempotent collision; three callers
  (`src/jobs/charge.ts:42`, `src/api/checkout/quote.ts:88`, `src/api/billing/preview.ts:21`) rely on
  the `null` semantic. One caller (`src/api/billing/charge.ts:101`) treats `null` as throw-worthy.
  The adapter's contract is undocumented.
- **Verified by:** `git grep -n 'paymentService.create' src/`
- **Needed:** Document the contract; migrate the divergent callers; possibly introduce a more explicit
  collision-detection API.
- **Severity:** MAJOR
- **Discovered during:** `feature/oauth2-pkce` (date: YYYY-MM-DD)
```

The finding is now durable. The Builder's task file can close cleanly because the finding has been promoted. The next refactor task driven by the audit will pick it up.

### Example 2: Mid-session pause

The Janitor is on batch 3 of 6 in a refactor. Their context window is getting full; they decide to pause and let a fresh session resume.

The Janitor's last actions:

```markdown
## Progress checklist

- [x] Audit read in full
- [x] Before/after state filled in
- [x] Shim contracts identified and documented
- [x] Refactor batch 1
- [x] `cmdValidateDeps` after batch 1 (output pasted)
- [x] Refactor batch 2
- [x] `cmdValidateDeps` after batch 2 (output pasted)
- [ ] Refactor batch 3 ← in progress; 4 of 12 files done
- [ ] _… per batch …_
- [ ] Final `cmdValidateDeps` clean

## Next steps

- **Resume at batch 3, file 5 of 12.** Files 1-4 are done; the rest of batch 3 is in `src/auth/middleware/`.
- Run `pnpm validate-deps` first to confirm the worktree state matches the last paste in `## Self-review`.
- After completing batch 3, run `pnpm validate-deps` and paste output as the new batch-3 checkpoint.
- Continue with batch 4: `src/api/legacy/auth.ts` and 9 others.
- Open `[pending]` assumption: "the `legacyTokenAdapter` shim can be removed in batch 6 — verify by greppping for any remaining callers before deletion".
- The audit's findings #1, #2, #4 are addressed; #3 deferred to a separate cleanup task per agent decision in `## Decisions`.
```

A fresh agent reading this can resume *exactly* where the previous session stopped. No re-discovery, no lost progress.

---

## 🔁 Lifecycle hooks

`manage-task` fires at these moments:

| Hook                  | Trigger                                  | Action                                                   |
| --------------------- | ---------------------------------------- | -------------------------------------------------------- |
| `pre-flight`          | Session start                            | Verify task file, persona, skills, source docs           |
| `pre-implementation`  | Before any code change                   | Verify `## Plan` is filled in                            |
| `progress-checkpoint` | Periodic (per task type's checkpoint frequency) | Verify checklist updated; verification output pasted |
| `pre-close`           | Agent attempts `status: done`            | Verify all gates satisfied (above)                       |
| `pre-pause`           | Session ends without `done`              | Verify `## Next steps` updated                           |

These are skill-level conventions; the agent CLI's hook system enforces them where available.

---

## See also

- [`concepts/11-session-lifecycle.md`](../concepts/11-session-lifecycle.md) — the full lifecycle
- [`concepts/03-distillation.md`](../concepts/03-distillation.md) — the promotion protocol
- [`documentation-gatekeeper.md`](documentation-gatekeeper.md) — the other always-loaded skill
- [`reference/task-base.md`](../reference/task-base.md) — the shared task skeleton
