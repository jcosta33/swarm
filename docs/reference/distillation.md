# Distillation

Distillation moves information into a smaller artifact.

Do not change its meaning while compressing it.

## Preserve

Always preserve:

- requirement id
- strength word
- actor
- trigger
- behavior
- `Verify with:` binding
- non-goals
- open questions
- scope limits
- source references

## Do not promote by accident

An observation does not become a requirement because it was copied into a spec.

Examples:

- audit observation -> context, unless rewritten as a requirement
- research finding -> evidence, not a decision
- bug report -> diagnosis, not implementation scope
- task note -> scratch, unless saved as a finding or spec amendment

## Loss budget

Loss is allowed only when it is visible.

Record:

- what was dropped
- why it was dropped
- where to find the source

Use **Dropped from sources** in specs when a source ask is intentionally excluded.

## Safe compression

Safe:

- remove repetition
- replace prose with table rows
- shorten examples without changing behavior
- link to source instead of restating it

Unsafe:

- remove verification
- weaken `must` to `should`
- merge two behaviors into one requirement
- hide an open question
- omit non-goals
- change owner or source

## Related

- [Writing specs](../04-writing-specs.md)
- [Source authority](source-authority.md)
- [Artifact formats](artifact-formats.md)
