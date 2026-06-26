# Agent guides

Agent guides are optional instruction packs.

The task packet is still the contract.

## Kit guides

The starter kit includes:

| Guide | Use |
| --- | --- |
| `write-spec` | write or amend specs |
| `implement-task` | run task packets |
| `review-output` | review worker output |

## Workspace guides

Common workspace guides:

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

Install only what the workspace uses.

## Implementation depth (opt-in)

Kit skills that implement a task packet of a given kind — Corpus-coupled, summoned as the work needs them (ADR-0112):

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

## Universal catalog (corpus-skills)

Framework-free skills, installable in any repo with no Corpus knowledge ([ADR-0112](../adrs/0112-two-tier-skills.md)) — load alongside the work:

- Stances: `persona-skeptic`, `persona-challenger`, `persona-surveyor`
- Disciplines: `adversarial-review` (the review *style*), `empirical-proof`, `concise-output`, `fix-flaky-test`

One-to-one authoring stances are folded into their kit guides. Do not maintain duplicate copies.

## Guide rules

A guide:

- state when it applies
- state when it does not apply
- load only needed references
- be self-contained enough to run
- point to templates instead of copying long templates
- avoid hidden sibling dependencies

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
