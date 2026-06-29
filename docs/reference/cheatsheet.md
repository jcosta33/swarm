# Cheatsheet

## Loop

```text
Pull -> (Inventory) -> Spec -> (Change Plan) -> Task -> Run -> Review -> Close
```

## Files

| Step | File |
| --- | --- |
| Pull | `intake/*.md` |
| Inventory | `inventory/*.md` |
| Spec | `specs/<feature>/spec.md` |
| Change Plan | `change-plans/*.md` |
| Task | `tasks/*.md` |
| Run | spec `## Execution` (default), or task `## Run summary` |
| Review | `reviews/*.md` |
| Close | `findings/*.md`, `status.md` |

## Requirement

```markdown
### AC-001 - Short name

The system must do one observable thing.

Verify with: `command`
```

Rules:

- one behavior
- one binding word
- one verify line
- uncertainty goes to Open questions

## Results

Four core results:

| Result | Meaning |
| --- | --- |
| Pass | evidence shows requirement is met |
| Fail | evidence shows requirement is not met |
| Unverified | evidence is missing or insufficient |
| Blocked | cannot judge yet |

Empty evidence means `Unverified`.

Three lifecycle markers (decorate a prior result, never a core value — [advanced lifecycle](advanced-lifecycle.md)):

| Marker | Meaning |
| --- | --- |
| Waived | a `Fail`/`Unverified` accepted by the owner, with reason and expiry |
| Stale | a prior `Pass` no longer trusted after the text or evidence path changed |
| Contradicted | evidence conflicts |

Merge gate: every in-scope requirement is `Pass` or a live `Waived`, and none is `Stale`, `Contradicted`, `Fail`, `Blocked`, or `Unverified`. An empty scope does not pass.

## Evidence

Valid:

- pasted command output
- CI link
- named manual observation

Invalid:

- `tests passed`
- worker summary alone
- unsupported screenshot

## Review triggers

Route to Human attention:

- Fail, Unverified, Blocked
- out-of-scope edits
- `Do not change` touched
- risky files
- public interface changes
- migrations
- security-sensitive changes
- missing test output
- candidate findings
- blocked questions

## Core checks

| ID | Name |
| --- | --- |
| C001 | `unique-ids` |
| C002 | `duplicate-id` |
| C003 | `verify-with` |
| C004 | `one-strength-word` |
| C005 | `non-goals-present` |
| C006 | `open-questions-present` |
| C007 | `no-tbd-at-ready` |
| C008 | `sources-named` |
| C009 | `broken-source-link` |
| C010 | `preserves-refs-resolve` |
| C011 | `waves-present` |
| C012 | `coverage` |
| C013 | `verify-evidence-binding` |
| C014 | `do-not-change-touched` |
| C015 | `citation-resolves` |
| C016 | `pass-needs-evidence` |
| C017 | `orphaned-reference` |

See [checks](checks.md).

## Workspace names

Dedicated workspace repo:

```text
<project>-works
```

Code repo pointer:

```text
Suspec workspace: ../<project>-works. Read the task packet before coding.
```

## CLI

Common commands:

```bash
suspec init
suspec update --check
suspec check
suspec new spec <slug>
suspec new task --from SPEC-id --scope AC-001
suspec worktree create TASK-id
suspec run TASK-id --agent codex
suspec review TASK-id
suspec status
```

CLI prepares and reconciles. It does not write code or decide correctness.
