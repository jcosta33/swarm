---
name: write-fix
description: Fix a bug from a bug-report. ALWAYS apply this skill when the user asks to fix, patch, resolve, or close a bug, regression, or defect — including hot-fixes and revert-and-re-fix flows. Do not patch the symptom, ship a fix without a regression test that fails before and passes after, or scope-creep into unrelated changes. Skip this skill for authoring the bug-report itself (a separate upstream task), behaviour-preserving refactors, or behaviour-changing rewrites of existing modules.
---

# Skill: write-fix

## Purpose

Fixes fail when they patch symptoms or when the regression test doesn't actually exercise the bug. This skill is the discipline that ensures the bug stays fixed.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`. If `AGENTS.md` is missing or a referenced entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. Reproduce in your worktree before patching

Re-run the bug report's reproduction in your worktree. Confirm the bug fires. Paste the output. The worker who wrote the bug report ran the reproduction in their environment; you run it in yours.

If you can't reproduce, *do not patch*. Investigate the env discrepancy first; surface as a `## Blocker` if needed.

### 2. Patch the root cause, not the symptom

The bug report cites the root cause at `<file>:<line>`. Patch *there*, not at the symptom. Symptom-patches let the bug recur via a different path.

### 3. Regression test fires before the fix and passes after

The regression test is the proof the bug is gone:

- Patch out your fix; run the test → must fail (proves the test exercises the bug).
- Restore the fix; run the test → must pass.

Paste *both* outputs into Self-review (or at minimum, the failing-then-passing transition).

### 4. No scope creep

Bugs often have neighbours. You found one (or the bug report did). The fix task addresses *the* bug; related findings get *promoted* to follow-up bug-reports or audits.

### 5. Run the full test suite

A fix that passes the regression test but breaks elsewhere is a worse bug. Run the project's full test command after the patch; paste the output.

### 6. Document the patch's reasoning

Why this patch addresses the root cause (and not just the symptom) goes in `## Decisions`. The reviewer of the fix will check this.

### 7. Mistrust your own confidence

Adopt an adversarial stance toward your own patch. If you find yourself thinking "this should fix it" without having flipped the regression test to red and back to green, that's the gate failing — finish the proof before declaring done.

## What does not belong

- **In a fix task:** unrelated cleanup, "while I'm here" improvements, multiple bug fixes bundled.
- **In the regression test:** assertions on internal state (test the *behaviour* the bug broke).
- **In `## Decisions`:** "the patch worked" — that's a verification output, not a decision.

## Anti-patterns

- Patching the symptom instead of the root cause
- Skipping reproduction in your worktree
- Regression test that doesn't fail before the fix
- Scope creep ("while I'm here, this related bug…")
- Bundling the fix with unrelated cleanup

## Bundled resources

- `references/task-template.md` — a fillable fix-task template with reproduction block, plan, progress checklist, and a self-review hard gate that requires pre-patch and post-patch reproduction output. Copy it into your project's task file location, substitute the `{{...}}` placeholders, and fill it in as you work.
