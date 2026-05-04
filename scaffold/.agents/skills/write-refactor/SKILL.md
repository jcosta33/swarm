---
name: write-refactor
description: Load when restructuring code (refactor) or migrating an API (migration / upgrade). Encodes the Janitor / Migrator discipline — behaviour preservation, per-batch architectural validation (every 10 files for refactor; every wave for migration), documented shim contracts with verifiable removal criteria, deletion-safety proof.
---

# Skill: write-refactor

## Purpose

Refactors and migrations fail when behaviour drifts silently or when shims become permanent. This skill is the discipline that keeps the change *structural* (not behavioural) and ensures every shim has a documented exit.

## Core rules

### 1. Behaviour preservation is non-negotiable

The test suite passes before, during (at every checkpoint), and after. If a test fails after a refactor, the refactor changed behaviour — investigate before "fixing" the test.

For refactor: behaviour is preserved end-to-end.
For migration / upgrade: behaviour is preserved at the surface; the implementation moves from API A to API B.

### 2. Periodic architectural validation

For refactor: `{{cmdValidateDeps}}` after every 10 files (the framework convention; the audit may set a different frequency). For migration: after every wave. Per-checkpoint validation catches drift early; final-only validation lets drift accumulate.

### 3. Each file modified individually

No bulk codemods. No `sed` over hundreds of files in one commit. Bulk operations hide subtle context-specific deviations. Each file is reviewed and modified deliberately.

### 4. Document every shim

Every shim added during the work has:

- A **shim path** (where it lives)
- A **forward target** (what it forwards to)
- A **removable-when criterion** (verifiable; e.g., `git grep -c '<old-API>' src/` returns 0)

A shim without a removal criterion is permanent. Permanent shims accumulate as architectural debt.

### 5. Prove deletion safety

For every deleted symbol:

- `git grep -n '<symbol>' src/ tests/` shows zero callers
- Dynamic-dispatch / string-based lookup is checked separately (grep for the symbol's *string form*)

Paste the grep output into `## Self-review`. Deletion without grep-evidence is unsafe.

### 6. Promote out-of-scope findings

Anything you discover that's not on the audit's (or migration plan's) list gets *promoted* to the audit, not silently fixed. Scope creep dilutes the refactor's review.

## What does not belong

- **In a refactor:** new features, behavioural improvements, "while I'm here" semantic changes.
- **In a migration:** behavioural drift bundled with the surface change.
- **In `## Findings`:** durable architectural concerns not promoted upstream.

## Anti-patterns

- Silencing a validation failure by editing the validator config
- "While I'm here" semantic changes
- Bulk codemods touching hundreds of files in one commit
- Deleting code without grep-evidence
- Skipping checkpoint validation
- Refactoring tests "for clarity" alongside production code
- Shims with no removal criteria

## See also

- `.agents/templates/task-refactor.md` — the refactor task template
- `.agents/templates/task-migration.md` — the migration task template
- `.agents/templates/audit.md` — the input doc type
- `.agents/skills/empirical-proof/SKILL.md`
- `.agents/skills/personas/SKILL.md` — The Janitor / The Migrator personas
