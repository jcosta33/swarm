# ADR 0015: Semantic-ish versioning for the framework scaffold

## Status

Accepted

## Context

Consumers copy `/scaffold` into repos. Undocumented breakage in templates/skills forks hundreds of workspaces silently.

## Decision

Treat **breaking changes** to template section names, mandatory skills, persona blocks, or flow-graph edges as semver-major for the framework package narrative. Minor adds optional sections/skills; patch fixes wording without behavioural change.

`MIGRATION.md` at repo root (when present) records upgrade notes between framework milestones.

## Consequences

- Positive: teams can judge upgrade risk when refreshing scaffolds.
- Negative: burdens maintainers with compatibility thinking — proportional to adoption.
