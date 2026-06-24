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
| Run | task `## Run summary` |
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

| Result | Meaning |
| --- | --- |
| Pass | evidence shows requirement is met |
| Fail | evidence shows requirement is not met |
| Unverified | evidence is missing or insufficient |
| Blocked | cannot judge yet |

Empty evidence means `Unverified`.

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
Corpus workspace: ../<project>-works. Read the task packet before coding.
```

## CLI

Common commands:

```bash
corpus init
corpus update --check
corpus check
corpus new spec <slug>
corpus new task --from SPEC-id --scope AC-001
corpus worktree create TASK-id
corpus run TASK-id --agent codex
corpus review TASK-id
corpus status
```

CLI prepares and reconciles. It does not write code or decide correctness.
