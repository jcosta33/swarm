# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: rewrite

---

> ⚠️ **REWRITE SESSION** — Distinct from refactor. A refactor preserves behavior; a rewrite may change it. Make the behavior delta explicit before changing code, and update the spec to reflect the new behavior.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Builder** persona.

---

## Objective

What is being rewritten and what behavior changes (or stays the same). One paragraph maximum.

---

## Linked docs

- Spec: `{{specFile}}`
- Audit (if rewrite was prompted by one): `<path>`

---

## Behavior delta

<behavior_delta>

The explicit list of behavior changes. Anything not listed here must be preserved.

| Aspect | Before | After |
| ------ | ------ | ----- |
|        |        |       |

</behavior_delta>

---

## Acceptance criteria

<acceptance_criteria>

Derived from the spec. Each criterion is a checkbox — all must be checked before this task is done. Include explicit "preserves prior behavior X" criteria for the parts that don't change.

- [ ]
- [ ]

</acceptance_criteria>

---

## Module plan

<module_plan>

Which modules will be touched and what changes in each.

| Module | Change | Behavior change? |
| ------ | ------ | ---------------- |
|        |        |                  |

</module_plan>

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Run `{{cmdValidate}}` after every batch of changes
- Behavior changes are restricted to the Behavior Delta table above; everything else must be preserved
- If a behavior change emerges that isn't in the delta, stop and update the spec before continuing
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/research/`, `.agents/bugs/`, `docs/`, `AGENTS.md`, and `.agents/skills/` as needed.

---

## Progress checklist

- [ ] Read spec in full
- [ ] Fill in behavior delta above
- [ ] Fill in acceptance criteria above
- [ ] Fill in module plan above
- [ ] Identify all callers affected by behavior changes
- [ ] Implement
- [ ] Update tests for new behavior
- [ ] Verify preserved behaviors still work (regression tests)
- [ ] `{{cmdValidate}}` passes
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Behavior delta integrity answered
- [ ] Self-review: Caller migration answered
- [ ] Self-review: Architecture answered
- [ ] Self-review: Conventions answered
- [ ] Self-review: Primary deliverable and related work answered
- [ ] Self-review: Completeness answered

---

## Decisions

- ***

## Findings

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

Concrete starting points for the next session if this one ends incomplete.

- ***

## Self-review

<self_review>

Stop. Rewrites are riskier than refactors precisely because behavior is permitted to change — and so unintended changes hide more easily. Act as a senior engineer doing an adversarial review.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- `{{cmdValidate}}` (last 2 lines):
- `{{cmdTest}}` (last 2 lines):

### Behavior delta integrity

- Does every behavior change you made appear in the delta table? Did any behavior change sneak in that wasn't planned? Were preserved behaviors actually preserved (paste the regression test output that proves it)?
  Answer:

### Caller migration

- Did you identify every caller of the rewritten code? Did you update each one for the new behavior, or verify each one still works under the preserved behavior? Did you grep across the whole codebase, not just the module under change?
  Answer:

### Architecture

- Zero validation errors? Any new architectural violations introduced while restructuring?
  Answer:

### Conventions

- Did you accidentally violate any project convention while rewriting? Did the rewrite fall back to default-helpful patterns instead of project-specific ones?
  Answer:

### Primary deliverable and related work

- The behavior delta is the contract. If you fixed or improved something beyond it, note it in **Findings** or **Decisions** so reviewers can follow the branch. Do not revert correct work only because it was extra.
  Answer:

### Completeness

- Is anything left stubbed, TODO'd, or half-rewritten? Would the next developer be able to continue from this task file alone?
  Answer:

### Final Polish

- Did you ask yourself: "What else could I do? How can I make this even better, more stable, or more bug-free?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
