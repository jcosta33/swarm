---
type: audit
id: AUDIT-codex-promptly-field-test-rollup
title: Promptly Swarm field-test rollup
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Swarm Field-Test Rollup

## Scope

This audit compares three Promptly UX jobs run through Swarm artifacts. It
collects datapoints only; it does not propose or implement Swarm framework
changes.

## Jobs compared

| Job | Promptly value | Swarm shape | Final review state |
|---|---|---|---|
| 020 model lifecycle | Popup model status plus load/reload/unload controls | audit -> spec -> task -> review | needs-human |
| 021 overlay polish | Viewport clamp, bounded render, Escape close | bug -> task -> review | needs-human |
| 022 response recovery | Retry latest, clear conversation, retry after error | spec -> task -> delegated worker -> review | needs-human |

## Cross-job observations

### Artifact fit varied by task type

The model lifecycle job benefited from an audit plus spec because it introduced
a new messaging contract. The overlay job benefited more from a bug report
because the desired change was bounded polish against existing overlay behavior.
The response recovery job benefited from a spec because the non-goals
conversation persistence and history browsing were important constraints.

### Review templates carried the honesty load

All three jobs produced real product changes and a passing extension build, but
none had Chrome runtime proof. The review packet shape made it natural to mark
runtime behavior Unverified instead of collapsing build success into product
acceptance.

### Baseline blockers dominated check evidence

The official commands requested in the plan were blocked by pnpm ignored build
scripts:

```text
$ pnpm build
exit 1
[ERR_PNPM_IGNORED_BUILDS] Ignored build scripts: esbuild@0.25.2, spawn-sync@1.0.15, unrs-resolver@1.7.2
```

Direct TypeScript and ESLint fallbacks remained blocked by pre-existing
baseline issues. The only clean automated checks available across the jobs were
changed-file Prettier and WXT production build.

### Chrome extension runtime remained the validation gap

Playwright could import from Promptly's dependencies, but system Chrome aborted
under persistent extension launch and the bundled Playwright Chromium was not
installed. This left popup, overlay, streaming/cancel, retry, clear, and error
recovery behavior pending named human observation.

### Delegation improved with a task packet

The Job 3 worker behaved more like a Swarm-booted task worker than earlier
subagent datapoints: it read the task/spec, used a narrow write scope, reported
skills, avoided broad checks, and made one scoped improvement. The datapoint is
limited because the lead had already implemented most of the job before the
worker was launched.

## Candidate requirement areas observed

- Extension-runtime validation evidence for browser extension projects.
- Delegated-worker boot evidence that distinguishes "read the task" from "read
  the workspace bootloader, task, spec, and linked plan."
- Review rows for baseline-blocked official checks versus targeted fallback
  evidence.
- Guidance for when a bug report is enough and a full spec would add ceremony.

## Useful safety versus ceremony

Useful safety:

- Non-goals prevented scope drift in all three jobs.
- Review packets kept Blocked and Unverified evidence visible.
- The delegated task packet's write ownership prevented broad worker edits.

Ceremony:

- Repeating the same blocked validation rows across three reviews was noisy.
- A full audit/spec/task/review chain was heavier than necessary for overlay
  polish.
- Late delegation produced a less pure datapoint than a worker-led
  implementation from the start.

## Close state

Promptly code changes are implemented and buildable. Promptly docs record the
change plan, specs/tasks/reviews, and validation finding. Product acceptance
still depends on a named manual Chrome extension observation.
