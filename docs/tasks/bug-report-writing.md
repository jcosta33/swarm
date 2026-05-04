# 📋 Task: bug-report-writing

> **TL;DR.** Reproduce a defect deterministically, isolate the root cause, and produce a `bug-report.md` a fixer can act on. Lead persona is The Bug Hunter. Read-only on source code (the fix is downstream). Distinguish observation from inference.

---

## 🎯 When to use

A `bug-report-writing` task is right when:

- A defect has been reported (by a human, by a CI failure, by an agent observation).
- The report is incomplete (no reliable reproduction, no root cause).
- The downstream task is `fix` (which adopts The Skeptic mindset).

If the report already has a deterministic reproduction and a verified root cause, skip straight to `fix`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | Human report / agent observation                   |
| **Lead persona**     | [The Bug Hunter](../personas/the-bug-hunter.md)   |
| **Output**           | `bug-report.md` at `.agents/bugs/{{slug}}.md`      |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-bug-report`, `adversarial-review`, `empirical-proof` |
| **Verification gate slots** | post: `git status` (clean — no source changes), reproduction-output proof |

---

## 📐 Template

````markdown
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

---

> 🔒 **BUG-REPORT SESSION** — This session produces a bug report, not a fix. You may explore, reproduce, and isolate, but you may NOT modify code to fix the bug. Output: `.agents/bugs/{{slug}}.md`. The fix happens in a downstream task driven by this report.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Bug Hunter** persona.

---

## Objective

What problem is being investigated and what the report must contain. One paragraph maximum. The deliverable is a bug report a fixer can act on without re-discovering the cause.

---

## Linked docs

- Reported by / triggering ask: `{{specFile}}` (or describe the human's prompt)

---

## Bug report output

Write your bug report to: `.agents/bugs/{{slug}}.md`
Use the bug-report template at `.agents/templates/bug-report.md`.
Load `.agents/skills/write-bug-report/SKILL.md` before starting.

> ⚠️ **REPRODUCE BEFORE YOU EXPLAIN.**
> A bug is a hypothesis until reproduced. The reported symptom is a clue, not a description of the bug. The root cause is rarely where the symptom appears. If you cannot reproduce, say so — do not speculate about cause.

---

## Reported behavior

<reported_behavior>

What the human or agent observed. Quote or paraphrase the original report.

</reported_behavior>

---

## Reproduction attempts

<reproduction_attempts>

Each attempt as you make it. Mark each `[reproduces]` / `[does not reproduce]` / `[partial]`.

1. _Steps:_ ... _Result:_ ... _[status]_
2.

</reproduction_attempts>

---

## Reliable reproduction

<reliable_reproduction>

The minimal, deterministic reproduction. Once found, all other attempts are noise.

**Steps:**

1.
2.
3.

**Expected:**

**Actual:**

**Conditions:** environment, version, config that affect reproducibility.

</reliable_reproduction>

---

## Hypothesis tracker

<hypothesis_tracker>

Each hypothesis you test. Mark `[disproven]` / `[supports]` / `[confirmed]` / `[unverified]`.

1. _Hypothesis:_ ... _Evidence:_ ... _[status]_
2.

</hypothesis_tracker>

---

## Root cause

<root_cause>

[pending — fill in once located]

State the root cause precisely: file, line, what state combines with what input to produce the symptom. "The function returns null" is not a root cause; "X mutates Y under condition Z, causing the null path to fire when caller W invokes it from context V" is.

</root_cause>

---

## Constraints

- **No source file changes — bug report document only**. The fix is a downstream task; this session writes the report
- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Reproduce before explaining; if you cannot reproduce, say so
- Distinguish observation from inference clearly
- **Proactively research and read related docs.** Browse `.agents/audits/`, `.agents/specs/`, `.agents/research/`, `.agents/bugs/`, and `docs/` as needed.

---

## Progress checklist

- [ ] Load `.agents/skills/write-bug-report/SKILL.md`
- [ ] Load `.agents/skills/adversarial-review/SKILL.md`
- [ ] Capture the reported behavior verbatim
- [ ] Attempt reproduction; record every attempt
- [ ] Find a reliable, minimal reproduction
- [ ] Form hypotheses; test each
- [ ] Identify the root cause (file, line, conditions)
- [ ] Search for related defects nearby
- [ ] Run the project's tests to identify regression coverage gaps
- [ ] Write the bug report at `.agents/bugs/{{slug}}.md`
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Read-only constraint answered
- [ ] Self-review: Reproduction reliability answered
- [ ] Self-review: Root cause depth answered
- [ ] Self-review: Related defects answered
- [ ] Self-review: Fixer readiness answered

---

## Decisions

- ***

## Findings

(Session-level meta-observations. Durable findings about the bug or related code go in the bug report itself.)

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

Stop. A bug report that gets the cause wrong wastes the fixer's session and lets the bug ship to production. Act as a senior engineer about to assign this report to a fixer, looking for the parts that could mislead them.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Reproduction command output (the bug actually fires):

### The read-only constraint — check this first

- Any modified source files in `git status`? A bug-report session produces one output: the report. The fix happens in a separate task.
  Answer:

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

- Did you ask yourself: "Did I reproduce or just convince myself I did? Is the cause the cause, or just the first plausible explanation?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

See [The Bug Hunter's worked example](../personas/the-bug-hunter.md#%EF%B8%8F-example-how-the-bug-hunter-resolves-a-representative-issue) — the proxy-streaming corruption bug, with disproven and confirmed hypotheses and a related-defects search.

---

## ⚠️ Common anti-patterns

- Reporting the symptom as the bug
- Speculating about cause without reproducing
- Conflating "I think" with "I have proven"
- Bug reports that read as "module X is broken"
- Fixing the bug instead of reporting it

---

## See also

- [`personas/the-bug-hunter.md`](../personas/the-bug-hunter.md)
- [`tasks/fix.md`](fix.md) — the downstream fix task
- [`documents/bug-report.md`](../documents/bug-report.md)
- [`skills/write-bug-report.md`](../skills/write-bug-report.md)
- [`skills/adversarial-review.md`](../skills/adversarial-review.md)
- [ADR 0007](../adrs/0007-bug-report-as-meta-task.md) — why bug-report is its own task
