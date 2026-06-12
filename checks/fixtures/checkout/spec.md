---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-checkout
title: Cart submission and checkout
status: draft
owner: checkout-team
sources:
  - SHOP-2041
---

# Cart submission and checkout

## Intent

When a shopper submits their cart, the checkout service validates it, charges the card, and
records the sale — charging the card at most once.

## Non-goals

- Cart editing, promotions, and tax calculation — owned by the cart service.
- Refunds and chargebacks.

## Requirements

### AC-001 — submit the cart

When the shopper submits the cart, the checkout service must validate the cart and charge
the card and email the receipt.

Verify with: `npm test -- checkout.spec.ts` (case `submit`)

### AC-002 — order record

When the charge succeeds, the checkout service must write the order record.

Verify with: `npm test -- order-record.spec.ts` (case `writes-order`)

### AC-003 — inventory ledger

When the charge succeeds, the checkout service must append the inventory ledger entry.

Verify with: `npm test -- inventory.spec.ts` (case `writes-ledger`)

## Open questions

- Non-blocking: should the order record and the ledger entry share one transaction? Both
  write into `db/orders` today — splitting them into parallel tasks would put two tasks on
  one write area.

## Affected areas

- `api/src/checkout/submit.ts`
- `db/orders` — AC-002 and AC-003 both write here
