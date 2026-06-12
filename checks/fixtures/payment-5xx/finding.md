---
# checks fixture — expected results pinned in EXPECTED.md
type: finding
id: FINDING-idempotency-key-persistence
status: candidate
from: REVIEW-payment-5xx
date: 2026-06-11
related: [SPEC-payment-5xx#AC-001]
---

# Finding: Persist the idempotency key before the first capture attempt

## What we learned

The provider deduplicates charges only after our idempotency key reaches its storage: two
concurrent submissions raced past the not-yet-persisted key and both captured. A
single-request test can never witness this defect.

## Evidence

REVIEW-payment-5xx: the staging monitor `duplicate-captures` reported two captures for one
idempotency key (dashboard link in the review packet) while the single-request test suite
stayed green throughout PR run #209.

## Where it applies

- Any retry or replay path that reuses an idempotency key, including automatic 5xx retries.

## Where it does not apply

- Providers that deduplicate server-side regardless of key timing (ours does not).

## Future guidance

Persist the key, then charge — and give every idempotency requirement a concurrent-request
test case, not just a single-request one.
