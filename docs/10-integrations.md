# Integrations

Suspec uses markdown. Any tool that can read files can use it.

## Agents

Give the agent:

- `AGENTS.md`
- the task packet
- the repo checkout or worktree

Common setup:

| Tool | Integration |
| --- | --- |
| Claude Code | reads `AGENTS.md`; optional `CLAUDE.md` symlink |
| Codex | reads `AGENTS.md` and task files |
| Cursor | read task packet in chat or attach file |
| GitHub Copilot | paste or link the task packet |
| Aider / other CLIs | point the command at the task file |

The task packet is the contract. The agent UI is replaceable.

## Issue trackers

Keep the tracker as the backlog.

Use Suspec for the work record:

1. Capture the ticket in `intake/`.
2. Write or amend a spec.
3. Link PR and review packet back to the tracker.

Optional `suspec pull` can create intake snapshots. Manual copy-paste is valid.

## PRs and CI

Keep PRs and CI.

Use the review packet to connect CI output to requirements:

- PR shows the diff.
- CI runs commands.
- Review packet records which requirement each result supports.

`suspec-cli` emits **gate facts + an exit code** (a clean reconcile vs. open items); the team wires CI
to block on that exit code if it wants a hard gate. The gate is the team's — Suspec reports, it never
owns merge authority.

## Code repos

Code repos stay clean.

At most, add:

- `AGENTS.md` pointer to the workspace
- `.gitignore` entries for local Suspec state
- optional local agent guides

Specs and reviews stay in the workspace.

## CLI and MCP

`suspec-cli` can scaffold and reconcile files.

`suspec-mcp` can expose Suspec data to MCP-capable agents.

Both prepare or report state. They do not implement code or issue verdicts.

## Boundaries

Suspec does not own:

- model settings
- provider credentials
- editor UI
- issue tracker state
- CI configuration
- merge authority

## Related

- Previous: [Saving findings](09-saving-findings.md)
- Start over: [What is Suspec?](01-what-is-suspec.md)
