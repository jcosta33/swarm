# 🛠️ Skills

> The framework's shipped skills. Two categories: **cross-cutting** (always or near-always loaded) and **authoring** (per doc type / per task type). Project-specific skills live in `.agents/skills/domain/` in the consumer repo.

> 📦 **The pages in this directory are *documentation about* the skills — what they do, why they exist, what failure modes they prevent.**
>
> The actual skill files (the ones the agent loads at runtime) live in [`/scaffold/.agents/skills/`](../../scaffold/.agents/skills/). Copy from there into your project; everything in the scaffold is self-contained (its cross-references stay valid after copying).

---

## ⚡ TL;DR

A skill is a Markdown file with YAML frontmatter that the agent loads on demand based on its `description`. The format matches Anthropic's Skills format and OpenAI Codex's Agent Skills, so a skill written for Swarm works in any compatible agent CLI.

---

## 🧭 The catalogue

### 🌐 Cross-cutting framework skills

Loaded by default (or near-default) for every task. They encode the framework-level disciplines.

| Skill                                                              | Loaded                                | Purpose                                                                          |
| ------------------------------------------------------------------ | ------------------------------------- | -------------------------------------------------------------------------------- |
| [`manage-task`](manage-task.md)                                    | always                                | Task-file authoring/maintenance, lifecycle hooks, promotion protocol             |
| [`documentation-gatekeeper`](documentation-gatekeeper.md)          | always                                | Enforces the flow graph; refuses forbidden flows                                 |
| [`personas`](personas.md)                                          | always (when persona blockquote present) | Loads the persona profile and adopts the mindset                              |
| [`distillation-discipline`](distillation-discipline.md)            | when distilling between doc tiers     | The Distillation Loss Statement protocol                                         |
| [`empirical-proof`](empirical-proof.md)                            | code-producing tasks; review tasks    | Show, Don't Tell — paste verbatim verification output                           |
| [`adversarial-review`](adversarial-review.md)                      | review, audit-writing, bug-report-writing, fix | The six adversarial questions; cross-module caller search           |

### ✍️ Authoring skills

One skill per authoring task type. Each codifies the failure modes the corresponding doc type is built to prevent.

| Skill                                              | Pairs with task                          | Doc produced     |
| -------------------------------------------------- | ---------------------------------------- | ---------------- |
| [`write-spec`](write-spec.md)                      | `spec-writing`                           | spec             |
| [`write-audit`](write-audit.md)                    | `audit-writing`, `deepen-audit`          | audit            |
| [`write-research`](write-research.md)              | `research-writing`                       | research         |
| [`write-bug-report`](write-bug-report.md)          | `bug-report-writing`                     | bug-report       |
| [`write-feature`](write-feature.md)                | `feature`, `integration`                 | (code, no doc — just the discipline) |
| [`write-fix`](write-fix.md)                        | `fix`                                    | (code patch + regression test)       |
| [`write-refactor`](write-refactor.md)              | `refactor`, `migration`, `upgrade`       | (refactored code, behaviour preserved) |
| [`write-rewrite`](write-rewrite.md)                | `rewrite`                                | (new implementation, behaviour delta enforced) |

---

## 📐 The skill format

Every skill is a Markdown file with YAML frontmatter. The format is identical to Anthropic Skills / OpenAI Codex Agent Skills.

```markdown
---
name: <skill-slug>
description: One or two sentences for the model. Tells the agent WHEN to load this skill.
---

# Skill: <Display name>

## Purpose

What this skill protects against. Why it exists.

## Core rules

Numbered. No hedging.

1.
2.

## What does not belong

Negative space — what to put elsewhere instead.

## Anti-patterns

Concrete failure modes with corrections.

## Examples (optional)

Worked examples illustrating the rules in action.
```

Key conventions:

- **`description` is for the model.** It answers the model's question: *"Should I load this now?"* Phrase it as a trigger, not a summary. Bad: "this skill is about empirical proof". Good: "Load when you've made a verifiable claim and need to back it with command output."
- **Skills can be folders.** `.agents/skills/<name>/SKILL.md` plus `references/`, `scripts/`, `examples/` subdirectories enable progressive disclosure within a skill.
- **Skills load on demand.** The `description` triggers loading; the body of the skill is read only when triggered.

---

## 🛠️ Project-specific skills

Projects add their own skills under `.agents/skills/domain/`. Common candidates:

| Project skill                | Triggers when…                              |
| ---------------------------- | ------------------------------------------- |
| `architecture-violations`    | Editing core layers (presentation, db, etc.) |
| `testing-file-layout`        | Adding tests; need to know where they go    |
| `state-management`           | Touching state or persistence layers        |
| `api-versioning`             | Modifying public API contracts              |
| `audio-engine` / `react-state` / `<your domain>` | Domain-specific patterns         |

These accumulate over time as the team encounters areas where agents repeatedly violate constraints. The pattern is *codify the rule once you've explained it twice*.

---

## 🚦 Skill loading conventions

The framework's standing convention is two skills always load:

1. `manage-task` — the lifecycle / promotion / next-steps discipline
2. `documentation-gatekeeper` — refuses forbidden flows

These two are loaded by every conditioned task file in its `## Required skills` section.

The persona's skill (`personas` itself, plus the named persona profile) loads when the task file's `> **PERSONA:**` blockquote names a persona — which it always does in framework-conformant task files.

The other skills load based on the task type's auto-attach table (see [`reference/flow-graph.md`](../reference/flow-graph.md)) and based on description-matching to project-specific skills.

---

## 📜 The session-start hook

Skills don't apply themselves; the agent has to be told to load them. The framework recommends a session-start instruction (in AGENTS.md or via the agent CLI's hook mechanism) that says:

> First action: read your task file at `.agents/tasks/<slug>.md`. Load `manage-task` and `documentation-gatekeeper`. Adopt the persona named in the task file. Then proceed.

This is what makes the discipline operational rather than aspirational. See [`reference/agents-md.md`](../reference/agents-md.md) for the recommended language.

---

## See also

- [`concepts/04-personas.md`](../concepts/04-personas.md) — how personas use skills
- [`concepts/06-task-types.md`](../concepts/06-task-types.md) — which skills attach to which tasks
- [`concepts/12-prior-art.md`](../concepts/12-prior-art.md) — the Anthropic/Codex skills format origin
- [`reference/flow-graph.md`](../reference/flow-graph.md) — skill attachment by task type
- [`guides/writing-skills.md`](../guides/writing-skills.md) — how to write project-specific skills
- [`reference/agents-md.md`](../reference/agents-md.md) — session-start hook
