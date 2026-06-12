---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-auth-refresh
title: Silent token refresh on 401
status: draft
owner: auth-team
sources:
  - AUTH-731
format: sol
---

# Silent token refresh on 401

<!-- The same spec as spec.md, written on the stricter surface — this directory's
     equivalence pair. -->

## Intent

When an access token expires mid-session, the web client refreshes it transparently and
replays the original request, so the user never sees a spurious login screen.

## Non-goals

- Server-side token issuance or rotation policy — owned by the identity service.
- Long-lived offline sessions.

## Requirements

REQ AC-001:
WHEN a request returns 401 and a refresh token is present
THE auth client MUST replay the original request once with a refreshed session
VERIFY BY test:cmdTest:auth-refresh.spec.ts#replays-after-refresh
WRITES web/src/http/client.ts
RISK high

REQ AC-002:
WHEN the refresh token is itself expired
THE auth client MUST redirect to `/login`
WRITES web/src/auth/refresh.ts

REQ AC-003:
WHEN the refresh request times out
THE auth client MUST handle the failure gracefully
VERIFY BY test:cmdTest:auth-refresh.spec.ts#timeout
WRITES web/src/http/client.ts

## Open questions

- None.

## Affected areas

- `web/src/http/client.ts`
- `web/src/auth/refresh.ts`
