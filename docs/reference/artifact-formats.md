# Artifact formats

Every Corpus file is markdown with frontmatter.

The `type:` field identifies the artifact.

## Core types

| Type | Prefix | Home |
| --- | --- | --- |
| `intake` | none | `intake/` |
| `spec` | `SPEC-` | `specs/<feature>/spec.md` |
| `task` | `TASK-` | `tasks/` |
| `review` | `REVIEW-` | `reviews/` |
| `finding` | `FINDING-` | `findings/` |
| `status` | none | `status.md` |

## Conditional types

| Type | Prefix | Home |
| --- | --- | --- |
| `inventory` | `INV-` | `inventory/` |
| `change-plan` | `CHANGE-` | `change-plans/` |

## Advanced types

| Type | Use |
| --- | --- |
| `audit` | present-state risk or debt |
| `bug-report` | diagnosis of one defect |
| `adr` | decision record |
| `research` | inquiry with sources, no decision |
| `prd` | product requirements |
| `rfc` | proposal for review |
| `threat-model` | security analysis |
| `release-note` | shipped-change note |

## Intake

Frontmatter:

```yaml
type: intake
source: SHOP-4012
url: https://...
captured: 2026-06-20
```

Body: verbatim source text.

No interpretation.

## Spec

Frontmatter:

```yaml
type: spec
id: SPEC-checkout
title: Expired checkout sessions
status: draft
owner: checkout-team
sources:
  - intake/SHOP-4012.md
```

Sections:

- Intent
- Non-goals
- Requirements
- Open questions
- Affected areas
- Dropped from sources, when needed

Each requirement has:

- `AC-NNN`
- one behavior
- `Verify with:`

## Task

Frontmatter:

```yaml
type: task
id: TASK-checkout-expiry
source:
  - SPEC-checkout
scope: [AC-001]
status: ready
```

Sections:

- Source
- Scope
- Do not change
- Affected areas
- Verify
- Agent instructions
- Findings
- Run summary

Every verify item names a requirement id.

## Review

Frontmatter:

```yaml
type: review
id: REVIEW-checkout-expiry
task: TASK-checkout-expiry
pr: https://...
reviewer: name-or-session
status: draft
```

Sections:

- Summary
- Changed files
- Requirement coverage
- Change-plan coverage, when relevant
- Human attention
- Open decisions, when relevant
- Task status
- Suggested decision

Coverage rows use:

```text
ID | Result | Evidence | Human attention
```

Results:

- `Pass`
- `Fail`
- `Unverified`
- `Blocked`

A `Pass` needs evidence.

## Finding

Frontmatter:

```yaml
type: finding
id: FINDING-session-expiry-is-409
from: REVIEW-checkout-expiry
date: 2026-06-20
related:
  - SPEC-checkout#AC-001
```

Sections:

- What we learned
- Evidence
- Where it applies
- Where it does not apply
- related spec / task / review / file
- Future guidance (optional)

One finding, one durable claim.

## Status board

`status.md` is hand-edited.

It lists:

- active specs
- active tasks
- review status
- human attention
- pending findings

Closed or verified rows link to their review packet while retained.

## Inventory

Use before brownfield work.

Sections:

- Scope
- Observed structure
- Interfaces
- Tests
- Unknowns
- Risks

No prescriptions.

## Change plan

Use for structural work.

Sections:

- Baseline
- Target
- Preservation guarantees
- Transformation waves
- Cutover / rollback
- Task split

Every wave names verification.

## Reference rules

- IDs are stable.
- Accepted decisions are superseded, not rewritten.
- Requirement IDs are spec-scoped.
- Cross-spec references use `SPEC-id#AC-NNN`.
- Code can falsify a spec; it does not amend it.

## Related

- [Checks](checks.md)
- [Basic workflow](../02-basic-workflow.md)
- [Where files live](../03-where-files-live.md)
