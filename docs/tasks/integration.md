# 📋 Task: integration

> **TL;DR.** Wire a third-party SDK, API, or MCP server into the codebase per a spec. Same persona as `feature` (The Builder), specialised constraints around credential handling, error semantics, and protocol fidelity. Output: working integration + tests + handoff to The Skeptic.

---

## 🎯 When to use

An `integration` task is right when:

- A spec defines integrating an external system (Stripe SDK, third-party API, MCP server, OAuth provider, etc.).
- The work primarily involves wiring an external surface, not building new internal behaviour.
- Credential handling, error mapping, and protocol fidelity are first-order concerns.

If you're *consuming* an already-integrated SDK to add a feature, that's `feature`, not `integration`. Integration is the wiring step.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `spec.md`                                          |
| **Lead persona**     | [The Builder](../personas/the-builder.md) (in integration mode) |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md), [The Architect](../personas/the-architect.md) (boundary review) |
| **Output**           | Working integration with credential handling + tests |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-feature`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (periodic + post), `cmdTest` (post including integration tests) |

---

## 🔒 Integration-specific constraints (in addition to feature constraints)

1. **Credentials via scoped environment variables.** Never hardcode API keys.
2. **Robust handshake handling.** Network errors, rate limits, retries — explicit per the SDK's contract or RFC.
3. **Bridge errors at the boundary.** Map external errors into the project's error taxonomy at the integration point; don't leak external error shapes into business logic.
4. **Test the contract** (or document why a contract test isn't feasible — e.g., the third-party charges per request and we use a sandbox env).
5. **Document the SDK / API version** in the integration's adjacent doc (in `docs/` or as a comment) so future upgrades have a reference point.

---

## 📐 Template

Use the [`feature` template](feature.md#-template), with:

- `Type: integration`
- Add a section after `## Linked docs`:

  ```markdown
  ## Integration target

  <integration_target>

  **External system:** (e.g., Stripe Payment Intents API)
  **Version:** (e.g., `stripe-node@14.21.0`, API version `2024-06-20`)
  **Authentication:** (e.g., bearer token via `STRIPE_SECRET_KEY` env var)
  **Documentation:** (link to SDK docs / API reference / RFC)

  </integration_target>
  ```

- Add to `## Constraints`:
  - Credentials via env vars, never hardcoded
  - Errors bridged at the integration boundary
  - SDK / API version pinned and recorded

- Add to `## Self-review`:

  ```markdown
  ### Integration boundary

  - Are external errors mapped into the project's error taxonomy at the integration point? Does business logic stay free of external error shapes?
  - Are credentials sourced from env vars only? Pasted `git grep -n '<api-key-prefix>'` showing zero hardcoded keys?
  - Is the integration's version pinned in `package.json` (or equivalent) and documented?
  ```

---

## 🛠️ Worked example

A spec at `.agents/specs/stripe-payment-intents.md` calls for integrating the Stripe Payment Intents API.

The Builder (in integration mode):

1. Reads the spec and the Stripe SDK docs.
2. Sets up the SDK client with the secret key from `process.env.STRIPE_SECRET_KEY`.
3. Wires the integration in `src/payments/stripe.ts`:
   - `createPaymentIntent({ amount, currency, customerId })` — returns the project's `PaymentIntent` type
   - Internal Stripe errors mapped to `PaymentError` with structured codes
4. Writes integration tests using Stripe's sandbox env (or recorded fixtures via VCR-like tools).
5. Writes a unit test verifying error mapping (e.g., Stripe's `card_declined` → our `PaymentError(code: 'card_declined')`).
6. Pastes the `git grep -n 'sk_'` result showing zero hardcoded keys.
7. Hands off to the Skeptic for review.

---

## ⚠️ Common anti-patterns

- Hardcoded credentials ("just for testing")
- Letting external error shapes leak into business logic
- Skipping the contract / integration test
- Pinning to `latest` instead of an explicit version
- "I'll add error handling later"
- Bundling integration setup with consumer feature work

---

## See also

- [`tasks/feature.md`](feature.md) — the parent template
- [`personas/the-builder.md`](../personas/the-builder.md)
- [`personas/the-architect.md`](../personas/the-architect.md) — consult on boundary decisions
- [`skills/write-feature.md`](../skills/write-feature.md)
