# Pull and Spec

This page creates:

- `intake/checkout-expiry.md`
- `specs/checkout/spec.md`

Scenario:

> A checkout session older than 30 minutes must return `409 SESSION_EXPIRED`, never a 5xx.

The `shop-api` command is illustrative. Use your own repo for a real run.

## 1. Pull

Create `intake/checkout-expiry.md`.

Copy the source ask without rewriting it:

```markdown
---
type: intake
source: SHOP-4012
url: https://acme.atlassian.net/browse/SHOP-4012
captured: 2026-06-20
---

# Intake: stale checkout sessions return 500s

SHOP-4012 - Stale checkout sessions return 500s
Reporter: Priya N. (Support)
Priority: High
Labels: checkout, api

When a customer leaves checkout open for a while and then tries to pay,
the API sometimes throws a 500 instead of telling them the session timed
out. Support can't tell these apart from real outages.

What we want: a checkout session older than 30 minutes must return
409 SESSION_EXPIRED, never a 5xx.
```

Check:

- source, URL, and capture date are filled
- body is source text, not interpretation

## 2. Spec

Create `specs/checkout/spec.md`.

```markdown
---
type: spec
id: SPEC-checkout
title: Expired checkout sessions return 409
status: ready
owner: checkout-team
sources:
  - intake/checkout-expiry.md
---

# Expired checkout sessions return 409

## Intent

Expired checkout sessions return a client-visible expiry response instead of a server error.

## Non-goals

- The 30-minute lifetime does not change.
- The `sessions` table schema does not change.
- Session creation and charging behavior do not change.

## Requirements

### AC-001 - Expired session returns 409

When a request acts on a checkout session older than 30 minutes, the API must respond
`409 SESSION_EXPIRED` and must not return a 5xx.

Verify with: `npm run test:integration -- expired-session`

## Open questions

- None.

## Affected areas

- `src/checkout/`
```

Check:

- `status: ready`
- one requirement: `AC-001`
- `Verify with:` exists
- non-goals bound scope

Next: [Task and Run](02-task-and-run.md).
