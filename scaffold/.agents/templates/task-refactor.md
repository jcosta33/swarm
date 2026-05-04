# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: refactor

---

> 🔒 **REFACTOR SESSION** — Run `{{cmdValidateDeps}}` after every 10 files modified. Behavior changes are STRICTLY FORBIDDEN.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Janitor** persona.

---

## Objective

Refactor modules to address the audit's prioritised findings without altering external API contracts. One paragraph maximum.

---

## Linked docs

- Audit: `{{auditFile}}`
- Related ADRs: `<path>`

---

## Required skills

- `manage-task`
- `documentation-gatekeeper`
- `personas` → The Janitor
- `write-refactor`
- `empirical-proof`

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Run `{{cmdValidateDeps}}` after every 10 files modified (or at the audit's chosen checkpoint frequency)
- Behaviour preservation is non-negotiable
- Document every shim contract before touching consumers
- Prove deletion safety via exhaustive search (grep for callers + check for dynamic dispatch)
- No new features; promote findings to upstream audit
- **Proactively research and read related docs.** Browse `.agents/audits/`, `.agents/specs/`, `.agents/research/`, `docs/`, `AGENTS.md`, and `.agents/skills/` as needed.

---

## Before / after state

<before_state>

[describe the structural state being refactored from — module layout, key types, problematic patterns]

</before_state>

<after_state>

[describe the structural state being refactored to — same module list with the changes applied]

</after_state>

---

## Shim contracts

<shim_contracts>

Every compatibility shim added during the refactor. Document the contract before adding it.

| Shim path | Forwards to | Removable when |
| --------- | ----------- | -------------- |
|           |             |                |

</shim_contracts>

---

## Plan

(Step-by-step. Identify which audit findings are addressed.)

1.
2.
3.

---

## Progress checklist

- [ ] Audit read in full
- [ ] Before/after state filled in
- [ ] Shim contracts identified and documented
- [ ] Refactor batch 1
- [ ] `{{cmdValidateDeps}}` after batch 1 (paste output)
- [ ] Refactor batch 2
- [ ] `{{cmdValidateDeps}}` after batch 2 (paste output)
- [ ] _… per batch …_
- [ ] Final `{{cmdValidateDeps}}` clean
- [ ] `{{cmdTypecheck}}` clean
- [ ] `{{cmdTest}}` clean (no behavioural drift)
- [ ] Findings promoted to audit
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Behavior preservation answered
- [ ] Self-review: Architectural cleanliness answered
- [ ] Self-review: Shim hygiene answered
- [ ] Self-review: Deletion safety answered
- [ ] Self-review: Scope answered

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

- ***

## Self-review

<self_review>

Stop. A refactor that changes behaviour silently is a rewrite in disguise. Act as a senior engineer hostile to behavioural drift.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Per-checkpoint `{{cmdValidateDeps}}` outputs:
- Final `{{cmdValidateDeps}}` (last 2 lines):
- `{{cmdTypecheck}}` (last 2 lines):
- `{{cmdTest}}` (last 2 lines):

### Behavior preservation

- Are the test results before and after the refactor identical? If tests changed, do the changes reflect mechanical adaptation (e.g., import paths) or behavioural drift?
  Answer:

### Architectural cleanliness

- Zero new architectural violations? Did the validation pass at every checkpoint, or did issues accumulate?
  Answer:

### Shim hygiene

- Every shim documented? Every shim has a verifiable removal criterion?
  Answer:

### Deletion safety

- For every deleted symbol, did I grep for callers and check for dynamic dispatch? Is the proof recorded?
  Answer:

### Scope

- Anything in the old location that should have moved? Anything moved that shouldn't have? Did "while I'm here" creep in?
  Answer:

### Final Polish

- Did you ask yourself: "What changed besides what I intended? What is now subtly different that the test suite doesn't cover?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
