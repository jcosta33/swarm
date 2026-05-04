# 🧭 Principles

> The load-bearing design constraints. When contributors disagree, these are the tiebreakers. They are written so they actually decide cases.

There are ten principles, in priority order. Higher principles win when two collide.

---

## 1. 📐 Documentation-first, not tooling-first

Swarm is documentation. The framework's value is in what it asks people to write down: source documents, task files, personas, skills. Tooling — a CLI, a TUI, a launcher — is downstream. The framework must be installable, readable, and usable by hand. If a tool is needed to make sense of the framework, the framework has failed.

> **Tiebreaker.** When deciding whether a feature lives in the framework or in a CLI: does it require code execution? If yes, it's CLI. If it's a contract, a vocabulary, or a written-down rule, it's framework.

---

## 2. 🌍 Language- and runtime-agnostic at the framework level

Every framework-level artefact is free of project-specific content. No TypeScript, no `pnpm`, no `cargo`, no React, no Python. Where a placeholder is needed, the framework uses the [`{{cmdX}}` syntax](reference/template-placeholders.md). Where examples are useful, they are clearly marked "example only — your project's conventions vary."

> **Tiebreaker.** When tempted to use a concrete command in a template: would a Rust shop, a Python shop, and a TypeScript shop all be able to copy the template verbatim? If not, replace the literal with a placeholder.

---

## 3. ⬇️ Distillation flows downhill only

Information moves from broad/external (research) to narrow/actionable (task) to terminal output (code, docs). Reverse flow — back-filling specs from finished code, narrating decisions retroactively — is forbidden.

```
research → spec/audit/bug-report → task → code/docs
```

When a task discovers something durable, the agent halts, *promotes* the finding upstream (to an audit, spec, or research file), and only then resumes. The chain stays acyclic.

> **Tiebreaker.** When a workflow tempts you to write a spec from finished code: stop. The right artefact is documentation, not a spec. See [ADR 0003](adrs/0003-distillation-is-unidirectional.md).

---

## 4. 🎯 Personas are 1-to-1 with task types

Each task type has exactly one default primary persona. The mapping is deterministic. The agent does not choose; the framework chooses. Secondary personas exist only for handoff (e.g., the Skeptic reviews after a Builder task).

> **Tiebreaker.** When proposing a many-to-many mapping: the determinism is the value. Adopters get the auto-conditioning benefit only if the routing is unambiguous. Override at the project level (via `swarm.config` or equivalent), not at the framework level. See [ADR 0002](adrs/0002-personas-1-to-1-with-task-types.md).

---

## 5. 🧪 Empirical proof is non-negotiable across all personas

Every persona's `## Self-review` is a hard gate. Every claim is backed by pasted command output. Paraphrase is not proof. "Tests passed" is not proof; the last two lines of the test runner is proof. This applies regardless of persona — Builders, Skeptics, Researchers, and Architects all paste output.

> **Tiebreaker.** When a persona resists pasting output ("the test passed; trust me"): the framework's response is to refuse. The cost of pasting two lines is trivial. The cost of trusting an unverified claim compounds. See [`concepts/09-empirical-proof.md`](concepts/09-empirical-proof.md).

---

## 6. 🪶 The task is the source of truth; source documents ground it

The task file is primary. It carries the persona, the skills, the verification gates, the constraints, the plan, the progress, the findings, and the self-review. Source documents (specs, audits, research, bug-reports) feed *into* the task file via `## Linked docs` — they ground it but do not replace it.

> **Tiebreaker.** When a task file reads like a thin wrapper around a spec ("see linked spec for everything"): rewrite the task file. The task is what an agent reads first; if the substance is elsewhere, the agent has to chase it down. Restate the load-bearing requirements in the task file.

---

## 7. 🧠 Skills are progressively disclosed; AGENTS.md only carries universal invariants

`AGENTS.md` is the entry point. It is short. It contains only what every agent in the repo must know: where the task file lives, the standing convention to load `manage-task` and `documentation-gatekeeper`, and the repo's named verification gate bindings. Skills carry the deep knowledge and load on demand based on their `description` field.

> **Tiebreaker.** When tempted to put a domain rule in `AGENTS.md`: write a skill instead. AGENTS.md grows linearly with what's universal; skills grow linearly with what's specialised. Conflating them rots both.

---

## 8. 🔒 Task files are gitignored; durable findings migrate

Task files are worktree-local execution scaffolding. They are not committed. Anything durable — an architectural insight, a bug discovered during a feature, a research result — is *promoted* to an audit, spec, or research file before the session closes.

> **Tiebreaker.** When a finding feels significant: don't leave it in the task file. The task file will be deleted with the worktree. Migrate it. See [ADR 0004](adrs/0004-task-files-are-gitignored.md).

---

## 9. 🗣️ The framework's voice is direct, opinionated, and unhedged

Plain declarative statements. No "you might want to consider…" hedge words unless genuinely uncertain. Specific over general; cite the file or section when making a claim. Lead with the load-bearing finding, then explain. The voice is the framework's UX as much as the structure is.

> **Tiebreaker.** When a sentence reads like consultantware ("teams may wish to evaluate whether…"): rewrite it. The framework is opinionated by design. Hedging dilutes the signal.

---

## 10. 🔁 The catalogue grows, but slowly and with evidence

New personas, new task types, new doc types are framework-level changes. They require evidence ("agents do this all the time across many repos"), an ADR ("considered and rejected: folding into existing X for these reasons"), and a migration path ([`MIGRATIONS.md`](../MIGRATIONS.md)). Bespoke project needs are handled by **overlays** (project-level personas, project-specific task types) — not by inflating the framework.

> **Tiebreaker.** When proposing a new persona: can you collapse it into an existing one with a different mindset switch? If yes, do that. The bar for catalogue growth is high because the determinism (Principle 4) depends on the catalogue being small enough to memorise.

---

## How to use these principles

1. **In an ADR.** Cite the principle that motivates the decision. The ADR shows the work; the principle anchors it.
2. **In a code review.** When reviewing a docs PR, ask "which principle does this serve, and which one (if any) does it conflict with?"
3. **In a contributor disagreement.** Higher principles win. If you can't agree on which principle applies, that's a meta-question — surface it and write an ADR before merging.
4. **As a skim test.** A doc that violates a principle without explanation is a candidate for revision. The principles are not aspirational; they are operational.

See also: [`NON-GOALS.md`](NON-GOALS.md) — the negative space.
