---
name: write-refactor
description: Restructure code to address audit findings without changing surface behaviour. ALWAYS apply this skill when the user asks to refactor, restructure, clean up, extract, or address an audit's "Needed" items — only when behaviour is preserved. Do not change observable behaviour, batch unrelated structural changes together, or remove a shim without proving call-site coverage. Skip this skill for behaviour-changing rewrites of existing modules, API/framework migrations, or net-new feature implementation against a fresh spec.
---

# Skill: write-refactor

## Purpose

Refactors fail when behaviour drifts silently or when shims become permanent. This skill is the discipline that keeps the change *structural* (not behavioural) and ensures every shim has a documented exit.

A refactor restructures code while preserving behaviour end-to-end. The audit drives the changes; the structure improves; the surface and semantics stay the same. Anything that *also* changes the surface — replacing one API with another, upgrading a framework version — is a different discipline (API/framework migration) and belongs in a separate task.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`, plus an optional dep-validation command (e.g. `pnpm dep-cruise`) used at the every-N-files architectural checkpoint — not in the standard contract; ask the user if the project uses one. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. Behaviour preservation is non-negotiable — proven by an equivalence check that fails if behaviour changed

The test suite passes before, during (at every checkpoint), and after. If a test fails after a refactor, the refactor changed behaviour — investigate before "fixing" the test.

But a green suite is **necessary, not sufficient**: "the existing tests still pass" only proves the refactor didn't break what was already covered, not that behaviour is unchanged where coverage is thin. The gate is an *equivalence check* — one that would **fail if behaviour changed**, generalising a bug-fix's fail-before / pass-after oracle to the whole refactored surface. Pick the strongest available:

- **Property-based** — assert invariants over generated inputs across the old and new code paths.
- **Differential** — run old and new implementations on the same inputs and assert byte-equal outputs (keep the pre-refactor code reachable behind the shim until the diff is clean).
- **Golden-output** — capture the pre-refactor output for a representative input set, then assert the post-refactor output matches it.

If no stronger check than the existing suite is available for a given change, **record explicitly in `## Self-review` why the existing suite is a sufficient oracle for this change** — e.g. the changed lines are exhaustively covered by named tests, with the coverage shown. "The suite is green" stated without that justification does not satisfy this gate.

### 2. Periodic architectural validation

Run the project's dependency-validation command after every 10 files (or at the audit's chosen checkpoint frequency). Per-checkpoint validation catches drift early; final-only validation lets drift accumulate.

### 3. Each file modified individually

No bulk codemods. No `sed` over hundreds of files in one commit. Bulk operations hide subtle context-specific deviations. Each file is reviewed and modified deliberately.

### 4. Document every shim

Every shim added during the refactor has:

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

Anything you discover that's not on the audit's list gets *promoted* to the audit, not silently fixed. Scope creep dilutes the refactor's review.

## What does not belong

- **In a refactor:** new features, behavioural improvements, "while I'm here" semantic changes, surface-level API replacements (those are migrations — different discipline).
- **In `## Findings`:** durable architectural concerns not promoted upstream.

## Anti-patterns

- Silencing a validation failure by editing the validator config
- Treating "the existing suite is green" as proof of equivalence without a check that would fail if behaviour changed (or a recorded reason the suite is a sufficient oracle)
- "While I'm here" semantic changes
- Bulk codemods touching hundreds of files in one commit
- Deleting code without grep-evidence
- Skipping checkpoint validation
- Refactoring tests "for clarity" alongside production code
- Shims with no removal criteria

## Bundled resources

- `references/task-template.md` — a fillable refactor-task template with before/after state, shim contracts table, plan, progress checklist with per-batch validation slots, and a self-review hard gate covering behaviour preservation (the equivalence-check paste slot), architectural cleanliness, shim hygiene, and deletion safety.

Substitute the `{{...}}` placeholders and fill in as you work.
