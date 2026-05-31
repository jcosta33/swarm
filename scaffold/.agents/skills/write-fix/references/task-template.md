# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: fix

---

> 🔧 **FIX SESSION** — Verify the bug fires deterministically, verify the fix addresses the root cause, add a regression test that fails before and passes after.
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

Fix the defect described in the linked bug report. One paragraph maximum.

---

## Linked docs

- Bug report: `{{bugReportFile}}`
- Spec defining the broken behaviour (if any): `<path>`
- Related audit (if the bug intersects an audited area): `<path>`

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Verify the bug actually fires before patching (re-run the bug report's reproduction)
- The fix must address the root cause, not the symptom
- Add a regression test that fails before the patch and passes after
- Run `{{cmdValidate}}` and `{{cmdTest}}` post-patch
- No scope creep; promote unrelated findings
- **Proactively research and read related docs.** Browse `.agents/bugs/`, `.agents/specs/`, `.agents/audits/`, `docs/`, `AGENTS.md`, and the project skills directory as needed.

---

## Reproduction

Re-run the bug report's reproduction. Paste the output to confirm the bug fires in *your* worktree.

```
[paste reproduction command output — bug should fire]
```

---

## Plan

1.
2.
3.

---

## Iteration trail

(Each fix attempt is a row. When an attempt fails, write the reflection that drives the next attempt — not just *what failed* but *what that teaches*. The trail is the verbal feedback loop the next iteration reads to avoid repeating the same dead end.)

| Trial # | Hypothesis | Attempt | Outcome | Next adjustment (verbal reflection) |
| --- | --- | --- | --- | --- |
| 1 | … | … | … | — |

---

## Progress checklist

- [ ] Bug report read in full
- [ ] Reproduction re-run; bug fires (output pasted)
- [ ] Root cause verified at file:line cited in the bug report
- [ ] Patch implemented at the root cause
- [ ] Regression test added (fails before patch — verified by patching out and re-running test)
- [ ] Regression test passes after patch
- [ ] `{{cmdValidate}}` clean
- [ ] `{{cmdTest}}` clean
- [ ] No scope creep; findings promoted
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Root-cause coverage answered
- [ ] Self-review: Regression test integrity answered
- [ ] Self-review: Side effects answered
- [ ] Self-review: Related defects answered

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

> **Hard gate.** Every question below has a written answer directly beneath it. A fix that addresses the symptom rather than the cause leaves the bug latent — review as a senior engineer hostile to "looks fine" closures.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Pre-patch reproduction (the bug actually fires in this worktree):
- Post-patch reproduction (the bug no longer fires):
- Regression test FAILS before the patch (patch out the fix, run the regression test, paste the failing output):
- Regression test PASSES after the patch (`{{cmdTest}}` on the regression test, paste the passing output):
- `{{cmdValidate}}` (last 2 lines):
- `{{cmdTest}}` (last 2 lines):
- `git diff --stat`:

### Root-cause coverage

- Did I patch the root cause cited in the bug report (file:line), or did I suppress a symptom elsewhere? Could the bug recur via a different path under the same root cause?
  Answer:

### Regression test integrity

- Does the regression test fail when I patch out my fix? Did I verify (paste the failing-test output)?
  Answer:

### Side effects

- Did the patch change behaviour anywhere else? Did `{{cmdTest}}` pass for the rest of the suite, not just the regression test?
  Answer:

### Related defects

- The bug report listed related defects nearby. Did I check whether any are now triggered or fixed by my patch? Did I leave them as documented work for follow-up?
  Answer:

### Final Polish

- Did you ask yourself: "Is this fix the *minimum* fix? Did I sneak in a 'small improvement' that changes behaviour beyond the bug?"
  Answer:
