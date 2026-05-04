# 📒 Guide: Writing skills

> How to author a project-specific skill. The frontmatter contract; the description-triggers-loading rule; format; examples of good and bad descriptions; when to write a skill vs add to AGENTS.md vs add to `docs/`.

---

## ⚡ TL;DR

A skill is a Markdown file with YAML frontmatter. The `description` triggers loading. Skills are for *deep, on-demand domain knowledge* the agent shouldn't carry by default. AGENTS.md is for *universal invariants* the agent always needs.

---

## 🪜 When to write a skill

Write a skill when:

- A *recurring constraint* trips agents up across sessions
- The constraint is *deep enough* that capturing it inline (in AGENTS.md or in a task file) would bloat
- The constraint is *narrow enough* that loading it on-demand (when the agent's work touches the relevant area) is preferable to loading it always

**Don't write a skill when:**

- The rule is universal — put it in `AGENTS.md`
- The rule is task-specific — put it in the task template
- The rule is one-off — put it in the task file's `## Constraints`
- The rule is human-facing documentation — put it in `docs/`

The pattern is *codify the rule once you've explained it twice*.

---

## 📐 The skill format

Skills are Markdown files with YAML frontmatter, matching the open Anthropic Skills / OpenAI Codex Agent Skills format.

```markdown
---
name: <skill-slug>
description: <one or two sentences telling the model WHEN to load this skill>
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

### File location

| Form          | Path                                             | When to use                                 |
| ------------- | ------------------------------------------------ | ------------------------------------------- |
| Flat file     | `.agents/skills/<name>.md`                       | Short skills (one screen)                   |
| Folder form   | `.agents/skills/<name>/SKILL.md`                 | Skills with references / scripts / examples |

For folder form, optional subdirectories:

```
.agents/skills/<name>/
├── SKILL.md             # the entry; same format as flat
├── references/          # detailed reference material the skill cites
├── scripts/             # helper scripts the skill mentions (e.g., for verification)
└── examples/            # worked examples
```

The agent reads `SKILL.md` first; subdirectories are read on demand.

---

## 🎯 Writing the `description` field

The `description` is the most load-bearing line of the skill. It tells the model *when to load*.

Write it for the model, not for humans:

- ✅ "Load when modifying core layers (`src/db/`, `src/presentation/`) to enforce strict boundary layers and prevent circular dependencies."
- ❌ "This skill is about architectural rules in our codebase."

The good version answers the model's question: *"Should I load this now?"* The bad version is a content summary.

### Description anti-patterns

| ❌ Description                                                    | Why it fails                                              |
| ---------------------------------------------------------------- | --------------------------------------------------------- |
| "About: testing"                                                 | No trigger; the model can't tell when to load             |
| "This skill helps with React components."                        | Too vague — what *kind* of work? When?                   |
| "Use this for everything related to auth."                       | "Everything" is too broad; the skill loads constantly    |
| "A guide to writing good code."                                  | Aspirational, not operational                             |
| "Mandatory."                                                     | Should be in AGENTS.md, not a per-load skill             |

### Description good patterns

| ✅ Description                                                                    | Why it works                                          |
| -------------------------------------------------------------------------------- | ----------------------------------------------------- |
| "Load when modifying files in `src/db/` or `src/api/middleware/`. Enforces our connection-pool isolation and idempotent-key contract." | Specific trigger (paths) + specific guarantee. |
| "Load when adding tests for React components in this monorepo. Documents our testing-library setup, custom matchers, and the wrapping pattern."  | Specific work + specific content.                  |
| "Load when authoring a spec that mentions caching. Documents the project's cache-coherency invariants and the standard cache-key format." | Trigger by topic; guarantee by content.            |

---

## 🪞 Skill vs AGENTS.md vs docs/

| Content                                                          | Lives in                       |
| ---------------------------------------------------------------- | ------------------------------ |
| Universal invariant (every agent needs to know)                  | `AGENTS.md`                    |
| Domain-specific rule (loads on relevant work)                    | `.agents/skills/domain/<name>.md` or `<name>/SKILL.md` |
| Task-type-specific rule (per task type)                          | The task template              |
| One-off task constraint (this task only)                         | The task file's `## Constraints` |
| Human-facing reference / explanation                             | `docs/`                        |
| Architectural decision rationale                                 | `.agents/adrs/<NNNN>-<slug>.md` |
| Project-wide invariants (security, layering, version pins)       | `.agents/constitution.md`     |

If a rule could live in two places, pick the *narrower* — narrower means the agent loads it only when relevant.

---

## 🛠️ Worked example: `architecture-violations`

A project has a strict layering rule: presentation logic must not import database connection logic directly; everything flows through `src/services/`.

```markdown
---
name: architecture-violations
description: Load when modifying files in `src/presentation/`, `src/api/`, or `src/db/`. Enforces our strict boundary layers — presentation must not import db directly; everything flows through `src/services/`. Includes a checklist for AST-aware modification (replace whole functions, not mid-function code).
---

# Skill: Architecture Violations and Boundary Enforcement

## Purpose

Prevent the silent introduction of architectural debt and layer violations. Our codebase has
strict boundaries between presentation, services, and persistence; violations cascade into
hard-to-untangle coupling.

## Core rules

1. **Layer isolation.** Presentation logic (`src/presentation/`, `src/api/`) MUST NOT import
   from `src/db/` directly. All database access flows through `src/services/`.

2. **AST-aware modification.** When replacing logic, replace the entire AST node (whole function
   or class). Do not inject mid-function code that destroys local context.

3. **Treat ADRs as factual groundings.** Read `.agents/adrs/0007-layered-architecture.md` before
   touching boundary code; the constraints are immutable unless an ADR supersedes.

4. **Run `pnpm run validate:deps` after every change.** This is `dependency-cruiser` configured
   to enforce the layering. A violation is a halt; do not silence by editing the config.

## What does not belong

- General architecture discussion (that's `docs/architecture.md`)
- The full ADR set (those live in `.agents/adrs/`)
- One-off violation justifications (those go in the spec / audit / ADR that introduces the exception)

## Anti-patterns

- "Shallow vertical slices": changing five different architectural concerns across multiple
  layers in one pass just to make a unit test turn green.
- Importing `src/db/` from `src/presentation/` "temporarily" while waiting for a service.
- Silencing the dependency-cruiser config to make a violation pass.

## Examples

### Good

```ts
// src/presentation/users/Profile.tsx
import { getUserProfile } from '@/services/user';  // ✅ via service layer
```

### Bad

```ts
// src/presentation/users/Profile.tsx
import { db } from '@/db/client';                  // ❌ presentation → db
const user = await db.users.findUnique(...);
```

The fix: move the query into `src/services/user.ts` as `getUserProfile`; have presentation
call the service.
```

This skill is loaded *when the agent's work touches the layered code*, not on every task. The trigger paths are specific; the rules are concrete; the examples illustrate; the anti-patterns name failure modes.

---

## 🛠️ Skill review checklist

Before committing a skill:

- [ ] Frontmatter has `name` and `description` (and `description` is for the model)
- [ ] The skill has a clear *Purpose* (what failure mode it prevents)
- [ ] *Core rules* are numbered and concrete
- [ ] *What does not belong* lists what goes elsewhere (with pointers)
- [ ] *Anti-patterns* name specific failure modes
- [ ] If the skill is folder-form, the SKILL.md is small enough to be a quick read; references / scripts / examples carry depth
- [ ] At least one team member has tried the skill in a real session and confirmed it loads at the right moments

---

## 🔁 Updating an existing skill

Skills can evolve. When you update one:

- Note the change in the project's CHANGELOG (or the skill's own changelog if it's a folder-form skill with substantial history)
- If the change tightens the discipline (new red flag, new constraint), tell the team — agents in flight may not see the update mid-session
- If the change loosens the discipline (a constraint is no longer required), record the rationale in an ADR

---

## See also

- [`skills/README.md`](../skills/README.md) — the skill catalogue
- [`reference/agents-md.md`](../reference/agents-md.md) — when to put rules there instead
- [`concepts/12-prior-art.md`](../concepts/12-prior-art.md) — the Anthropic / Codex skills format origin
- [Anthropic's Skills format](https://docs.anthropic.com/) (external)
