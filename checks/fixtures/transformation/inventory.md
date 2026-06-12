---
# checks fixture — expected results pinned in EXPECTED.md
type: inventory
id: INV-checkout-storage
title: Checkout storage inventory
status: ready
owner: checkout-team
sources: [code:api/src/checkout/, tests:api/tests/]
created: 2026-06-11
---

# Inventory: checkout storage

## Scope

What the checkout service writes and reads in `db/orders`. Excludes the cart service and
the payment provider integration.

## Current modules

| Module | Responsibility | Notes |
|---|---|---|
| `api/src/checkout/submit.ts` | Validates, charges, writes order + ledger | Both writes happen in one function |
| `api/src/checkout/ledger.ts` | Inventory ledger helpers | Writes into `db/orders` tables, not a schema of its own |

## Current interfaces

| Interface | Callers | Behavior |
|---|---|---|
| `writeOrder(order)` | `submit.ts` | Inserts one row into `db/orders.orders`; returns the order id |
| `appendLedger(entry)` | `submit.ts`, nightly reconciliation job | Inserts into `db/orders.inventory_ledger`; the job assumes same-schema joins |

## Observed behavior

| Behavior | Evidence |
|---|---|
| One submitted cart produces exactly one order row and one ledger row | `api/tests/order-record.spec.ts`, `api/tests/inventory.spec.ts` (green on main) |
| The reconciliation job joins orders to ledger inside one schema | `jobs/reconcile.sql:14` — `JOIN inventory_ledger USING (order_id)` |

## Known risks

- The ledger lives in the orders schema, so every orders migration locks the ledger too.
- The reconciliation SQL silently depends on both tables sharing a schema.

## Existing tests

- `api/tests/order-record.spec.ts`
- `api/tests/inventory.spec.ts`
- Nothing covers the reconciliation join.

## Unknowns

- Whether any reporting dashboard reads `db/orders.inventory_ledger` directly — with enough
  users, every observable shape ends up depended on.
