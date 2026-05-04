---
name: documentation-gatekeeper
description: Load at session start. Enforces the framework's flow graph — the deterministic mapping from source documents to task types to personas. Refuses forbidden flows (research → fix without spec; spec from finished code; multiple task types per source doc; etc.) and refuses to let durable findings stay in the gitignored task file.
---

# Skill: documentation-gatekeeper

## Purpose

The flow graph encodes the framework's discipline (see `docs/agents/05-flow-graph.md`). Without enforcement, the discipline is just advice. `documentation-gatekeeper` is the enforcement: every transition the agent makes (from source doc to task; from task to terminal output; from finding to upstream promotion) is checked against the flow graph rules.

## Core rules

### 1. Source → task routing is deterministic

For every task launched, the gatekeeper verifies the routing:

- `spec.md` → `feature` (or `rewrite` if behaviour delta is explicit)
- `audit.md` → `refactor` (or `performance` / `deepen-audit` per audit content)
- `bug-report.md` → `fix`
- `research.md` → `spec-writing`
- `migration plan` → `migration`
- `benchmark report` → `performance`

Overrides are explicit (recorded in `## Decisions` with rationale). Silent re-routing is forbidden.

### 2. Forbidden flows are blocked

The gatekeeper enumerates the forbidden flows and refuses any:

| Forbidden                                       | Why                                                                    |
| ----------------------------------------------- | ---------------------------------------------------------------------- |
| `research → fix` (skipping spec/audit)          | Research is input; implementation requires a spec or audit             |
| `code → spec` (back-fill)                       | Specs are forward-looking; documentation is for what was built          |
| `task with no source doc and no task scope`     | Every task is grounded                                                 |
| `one source doc → multiple task types`          | Mapping is rigid; split the work                                       |
| `multiple source docs → one task`               | One source per task; multiple = orchestration or split                 |
| `task file authored after implementation begins` | The task file is step one                                              |
| `persona invented per session`                  | Personas are catalogued                                                 |
| `durable findings left only in the task file`   | Task files are gitignored; findings must promote                       |

### 3. Doc-type composition rules

The gatekeeper also enforces that *within* a doc, the type's epistemic stance holds:

- A `spec.md` does not contain present-state observations (those go in an audit)
- An `audit.md` does not prescribe new behaviour (that goes in a spec)
- A `bug-report.md` does not contain the fix (the fix is a downstream task)
- A `research.md` does not double as a spec (the transition is `spec-writing`)

Violations surface as a halt with a specific suggestion (e.g., "this looks like an audit finding; promote to `.agents/audits/<slug>.md` instead of including in the spec").

### 4. The "research is sufficient without a spec" trap

A common temptation: the research file is detailed enough that it feels like a spec; the agent moves to implementation directly.

**Forbidden.** The gatekeeper refuses. Research is *input*; spec is *contract*. Implementing from research means skipping the discipline that translates findings into testable acceptance criteria. The agent halts and spawns `spec-writing` first.

### 5. Promotion enforcement

When a task moves to `done`, the gatekeeper checks that any durable finding has been promoted upstream. A finding marked `[session-only]` with justification is exempt; otherwise the promotion is required.

This rule pairs with `manage-task`'s pre-close gate.

## What does not belong

- The gatekeeper is *not* a style enforcer. Spec quality is `write-spec`'s concern; the gatekeeper only enforces *which doc type a piece of content belongs in*.
- The gatekeeper is *not* a runtime. It refuses violations by halting the agent, not by patching documents itself.

## Anti-patterns

- "I'll back-fill the spec from the code I just wrote" — refused
- "I'll skip writing the audit; just refactor based on what I noticed" — refused (ungrounded refactor)
- "This research is detailed enough; let's just implement" — refused (skip-the-spec)
- "This bug-report includes the fix" — refused (split into bug-report + fix)
- Silently re-routing a `bug-report.md` as a `refactor` task — refused (forbidden edge)

## Interaction with other skills

- **`manage-task`** owns the lifecycle hooks; `documentation-gatekeeper` provides the *content rules* enforced at those hooks.
- **`distillation-discipline`** focuses on the *quality* of distillation (Loss Statements); `documentation-gatekeeper` focuses on the *direction* (downhill only).
- **The `write-<type>` skills** focus on *how to write a doc of type X well*; `documentation-gatekeeper` focuses on *whether the content belongs in a doc of type X at all*.

## See also

- `docs/agents/05-flow-graph.md` — the rules being enforced
- `docs/agents/02-file-types.md` — composition rules
- `.agents/skills/manage-task/SKILL.md` — the other always-loaded skill
- `.agents/skills/distillation-discipline/SKILL.md` — sister skill (quality of distillation)
