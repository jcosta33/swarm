# 🚀 Guide: Quickstart

> The 10-minute path to seeing what Swarm looks like in a real repo. No CLI required to follow along — Swarm is just files.

---

## ⚡ TL;DR

You'll:

1. Create the `.agents/` directory structure
2. Drop in the framework's skills and templates
3. Write a one-screen `AGENTS.md`
4. Open one task file as the agent would see it
5. Run a verification gate

By the end you'll have a Swarm-conformant repo and a single conditioned task file ready for an agent.

---

## 🪜 Step 1: Make the directory structure

In your repo root:

```bash
mkdir -p .agents/{tasks,templates,skills/personas,specs,audits,bugs,research}
echo ".agents/tasks/" >> .gitignore
```

Verify:

```bash
ls -la .agents
```

You should see the empty subdirectories. The `tasks/` directory is gitignored.

---

## 🪜 Step 2: Drop in the framework's skills

The framework ships these skills (the cross-cutting ones plus the eight authoring skills). For now, you can install minimum stubs and grow them as you need:

```bash
# In a real install, copy the framework's skill files. For the quickstart,
# create a minimal manage-task and documentation-gatekeeper:

cat > .agents/skills/manage-task.md <<'EOF'
---
name: manage-task
description: Always loaded. Owns the task file's lifecycle and the pre-close gate.
---

See https://<your-swarm-docs-url>/skills/manage-task.md for the full skill.
EOF

cat > .agents/skills/documentation-gatekeeper.md <<'EOF'
---
name: documentation-gatekeeper
description: Always loaded. Enforces the framework's flow graph; refuses forbidden flows.
---

See https://<your-swarm-docs-url>/skills/documentation-gatekeeper.md for the full skill.
EOF
```

For a real install, copy each skill from this repo's `docs/skills/` directory. The full skill content is what makes them load-bearing.

---

## 🪜 Step 3: Write a minimum AGENTS.md

```bash
cat > AGENTS.md <<'EOF'
# AGENTS.md

> First action: read your task file at `.agents/tasks/<your-slug>.md`. The file names your persona, lists your skills, links your source doc, and binds the verification commands you'll need. Then proceed.

## Project conventions

- Language: TypeScript ≥ 5.5
- Test runner: vitest
- Package manager: pnpm

## Verification gate bindings

| Slot | Command |
|------|---------|
| `{{cmdInstall}}` | `pnpm install` |
| `{{cmdValidate}}` | `pnpm run validate` |
| `{{cmdTest}}` | `pnpm test` |
| `{{cmdValidateDeps}}` | `pnpm run validate:deps` |

## Standing skill load

Every session starts by loading `manage-task` and `documentation-gatekeeper`. When the task file's `> **PERSONA:**` blockquote names a persona, also load that persona profile.

## Repo structure

- `src/` — source
- `tests/` — tests
- `.agents/` — agent docs / skills / templates
EOF
```

Adapt the bindings to your stack. See [`reference/template-placeholders.md`](../reference/template-placeholders.md) for the full slot list.

---

## 🪜 Step 4: Drop in one persona profile

For a quickstart, the Builder is enough:

```bash
mkdir -p .agents/skills/personas
# Copy or symlink docs/personas/the-builder.md into .agents/skills/personas/
# In a real install, drop in all 13 personas.
```

---

## 🪜 Step 5: Write a tiny spec

```bash
mkdir -p .agents/specs
cat > .agents/specs/example-greet.md <<'EOF'
# Specification: A `greet(name)` function

## Status
Active

## Author
Human (you)

## Context
Quickstart spec to demonstrate Swarm conditioning.

## Linked docs
(none)

## Goal
Add a `greet(name)` function to `src/greet.ts` that returns a friendly greeting.

## Scope
**In scope:**
- `greet(name: string): string` returning `"Hello, <name>!"`

**Out of scope:**
- Internationalisation
- Greeting variations

## Acceptance criteria
- [ ] AC1: `greet("Ada")` returns `"Hello, Ada!"`
- [ ] AC2: `greet("")` returns `"Hello, !"` (empty name acceptable for v1)
- [ ] AC3: A unit test exists in `tests/greet.test.ts` exercising both AC1 and AC2.

## Design decisions

### Decision: Plain string concatenation
**Chosen:** Use `\`Hello, \${name}!\``.

