# Drift

Drift is a mismatch between intent and evidence.

It happens when a requirement, code path, or verify command changes after a prior `Pass`.

## Drift triggers

Old evidence becomes stale when:

- requirement text changes
- non-goals change
- `Verify with:` changes
- exercised code changes
- the command target changes
- the evidence path no longer exists

## Result

Use `Stale` for a prior `Pass` that needs re-checking.

Do not keep the old `Pass` silently.

## Resolution

Pick one:

- re-run the verification
- amend the requirement
- fix the code

Do not let code redefine intent without an amendment.

## Evidence path

The evidence path is what the check actually exercised.

Examples:

- test file
- integration route
- API contract
- migration script
- browser path

If later work edits that path, review the old evidence for staleness.

## Scope

Only declared drift needs action.

Do not reopen unrelated old work unless the current change touches its evidence path or requirement.

## Related

- [Source authority](source-authority.md)
- [Reviewing output](../08-reviewing-output.md)
- [Artifact formats](artifact-formats.md)
