# Audit: <Area>

## Status

Active / Resolved

## Author

The Auditor (or The Skeptic if this is a deepen-audit)

## Context

Why this audit exists. The triggering ask, the goal it serves.

---

## Linked docs

- Triggering brief / ask: <path or paragraph>
- Prior audit (if deepening): `.agents/audits/<prior-slug>.md`
- Related specs: `.agents/specs/<slug>.md`

---

## Goal

What "good" looks like for this area. Without a goal, "current state" has no meaning.

---

## Scope

**In scope:**

- (specific code paths under audit)

**Out of scope:**

- (related areas explicitly excluded)

---

## Code paths inspected

- `<path>` — <one-line description of what's there>

---

## Findings

Each finding has: severity (BLOCKER / MAJOR / MINOR), file:line, observation, and a **Needed** —
the concrete change that would close it.

### Issue 1 — <name> [SEVERITY]

- **File:line:** `<path>:<line>`
- **Observation:** <what is true today>
- **Needed:** <what change closes this>
- **Verified by:** <grep results, validation output, or other evidence>

### Issue 2 — ...

---

## Risks

Things that could go wrong, weren't observed firing yet, but warrant explicit naming. Each risk
includes the conditions under which it would fire.

---

## Suggested approaches

How a downstream task (refactor, performance, fix) could address the findings. Suggest the
*approach*, not the implementation. Sequence if multiple approaches interact.

---

## Open questions

- [ ] **[CRITICAL]** Questions that would change the audit's prioritisation if answered.
- [ ] **[MINOR]** Worth recording.

---

## Distillation Loss Statement

(For audits distilled from a long-running investigation or a prior audit)

**Dropped from upstream:**

- <what>

**Why downstream doesn't need this:**

- <why>
