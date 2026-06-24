# Example: large PR review

Goal: review a 41-file agent PR without reading it blindly from top to bottom.

## Situation

An agent refactored checkout session handling.

Claim:

```text
All checkout session behaviors preserved.
```

Risk:

- 41 files changed
- checkout is a money path
- CI is green
- the worker summary is broad and unsupported

## Inventory

The reviewer first records current behavior:

```markdown
---
type: inventory
id: INV-checkout-session
---

## Observed behavior

- active session can pay
- expired session returns `409 SESSION_EXPIRED`
- missing session returns `404`
- payment provider errors return `502`

## Tests

- `npm run test:integration -- checkout-session`
```

## Change plan

```markdown
---
type: change-plan
id: CHANGE-checkout-session-refactor
preserves:
  - SPEC-checkout#AC-001
  - SPEC-checkout#AC-002
  - SPEC-checkout#AC-003
  - SPEC-checkout#AC-004
---

## Preservation guarantees

| ID | Behavior | Verify |
| --- | --- | --- |
| AC-001 | active session can pay | `npm run test:integration -- active-session` |
| AC-002 | expired session returns 409 | `npm run test:integration -- expired-session` |
| AC-003 | missing session returns 404 | `npm run test:integration -- missing-session` |
| AC-004 | provider failure returns 502 | `npm run test:integration -- provider-failure` |
```

## Review packet

```markdown
---
type: review
id: REVIEW-checkout-session-refactor
task: TASK-checkout-session-refactor
status: needs-human
---

## Changed files

- 41 files changed
- risky path: checkout/payment

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `active-session` -> passed | no |
| AC-002 | Fail | `expired-session` -> expected 409, got 500 | yes |
| AC-003 | Pass | `missing-session` -> passed | no |
| AC-004 | Pass | `provider-failure` -> passed | yes |

## Human attention

1. AC-002 fails: expired sessions now return 500.
2. Money path changed: inspect checkout charge ordering.
3. Out-of-scope file changed: `src/retry.ts` was not in the task affected areas.

## Suggested decision

Do not merge. Fix AC-002 and explain `src/retry.ts`.
```

## Follow-up task

```markdown
---
type: task
id: TASK-checkout-expiry-regression
source:
  - REVIEW-checkout-session-refactor
scope: [AC-002]
status: review-ready
---

## Scope

- AC-002 - expired checkout session returns `409 SESSION_EXPIRED`.

## Do not change

- payment provider retry behavior

## Verify

- [x] `npm run test:integration -- expired-session` (AC-002)

      expected 409
      received 409
      1 passed
```

## Second review

```markdown
## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-002 | Pass | `expired-session` -> `1 passed` | no |

Spot-checked: AC-002 - reran test; output matched.

## Suggested decision

Merge follow-up, then re-review original PR state.
```

## Finding

```markdown
# Finding: checkout expiry regression hides behind green broad CI

## What we learned

Broad checkout CI can pass while the expired-session case regresses.

## Evidence

- `REVIEW-checkout-session-refactor`, AC-002

## Where it applies

- checkout session refactors

## Where it does not apply

- changes that do not touch checkout session status handling
```

## Lesson

Review by exception found three things the worker summary hid:

- one failed requirement
- one risky path
- one out-of-scope file
