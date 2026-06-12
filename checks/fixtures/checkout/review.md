---
# checks fixture — expected results pinned in EXPECTED.md
type: review
id: REVIEW-checkout
task: TASK-checkout
pr: https://example.test/pr/507
status: needs-human
---

# Review: Cart submission and checkout

## Summary

Cart submission validates, charges, and emails; a successful charge writes the order record.
The inventory test was never run in this change set — AC-003 is unverified.

## Changed files

- `api/src/checkout/submit.ts`
- `db/orders` (migration `0007_add_inventory_ledger.sql`)

## Requirement coverage

| ID | Result | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass | `npm test -- checkout.spec.ts` → `submit ✓` (full output in PR run #133) | no |
| AC-002 | Pass | `npm test -- order-record.spec.ts` → `writes-order ✓` (full output in PR run #133) | no |
| AC-003 | Unverified | | yes |

## Human attention

1. AC-003 has an empty Evidence cell, so the row reads Unverified — never Pass. The agent's
   summary claims the ledger write works, but a claim without output is not evidence; run
   `npm test -- inventory.spec.ts` and paste the output before merging.
2. DB migration in the diff (`0007_add_inventory_ledger.sql`) — a trigger-list item; it puts
   the ledger inside `db/orders`, the write area the spec's open question flags.
3. Spot-checked the AC-002 row by re-running `npm test -- order-record.spec.ts` locally:
   same output. No out-of-scope changes, public-interface changes, or security-sensitive
   edits; one finding candidate recorded; no blocked questions.

## Suggested decision

Block until the AC-003 test output is pasted and the migration's write-area placement has an
owner decision.
