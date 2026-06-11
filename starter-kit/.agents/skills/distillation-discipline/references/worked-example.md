# Worked example: `research.md → spec.md` distillation

A concrete walk-through of the procedure in `SKILL.md` applied to a `research.md → spec.md`
crossing — the first row of the per-boundary loss matrix in the `lower` step (*permitted loss:* source digressions,
rejected options, low-confidence observations; *forbidden loss:* constraints, unresolved ambiguity,
decision-changing evidence). The body keeps a one-line input/output pair to show the shape; this
file carries the full per-item check (step 4) and the resulting `Preserved / Dropped /
Still-uncertain` statement (step 5).

## Source: high-verbosity `research.md`

> "After reviewing the Stripe documentation and testing the `/v1/charges` vs `/v1/payment_intents`
> endpoints via `curl`, it's clear we have to migrate to Payment Intents. Charges are legacy and
> don't support SCA (Strong Customer Authentication) well in Europe. The Payment Intents API requires
> a two-step process: create the intent on the server to get a `client_secret`, then confirm it on
> the frontend using Stripe.js. Open question: do we keep the legacy `/v1/charges` path live during a
> transition window, or cut over directly?"

## Step 1 — boundary and matrix row

Crossing: `research.md → spec.md`. Permitted loss for this row: source digressions, rejected
options, low-confidence observations. Forbidden loss: constraints, unresolved ambiguity,
decision-changing evidence. The historical SCA narrative and the legacy comparison are *digressions*
(permitted); the two-step `client_secret` contract is a *constraint* (forbidden to lose); the
transition-window line is *unresolved ambiguity* (forbidden to lose — it carries forward as a
`QUESTION`).

## Step 2–3 — enumerate the load-bearing items and classify

## Step 4 — the visible per-item check (the hard gate)

| Source item | Disposition | Survives as / why droppable |
| ----------- | ----------- | --------------------------- |
| Use Payment Intents, not legacy `/v1/charges` (decision-changing evidence) | preserved | `REQ AC-001` — *Provider: Stripe Payment Intents API* |
| Two-step server → client flow returning `client_secret` (constraint) | preserved | `CONSTRAINT C-001 (MUST)` — server creates the intent and returns `client_secret`; client confirms with Stripe.js. `VERIFY BY test:integration:cmdTest:payment-intent-flow` carried across intact. |
| European SCA support (decision-changing evidence) | preserved (by structural choice) | The Payment Intents flow enforces SCA by design; encoded by `C-001`'s contract, not a separate obligation. |
| Transition window vs. direct cut-over (unresolved ambiguity) | promoted to `QUESTION` | Open `QUESTION Q-001`, carried into *Still-uncertain* below — not resolved at this boundary. |
| European SCA *historical* justification (source digression) | dropped (justified) | Survives in the linked `research.md`; the the `lower` step MAY-drop list covers rationale recorded elsewhere — it does not change the contract. |
| `/v1/charges` comparison + `curl` testing notes (rejected option / low-confidence observation) | dropped (justified) | Survives in the linked `research.md`; the `research → spec` matrix row names rejected options as permitted loss. |

Every the `lower` step MUST-survive item lands as `preserved` or `promoted` — none is `dropped`. The two
`dropped (justified)` rows are both on the permitted-loss side of this boundary's matrix row, and
each names where it survives. The gate passes; the composing `lower`/author step may finalize.

## Step 5 — the `Preserved / Dropped / Still-uncertain` statement (written into the spec)

```markdown
## Payment processing architecture

- **Provider:** Stripe Payment Intents API  (REQ AC-001)
- **Flow (CONSTRAINT C-001, MUST):**
  1. Server creates `PaymentIntent` → returns `client_secret`
  2. Client confirms with `Stripe.js` `confirmCardPayment(client_secret)`
  - VERIFY BY test:integration:cmdTest:payment-intent-flow

## Preserved / Dropped / Still-uncertain

**Preserved:**
- The Payment-Intents decision (R-001) and the two-step `client_secret` contract (C-001, MUST) with
  its `VERIFY BY` binding.
- European SCA support — enforced structurally by the C-001 flow.

**Dropped:**
- European SCA *historical* justification — survives in the linked `research.md`; does not change
  the contract.
- The `/v1/charges` comparison and `curl` testing notes — survives in the linked `research.md`; a
  rejected option under the `research → spec` matrix row.

**Still-uncertain:**
- Q-001: keep the legacy `/v1/charges` path live during a transition window, or cut over directly?
  Carried forward unresolved — structuring past it would commit a guess as an obligation.
```

## Why this satisfies the discipline

The historical narrative and the rejected-endpoint comparison vanish by the spec stage — both are
permitted loss for this boundary, and both survive in the linked source, so nothing is *lost*, only
*relocated*. The load-bearing constraint (`C-001`, *MUST return `client_secret`*) crosses intact
with its modality and `VERIFY BY` binding. The unresolved transition-window question is not silently
resolved into an obligation — it is promoted to `Q-001` and left visible in *Still-uncertain*. Source
and target can be read side by side: a reviewer can confirm no obligation, modality, verification
binding, or open question went missing, and lint (the SOL error catalogue) has a concrete loss
statement to check against.
