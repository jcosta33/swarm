---
name: write-migration
description: Migrate an API or upgrade a framework / language / library version across the codebase. ALWAYS apply this skill when the user asks to upgrade, migrate, port, or transition between API versions, framework majors, or language versions — including breaking-change adoption and codemod-driven sweeps. Do not change unrelated behaviour, skip wave-by-wave validation, or remove a shim without verifiable callsite coverage proof. Skip this skill for behaviour-preserving refactors of internals at a single API version, or implementing net-new features against a fresh spec at the new API version.
---

# Skill: write-migration

## Purpose

Migrations fail in two characteristic ways: the codebase ends up in a half-migrated state where some callsites use the old API and some use the new one indefinitely, or the migration "completes" with old-API callsites still lurking in dynamic dispatch, generated code, or string-based lookups the grep didn't catch. This skill is the discipline that prevents both.

A migration moves the implementation from API A to API B (framework upgrade, language version bump, library replacement). Behaviour at the surface is preserved; the implementation moves. Anything that *also* changes behaviour is a separate task — promote it.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation` (run after every wave; never let two waves' worth of breakage accumulate), `Commands > Test`. An optional dep-validation command (architectural-rules check) is not in the standard contract; ask the user if the project uses one. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. Surface-level behaviour is preserved — proven by an equivalence check that fails if behaviour changed

The test suite passes before, during (at every wave checkpoint), and after. Behaviour at the surface — what callers observe — does not change. The *implementation* moves; the *contract* doesn't. If a test fails after a wave, investigate before "fixing" the test.

But a green suite is **necessary, not sufficient**: "the existing tests still pass" only proves the migration didn't break what was already covered, not that behaviour is unchanged where coverage is thin. The gate is an *equivalence check* — one that would **fail if behaviour changed**, generalising a bug-fix's fail-before / pass-after oracle to the whole migrated surface. Pick the strongest available:

- **Property-based** — assert invariants over generated inputs across the old-API and new-API code paths.
- **Differential** — run the old API and the new API on the same inputs and assert byte-equal outputs (keep the old path reachable behind the shim until the diff is clean — a migration's shims make this the natural fit).
- **Golden-output** — capture the pre-migration output for a representative input set, then assert the post-migration output matches it.

If no stronger check than the existing suite is available for a given change, **record explicitly in `## Self-review` why the existing suite is a sufficient oracle for this change** — e.g. the migrated callsites are exhaustively covered by named tests, with the coverage shown. "The suite is green" stated without that justification does not satisfy this gate.

### 2. Plan in waves

Break the migration into waves. The codebase must compile and pass tests after each wave, not only at the end. A wave is the smallest atomic change that leaves the codebase functional. Document the waves up front; don't discover them mid-migration.

### 3. Validate after every wave

Run the project's validation command and test command at the end of every wave. Per-wave validation catches drift early; final-only validation lets drift accumulate across waves until untangling becomes its own project.

### 4. Each file migrated individually

No bulk codemods, no `sed` over hundreds of files in one commit, no shell loops over files. Bulk operations hide subtle context-specific deviations (a callsite uses the API in an unusual way; the codemod's fixed substitution silently breaks it). Each file is reviewed and migrated deliberately.

### 5. Track callsite coverage explicitly

Count the callsites of the old API up front; track per wave how many are migrated and how many remain. The migration is not done until the count of remaining old-API callsites (outside of explicit shims) is zero. Grep the *whole codebase*, not just the modules the migration was scoped to.

### 6. Document every shim

A compatibility shim lets old callers keep working while the migration proceeds. Every shim has:

- A **shim path** (where it lives)
- A **forward target** (what it forwards to)
- A **removable-when criterion** (verifiable; e.g., `git grep -c '<old-API>' src/` returns 0)

A shim without a removal criterion is permanent. Permanent shims are the migration's lasting cost; the criterion is the contract that prevents it.

### 7. Search beyond grep

Static text-search misses dynamic dispatch, string-based lookups, generated code, and reflection. After grep, audit explicitly:

- Dynamic-dispatch sites (interface implementations, virtual methods)
- String-based references (registry lookups, dependency injection by name)
- Generated code (build outputs, codegen templates)
- Test fixtures and snapshots

Paste the audit results into `## Self-review`.

### 8. Promote out-of-scope findings

Anything you discover that's not on the migration plan's list gets *promoted* to an audit, not silently fixed. "While I'm migrating" semantic changes destroy the migration's reviewability.

## What does not belong

- **In a migration:** behavioural drift bundled with the surface change. If the new API behaves differently and that's intentional, the divergence is a separate spec/task.
- **In `## Findings`:** durable architectural concerns not promoted upstream.

## Anti-patterns

- Bulk codemods touching hundreds of files in one commit
- Skipping per-wave validation; running it only at the end
- Declaring the migration done with old-API callsites still present (outside of explicitly-tracked shims)
- Shims without removal criteria
- "While I'm migrating" semantic changes
- Trusting grep alone — dynamic dispatch and string lookups are not text-searchable
- Wave plans drawn up after the migration started

## Bundled resources

- `references/task-template.md` — a fillable migration-task template with source/target, wave plan, compatibility shims, callsite tracker, per-wave validation slots, and a self-review hard gate covering wave integrity, callsite coverage, shim hygiene, behaviour preservation (the equivalence check), and final state.

Substitute the `{{...}}` placeholders and fill in as you work.
