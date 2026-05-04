# 🛠️ Skill: distillation-discipline

> **Auto-loaded for spec-writing, research-writing, and documentation.** Codifies accountable distillation: when transitioning down the verbosity gradient, explicitly state what was dropped and why the next stage doesn't need it. The Distillation Loss Statement makes the loss visible.

---

## 📦 Frontmatter

```yaml
---
name: distillation-discipline
description: Load when transforming a high-verbosity document (research) into a lower-verbosity one (spec, audit, task), or when distilling a long-running investigation into a finalised doc. Enforces the Distillation Loss Statement protocol — drop conversational fluff, keep load-bearing constraints, and explicitly record what was dropped.
---
```

---

## 🎯 Purpose

Information in Swarm flows along a verbosity gradient: research → spec/audit/bug-report → task → terminal output. Each transition drops something. Without discipline, the dropping is silent, and load-bearing context evaporates.

Accountable distillation requires the agent to *explicitly state what was dropped and why the next stage doesn't need it*. The statement makes the loss visible to downstream readers and reviewers.

---

## 🔒 Core rules

### Rule 1: You are permitted to drop conversational fluff and examples

Narratives ("after exploring three options…"), historical context ("we briefly considered Y in 2024…"), and exploratory tangents are fair game. The downstream consumer needs the *contract*, not the *journey*.

### Rule 2: You are forbidden from dropping load-bearing content

The framework defines categories that *cannot* be dropped:

- **Architectural constraints** (security mandates, layering rules)
- **API payload shapes** (request/response schemas, status codes, error codes)
- **Acceptance criteria** (testable requirements)
- **Identified risks** with their mitigations
- **`[CRITICAL]` open questions** (the spec halts on these)

