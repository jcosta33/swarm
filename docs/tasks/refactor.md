# 📋 Task: refactor

> **TL;DR.** Restructure code without changing observable behaviour. Lead persona is The Janitor. Source: an `audit.md`. Run `{{cmdValidateDeps}}` after every 10-file batch (the framework convention). Document every shim contract before consumers touch it.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-refactor.md`](../../scaffold/.agents/templates/task-refactor.md).

---

## 🎯 When to use

A `refactor` task is right when:

- An `audit.md` exists with prioritised "Needed" entries.
- The change is *structural*, not behavioural — observable behaviour is preserved.
- Tests pass before, during (at every checkpoint), and after.

If the change is mechanical replacement of API A with API B, that's `migration`, not `refactor`. If observable behaviour changes, that's `rewrite`, not `refactor`. If the audit triggers a structural rethink, that's `spec-writing`, not `refactor`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `audit.md`                                         |
| **Lead persona**     | [The Janitor](../personas/the-janitor.md)         |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review) |
| **Output**           | Restructured code, behaviour preserved             |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-refactor`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidateDeps` (every 10 files), `cmdValidateDeps` (post), `cmdTypecheck` (post), `cmdTest` (post) |

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

- Silencing a validation failure by editing the validator config
- "While I'm here" semantic changes
- Codemods touching hundreds of files in one commit
- Deleting code without grep-evidence
- Skipping checkpoint validation
- Refactoring tests "for clarity" alongside production code

---

## See also

- [`personas/the-janitor.md`](../personas/the-janitor.md)
- [`tasks/migration.md`](migration.md) — close cousin (different scope)
- [`tasks/rewrite.md`](rewrite.md) — when behaviour does change
- [`documents/audit.md`](../documents/audit.md) — the source doc
- [`skills/write-refactor.md`](../skills/write-refactor.md)
