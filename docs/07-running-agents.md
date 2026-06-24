# Running agents

Corpus does not run agents. It gives them task packets.

Any worker can use a task packet:

- Claude Code
- Codex
- Cursor
- Aider
- another agent
- a human

## Handoff

Point the worker at the task file:

```text
Read tasks/checkout-expiry.md and do what it says.
```

The task file contains the source, scope, `Do not change`, affected areas, verify commands, and standing instructions.

## Worker types

- **Worker**: implements a task and leaves a run summary.
- **Scout**: reads or researches and reports back. It does not merge code.

Do not merge scout output as implementation work.

## Roles

Run authoring, implementation, and review as different sessions:

- **Spec/task author** — writes the spec, change plan, and task packet.
- **Implementer** — executes one task; reads the task and cited spec; the task is the scope boundary; does not change requirements.
- **Lens reviewer** — reviews one lens (correctness, evidence, design risk, …) and returns findings only.
- **Review lead** — orchestrates at least three lens reviewers, reconciles, and writes the packet.
- **Human/owner** — owns the verdict.

The reviewer is not the implementer. The spec or task author may review the implementation, as long as they did not implement it.

Escalate to a stronger model or session on unclear scope, repeated Verify failures, risky files, or a requirement that needs reinterpretation. A cheaper implementer fits a clear, bounded task — but measure the saving by pass rate, rework rate, and review outcome; never assume it.

## Worktree rule

Use one branch or worktree per task.

Branch pattern:

```text
corpus/<spec-slug>/<task-slug>
```

For a single-task spec:

```text
corpus/<task-slug>
```

Worktrees isolate file state. They do not isolate shared services, ports, databases, or credentials. Configure those separately when needed.

## Provenance

For delegated or worker-run tasks, record:

- sources read
- guide loaded
- worker identity
- isolation mode: worktree, shared tree, or patch-only

This is evidence for review. It is not a trust token.

## What the worker must return

The returned task packet contains:

- every verify item checked or marked blocked
- real output pasted under each command
- changed files listed
- out-of-scope edits named
- blocked questions named
- candidate findings listed

Example:

```markdown
## Verify

- [x] `npm run test:integration -- expired-session` (AC-001)

      Test Suites: 1 passed, 1 total
      Tests:       3 passed, 3 total

## Run summary

- Changed files: `src/checkout/expiry.ts`, `test/integration/expired-session.test.ts`
- Verify results:
  - `npm run test:integration -- expired-session` (AC-001): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

## Evidence rule

`Tests passed` is not evidence.

A `Pass` needs pasted output, a CI link, or a named manual observation. Without that, review records `Unverified`.

## Self-review

The worker inspects its own diff before handoff.

Self-review can produce fixes. It does not produce the review result. The result belongs to an independent reviewer.

## Keep the worktree

Keep the worktree until review is final. Review may need to:

- inspect the diff
- rerun commands
- verify changed files
- ask for follow-up work
