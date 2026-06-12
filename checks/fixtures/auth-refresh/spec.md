---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-auth-refresh
title: Silent token refresh on 401
status: draft
owner: auth-team
sources:
  - AUTH-731
---

# Silent token refresh on 401

## Intent

When an access token expires mid-session, the web client refreshes it transparently and
replays the original request, so the user never sees a spurious login screen.

## Non-goals

- Server-side token issuance or rotation policy — owned by the identity service.
- Long-lived offline sessions.

## Requirements

### AC-001 — replay on 401

When a request returns 401 and a refresh token is present, the auth client must replay the
original request once with a refreshed session.

Verify with: `npm test -- auth-refresh.spec.ts` (case `replays-after-refresh`)

### AC-002 — expired refresh token ends the session

When the refresh token is itself expired, the auth client must redirect to `/login`.

### AC-003 — refresh timeout

When the refresh request times out, the auth client must handle the failure gracefully.

Verify with: `npm test -- auth-refresh.spec.ts` (case `timeout`)

## Open questions

- None.

## Affected areas

- `web/src/http/client.ts`
- `web/src/auth/refresh.ts`
