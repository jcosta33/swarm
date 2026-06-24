# Close

This page creates:

- `findings/session-expiry-is-409.md`
- an updated `status.md`

Start only after review is `pass` or an owner accepts a waiver.

## 1. Save the finding

Create `findings/session-expiry-is-409.md`.

```markdown
---
type: finding
id: FINDING-session-expiry-is-409
from: REVIEW-checkout-expiry
date: 2026-06-20
related:
  - SPEC-checkout#AC-001
---

# Finding: expired checkout sessions are 409

## What we learned

Expired checkout sessions return `409 SESSION_EXPIRED`, not a 5xx.

## Evidence

- `reviews/checkout-expiry.md`, AC-001
- `npm run test:integration -- expired-session`

## Where it applies

- checkout session expiry

## Where it does not apply

- other checkout validation failures
- non-checkout sessions

## Future guidance

Treat expired checkout sessions as an expected client error.
```

Check:

- one claim
- evidence named
- applies and does-not-apply sections present
- related requirement linked

## 2. Update the board

In `status.md`:

- mark `SPEC-checkout` as ready or accepted, per your local status model
- mark `TASK-checkout-expiry` closed
- link the task row to `reviews/checkout-expiry.md` while retained
- add the finding under pending acceptance if your board tracks that list

## Artifact chain

| Step | Artifact |
| --- | --- |
| Pull | `intake/checkout-expiry.md` |
| Spec | `specs/checkout/spec.md` |
| Task | `tasks/checkout-expiry.md` |
| Run | task `## Run summary` |
| Review | `reviews/checkout-expiry.md` |
| Close | `findings/session-expiry-is-409.md`, `status.md` |

## What you skipped

No inventory or change plan was needed because this is one small feature.

Use [brownfield work and change plans](../05-brownfield-and-change-plans.md) for structural work.
