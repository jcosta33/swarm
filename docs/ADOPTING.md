# Adopting Swarm

*Works today — plain markdown plus your agent; no Swarm tooling required.*

Swarm is files, not software. Adoption is copying a handful of templates and filling
in one bootloader. Three paths, in order of preference.

## 1. Manual adoption (five minutes)

In the repo that will hold your specs and reviews — a dedicated workspace repo, or
your project repo for a co-located setup ([where files live](03-where-files-live.md)):

1. Copy the templates: `cp -r starter-kit/templates <your-workspace>/templates`
   (8 files: spec, task, review, finding, status, intake, inventory, change-plan).
2. Copy the three agent guides into the directory your agent CLI scans for skills
   (`.claude/skills/` for Claude Code; for other CLIs see the per-tool table in
   [integrations](10-integrations.md) — keeping them as plain docs works everywhere):

   ```sh
   cp -r starter-kit/agent/write-spec starter-kit/agent/implement-task \
         starter-kit/agent/review-output .claude/skills/
   ```

3. Put the bootloader at your repo **root** — `AGENTS.md` and its two symlinks move
   together:

   ```sh
   cp starter-kit/agent/AGENTS.md . && ln -sf AGENTS.md CLAUDE.md && ln -sf AGENTS.md GEMINI.md
   ```

   Fill the `{{placeholders}}` — in a dedicated workspace repo the Commands table
   names the commands of the code repos this workspace governs (or stays as
   placeholders until it does); the `For code repos:` line is the pointer you copy
   *out* to each code repo's own `AGENTS.md`, then remove here.
4. Copy `starter-kit/decisions/` → `decisions/`.
5. Create `specs/`, `intake/`, `tasks/`, `reviews/`, `findings/`, and a `status.md`
   from the template (replace its example rows). Write one spec for your next
   non-trivial change.

Optional, when you need them: copy pieces of `starter-kit/advanced/` (audit,
research, bug, ADR, RFC, PRD templates, plus guides for the audit, research,
bug, RFC, and PRD work). The advanced audit
template is the recommended first taste for brownfield teams.

## 2. Agent-assisted adoption

Hand your coding agent this prompt:

> Adopt the Swarm framework into this repository. Read
> `https://github.com/jcosta33/swarm` — specifically `docs/ADOPTING.md` and
> `starter-kit/README.md` — then perform the manual-adoption steps above for me:
> copy the templates and agent guides, place `AGENTS.md` at the repo root with
> `CLAUDE.md`/`GEMINI.md` symlinks, fill its Commands table from my real
> test/lint/build setup (read package.json/Makefile/CI and confirm with me),
> create the workspace folders, and append the gitignore additions. This is
> additive — do not delete or overwrite my files; stop and ask on any conflict.

## 3. Future CLI adoption

`swarm init` will do the above mechanically. It does not exist yet — the contract
is [reference/future-cli.md](reference/future-cli.md).

## Code repos

A code repo that implements against your specs needs **nothing**. At most:

- a one-line pointer in its `AGENTS.md`: _"Swarm workspace: `<path-or-url>` — read
  the task packet you are given before coding"_;
- the `implement-task` guide copied into its skills directory;
- the `.gitignore.additions` lines appended to its `.gitignore` (they cover agent
  scratch and future CLI state — the *workspace* commits its artifacts and needs none of it).

The agent works from the task packet; the PR links the workspace review packet.
Specs, reviews, and findings never live in the code repo (convention — nothing
enforces it; that's the point of keeping the workspace authoritative).

## Upgrading

Re-copy `starter-kit/templates/` and `starter-kit/agent/` from a newer checkout.
Your specs, tasks, reviews, findings, decisions, and `AGENTS.md` are yours — the
kit never touches them.
