# 🐝 Swarm scaffold

> **The literal, copy-and-paste artefacts that turn any repo into a Swarm-conformant repo.** Self-contained: every reference inside this directory points to other files inside this directory. No `/docs/` references, no broken links when you copy.

This directory mirrors what your repository's structure should look like at the relevant paths. Copy the contents into your repo's root; bind the `{{cmdX}}` placeholders in `AGENTS.md` to your project's commands; you're conformant.

For the *why* behind these artefacts — the conceptual rationale, design decisions, worked examples — see the project's `/docs/` directory. The scaffold is what to copy; the docs are what to read.

---

## 🗺️ What's in here

```
scaffold/
├── README.md                              ← you are here
├── AGENTS.md                              ← root agent brief (TODO markers to fill in)
├── CLAUDE.md                              ← Claude Code alias (imports AGENTS.md)
├── GEMINI.md                              ← Gemini alias (points to AGENTS.md)
├── .gitignore.additions                   ← lines to append to your .gitignore
│
├── docs/
│   └── agents/                            ← human-facing process docs that ship with every project
│       ├── 01-process.md                  ← the documentation-first workflow
│       ├── 02-file-types.md               ← what each document type contains
│       ├── 03-workflow.md                 ← step-by-step session flow
│       ├── 04-standards.md                ← writing and execution standards
│       └── 05-flow-graph.md               ← the deterministic routing graph
│
└── .agents/
    ├── skills/
    │   ├── personas/
    │   │   └── SKILL.md                   ← the personas skill (loads all 13 persona profiles)
    │   ├── manage-task/SKILL.md           ← always loaded
    │   ├── documentation-gatekeeper/SKILL.md ← always loaded
    │   ├── distillation-discipline/SKILL.md
    │   ├── empirical-proof/SKILL.md
    │   ├── adversarial-review/SKILL.md
    │   ├── write-spec/SKILL.md
    │   ├── write-audit/SKILL.md
    │   ├── write-research/SKILL.md
    │   ├── write-bug-report/SKILL.md
    │   ├── write-feature/SKILL.md
    │   ├── write-fix/SKILL.md
    │   ├── write-refactor/SKILL.md
    │   └── write-rewrite/SKILL.md
    │
    └── templates/
        ├── spec.md                        ← document templates
        ├── audit.md
        ├── bug-report.md
        ├── research.md
        ├── skill.md                       ← template for new project-specific skills
        ├── task-base.md                   ← shared task skeleton
        ├── task-feature.md                ← task templates per type
        ├── task-fix.md
        ├── task-refactor.md
        ├── task-rewrite.md
        ├── task-research.md
        ├── task-audit.md
        ├── task-bug-report.md
        ├── task-migration.md
        ├── task-performance.md
        ├── task-testing.md
        ├── task-documentation.md
        ├── task-orchestration.md
        └── task-review.md
```

---

## 🚀 Install procedure

The scaffold is designed for **mirror-the-paths** installation: every file's path inside `scaffold/` is the path it should land at, relative to your repo's root.

### Quick install (one shell)

From your repo's root:

```bash
# 1. Copy the directory contents (the .agents/ tree, docs/agents/, the alias files)
cp -r path/to/swarm/scaffold/.agents .
cp -r path/to/swarm/scaffold/docs/agents docs/

# 2. Copy the entry-point files
cp path/to/swarm/scaffold/AGENTS.md .
cp path/to/swarm/scaffold/CLAUDE.md .
cp path/to/swarm/scaffold/GEMINI.md .

# 3. Append to your .gitignore
cat path/to/swarm/scaffold/.gitignore.additions >> .gitignore

# 4. Create the source-doc directories
mkdir -p .agents/{tasks,specs,audits,bugs,research}
```

### Required edits after copying

The scaffold ships with `TODO` markers where your project's specifics belong. Search for them:

```bash
grep -rn "TODO" AGENTS.md .agents/
```

You must:

1. **Bind the verification gate slots in `AGENTS.md`.** Replace each `TODO: <bind>` with your project's command (e.g., `pnpm install`, `cargo check`).
2. **Fill in the `## Project conventions` section in `AGENTS.md`** — language, runtime, test runner, package manager.
3. **Optionally:** add a `.agents/constitution.md` capturing project-wide non-negotiable baselines.

### Verify

```bash
ls -la .agents/skills/personas/        # should list SKILL.md
ls -la .agents/templates/              # should list 18 task templates + 5 doc templates
cat AGENTS.md | grep -c "TODO"         # should be 0 after you've bound the placeholders
grep -F ".agents/tasks/" .gitignore     # should match
```

---

## 🪞 The placeholder contract

Every template in `.agents/templates/` uses `{{name}}` placeholders. They fall into two namespaces:

### Command placeholders (project-bound, set once in `AGENTS.md`)

