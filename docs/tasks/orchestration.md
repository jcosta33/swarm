# 📋 Task: orchestration

> **TL;DR.** Decompose a complex ask into independent sub-tasks, delegate each to a worker (in their own worktree), review each branch as the Skeptic, and merge in a chosen order. Lead persona is The Lead Engineer. The orchestration task file is the canonical record — anyone reading it can reconstruct what happened.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-orchestration.md`](../../scaffold/.agents/templates/task-orchestration.md).

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

## Canonical template (agent artefact)

The verbatim Markdown template (persona directive, placeholders, gated `Self-review`) lives under **`/scaffold/.agents/templates/`**. Install by copying [`/scaffold`](../../scaffold/README.md); do not paste large template bodies from framework docs into downstream repos — that guarantees drift.

### Why these structural clusters exist

| Cluster | Conditioning rationale |
|---------|-------------------------|
| Metadata & task `type` | Freezes the launcher’s routing choice where chat context will evaporate. |
| Linked docs | Anchors primary upstream doctrine; ancillary docs remain read-only grounding. |
| Banner + constraints | Imports flow-graph forbiddances as non-negotiable session text. |
| Plan vs checklist vs decisions | Separates forecast, execution telemetry, and post-hoc rationale for audits. |
| Self-review | Converts “done?” into evidence-shaped questions aligned to persona proof obligations. |

See [`reference/task-base.md`](../reference/task-base.md), [`reference/template-placeholders.md`](../reference/template-placeholders.md), and [`reference/verification-gates.md`](../reference/verification-gates.md).


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
