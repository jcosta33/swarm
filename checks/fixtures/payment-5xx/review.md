---
# checks fixture — expected results pinned in EXPECTED.md
type: review
id: REVIEW-payment-5xx
task: TASK-payment-5xx
pr: https://example.test/pr/641
status: blocked
---

# Review: Payment provider 5xx handling

## Summary

The charge path now retries once on a provider 5xx with the same idempotency key, and the
idempotency test passes. The diff satisfies AC-002 and thereby violates AC-003 — the spec
contradicts itself, and its blocking question is still open.

## Changed files

- `server/src/payments/charge.ts`

## Requirement coverage

| ID | Result | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass | `npm test -- payment-idempotency.spec.ts` → `at-most-one-capture ✓` (full output in PR run #209) | no |
| AC-002 | Pass | `npm test -- payment-retry.spec.ts` → `retries-once ✓` (full output in PR run #209) | yes |
| AC-003 | Unverified | | yes |

## Human attention

1. AC-002 and AC-003 contradict — same trigger, opposed strength words. The code satisfies
   AC-002, so AC-003 cannot also hold; the spec owner must drop one before any merge.
2. The spec's blocking question (provider idempotency across retries) is still open — this
   work should not have been prepared past it, and it cannot close while the question stands.
3. AC-003 has an empty Evidence cell, so the row reads Unverified — never Pass. Its `no-retry`
   case was never run; running it against this diff would fail by construction.
4. `server/src/payments/charge.ts` is security-sensitive (it moves money). Spot-checked the
   AC-001 row by re-running `npm test -- payment-idempotency.spec.ts` locally: same output.

## Suggested decision

Block until the spec resolves the AC-002/AC-003 contradiction and answers the blocking
question; re-review against the corrected spec.
