# 📋 Task: documentation

> **TL;DR.** Write or update user-facing documentation (READMEs, contributor guides, ADRs, public API docs). Lead persona is The Documentarian. The reader is a human who has not read the code; lead with what they need to do. Every code example must run as written.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-documentation.md`](../../scaffold/.agents/templates/task-documentation.md).

---

## 🎯 When to use

A `documentation` task is right when:

- The deliverable is *user-facing* prose (READMEs, how-to guides, reference pages, ADRs, API docs).
- A spec or audit identifies the doc gap, **or** a one-paragraph human ask captures the scope.
- The reader is a human, not an agent (agent-facing docs are written by the relevant persona — Architect for spec, Auditor for audit, etc.).

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `spec.md` / `audit.md` / task scope                |
| **Lead persona**     | [The Documentarian](../personas/the-documentarian.md) |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review) |
| **Output**           | User-facing doc(s) at the project's doc location   |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `distillation-discipline`, `empirical-proof` |
| **Verification gate slots** | post: every code example actually run (output pasted), `cmdValidate` (if doc-linting applies) |

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

- Examples that don't run
- Hedge words ("should", "might", "could") the reader can't act on
- Updating the README without updating in-tree docs that contradict
- Mixing Diátaxis types in a single doc
- Background paragraphs before the action
- Treating documentation as an afterthought to feature work

---

## See also

- [`personas/the-documentarian.md`](../personas/the-documentarian.md)
- [`skills/distillation-discipline.md`](../skills/distillation-discipline.md)
- [`skills/empirical-proof.md`](../skills/empirical-proof.md)
- The [Diátaxis](https://diataxis.fr) framework — the doc-type vocabulary
