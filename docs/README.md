# 🐝 Swarm — Agentic Documentation Framework

> **Swarm is a documentation framework that conditions coding agents for the work they do.** Pick a source document, and the task type, persona, skills, and verification gates all follow — deterministically.

This directory is the canonical home of the framework. Everything you need to understand, adopt, extend, or audit Swarm lives here.

---

## ⚡ The 30-second pitch

Coding agents fail in predictable ways: they drift from intent, conflict with the existing architecture, hallucinate completion, and leave no resumable trail.

Swarm addresses these failures with a **single mechanism**: the conditioning pipeline.

```mermaid
flowchart LR
    A[📄 Source<br/>document] --> B[🎯 Task<br/>type]
    B --> C[🧠 Persona]
    C --> D[🛠️ Skills +<br/>verification]
    D --> E[📋 Conditioned<br/>task file]
    E --> F[💻 Agent<br/>session]
    style A fill:#e0f2fe,stroke:#0369a1
    style B fill:#fef3c7,stroke:#a16207
    style C fill:#fce7f3,stroke:#be185d
    style D fill:#dcfce7,stroke:#15803d
    style E fill:#ede9fe,stroke:#6d28d9
    style F fill:#f1f5f9,stroke:#334155
```

A human (or upstream agent) hands a source document to the framework. Swarm routes it deterministically: a `spec.md` becomes a `feature` task assigned to **The Builder**; an `audit.md` becomes a `refactor` task assigned to **The Janitor**; a `bug-report.md` becomes a `fix` task assigned to **The Skeptic**. Skills attach automatically. Verification commands are bound to named slots. The agent reads one file (the conditioned task file), adopts the named persona, executes the task, and pastes empirical proof into a hard-gated `## Self-review`.

The framework itself is just disciplined Markdown — no runtime, no DSL, no executable. A CLI (e.g., the **Swarm CLI**) implements the framework. **This repository is the framework.**

---

## 🗺️ Repo map

```
docs/
├── README.md                  ← you are here
├── PRINCIPLES.md              ← load-bearing design constraints
├── NON-GOALS.md               ← what Swarm explicitly is not
│
├── concepts/                  ← the WHY — the framework's ideas
├── personas/                  ← the 13 mindsets, one file each
├── tasks/                     ← the 18 task types, one file each
├── documents/                 ← the 4 core doc types + extended variants
├── skills/                    ← the framework's shipped skills
├── reference/                 ← the lookup tables (compatibility matrix, flow graph, placeholders, glossary)
├── guides/                    ← the HOW — task-shaped instruction
├── examples/                  ← worked walkthroughs in prose
└── adrs/                      ← Architecture Decision Records
```

Every directory has its own `README.md` that catalogues what's inside.

---

## 🚀 Where to start

Reading order depends on who you are and why you're here:

| You are…                                     | Read this first                                                                           |
| -------------------------------------------- | ----------------------------------------------------------------------------------------- |
| 👀 Casually evaluating Swarm                 | [`concepts/01-what-is-swarm.md`](concepts/01-what-is-swarm.md) — 5 minutes                |
| 🛠️ Adopting Swarm in a real project          | [`guides/quickstart.md`](guides/quickstart.md) → [`guides/adopting-swarm.md`](guides/adopting-swarm.md) |
| 🧠 Trying to understand the mechanism        | [`concepts/02-conditioning-pipeline.md`](concepts/02-conditioning-pipeline.md)            |
| 🎭 Looking for the right persona             | [`personas/README.md`](personas/README.md) → the matrix                                    |
| 📋 Looking for the right task type           | [`tasks/README.md`](tasks/README.md) → the matrix                                          |
| 🧰 Building a tool that consumes Swarm       | [`reference/template-placeholders.md`](reference/template-placeholders.md)                |
| 🤝 Contributing or extending the framework   | [`guides/extending-the-framework.md`](guides/extending-the-framework.md) → [`adrs/`](adrs/) |
| 🔬 Comparing to Spec Kit / BMAD / Superpowers | [`concepts/12-prior-art.md`](concepts/12-prior-art.md)                                    |

