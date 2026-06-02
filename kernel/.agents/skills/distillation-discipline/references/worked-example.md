# Worked example: research → spec distillation

A concrete example of the distillation discipline applied to a research → spec transition. The body of `SKILL.md` keeps a one-line input/output pair to illustrate the shape; this document carries the full worked example, including the explicit Distillation Loss Statement and the rationale for what the four tests passed and dropped.

## Source content (high-verbosity research file)

> "After reviewing the Stripe documentation and testing the `/v1/charges` vs `/v1/payment_intents` endpoints via `curl`, it's clear we have to migrate to Payment Intents. Charges are legacy and don't support SCA (Strong Customer Authentication) well in Europe. The Payment Intents API requires a two-step process: create the intent on the server to get a `client_secret`, then confirm it on the frontend using Stripe.js."

## Distilled content (medium-verbosity spec)

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

The historical justification vanishes by the spec stage. The load-bearing constraint (`Must return client_secret`) is preserved. The Loss Statement records what was dropped.

## Why the four tests pass

| Upstream item | 🎯 Requirements | 🧬 Behavior | 🔍 Edge case | 🧪 Empirical | Status |
| --- | --- | --- | --- | --- | --- |
| Use Payment Intents (not legacy charges) | preserved (Provider line) | preserved (two-step flow) | preserved (SCA enforced by design) | preserved (`curl` testing recorded in research file, not needed in spec) | ✅ |
| Two-step server → client flow returning `client_secret` | preserved (Flow steps 1–2) | preserved (named methods) | n/a | n/a | ✅ |
| European SCA support | preserved by structural choice (PI flow enforces SCA) | preserved | n/a | n/a | ✅ |

Every load-bearing item from the research file survives in the spec in *some* form — either as a requirement, a behavioural constraint, or a structural choice. The historical narrative drops; the contract stands.
