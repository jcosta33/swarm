# 🛠️ Skill: write-bug-report

> **Auto-loaded for `bug-report-writing` tasks.** Codifies the failure modes the bug-report doc type is built to prevent: reporting symptom as root cause, speculating without reproducing, conflating "I think" with "I have proven".

---

## 📦 Frontmatter

```yaml
---
name: write-bug-report
description: Load when authoring a bug-report.md file. Encodes the bug report's discipline — reproduce deterministically before explaining, find the root cause (not the symptom), distinguish observation from inference, propose a regression test.
---
```

---

## 🎯 Purpose

A bug report is the input to a `fix` task. The fixer must be able to patch from the report alone, with zero re-investigation. This skill is the discipline that gets the report there.

---

## 🔒 Core rules

### 1. Reproduce before explaining

A bug is a hypothesis until reproduced. If you cannot reproduce, *say so* — don't speculate about the cause. The reproduction command output is the proof that the bug fires.

### 2. Isolate to the smallest reproduction

Once reproduced, narrow it: minimal input, minimal env, fewest steps. The reproduction in the final report is *the* reproduction; all the attempts that didn't repro are noise (capture them in `## Reproduction attempts` for context but don't lead with them).

### 3. State the root cause precisely

The root cause is *file:line + state + input + caller*. The symptom alone is not the cause.

- ❌ "The function returns null."
- ✅ "`getPricing()` (`src/billing/pricing-adapter.ts:42`) returns null when the cache is cold and the upstream Stripe call is rate-limited; the caller `quote.ts:88` interprets null as 'fallback to default tier' instead of throwing."

### 4. Distinguish observation from inference

- **Observation:** "Reproduction fires deterministically with `NODE_ENV=production` and 12 MB input."
- **Inference:** "The proxy is dropping bytes."

Both are useful; conflating them obscures the trail. Mark inferences in `## Hypothesis tracker` with status `[supports]`/`[disproven]`/`[confirmed]`.

### 5. Search for related defects

For every root cause, grep the codebase for the *pattern* (not just the file). Note related vulnerabilities. The fix task may expand scope to include the related cases (or spawn a separate bug-report).

### 6. Propose a regression test

Identify the test that would catch the regression. State its location and assertion. If the project's test framework makes the test difficult to write, note the gap.

---

## 🚫 What does not belong

- **In a bug report:** the fix. The fix is a downstream task. (See [ADR 0007](../adrs/0007-bug-report-as-meta-task.md).)
- **In `## Root cause`:** speculation. State only what's verified.
- **In `## Reliable reproduction`:** "should reproduce" or "in theory". Either it reproduces deterministically, or you mark the report as `[unable to reproduce]` and document why.

---

## ⚠️ Anti-patterns

- Reporting the symptom as the bug
- Speculating about cause without reproducing
- Conflating "I think this is the problem" with "I have proven this is the problem"
- Bug reports that read as "module X is broken"
- Fixing the bug instead of reporting it
- Skipping the related-defects search

---

## 🛠️ Worked example

See [The Bug Hunter's worked example](../personas/the-bug-hunter.md#%EF%B8%8F-example-how-the-bug-hunter-resolves-a-representative-issue) — the proxy-streaming corruption bug, with a deterministic reproduction, a disconfirmed first hypothesis (buffer-size), a confirmed second hypothesis (chunked-encoding offset), a related-defects search, and a regression test plan.

---

## See also

- [`documents/bug-report.md`](../documents/bug-report.md) — the doc this skill produces
- [`personas/the-bug-hunter.md`](../personas/the-bug-hunter.md)
- [`tasks/bug-report-writing.md`](../tasks/bug-report-writing.md), [`tasks/fix.md`](../tasks/fix.md)
- [`adversarial-review.md`](adversarial-review.md) — sister skill for the hostile reading
- [ADR 0007](../adrs/0007-bug-report-as-meta-task.md) — why bug-report is meta
