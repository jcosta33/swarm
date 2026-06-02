# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: bug-report
- Deliverable path: `.agents/bugs/{{slug}}.md`

---

> 🔒 **BUG-REPORT SESSION** — Produces a bug report, not a fix. Explore, reproduce, isolate; do NOT patch code. Fix happens in a downstream task driven by this report. Copy `## Deliverable` to the path above at close.
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

What problem is being investigated and what the report must contain. One paragraph maximum. The deliverable is a bug report a fixer can act on without re-discovering the cause.

---

## Linked docs

- Reported by / triggering ask: `{{specFile}}` (or describe the human's prompt)

---

## Constraints

- **No source file changes — bug-report document only.** The fix is a downstream task. Work only inside this worktree; do not switch branches, merge, rebase, or push unless instructed.
- Reproduce before explaining; if you cannot reproduce, say so
- Distinguish observation from inference clearly
- **Proactively research and read related docs** under `.agents/audits/`, `.agents/specs/`, `.agents/research/`, `.agents/bugs/`, and `docs/`.

---

## Progress checklist

- [ ] Capture the reported behaviour verbatim in the deliverable below
- [ ] Attempt reproduction; record every attempt in the deliverable's `## Reproduction attempts (history)`
- [ ] Find a reliable, minimal reproduction
- [ ] Form hypotheses in the deliverable's `## Hypothesis tracker`; test each
- [ ] Identify the root cause (file, line, conditions)
- [ ] Search for related defects nearby
- [ ] Run the project's test command (`AGENTS.md` > `Commands` > `Test`) to identify regression coverage gaps
- [ ] Self-review: every question answered
- [ ] Copy the `## Deliverable` block to its final home

---

## Deliverable

> Copy everything between this line and `--- END DELIVERABLE ---` into `.agents/bugs/{{slug}}.md` at close, demoting headings as needed. ⚠️ **REPRODUCE BEFORE YOU EXPLAIN** — a bug is a hypothesis until reproduced; the symptom is a clue, not a description. If you cannot reproduce, say so.

### Status — Active / Closed

### Context

How the bug was reported (human ticket, agent observation, CI failure). The audience for this report is the future fixer.

### Linked docs

- Reporter: <human / agent>
- Spec defining the broken behaviour (if any): `<path>`
- Related audit: `<path>`

### Reported behaviour

What the reporter observed. Quote or paraphrase.

### Reliable reproduction

(Minimal, deterministic. Once found, all other attempts are noise.)

**Steps:** 1. <step> · 2. <step> · 3. <step>

**Expected:** <what should happen> · **Actual:** <what does happen>

**Conditions:** environment, version, config that affect reproducibility.

### Reproduction attempts (history)

(Optional but useful when the reproduction was hard to find.)

| # | Steps | Result | Status |
| - | ----- | ------ | ------ |
| 1 |       |        | [reproduces / does not reproduce / partial] |

### Hypothesis tracker

Verbal-feedback loop (per Reflexion, NeurIPS 2023, arXiv:2303.11366): each disproven hypothesis records the next adjustment in writing, so the next attempt builds on the last one's signal instead of re-exploring. Append a row before testing each hypothesis; fill `Status` and `Next adjustment` after.

| # | Hypothesis | Evidence | Status                                          | Next adjustment                                            |
| - | ---------- | -------- | ----------------------------------------------- | ---------------------------------------------------------- |
| 1 |            |          | [confirmed / disproven / supports / unverified] | [what to test next given this result, or `n/a` if closed] |

### Root cause

State the cause precisely: file, line, what state combines with what input to produce the symptom. Examples:

- Bad: "The function returns null."
- Good: "`getPricing()` (`src/billing/pricing-adapter.ts:42`) returns null when the cache is cold and the upstream Stripe call is rate-limited; the caller `quote.ts:88` interprets null as 'fallback to default tier' instead of throwing."

### Related defects

Defects nearby that may share a root cause or a pattern. Note them even if out of scope for the fix.

- `<path>:<line>` — <description>

### Regression test plan

A test that sets up the conditions identified in Reliable reproduction, asserts the expected behaviour, and lives at <suggested path>. If the test runner makes this difficult, note the gap.

### Open questions

- [ ] **[MINOR]** <questions that would refine the fix's scope>

### Distillation Loss Statement

(If distilled from a long investigation.) **Dropped:** <what>. **Why downstream doesn't need it:** <why>.

--- END DELIVERABLE ---

---

## Decisions

(Session-level choices — distinct from the deliverable.)

- ***

## Findings (session meta)

(Process-level notes — distinct from the bug-report content.)

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

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. Review as a senior engineer about to assign this report to a fixer — look for parts that could mislead them.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` → (must show only the report; revert anything else immediately — bug-report sessions are read-only)
- Reproduction command output (the bug actually fires):

### Reproduction reliability

- Does the reproduction fire deterministically from a fresh checkout? Did you actually run it, or are you describing what you think would happen? Are the conditions documented (env, version, state)?
  Answer:

### Root cause depth

- Have you stated the root cause as a specific file:line interaction with state and input, or only as the symptom? Would the bug recur in a different surface area if the cause is what you say it is?
  Answer:

### Related defects

- Did you search for related defects nearby — same module, same pattern, same call site? Did you note them in the report (even if out of scope for the fix)?
  Answer:

### Fixer readiness

- Could a fixer write the patch from this report alone, with zero re-investigation? Is the test that would catch a regression identified (or noted as missing)?
  Answer:

### Final Polish

- Did you ask yourself: "Did I reproduce or just convince myself I did? Is the cause the cause, or just the first plausible explanation?"
  Answer:
