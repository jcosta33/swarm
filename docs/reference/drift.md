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

## Amending a living spec

A spec is a living organism: amend the original rather than write a new one (ADR-0108).

- **Review on touch.** When a change touches a spec's evidence path, amend the spec in the same
  change — the moment its code moves is the moment to fix its intent. Amendment is change-triggered;
  there is no scheduled spec audit.
- **Amend vs supersede.** Amend an AC's text in place as the feature evolves (it keeps its id); mark
  an AC superseded in place when it is retired; mint a new spec (and set the old one's
  `superseded_by`) only when a whole feature is replaced.
- **Status.** A spec moves `ready → active` once it is in use and being amended; `superseded` only on
  whole-feature replacement.

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