If a transition appears to drop one of these, halt and either:
- Move the content to the new doc (it wasn't actually droppable), or
- Mark it explicitly as deferred to a downstream artefact (e.g., "API payload shapes: see `.agents/specs/<api-slug>.md` §4")

### Rule 3: The Distillation Loss Statement

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

### Rule 4: The four tests

Before considering a distillation complete, the agent runs four tests:

| Test            | Question                                                              |
| --------------- | --------------------------------------------------------------------- |
| 🎯 **Requirements** | Does every requirement in the upstream survive in some form?       |
| 🧬 **Behavior**     | Does every behavioural constraint (API shape, error semantics) survive? |
| 🔍 **Edge case**    | Does every edge case mentioned upstream get a treatment downstream? |
| 🧪 **Empirical**    | Does every measurement, benchmark, or repro step survive in actionable form? |

A distillation that passes all four is *accountable*. A distillation that fails one is incomplete — the agent halts and revises.

### Rule 5: Per-transition loss budgets

Different transitions have different budgets:

| Transition                             | Loss budget | Notes                                              |
| -------------------------------------- | ----------- | -------------------------------------------------- |
| `research → spec/audit/bug-report`     | 🟡 High     | Narratives, alternatives explored OK to drop      |
| `spec → task`                          | 🟢 Zero     | Architectural constraints, data shapes preserved  |
| `audit → task`                         | 🟡 Medium   | Suggestive language OK to drop; file:line stays  |
| `bug-report → task`                    | 🟢 Zero     | Reproduction + root cause preserved verbatim     |
| `task → code/docs`                     | 🟢 Zero     | Already minimal; findings *promote*, not drop    |

The `spec → task` transition is the critical one. The Lead Engineer parsing a specification into sub-tasks is forbidden from dropping any architectural constraints or data shapes.

---

## 🚫 What does not belong

- **A Loss Statement that says "nothing was dropped".** If nothing was dropped, you didn't distil — you copy-pasted. Either embrace the copy-paste (and remove the Loss Statement) or actually distil.
- **A Loss Statement that lists *categories* without specifics.** "Dropped: implementation details" is not specific enough. "Dropped: comparison of three sorting algorithms (we picked merge-sort)" is.
- **Silent dropping.** If a load-bearing item *was* dropped, the framework treats this as a gate failure; the agent halts and adds the item back (or moves it to a deferred artefact).

---

## ⚠️ Anti-patterns

- "Dropped: anything not in the spec" (vacuous)
- Loss Statement appended after the fact without re-checking the four tests
- Dropping API payload shapes "to keep the spec short"
- Dropping `[CRITICAL]` open questions because they look like nuisance
- Treating a Loss Statement as ceremony rather than discipline

---

## 🛠️ Worked example

### Source content (high-verbosity research file)

> "After reviewing the Stripe documentation and testing the `/v1/charges` vs `/v1/payment_intents` endpoints via `curl`, it's clear we have to migrate to Payment Intents. Charges are legacy and don't support SCA (Strong Customer Authentication) well in Europe. The Payment Intents API requires a two-step process: create the intent on the server to get a `client_secret`, then confirm it on the frontend using Stripe.js."

### Distilled content (medium-verbosity spec)

```markdown
## Payment processing architecture

- **Provider:** Stripe Payment Intents API
- **Flow:**
  1. Server creates `PaymentIntent` → returns `client_secret`
  2. Client uses `Stripe.js` `confirmCardPayment` with `client_secret`

## Distillation Loss Statement

**Dropped from upstream:**

- European SCA historical justification
- Comparisons to legacy `/v1/charges` endpoint

**Why the next stage does not need this:**

- The flow enforces SCA by design; the historical motivation does not change the contract
- The legacy comparison is closed — `/v1/charges` is not on the table
```

### Distilled content (low-verbosity task file for the backend agent)

```markdown
## Objective

Implement server-side `PaymentIntent` creation.

## Constraints

- Endpoint must return `client_secret`
- DO NOT implement client-side confirmation (separate task)
```

The historical justification vanishes by the task stage. The load-bearing constraint (`Must return client_secret`) is preserved. The Loss Statement at the spec stage records what was dropped.

This is accountable distillation in practice.

---

## 🚨 Distillation done wrong: a counter-example

A research file documents three competing approaches (A, B, C). The Architect drafts:

```markdown
## Approach: A

[implementation contract]
```

…and stops. No Distillation Loss Statement. No mention of B and C. No record of *why* A won.

A reviewer can't tell whether B and C were dropped because they were inferior or because the Architect forgot they existed. The decision is now context-free.

The fix:

```markdown
## Approach: A

[contract]

## Design decisions

### Decision: Why A over B and C
**Chosen:** Approach A.

**Considered and rejected:**
- _Approach B_ — rejected because B requires a custom implementation we don't have capacity to maintain.
- _Approach C_ — rejected because C requires a runtime change incompatible with our deployment target.

## Distillation Loss Statement

**Dropped from upstream:**
- Detailed implementation tradeoffs of approaches B and C
- Original library benchmarks comparing all three

**Why the next stage does not need this:**
- The decision (A) is final; the Builder needs the contract, not the comparison
- The decision rationale is captured in `## Design decisions` for archeology
- The original research file (`.agents/research/<slug>.md`) is preserved
```

Now the spec carries the contract, the Loss Statement records what was dropped, and the design decisions encode the *why* in case anyone revisits.

---

## 🔁 The promotion protocol (sister discipline)

Distillation flows downhill. The companion is *promotion*: when a task discovers something durable, the finding is promoted *upstream*, not silently dropped.

The two together make the chain accountable end-to-end:
- Distillation: explicit loss when transitioning down the gradient
- Promotion: explicit gain when the down-stream discovers something

See [`concepts/03-distillation.md`](../concepts/03-distillation.md) for both protocols.

---

## See also

- [`concepts/03-distillation.md`](../concepts/03-distillation.md) — the conceptual frame
- [`documentation-gatekeeper.md`](documentation-gatekeeper.md) — sister skill (enforces the *direction* of flow)
- [`personas/the-architect.md`](../personas/the-architect.md), [`personas/the-researcher.md`](../personas/the-researcher.md), [`personas/the-documentarian.md`](../personas/the-documentarian.md) — primary users
- [ADR 0003](../adrs/0003-distillation-is-unidirectional.md) — why downhill only
