# Source authority

Source authority decides which written intent governs when artifacts conflict.

Tools may flag conflicts. People resolve them.

## Minimum model

Use these rules first:

- Specs state intended behavior.
- Code can falsify a spec, not silently amend it.
- Review rows judge against current spec text and evidence.
- Changed requirements or changed exercised code make old evidence stale.
- Findings inform future work but are not requirements until promoted into a spec.

## Artifact rank

| Rank | Artifact |
| --- | --- |
| 1 | accepted ADR |
| 2 | approved spec |
| 3 | accepted finding |
| 4 | reviewed audit |
| 5 | reviewed research |
| 6 | task notes |
| 7 | chat |

Drafts rank one step below their accepted tier.

## Domain rank

| Rank | Domain |
| --- | --- |
| 1 | enforced policy |
| 2 | compliance |
| 3 | security |
| 4 | architecture |
| 5 | product |
| 6 | team |
| 7 | task scoping |
| 8 | memory |

## Conflict rule

1. If either statement is enforced-policy, compliance, or security, higher domain wins.
2. Otherwise, higher artifact rank wins.
3. If artifact rank ties, higher domain rank wins.
4. If both ranks tie, resolve by amendment.

The losing statement is not deleted. Reconcile it.

## Approval

These edits need the governing owner:

- add, remove, or renumber a requirement
- change actor, trigger, strength, outcome, or non-goal
- change a public interface
- resolve a blocking open question
- add, remove, or repoint `Verify with:`
- accept manual evidence where automated evidence was expected
- approve, supersede, or amend an ADR
- promote a finding into a spec requirement

Meaning-preserving cleanup does not need the same approval.

## High-oversight work

Use named human review for:

- critical-risk work
- destructive operations
- migrations
- shared databases
- public interfaces
- security-sensitive changes

Waivers in this band need a named human, reason, affected rows, and expiry.

## Related

- [Drift](drift.md)
- [Distillation](distillation.md)
- [Checks](checks.md)
- [Reviewing output](../08-reviewing-output.md)
