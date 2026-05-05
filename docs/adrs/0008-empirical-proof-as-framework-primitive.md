# ADR 0008: Empirical proof as a framework primitive

## Status

Accepted

## Context

Models complete the "successful task" pattern with confident summaries. Without structural proof gates, hallucinated greens pass review.

## Decision

Every code-changing task archetype mandates **verbatim** command output (or bounded equivalent) in `## Self-review` / verification sections. Paraphrase is invalid. Skeptic reviewers **re-run** checks locally.

Encoded in **`empirical-proof`** skill plus task templates (`/scaffold/.agents/templates/`).

## Consequences

- Positive: removes a whole class of false completions.
- Negative: slower closes; brittle in broken dev envs → must surface explicit `## Blockers`.
