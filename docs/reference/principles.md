# Principles

These rules resolve conflicts in the docs and templates.

## 1. No runtime in this repo

This repo is markdown and documentation.

Tool behavior described here is a contract for optional tooling, not proof that this repo runs it.

Use precise wording:

- good: `corpus check can report...`
- bad: `Corpus enforces...`

## 2. Conventions are not enforcement

Every rule has an honesty level:

- convention
- checklist
- toolable
- enforced

This docs repo enforces nothing.

Teams can enforce rules in CI or hooks. That is the team's gate.

## 3. Code can falsify intent, not amend it

Specs and decisions state intent.

Code and tests show reality.

When they disagree:

- re-run evidence
- amend the spec
- fix the code

Do not let changed code silently redefine the requirement.

## 4. Evidence beats shape

A valid-looking file is not evidence.

A `Pass` needs:

- pasted output
- CI link
- named manual observation

Empty evidence means `Unverified`.

## 5. Provider neutral

Corpus artifacts are plain markdown.

They must work with any agent or human who can read files.

Do not make one provider's behavior a framework requirement.

## 6. Claims need sources

Load-bearing empirical claims cite `docs/research/sources.md`.

If a claim has no source, label it as design rationale or remove it.

Rejected sources are not cited.

## Related

- [Source authority](source-authority.md)
- [Drift](drift.md)
- [Checks](checks.md)
- [ADRs](../adrs/README.md)
