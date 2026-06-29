# Where files live

Suspec uses three surfaces:

- **Framework repo**: the docs and decisions for Suspec itself.
- **Workspace repo or folder**: specs, tasks, reviews, findings, and board for a project.
- **Code repo**: the application code.

Keep durable work records in the workspace, not scattered across chat or PR comments.

## Workspace layout

```text
your-workspace/
  AGENTS.md
  specs/
    checkout/
      spec.md
      research.md
  intake/
  tasks/
  reviews/
  findings/
  inventory/
  change-plans/
  decisions/
  templates/
  status.md
```

Core homes:

- `intake/`: upstream asks captured verbatim.
- `specs/<feature>/`: intended behavior and related support docs.
- `tasks/`: one bounded work packet per task.
- `reviews/`: review packets kept while they are active records.
- `findings/`: durable lessons saved at Close.
- `inventory/`: present-state maps for brownfield work.
- `change-plans/`: wave plans for structural work.
- `decisions/`: project ADRs.
- `status.md`: hand-edited board and index.

## Co-located or dedicated

Both layouts are valid.

- **Co-located**: put the workspace inside one code repo, often under `suspec/`.
- **Dedicated**: use a separate repo for one or more code repos.

Default name for a dedicated workspace repo:

```text
<project>-works
```

Use a dedicated workspace when features span repos or when spec owners differ from code owners.

In dedicated mode, keep the implementer single-root. See [ADOPTING](ADOPTING.md#spec-external-single-root-implementer).

## Code repo footprint

A code repo needs little or nothing.

Allowed footprint:

- a short `AGENTS.md` pointer:

  ```text
  Suspec workspace: ../<project>-works. Read the task packet before coding.
  ```

- `.gitignore` lines for local Suspec state
- optional agent guide copies if the repo needs them

Specs, tasks, reviews, and findings belong in the workspace.

## Retention

Keep for the life of the project:

- accepted specs
- ADRs
- saved findings

Let transitory output age out once the durable record has what matters:

- closed task packets
- review packets
- `suspec check` output
- run logs
- temporary agent scratch

Use git history or `archive/`.

A 30-90 day window matches common CI artifact retention
[[GHRETENTION]](research/sources.md#GHRETENTION) [[GLRETENTION]](research/sources.md#GLRETENTION).
A task or review packet is live while open, kept for reference once closed, then moved to `archive/` or left to git history; the closed board row keeps the link. Promote a closed task's durable lesson to its home before the scratch ages out.

## Drift rule

Code can prove a spec wrong. It does not silently update the spec.

When code and intent diverge, do one of three things:

- re-run the verification
- amend the spec
- fix the code

See [drift](reference/drift.md).

## Related

- Next: [Writing specs](04-writing-specs.md)
- Previous: [The basic workflow](02-basic-workflow.md)
