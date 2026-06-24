# Example: bug fix

Goal: fix a defect by amending the spec, writing a task, and proving the regression.

## Bug

```text
PAY-88

Retrying a payment after a timeout can double charge the customer.
```

## Spec amendment

Existing spec: `SPEC-payments`.

Add:

```markdown
### AC-003 - Retry is idempotent after timeout

When a payment request times out and the client retries with the same idempotency key,
the payment service must not create a second charge.

Verify with: `npm run test:integration -- payment-timeout-retry`
```

Non-goal:

```markdown
- No change to idempotency-key format.
```

## Task

`tasks/payment-timeout-retry.md`

```markdown
---
type: task
id: TASK-payment-timeout-retry
source:
  - SPEC-payments
scope: [AC-003]
status: review-ready
---

## Scope

- AC-003 - retry after timeout does not create a second charge.

## Do not change

- idempotency-key format
- settlement reconciliation logic

## Verify

- [x] `npm run test:integration -- payment-timeout-retry` (AC-003)

      1 failed before fix
      1 passed after fix

## Run summary

- Changed files: `src/payments/retry.ts`, `test/integration/payment-timeout-retry.test.ts`
- Verify results:
  - `npm run test:integration -- payment-timeout-retry` (AC-003): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

## Review

`reviews/payment-timeout-retry.md`

```markdown
---
type: review
id: REVIEW-payment-timeout-retry
task: TASK-payment-timeout-retry
status: needs-human
---

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-003 | Pass | `npm run test:integration -- payment-timeout-retry` -> failed before fix, passed after fix | yes |

Spot-checked: AC-003 - reran integration test after fix; pass reproduced.

## Human attention

1. Money path: inspect retry path and idempotency lookup before merge.

## Suggested decision

Merge after human inspection of the money-path note.
```

## Close

Finding:

```markdown
# Finding: payment timeout retries use the same idempotency record

## What we learned

Timeout retries with the same idempotency key reuse the original payment record.

## Evidence

- `reviews/payment-timeout-retry.md`, AC-003

## Where it applies

- payment timeout retry handling

## Where it does not apply

- retries with a different idempotency key
```

Board:

- task closed after review
- finding pending acceptance or accepted, per local board policy

## Lesson

A bug fix needs red-before-green evidence, not only the final green run.
