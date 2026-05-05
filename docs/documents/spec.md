# 📜 Document: spec.md

> **TL;DR.** Forward-looking contract: what **should become true**. Diátaxis *Reference*-shaped. Authored by The Architect. Seeds `feature` / `rewrite` / `integration` lanes. Acceptance criteria exist to extinguish Builder interpretation battles.

> 📦 **Authoring scaffold:** [`/scaffold/.agents/templates/spec.md`](../../scaffold/.agents/templates/spec.md) — install via [`/scaffold/README.md`](../../scaffold/README.md).

---

## 🎯 Purpose

Bind Architect intent to mechanically testable predicates so downstream tasks cannot smuggle tacit assumptions. Anything that smells like observational archaeology belongs in audits, not here.

---

## 📍 Where it lives

`.agents/specs/{{slug}}.md` — promoted to `/shipped/` subfolders after delivery when teams track living contracts.

---

## ✍️ Authoring persona

[The Architect](../personas/the-architect.md) exclusively for default routing ([ADR 0002](../adrs/0002-personas-1-to-1-with-task-types.md)).

---

## Canonical scaffold (human reasoning — **not** the literal template)

Markdown skeleton + XML-ish helper tags remain **only** in `/scaffold` so consumer copies diverge consciously, not accidentally via docs copy-pasta.

### Why those heading clusters matter

| Cluster | Load-bearing rationale |
|--------|-------------------------|
| Goal vs scope fences | Keeps exploratory narrative outside executable requirements surface. |
| User-visible behaviours | Bridges product language ↔ engineering validation without prescribing internals. |
| Acceptance criteria checklist | Gives Test Author / Builder unanimous oracle for completeness tests. |
| Design decisions (+ rejected options) | Freezes ambiguity resolution historically—prevents reopened religious wars later. |
| Open questions taxonomy (`[CRITICAL]` / `[MINOR]`) | Forces explicit chokepoints before Implementation begins burning calendar. |
| Distillation Loss Statement | When derived from research, proves Architect acknowledged compression risk. |

Verbatim headings, placeholders, and tag blocks: **do not mirror from `/docs`** — sync only through scaffold refreshes tracked in version control ([ADR 0015](../adrs/0015-versioning-scheme.md)).

---

## ⚠️ Failure modes the `write-spec` skill targets

- Unmeasurable adjectives posing as requirements.
- Sneaking implementation recipe into supposedly behavioural contract.
- Shipping with unanswered `[CRITICAL]` questions silently demoted.
- Mixing observations of today's code with prescriptions for tomorrow.

---

## See also

- [`tasks/spec-writing.md`](../tasks/spec-writing.md)
- [`skills/write-spec.md`](../skills/write-spec.md)
- [`concepts/05-document-types.md`](../concepts/05-document-types.md)
- [`extended.md`](extended.md)
