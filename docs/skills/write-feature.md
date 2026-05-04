# 🛠️ Skill: write-feature

> **Auto-loaded for `feature` and `integration` tasks.** Codifies the Builder's discipline: build exactly what the spec specifies, halt on ambiguity, no opportunistic refactoring, run validation after every batch, paste the proof.

---

## 📦 Frontmatter

```yaml
---
name: write-feature
description: Load when implementing a feature from a spec. Encodes the Builder's discipline — read the spec in full, survey existing patterns, halt on ambiguity, no scope creep, validate after every batch, paste verification output.
---
```

---

## 🎯 Purpose

Features fail when the agent improvises around the spec. This skill is the discipline that keeps the implementation aligned with the spec, while still allowing the Builder to make implementation choices the spec doesn't constrain.

---

## 🔒 Core rules

### 1. Read the spec in full before coding

Not the summary; the full spec. Every acceptance criterion gets mapped to an implementation step *before* implementation begins.

### 2. Survey existing patterns

Before introducing a new helper, type, or pattern, search the codebase for existing equivalents. Reinvention is forbidden. If existing patterns don't fit, *say so* in `## Decisions` with reasoning.

### 3. Halt on ambiguity

If the spec is unclear or contradictory, stop. Surface the question in `## Blockers`. Wait for the spec to be updated. Do not invent the requirement.

### 4. No opportunistic refactoring

Refactor and feature work are different scopes. If you spot architectural debt while implementing, *promote it* to an audit; do not silently fix it. The Builder ships features; the Janitor refactors.

### 5. Run validation after every batch

`{{cmdValidate}}` runs after every batch of changes, not only at the end. Catching a violation at batch 3 is cheaper than catching it after batch 12. Paste the output into the progress checklist.

### 6. Tests are part of the deliverable

Every acceptance criterion has a corresponding test (or notes the test in a `testing` follow-up task). The Builder doesn't ship features without tests; the Test Author may augment, but the Builder owns the baseline.

### 7. Paste verification output

`## Self-review` requires verbatim verification output. Paraphrase is not proof. See [`empirical-proof.md`](empirical-proof.md).

---

## 🚫 What does not belong

- **In a feature task:** refactoring of unrelated code, new dependencies not authorised by the spec, "while I'm here" cleanup.
- **In `## Decisions`:** silent ambiguity resolutions (these go in `## Blockers` instead).

---

## ⚠️ Anti-patterns

- Implementing past the spec ("while I'm here…")
- Silently resolving spec ambiguities
- Declaring done without verification output
- Reinventing helpers that already exist
- Suppressing architectural-violation warnings
- "I'll add tests later"

---

## 🛠️ Worked example

See [The Builder's worked example](../personas/the-builder.md#%EF%B8%8F-example-how-the-builder-resolves-a-representative-issue) — the feature task that hits a spec ambiguity (collision detection mechanism) and halts rather than invents.

---

## See also

- [`personas/the-builder.md`](../personas/the-builder.md)
- [`tasks/feature.md`](../tasks/feature.md), [`tasks/integration.md`](../tasks/integration.md)
- [`empirical-proof.md`](empirical-proof.md)
