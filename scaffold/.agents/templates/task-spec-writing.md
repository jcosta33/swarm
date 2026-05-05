# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: spec-writing

---

> 🔒 **SPEC-WRITING SESSION** — This session produces a spec, not code. You may NOT modify any source files, configuration files, or dependencies. Output: `.agents/specs/{{slug}}.md`. Halt on `[CRITICAL]` open questions.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Architect** persona.

---

## Objective

What capability is being specified and what decision it informs. One paragraph maximum.

---

## Linked docs

- Triggering ask: `{{specFile}}` (or describe the human's prompt if none)
- Upstream research (if any): `<path>`
- Upstream audit (if any): `<path>`
- Related ADRs: `<path>`
- Constitution (if applicable): `.agents/constitution.md`

---

## Spec output

Write your spec to: `.agents/specs/{{slug}}.md`
Use the spec template at `.agents/templates/spec.md`.
Load `.agents/skills/write-spec/SKILL.md` before starting.

> ⚠️ **VERIFIABILITY OVER COMPLETENESS.** Every requirement is testable. Mark wishes as wishes; rewrite them as testable requirements or remove them.

---

## Constraints

- **No source file changes — spec document only**
- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Survey existing patterns before introducing new ones
- Identify all downstream dependencies a change will break before the change ships
- Document structural decisions rigorously (alternatives considered, alternatives rejected, with reasoning)
- Halt on `[CRITICAL]` open questions; do not proceed
- Use Distillation Loss Statements when distilling from research
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/audits/`, `.agents/research/`, `.agents/adrs/`, `docs/`, `AGENTS.md`, and source code (read-only).

---

## Pattern survey

<pattern_survey>

Existing helpers, modules, or patterns consulted to ensure the spec doesn't reinvent. Listed inline or here for the reviewer's traceability.

- `<path>:<line>` — what was reviewed and how it informs the spec

</pattern_survey>

---

## Progress checklist

- [ ] Load `.agents/skills/write-spec/SKILL.md`
- [ ] Load `.agents/skills/distillation-discipline/SKILL.md`
- [ ] Read upstream sources (research, audit) in full
- [ ] Survey existing patterns; record consulted modules
- [ ] Draft the spec's `## Goal`, `## Scope`, `## User-visible behaviour`, `## Acceptance criteria`
- [ ] Draft `## Design decisions` with named alternatives + reasoning
- [ ] Identify and flag `[CRITICAL]` and `[MINOR]` open questions
- [ ] Distillation Loss Statement (if distilling from research)
- [ ] Write the spec at `.agents/specs/{{slug}}.md`
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Read-only constraint answered
- [ ] Self-review: Implementability answered
- [ ] Self-review: Verifiability answered
- [ ] Self-review: Pattern survey answered
- [ ] Self-review: `[CRITICAL]` open questions answered

---

## Decisions

- ***

## Findings

(Session-level meta-observations. Durable findings about the area being specced go in the spec itself.)

- ***

## Assumptions

- [pending]

---

## Blockers

(Including `[CRITICAL]` open questions that halt the spec.)

- ***

## Next steps

- ***

## Self-review

<self_review>

Stop. A spec a Builder can't implement from sends every downstream session in the wrong direction. Act as a senior engineer about to greenlight this spec for implementation, looking for what's missing.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →

### The read-only constraint — check this first

- Any modified source/config/dependency files in `git status`? A spec session produces one output: the spec doc. Revert anything else immediately.
  Answer:

### Implementability

- Could a Builder implement from this spec with no follow-up questions? If they'd need to ask, the spec is incomplete. Pick the most ambiguous-feeling acceptance criterion: would a Builder know exactly what to build?
  Answer:

### Verifiability

- Is every requirement testable? Could a Test Author write a test that distinguishes "satisfies" from "doesn't"? Are there any "the system should be fast"-style requirements?
  Answer:

### Pattern survey

- Did the survey actually happen? Are reuse decisions justified? Are there existing helpers the spec re-implements unintentionally?
  Answer:

### `[CRITICAL]` open questions

- Are all `[CRITICAL]` open questions resolved (or the spec halted)? Did I push past one with a "will figure out at implementation" framing?
  Answer:

### Distillation Loss Statement (if distilling from research)

- Is the Loss Statement complete? Does it state what was dropped and why the next stage doesn't need it?
  Answer:

### Final Polish

- Did you ask yourself: "What requirement did I assume the Builder would infer?" Inference is the failure mode the spec exists to prevent.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
