---
name: write-rewrite
description: Re-implement a module with explicit behaviour changes. ALWAYS apply this skill when the user asks to rewrite a module with new behaviour, replace an implementation, or re-do something that was wrong — when behaviour will change deliberately. Do not start before the behaviour delta is explicit and recorded, preserve unintended differences, or proceed past an unplanned behaviour change without halting and updating the spec. Skip this skill for behaviour-preserving cleanup of existing modules, API/framework migrations, or net-new feature implementation against a fresh spec.
---

# Skill: write-rewrite

## Purpose

Rewrites are riskier than refactors precisely because behaviour is *permitted* to change. Without discipline, unintended changes hide. This skill forces the behaviour delta to be explicit — the contract between the spec and the implementation about what changes and what doesn't.

A rewrite is not a refactor. A refactor preserves behaviour end-to-end; a rewrite changes some of it deliberately. If your task changes no behaviour, it's a refactor (use the refactor discipline). If it changes some behaviour, it's a rewrite (this skill).

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`. If `AGENTS.md` is missing or a referenced entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. Behaviour delta is explicit

Before writing code, fill in a behaviour-delta table with every aspect that changes:

| Aspect | Before | After |
| ------ | ------ | ----- |
|        |        |       |

Anything *not* in the delta must be preserved. The table is the contract.

### 2. Acceptance criteria include preservation criteria

Acceptance criteria cover both:

- The *new* behaviour (what changed)
- The *preserved* behaviour (what stayed the same — explicitly stated)

A rewrite that only tests the new behaviour misses the regression risk.

### 2a. The delta gets acceptance-criteria coverage; the non-delta gets behaviour-preservation

A rewrite has two surfaces, and each is verified differently:

- **The delta (what changed).** Each changed behaviour is a spec acceptance criterion, and the spec bound each one to a check — `test`, `command`, or `manual`. Honour that binding: in `## Self-review`, list every changed-behaviour criterion, the check the spec named for it, and the pasted result of running that check. A `test`-bound criterion is covered only when its oracle is shown to be valid — it fails when the criterion is violated and passes when satisfied (prove it by flipping the assertion); a `command`-bound criterion by the pasted output of the project command (resolved via `AGENTS.md > Commands`); a `manual` criterion by the one-line reason it can't be runnable plus the judgement made. A green suite is not coverage — the delta is covered only when each changed behaviour's result is in the task file.

- **The non-delta (everything else).** Everything *outside* the recorded delta must be behaviour-preserved, and the proof is an *equivalence check that would fail if behaviour changed* — not merely "the suite is green". Where the project has one, name a property-based, differential, or golden-output check that pins the preserved surface; where it doesn't, record explicitly *why* the existing test suite is a sufficient oracle for this change (which preserved behaviours it actually exercises). The existing suite passing is necessary but not sufficient. This generalises the fix discipline's fail-before / pass-after oracle to the whole non-delta surface.

The two are complementary: AC-coverage proves you built the *intended* change; behaviour-preservation proves you changed *nothing else*.

### 3. Identify all affected callers

For every changed behaviour, grep for callers. Update each one for the new behaviour, or verify each one still works under the preserved behaviour.

### 4. Halt and update the spec on emergent behaviour changes

If during implementation you discover a behaviour change that *isn't* in the delta — stop. Update the spec to authorise the change (or revise to keep the original behaviour). Silent emergent changes are the failure mode.

### 5. Module plan documented

A module plan lists which modules will be touched and what changes in each. The reviewer can use it to verify the diff matches the plan.

### 6. Run validation after every batch

The project's validation command runs after every batch of changes, not only at the end. Catching drift early is cheaper than catching it at the end.

## What does not belong

- **In a rewrite:** behaviour changes that aren't in the delta, scope expansion to "redesign while we're here".
- **In `## Module plan`:** modules with `Behavior change?` left blank — make the call.

## Anti-patterns

- Behaviour changes that aren't in the delta table
- Treating "rewrite" as a license to redesign
- Not updating callers for behaviour changes
- Calling it a refactor when behaviour changes (mislabelling)
- Calling it a rewrite when behaviour is preserved (over-marking; should be refactor)
- Treating a green suite as proof the non-delta surface was preserved (no equivalence check that fails if behaviour changed)
- Declaring done with a changed behaviour that isn't mapped to its check and a pasted result

## Bundled resources

- `references/task-template.md` — a fillable rewrite-task template with behaviour-delta table, acceptance criteria, module plan, progress checklist, and a self-review hard gate whose Self-review carries both a behaviour-delta regression paste slot (each changed behaviour → its check → result) and a behaviour-preservation paste slot for the non-delta surface (the equivalence check that fails if anything outside the delta changed). Copy it into your project's task file location, substitute the `{{...}}` placeholders, and fill it in as you work.
