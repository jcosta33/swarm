# 📊 Document: audit.md

> **TL;DR.** Present-looking, observational document describing the *current state* of a codebase area against a defined goal. Authored by The Auditor. Spawns `refactor` tasks (or `deepen-audit`, `performance`, `bug-report-writing` depending on findings). Findings cite file:line; every issue has a "Needed".

---

## 🎯 Purpose

Make a codebase area *legible* — what exists, what's broken, what risks lurk — so downstream work can be planned. The audit is honest observation. It does not prescribe; it describes.

---

## 📍 Where it lives

`.agents/audits/{{slug}}.md`

When all "Needed" entries close, archive to `.agents/audits/resolved/`.

---

## ✍️ Authoring persona

[The Auditor](../personas/the-auditor.md). For deepening an existing audit, [The Skeptic](../personas/the-skeptic.md) takes over (task type: `deepen-audit`).

---

## 📐 Template

```markdown
# Audit: <Area>

## Status

Active / Resolved

## Author

The Auditor (or The Skeptic if this is a deepen-audit)

## Context

Why this audit exists. The triggering ask, the goal it serves.

## Linked docs

- Triggering brief / ask: <path or paragraph>
- Prior audit (if deepening): `.agents/audits/<prior-slug>.md`
- Related specs: `.agents/specs/<slug>.md`

## Goal

What "good" looks like for this area. Without a goal, "current state" has no meaning.

## Scope

**In scope:**

- (specific code paths under audit)

**Out of scope:**

- (related areas explicitly excluded)

## Code paths inspected

- `<path>` — <one-line description of what's there>

## Findings

Each finding has: severity (BLOCKER / MAJOR / MINOR), file:line, observation, and a **Needed** —
the concrete change that would close it.

### Issue 1 — <name> [SEVERITY]

- **File:line:** `<path>:<line>`
- **Observation:** <what is true today>
- **Needed:** <what change closes this>
- **Verified by:** <grep results, validation output, or other evidence>

### Issue 2 — ...

## Risks

Things that could go wrong, weren't observed firing yet, but warrant explicit naming. Each risk
includes the conditions under which it would fire.

## Suggested approaches

How a downstream task (refactor, performance, fix) could address the findings. Suggest the
*approach*, not the implementation. Sequence if multiple approaches interact.

## Open questions

- [ ] **[CRITICAL]** Questions that would change the audit's prioritisation if answered.
- [ ] **[MINOR]** Worth recording.

## Distillation Loss Statement

(For audits distilled from a long-running investigation or a prior audit; see [`concepts/03-distillation.md`](../concepts/03-distillation.md))
```

---

## 🛠️ Worked example

See [The Auditor's worked example](../personas/the-auditor.md#%EF%B8%8F-example-how-the-auditor-resolves-a-representative-issue) — the `src/billing/` audit with a BLOCKER, MAJOR, and MINOR finding plus risks and a sequenced suggested approach.

---

## 🪜 Severity scale

| Severity   | Meaning                                                                          |
| ---------- | -------------------------------------------------------------------------------- |
| **BLOCKER** | Must address before downstream work can proceed safely (e.g., before a Q3 commit) |
| **MAJOR**  | Should address; significant impact on quality, reliability, or security           |
| **MINOR**  | Worth noting; low impact; cleanup-class                                           |

Severity is calibrated by *impact*, not by *order of discovery*. The Auditor explicitly justifies any unusual promotion or demotion.

---

## ⚠️ Failure modes the `write-audit` skill prevents

- **Findings without file:line citations** (vague observations promoted to findings)
- **Findings without "Needed" entries** (the next session can't act)
- **Flat lists not prioritised by impact**
- **Empty Risks** (the auditor saw none, or didn't think to look)
- **Trusting structural claims** ("this is internal-only") without grepping
- **Prescribing fixes as findings** (Needed states the change; the fix is downstream)

---

## See also

- [`tasks/audit-writing.md`](../tasks/audit-writing.md) — the authoring task
- [`tasks/deepen-audit.md`](../tasks/deepen-audit.md) — re-walking an existing audit
- [`tasks/refactor.md`](../tasks/refactor.md) — the downstream task that consumes the audit
- [`personas/the-auditor.md`](../personas/the-auditor.md) — the authoring persona
- [`skills/write-audit.md`](../skills/write-audit.md) — the authoring skill
- [`skills/adversarial-review.md`](../skills/adversarial-review.md) — the auditor's mindset skill
- [`extended.md`](extended.md) — benchmark report and cleanup list variants
