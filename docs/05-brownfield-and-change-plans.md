# Brownfield work and change plans

Use extra structure only when the work needs it.

The expanded loop:

```text
Pull -> Inventory -> Spec -> Change Plan -> Task -> Run -> Review -> Close
```

## Inventory

Inventory maps current code. It does not prescribe changes.

Use it when:

- ownership is unclear
- behavior is undocumented
- tests are missing or misleading
- changes cross modules or repos
- the task touches risky code

Include:

- relevant files and modules
- observed behavior
- public interfaces
- existing tests
- unknowns
- risks

Every structural claim needs a file or line reference.

## Change Plan

A change plan explains how to change code without losing behavior.

Use it for:

- migrations
- rewrites
- schema changes
- broad refactors
- dependency upgrades
- performance work with staged rollout

Include:

- baseline state
- target state
- preservation guarantees
- waves
- verification per wave
- cutover and rollback notes

## Preservation guarantees

A preservation guarantee says what must not change.

Prefer existing requirement ids:

```yaml
preserves:
  - SPEC-checkout#AC-001
```

Use `PG-NNN` only for plan-local guarantees. If a `PG-NNN` becomes permanent behavior, amend the spec.

## Waves

Each wave must leave the codebase usable and verifiable.

Good waves:

- have a small write surface
- name commands to run
- avoid mixing refactor and behavior change
- make rollback understandable

## Review level

Review effort follows risk, not labels like greenfield or brownfield.

Increase review depth when work has:

- high diffusion across files or modules
- high churn areas
- security, data, payment, or public API impact
- migrations or destructive operations
- weak or missing tests

## When not to use this

Do not write inventory or a change plan for a small, local feature with clear code and clear tests. Use the normal loop.
