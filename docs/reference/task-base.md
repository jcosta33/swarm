# 📖 Reference: Task base skeleton

> The shared sections every task template includes. Type-specific templates extend this base; this doc is the canonical statement of what every task file looks like.

---

## 📐 The skeleton

```markdown
# {{title}}

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

> 🔒 / ⚠️ / 🧪 / 📚 **<TASK TYPE> SESSION** — short descriptor of the session's discipline
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **<Persona name>** persona.

---

## Objective

What is true when this task is done. One paragraph maximum.

---

## Linked docs

- Source doc: `{{specFile}}` (or `{{auditFile}}`, `{{bugReport}}`, etc.)
- Related research / audit / ADR / constitution: `<paths>`
- (Other relevant artefacts.)

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
- (Task-type-specific constraints — e.g., "no source file changes" for read-only sessions; "run cmdValidate after every batch" for code-producing sessions.)
- (Persona's forbidden actions, copied or summarised.)
- **Proactively research and read related docs.** (Permitted directories listed.)

---

## (Type-specific blocks)

Per task type:

- `feature`: (no extra blocks beyond Objective + Linked docs)
- `fix`: `## Reproduction` block
- `refactor`: `## Before / after state`, `## Shim contracts`
- `rewrite`: `## Behavior delta`, `## Acceptance criteria`, `## Module plan`
- `migration`: `## Migration source and target`, `## Wave plan`, `## Compatibility shims`, `## Callsite tracker`
- `performance`: `## Baseline`, `## Target`, `## Hypothesis`, `## Measurement protocol`
- `testing`: `## Coverage gap`, `## Test cases`, `## Test placement`
- `documentation`: `## Doc target`, `## Source material`, `## Examples to verify`
- `orchestration`: `## Worker tracker`, `## Kickback queue`, `## Merge log`
- `review`: `## Diff overview`, `## Findings`, `## Verdict`
- `kickback`: `## Kickback items` (queue from Skeptic notes)
- `bug-report-writing`: `## Reported behavior`, `## Reproduction attempts`, `## Reliable reproduction`, `## Hypothesis tracker`, `## Root cause`
- `audit-writing`: `## Goal`, `## Scope`, `## Code paths to inspect`
- `spec-writing`: `## Pattern survey`
- `research-writing`: `## Research question`, `## Sources to consult`, `## Findings outline`

---

## Plan

(Step-by-step, written before implementation begins.)

---

## Progress checklist

(Discrete items, marked as they complete.)

- [ ] (item)

---

## Decisions

(Significant choices made during the session, with rationale.)

- ***

---

## Findings

(Codebase discoveries worth preserving. Promote durable findings to upstream docs before close.)

- ***

---

## Assumptions

(Every assumption marked `[pending]` or `[confirmed]`.)

- [pending]

---

## Blockers

(Anything preventing confident progress, recorded immediately.)

- ***

---

## Next steps

(Concrete starting points if the session ends incomplete.)

- ***

---

## Self-review

<self_review>

(Persona-specific framing — see each task page for the questions.)

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- (per-task slot list)

### (persona-specific Self-review questions)

- ...

### Final Polish

- (the standing "what did I leave behind" question)

Only when every answer above is written is this task complete.

</self_review>
```

---

## 🪞 Sections that are deterministic from the task type

The launcher (CLI or human) fills these in automatically:

- `## Metadata` — fully filled (slug, branch, etc.)
- `> 🔒 ⚠️` markers and `> **PERSONA:**` blockquote — set by task type
- `## Required skills` — set by task type
- `## Constraints` — base constraints + persona's forbidden actions
- `## Validation gates` slot list — set by task type
- `## Self-review` skeleton with persona-specific questions — set by persona

---

## 🪞 Sections the agent fills in

- `## Objective` (rephrased from source doc)
- `## Linked docs` (the launcher provides the primary; the agent adds related)
- `## Plan`
- `## Progress checklist` (the agent ticks off as they go)
- `## Decisions`
- `## Findings`
- `## Assumptions`
- `## Blockers`
- `## Next steps`
- `## Self-review` answers + verification outputs

---

## See also

- [`tasks/`](../tasks/) — every per-task template extends this base
- [`document-base.md`](document-base.md) — the doc equivalent
- [`template-placeholders.md`](template-placeholders.md) — what `{{slug}}`, `{{cmdX}}`, etc. mean
- [`skills/manage-task.md`](../skills/manage-task.md) — the skill that owns this skeleton
