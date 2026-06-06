---
type: adr
id: 0049-minimal-install-no-mount-no-imposed-workspace
status: accepted
created: 2026-06-06
updated: 2026-06-06
supersedes: 0045-overlays-are-project-owned, 0048-installed-payload-is-the-runtime-surface
superseded_by:
---

# ADR-0049: Minimal install — files in place, no mount, no imposed workspace

## Context

A pragmatic skeptic review of the adopted-project scaffold (grounded in what the shipped skills actually
reference) found most of the structure was ceremony a **no-runtime** framework cannot justify:

- **Empty filing cabinet.** Adoption pre-created ~32 `.gitkeep` directories (`sources/{10}`, `status/{4}`,
  `generated/{5}`, `memory/{2}`, `ledger/{3}`, `overlays/`, `archive/`, `tmp/`). Four of the eight
  top-level dirs (`status/`, `overlays/`, `archive/`, `tmp/`) are referenced by **zero** shipped skills or
  templates; the rest only by passing prose mentions. They are a filesystem for a runtime that does not
  exist — and Swarm's first invariant is that it ships **no runtime**.
- **The "kernel" mount + symlink bridge.** Skills were copied into a framework-owned `.swarm/kernel/skills/`
  and then surfaced into the agent's scan dir (`.claude/skills/`) by symlink. This was the source of **two**
  adoption bugs in a single session (a dir-symlink collision that hid the project's own skills, then a
  stranded skill). The structure manufactured the bugs.
- **"kernel" is empty jargon.** An OS kernel is a privileged runtime core; here the term named a folder of
  markdown. It borrowed authority it had not earned and appeared ~500× across the docs.

The skills are already self-contained ([0047](./0047-skills-are-self-contained.md)) and the shared rules
ship as compact reference cards ([0048](./0048-installed-payload-is-the-runtime-surface.md)'s Update). With
that, nothing requires a separate mount, a bridge, or a pre-built workspace tree.

## Decision

1. **Install is "copy files next to your skills."** Swarm ships three folders — `skills/`, `templates/`,
   `reference/`. An adopter copies them under `.agents/` (or, for a CLI that scans a fixed skills dir like
   Claude Code's `.claude/skills/`, puts the skills there directly). **No `.swarm/kernel/` mount, no symlink
   bridge.** Swarm's skills are ordinary skills, installed where skills live, beside the project's own.
2. **Upgrade is "re-copy the named files."** Swarm's skills carry recognizable names (`pass-*`, `persona-*`,
   `write-*`) that cannot collide with a project's own; an upgrade re-copies those, leaving the project's
   skills untouched. Replacement safety is a **naming** property, not a separate-mount property.
3. **No imposed workspace.** Adoption creates **no** directory tree. A source artifact (`*.swarm.md`, PRD,
   audit, finding, ADR…) is a normal document kept wherever the project keeps docs, classified by its
   `type:` frontmatter — Swarm reads the frontmatter, not a mandated path. A directory (`memory/`,
   and — for a future toolchain — `status/`/`generated/`/`ledger/`) is created **the first time something
   writes into it**, never stamped empty at install.
4. **Project conventions live in `AGENTS.md`.** Architecture boundaries, extra refusals, and command
   bindings are project facts; they go in the bootloader an agent already reads first. There is no overlays
   directory (this is what supersedes [0045](./0045-overlays-are-project-owned.md)).
5. **"kernel" is retired as an adopter-facing concept.** No adopted project has a kernel. (The producer
   repo's source-of-payload directory is currently still named `kernel/`; renaming that physical directory
   is a separate mechanical follow-up and does not block this decision.)

This **supersedes [0048](./0048-installed-payload-is-the-runtime-surface.md)** (the payload no longer mounts
at `.swarm/kernel/`; it installs in place) and **[0045](./0045-overlays-are-project-owned.md)** (no overlays
dir). It **refines [0040](./0040-kernel-payload-directory.md)** (the adopter-side mount it defined is gone;
the producer-side payload directory survives, rename pending) and **[0044](./0044-kernel-is-derived-and-self-contained.md)**
(`docs/` stays canonical and the derived files are still eyeball-diffed — they simply install in place
rather than into a mount).

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| Keep the `.swarm/kernel/` mount + bridge | It exists only for wholesale replacement on upgrade, which unique skill names already give for free — and it caused two adoption bugs. Pure cost. |
| Keep the pre-built workspace tree (lazy-create only the dead dirs) | Pre-creating *any* empty dir asserts a runtime that isn't there; the honest line is "create on first write." Half-measures keep the filing-cabinet smell. |
| Delete the reconciliation model entirely (status/generated/ledger as concepts) | That is design, not noise — the intent/reality/observed split and the surface policies are Swarm's value. The fix is to stop *materialising* them at install, not to remove them. They remain documented contracts a tool fulfils. |
| Rename the producer `kernel/` dir in this ADR | Out of scope here — a ~90-reference mechanical rename; tracked as a follow-up so this decision isn't blocked on it. |

## Consequences

- **Positive:** adoption is "copy three folders into your skills dir." No empty tree, no mount, no bridge,
  no new jargon. The two classes of bridge bug become impossible. The adopter's repo gains only the files it
  will actually use.
- **Negative:** the elaborate `docs/model/workspace.md` filesystem model is replaced by a slim one, and the
  ADRs/docs that referenced `.swarm/kernel/`, the workspace tree, or overlays must be swept. Done as part of
  this change.
- **Neutral:** the obligation model, all closed sets, the SOL grammar, the pass pipeline, and the
  reconciliation *design* (desired/reality/observed, surface policies) are unchanged — only where files
  physically land changes.

## Status

Accepted (v0.1). `docs/model/workspace.md` and `docs/ADOPTING.md` are rewritten to the minimal model; the
bootloader template names the in-place install. Secondary doc sweep (artifact home paths, `library/overlays.md`,
`conformance.md`, README, PRINCIPLES) and the producer-dir rename follow as tracked steps.

## Affected obligations / constraints

- Supersedes: [0045](./0045-overlays-are-project-owned.md), [0048](./0048-installed-payload-is-the-runtime-surface.md).
- Refines: [0040](./0040-kernel-payload-directory.md), [0044](./0044-kernel-is-derived-and-self-contained.md).
- Depends on: [0047](./0047-skills-are-self-contained.md) (self-contained skills make the in-place install safe).
- Does NOT change: the obligation grammar, any closed set, or the intent/reality/observed reconciliation design.
