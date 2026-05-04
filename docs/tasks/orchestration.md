# 📋 Task: orchestration

> **TL;DR.** Decompose a complex ask into independent sub-tasks, delegate each to a worker (in their own worktree), review each branch as the Skeptic, and merge in a chosen order. Lead persona is The Lead Engineer. The orchestration task file is the canonical record — anyone reading it can reconstruct what happened.

---

## 🎯 When to use

An `orchestration` task is right when:

- The ask spans multiple source documents (5 specs, an audit + 3 follow-up specs, etc.).
- A single complex spec warrants decomposition.
- Disjoint scopes can be worked in parallel by separate workers.

If the ask doesn't decompose into disjoint scopes, collapse to a single-agent task. The framework's response: there is no shame in single-threaded work; coordination cost on coupled work is too high.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source docs**      | Multiple (one per worker)                          |
| **Lead persona**     | [The Lead Engineer](../personas/the-lead-engineer.md), becoming [The Skeptic](../personas/the-skeptic.md) for each review |
| **Output**           | Merged result + worker tracker + merge log         |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `adversarial-review` (for review pass), `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), per-worker review (`cmdValidate`/`cmdTest` run by Lead Engineer), final merged-branch `cmdValidate`/`cmdTest` (post) |

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
- Type: orchestration

---

> ⚠️ **ORCHESTRATION SESSION** — You are managing other agents, not writing code yourself. Your output is the merged result and the trail showing how it got there. Never merge a branch without verifying it empirically; adopt **The Skeptic** for every review pass.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Lead Engineer** persona. Switch to **The Skeptic** for each review pass; switch back when delegating or merging.

---

## Objective

What outcome the orchestration must produce, decomposed from the human's ask. One paragraph maximum.

---

## Linked docs

- Source documents (one per worker): `<paths>`
- Triggering ask: `{{specFile}}`

---

## Worker tracker

<worker_tracker>

Each worker is a sub-task in its own worktree. Track everything here; this is the canonical record.

| Slug | Source doc | Task type | Persona | Branch | Status | Last review verdict |
| ---- | ---------- | --------- | ------- | ------ | ------ | ------------------- |
|      |            |           |         |        |        |                     |

Status values: `not-started`, `in-progress`, `awaiting-review`, `kicked-back`, `merged`, `abandoned`.

</worker_tracker>

---

## Kickback queue

<kickback_queue>

Workers whose branches were rejected at review and need revision. Each kickback names the worker, the reason, and the specific files/lines that must change.

| Worker slug | Reason | Files / lines | Re-review status |
| ----------- | ------ | ------------- | ---------------- |
|             |        |               |                  |

</kickback_queue>

---

## Merge log

<merge_log>

The order branches were merged, conflicts encountered, and how they were resolved. Reconstructable history.

| Order | Worker slug | Merged into | Conflicts | Resolution |
| ----- | ----------- | ----------- | --------- | ---------- |
|       |             |             |           |            |

</merge_log>

---

## Constraints

- Work only inside this worktree
- Do not write feature code yourself — delegate
- Do not merge a branch without empirical verification (paste worker-branch validation output)
- Adopt The Skeptic for every review pass; do not approve on the worker's word
- Kickback feedback must cite files and lines; vague rejections waste worker time
- Document the merge protocol used (order, conflict resolution)
- Recursive sub-orchestration is permitted up to the limit set in the project's recursion config (default: 2)
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/research/`, `.agents/audits/`, `docs/`, and `AGENTS.md` as needed.

---

## Progress checklist

- [ ] Decompose the human's ask into N sub-tasks; one source doc per sub-task
- [ ] Verify decomposition: file scopes are disjoint
- [ ] Fill in the worker tracker
- [ ] Spawn each worker (own worktree, own branch, conditioned task file)
- [ ] As each worker completes: switch to The Skeptic, review the branch, paste verification output
- [ ] Approve or kick back; if kicked back, fill in the kickback queue
- [ ] Re-review revised branches
- [ ] Merge approved branches in the order documented in the merge log
- [ ] Resolve any merge conflicts; document each resolution
- [ ] Run `{{cmdValidate}}` on the merged result; paste output
- [ ] Run `{{cmdTest}}` on the merged result; paste output
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Per-worker review answered
- [ ] Self-review: Kickback specificity answered
- [ ] Self-review: Merge integrity answered
- [ ] Self-review: Trail reconstructibility answered

---

## Decisions

(Significant choices made during orchestration: how the work was decomposed, how conflicts were resolved, why a worker was abandoned (if any).)

- ***

## Findings

(Cross-cutting issues that surfaced across multiple workers — patterns suggesting a deeper architectural concern. Move durable findings to an audit.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

(Concrete starting points for the next session if this one ends incomplete. The next session should be able to identify which workers are merged vs pending from this file alone.)

- ***

## Self-review

<self_review>

Stop. Orchestration fails when a worker's word is taken as proof, when a kickback is too vague to act on, or when merges happen out of order and break the integration. Act as a senior engineer about to ship the merged result, hostile to all three.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Per-worker review: `git diff <worker-branch>` (representative sample) and `{{cmdValidate}}` output run by you, not the worker
- Final merged-branch `{{cmdValidate}}` (last 2 lines):
- Final merged-branch `{{cmdTest}}` (last 2 lines):

### Per-worker review

- Did you run validation locally for every worker, not trust their pasted output? Did you read each diff with The Skeptic stance? Are review verdicts in the tracker accurate?
  Answer:

### Kickback specificity

- For every kicked-back branch, does the kickback queue cite specific files and lines and what must change? Did the worker need to come back and ask "what do you mean" — if so, the kickback was insufficient.
  Answer:

### Merge integrity

- Does the merge log show the order branches were merged and how conflicts were resolved? Did the merged result pass full validation, not just per-worker validation? Are there latent integration issues that worked in isolation but break together?
  Answer:

### Trail reconstructibility

- Could a fresh agent reconstruct what happened from this task file alone — which workers ran, which were kicked back, which merged in what order? If not, the trail is incomplete.
  Answer:

### Final Polish

- Did you ask yourself: "Did I rubber-stamp any worker's review? Did the merged result actually integrate, or did I declare done at the per-worker level?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

See [The Lead Engineer's worked example](../personas/the-lead-engineer.md#%EF%B8%8F-example-how-the-lead-engineer-resolves-a-representative-issue) — the 5-worker payments orchestration with serialised dependent workers and a kickback round.

For the full walkthrough, see [`examples/orchestration-walkthrough.md`](../examples/orchestration-walkthrough.md).

---

## ⚠️ Common anti-patterns

- Merging on the worker's word
- Kicking back with vague notes
- Doing the work yourself
- Spawning workers with overlapping scopes
- Skipping integrated validation
- Letting kickback loops exceed 3 rounds without escalation

---

## See also

- [`personas/the-lead-engineer.md`](../personas/the-lead-engineer.md)
- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — your alter-ego for review passes
- [`concepts/08-recursion-and-delegation.md`](../concepts/08-recursion-and-delegation.md)
- [`concepts/10-subagent-strategy.md`](../concepts/10-subagent-strategy.md) — write-side single-threaded
- [`tasks/kickback.md`](kickback.md) — what kickback tasks look like
- [`examples/orchestration-walkthrough.md`](../examples/orchestration-walkthrough.md)
