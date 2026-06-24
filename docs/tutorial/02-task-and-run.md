# Task and Run

This page creates:

- `tasks/checkout-expiry.md`
- a run summary in that task

## 1. Task

Create `tasks/checkout-expiry.md`.

```markdown
---
type: task
id: TASK-checkout-expiry
source:
  - SPEC-checkout
scope: [AC-001]
status: ready
---

# Task: Expired checkout session returns 409

## Source

- `specs/checkout/spec.md`

## Scope

- AC-001 - A checkout session older than 30 minutes returns `409 SESSION_EXPIRED`, never a 5xx.

## Do not change

- the `sessions` table schema

## Affected areas

- `src/checkout/`
- `test/`

## Verify

- [ ] `npm run test:integration -- expired-session` (AC-001)

## Agent instructions

Copy from the task template.
```

Check:

- scope is `[AC-001]`
- `Do not change` names the schema
- verify command matches the spec
- agent instructions come from the template

## 2. Run

Use one worktree or branch per task.

Example:

```bash
git worktree add -b corpus/checkout-expiry ../shop-api--checkout-expiry main
```

Hand off:

```text
Read tasks/checkout-expiry.md and do what it says.
```

## Expected return

The worker pastes real output under the verify item and fills the run summary:

```markdown
## Verify

- [x] `npm run test:integration -- expired-session` (AC-001)

      Test Suites: 1 passed, 1 total
      Tests:       3 passed, 3 total

## Run summary

- Changed files: `src/checkout/expiry.ts`, `src/api/errors.ts`, `test/integration/expired-session.test.ts`
- Verify results:
  - `npm run test:integration -- expired-session` (AC-001): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

Check:

- output is pasted, not summarized
- changed files are listed
- out-of-scope edits are named, even if `none`
- blocked questions are named, even if `none`

Next: [Review](03-review.md).
