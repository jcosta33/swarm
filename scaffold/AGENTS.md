# AGENTS.md

> **First action:** read your task file at `.agents/tasks/<your-slug>.md`. The file names your persona, lists your skills, links your source doc, and binds the verification commands you'll need. Then proceed.

This file is the entry point every agent CLI looks for (per the open [agents.md](https://agents.md/) standard, stewarded by the Agentic AI Foundation under the Linux Foundation). It carries only what *every* agent in this repo must know. Deeper, on-demand knowledge lives in `.agents/skills/`.

---

## Project conventions

> **TODO:** fill in your project's specifics.

- **Language:** TODO (e.g., TypeScript ≥ 5.5)
- **Runtime:** TODO (e.g., Node.js LTS)
- **Test runner:** TODO (e.g., vitest)
- **Package manager:** TODO (e.g., pnpm ≥ 9)

---

## Verification gate bindings

The framework defines named gate slots; this project binds them to commands. Replace each `TODO: <bind>` with your project's command.

| Slot                   | Command                                | Notes                                   |
| ---------------------- | -------------------------------------- | --------------------------------------- |
| `{{cmdInstall}}`       | TODO: `<install command>`              | e.g., `pnpm install`                    |
| `{{cmdValidate}}`      | TODO: `<validate command>`             | runs lint + format + typecheck          |
| `{{cmdLint}}`          | TODO: `<lint command>`                 | e.g., `pnpm run lint`                   |
| `{{cmdFormat}}`        | TODO: `<format check command>`         | e.g., `pnpm run format:check`           |
| `{{cmdTypecheck}}`     | TODO: `<typecheck command>`            | e.g., `pnpm run typecheck`              |
| `{{cmdTest}}`          | TODO: `<test command>`                 | e.g., `pnpm test`                       |
| `{{cmdBuild}}`         | TODO: `<build command>`                | e.g., `pnpm run build`                  |
| `{{cmdValidateDeps}}`  | TODO: `<deps check>` _or_ `n/a`        | dependency-graph check; `n/a` is allowed if you don't have one |
| `{{cmdBenchmark}}`     | TODO: `<bench command>` _or_ `n/a`     | only used by `performance` tasks       |
| `{{cmdMarkdownLint}}`  | TODO: `<md lint command>` _or_ `n/a`   | optional                                |
| `{{cmdLinkCheck}}`     | TODO: `<link check command>` _or_ `n/a` | optional                               |
| `{{cmdCitationCheck}}` | TODO: `<citation check>` _or_ `n/a`    | rare; only enforced for research tasks |

---

## Standing skill load

Every session starts by loading two skills:

- `manage-task` — task-file lifecycle and the pre-close gate (`.agents/skills/manage-task/SKILL.md`)
- `documentation-gatekeeper` — the framework's flow-graph enforcement (`.agents/skills/documentation-gatekeeper/SKILL.md`)

When your task file's `> **PERSONA:**` blockquote names a persona, also load `personas` (`.agents/skills/personas/SKILL.md`) and adopt the named persona profile.

Other skills auto-attach by task type — see the task templates in `.agents/templates/` for which skills each task loads. Project-specific skills under `.agents/skills/domain/` attach when their `description` field matches the work.

---

## Repo structure

> **TODO:** adapt to your repo's layout.

- `src/` — source code
- `tests/` — tests
- `.agents/` — agent docs / skills / templates / source docs
- `docs/` — user-facing documentation (if any)
- `docs/agents/` — process docs for agents (ships with Swarm)

---

## Constitution

> **TODO (optional):** if you maintain a project-wide non-negotiable-baselines doc:

The project's non-negotiable baselines live in `.agents/constitution.md`. Every spec, audit, and ADR operates within its constraints. (Delete this section if you don't maintain a constitution.)

---

## ADRs

> **TODO (optional):** if you maintain ADRs:

Architecturally significant decisions are recorded under `.agents/adrs/`. New ADRs are authored during `spec-writing` tasks when a structural decision warrants its own immutable record.

---

## Subagent strategy

The framework's position on parallelism (per `docs/agents/05-flow-graph.md` and the project's selected disciplines):

- **Read-side parallelism is permitted** via subagents. Research, audit, and review tasks run effectively in subagents (separate context windows reporting back digests).
- **Write-side work is single-threaded.** Implementation tasks (feature, fix, refactor, migration, etc.) run in the main thread; the Lead Engineer pattern serialises writes through a single-threaded merge protocol.

This is the synthesis the field converged on through 2025-2026; see `docs/agents/05-flow-graph.md` for the routing rules.

---

## Override semantics

This file is repo-root. In monorepos, subdirectories may have their own `AGENTS.md` (or `AGENTS.override.md`) for path-specific conventions. The closest file in the directory tree wins.

> **TODO (monorepo only):** list workspace-specific AGENTS.md files here for discoverability.

---

## See also

- `docs/agents/01-process.md` — the documentation-first workflow
- `docs/agents/02-file-types.md` — what each document type contains
- `docs/agents/03-workflow.md` — step-by-step session flow
- `docs/agents/04-standards.md` — writing and execution standards
- `docs/agents/05-flow-graph.md` — the deterministic routing graph (source-doc → task → persona → skills → verification)
- `.agents/skills/personas/SKILL.md` — full persona definitions
- `.agents/templates/` — the task and document templates
