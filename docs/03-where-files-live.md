# Where files live

Corpus uses three surfaces:

- **Framework repo**: the docs and decisions for Corpus itself.
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
  advanced/
  examples/
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

- **Co-located**: put the workspace inside one code repo, often under `corpus/`.
- **Dedicated**: use a separate repo for one or more code repos.

Default name for a dedicated workspace repo:

```text
<project>-works
```

Use a dedicated workspace when features span repos or when spec owners differ from code owners.

## Code repo footprint

A code repo needs little or nothing.

Allowed footprint:

- a short `AGENTS.md` pointer:

  ```text
  Corpus workspace: ../<project>-works. Read the task packet before coding.
  ```

- `.gitignore` lines for local Corpus state
- optional agent guide copies if the repo needs them

Specs, tasks, reviews, and findings belong in the workspace.

## Retention

Keep for the life of the project:

- accepted specs
- ADRs
- saved findings

Let transitory output age out once the durable record has what matters:

- review packets
- `corpus check` output
- run logs
- temporary agent scratch

Use git history or `archive/`.

A 30-90 day window matches common CI artifact retention
[[GHRETENTION]](research/sources.md#GHRETENTION) [[GLRETENTION]](research/sources.md#GLRETENTION).
Closed board rows can link to retained review packets or archived review packet paths.

## Drift rule

Code can prove a spec wrong. It does not silently update the spec.

When code and intent diverge, do one of three things:

- re-run the verification
- amend the spec
- fix the code

See [drift](reference/drift.md).
