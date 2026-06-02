# Bug: <Symptom in one sentence>

## Status

Active / Closed

## Author

The Bug Hunter

## Context

How the bug was reported (human ticket, agent observation, CI failure). The audience for this report
is the future fixer.

---

## Linked docs

- Reporter: <human / agent>
- Spec defining the broken behaviour (if any): `<path>`
- Related audit: `<path>`

---

## Reported behaviour

What the reporter observed. Quote or paraphrase.

---

## Reliable reproduction

The minimal, deterministic reproduction. Once found, all other attempts are noise.

**Steps:**

1. <step>
2. <step>
3. <step>

**Expected:** <what should happen>

**Actual:** <what does happen>

**Conditions:** environment, version, config that affect reproducibility.

---

## Reproduction attempts (history)

(Optional but useful when the reproduction was hard to find.)

| # | Steps | Result | Status |
| - | ----- | ------ | ------ |
| 1 |       |        | [reproduces / does not reproduce / partial] |

---

## Hypothesis tracker

| # | Hypothesis | Evidence | Status |
| - | ---------- | -------- | ------ |
| 1 |            |          | [confirmed / disproven / supports / unverified] |

---

## Root cause

State the cause precisely: file, line, what state combines with what input to produce the symptom.
Examples:

- Bad: "The function returns null."
- Good: "`getPricing()` (`src/billing/pricing-adapter.ts:42`) returns null when the cache is cold and
  the upstream Stripe call is rate-limited; the caller `quote.ts:88` interprets null as
  'fallback to default tier' instead of throwing."

---

## Related defects

Defects nearby that may share a root cause or a pattern. Note them even if out of scope for the fix.

- `<path>:<line>` — <description>

---

## Regression test plan

A test that:

- Sets up the conditions identified in Reliable reproduction
- Asserts the expected behaviour
- Lives at <suggested path>

If the test runner makes this difficult, note the gap.

---

## Open questions

- [ ] **[MINOR]** <questions that would refine the fix's scope>

---

## Distillation Loss Statement

(For bug reports distilled from a long investigation)

**Dropped from upstream:**

- <what>

**Why downstream doesn't need this:**

- <why>
