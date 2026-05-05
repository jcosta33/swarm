# 📋 Task: audit-writing

> **TL;DR.** Honestly describe the current state of a codebase area against a defined goal. Lead persona is The Auditor. Findings cite file:line. Every issue has a "Needed". Read-only on source code; only the audit doc changes.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-audit.md`](../../scaffold/.agents/templates/task-audit.md). The doc-template the audit-writing task produces lives at [`/scaffold/.agents/templates/audit.md`](../../scaffold/.agents/templates/audit.md).

---

## 🎯 When to use

An `audit-writing` task is right when:

- A goal exists ("make X area legible", "find blockers to Q3 work").
- The deliverable is *observation*, not prescription.
- Downstream work (refactor, performance, fix) depends on the audit.

If you're re-walking an existing audit, that's `deepen-audit`. If you're investigating a bug, that's `bug-report-writing`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `audit brief` (optional) / human ask               |
| **Lead persona**     | [The Auditor](../personas/the-auditor.md)         |
| **Output**           | `audit.md` at `.agents/audits/{{slug}}.md`         |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-audit`, `adversarial-review` |
| **Verification gate slots** | post: `git status` (clean on source), `cmdValidate` and `cmdValidateDeps` if structural claims rely on them |

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

- Listing issues without representative file:line citations
- Presenting fixes as findings
- Leaving Risks and Suggested approaches empty
- Trusting structural claims without grepping
- Audit reads like a TODO list

---

## See also

- [`personas/the-auditor.md`](../personas/the-auditor.md)
- [`tasks/deepen-audit.md`](deepen-audit.md) — re-walking an existing audit
- [`documents/audit.md`](../documents/audit.md)
- [`skills/write-audit.md`](../skills/write-audit.md)
- [`skills/adversarial-review.md`](../skills/adversarial-review.md)
