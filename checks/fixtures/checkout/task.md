---
# checks fixture — expected results pinned in EXPECTED.md
type: task
id: TASK-checkout
source:
  - SPEC-checkout
scope: [AC-001, AC-002, AC-003]
status: review-ready
---

# Task: Cart submission and checkout

## Source

- Spec: `specs/checkout/spec.md` (SPEC-checkout)

## Scope

Implement or preserve:

- AC-001 — validate the cart, charge the card, email the receipt
- AC-002 — write the order record on successful charge
- AC-003 — append the inventory ledger entry on successful charge

This is deliberately one task, not two: AC-002 and AC-003 both write `db/orders`, and two
parallel tasks on one write area conflict.

## Do not change

- The cart service and its pricing logic.
- The payment provider client — consume it, don't edit it.

## Affected areas

- `api/src/checkout/submit.ts`
- `db/orders`

## Verify

- [ ] `npm test -- checkout.spec.ts` (AC-001)
- [ ] `npm test -- order-record.spec.ts` (AC-002)
- [ ] `npm test -- inventory.spec.ts` (AC-003)

## Agent instructions

1. Read the source spec first.
2. Stay inside this task's scope. If a requirement can't be met as written, stop and say why
   instead of improvising.
3. Run every Verify item and paste the real output — a claim without output counts as
   unverified.
4. Before finishing, re-read your own diff as a skeptic: what would a reviewer flag?
5. Leave a summary: changed files, commands run with output, and anything learned worth
   saving as a finding.

## Findings

- Candidate: the order record and inventory ledger share one write area — see `finding.md`.