**Considered and rejected:**
- _Templating library_ — overkill for a one-line function.

## Constraints
- Honour project conventions (vitest, pnpm).

## Open questions
(none)
EOF
```

---

## 🪜 Step 6: Open a conditioned task file

In a real install, the Swarm CLI scaffolds this. For the quickstart, write it by hand:

```bash
cat > .agents/tasks/feat-example-greet.md <<'EOF'
# Feature: greet function

## Metadata
- Slug: feat-example-greet
- Branch: feature/example-greet
- Base: main
- Worktree: .worktrees/feat-example-greet
- Created: 2026-04-22T14:32:00Z
- Status: active
- Type: feature

---

> ⚠️ **FEATURE SESSION** — Build exactly what the spec specifies. Halt on ambiguity. No opportunistic refactoring.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Builder** persona.

---

## Objective
Implement `greet(name)` per `.agents/specs/example-greet.md`.

## Linked docs
- Spec: .agents/specs/example-greet.md

## Required skills
- manage-task
- documentation-gatekeeper
- personas → The Builder
- write-feature
- empirical-proof

## Constraints
- Work only inside this worktree
- Run `pnpm install` to install dependencies
- Run `pnpm run validate` after changes
- Halt on ambiguity

## Plan
1. Add `src/greet.ts` with the `greet` function
2. Add `tests/greet.test.ts` with AC1 and AC2 cases
3. Run `pnpm run validate` and `pnpm test`; paste outputs

## Progress checklist
- [ ] Spec read in full
- [ ] `src/greet.ts` created
- [ ] `tests/greet.test.ts` created with AC1 + AC2
- [ ] `pnpm run validate` passes (paste output)
- [ ] `pnpm test` passes (paste output)
- [ ] Self-review filled in

## Decisions
- ***

## Findings
- ***

## Assumptions
- [pending]

## Blockers
- ***

## Next steps
- ***

## Self-review

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs

- `git status` →
- `pnpm run validate` (last 2 lines):
- `pnpm test` (last 2 lines):

### Spec adherence
Answer:

### Architecture
Answer:

### Tests
Answer:

### Completeness
Answer:
EOF
```

---

## 🪜 Step 7: Open the task file in your agent CLI

If you have an agent CLI installed (Claude Code, Codex, Cursor, Aider, etc.):

1. Open the worktree (`cd` into it; or `git worktree add .worktrees/feat-example-greet`)
2. Open `.agents/tasks/feat-example-greet.md` in your agent
3. Tell the agent: *"Read the task file and proceed."*

The agent will:

- Read the persona profile
- Adopt The Builder mindset
- Read the spec
- Implement `greet`
- Add the test
- Run the validation gates
- Fill in the Self-review with pasted output

The whole thing is the framework working as designed: the task file conditions the agent; the agent reads one file and acts.

---

## 🪜 Step 8: What you've done

You now have:

- A Swarm-conformant `.agents/` directory
- An `AGENTS.md` binding the framework's slots to your project's commands
- One persona profile (the Builder)
- One framework skill stub (`manage-task`, `documentation-gatekeeper`)
- One spec (`example-greet.md`)
- One conditioned task file
- (After running the agent) one feature implementation with verification proof

Next steps:

- Read [`adopting-swarm.md`](adopting-swarm.md) for the full install (all 13 personas, all 8 authoring skills, the full template set)
- Read [`concepts/`](../concepts/) to understand the framework
- Browse [`personas/`](../personas/) and [`tasks/`](../tasks/) for what each persona / task does
- Try writing a real spec for your project; let the framework take over

---

## See also

- [`adopting-swarm.md`](adopting-swarm.md) — the full install
- [`reference/agents-md.md`](../reference/agents-md.md) — the AGENTS.md anatomy
- [`reference/directory-layout.md`](../reference/directory-layout.md) — the canonical layout
- [`tasks/feature.md`](../tasks/feature.md) — the feature task in detail
- [`personas/the-builder.md`](../personas/the-builder.md) — the persona you just used
