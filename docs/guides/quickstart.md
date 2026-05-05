# 🚀 Guide: Quickstart

> The 10-minute path to seeing what Swarm looks like in a real repo. Copy the scaffold; bind a few placeholders; run your first conditioned task.

---

## ⚡ TL;DR

```bash
# From your repo root, with Swarm cloned at $SWARM_REPO
cp -r $SWARM_REPO/scaffold/.agents .
cp -r $SWARM_REPO/scaffold/docs/agents docs/
cp $SWARM_REPO/scaffold/{AGENTS.md,CLAUDE.md,GEMINI.md} .
cat $SWARM_REPO/scaffold/.gitignore.additions >> .gitignore
mkdir -p .agents/{tasks,specs,audits,bugs,research}

# Edit AGENTS.md to bind {{cmdInstall}}, {{cmdValidate}}, {{cmdTest}}, etc.
# Then write a small spec, scaffold a task file, point your agent CLI at it.
```

That's the entire install. Read on for a worked end-to-end example.

---

## 🪞 What `/scaffold/` is and isn't

The framework's two halves:

- **`/docs/`** — documentation about the framework. *Read* this when you want to understand the framework. Don't copy it.
- **`/scaffold/`** — the literal copyable artefacts. **Self-contained**: every reference inside `/scaffold/` points to other files inside `/scaffold/` (using `.agents/...` paths). Copies cleanly into your repo.

You only ever copy `/scaffold/`. You read `/docs/` for the why.

---

## 🪜 Step 1: Copy the scaffold

```bash
SWARM_REPO=/path/to/swarm   # this Swarm framework repo

# Copy the .agents/ tree, the docs/agents/ process docs, and the entry-point files
cp -r $SWARM_REPO/scaffold/.agents .
cp -r $SWARM_REPO/scaffold/docs/agents docs/
cp $SWARM_REPO/scaffold/AGENTS.md .
cp $SWARM_REPO/scaffold/CLAUDE.md .
cp $SWARM_REPO/scaffold/GEMINI.md .

# Append the gitignore additions
cat $SWARM_REPO/scaffold/.gitignore.additions >> .gitignore

# Create the source-doc directories
mkdir -p .agents/{tasks,specs,audits,bugs,research}
```

Verify the structure:

```bash
ls -la .agents/skills/personas/        # SKILL.md
ls -la .agents/templates/              # 19 task and doc templates
ls -la docs/agents/                    # 5 process docs
grep -F ".agents/tasks/" .gitignore     # should match
```

---

## 🪜 Step 2: Bind the placeholders in AGENTS.md

Open `AGENTS.md`. The scaffold ships with `TODO` markers where your project's specifics belong.

```bash
grep -n "TODO" AGENTS.md
```

For each `{{cmdX}}` slot, replace `TODO: <bind>` with your project's command. Example for a TS / pnpm project:

```markdown
| `{{cmdInstall}}`       | `pnpm install`                       |
| `{{cmdValidate}}`      | `pnpm run validate`                  |
| `{{cmdLint}}`          | `pnpm run lint`                      |
| `{{cmdFormat}}`        | `pnpm run format:check`              |
| `{{cmdTypecheck}}`     | `pnpm run typecheck`                 |
| `{{cmdTest}}`          | `pnpm test`                          |
| `{{cmdBuild}}`         | `pnpm run build`                     |
| `{{cmdValidateDeps}}`  | `n/a`                                |
```

Slots you don't have can be `n/a` with a one-line justification.

Also fill in the `## Project conventions` section (language, runtime, test runner, package manager).

---

## 🪜 Step 3: Write a tiny spec

```bash
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

## 🪜 Step 4: Scaffold a conditioned task file

In a real install, the Swarm CLI scaffolds this from the spec. For the quickstart, copy the template and fill in the placeholders by hand:

```bash
cp .agents/templates/task-feature.md .agents/tasks/feat-example-greet.md
```

Now edit `.agents/tasks/feat-example-greet.md` and replace:

- `{{title}}` → `Feature: greet function`
- `{{slug}}` → `feat-example-greet`
- `{{branch}}` → `feature/example-greet`
- `{{baseBranch}}` → `main`
- `{{worktreePath}}` → `.worktrees/feat-example-greet` (or wherever you'll work)
- `{{createdAt}}` → today's ISO-8601 timestamp
- `{{specFile}}` → `.agents/specs/example-greet.md`
- The `{{cmdX}}` placeholders → your project's commands (or leave them — your AGENTS.md already binds them and the agent will resolve via context)

---

## 🪜 Step 5: Open the task file in your agent CLI

If you have an agent CLI installed (Claude Code, Codex, Cursor, Aider, etc.):

1. Open the worktree (`cd` into it; or `git worktree add .worktrees/feat-example-greet`)
2. Open `.agents/tasks/feat-example-greet.md` in your agent
3. Tell the agent: *"Read the task file and proceed."*

The agent will:

- Read the persona profile (`.agents/skills/personas/SKILL.md` → The Builder section)
- Adopt The Builder mindset
- Read the spec at `.agents/specs/example-greet.md`
- Plan, then implement `greet`
- Add the test
- Run the validation gates (`pnpm validate`, `pnpm test`)
- Fill in `## Self-review` with pasted output

The whole thing is the framework working as designed: the task file conditions the agent; the agent reads one file and acts.

---

## 🪜 Step 6: What you've done

You now have:

- A Swarm-conformant `.agents/` directory
- An `AGENTS.md` binding the framework's slots to your project's commands
- The 13 persona profiles + 6 cross-cutting skills + 8 authoring skills installed
- 19 task and doc templates ready to use
- One spec (`example-greet.md`)
- One conditioned task file (gitignored)
- (After running the agent) one feature implementation with verification proof

Next steps:

- Read [`adopting-swarm.md`](adopting-swarm.md) for the full adoption walkthrough
- Read [`concepts/`](../concepts/) to understand the framework
- Browse [`personas/`](../personas/) and [`tasks/`](../tasks/) for what each persona / task does
- Try writing a real spec for your project; let the framework take over

---

## See also

- [`/scaffold/README.md`](../../scaffold/README.md) — the scaffold's install procedure (with placeholder catalogue)
- [`adopting-swarm.md`](adopting-swarm.md) — the full adoption walkthrough
- [`reference/agents-md.md`](../reference/agents-md.md) — the AGENTS.md anatomy
- [`reference/directory-layout.md`](../reference/directory-layout.md) — the canonical layout
- [`tasks/feature.md`](../tasks/feature.md) — the feature task in detail
- [`personas/the-builder.md`](../personas/the-builder.md) — the persona you just used
