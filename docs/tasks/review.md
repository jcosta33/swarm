# 📋 Task: review

> **TL;DR.** Adversarial inspection of a worker's branch (or your own work in a fresh session). Lead persona is The Skeptic. Output: a verdict (APPROVE / KICK BACK / ABANDON) and a findings list. Fixes happen in a downstream task. Run validation yourself; do not trust the worker's pasted output.

---

## 🎯 When to use

A `review` task is right when:

- A code-producing task has finished and produced a branch.
- Independent verification is required before merge.
- The reviewer must operate adversarially, not collaboratively.

The Lead Engineer adopts this task type as part of orchestration (becomes The Skeptic for each worker's branch). A standalone `review` task can also be spawned for any branch needing pre-merge review.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | A branch under review + the original source doc (spec/audit/bug-report) |
| **Lead persona**     | [The Skeptic](../personas/the-skeptic.md)         |
| **Output**           | Verdict + findings list                            |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `adversarial-review`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (post — **run by you**), `cmdTest` (post — **run by you**), `git diff` of branch under review |

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
- Type: review

---

> 🔒 **REVIEW SESSION** — Reviewing another agent's branch (or your own work in a fresh session). You may NOT modify code. Output: a verdict (approve / kick back) and a findings list. Fixes happen in a downstream task.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Skeptic** persona.

---

## Objective

What branch is being reviewed and what the review must determine. One paragraph maximum.

---

## Linked docs

- Branch under review: `<branch-name>`
- Worker's task file (if available): `<path>`
- Original spec / audit / bug-report: `{{specFile}}`

---

## Diff overview

<diff_overview>

The shape of the change. Run `git diff --stat` and paste the output here. Then describe what the change appears to do in one sentence.

```
[paste git diff --stat output]
```

**Apparent intent:**

</diff_overview>

---

## Findings

<findings>

Each finding cites file and line and states the issue specifically. Vague concerns are not findings.

| # | Severity | File | Line | Issue | Fix sketch |
| - | -------- | ---- | ---- | ----- | ---------- |
|   |          |      |      |       |            |

Severity scale: `BLOCKER` (must fix before merge), `MAJOR` (should fix; merge blocked unless waived), `MINOR` (note for follow-up).

</findings>

---

## Verdict

<verdict>

[pending — fill in at the end]

One of:

- `APPROVE` — no blockers, merge.
- `KICK BACK` — blockers present; worker must revise. List specific files/lines that must change.
- `ABANDON` — branch is unsalvageable; recommend starting over.

</verdict>

---

## Constraints

- **No code changes — review document only.** Fixes are downstream
- Work only inside this worktree
- Do not switch branches unless explicitly to inspect the branch under review
- Do not merge, rebase, or push
- Run `{{cmdInstall}}` and the project's full validation yourself; do not trust the worker's pasted output
- Read the diff adversarially — six questions in `adversarial-review` skill
- Findings cite file and line; vague concerns get demoted or removed
- Mistrust confident-sounding language in the worker's task file ("harmless", "should never", "by happy accident")
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/audits/`, `.agents/bugs/`, `docs/`, and `AGENTS.md` as needed.

---

## Progress checklist

- [ ] Load `.agents/skills/adversarial-review/SKILL.md`
- [ ] Load `.agents/skills/empirical-proof/SKILL.md`
- [ ] Read the worker's task file
- [ ] Check out the branch under review (or compare from this worktree)
- [ ] Run `git diff --stat`; paste in Diff overview
- [ ] Run `{{cmdInstall}}` and `{{cmdValidate}}` yourself (not trusting the worker's output)
- [ ] Run `{{cmdTest}}` yourself
- [ ] Walk the diff with the six adversarial questions
- [ ] Search for callers across the codebase (cross-module impact)
- [ ] Verify dynamic invariants where applicable (concurrency, lifecycle, resource cleanup)
- [ ] Verify any structural claims the worker made
- [ ] Read the source once with the worker's claims set aside; hunt for missed findings
- [ ] Record findings with file/line specificity
- [ ] Calibrate severities
- [ ] Render verdict
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Independent verification answered
- [ ] Self-review: Diff reading depth answered
- [ ] Self-review: Cross-module callers answered
- [ ] Self-review: Severity calibration answered

---

## Decisions

- ***

## Findings (session-level)

(Things worth knowing about the review process itself, not findings about the branch — those are in the table above.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

(For the worker (if kicked back) or the merger (if approved). Concrete enough that the downstream agent doesn't ask "what do you mean".)

- ***

## Self-review

<self_review>

Stop. A review that rubber-stamps a worker's claims is worse than no review — it gives a false sense of integrity to broken work. Act as a senior engineer skeptical of your own thoroughness.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- `git diff --stat` of branch under review:
- `{{cmdValidate}}` run by you (last 2 lines):
- `{{cmdTest}}` run by you (last 2 lines):

### Independent verification

- Did you run the validation commands yourself, in your own worktree, with the branch checked out? Did the commands actually pass when you ran them, or did you accept the worker's pasted output? If your run differed from theirs, did you investigate why?
  Answer:

### Diff reading depth

- Did you walk the diff with the six adversarial questions (intent, does-the-code-do-it, what-didn't-change, edge cases, production failures, unclaimed verifications)? Or did you skim the diff for obvious issues and stop?
  Answer:

### Cross-module callers

- Did you search the whole codebase for callers of any changed public surface? Did you read the calling code, not just the changed module? Lifecycle bugs and id-collision hazards live in the calling code as often as in the audited module.
  Answer:

### Severity calibration

- Are blockers genuinely blockers (would ship a regression or break invariants), or did some get inflated? Are minors genuinely minor (would not affect correctness), or did some get demoted to avoid confrontation?
  Answer:

### Final Polish

- Did you ask yourself: "Did I find what's actually wrong, or did I stop at the first plausible issue? Did the worker's confidence make me too generous?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

See [The Skeptic's worked example](../personas/the-skeptic.md#%EF%B8%8F-example-how-the-skeptic-resolves-a-representative-issue) — the rate-limiter review that catches a Cloudflare-IP bug despite the worker's "all tests pass" claim.

---

## ⚠️ Common anti-patterns

- Approving because the worker said all tests passed
- Reviewing only the diff and missing the unchanged callers
- Soft-language findings
- Trusting the worker's pasted verification output instead of running yourself
- Demoting findings to avoid confrontation
- Approving a small diff without confirming the small diff is the right work

---

## See also

- [`personas/the-skeptic.md`](../personas/the-skeptic.md)
- [`skills/adversarial-review.md`](../skills/adversarial-review.md) — the canonical review skill
- [`skills/empirical-proof.md`](../skills/empirical-proof.md)
- [`tasks/kickback.md`](kickback.md) — what happens after a KICK BACK verdict
- [`tasks/deepen-audit.md`](deepen-audit.md) — sibling task
