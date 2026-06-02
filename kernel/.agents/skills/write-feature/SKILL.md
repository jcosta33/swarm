---
name: write-feature
description: Implement a feature from a spec. ALWAYS apply this skill when the user asks to implement, build, or add a feature, when a spec doc is referenced, or when an acceptance criterion is named — even if the user does not name the spec explicitly. Do not start writing feature code directly without first surveying patterns, mapping criteria to steps, and halting on ambiguity. Skip this skill for bug-fix work against an existing implementation, behaviour-preserving refactors, or behaviour-changing rewrites of existing modules.
---

# Skill: write-feature

## Purpose

Features fail when the agent improvises around the spec. This skill is the discipline that keeps the implementation aligned with the spec, while still allowing the implementer to make implementation choices the spec doesn't constrain.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`. An optional dep-validation command (architectural-rules check) is not in the standard contract; ask the user if the project uses one. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. Read the spec in full before coding

Not the summary; the full spec. Every acceptance criterion gets mapped to an implementation step *before* implementation begins.

### 2. Survey existing patterns

Before introducing a new helper, type, or pattern, search the codebase for existing equivalents. Reinvention is forbidden. If existing patterns don't fit, *say so* in `## Decisions` with reasoning.

### 3. Halt on ambiguity

If the spec is unclear or contradictory, stop. Surface the question in `## Blockers`. Wait for the spec to be updated. Do not invent the requirement.

### 4. No opportunistic refactoring

Refactor and feature work are different scopes. If you spot architectural debt while implementing, *promote it* to an audit; do not silently fix it.

### 5. Run validation after every batch

The project's validation command runs after every batch of changes, not only at the end. Catching a violation at batch 3 is cheaper than catching it after batch 12. Paste the output into the progress checklist.

### 6. Tests are part of the deliverable

Every acceptance criterion has a corresponding test (or notes the test in a `testing` follow-up task).

### 7. Map every acceptance criterion to its check and paste the result

The spec binds each acceptance criterion to a check — `test`, `command`, or `manual`. Honour that binding: in `## Self-review`, list every criterion, the check the spec named for it, and the pasted result of running that check. A criterion is only covered when its result is in the task file.

- A `test`-bound criterion is covered only when its oracle is shown to be valid — it fails when the criterion is violated and passes when satisfied (prove it by flipping the assertion). A test that passes no matter what proves nothing.
- A `command`-bound criterion is covered by the pasted output of the named project command (resolved via `AGENTS.md > Commands`).
- A `manual` criterion is covered by recording the one-line reason it can't be a runnable check and the human judgement made.

A green toolchain suite is not coverage. The suite proves the code is well-formed; this mapping proves the code does what the spec asked. Do not declare done with an unmapped criterion.

### 8. Paste verification output

`## Self-review` requires verbatim verification output. Paraphrase is not proof: paste the last two lines of every command run, in a fenced code block, unmodified.

## What does not belong

- **In a feature task:** refactoring of unrelated code, new dependencies not authorised by the spec, "while I'm here" cleanup.
- **In `## Decisions`:** silent ambiguity resolutions (these go in `## Blockers` instead).

## Anti-patterns

- Implementing past the spec ("while I'm here…")
- Silently resolving spec ambiguities
- Declaring done without verification output
- Declaring done with an acceptance criterion that isn't mapped to its check and a pasted result
- Treating a green toolchain suite as proof the spec's intent was met
- Reinventing helpers that already exist
- Suppressing architectural-violation warnings
- "I'll add tests later"

## Bundled resources

- `references/task-template.md` — a fillable feature-task template with progress checklist, decisions log, findings, blockers, next steps, and a self-review hard gate. Copy it into your project's task file location, substitute the `{{...}}` placeholders with project values, and fill it in as you work.
