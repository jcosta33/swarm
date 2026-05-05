# 📋 Task: feature

> **TL;DR.** Build new behaviour from a complete spec. Lead persona is The Builder. Spec is the contract; the Builder doesn't improvise around it. Output: code + tests + handoff to The Skeptic for review.

> 📦 **This page is documentation.** The actual task template (the one a launcher / Swarm CLI scaffolds tasks from) lives at [`/scaffold/.agents/templates/task-feature.md`](../../scaffold/.agents/templates/task-feature.md).

---

## 🎯 When to use

A `feature` task is right when:

- You have a spec describing new behaviour to build (or extending existing behaviour in a way that adds capability).
- The spec is *complete enough to implement from* — no `[CRITICAL]` open questions.
- The change is bounded; it doesn't require restructuring (that's `refactor`) or replacing existing behaviour (that's `rewrite`).

If the spec is incomplete, the task type is `spec-writing` (with The Architect), not `feature`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `spec.md`                                          |
| **Lead persona**     | [The Builder](../personas/the-builder.md)         |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review) |
| **Output**           | Code (with tests) + Skeptic handoff                |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-feature`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (periodic + post), `cmdTest` (post), `cmdValidateDeps` (post, where applicable) |

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

## ⚠️ Common anti-patterns for feature tasks

- Implementing past the spec ("while I'm here…")
- Silent ambiguity resolution (the spec was unclear; the Builder picked one interpretation)
- Declaring done without pasting validation output
- Refactoring during the feature task (different scope; promote)
- Reinventing helpers that already exist

---

## See also

- [`personas/the-builder.md`](../personas/the-builder.md) — the lead persona
- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — handoff partner
- [`tasks/review.md`](review.md) — the downstream review task
- [`tasks/kickback.md`](kickback.md) — what happens if the Skeptic kicks back
- [`skills/write-feature.md`](../skills/write-feature.md) — the auto-attached skill
- [`documents/spec.md`](../documents/spec.md) — what the source doc looks like
