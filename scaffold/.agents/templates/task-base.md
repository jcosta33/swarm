# {{title}}

> This file documents the **shared task skeleton** every type-specific task template extends. It is not itself launched as a task — type-specific templates (`task-feature.md`, `task-fix.md`, etc.) include these sections plus their own additions.

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: <task-type>

---

> 🔒 / ⚠️ / 🧪 / 📚 **<TASK TYPE> SESSION** — short descriptor of the session's discipline.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **<Persona name>** persona.

---

## Objective

What is true when this task is done. One paragraph maximum.

---

## Linked docs

- Source doc: `{{specFile}}` (or `{{auditFile}}`, `{{bugReport}}`, etc.)
- Related research / audit / ADR / constitution: `<paths>`

---

## Required skills

- `manage-task`
- `documentation-gatekeeper`
- `personas` → <Persona>
- (task-type-specific skills, e.g., `write-feature`, `empirical-proof`)

---

## Domain skills

- (Project-specific skills determined by description-matching to the work.)

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- (Task-type-specific constraints)
- (Persona's forbidden actions, summarised)
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/audits/`, `.agents/research/`, `.agents/bugs/`, `docs/`, `AGENTS.md`, and `.agents/skills/` as needed.

---

## (Type-specific blocks)

Per task type, additional sections are inserted here. See:

- `task-feature.md`: (no extra blocks beyond Objective + Linked docs)
- `task-fix.md`: `## Reproduction`
- `task-refactor.md`: `## Before / after state`, `## Shim contracts`
- `task-rewrite.md`: `## Behavior delta`, `## Acceptance criteria`, `## Module plan`
- `task-migration.md`: `## Migration source and target`, `## Wave plan`, `## Compatibility shims`, `## Callsite tracker`
- `task-performance.md`: `## Baseline`, `## Target`, `## Hypothesis`, `## Measurement protocol`
- `task-testing.md`: `## Coverage gap`, `## Test cases`, `## Test placement`
- `task-documentation.md`: `## Doc target`, `## Source material`, `## Examples to verify`
- `task-orchestration.md`: `## Worker tracker`, `## Kickback queue`, `## Merge log`
- `task-review.md`: `## Diff overview`, `## Findings`, `## Verdict`
- `task-bug-report.md`: `## Reported behavior`, `## Reproduction attempts`, `## Reliable reproduction`, `## Hypothesis tracker`, `## Root cause`
- `task-audit.md`: `## Goal`, `## Scope`, `## Code paths to inspect`
- `task-research.md`: `## Research question`, `## Sources to consult`, `## Findings outline`

---

## Plan

(Step-by-step, written before implementation begins.)

1.
2.
3.

---

## Progress checklist

(Discrete items, marked as they complete.)

- [ ] (item)

---

## Decisions

(Significant choices made during the session, with rationale.)

- ***

## Findings

(Codebase discoveries worth preserving. Promote durable findings to upstream docs before close.)

- ***

## Assumptions

(Every assumption marked `[pending]` or `[confirmed]`.)

- [pending]

---

## Blockers

(Anything preventing confident progress, recorded immediately.)

- ***

## Next steps

(Concrete starting points if the session ends incomplete.)

- ***

---

## Self-review

<self_review>

(Persona-specific framing — see each task template for the questions.)

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- (per-task slot list)

### (persona-specific Self-review questions)

- ...

### Final Polish

- (the standing "what did I leave behind" question)

Only when every answer above is written is this task complete.

</self_review>
