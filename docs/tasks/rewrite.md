# 📋 Task: rewrite

> **TL;DR.** Re-implement a module with explicit behaviour changes. Distinct from refactor (which preserves behaviour). Lead persona is The Builder. The behaviour delta must be explicit before code changes; everything not in the delta must be preserved.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-rewrite.md`](../../scaffold/.agents/templates/task-rewrite.md).

---

## 🎯 When to use

A `rewrite` task is right when:

- A spec authorises behaviour change as part of re-implementing a module.
- The change is bigger than a feature (it replaces existing implementation), but smaller than a green-field project.
- The behaviour delta is explicit — what changes, what stays the same.

If behaviour is preserved, it's `refactor`. If it's a new module from scratch with no prior behaviour to compare against, it's `feature`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `spec.md` (with explicit behaviour delta)          |
| **Lead persona**     | [The Builder](../personas/the-builder.md)         |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review) |
| **Output**           | New implementation, behaviour delta enforced       |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-rewrite`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (after each module), `cmdValidate` (post), `cmdTest` (post) |

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

- Behaviour changes that aren't in the delta table
- Treating "rewrite" as a license to redesign
- Not updating callers for behaviour changes
- Calling it a refactor when behaviour changes (mislabelling)
- Calling it a rewrite when behaviour is preserved (over-marking)

---

## See also

- [`tasks/refactor.md`](refactor.md) — when behaviour is preserved
- [`tasks/feature.md`](feature.md) — when there's no prior behaviour
- [`personas/the-builder.md`](../personas/the-builder.md)
- [`skills/write-rewrite.md`](../skills/write-rewrite.md)
