# Workspace Model

> Where an adopted project keeps Swarm's files and its own source artifacts. Swarm imposes **no runtime
> and no filing cabinet**: it ships skills, templates, and reference cards you copy in, plus the SOL
> language. Nothing else is created until something actually writes it.

This page describes the **adopted project** (the product). It is distinct from the framework-dev repo
(the producer: `docs/`, `examples/`, `evals/`, and the installable files). The two MUST NOT be conflated.

## No runtime, no imposed workspace (Invariant 1)

Swarm ships inert markdown — skills, templates, reference cards, and the language. There is no process it
runs and no directory tree it must create. Every "the X pass writes Y" below is a **contract a human or a
future toolchain fulfils**, never something Swarm executes. A directory therefore appears the first time
someone (or a tool) writes into it — it is **never pre-stamped empty at install**. A scaffold of empty
folders would be a filing cabinet for a clerk who does not exist yet.

## Install: files in your agent dir

Swarm installs by **copying three folders** next to the skills you already use — there is no separate
home and no symlink bridge:

```text
.agents/
  skills/      # Swarm's pass / persona / author skills, alongside your own (names don't collide)
  templates/   # starting points for specs, audits, …
  reference/   # the closed-set rule cards (sol.md, proofs.md, ir.md)
```

If your agent CLI scans a specific skills directory (Claude Code scans `.claude/skills/`), put the skills
**there** instead — they sit beside your own as ordinary entries. Swarm's skills are just skills, installed
where skills live. An upgrade re-copies the `pass-*` / `persona-*` / `write-*` files; your own skills
(different names) are untouched. That naming is the whole upgrade story — no mount to replace wholesale,
nothing to bridge.

## Where source artifacts go

A spec (`*.swarm.md`), PRD, RFC, audit, finding, ADR, or interface is a normal document — keep it wherever
your project already keeps docs. Its `type:` frontmatter says what it is; Swarm reads the **frontmatter**,
not a mandated path. Swarm does not dictate a `sources/` tree.

## Durable memory (the `promote` target)

The `promote` pass lifts durable findings and patterns out of throwaway task state into a memory file, so a
later session **recalls** them instead of re-deriving them. Externalising state to disk rather than holding
it in a context window is what makes multi-session work tractable [[CTXENG]](../research/sources.md#CTXENG),
and writing intermediate steps down rather than holding them implicitly is itself what makes multi-step
work succeed [[SCRATCHPAD]](../research/sources.md#SCRATCHPAD) — a written self-reflection between attempts,
not extra model capability, is what lets an agent improve [[REFLEXION]](../research/sources.md#REFLEXION),
and persisting task state with explicit dependencies mirrors a pattern validated at vendor
scale [[CCTASKS]](../research/sources.md#CCTASKS). That memory file is created the **first time** `promote`
writes one (conventional path `.agents/memory/`); it is not pre-stubbed.

## Project conventions

Project-specific rules — architecture boundaries, extra refusals, local command bindings — go in your
`AGENTS.md`, the file that already carries standing project facts and the `Commands` table. There is no
separate overlays directory; a convention is a fact about the project, and project facts live in the
bootloader an agent already reads first.

## Intent, reality, and the reconciliation between them (the design contract)

Swarm's value is keeping three things distinct and reconciled. This is **design** — realised by hand today,
by a future toolchain later — **not** a set of directories you create up front:

- **Desired truth** — what the project intends: the spec / source artifact. Primary for *intent*.
- **Implementation reality** — the code. **Invariant 4: code is reality**, reconciled implementation, not a
  build product of the spec.
- **Observed satisfaction + drift** — whether the code satisfies the intent, recorded by trace / review /
  verdicts. It records reality against intent and **never redefines** intent.

A toolchain that tracks satisfaction, emits task / trace / review packets, or keeps a compacted history MAY
write them under conventional paths (e.g. `status/`, `generated/`, `ledger/`) — **each created on first
write**, and gitignored when recreatable from the source. The kernel fixes the *shape* of those records
(the obligation graph, the verdict model, the coverage a history entry must preserve), not a directory you
must materialise to adopt. Recreatable execution state (task frames, scratch) is throwaway; the durable
record is the source artifact, the memory, and whatever compacted history a tool keeps.

## Source-code surface policies

The reconciliation has a per-path projection over the codebase. A code region declares **exactly one**
policy from a closed set of five — recording which side of the intent-versus-reality reconciliation it sits
on (this follows from Invariant 4):

| Policy | Meaning | Manual edits |
| --- | --- | --- |
| `generated` | Emitted from a **named source artifact** (an OpenAPI doc, a schema, an interface spec) — the artifact is the truth, the file is its emission. | **Forbidden** — edit the source and regenerate; a hand-edit is overwritten and is a finding. |
| `governed` | Reconciled implementation under an obligation: a spec owns intent, the code owns realization, trace/review reconcile them. | **Allowed only with an obligation trace** — every change carries an obligation id and emits a trace. |
| `observed` | Existing code not yet governed — pre-existing reality with no obligation behind it. | Allowed, but the surface needs an audit + a spec before it becomes `governed`. |
| `external` | Vendor / third-party code you do not own. | **Do not modify** — changes belong upstream or in an owned wrapper. |
| `deprecated` | Scheduled for removal or migration; retained until cutover. | Discouraged; permitted edits SHOULD be migration/removal steps, not new behavior. |

`observed` is the **honest default** for brownfield adoption: real code no obligation yet claims. It is the
on-ramp — an audit plus a spec promote `observed` → `governed`; it is never silently treated as already
governed. The set **rejects** the doctrine that code is disposable or "regenerated from specs": only a
surface explicitly marked `generated` is emitted from a source, and even then only from a named artifact.
The surface map is a contract a future tool reads (a `surfaces:` map of `path → {policy, source}` in your
Swarm config); computing and enforcing it is a future-tool concern, the **map shape is the contract today**.

## The CLI / agent boundary

Swarm coordinates agent-CLI workers and **prepares and validates** work; it does **not** own the model loop,
the file-editing mechanics, or the provider/MCP runtime, and it MUST NOT replace an agent CLI. The future
launcher is a contract a toolchain builds against — it would scaffold task frames, bind `VERIFY BY` adapters
through `AGENTS.md > Commands`, serialize write surfaces, and reconcile history — consistent with the
orchestrator-worker, single-threaded-writes boundary. Every "runs" verb resolves to that contract
(Invariant 1); nothing here makes Swarm an agent runtime.

## Monorepo: nested `AGENTS.md` (closest-wins)

In a multi-package repo more than one `AGENTS.md` may coexist: the repo-root file carries shared bindings
and conventions; a per-workspace file (e.g. `packages/api/AGENTS.md`) adds to or overrides them. An agent
reads the **closest** `AGENTS.md` up the tree — nearest wins, root as fallback; a workspace with no file
inherits the root. Only the `## Commands` bindings and standing facts differ per workspace; the installed
skills are shared. This is purely a bootloader-resolution rule; it changes nothing about the obligation model.

## Related

- [Source artifacts](source-artifacts.md) — the durable source-artifact types and what each carries.
- [Source authority](source-authority.md) — how intent governs implementation reality.
- [Compiler pipeline](compiler-pipeline.md) — the passes that produce traces, reviews, verdicts, and memory.
- [Adopting Swarm](../ADOPTING.md) — the install steps.
