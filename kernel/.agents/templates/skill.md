---
name: <skill-slug>
description: <One directive sentence stating WHAT this skill enforces, in the imperative.> ALWAYS apply this skill when <the concrete triggers — files touched, task type, document being produced>. Do not <the failure mode the skill exists to prevent — paraphrasing, skipping a gate, blending concerns>. Skip this skill for <the cases where it does not apply, so the model does not over-load it>.
---

# Skill: <skill-slug>

## Purpose

What this skill protects against. Why it exists. What failure mode it prevents. One or two paragraphs — name the specific drift, hallucination, or shortcut the rules below structurally block.

## Project context (the AGENTS.md contract)

(Include only if the skill runs project commands.) Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`, and any extended entry the skill needs. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before proceeding — do not guess or invent a command.

## Core rules

Numbered. Directive. No hedging. Each rule is a `### N.` heading so a checklist can reference it by number.

### 1. <rule>

<The rule stated as an imperative, with the one-sentence reason it holds.>

### 2. <rule>

<…>

### 3. <rule>

<…>

## What does not belong

Negative space — what to put elsewhere instead, and why. Keeps the skill self-contained: persistent facts go to AGENTS.md, per-task scaffolding goes to the task template, contracts go to the source doc.

- (belongs in `AGENTS.md` instead, because it is a persistent project fact)
- (belongs in the task template instead, because it is per-task scaffolding)
- (belongs in a spec / audit instead, because it is a contract, not a discipline)

## Anti-patterns

Concrete failure modes with corrections. Each line is a real shortcut an agent takes and the response that closes it.

- ❌ <pattern> → <correction>
- ❌ <pattern> → <correction>

## Bundled resources

(Include only if the skill folder ships a `references/` subdirectory. The body stays under one screen; depth lives here and is pulled up on demand.)

- `references/task-template.md` — the conditioned task file this skill scaffolds.
- `references/<other>.md` — <what it holds and when to pull it up>.

---

> **Notes for skill authors (delete before shipping):**
> - The `description` is the most load-bearing line — it decides *when* the skill loads. Write it for the model as a directive trigger (WHAT · ALWAYS apply when · Do not · Skip for), not as a human-facing content summary.
> - Keep the skill **self-contained**: no cross-skill "See also" links and no framework-internal paths (`.agents/…`, `docs/…`) in the body. The agent loads this skill on its own description; it should not have to chase references to be useful.
> - Skills can be flat files (`<name>/SKILL.md`) or folders (`<name>/SKILL.md` plus `references/`, `scripts/`, `examples/`). Folder form is preferred once the skill grows beyond one screen — keep the body short and push depth into `references/`.
> - Project-specific skills live under `.agents/skills/domain/` and self-activate the same way when their `description` matches.
> - The pattern is *codify the rule once you've explained it twice*. For the authoring rationale — scope, description-writing, the self-containment rule — see the Swarm framework's skill-authoring docs.
