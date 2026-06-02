---
name: distillation-discipline
description: Distil upstream docs accountably. ALWAYS apply this skill when transforming a high-verbosity document (research) into a lower-verbosity one (spec, audit, task), or when finalising a long-running investigation into a durable doc — append a `## Distillation Loss Statement` listing what was dropped and why downstream does not need it. Do not silently drop architectural constraints, API payload shapes, acceptance criteria, identified risks, or `[CRITICAL]` open questions during the distillation. Skip this skill for net-new authoring with no upstream document to distil from.
---

# Skill: distillation-discipline

## Purpose

Information flows along a verbosity gradient: research → spec/audit/bug-report → task → terminal output. Each transition drops something. Without discipline, the dropping is silent, and load-bearing context evaporates.

Accountable distillation requires the agent to *explicitly state what was dropped and why the next stage doesn't need it*. The statement makes the loss visible to downstream readers and reviewers.

## Core rules

### 1. You are permitted to drop conversational fluff and examples

Narratives ("after exploring three options…"), historical context ("we briefly considered Y in 2024…"), and exploratory tangents are fair game. The downstream consumer needs the *contract*, not the *journey*.

### 2. You are forbidden from dropping load-bearing content

Categories that *cannot* be dropped:

- **Architectural constraints** (security mandates, layering rules)
- **API payload shapes** (request/response schemas, status codes, error codes)
- **Acceptance criteria** (testable requirements)
- **Identified risks** with their mitigations
- **`[CRITICAL]` open questions** (the spec halts on these)

If a transition appears to drop one of these, halt and either:

- Move the content to the new doc (it wasn't actually droppable), or
- Mark it explicitly as deferred to a downstream artefact

### 3. The Distillation Loss Statement

At the end of every document distilled from upstream, append a `## Distillation Loss Statement`:

```markdown
## Distillation Loss Statement

**Dropped from upstream:**

- <what was dropped, in concrete terms>
- <more dropped content>

**Why the next stage does not need this:**

- <justification — usually "decision is finalised", "context captured elsewhere", "downstream operates from contract, not history">
```

The statement is real and complete. A reviewer can read upstream and downstream side by side and verify nothing load-bearing went missing.

### 4. The four tests (with forced visible output)

Before considering a distillation complete, run four tests on every upstream load-bearing item and output the result table — one row per item:

| Upstream item | 🎯 Requirements | 🧬 Behavior | 🔍 Edge case | 🧪 Empirical | Status |
| --- | --- | --- | --- | --- | --- |
| <item from upstream> | preserved / dropped (justified) / promoted to <doc> | preserved / dropped / promoted | preserved / dropped / promoted | preserved / dropped / promoted | ✅ / ❌ |

The four tests:

- 🎯 **Requirements** — Does this requirement from the upstream survive (in some form)?
- 🧬 **Behavior** — Does the behavioural constraint (API shape, error semantics) survive?
- 🔍 **Edge case** — Does every edge case mentioned upstream get a treatment downstream?
- 🧪 **Empirical** — Does every measurement, benchmark, or repro step survive in actionable form?

**Pre-deliver visibility gate:** Do not finalise the distilled doc until you have output this table with one row per upstream load-bearing item. A row with any `dropped (without justification)` cell, or a row marked ❌, means the distillation is incomplete — halt and revise, do not finalise. The agent does not deliver the distilled doc to the user until the table is in the task file and every row is ✅.

### 5. Per-transition loss budgets

| Transition                         | Loss budget | Notes                                             |
| ---------------------------------- | ----------- | ------------------------------------------------- |
| `research → spec/audit/bug-report` | 🟡 High     | Narratives, alternatives explored OK to drop      |
| `spec → task`                      | 🟢 Zero     | Architectural constraints, data shapes preserved  |
| `audit → task`                     | 🟡 Medium   | Suggestive language OK to drop; file:line stays   |
| `bug-report → task`                | 🟢 Zero     | Reproduction + root cause preserved verbatim      |
| `task → code/docs`                 | 🟢 Zero     | Already minimal; findings *promote*, not drop     |

The `spec → task` transition is the critical one. Parsing a specification into sub-tasks is forbidden from dropping any architectural constraints or data shapes.

## What does not belong

- **A Loss Statement that says "nothing was dropped".** If nothing was dropped, you didn't distil — you copy-pasted. Either embrace the copy-paste (and remove the Loss Statement) or actually distil.
- **A Loss Statement that lists *categories* without specifics.** "Dropped: implementation details" is not specific enough. "Dropped: comparison of three sorting algorithms (we picked merge-sort)" is.
- **Silent dropping.** If a load-bearing item *was* dropped, treat this as a gate failure; halt.

## Anti-patterns

- "Dropped: anything not in the spec" (vacuous)
- Loss Statement appended after the fact without re-checking the four tests
- Dropping API payload shapes "to keep the spec short"
- Dropping `[CRITICAL]` open questions because they look like nuisance
- Treating a Loss Statement as ceremony rather than discipline

## Worked example (one input / output pair)

**Input (research file paragraph):** "We tested Stripe Payment Intents vs legacy Charges via `curl`. Payment Intents is required for European SCA. The flow is server-creates-intent → returns `client_secret` → client confirms via Stripe.js."

**Output (spec excerpt):**

```markdown
## Payment processing
- **Provider:** Stripe Payment Intents API
- **Flow:** server creates `PaymentIntent` → returns `client_secret`; client confirms via `Stripe.js.confirmCardPayment(client_secret)`

## Distillation Loss Statement
**Dropped:** SCA historical justification, comparison to legacy `/v1/charges`.
**Why next stage doesn't need it:** flow enforces SCA by design; legacy is closed.
```

The historical narrative drops; the contract stands. For the full walk-through (including the four-tests result table for this example), see [`references/worked-example.md`](./references/worked-example.md).

## The promotion protocol (sister discipline)

Distillation flows downhill. The companion is *promotion*: when a task discovers something durable, the finding is promoted *upstream*, not silently dropped. Capture promoted findings in the upstream doc (audit, spec, research, bug-report) before the task closes.

## Bundled resources

- [`references/worked-example.md`](./references/worked-example.md) — the full Stripe research → spec walk-through, including the four-tests result table.
