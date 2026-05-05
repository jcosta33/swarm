# 📋 Task: research-writing

> **TL;DR.** Produce a research file an Architect can lift directly into spec requirements. Lead persona is The Researcher (technical mode) or The Surveyor (UX/market mode). Every claim cites a primary source. End with an actionable recommendation. Read-only on source code.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-research.md`](../../scaffold/.agents/templates/task-research.md). The doc-template the research-writing task produces lives at [`/scaffold/.agents/templates/research.md`](../../scaffold/.agents/templates/research.md).

---

## 🎯 When to use

A `research-writing` task is right when:

- A decision-informing question needs an external knowledge gathering session.
- The training-data answer is insufficient (or unverifiable).
- The output will feed a `spec-writing` task or an ADR.

If the answer is simple enough to capture in a task file's `## Findings`, you don't need a research file. The framework's "research is optional" rule: if a competent agent can answer from training data alone, the research file is unjustified.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `research question` (optional) / human ask         |
| **Lead persona**     | [The Researcher](../personas/the-researcher.md) (technical) **or** [The Surveyor](../personas/the-surveyor.md) (UX/market) |
| **Output**           | `research.md` at `.agents/research/{{slug}}.md`    |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-research`, `distillation-discipline` |
| **Verification gate slots** | post: `git status` (clean on source)        |

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

- Opinion presented as finding
- Sources listed but not actually consulted
- Recommendations that say "it depends" without saying on what
- Vague attribution ("according to common practice")
- Inferring product behaviour without verifying
- Research without a decision-informing question

---

## See also

- [`personas/the-researcher.md`](../personas/the-researcher.md) — technical mode
- [`personas/the-surveyor.md`](../personas/the-surveyor.md) — UX/market mode
- [`documents/research.md`](../documents/research.md)
- [`skills/write-research.md`](../skills/write-research.md)
- [`skills/distillation-discipline.md`](../skills/distillation-discipline.md)
