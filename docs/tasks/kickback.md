# 📋 Task: kickback

> **TL;DR.** A revision task spawned when The Skeptic rejects a worker's branch. The original persona (Builder, Janitor, Migrator, etc.) revises per the Skeptic's specific notes. Source docs: original spec/audit/bug-report **plus** the Skeptic's review notes. After revision, hand back to The Skeptic for re-review.

---

## 🎯 When to use

A `kickback` task is right when:

- A previous task (feature, refactor, fix, etc.) was reviewed by The Skeptic and the verdict was `KICK BACK`.
- The Skeptic provided specific file:line citations and what must change.
- The branch is salvageable (verdict was not `ABANDON`).

If the Skeptic's verdict was `ABANDON`, the path forward is *not* a kickback — it's re-spec, re-scope, or close.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source docs**      | Original source doc (spec/audit/bug-report) **+** the Skeptic's review notes |
| **Lead persona**     | (Original persona — typically The Builder, sometimes Janitor or Migrator) |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (re-review) |
| **Output**           | Revised branch addressing every BLOCKER and (where waived) MAJOR |
| **Auto-loaded skills** | Same as the original task type, plus `adversarial-review` (so the persona can re-check their work against the Skeptic's notes) |
| **Verification gate slots** | Same as the original task type                |

---

## 📐 Template

````markdown
# {{title}}

## Metadata

- Slug: {{slug}}-kickback-{{round}}
- Agent: {{agent}}
- Branch: {{branch}} _(same branch as the original task)_
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: kickback (originally: {{originalType}})
- Round: {{round}} _(of max 3)_

---

> 🔁 **KICKBACK SESSION** — A previous review identified blockers. Address every BLOCKER. Address MAJORs unless explicitly waived. Do not change scope beyond the kickback notes.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **{{originalPersona}}** (the persona that authored the original branch).

---

## Objective

Revise the branch per the Skeptic's review notes. One paragraph maximum.

---

## Linked docs

- Original source doc: `{{originalSourceDoc}}`
- Skeptic's review notes: `{{reviewFile}}`
- Original task file (for context, before this kickback): `{{originalTaskFile}}` _(may be deleted by the time you read this — gitignored)_

---

## Kickback queue (from the Skeptic's review)

<kickback_items>

| # | Severity | File | Line | Required change |
| - | -------- | ---- | ---- | --------------- |
|   |          |      |      |                 |

(Copied verbatim from the Skeptic's findings table; one row per BLOCKER and any non-waived MAJOR.)

</kickback_items>

---

## Constraints

- Address every BLOCKER in the table above
- Address every MAJOR unless an explicit waiver from the reviewer is recorded in `## Decisions`
- MINORs may be addressed if convenient; document in `## Decisions`
- **Do not change scope beyond the kickback notes.** New findings discovered during revision get *promoted* (to an audit, to a separate bug-report, etc.); they do not silently expand this kickback's diff.
- Run the original task's verification gates after each fix
- This is round {{round}} of a max 3. If round 3 doesn't resolve, escalate (re-spec, re-scope, or surface to human)
- **Proactively research and read related docs.** Browse the original source, the Skeptic's notes, related specs/audits/bug-reports.

---

## Plan

1. Read the Skeptic's notes in full.
2. For each BLOCKER, plan the change.
3. For each MAJOR, plan the change (or record waiver in Decisions).
4. Implement each change individually.
5. Re-run the original task's verification gates.

---

## Progress checklist

- [ ] Skeptic's notes read in full
- [ ] Kickback table populated above
- [ ] BLOCKER 1 addressed
- [ ] BLOCKER 2 addressed
- [ ] _… etc …_
- [ ] MAJORs addressed (or waivers documented)
- [ ] Original task's verification gates re-run (paste output)
- [ ] No scope creep; new findings promoted upstream
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Kickback coverage answered
- [ ] Self-review: No scope creep answered
- [ ] Self-review: Re-review readiness answered

---

## Decisions

(Including any explicit MAJOR waivers, with reviewer agreement noted.)

- ***

## Findings

(New findings discovered during revision — promote upstream rather than expanding this kickback.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

(For the Skeptic re-reviewing this branch.)

- ***

## Self-review

<self_review>

Stop. A kickback that addresses 4 of 5 BLOCKERs ships with 1. Act as a senior engineer hostile to "good enough".

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- `{{cmdValidate}}` (last 2 lines):
- `{{cmdTest}}` (last 2 lines):
- `git diff --stat` showing the kickback's changes (delta from prior head):

### Kickback coverage

- Did I address every BLOCKER in the queue? Did I address every MAJOR (or document a waiver)? For each, can I point at the specific change?
  Answer:

### No scope creep

- Did I touch any code beyond what the kickback required? If yes, was it in service of the kickback (e.g., a typo in the affected line) or unrelated?
  Answer:

### Re-review readiness

- Could the Skeptic re-review this branch with confidence? Is the kickback table updated to show each item as `addressed` (or `waived` with reasoning)?
  Answer:

### Final Polish

- Did you ask yourself: "Did I just patch the symptom of each finding, or did I understand and address each cause?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

The Skeptic kicked back `feature/payments-rate-limit` (see [The Skeptic's example](../personas/the-skeptic.md#%EF%B8%8F-example-how-the-skeptic-resolves-a-representative-issue)) with:

- BLOCKER: Use `req.realIp` not `req.ip`
- MAJOR: Fix per-request cleanup pattern
- MAJOR: Add Cloudflare-fixture test
- MINOR: Confirm body-parsing-vs-rate-limit ordering

The Builder (in kickback mode):

1. Reads the Skeptic's notes.
2. Populates the kickback table.
3. Addresses BLOCKER (one-line change).
4. Addresses MAJOR #1 (replaces per-request cleanup with periodic interval).
5. Addresses MAJOR #2 (adds the Cloudflare fixture test, verifies it fails before the BLOCKER fix and passes after).
6. Decides on MINOR: the body-parsing ordering is intentional; documents in `## Decisions` ("rate limiter applies before body-parse so failed-parse requests count against the limit, by spec §3.5").
7. Runs validation; pastes outputs.
8. Hands back to the Skeptic for re-review.

---

## 🛑 Round limit and escalation

A branch that's been kicked back **3 times** is escalated. The Lead Engineer (or human) chooses:

- **Re-spec** — the spec is unclear; spawn a `spec-writing` task to revise.
- **Re-scope** — the work is too large; spawn an `orchestration` to decompose.
- **Abandon** — close the branch and the parent work with rationale.

The 3-round limit is a recommendation, not a hard rule. See [`concepts/08-recursion-and-delegation.md`](../concepts/08-recursion-and-delegation.md) for the escalation protocol.

---

## ⚠️ Common anti-patterns

- Addressing some BLOCKERs but not others ("I'll get to the rest in a follow-up")
- Scope creep during revision (adding "while I'm here" changes)
- Treating a vague kickback as actionable (instead of asking the Skeptic to sharpen it)
- Adopting a different persona during the kickback (the original persona owns the revision)
- Looping past 3 rounds without escalation

---

## See also

- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — author of the kickback
- [`tasks/review.md`](review.md) — the upstream review task
- [`concepts/08-recursion-and-delegation.md`](../concepts/08-recursion-and-delegation.md) — escalation protocol
- [`skills/adversarial-review.md`](../skills/adversarial-review.md) — for re-checking your work
