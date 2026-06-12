---
# checks fixture — expected results pinned in EXPECTED.md
type: review
id: REVIEW-auth-refresh
task: TASK-auth-refresh
pr: https://example.test/pr/412
status: needs-human
---

# Review: Silent token refresh on 401

## Summary

The client now replays a 401'd request once with a refreshed session, and a refresh timeout
surfaces an error instead of hanging. AC-002 shipped without a named test and is unverified.

## Changed files

- `web/src/http/client.ts`
- `web/src/auth/refresh.ts`

## Requirement coverage

| ID | Result | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass | `npm test -- auth-refresh.spec.ts` → `replays-after-refresh ✓` (full output in PR run #88) | no |
| AC-002 | Unverified | | yes |
| AC-003 | Pass | `npm test -- auth-refresh.spec.ts` → `timeout ✓` (full output in PR run #88) | no |

## Human attention

1. AC-002 has an empty Evidence cell, so the row reads Unverified — never Pass. The spec
   names no verification for it; decide: add the test, or accept the gap on the record.
2. `web/src/http/client.ts` is a risky file — every request flows through it. Spot-checked
   the AC-001 row by re-running `npm test -- auth-refresh.spec.ts` locally: same output.
3. No out-of-scope changes, public-interface changes, DB migrations, or security-sensitive
   edits; one finding candidate (refresh fan-out) recorded; no blocked questions.

## Suggested decision

Block until AC-002 has a test with pasted output or a recorded acceptance; the rest is
mergeable.
