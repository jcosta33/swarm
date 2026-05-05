# 📋 Task: migration

> **TL;DR.** Move the codebase from API A to API B mechanically across many call sites. Lead persona is The Migrator. Plan in waves; the codebase must compile and pass tests after each wave, not only at the end. No bulk codemods.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-migration.md`](../../scaffold/.agents/templates/task-migration.md).

---

## 🎯 When to use

A `migration` task is right when:

- A migration plan (or a spec acting as one) defines the source and target APIs.
- Many call sites need the same mechanical change.
- Behaviour is preserved (it's a *surface* change, not a *semantic* change).

If behaviour changes, it's `rewrite`. If it's a single file with a small change, it's `refactor`. If it's a dependency version bump rather than an API replacement, it's `upgrade`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `migration plan` or `spec.md`                      |
| **Lead persona**     | [The Migrator](../personas/the-migrator.md)       |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review of each wave) |
| **Output**           | Codebase using the target API; old API removed (or scheduled) |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-refactor` (overlap), `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (per wave), `cmdValidate` (post), `cmdTest` (post), migration-coverage check (post) |

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

- Bulk codemods touching hundreds of files
- Skipping per-wave validation ("this wave is small")
- Shims with no removal criteria
- "Mostly migrated" final state
- Behaviour drift bundled into the migration

---

## See also

- [`personas/the-migrator.md`](../personas/the-migrator.md)
- [`tasks/upgrade.md`](upgrade.md) — close cousin (dependency / framework version)
- [`tasks/refactor.md`](refactor.md) — when scope is single-module
- [`documents/extended.md`](../documents/extended.md) — the migration plan format
- [`skills/write-refactor.md`](../skills/write-refactor.md)
