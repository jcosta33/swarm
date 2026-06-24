# What is Corpus?

Corpus is a markdown workflow for agent-assisted code changes.

It gives you:

- specs with acceptance criteria
- task packets for agents or people
- review packets with evidence per requirement
- findings for lessons worth keeping
- a workspace layout for those files

It does not replace your agent, issue tracker, PRs, CI, or docs site.

## Why use it

Agent output is easy to generate and hard to review. Corpus puts a small record between each step:

| Problem | Corpus record |
| --- | --- |
| Vague ticket | `intake/` snapshot plus a spec |
| Repeated prompt context | workspace files the agent can read |
| Scope drift | task packet with scope and `Do not change` |
| Large PR | review packet with coverage and exceptions |
| Lost lesson | finding saved at Close |

## The loop

```text
Pull -> Spec -> Task -> Run -> Review -> Close
```

Two steps are conditional:

- **Inventory**: map existing code before brownfield work.
- **Change Plan**: plan migrations, rewrites, schema changes, or high-risk refactors.

See [the basic workflow](02-basic-workflow.md).

## What the files do

- **Intake** captures the upstream ask without interpretation.
- **Spec** states intended behavior, non-goals, open questions, and `Verify with:` lines.
- **Task** gives one bounded unit of work to an agent or person.
- **Run summary** records changed files, commands run, output, blocked questions, and findings.
- **Review** records requirement results and what needs human attention.
- **Finding** saves durable knowledge for future work.
- **Status board** shows the current state and links closed work to review packets.

## Tooling

The markdown workflow works without tooling.

`corpus-cli` is optional. It scaffolds, checks, launches, and reconciles files.
It does not write code or decide whether work is correct.

See [the CLI reference](reference/future-cli.md).

## Start here

1. Read [the basic workflow](02-basic-workflow.md).
2. Check [where files live](03-where-files-live.md).
3. Walk [the tutorial](tutorial/README.md).
