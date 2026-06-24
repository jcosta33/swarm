# Creating tasks

A task packet is the unit of work handed to an agent or person.

It does not add requirements. It copies scope from a spec or change plan.

## Task shape

```markdown
---
type: task
id: TASK-checkout-expiry
source:
  - SPEC-checkout
scope: [AC-001]
status: ready
---

# Task: Expired checkout session returns 409

## Source

- `specs/checkout/spec.md`

## Scope

- AC-001 - Expired sessions return `409 SESSION_EXPIRED`.

## Do not change

- `sessions` table schema

## Affected areas

- `src/checkout/`
- `test/integration/`

## Verify

- [ ] `npm run test:integration -- expired-session` (AC-001)

## Agent instructions

Copy from the task template.
```

## Scope

Keep scope small.

Good tasks:

- cover one behavior or one wave
- name exact requirement ids
- have a clear write surface
- have runnable verification
- can be reviewed without reading a huge diff

Split tasks when:

- files overlap but behaviors differ
- refactor and behavior change are mixed
- one command cannot verify the work
- parallel work would write the same files

## Do not change

`Do not change` is the scope wall.

Name tempting adjacent areas:

- schemas
- public APIs
- payment code
- auth rules
- generated files
- unrelated modules

A changed `Do not change` path is a review exception, even if the change looks harmless.

## Verify

Every scoped requirement needs a verify item.

Each verify item:

- names the command
- names the requirement id
- is runnable by the worker or explicitly manual

Manual verification names who observed what.

## Parallel tasks

Parallel tasks need disjoint write surfaces.

If two tasks write the same file, serialize them or split differently.

## Multi-repo tasks

Prefix affected areas with the repo name:

```text
api: src/checkout/**
web: app/checkout/**
```

Each repo still needs its own verification command.

## Run summary

The worker fills the run summary after implementation.

It records:

- changed files
- verify results with pasted output
- out-of-scope edits
- blocked questions
- candidate findings

The summary points to evidence. It does not replace evidence.
