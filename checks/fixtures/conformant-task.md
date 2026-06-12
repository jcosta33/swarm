<!--
Checks fixture — positive. Expected: a checker applying ../checks.yaml's
task_file rules reports nothing. Every required section is present;
every Verify item carries pasted output (non-empty-paste satisfied); the
status is terminal (closed) and no blocking open question remains anywhere
(no-open-critical satisfied). Inert fixture data — nothing here runs.
-->

---
type: task
id: TASK-export-json-flag
source:
  - SPEC-export-cli
scope: [AC-001, AC-002]
status: closed
---

# Task: Add a `--json` flag to the `export` command

## Source

- Spec: `specs/export-cli/spec.md` (SPEC-export-cli)

## Scope

Implement or preserve:

- AC-001 — when `export` is invoked with `--json`, it writes the result set as
  one valid JSON document to stdout.
- AC-002 — when `export --json` completes without error, it exits with status
  code 0.

## Do not change

- `src/format/human.ts` — the default human-readable formatter. No-flag output
  stays byte-for-byte identical.

## Affected areas

- `src/cli/export.ts`
- `src/format/json.ts`

## Verify

- [x] `npm test -- export-json.spec.ts` (AC-001, AC-002)

  ```
  PASS tests/export-json.spec.ts
    export --json
      ✓ emits one valid JSON document to stdout (41 ms)
      ✓ exits 0 on success (12 ms)
  Tests: 2 passed, 2 total
  ```

- [x] `npm test -- export-default.spec.ts` (guards "Do not change": default
  output unchanged)

  ```
  PASS tests/export-default.spec.ts
    export (no flag)
      ✓ output identical to the recorded snapshot (18 ms)
  Tests: 1 passed, 1 total
  ```

## Agent instructions

1. Read the source spec first.
2. Stay inside this task's scope. If a requirement can't be met as written,
   stop and say why instead of improvising.
3. Run every Verify item and paste the real output — a claim without output
   counts as unverified.
4. Before finishing, re-read your own diff as a skeptic: what would a
   reviewer flag?
5. Leave a summary: changed files, commands run with output, and anything
   learned worth saving as a finding.

## Findings

- The CLI arg parser lowercases flag names before dispatch, so any future flag
  must be registered in lowercase (`--json`, never `--JSON`) or it silently
  falls through to the default formatter. Worth saving to `findings/` at Close.
