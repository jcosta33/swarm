# Reviewing output

Review checks the worker's output against the task and spec.

Do not read a large diff from line 1. Start with:

- requirement coverage
- failed, unverified, or blocked rows
- human-attention items
- changed files

Then open the diff where the packet points.

## Reviewer rule

The implementer does not render the review result. The reviewer is not the implementer — but the spec or task author may review, as long as they did not implement the change.

Use a fresh session, another agent, or a human reviewer.

For code-changing work, a **review lead** orchestrates the review: it reads the task, cited spec, run summary, and diff, then sends **at least three independent lens reviewers** — requirement correctness, verification/evidence, and maintainability/design by default; security, migration, performance, and others as the change warrants. Each lens returns findings and evidence only. The lead reconciles them, deduplicates, and writes the one packet; a lens reviewer never renders the status or suggested decision.

## Review packet

The packet lives in `reviews/` and follows the kit template.

Required sections:

- Summary
- Changed files
- Requirement coverage
- Change-plan coverage, when relevant
- Human attention
- Task status
- Suggested decision

## Coverage table

One row per scoped requirement:

```markdown
| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm test -- expired-session` -> `3 passed` | yes |
```

Results:

- `Pass`: evidence shows the requirement is met.
- `Fail`: evidence shows the requirement is not met.
- `Unverified`: evidence is missing or insufficient.
- `Blocked`: the requirement cannot be judged yet.

Empty evidence means `Unverified`, never `Pass`.

## Evidence

Valid evidence:

- pasted command output
- CI link with the relevant job
- named manual observation

Invalid evidence:

- `tests passed`
- the worker's summary alone
- a screenshot with no stated check
- a claim that a command was run, without output or link

## Human attention

Route anything a reviewer must inspect:

- failed, unverified, or blocked requirements
- out-of-scope edits
- changed `Do not change` paths
- risky files
- public interface changes
- migrations
- security-sensitive changes
- missing or weak test output
- candidate findings
- unresolved questions

If no trigger applies, say `None`.

## Spot-check

Spot-check at least one green row.

Record what you checked:

```markdown
Spot-checked: AC-001 - reran `npm test -- expired-session`; output matched the evidence row.
```

## Suggested decision

Use the table:

| State | Decision |
| --- | --- |
| All scoped rows Pass, exceptions routed | Merge |
| Any Fail | Do not merge |
| Any Unverified without waiver | Do not merge |
| Any Blocked | Do not merge |
| Fail or Unverified waived by owner | Merge with waiver |

Waivers name:

- who accepted it
- which rows it covers
- why
- expiry or follow-up

## Review status

Use:

- `draft`
- `pass`
- `waived`
- `blocked`
- `needs-human`

The status is about the review packet, not the PR platform state.

## App-run evidence

An agent driving the app can produce evidence: actions taken, screen state, logs, or screenshots.

It does not produce the verdict. A reviewer still judges the evidence against the requirement.

## Related

- Next: [Saving findings](09-saving-findings.md)
- Previous: [Running agents](07-running-agents.md)
