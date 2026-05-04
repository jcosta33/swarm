# 📋 Task: fix

> **TL;DR.** Repair a defect documented in a `bug-report.md`. Lead persona is The Skeptic — root-causing demands hostility toward plausible-sounding explanations. Output: code patch + regression test + handoff back to The Skeptic for re-review.

---

## 🎯 When to use

A `fix` task is right when:

- A `bug-report.md` exists with a verified root cause and a reliable reproduction.
- The fix is bounded; it doesn't require new behaviour (that's `feature`) or restructuring (that's `refactor`).
- A regression test is part of the deliverable.

If the bug report is incomplete (no reliable reproduction, no root cause), the task type is `bug-report-writing` (with The Bug Hunter), not `fix`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `bug-report.md`                                    |
| **Lead persona**     | [The Skeptic](../personas/the-skeptic.md) — see [ADR 0006](../adrs/0006-skeptic-owns-fix-tasks.md) |
| **Secondary**        | (kickback returns to original Skeptic-as-fixer)    |
| **Output**           | Code patch + regression test                       |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-fix`, `adversarial-review`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (post), `cmdTest` (post), regression-test fires (post) |

---

## 🪞 Why The Skeptic owns fix tasks

Fixing a bug requires the same hostility toward plausible explanations that the Skeptic uses for review. The bug report says "the cause is X"; the fixer must verify X is actually the cause before patching, and must verify the patch actually addresses X (not just suppresses the symptom).

If your team prefers a dedicated `Fixer` persona (minimality-focused rather than adversarial-focused), you can override the default per-task persona via `swarm.config` (a CLI concern). The framework default is The Skeptic.

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
- Type: fix

---

> 🔧 **FIX SESSION** — Verify the bug fires deterministically, verify the fix addresses the root cause, add a regression test that fails before and passes after.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Skeptic** persona (in fixer mode).

---

## Objective

Fix the defect described in the linked bug report. One paragraph maximum.

---

## Linked docs

- Bug report: `{{bugReport}}`
- Spec defining the broken behaviour (if any): `<path>`
- Related audit (if the bug intersects an audited area): `<path>`

---

## Required skills

- `manage-task`
- `documentation-gatekeeper`
- `personas` → The Skeptic
- `write-fix`
- `adversarial-review`
- `empirical-proof`

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
- **Proactively research and read related docs.** Browse `.agents/bugs/`, `.agents/specs/`, `.agents/audits/`, `docs/`, `AGENTS.md`, and `.agents/skills/` as needed.

---

## Reproduction

<reproduction>

Re-run the bug report's reproduction. Paste the output to confirm the bug fires in *your* worktree.

```
[paste reproduction command output — bug should fire]
```

</reproduction>

---

## Plan

1.
2.
3.

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

<self_review>

Stop. A "fix" that addresses the symptom rather than the cause leaves the bug latent. Act as a senior engineer hostile to "looks fine" closures.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Pre-patch reproduction (the bug actually fires in this worktree):
- Post-patch reproduction (the bug no longer fires):
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

- Did you ask yourself: "Is this fix the *minimum* fix? Did I sneak in a 'small improvement' that changes behaviour beyond the bug?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

A bug report at `.agents/bugs/csv-export-truncation.md` documents the proxy-streaming bug from [The Bug Hunter's example](../personas/the-bug-hunter.md#%EF%B8%8F-example-how-the-bug-hunter-resolves-a-representative-issue). Root cause: `src/server/proxy.ts:88` resets `response.bytesWritten = 0` after `response.flush()`, breaking the chunked-encoding offset.

The Skeptic-as-fixer:

1. Re-runs the reproduction; confirms the bug fires (pastes output).
2. Reads `src/server/proxy.ts:88` directly; confirms the root cause.
3. Patches the proxy to flush without resetting the export's offset.
4. Adds a regression test in `tests/server/proxy.streaming.test.ts` that streams ≥ 16MB and asserts byte-count parity.
5. Patches out the fix; runs the regression test → fails (expected).
6. Restores the fix; runs the regression test → passes.
7. Runs the full test suite; pastes output.
8. Notes the related vulnerability (`src/api/streaming/file-download.ts:55`) and either expands scope (per the bug report's recommendation) or promotes to a follow-up bug-report.

---

## ⚠️ Common anti-patterns for fix tasks

- Patching the symptom instead of the root cause
- Skipping reproduction in your worktree (trusting the bug report's claim)
- Regression test that doesn't actually fail before the fix
- Scope creep ("while I'm here, this related bug…")
- Bundling the fix with unrelated cleanup

---

## See also

- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — the lead persona (in fixer mode)
- [`personas/the-bug-hunter.md`](../personas/the-bug-hunter.md) — author of the source bug-report
- [`tasks/bug-report-writing.md`](bug-report-writing.md) — the upstream task
- [`tasks/review.md`](review.md) — the post-fix review
- [`skills/write-fix.md`](../skills/write-fix.md) — the auto-attached skill
- [`examples/bug-fix-walkthrough.md`](../examples/bug-fix-walkthrough.md) — full worked example
- [ADR 0006](../adrs/0006-skeptic-owns-fix-tasks.md) — why The Skeptic
