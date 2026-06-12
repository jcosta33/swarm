---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-checkout
title: Cart submission and checkout
status: draft
owner: checkout-team
sources:
  - SHOP-2041
format: sol
---

# Cart submission and checkout

<!-- The same spec as spec.md, written on the stricter surface — this directory's
     equivalence pair. -->

## Intent

When a shopper submits their cart, the checkout service validates it, charges the card, and
records the sale — charging the card at most once.

## Non-goals

- Cart editing, promotions, and tax calculation — owned by the cart service.
- Refunds and chargebacks.

## Requirements

REQ AC-001:
WHEN the shopper submits the cart
THE checkout service MUST validate the cart and charge the card and email the receipt
VERIFY BY test:cmdTest:checkout.spec.ts#submit
WRITES api/src/checkout/submit.ts
RISK high

REQ AC-002:
WHEN the charge succeeds
THE checkout service MUST write the order record
VERIFY BY test:cmdTest:order-record.spec.ts#writes-order
WRITES db/orders

REQ AC-003:
WHEN the charge succeeds
THE checkout service MUST append the inventory ledger entry
VERIFY BY test:cmdTest:inventory.spec.ts#writes-ledger
WRITES db/orders

## Open questions

QUESTION Q-001 [non-blocking]:
Should the order record and the ledger entry share one transaction?
AFFECTS AC-002, AC-003

## Affected areas

- `api/src/checkout/submit.ts`
- `db/orders` — AC-002 and AC-003 both write here
