# 🛠️ Skill: documentation-gatekeeper

> **Always loaded.** Enforces the flow graph and the forbidden-flow rules. The skill that *refuses* to let a task drift into a different doc type or skip a required upstream artefact.

---

## 📦 Frontmatter

```yaml
---
name: documentation-gatekeeper
description: Load at session start. Enforces the framework's flow graph — the deterministic mapping from source documents to task types to personas. Refuses forbidden flows (research → fix without spec; spec from finished code; multiple task types per source doc; etc.) and refuses to let durable findings stay in the gitignored task file.
---
```

---

## 🎯 Purpose

The flow graph encodes the framework's discipline (see [`concepts/07-flow-graph.md`](../concepts/07-flow-graph.md)). Without enforcement, the discipline is just advice. `documentation-gatekeeper` is the enforcement: every transition the agent makes (from source doc to task; from task to terminal output; from finding to upstream promotion) is checked against the flow graph rules.

---

## 🔒 Core rules

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

---

## 🚫 What does not belong

- The gatekeeper is *not* a style enforcer. Spec quality is `write-spec`'s concern; the gatekeeper only enforces *which doc type a piece of content belongs in*.
- The gatekeeper is *not* a runtime. It refuses violations by halting the agent, not by patching documents itself.

---

## ⚠️ Anti-patterns

- "I'll back-fill the spec from the code I just wrote" — refused
- "I'll skip writing the audit; just refactor based on what I noticed" — refused (ungrounded refactor)
- "This research is detailed enough; let's just implement" — refused (skip-the-spec)
- "This bug-report includes the fix" — refused (split into bug-report + fix)
- Silently re-routing a `bug-report.md` as a `refactor` task — refused (forbidden edge)

---

## 🛠️ Worked examples

### Example 1: forbidden flow caught

Setup: the human says "the auth module has a tokenStore problem; please clean it up." The agent considers spawning a `refactor` task directly (audit → refactor is the standard flow).

But there is no audit. The proposed work would be a `refactor` from a *human ask*, not a *grounding doc*. The gatekeeper:

```markdown
[gatekeeper halt]

The proposed task is a `refactor` of `src/auth/tokenStore.ts` based on a human's
informal ask. Refactor tasks require an `audit.md` as the source doc.

Two options:

1. Spawn `audit-writing` first, with the audit brief: "describe the current state of
   `src/auth/tokenStore.ts` and surface issues affecting maintainability." The resulting
   audit becomes the source for the refactor.

2. If the human's ask is already specific enough (e.g., "delete the deprecated `legacyGet`
   method"), spawn that as a `refactor` with a short audit-as-task-scope captured in the
   task file's `## Linked docs` section. This is allowed for trivial scope only.

Halting until one of the two paths is chosen.
```

### Example 2: doc-type composition violation

Setup: the Architect is writing `.agents/specs/oauth2-pkce.md` and starts including a section "Current state of `tokenStore.ts`":

```markdown
## Current state of `tokenStore.ts`

The existing `tokenStore.ts` interface (`src/auth/tokenStore.ts:18`) does not
support the PKCE state-verifier round-trip. The `legacyGet` method is also
deprecated and has 3 callers...
```

The gatekeeper flags this:

```markdown
[gatekeeper observation]

The `## Current state of tokenStore.ts` section in this spec contains
present-state observation, which belongs in an audit, not a spec.

Recommendation:
- Move this content to `.agents/audits/auth-tokenstore-2026.md` (or append to an
  existing audit if one covers the area).
- Reference the audit from this spec's `## Linked docs`.
- The spec itself should describe what the new behaviour requires (forward-looking,
  prescriptive), not what the current state is (present-looking, observational).

Halting until the spec is restructured.
```

The Architect moves the observation, references the audit, and proceeds.

### Example 3: promotion enforcement at close

Setup: the Builder finishes a feature task. `## Findings` contains:

```markdown
## Findings

- `src/payments/processor.ts:88` has unsafe error handling; swallows errors silently.
  Could mask real failures. Worth a separate refactor task.
```

The Builder tries to mark `status: done`. The gatekeeper:

```markdown
[gatekeeper halt]

The task has 1 unpromoted finding in `## Findings`:

  "`src/payments/processor.ts:88` has unsafe error handling..."

This is a durable architectural observation. Task files are gitignored — leaving this
finding in the task file means losing it.

Two options:

1. Promote to `.agents/audits/payments-error-handling.md` (or append to an existing
   audit). After promotion, the entry in this task file can be summarised as
   "promoted to <audit path>".

2. Mark the finding `[session-only]` with a justification (e.g., "noted but not
   actionable; no follow-up needed because <reason>").

Halting `status: done` until one of the two is done.
```

The Builder promotes the finding, updates the audit, and the task closes cleanly.

---

## 🔁 Interaction with other skills

- **`manage-task`** owns the lifecycle hooks; `documentation-gatekeeper` provides the *content rules* enforced at those hooks.
- **`distillation-discipline`** focuses on the *quality* of distillation (Loss Statements); `documentation-gatekeeper` focuses on the *direction* (downhill only).
- **The `write-<type>` skills** focus on *how to write a doc of type X well*; `documentation-gatekeeper` focuses on *whether the content belongs in a doc of type X at all*.

These skills layer cleanly: the gatekeeper picks the right type; the write skill makes it good; manage-task tracks lifecycle; empirical-proof / adversarial-review enforce verification.

---

## See also

- [`concepts/07-flow-graph.md`](../concepts/07-flow-graph.md) — the rules being enforced
- [`concepts/03-distillation.md`](../concepts/03-distillation.md) — promotion protocol
- [`concepts/05-document-types.md`](../concepts/05-document-types.md) — composition rules
- [`manage-task.md`](manage-task.md) — the other always-loaded skill
- [`reference/flow-graph.md`](../reference/flow-graph.md) — operational tables
