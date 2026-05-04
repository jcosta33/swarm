# 🐛 Document: bug-report.md

> **TL;DR.** Past-looking, evidential document describing a defect: reliable reproduction, root cause, regression test plan. Authored by The Bug Hunter. Spawns `fix` tasks (which adopt the Skeptic mindset). The fixer must be able to patch from this report alone, with zero re-investigation.

---

## 🎯 Purpose

Capture the deterministic reproduction and root cause of a defect. The deliverable is a report a fixer can act on without re-discovering. The fix is a *separate* task — see [ADR 0007](../adrs/0007-bug-report-as-meta-task.md).

---

## 📍 Where it lives

`.agents/bugs/{{slug}}.md`

When the fix ships *and* a regression test exists, archive to `.agents/bugs/closed/`.

---

## ✍️ Authoring persona

[The Bug Hunter](../personas/the-bug-hunter.md).

---

## 📐 Template

```markdown
# Bug: <Symptom in one sentence>

## Status

Active / Closed

## Author

The Bug Hunter

## Context

How the bug was reported (human ticket, agent observation, CI failure). The audience for this report
is the future fixer.

## Linked docs

- Reporter: <human / agent>
- Spec defining the broken behaviour (if any): `<path>`
- Related audit: `<path>`

## Reported behaviour

What the reporter observed. Quote or paraphrase.

## Reliable reproduction

The minimal, deterministic reproduction. Once found, all other attempts are noise.

**Steps:**

1. <step>
2. <step>
3. <step>

**Expected:** <what should happen>

**Actual:** <what does happen>

**Conditions:** environment, version, config that affect reproducibility.

## Reproduction attempts (history)

(Optional but useful when the reproduction was hard to find.)

| # | Steps | Result | Status |
| - | ----- | ------ | ------ |
| 1 |       |        | [reproduces / does not reproduce / partial] |

## Hypothesis tracker

| # | Hypothesis | Evidence | Status |
| - | ---------- | -------- | ------ |
| 1 |            |          | [confirmed / disproven / supports / unverified] |

## Root cause

State the cause precisely: file, line, what state combines with what input to produce the symptom.
Examples:

- Bad: "The function returns null."
- Good: "`getPricing()` (`src/billing/pricing-adapter.ts:42`) returns null when the cache is cold and
  the upstream Stripe call is rate-limited; the caller `quote.ts:88` interprets null as
  'fallback to default tier' instead of throwing."

## Related defects

Defects nearby that may share a root cause or a pattern. Note them even if out of scope for the fix.

- `<path>:<line>` — <description>

## Regression test plan

A test that:
- Sets up the conditions identified in Reliable reproduction
- Asserts the expected behaviour
- Lives at <suggested path>

If the test runner makes this difficult, note the gap.

## Open questions

- [ ] **[MINOR]** <questions that would refine the fix's scope>

## Distillation Loss Statement

(For bug reports distilled from a long investigation; see [`concepts/03-distillation.md`](../concepts/03-distillation.md))
```

---

## 🛠️ Worked example

See [The Bug Hunter's worked example](../personas/the-bug-hunter.md#%EF%B8%8F-example-how-the-bug-hunter-resolves-a-representative-issue) — the proxy-streaming corruption bug, with a deterministic reproduction, a disconfirmed first hypothesis, a confirmed second hypothesis, and a related-defects search.

---

## ⚠️ Failure modes the `write-bug-report` skill prevents

- **Reporting the symptom as the bug**
- **Speculating about cause without reproducing**
- **Conflating "I think" with "I have proven"**
- **Bug reports that read as "module X is broken"** (no actionable cause)
- **Skipping the related-defects search**
- **Missing regression test plan**

---

## 🪞 Why bug-report is its own meta-task

The diagnosis and the fix have *different mindsets*, *different empirical proofs*, and *different ways of being wrong*. Splitting them into two tasks lets each session be done well:

- **bug-report-writing** (The Bug Hunter): forensic, hypothesis-driven, read-only on code.
- **fix** (The Skeptic-as-fixer): adversarial about the patch, runs the regression test, verifies the cause.

A combined "diagnose-and-fix" task tends to short-circuit the diagnosis at the first plausible explanation. The split forces the diagnosis to stand on its own.

See [ADR 0007](../adrs/0007-bug-report-as-meta-task.md) for the full reasoning.

---

## See also

- [`tasks/bug-report-writing.md`](../tasks/bug-report-writing.md) — the authoring task
- [`tasks/fix.md`](../tasks/fix.md) — the downstream fix task
- [`personas/the-bug-hunter.md`](../personas/the-bug-hunter.md) — the authoring persona
- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — the fix persona
- [`skills/write-bug-report.md`](../skills/write-bug-report.md) — the authoring skill
- [ADR 0007](../adrs/0007-bug-report-as-meta-task.md) — why bug-report is meta
