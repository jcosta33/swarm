---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-payment-5xx
title: Payment provider 5xx handling
status: ready
owner: payments-team
sources:
  - PAY-883
---

# Payment provider 5xx handling

## Intent

When the payment provider returns a 5xx, the payments service absorbs the transient outage
without ever charging the customer twice.

## Non-goals

- Provider failover or multi-provider routing.
- Card-declined (4xx) handling.

## Requirements

### AC-001 — at most one capture

When the same idempotency key is submitted twice, the payments service must capture at most
one charge.

Verify with: `npm test -- payment-idempotency.spec.ts` (case `at-most-one-capture`)

### AC-002 — retry on 5xx

When the provider returns a 5xx, the payments service must retry the charge once with the
same idempotency key.

Verify with: `npm test -- payment-retry.spec.ts` (case `retries-once`)

### AC-003 — no retry on 5xx

When the provider returns a 5xx, the payments service must not retry the charge.

Verify with: `npm test -- payment-retry.spec.ts` (case `no-retry`)

## Open questions

- Blocking: is the provider's charge endpoint idempotent across retries? AC-002 and AC-003
  cannot both stand until this is answered.

## Affected areas

- `server/src/payments/charge.ts`
