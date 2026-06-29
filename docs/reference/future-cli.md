# The `suspec` CLI

`suspec-cli` is optional. The markdown workflow does not require it.

The CLI prepares files, launches configured agents, and reconciles evidence.
It does not write code and does not decide whether code is correct.

Use the [suspec-cli README](https://github.com/jcosta33/suspec-cli#commands) for exact flags and shipped commands.

## Boundary

| CLI owns | Agent or team owns |
| --- | --- |
| scaffolding | coding loop |
| intake snapshots | model reasoning |
| checks | edits |
| task packets | provider credentials |
| worktrees | tool-calling runtime |
| launch envelope | correctness |
| review draft | merge decision |

## Shipped surface

The command set includes:

- `init`
- `update`
- `check`
- `new`
- `worktree`
- `status`
- `review`
- `pull`
- `promote`
- `run --agent`
- `show`
- `agents emit --codex`

`suspec-mcp` exposes CLI data over MCP. It shells out to the CLI `--json` contract.

## Non-goals

The CLI does not provide:

- `suspec close` that mutates the board
- code generation
- spec compilation
- automatic task decomposition
- architecture enforcement
- agent runtime
- model configuration
- verdicts

## Deferred or measured-out

Deferred:

- `suspec inventory new`
- per-adapter hook generation
- run-record `commands[]`
- strict SOL parser
- per-task cost attribution

Measured-out:

- hard oversized-packet threshold. Diff size is reported as neutral review information.

## Command contracts

### `suspec init`

Creates a workspace from the starter kit.

Writes `AGENTS.md`, templates, guides, flow folders, examples, and `status.md`.

### `suspec pull <ticket>`

Captures an external ticket into `intake/`.

It does not write a spec.

### `suspec new spec <slug> [--from <intake>]`

Creates `specs/<slug>/spec.md` from the template.

The user fills requirements.

### `suspec check [file]`

Reads specs or workspace files and reports diagnostics.

Exit codes:

- `0`: clean
- `1`: warnings
- `2`: hard errors

It reports facts. It does not issue a merge verdict.

### `suspec new task --from <SPEC-id | CHANGE-id> [--scope AC-...]`

Creates a task packet from declared scope.

It does not invent requirements.

### `suspec worktree <create|list|remove|prune>`

Creates and tracks task worktrees.

One task gets one branch or worktree.

### `suspec run <task> --agent <name>`

Launches a configured agent in the task worktree.

Records the launch envelope. The agent does the work.

### `suspec review <task> [--agent <name>]`

Drafts a review packet from the task, diff, spec, and change plan.

It routes mismatches and exceptions to human attention. It does not decide the result.

### `suspec status`

Prints a derived board from workspace files.

Committed `status.md` stays hand-edited.

## Local state

If the CLI is used inside a code repo, it may create a gitignored directory:

```text
.suspec/
  config.yaml
  work/
  cache/
  tmp/
```

Rules:

- never commit `.suspec/`
- deleting it loses no durable record
- specs, reviews, and findings stay in the workspace

## Adapter shape

```yaml
agents:
  codex:
    command: codex
    working_directory: task_worktree
    startup_instruction: "Read AGENTS.md, then read the task file you were given."
```

Adapters launch existing tools. They do not carry credentials or model settings.

## Run record

Reserved machine shape:

```json
{
  "task_id": "...",
  "changed_files": [],
  "commands": [],
  "out_of_scope": [],
  "findings": [],
  "provenance": {}
}
```

This is reconciliation input. Markdown remains the durable artifact.

## Source policies

| Policy | Meaning |
| --- | --- |
| `generated` | emitted from a named source artifact |
| `governed` | implementation under a spec requirement |
| `observed` | existing code with no spec yet |
| `external` | third-party code |
| `deprecated` | migration or removal only |

`observed` is the brownfield default. Code is not silently treated as governed.

## Related

- [Checks](checks.md)
- [Structured requirements](structured-requirements.md)
- [Advanced lifecycle](advanced-lifecycle.md)
- [Memory](memory.md)
