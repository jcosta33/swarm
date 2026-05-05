# Swarm

**Swarm is documentation-shaped conditioning for coding agents.** Nothing in this repository runs inference or ships a runtime. You get Markdown—concepts in [`docs/`](docs/README.md), copy-paste artefacts in [`scaffold/`](scaffold/README.md)—that you vendor into your own tree, edit, delete, or replace. Adoption can be incremental or complete; mixing both is fine. This is deliberately **not** a product you install and obey wholesale, and not a completeness test for whether you’re “doing agents correctly.” Use it as raw material until it stops earning its keep.

---

## What problem this tries to solve

Agents tend to fail in predictable ways:

- **Drift** — work wanders away from the real ask.
- **Ungrounded changes** — the model never saw your architecture rules or the contract for the task.
- **Hallucinated “done”** — confident summaries without evidence from your toolchain.
- **No durable trail** — the next session re-discovers the same facts because nothing was captured where it belongs.

Swarm addresses that by tying **upstream documents** to **task types**, **personas**, **skills**, and **verification gates** in a deterministic way, then folding that into **one task file** the agent is meant to read before it edits code. The aim is repeatable conditioning—not autonomous magic.

---

## What this repo is—and isn’t

| Here | Elsewhere |
| ---- | --------- |
| Prose, reference tables, ADRs (`docs/`) | The Swarm CLI, schedulers, or an installable “Swarm SDK” |
| Artefacts you paste and own (`scaffold/`) | A mandate to adopt every persona, template, or convention |
| A starting constraint language for teams | A single sanctioned stack everyone must mirror |

---

## How to consume it

### Incrementally (usual path)

Skim [`docs/`](docs/README.md), then take only what lowers your risk:

| Need | Entry |
| --- | --- |
| Shared vocabulary | [`docs/concepts/`](docs/concepts/README.md), [`docs/reference/glossary.md`](docs/reference/glossary.md) |
| Routing & attachment rules | [`docs/reference/flow-graph.md`](docs/reference/flow-graph.md) |
| One skill’s behaviour | A folder under [`scaffold/.agents/skills/`](scaffold/.agents/skills/), with [`docs/guides/writing-skills.md`](docs/guides/writing-skills.md) |
| Task / doc blanks | [`scaffold/.agents/templates/`](scaffold/.agents/templates/) |

You are not obliged to adopt worktrees, every task type, or the full persona set. Ship the smallest slice that fixes a real gap.

### Full bundle

Copy [`scaffold/`](scaffold/README.md) into your project, resolve `TODO`s in [`scaffold/AGENTS.md`](scaffold/AGENTS.md), apply [`.gitignore` hints](scaffold/.gitignore.additions). Read [`docs/guides/adopting-swarm.md`](docs/guides/adopting-swarm.md) for intent. **`/docs` is for humans; `/scaffold` is what agents and launchers reuse.**

### Rationale before paste

Concepts → guides → reference: [`docs/README.md`](docs/README.md). Design decisions live in [`docs/adrs/README.md`](docs/adrs/README.md).

---

## Repository layout

| Path | Purpose |
| ---- | ------- |
| [`docs/`](docs/README.md) | Why things exist, progressive depth |
| [`scaffold/`](scaffold/README.md) | Self-contained files meant to land in consumer repos |
| [`.agents/audits/`](.agents/audits/) | Optional internal audits—same convention as adopting projects |

---

## Where to go next

| Goal | Doc |
| ---- | --- |
| Full framing & pipeline diagram | [`docs/concepts/01-what-is-swarm.md`](docs/concepts/01-what-is-swarm.md) |
| Fast concrete install steps | [`docs/guides/quickstart.md`](docs/guides/quickstart.md) |
| What ships in the scaffold | [`scaffold/README.md`](scaffold/README.md) |
| Explicit boundaries | [`docs/NON-GOALS.md`](docs/NON-GOALS.md) |

If Swarm eliminates one recurrent failure mode or gives your team clearer words for how you condition agents, it has done enough. The rest is optional.
