---
# checks fixture — expected results pinned in EXPECTED.md
type: task
id: TASK-auth-refresh
source:
  - SPEC-auth-refresh
scope: [AC-001, AC-002, AC-003]
status: review-ready
---

# Task: Silent token refresh on 401

## Source

- Spec: `specs/auth-refresh/spec.md` (SPEC-auth-refresh)

## Scope

Implement or preserve:

- AC-001 — replay the original request once with a refreshed session
- AC-002 — expired refresh token redirects to `/login`
- AC-003 — refresh timeout surfaces a failure

## Do not change

- Token issuance and rotation policy — owned by the identity service.
- `web/src/auth/storage.ts` — the session storage format is out of bounds.

## Affected areas

- `web/src/http/client.ts`
- `web/src/auth/refresh.ts`

## Verify

- [ ] `npm test -- auth-refresh.spec.ts` (AC-001, AC-003)
- [ ] AC-002 — the spec names no verification; expect Unverified at review unless a test is
      added and its output pasted

## Agent instructions

1. Read the source spec first.
2. Stay inside this task's scope. If a requirement can't be met as written, stop and say why
   instead of improvising.
3. Run every Verify item and paste the real output — a claim without output counts as
   unverified.
4. Before finishing, re-read your own diff as a skeptic: what would a reviewer flag?
5. Leave a summary: changed files, commands run with output, and anything learned worth
   saving as a finding.

## Findings

- Candidate: concurrent 401s fan out into parallel refresh calls — see `finding.md`.
