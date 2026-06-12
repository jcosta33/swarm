---
# checks fixture — expected results pinned in EXPECTED.md
type: task
id: TASK-payment-5xx
source:
  - SPEC-payment-5xx
scope: [AC-001, AC-002, AC-003]
status: review-ready
---

# Task: Payment provider 5xx handling

<!-- Seeded defect carrier: this task was prepared while the spec's blocking question was
     still open — the situation EXPECTED.md pins as SOL-O003 at task-splitting. -->

## Source

- Spec: `specs/payment-5xx/spec.md` (SPEC-payment-5xx)

## Scope

Implement or preserve:

- AC-001 — at most one capture per idempotency key
- AC-002 — retry the charge once on a provider 5xx
- AC-003 — do not retry the charge on a provider 5xx

## Do not change

- The provider SDK and its request signing.
- Payout and refund paths.

## Affected areas

- `server/src/payments/charge.ts`

## Verify

- [ ] `npm test -- payment-idempotency.spec.ts` (AC-001)
- [ ] `npm test -- payment-retry.spec.ts` (AC-002, AC-003)

## Agent instructions

1. Read the source spec first.
2. Stay inside this task's scope. If a requirement can't be met as written, stop and say why
   instead of improvising — AC-002 and AC-003 cannot both be met as written.
3. Run every Verify item and paste the real output — a claim without output counts as
   unverified.
4. Before finishing, re-read your own diff as a skeptic: what would a reviewer flag?
5. Leave a summary: changed files, commands run with output, and anything learned worth
   saving as a finding.

## Findings

- Candidate: the provider is idempotent only after the key is persisted — see `finding.md`.
