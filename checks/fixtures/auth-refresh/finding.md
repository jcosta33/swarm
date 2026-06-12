---
# checks fixture — expected results pinned in EXPECTED.md
type: finding
id: FINDING-refresh-storm
status: candidate
from: REVIEW-auth-refresh
date: 2026-06-11
related: [SPEC-auth-refresh#AC-001]
---

# Finding: A single expired token fans out into N concurrent refresh calls

## What we learned

When several requests are in flight as the token expires, each sees its own 401 and
independently triggers a refresh — every request replays only once, yet the client still
issues N parallel refresh calls for one expired token.

## Evidence

REVIEW-auth-refresh: the concurrency case added during review showed three parallel refresh
calls for one expired token — `npm test -- auth-refresh.spec.ts`, case `concurrent-401s`,
output in PR run #88.

## Where it applies

- Any client where multiple authenticated requests can be in flight at token expiry.

## Where it does not apply

- Clients that serialize all authenticated requests.

## Future guidance

Guard the refresh path with a single-flight lock: the first 401 refreshes, concurrent 401s
await the same promise. A spec for token-refresh work should carry that as an explicit
requirement with its own test.
