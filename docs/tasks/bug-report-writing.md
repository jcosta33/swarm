# 📋 Task: bug-report-writing

> **TL;DR.** Reproduce a defect deterministically, isolate the root cause, and produce a `bug-report.md` a fixer can act on. Lead persona is The Bug Hunter. Read-only on source code (the fix is downstream). Distinguish observation from inference.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-bug-report.md`](../../scaffold/.agents/templates/task-bug-report.md). The doc-template the bug-report-writing task produces lives at [`/scaffold/.agents/templates/bug-report.md`](../../scaffold/.agents/templates/bug-report.md).

---

## 🎯 When to use

A `bug-report-writing` task is right when:

- A defect has been reported (by a human, by a CI failure, by an agent observation).
- The report is incomplete (no reliable reproduction, no root cause).
- The downstream task is `fix` (which adopts The Skeptic mindset).

If the report already has a deterministic reproduction and a verified root cause, skip straight to `fix`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | Human report / agent observation                   |
| **Lead persona**     | [The Bug Hunter](../personas/the-bug-hunter.md)   |
| **Output**           | `bug-report.md` at `.agents/bugs/{{slug}}.md`      |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-bug-report`, `adversarial-review`, `empirical-proof` |
| **Verification gate slots** | post: `git status` (clean — no source changes), reproduction-output proof |

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

- Reporting the symptom as the bug
- Speculating about cause without reproducing
- Conflating "I think" with "I have proven"
- Bug reports that read as "module X is broken"
- Fixing the bug instead of reporting it

---

## See also

- [`personas/the-bug-hunter.md`](../personas/the-bug-hunter.md)
- [`tasks/fix.md`](fix.md) — the downstream fix task
- [`documents/bug-report.md`](../documents/bug-report.md)
- [`skills/write-bug-report.md`](../skills/write-bug-report.md)
- [`skills/adversarial-review.md`](../skills/adversarial-review.md)
- [ADR 0007](../adrs/0007-bug-report-as-meta-task.md) — why bug-report is its own task
