---
type: audit
id: AUDIT-codex-promptly-field-test-job-020
title: Promptly field-test job 020 - model lifecycle UX
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Field-Test Job 020 - Model Lifecycle UX

## Scope

This audit records Swarm usage while delivering Promptly popup model lifecycle
UX. It does not propose or implement Swarm framework changes.

## Product value delivered

Promptly now has a typed model runtime status protocol, background-owned model
status, and popup controls for load, reload, and unload.

Review follow-up: Promptly commit `df0b4cd` records the fix for the
raw-progress completion finding from the adversarial review.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/change-plans/020-promptly-ux-field-test.md`
- `/Users/josecosta/dev/promptly-docs/specs/020-model-lifecycle/audit.md`
- `/Users/josecosta/dev/promptly-docs/specs/020-model-lifecycle/spec.md`
- `/Users/josecosta/dev/promptly-docs/tasks/020-model-lifecycle.md`
- `/Users/josecosta/dev/promptly-docs/reviews/020-model-lifecycle.md`

## Artifact usefulness

The current-state audit was useful because it identified the missing boundary:
Promptly had loading progress but no runtime status request/response contract.
The spec was useful for keeping the status shape serializable and preventing
the popup work from becoming a broader model-provider redesign. The task packet
was enough for implementation because affected files and non-goals were narrow.

The review packet was useful mostly as an honesty container: it let the work
record build success while keeping Chrome runtime behavior Unverified.

## Skill and guide behavior

The main thread initially had Swarm skills available, but during this field
test the Swarm working tree already contained unrelated staged deletions for
several `.agents/skills/*` files. Later attempts to reload `write-audit`,
`persona-auditor`, `persona-skeptic`, and `review-output` failed with
`No such file or directory`. `empirical-proof` remained readable and was the
guide that most directly shaped the review packet.

No scout or worker participated in this job.

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
$ pnpm build
exit 1
[ERR_PNPM_IGNORED_BUILDS] Ignored build scripts: esbuild@0.25.2, spawn-sync@1.0.15, unrs-resolver@1.7.2
```

```text
$ ./node_modules/.bin/tsc --noEmit
exit 2
src/components/Flex/Flex.tsx(1,15): error TS6133: 'FC' is declared but its value is never read.
...
src/stories/Header.tsx(1,1): error TS6133: 'React' is declared but its value is never read.
```

Unverified evidence:

```text
Playwright Chrome extension attempt
ok: false
Chrome channel launch failed: browserType.launchPersistentContext: Target page, context or browser has been closed
Bundled Chromium fallback failed: Executable doesn't exist at .../chromium-1200/.../Google Chrome for Testing
```

## Safety versus ceremony

Useful safety: the spec and review template prevented the build pass from being
misreported as runtime validation. Ceremony: creating both an audit and spec
for a small UI surface felt heavy, but the audit did expose the missing
background-owned runtime status boundary before implementation.