| Placeholder              | What it represents                                                           |
| ------------------------ | ---------------------------------------------------------------------------- |
| `{{cmdInstall}}`         | Install dependencies / set up the worktree                                  |
| `{{cmdValidate}}`        | The project's catch-all check (lint + format + typecheck)                   |
| `{{cmdLint}}`            | Lint only                                                                   |
| `{{cmdFormat}}`          | Format check                                                                |
| `{{cmdTypecheck}}`       | Static analysis / type check                                                |
| `{{cmdTest}}`            | Test suite                                                                  |
| `{{cmdBuild}}`           | Build the project artefact                                                  |
| `{{cmdValidateDeps}}`    | Architectural / dependency-graph boundary check (mark `n/a` if unavailable) |
| `{{cmdBenchmark}}`       | Run benchmarks (`performance` tasks)                                         |
| `{{cmdMarkdownLint}}`    | Lint Markdown docs (where applicable)                                       |
| `{{cmdLinkCheck}}`       | Check doc links resolve                                                     |
| `{{cmdCitationCheck}}`   | Check research-file citations are valid (rare)                              |

### Scaffolding placeholders (per-task, set by your launcher / Swarm CLI)

| Placeholder         | What it represents                                                                       |
| ------------------- | ---------------------------------------------------------------------------------------- |
| `{{slug}}`          | URL-safe task slug (`oauth2-pkce`)                                                       |
| `{{title}}`         | Human-readable title                                                                     |
| `{{agent}}`         | Agent CLI / model identifier                                                             |
| `{{branch}}`        | Git branch                                                                               |
| `{{baseBranch}}`    | Base branch                                                                              |
| `{{worktreePath}}`  | Worktree location                                                                        |
| `{{createdAt}}`     | ISO-8601 timestamp                                                                       |
| `{{specFile}}`      | Path to the primary source doc                                                           |
| `{{auditFile}}`     | Path to the source audit (when applicable)                                              |
| `{{bugReport}}`     | Path to the source bug-report                                                            |
| `{{reviewFile}}`    | Path to a Skeptic's review notes (kickback tasks)                                       |
| `{{round}}`         | Kickback round (1, 2, 3)                                                                 |
| `{{originalType}}`  | Kickback's original task type                                                            |
| `{{originalPersona}}` | Kickback's original persona                                                              |

A runner (the Swarm CLI or any other) is **Swarm-compliant** if it substitutes every required placeholder before passing the task file to the agent. The framework defines the names; the project (or runner) binds the values.

---

## 🎭 The persona catalogue

The `personas/SKILL.md` file is a single skill defining all 13 framework personas:

| Persona                | Primary tasks                       |
| ---------------------- | ----------------------------------- |
| The Builder            | feature, integration, kickback      |
| The Skeptic            | review, deepen-audit, fix           |
| The Architect          | spec-writing                        |
| The Janitor            | refactor                            |
| The Lead Engineer      | orchestration                       |
| The Researcher         | research-writing (technical)        |
| The Surveyor           | research-writing (UX/market)        |
| The Bug Hunter         | bug-report-writing                  |
| The Auditor            | audit-writing                       |
| The Migrator           | migration, upgrade                  |
| The Performance Surgeon | performance                        |
| The Test Author        | testing                             |
| The Documentarian      | documentation                       |

Open `personas/SKILL.md` for the full profiles. Project-specific overlay personas (e.g., a TypeSurgeon for a TS-heavy shop) should live alongside as separate files in this directory.

---

## 🧰 What's NOT in this scaffold

- **A CLI.** Swarm is a documentation framework. Tools that implement it (the Swarm CLI, plus any compatible runner) live in separate repos.
- **Project-specific skills.** Add yours under `.agents/skills/domain/` after install.
- **The constitution.** Your project's non-negotiable baselines (`.agents/constitution.md`) is project-specific; the scaffold doesn't ship one.
- **Source docs (specs, audits, bugs, research).** Those are your project's content; the scaffold creates the *directories* but you author the *files*.
- **Conformance checker.** A future addition. The scaffold's structure is the conformance contract for now.

---

## 📜 Updating an installed scaffold

When the framework releases a new version with scaffold changes, the project repo's CHANGELOG and `MIGRATIONS.md` will list:

1. **Changed files** — diff against your installed copy, apply changes
2. **New files** — copy in
3. **Removed files** — remove (or deprecate per the migration notes)

Treat the scaffold like any vendored dependency: track the version you installed, update deliberately.

---

## 📚 Reference

For the *why* behind every artefact:

- The framework's main documentation is at `/docs/` in this repo.
- The persona-task-doc mapping is in `/docs/reference/flow-graph.md`.
- The placeholder contract is in `/docs/reference/template-placeholders.md`.
- The conceptual frame is in `/docs/concepts/`.

But again — **once you copy the scaffold into your repo, you don't need `/docs/` for day-to-day operation.** The scaffold is self-contained.
