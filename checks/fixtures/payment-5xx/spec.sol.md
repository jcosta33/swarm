---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-payment-5xx
title: Payment provider 5xx handling
status: ready
owner: payments-team
sources:
  - PAY-883
format: sol
---

# Payment provider 5xx handling

<!-- The same spec as spec.md, written on the stricter surface — this directory's
     equivalence pair. -->

## Intent

When the payment provider returns a 5xx, the payments service absorbs the transient outage
without ever charging the customer twice.

## Non-goals

- Provider failover or multi-provider routing.
- Card-declined (4xx) handling.

## Requirements

REQ AC-001:
WHEN the same idempotency key is submitted twice
THE payments service MUST capture at most one charge
VERIFY BY test:cmdTest:payment-idempotency.spec.ts#at-most-one-capture
WRITES server/src/payments/charge.ts
RISK critical

REQ AC-002:
WHEN the provider returns a 5xx
THE payments service MUST retry the charge once with the same idempotency key
VERIFY BY test:cmdTest:payment-retry.spec.ts#retries-once
WRITES server/src/payments/charge.ts

REQ AC-003:
WHEN the provider returns a 5xx
THE payments service MUST NOT retry the charge
VERIFY BY test:cmdTest:payment-retry.spec.ts#no-retry
WRITES server/src/payments/charge.ts

## Open questions

QUESTION Q-001 [blocking]:
Is the provider's charge endpoint idempotent across retries?
AFFECTS AC-002, AC-003

## Affected areas

- `server/src/payments/charge.ts`
