# Saving findings

Close is where durable lessons leave the task and enter the workspace.

Save a finding when the lesson will matter again.

Do not save task-local scratch.

## What counts

Good finding candidates:

- a behavior that surprised the worker or reviewer
- a project constraint not already documented
- a risky edge case
- a test or fixture fact future tasks need
- a recurring implementation pattern
- a known non-goal or boundary

Poor finding candidates:

- routine command output
- temporary debugging notes
- one-off local setup
- speculation with no evidence

## Finding shape

Use the kit template.

Include:

- one claim
- evidence
- where it applies
- where it does not apply
- related spec, task, review, or file

Example:

```markdown
# Finding: expired checkout sessions are 409

## What we learned

Expired checkout sessions return `409 SESSION_EXPIRED`, not a 5xx.

## Evidence

- `reviews/checkout-expiry.md`, AC-001
- `test/integration/expired-session.test.ts`

## Where it applies

- checkout session expiry

## Where it does not apply

- other checkout validation failures
- non-checkout sessions
```

## Board update

After review:

- update `status.md`
- link closed work to its review packet while retained
- add pending findings to Human attention
- carry forward blocked questions or follow-up work

A closed row without evidence is not a reliable board entry.

## Promotion

Some discoveries belong somewhere else:

- intended behavior -> spec amendment
- decision with tradeoffs -> ADR
- reusable fact -> finding
- repeated fact pattern -> pattern, if the workspace uses patterns
- term definition -> glossary

A finding does not weaken a requirement. If the finding contradicts the spec, reconcile the spec.

## Retrieval

There is no retrieval engine in the markdown workflow.

Use:

- clear filenames
- `status.md`
- links from specs, tasks, and reviews
- grep

Name findings for the words future readers will search.
