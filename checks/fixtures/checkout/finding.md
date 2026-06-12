---
# checks fixture — expected results pinned in EXPECTED.md
type: finding
id: FINDING-shared-write-area
status: candidate
from: REVIEW-checkout
date: 2026-06-11
related: [SPEC-checkout#AC-002, SPEC-checkout#AC-003]
---

# Finding: The order record and inventory ledger share one write area

## What we learned

The inventory ledger lives inside `db/orders`, so order work and inventory work cannot run
as parallel tasks — any pair of tasks touching both requirements writes the same area, and
every orders migration locks the ledger with it.

## Evidence

REVIEW-checkout: migration `0007_add_inventory_ledger.sql` placed the ledger table in
`db/orders`; the review packet flags the placement, and an earlier attempt to split AC-002
and AC-003 into two parallel tasks produced conflicting migrations on that schema (PR run
#131, both branches rewriting `db/orders`).

## Where it applies

- Splitting any checkout work that touches both the order record and the ledger.
- Schema migrations on `db/orders`.

## Where it does not apply

- Read-only work against either table.

## Future guidance

Keep order-record and ledger requirements in one task until the ledger moves to its own
schema — that move is planned in `CHANGE-inventory-ledger` (see
`../transformation/change-plan.md`). Declare write areas in the spec before splitting work.
