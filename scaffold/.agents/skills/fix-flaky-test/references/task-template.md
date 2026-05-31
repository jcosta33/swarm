# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: fix-flaky-test

---

> 🎲 **FLAKY TEST SESSION** — Reproduce before fixing. Categorise. Fix the root cause, not the assertion. Reject sleep-as-fix and quarantine-as-fix. Verify with a loop-run, not a single green tick.
>
> **AGENTS.md:** the test command resolves via `AGENTS.md > Commands > Test`. The loop-runner invocation (e.g. `--repeat=500`, parallel matrix) is not in the standard contract — ask the user how the project loops a single test. If `AGENTS.md` is missing or the test command is undefined, ask before declaring the reproduction reliable.

---

## Objective

The single test (or test family) being stabilised, in one sentence. *Example: "Stabilise `LoginFlow > redirects after auth` which fails ~3% of CI runs."*

---

## Linked docs

- Test file: `<path>:<line>`
- CI failure links / logs (most recent N): `<paths or URLs>`
- Related bug-report (if applicable): `<path>`

---

## Constraints

- Reproduce before fixing — no diagnosis on suspicion alone
- Fix the root cause; never accommodate the nondeterminism in the assertion
- No `await sleep(N)` patches unless timing is part of the system's documented contract
- No quarantine (`.skip`, `.fail`, conditional `it.if`) as the resolution; quarantine without a tracking issue and a date is forbidden
- Verification requires a loop-run (typically 100×, often 500–1000×) with all runs passing
- If the root cause is in production code, surface it as a separate fix task — do not patch production code from inside this task

---

## Test under stabilisation

- **Test:** `<path>:<test name>` · **Observed failure rate:** `<%>` (e.g. ~3% of CI runs)
- **First observed:** `<sha or date>` · **Currently quarantined?** yes / no

---

## Flake category

(Pick exactly one. Mixed-category flakes split into separate task files.)

- [ ] **Timing / ordering** — depends on a `setTimeout`, unbounded poll, or operation-order assumption
- [ ] **Shared state** — module-level state, singleton caches, fixtures mutated by sibling tests
- [ ] **Network / external service** — real HTTP, real DNS, unmocked clock, flaky test container
- [ ] **Randomness** — unmocked `Math.random`, unseeded UUID, unseeded shuffle
- [ ] **Time** — unmocked `Date.now`, time-of-day, DST boundary
- [ ] **Resource exhaustion** — file handles, ports, DB connections, memory under parallel runs
- [ ] **Environment** — locale, timezone, hostname, env vars, terminal width, ANSI

---

## Reproduction protocol

(The exact command run repeatedly to fire the flake. Replace with the project's loop-runner per `AGENTS.md` / user.)

```bash
{{cmdTest}} --repeat=500 --testNamePattern="<test name>"
# or under load: parallel-runner -j 8 -- {{cmdTest}} --testNamePattern="<test name>"
```

| Target | Run-environment matrix | Conditions verified |
| --- | --- | --- |
| 500× local + 500× CI matrix | timezone, env vars, no network · parallel sibling tests, real network |

---

## Reproduction evidence

(Paste the loop-run output that fires the flake. Last 30 lines or pass/fail summary; do not paraphrase.)

```text
<paste>
```

- Loop runs: 500 · Failures observed: … · Failure rate: … % · Failure modes seen: assertion / error / hang

---

## Hypothesis tracker

(Each suspected cause is a row. State, verify, and — if rejected — record what the failed attempt teaches the next one.)

| # | Hypothesis | How to verify | State (`unverified` / `confirmed` / `rejected`) | Next adjustment (if rejected) |
| --- | --- | --- | --- | --- |
| 1 | … | … | unverified | — |

---

## Root cause

(One paragraph. The actual mechanism producing the flake. Cite file:line. *Symptom* and *cause* must not be the same statement.)

- **Symptom:** `<what fails, where>` — `<file>:<line>`
- **Cause:** `<the actual mechanism>` — `<file>:<line>`

---

## Plan

1. Reproduce the flake using the protocol above; record failure rate
2. Categorise the source; pick exactly one category
3. Form hypotheses; verify each by altering one variable at a time
4. Find the root cause in production code or test setup (not the assertion)
5. Apply the fix; document the cause inline
6. Verify with a loop-run of the same shape that reproduced the flake
7. If the root cause lives in production code, surface it as a separate fix task — do not patch production code from inside this task

---

## Progress checklist

- [ ] Flake reproduced (failure rate measured)
- [ ] Category identified
- [ ] Hypotheses tracked; each verified or rejected with evidence
- [ ] Root cause identified at file:line
- [ ] Fix targets the cause, not the assertion
- [ ] No `sleep` / timeout-bump patches (unless timing is contractual)
- [ ] No quarantine as the resolution
- [ ] Inline note added so the failure mode is recognisable next time
- [ ] Verification loop-run executed (typically 500×); all runs pass
- [ ] Full `{{cmdTest}}` suite still passes (the fix did not break sibling tests)
- [ ] If cause is in production code, a separate fix task has been surfaced
- [ ] Self-review answered

---

## Fix evidence

(Paste the verification loop-run output. Last lines or pass/fail summary.)

```text
<paste>
```

- Loop runs after fix: 500 · Failures: 0 · Failure rate: 0 % · Stability gain: from `<%>` to 0

---

## Decisions

(Significant choices made during stabilisation — e.g., mocking the system clock vs. seeding random.)

- ***

## Findings

(Codebase discoveries worth preserving — e.g., a sibling test touching the same shared state, an unmocked dependency probably affecting other tests. Promote durable findings to upstream docs before close.)

- ***

## Assumptions

- [pending]

---

## Blockers

- *** (anything preventing confident progress; flakes resisting 1000× reproduction go here with conditions tried)

## Next steps

- *** (concrete starting points if incomplete; typically a separate fix task for production-code races, or a codebase-wide audit if the flake category recurs)

---

## Self-review

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. An unanswered question is a skipped check.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Reproduction loop-run before the fix (the flake fires — last 30 lines / pass-fail summary) →
- Verification loop-run after the fix (same loop shape that reproduced the flake, all runs pass — last 30 lines / pass-fail summary) →
- Full `{{cmdTest}}` after the fix (the rest of the suite still passes — last 2 lines):

### Reproduction

- Flake reproduced before any fix attempt — failure rate over how many loop runs?
  Answer:

### Categorisation

- Flake category named exactly (one of the seven)? Mixed-category flakes split?
  Answer:

### Root cause vs symptom

- Is the patch on the *cause* or the *symptom*? Any "fix the assertion" temptations rejected?
  Answer:

### Sleep / quarantine rejection

- Fix avoids `sleep`, timeout-bumps, quarantine? If sleep used, on which documented async contract?
  Answer:

### Verification

- Loop-run of the same shape that reproduced the flake (typically 500×) passed with zero failures? Output pasted into `## Fix evidence`?
  Answer:

### Inline documentation

- One-line note in the test or production code naming the failure mode, so the next contributor recognises it?
  Answer:

### Production-code handoff

- If root cause is in production code, separate fix task surfaced with the now-stable test as the regression?
  Answer:

### Final Polish

- "Did I actually verify with a loop-run, or did I get one green tick and call it done?"
  Answer:
