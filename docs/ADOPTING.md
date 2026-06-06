# Adopting Swarm

Adopting Swarm is **handing your coding agent the `install/` folder and asking it to integrate Swarm into
your repo**. There is no installer to run (NO RUNTIME) — just files an agent places intelligently, adapting
to how your repo is already laid out. A human can do the same by hand, but the agent is the intended path.

## Quick start — hand it to your agent

Point your agent (Claude Code, Codex, Cursor, …) at a checkout of this repo and say:

> Adopt **Swarm** into this repository. Read `<swarm-repo>/install/` (its `README.md` and the files under
> `install/.agents/`) and integrate it here, following `<swarm-repo>/docs/ADOPTING.md`:
> - **Install files** (`install/.agents/skills/`, `reference/`, `templates/`) → place them under the agent
>   directory this repo already uses. Skills go in whatever folder my agent CLI scans (`.claude/skills/`
>   for Claude Code, else `.agents/skills/`), **beside my own skills** — their `pass-*`/`persona-*`/`write-*`
>   names won't collide. `reference/` and `templates/` go under `.agents/`.
> - **Bootloader** (`install/AGENTS.md`) → my repo root as `AGENTS.md` (+ `CLAUDE.md`/`GEMINI.md` one-line
>   `@AGENTS.md` aliases). If those files exist, **merge** — append Swarm's sections by heading, keep mine,
>   and stop for my approval on any conflict.
> - **Fill it in** — populate the `## Commands` table from my real test/lint/build commands (read
>   `package.json`/`Makefile`/CI and confirm with me) and put my project conventions in `## Project facts`.
> - **Flow folders** — ensure `.agents/specs/`, `.agents/tasks/`, and `.agents/memory/` exist (create only
>   when first written), add `/.agents/tasks/` to `.gitignore`, and write the Swarm version to
>   `.agents/swarm.version`.
> - **Adapt, don't impose** — if I already keep specs or docs somewhere, use that; reuse my existing
>   `.agents/` subfolders rather than duplicating them. Report what you placed and what you merged.

The agent does the judgement work — slotting Swarm into your conventions instead of forcing a fixed tree.

## The target layout (goldilocks — a few folders, all earned)

Everything lives under `.agents/`, the cross-tool agent directory your repo likely already has. Swarm
prescribes **six** folders, each one exercised by the flow — no empty filing cabinet:

```text
.agents/
  skills/        # install — Swarm's skills, beside your own
  reference/     # install — the rule cards (sol.md, proofs.md, ir.md) the skills name
  templates/     # install — artifact skeletons
  specs/         # your *.swarm.md sources (the `author` pass writes here)
  tasks/         # task frames — gitignored (recreatable execution state)
  memory/        # durable recall the `promote` pass writes (INDEX.md + findings)
  swarm.version  # the adopted Swarm version
AGENTS.md        # repo root — the bootloader; fill its Commands + project facts
```

The three **install** folders are re-copied on upgrade; the three **flow** folders are yours and grow as
you work. Other source artifacts (PRDs, RFCs, audits, findings, ADRs) are normal `type:`-tagged documents —
keep them under `.agents/` however you like; only `specs/`, `tasks/`, and `memory/` are fixed, because the
flow keys off them. Nothing tied to a future toolchain (drift `status/`, `generated/` packets, a `ledger/`)
is created up front — those appear only if and when a tool writes them.

## Brownfield (an existing repo)

Adoption is non-destructive. Swarm's skills have unique names (`pass-*`, `persona-*`, `write-*`) that can't
collide with yours, so they drop into your skills dir without touching anything. The only merge point is the
root `AGENTS.md`/`CLAUDE.md` (append Swarm's sections, keep yours, approve conflicts). Existing code is
`observed` until an audit + a spec govern it — adoption does not retrofit specs. See
[`model/workspace.md`](model/workspace.md) for the source-code surface policies.

## Upgrading

Re-copy Swarm's `skills/`, `templates/`, and `reference/` from a newer `install/`. The skills overwrite the
`pass-*`/`persona-*`/`write-*` entries; **your own skills (different names), your `specs/`/`tasks/`/`memory/`,
and your filled `AGENTS.md` are untouched**. That naming is the whole upgrade story — no mount to replace,
no bridge to rebuild.
