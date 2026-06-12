---
type: audit
id: AUDIT-codex-promptly-field-test-job-021
title: Promptly field-test job 021 - overlay viewport and keyboard polish
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Field-Test Job 021 - Overlay Viewport And Keyboard Polish

## Scope

This audit records Swarm usage while delivering Promptly overlay positioning
and keyboard polish. It does not propose or implement Swarm framework changes.

## Product value delivered

Promptly now clamps the overlay to the viewport, constrains overlay width and
height, and routes Escape through the same close path that cancels active
inference.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/change-plans/020-promptly-ux-field-test.md`
- `/Users/josecosta/dev/promptly-docs/specs/021-overlay-polish/bug.md`
- `/Users/josecosta/dev/promptly-docs/tasks/021-overlay-polish.md`
- `/Users/josecosta/dev/promptly-docs/reviews/021-overlay-polish.md`

## Artifact usefulness

The bug report was the most useful artifact for this job. It let the work stay
as a bounded polish fix against existing overlay specs instead of creating a new
full feature spec. The task packet was enough for implementation because it
named the exact presentation scope and explicitly excluded action-system and
inference refactors.

The review packet was useful because every user-visible overlay behavior still
required a Chrome page observation, and the template had a place to mark those
rows Unverified.

## Skill and guide behavior

The right guide conceptually was bug/polish plus empirical evidence. The local
Swarm skill files needed for formal review/audit stance were unavailable later
in the run because of unrelated staged deletions in the Swarm working tree.
No scout or worker participated in this job.

Templates were used from Promptly docs:

- `/Users/josecosta/dev/promptly-docs/templates/task.md`
- `/Users/josecosta/dev/promptly-docs/templates/review.md`

The bug file followed the existing Promptly bug shape from
`specs/014-overlay-close-cancel/bug.md`.

## Review evidence

Sufficient evidence:

```text
$ ./node_modules/.bin/prettier --check <changed files>
exit 0
Checking formatting...
All matched files use Prettier code style!
```

```text
$ ./node_modules/.bin/wxt build
exit 0
✔ Built extension in 2.645 s
Σ Total size: 9.58 MB
✔ Finished in 2.761 s
```

Blocked evidence:

```text
$ ./node_modules/.bin/eslint .
exit 2
A configuration object specifies rule "@typescript-eslint/prefer-for-of", but could not find plugin "@typescript-eslint".
```

Missing evidence:

- No named human Chrome observation for edge selection, bounded drag,
  Escape-to-close, or close while streaming.
- Browser automation could not load a usable Chrome extension runtime.

## Safety versus ceremony

Useful safety: using a bug report rather than a fresh feature spec kept the
change small and prevented refactoring. Ceremony: the review table was repetitive
because every meaningful overlay behavior depended on the same blocked runtime
validation path.
