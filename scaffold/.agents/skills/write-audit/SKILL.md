---
name: write-audit
description: Load when authoring an audit.md file (or deepening an existing one). Encodes the audit's discipline — findings cite file:line, every issue has a "Needed", issues prioritised by impact, risks made explicit, dynamic invariants verified.
---

# Skill: write-audit

## Purpose

An audit makes a codebase area *legible* so downstream work can be planned. The audit is honest observation, not prescription. This skill keeps the audit specific, prioritised, and actionable.

## Core rules

### 1. State the goal first

Without a goal, "current state" has no meaning. The goal is a measurable target ("make the billing module's invariants explicit and surface anything blocking us from changing the pricing engine in Q3"), not a vague intention ("improve the billing module").

### 2. Findings cite file and line

Every finding includes `<path>:<line>`. Vague observations ("error handling could be better") get demoted or removed. The Janitor reading the audit must be able to navigate to each finding directly.

### 3. Every issue has a "Needed"

For every finding, state the concrete change that would close it. The Needed is *what* must change, not *how* to change it (the how is the Janitor's call). Examples:

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

## See also

- `.agents/templates/audit.md` — the audit doc template
- `.agents/templates/task-audit.md` — the audit-writing task template
- `.agents/skills/adversarial-review/SKILL.md` — sister skill for the hostile reading
- `.agents/skills/personas/SKILL.md` — The Auditor persona
