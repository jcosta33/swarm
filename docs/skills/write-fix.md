# 🛠️ Skill: write-fix

> **Auto-loaded for `fix` tasks.** Codifies the Skeptic-as-fixer's discipline: reproduce in your worktree, address the root cause, add a regression test that fails before and passes after.

---

## 📦 Frontmatter

```yaml
---
name: write-fix
description: Load when fixing a bug from a bug-report.md. Encodes the discipline — reproduce in your worktree, patch the root cause (not the symptom), add a regression test that fails before the fix and passes after, no scope creep.
---
```

---

## 🎯 Purpose

Fixes fail when they patch symptoms or when the regression test doesn't actually exercise the bug. This skill is the discipline that ensures the bug stays fixed.

---

## 🔒 Core rules

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

A fix that passes the regression test but breaks elsewhere is a worse bug. Run `{{cmdTest}}` after the patch; paste the output.

### 6. Document the patch's reasoning

Why this patch addresses the root cause (and not just the symptom) goes in `## Decisions`. The reviewer of the fix will check this.

---

## 🚫 What does not belong

- **In a fix task:** unrelated cleanup, "while I'm here" improvements, multiple bug fixes bundled.
- **In the regression test:** assertions on internal state (test the *behaviour* the bug broke).
- **In `## Decisions`:** "the patch worked" — that's a verification output, not a decision.

---

## ⚠️ Anti-patterns

- Patching the symptom instead of the root cause
- Skipping reproduction in your worktree
- Regression test that doesn't fail before the fix
- Scope creep ("while I'm here, this related bug…")
- Bundling the fix with unrelated cleanup

---

## 🛠️ Worked example

See [the fix task page's worked example](../tasks/fix.md#%EF%B8%8F-worked-example) — the proxy-streaming bug, where the Skeptic-as-fixer reproduces in their worktree, patches at the root cause (`src/server/proxy.ts:88`), adds a regression test that streams ≥ 16 MB, and verifies the test fails-then-passes.

---

## See also

- [`tasks/fix.md`](../tasks/fix.md)
- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — the persona in fixer mode
- [`documents/bug-report.md`](../documents/bug-report.md) — the input
- [`empirical-proof.md`](empirical-proof.md)
- [ADR 0006](../adrs/0006-skeptic-owns-fix-tasks.md) — why The Skeptic
