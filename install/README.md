# Swarm — the installable files

This directory holds what an agent integrates into your repo to adopt Swarm. It is inert markdown
(**NO RUNTIME** — every artifact is a contract a future tool builds against). Hand this folder to your
coding agent and point it at [`../docs/ADOPTING.md`](../docs/ADOPTING.md); it adapts these files into your
repo under `.agents/`.

## What installs (→ your `.agents/`)

Only three folders are copied into an adopting repo:

```text
install/.agents/skills/      →  <your skills dir>   # .claude/skills/ (Claude Code) or .agents/skills/, beside your own
install/.agents/reference/   →  .agents/reference/  # the rule cards: sol.md, proofs.md, ir.md
install/.agents/templates/   →  .agents/templates/  # artifact skeletons
install/AGENTS.md            →  AGENTS.md            # your repo-root bootloader (fill Commands + project facts)
```

The agent then ensures the three **flow** folders exist (created on first write, not pre-stamped):
`.agents/specs/` (your `*.swarm.md` sources), `.agents/tasks/` (task frames — **gitignored**), and
`.agents/memory/` (durable recall). It writes the adopted version to `.agents/swarm.version`. That's the
whole install — no `.swarm/` mount, no symlink bridge, no empty workspace tree.

## What does NOT install (reference, kept here)

`install/.agents/{passes,language,conformance}` and `install/overlays/` are **not** copied into an adopter.
The skills carry their pass procedure inline and the `reference/` cards carry the shared rules, so an
adopter needs none of the full manuals or the golden corpus; project conventions go in `AGENTS.md`, not an
overlays dir. These stay here as the framework's human reference / derived twins / corpus.

## Folder contents

| Path | Installs? | What it is |
| --- | --- | --- |
| `.agents/skills/` | **yes** | Pass guides, per-kind implement & author guides, cross-cutting fragments, and the `persona-*` profile stances — lazily loaded, never always-on. |
| `.agents/reference/` | **yes** | The closed-set rule cards the skills name: `sol.md`, `proofs.md`, `ir.md`. |
| `.agents/templates/` | **yes** | Copyable skeletons — `spec.swarm.md`, `task.md`, `trace.md`, `review.md`, `finding.md`, `adr.md`, `memory/INDEX.md`, plus source-doc types (`audit.md`, `research.md`, `bug-report.md`, `prd.md`, `rfc.md`). No `verdict.md` — a `VERDICT` is a block inside `review.md`. |
| `.agents/language/`, `.agents/passes/` | no | The full SOL/APS references and the nine pass contracts — human reference; the shipped skills + cards are derived from them. |
| `.agents/conformance/` | no | The inert conformance contract (`conformance.yaml`) + golden-corpus `fixtures/` — test data for a future checker. |
| `.agents/memory/` | seed | The recall seed (`INDEX.md`, `glossary.md`) an adopter grows under `.agents/memory/`. |

## Adopting

**The full guide (with a copy-paste agent prompt) is [`../docs/ADOPTING.md`](../docs/ADOPTING.md).** In brief: hand
this folder to your agent → it places `skills/`/`reference/`/`templates/` under `.agents/`, adopts/merges
`AGENTS.md`, fills the `## Commands` table (binds each `cmd*` slot a `VERIFY BY` clause resolves through),
ensures `specs/`/`tasks/`/`memory/` exist, and appends [`.gitignore.additions`](./.gitignore.additions) to
your `.gitignore`. A repo is **Swarm-conformant** when its installed files, its `AGENTS.md`, and its flow
folders satisfy the conformance contract in [`.agents/conformance/conformance.yaml`](./.agents/conformance/conformance.yaml) —
nothing is enforced at runtime (there is none); the contract is what a future launcher honours.
