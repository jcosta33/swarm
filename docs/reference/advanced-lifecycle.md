# Advanced lifecycle

Use the basic loop by default:

```text
Pull -> Spec -> Task -> Run -> Review -> Close
```

Use the advanced lifecycle for high-risk work, large transformations, or teams that need finer gates.

## Steps

```text
author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote
```

| Step | Output |
| --- | --- |
| author | draft artifact |
| lint | defects, no edits |
| improve | same meaning, clearer artifact |
| lower | structured form or work model |
| decompose | task split |
| implement | code change |
| verify | evidence gathered |
| review | judgment and exceptions |
| promote | durable findings or amendments |

## Author

Write the artifact in its normal format.

Do not solve unclear scope by guessing. Put uncertainty in Open questions.

## Lint

Report issues from [checks](checks.md).

Do not edit during lint.

## Improve

Improve wording without changing meaning.

Allowed operations:

| Operation | Meaning |
| --- | --- |
| normalize | use canonical structure |
| atomize | split bundled requirements |
| concretize | replace vague terms |
| quantify | add threshold or units |
| bind | add verification |
| scope | state affected areas |
| clarify | move ambiguity to questions |
| deconflict | surface contradictions |
| compress | remove duplication |
| promote | move durable discovery to the right artifact |

Meaning-changing edits require amendment.

## Lower

Convert requirements into a structured work model.

Preserve:

- id
- strength
- statement
- verification
- dependencies
- read/write surfaces

Do not lower past blocking questions.

## Decompose

Split into tasks.

Rules:

- every requirement is assigned
- no requirement has two implementers
- parallel tasks have disjoint write surfaces
- dependency order is respected
- each task is independently reviewable

## Implement

Run the task.

Stay inside affected areas or report the exception.

## Verify

Run every named check.

Record:

- command
- output or link
- requirement id
- result

If a check cannot run, record `Blocked`.

## Review

Judge evidence against the current spec.

Results:

- `Pass`
- `Fail`
- `Unverified`
- `Blocked`

Lifecycle markers:

- `Waived`: Fail or Unverified accepted by owner, with reason and expiry
- `Stale`: prior Pass no longer trusted after text or evidence path changed
- `Contradicted`: evidence conflicts

## Merge gate

Merge only when every in-scope requirement is:

- `Pass`, or
- live `Waived`

An empty scope does not pass.

## Promote

Move durable discoveries to the right home:

- behavior -> spec amendment
- decision -> ADR
- lesson -> finding
- repeated lesson -> pattern
- term -> glossary

Nothing durable stays only in task scratch.

## Parallel work

Before spawning parallel workers, check:

- task scope
- write surfaces
- dependency order
- verification ownership
- merge order

If two workers need the same file, serialize.

## Related

- [Basic workflow](../02-basic-workflow.md)
- [Step bars](step-bars.md)
- [Checks](checks.md)
- [Review stances](review-stances.md)
