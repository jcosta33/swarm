# Swarm

**Swarm is documentation-shaped conditioning for coding agents.** It does not run models or ship a runtime in this repo. It gives you Markdown you can copy, adapt, or ignore—the same philosophical lane as **[shadcn/ui](https://ui.shadcn.com/)**: *you bring the codebase; we bring patterns you paste in and own.* Think of Swarm as a **buffet**, not a monolithic framework you “install” and obey end-to-end.

---

## What problem this tries to solve

Agents fail in repeatable ways:

- **Drift** — work wanders away from the real ask.
- **Ungrounded changes** — the model never saw your architecture rules or the contract for the task.
- **Hallucinated “done”** — confident summaries without evidence from your toolchain.
- **No durable trail** — the next session re-discovers the same facts because nothing was captured where it belongs.

Swarm attacks that root cause by making **upstream documents** route to **task types**, **personas**, **skills**, and **verification gates** deterministically—then encoding all of that in a **single task file** the agent reads before it touches code. The goal is predictable conditioning, not magic autonomy.

---

## What this is / is not

| This repo **is** | This repo **is not** |
| ---------------- | --------------------- |
| Prose (`/docs`), copy-paste artefacts (`/scaffold`), and ADRs | The Swarm CLI, a daemon, or a package you `npm install` as “Swarm” |
| A starting point you fork mentally and literally | A certification that “you’re doing agents right” if you copy everything |
| A buffet: take the flow graph only, take skills only, or take the whole tray | The one true agent stack; teams differ—**pick what earns its keep** |

If something here does not fit your stack, leave it on the buffet. Mixed adoption is intentional.

---

## How to consume it

### Buffet (recommended default)

Browse [`docs/`](docs/README.md), then pull **only** what reduces your failure modes:

- **Just the vocabulary** → [`docs/concepts/`](docs/concepts/README.md) and [`docs/reference/glossary.md`](docs/reference/glossary.md)
- **Just routing discipline** → [`docs/reference/flow-graph.md`](docs/reference/flow-graph.md)
- **Just skills format + one behaviour** → a single folder under [`scaffold/.agents/skills/`](scaffold/.agents/skills/), plus [`docs/guides/writing-skills.md`](docs/guides/writing-skills.md)
- **Just templates** → [`scaffold/.agents/templates/`](scaffold/.agents/templates/)

You are not obligated to adopt personas, worktrees, or every task type. **Partial adoption beats zero adoption framed as “we’ll migrate later”.**

### Wholesale (single drop)

Copy the [`scaffold/`](scaffold/README.md) tree into your project, fill `TODO`s in [`scaffold/AGENTS.md`](scaffold/AGENTS.md), merge [`.gitignore` hints](scaffold/.gitignore.additions). Then skim [`docs/guides/adopting-swarm.md`](docs/guides/adopting-swarm.md) for intent. **Reasoning stays in `/docs`; literal files you paste live in `/scaffold`.**

### Understand before you cargo-cult

- **Why these ideas exist:** [`docs/README.md`](docs/README.md) → concepts → guides  
- **Decisions recorded as ADRs:** [`docs/adrs/README.md`](docs/adrs/README.md)

---

## Repository map

| Path | Role |
| ---- | ---- |
| [`docs/`](docs/README.md) | *Why & what* — progressive disclosure for humans |
| [`scaffold/`](scaffold/README.md) | *What you paste* — self-contained artefacts for agents (skills, templates, process snippets) |
| [`.agents/audits/`](.agents/audits/) | Optional dogfood — this repo occasionally audits itself here |

---

## The shadcn analogy (one sentence)

Like shadcn, Swarm favors **explicit, editable artefacts in your repo** over an opaque upstream runtime: copy, customize, delete what you dislike—**your tree, your rules**, with conventions that stayed portable enough to steal.

---

## Next clicks

| I want to… | Go to |
| ---------- | ----- |
| Read the full pitch & mechanism | [`docs/concepts/01-what-is-swarm.md`](docs/concepts/01-what-is-swarm.md) |
| Install in a project fast | [`docs/guides/quickstart.md`](docs/guides/quickstart.md) |
| Copy files into a repo | [`scaffold/README.md`](scaffold/README.md) |
| See what Swarm refuses to be | [`docs/NON-GOALS.md`](docs/NON-GOALS.md) |

---

**Swarm is a starting point.** If it saves you one class of agent failure or gives you language to discuss conditioning with your team, it did its job. Everything else is optional.