---

## 🧭 The framework at a glance

| Dimension          | Cardinality | Where                                                       |
| ------------------ | ----------- | ----------------------------------------------------------- |
| 🎭 Personas        | 13          | [`personas/`](personas/)                                    |
| 📋 Task types      | 18          | [`tasks/`](tasks/)                                          |
| 📄 Core doc types  | 4           | [`documents/`](documents/) (+ extended variants)            |
| 🛠️ Cross-cutting skills | 6      | [`skills/`](skills/) (`manage-task`, `documentation-gatekeeper`, `personas`, `distillation-discipline`, `empirical-proof`, `adversarial-review`) |
| ✍️ Authoring skills | 8         | [`skills/`](skills/) (`write-spec`, `write-audit`, `write-research`, `write-bug-report`, `write-feature`, `write-fix`, `write-refactor`, `write-rewrite`) |

---

## 🪞 Is this for you?

**Swarm fits when:**

- ✅ Multiple agents (or one agent across many sessions) are doing real engineering work in your repo
- ✅ You've been bitten by drift, hallucinated completion, or context pollution
- ✅ You want determinism: the same source doc always routes to the same persona, every time
- ✅ Your stack is heterogeneous and you don't want a framework that bakes in `pnpm` or `cargo` or `pip`
- ✅ You like Diátaxis / Spec Kit / Superpowers but want something more rigorous on the documentation side

**Swarm is not for you (yet) if:**

- ❌ You're looking for a runtime, an agent CLI, or an inference engine — Swarm conditions agents; it doesn't run them
- ❌ You want a one-click setup with a pretty TUI — that's a CLI concern, separate from the framework
- ❌ Your project has zero structure and you want the framework to invent it for you — Swarm assumes you already write things down; it organises and amplifies that
- ❌ You want roleplay personas with names like "Mary the Analyst" — Swarm's personas are mindsets, not characters

See [`NON-GOALS.md`](NON-GOALS.md) for the full list of what Swarm explicitly is not.

---

## 📐 Status and stability

| Surface                                  | Status     |
| ---------------------------------------- | ---------- |
| Persona catalogue (13 personas)          | 🟢 Stable  |
| Task type catalogue (18 task types)      | 🟢 Stable  |
| Core doc types (4)                       | 🟢 Stable  |
| Flow graph (document → task → persona)   | 🟢 Stable  |
| Template placeholder contract            | 🟢 Stable  |
| Cross-cutting skill set                  | 🟡 Evolving — see [`skills/README.md`](skills/README.md) |
| Subagent strategy                        | 🟡 Evolving — see [`concepts/10-subagent-strategy.md`](concepts/10-subagent-strategy.md) |
| Project-level overlays (constitution, ADR) | 🟠 Recommended, not required |

The framework is versioned (semver). Major version bumps are reserved for scaffold-breaking changes. See [`adrs/0015-versioning-scheme.md`](adrs/0015-versioning-scheme.md).

---

## 🔗 Related repositories

- **Swarm CLI** — implements this framework: scaffolds task files, manages worktrees, runs verification gates. The CLI lives in a separate repo. Swarm-the-framework is consumable by *any* tool that honours the [placeholder contract](reference/template-placeholders.md).
- **AGENTS.md** — the open standard Swarm builds on for repo entry points. See [`reference/agents-md.md`](reference/agents-md.md).

---

## 📜 Provenance

This documentation is consolidated from a series of design specs, persona catalogues, task templates, and field research conducted between late 2025 and mid-2026. See [`concepts/12-prior-art.md`](concepts/12-prior-art.md) for the bibliography and competitive landscape, and [`adrs/`](adrs/) for the design decisions and the alternatives that were considered and rejected.

---

> **A note on voice.** Swarm's docs are direct, opinionated, and unhedged. When something is forbidden, it says forbidden. When something is a tradeoff, it shows the tradeoff. When the field is divided, the docs pick a position and explain why. If you find a hedge that doesn't earn its place, that's a bug.
