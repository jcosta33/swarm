# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: audit
- Deliverable path: `.agents/audits/{{slug}}.md`

---

> 🔒 **AUDIT SESSION** — Produces an audit document, not code. No source/config/dependency changes. Copy `## Deliverable` to the path above at close (or keep this file as the deliverable).
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

What area, goal, or initiative this audit covers and why it is being audited now. One paragraph maximum.

---

## Linked docs

- Triggering ask: `{{specFile}}` (or describe the human's prompt if none)
- Prior audit (if deepening): `<path>`

---

## Constraints

- **No source file changes — audit document only.** Work only inside this worktree; do not switch branches, merge, rebase, or push unless instructed.
- Cite file and line for every finding; vague observations get demoted
- Verify dynamic invariants, not just static text — concurrency, lifecycle, resource cleanup
- Search for "no callers anywhere" — dead code labelled as working is itself a finding
- **Proactively research and read related docs** under `.agents/audits/`, `.agents/specs/`, `.agents/research/`, `docs/`, `AGENTS.md`, and the project skills directory.

---

## Progress checklist

- [ ] Define the goal and scope inside the deliverable below
- [ ] List the code paths in the deliverable
- [ ] Inspect the code with the prior audit closed (if deepening)
- [ ] Inspect the code: read each path adversarially
- [ ] Verify cited file:line references for any prior audit
- [ ] Run cross-module caller searches for any public surface
- [ ] Run the project's validation command (`AGENTS.md` > `Commands` > `Validation`) to surface architectural issues
- [ ] Draft findings, distinguishing observations from issues
- [ ] Number open issues with file:line references and "Needed" entries
- [ ] Prioritise issues by impact
- [ ] Document risks and suggested approaches
- [ ] Self-review: every question answered
- [ ] Copy the `## Deliverable` block to its final home

---

## Deliverable

> Copy everything between this line and the `--- END DELIVERABLE ---` marker into `.agents/audits/{{slug}}.md` at session close, demoting headings as needed.
>
> ⚠️ **ADVERSARIAL ANALYSIS — ALWAYS.** Do not trust that existing code works as intended. Hunt for architectural violations, edge cases, race conditions, and unhandled failures. Assume the codebase is hiding its flaws from you. The audit is honest observation, not narrative validation.

### Status — Active / Resolved

### Context

Why this audit exists. The triggering ask, the goal it serves.

### Linked docs

- Triggering brief / ask: <path or paragraph>
- Prior audit (if deepening): `.agents/audits/<prior-slug>.md`
- Related specs: `.agents/specs/<slug>.md`

### Goal

What "good" looks like for this area. Without a goal, "current state" has no meaning.

### Scope

- **In scope:** (specific code paths under audit)
- **Out of scope:** (related areas explicitly excluded)

### Code paths inspected

- `<path>` — <one-line description of what's there>

### Findings

Each finding has: severity (BLOCKER / MAJOR / MINOR), file:line, observation, and a **Needed** — the concrete change that would close it.

#### Issue 1 — <name> [SEVERITY]

- **File:line:** `<path>:<line>`
- **Observation:** <what is true today>
- **Needed:** <what change closes this>
- **Verified by:** <grep results, validation output, or other evidence>

#### Issue 2 — ...

### Risks

(Things that could go wrong but weren't observed firing yet. Each risk states the conditions under which it would fire.)

### Suggested approaches

(How a downstream task could address the findings. Suggest the *approach*, not the implementation. Sequence if multiple approaches interact.)

### Open questions

- [ ] **[CRITICAL]** Questions that would change the audit's prioritisation if answered.
- [ ] **[MINOR]** Worth recording.

### Distillation Loss Statement

(If distilled from a long-running investigation or a prior audit.) **Dropped:** <what>. **Why downstream doesn't need it:** <why>.

--- END DELIVERABLE ---

---

## Decisions

(Session-level choices — distinct from the deliverable.)

- ***

## Findings (session meta)

(Process-level notes — distinct from the deliverable's audit findings.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

- *** (concrete starting points if this session ends incomplete)

---

## Self-review

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. An unanswered question is a skipped check. Review as a senior engineer about to greenlight this audit as input to refactor or spec work — look for what the audit does *not* say.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` → (must show only the audit doc; revert anything else immediately — audit sessions are read-only)
- `{{cmdValidate}}` (last 2 lines):
- `{{cmdValidateDeps}}` (last 2 lines):

### Goal and scope

- Is the goal stated as a measurable target rather than vague intention? Is the scope tight enough that a downstream refactor session can act on the audit without the scope expanding under their feet?
  Answer:

### Finding specificity

- Does every finding cite file and line? Does every open issue have a "Needed" — a concrete change that would close it? Are vague concerns either sharpened or removed?
  Answer:

### Severity calibration

- Are issues prioritised by impact, not by order of discovery? Did you promote issues that compound and demote issues that read scary but cannot fire? Have you cited the reasoning for each promotion/demotion?
  Answer:

### Adversarial completeness

- Did you read the code with the prior audit (if any) closed? Did you find issues the prior audit missed? Did you grep for callers across the codebase, not just the audited module? Did you verify dynamic invariants, not just compile-time text?
  Answer:

### Final Polish

- Did you ask yourself: "What is the audit not saying? What invariants did I assume held without checking?"
  Answer:
