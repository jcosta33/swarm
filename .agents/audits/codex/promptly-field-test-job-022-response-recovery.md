---
type: audit
id: AUDIT-codex-promptly-field-test-job-022
title: Promptly field-test job 022 - response recovery controls
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Field-Test Job 022 - Response Recovery Controls

## Scope

This audit records Swarm usage while delivering Promptly response recovery
controls and one delegated worker datapoint. It does not propose or implement
Swarm framework changes.

## Product value delivered

Promptly now has retry latest, clear conversation, and retry-after-error
controls in the response panel. `PromptOverlay` owns latest request state and
clear cancels active loading or streaming work before resetting overlay state.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/change-plans/020-promptly-ux-field-test.md`
- `/Users/josecosta/dev/promptly-docs/specs/022-response-recovery/spec.md`
- `/Users/josecosta/dev/promptly-docs/tasks/022-response-recovery.md`
- `/Users/josecosta/dev/promptly-docs/reviews/022-response-recovery.md`

## Artifact usefulness

The spec was useful because it captured the boundary between recovery controls
and excluded persistence/history browsing. The task packet was enough for the
delegated worker to identify one missing detail: recovery controls needed to
render as soon as a conversation exists, including while the assistant message
is still empty.

The review packet was useful because it recorded the worker result without
treating the worker's pasted output as independent runtime proof.

## Delegated worker behavior

Worker `019ebdf4-5684-7771-9f6c-5aee56693a43` was launched from the task packet
with write ownership limited to:

- `/Users/josecosta/dev/promptly/src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx`
- `/Users/josecosta/dev/promptly/src/modules/selection/presentations/views/PromptOverlay/PromptOverlay.tsx`

The worker changed only `ResponseDisplay.tsx`. It reported using
`implement-task` and `empirical-proof`, and said it felt fully Swarm-booted from
`AGENTS.md`, the task, the spec, and the change plan. It did not use a template.

Observed limitation: the worker inherited enough instructions to behave more
like a Swarm task worker than earlier subagents, but this was still weaker than
a true from-scratch delegated implementation because the lead agent had already
implemented most of the job before delegation.

## Review evidence

Worker-provided evidence, later re-run by the lead:

```text
$ ./node_modules/.bin/prettier --check src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx src/modules/selection/presentations/views/PromptOverlay/PromptOverlay.tsx
Checking formatting...
All matched files use Prettier code style!
```

Lead evidence:

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
$ ./node_modules/.bin/tsc --noEmit
exit 2
src/components/Flex/Flex.tsx(1,15): error TS6133: 'FC' is declared but its value is never read.
...
src/stories/Header.tsx(1,1): error TS6133: 'React' is declared but its value is never read.
```

Missing evidence:

- No named human Chrome observation for retry latest, clear while streaming, or
  retry after an induced error.

## Safety versus ceremony

Useful safety: explicit write ownership prevented the worker from touching
model lifecycle or overlay positioning files. The task packet's non-goals kept
the worker out of persistence/history. Ceremony: because the worker arrived
late, the delegated implementation datapoint was partly artificial; it still
found a real UI gap.
