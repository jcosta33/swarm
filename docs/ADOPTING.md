# Adopting Swarm

Adopting Swarm is **copying a few folders of files next to the skills you already use** — there is no
installer to run (NO RUNTIME) and no workspace tree to create. The fastest path is to hand the steps to the
coding agent you already use; a human can run the same steps by hand.

## Quick start — let your agent do it

Paste this into your agent (Claude Code, Codex, Cursor, …), pointing it at a checkout of this repo:

> Adopt the **Swarm** framework into this repository, following `<swarm-repo>/docs/ADOPTING.md`. Specifically:
> 1. Copy Swarm's three folders next to my own skills. My skills live in **`<MY-SKILLS-DIR>`** (ask me if
>    you're unsure — it's `.claude/skills/` for Claude Code, or the neutral `.agents/skills/`):
>     - `<swarm-repo>/kernel/.agents/skills/*` → `<MY-SKILLS-DIR>/` (Swarm's `pass-*` / `persona-*` /
>       `write-*` skills land **beside** my own — the names don't collide).
>     - `<swarm-repo>/kernel/.agents/templates/` → `.agents/templates/`
>     - `<swarm-repo>/kernel/.agents/reference/` → `.agents/reference/` (the closed-set rule cards
>       `sol.md`, `proofs.md`, `ir.md` the skills name).
>    Do **not** create any other directories. Do **not** copy `passes/`, `language/`, or `conformance/` —
>    the skills carry their procedure inline and the `reference/` cards carry the shared rules; the full
>    manuals are the framework's human reference and stay in the `swarm` repo.
> 2. Put `<swarm-repo>/kernel/AGENTS.md` at my repo **root** as `AGENTS.md`, plus the `CLAUDE.md` and
>    `GEMINI.md` one-line `@AGENTS.md` aliases. **If `AGENTS.md`/`CLAUDE.md` already exist, merge — do not
>    overwrite**: append Swarm's sections by heading, keep my existing content, stop for my approval on any
>    conflict.
> 3. Fill `AGENTS.md`'s `## Commands` table and `## Project facts` from this repo's **real** test / lint /
>    build commands and conventions — propose them from `package.json`/`Makefile`/CI and ask me to confirm.
>    Put any project-specific rules (architecture boundaries, extra refusals) in `## Project facts` too —
>    there is no separate overlays file.
> 4. Report what you did per step.

That's the whole adoption: copy three folders, drop in the bootloader, fill in your commands. The only
things you must supply are the project-specific bits in step 3.

## What lands where

| From the framework | → installs to | Owner |
| --- | --- | --- |
| `kernel/.agents/skills/*` | `<MY-SKILLS-DIR>/` (e.g. `.claude/skills/` or `.agents/skills/`), **beside your own skills** | framework — re-copied on upgrade |
| `kernel/.agents/templates/` | `.agents/templates/` | framework — re-copied on upgrade |
| `kernel/.agents/reference/` | `.agents/reference/` | framework — re-copied on upgrade |
| `kernel/AGENTS.md` (+ `CLAUDE.md`/`GEMINI.md` aliases) | repo **root** | project (you fill Commands + facts) |

Nothing else is created. There is **no `.swarm/` directory, no mount, and no symlink bridge** — Swarm's
skills are ordinary skills installed where your skills live. Source artifacts you author (a spec
`*.swarm.md`, a PRD, an audit, a finding, an ADR) are normal documents: keep them wherever you keep docs;
their `type:` frontmatter identifies them. A directory like `memory/` appears the first time the `promote`
pass writes into it — never before.

## Brownfield (an existing repo)

Adoption is non-destructive. Swarm's skills have unique names (`pass-*`, `persona-*`, `write-*`) that can't
collide with your own, so they drop into your skills dir without touching anything. The only merge point is
the root `AGENTS.md`/`CLAUDE.md` (append Swarm's sections, keep yours, approve conflicts). Existing code is
`observed` until an audit + a spec govern it — adoption does not retrofit specs. See
[`model/workspace.md`](model/workspace.md) for the source-code surface policies.

## Upgrading

Re-copy Swarm's `skills/`, `templates/`, and `reference/` from a newer checkout. The skills overwrite the
`pass-*` / `persona-*` / `write-*` entries; **your own skills (different names) are untouched**, and so is
your filled `AGENTS.md`. That naming is the whole upgrade story — there is no mount to replace and no bridge
to rebuild.
