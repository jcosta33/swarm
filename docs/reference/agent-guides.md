# Agent guides

Agent guides are optional instruction packs.

The task packet is still the contract.

## Kit core

The starter kit's always-core loop guides:

| Guide | Use |
| --- | --- |
| `write-spec` | write or amend specs |
| `implement-task` | run task packets |
| `review-output` | review worker output |

## Kit authoring guides

Also kit-shipped (Suspec-coupled → the kit, [ADR-0112](../adrs/0112-two-tier-skills.md)) — install only what the workspace uses:

| Guide | Use |
| --- | --- |
| `write-audit` | present-state audit |
| `write-inventory` | brownfield inventory |
| `write-change-plan` | structural change plan |
| `write-research` | source-backed inquiry |
| `write-bug-report` | defect diagnosis |
| `write-prd` | product requirements |
| `write-rfc` | proposal |
| `spec-check` | spec review |
| `split-work` | task decomposition |
| `save-findings` | close and promotion |

## Implementation depth (opt-in)

Kit skills that implement a task packet of a given kind — Suspec-coupled, summoned as the work needs them (ADR-0112):

| Guide | Use |
| --- | --- |
| `write-feature` | net-new behavior |
| `write-fix` | a reproduced defect, root cause |
| `write-refactor` | restructure, behavior held |
| `write-rewrite` | deliberate behavior change |
| `write-migration` | API A → B, green per wave |
| `write-performance` | a measured bottleneck |
| `write-testing` | tests as the deliverable |
| `write-documentation` | human-facing docs |

## Universal catalog (suspec-skills)

Framework-free skills, installable in any repo with no Suspec knowledge ([ADR-0112](../adrs/0112-two-tier-skills.md)) — load alongside the work:

- Stances: `persona-challenger`, `persona-surveyor`
- Disciplines: `adversarial-review` (the review *style* — also carries the former `persona-skeptic` stance), `codebase-exploration`, `debugging`, `security-review`, `git-pr`, `planning-spec`, `empirical-proof`, `concise-output`, `fix-flaky-test`

One-to-one authoring stances are folded into their kit guides. Do not maintain duplicate copies.

## Guide rules

A guide:

- states when it applies
- states when it does not apply
- loads only needed references
- is self-contained enough to run
- points to templates instead of copying long templates
- avoids hidden sibling dependencies

## Progressive disclosure

Keep the main guide small.

Put detail in referenced files only when:

- not every task needs it
- the guide names when to load it
- the reference is directly linked

An unreferenced file is dead weight.

## Authoring checklist

Before adding a guide:

- name the user task it serves
- prove no existing guide owns it
- decide if it is kit, workspace, or catalog material
- give it a clear activation description
- remove duplicate rules from nearby guides

## Related

- [Review stances](review-stances.md)
- [Checks](checks.md)
- [Memory](memory.md)
