---
name: write-audit
description: Author an audit of present state. ALWAYS apply this skill when the user asks for a code audit, architecture review, technical-debt survey, or quality assessment of an existing codebase area — including deepening an existing audit. Do not prescribe new behaviour (that goes in a spec), include vague findings without file:line references, or leave any issue without a "Needed" line. Skip this skill for forward-looking specifications or defect reproduction — audits describe what is, not what should be or what broke.
---

# Skill: write-audit

## Purpose

An audit makes a codebase area *legible* so downstream work can be planned. The audit is honest observation, not prescription. This skill keeps the audit specific, prioritised, and actionable.

## Project context (the AGENTS.md contract)

When verifying dynamic invariants (rule 5) — running the project's validation, exercising lifecycle code, or checking that claimed thread-safety holds — resolve the project commands via the consuming repo's `AGENTS.md`: `Commands > Validation` and, where relevant, `Commands > Test`. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. State the goal first

Without a goal, "current state" has no meaning. The goal is a measurable target ("make the billing module's invariants explicit and surface anything blocking us from changing the pricing engine in Q3"), not a vague intention ("improve the billing module").

### 2. Findings cite file and line

Every finding includes `<path>:<line>`. Vague observations ("error handling could be better") get demoted or removed. The reader of the audit must be able to navigate to each finding directly.

### 3. Every issue has a "Needed"

For every finding, state the concrete change that would close it. The Needed is *what* must change, not *how* to change it (the how is the implementer's call). Examples:

- ✅ **Needed:** Document the contract (`null` = "no pricing rule applies"; throw = "lookup failed"). Migrate the 3 fallback callers.
- ❌ **Needed:** Refactor the pricing adapter.

### 4. Prioritise by impact

Issues sorted by impact, not by order of discovery. The severity scale (BLOCKER / MAJOR / MINOR) is calibrated by *what would happen if not addressed*, not by *how loud the issue feels*.

### 5. Verify dynamic invariants

Static text doesn't tell you everything. Concurrency, lifecycle, resource cleanup — these need active verification. Check whether claimed thread-safety actually holds; whether resources actually clean up; whether the lifecycle the code assumes matches the runtime.

### 6. Search for "no callers anywhere"

Dead code labelled as working is itself a finding. For every public surface, grep for callers. Code with zero callers gets a finding (cleanup recommendation), not a tacit pass.

### 7. Make risks explicit

Risks are things that *could* go wrong but haven't fired yet. Don't leave them implicit. Each risk includes:

- The condition under which it would fire
- The mitigation (or lack of one)
- Whether the risk is in scope for the audit's downstream work

### 8. Adversarial reading

Approach the code assuming it's hiding its flaws. Set aside any prior audit's framing; read the code with fresh eyes. Findings are observation, not narrative validation.

### 9. Pre-deliver visibility gate (forced visible output)

Do not finalise the audit until every issue row has a non-empty `Needed` column and a `<path>:<line>` reference. Before declaring the audit done, output the completeness table:

| Issue ID | `<path>:<line>` present? | Severity | `Needed` non-empty? |
| --- | --- | --- | --- |
| F1 | ✅ / ❌ | BLOCKER / MAJOR / MINOR | ✅ / ❌ |

A row with any ❌ means the audit is not finalisable — halt, fix the row, output the table again. The agent does not deliver the audit to the user until this table is in the task file with all ✅.

## What does not belong

- **In an audit:** prescriptions ("we should refactor X"), forward-looking specifications ("the new behaviour will be Y"), the implementation of fixes.
- **In `## Findings`:** TODO-comment scrapes, surface impressions, vague concerns.
- **In `## Risks`:** `<empty>` (look harder; there are always risks worth naming).

## Anti-patterns

- Listing issues without representative file:line citations
- Presenting fixes as findings
- Leaving Risks and Suggested approaches empty
- Trusting structural claims without grepping
- Audit reads like a TODO list
- Findings sorted by discovery order, not impact

## Bundled resources

- `references/task-template.md` — a fillable audit-writing task template combining the workflow scaffold (metadata, AGENTS.md contract, constraints, progress checklist, decisions, self-review for finding specificity / severity calibration / adversarial completeness) with the deliverable structure inlined as a `## Deliverable` block (goal, scope, code paths, findings with severity + file:line + observation + Needed + evidence, risks, suggested approaches, open questions, Distillation Loss Statement). At session close, copy the `## Deliverable` block to its final home (`<your-audits-dir>/{{slug}}.md`).

Substitute the `{{...}}` placeholders and fill in as you work.
