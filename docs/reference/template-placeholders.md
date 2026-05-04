# 📖 Reference: Template placeholders

> The framework's placeholder contract — the interface a CLI or runner must honour to be Swarm-compliant. This is what makes the framework usable by tools other than the Swarm CLI.

---

## ⚡ TL;DR

Placeholders use `{{name}}` syntax. They fall into two namespaces:

- **Command placeholders** (`{{cmdInstall}}`, `{{cmdValidate}}`, …) — bound by the project to repo-specific commands
- **Scaffolding placeholders** (`{{slug}}`, `{{branch}}`, `{{worktreePath}}`, …) — bound by the launcher per task

A runner is **Swarm-compliant** if it honours every placeholder in the catalogues below.

---

## 🪜 Why a contract

The framework is tool-agnostic. Templates contain `{{cmdValidate}}` rather than `pnpm run validate`; one team binds it to `pnpm run validate`, another to `cargo check && cargo clippy`, another to `pytest -q`. The contract makes the binding the project's responsibility, not the framework's.

Tool builders implementing the contract:

- Substitute every recognised placeholder with the project's binding before passing the task file to the agent
- Leave unrecognised placeholders alone (the agent or another runner may handle them)
- Reserve their own namespaces under `{{<vendor>:...}}` to avoid collisions

See [ADR 0005](../adrs/0005-placeholder-syntax.md) for the syntax decision.

---

## 🛠️ Command placeholders

These are bound by the project (typically in the project's `AGENTS.md`, or in the CLI's `swarm.config.yaml`-equivalent). The framework cares only about the slot names; the project binds them.

| Placeholder              | Semantics                                                                  | Example bindings                                  |
| ------------------------ | -------------------------------------------------------------------------- | ------------------------------------------------- |
| `{{cmdInstall}}`         | Install dependencies / set up the worktree                                | `pnpm install` · `cargo build` · `pip install -r requirements.txt` |
| `{{cmdValidate}}`        | The project's catch-all check (lint + format + typecheck)                 | `pnpm run validate` · `cargo check && cargo clippy` |
| `{{cmdLint}}`            | Lint only                                                                  | `pnpm run lint` · `cargo clippy` · `ruff check`   |
| `{{cmdFormat}}`          | Format check                                                               | `pnpm run format:check` · `cargo fmt --check`     |
| `{{cmdTypecheck}}`       | Static analysis / type check                                               | `pnpm run typecheck` · `mypy .` · `cargo check`   |
| `{{cmdTest}}`            | Test suite                                                                 | `pnpm test` · `cargo test` · `pytest`             |
| `{{cmdBuild}}`           | Build the project artefact                                                 | `pnpm run build` · `cargo build --release`        |
| `{{cmdValidateDeps}}`    | Architectural / dependency-graph boundary check                            | `pnpm run validate:deps` · `dependency-cruiser` · `import-linter` |
| `{{cmdBenchmark}}`       | Run benchmarks (used by `performance` tasks)                              | `pnpm run bench` · `cargo bench`                  |
| `{{cmdMarkdownLint}}`    | Lint Markdown docs (used by `documentation` tasks where applicable)        | `pnpm run lint:md` · `markdownlint`               |
| `{{cmdLinkCheck}}`       | Check that doc links resolve                                               | `pnpm run check:links` · `lychee`                 |
| `{{cmdCitationCheck}}`   | Check that research file citations are valid (used by `research-writing`)  | (project-defined; few projects implement this)    |

A repo that lacks a particular slot (e.g., no architectural validation tooling) marks the slot `n/a` with a one-line justification rather than silently skipping it.

---

## 🪧 Scaffolding placeholders

Bound by the launcher per task. The framework defines the names; the launcher computes the values.

| Placeholder         | Semantics                                                                       | Example value                                         |
| ------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `{{slug}}`          | Task's URL-safe slug (used in branch names, task file names, worktree paths)   | `oauth2-pkce`                                         |
| `{{title}}`         | Human-readable title (rendered as the task file's H1)                          | `Feature: OAuth2 PKCE flow`                           |
| `{{agent}}`         | Identifier for the agent CLI / model running this task                          | `claude-sonnet-4` · `codex-gpt-5` · `cursor`          |
| `{{branch}}`        | Git branch for this task                                                        | `feature/oauth2-pkce`                                 |
| `{{baseBranch}}`    | Base branch the worktree branched from                                         | `main`                                                |
| `{{worktreePath}}`  | Path to the worktree                                                            | `.worktrees/oauth2-pkce`                              |
| `{{createdAt}}`     | ISO-8601 timestamp when the task was scaffolded                                 | `2026-04-22T14:32:00Z`                                |
| `{{specFile}}`      | Path to the primary source doc                                                  | `.agents/specs/oauth2-pkce.md`                        |
| `{{auditFile}}`     | Path to the source audit (when applicable)                                     | `.agents/audits/billing-q1-2026.md`                   |
| `{{bugReport}}`     | Path to the source bug-report (when applicable)                                | `.agents/bugs/csv-export-truncation.md`               |
| `{{reviewFile}}`    | Path to a Skeptic's review notes (used in kickback tasks)                      | `.agents/reviews/payments-rate-limit-review.md`       |
| `{{round}}`         | For kickback tasks: round number (1, 2, 3)                                     | `2`                                                   |
| `{{originalType}}`  | For kickback tasks: the task type being revised                                 | `feature`                                             |
| `{{originalPersona}}` | For kickback tasks: the persona being revised                                | `The Builder`                                         |

---

## 🪧 Optional path placeholders

Some templates use placeholders for paths to documents that may or may not exist:

| Placeholder           | Semantics                                                                     |
| --------------------- | ----------------------------------------------------------------------------- |
| `{{constitutionFile}}` | Path to `.agents/constitution.md` (if the project has one)                  |
| `{{adrDir}}`           | Path to `.agents/adrs/` (if the project uses ADRs)                          |
| `{{relatedAdr}}`       | Path to a specific related ADR                                               |

---

## 🛡️ Reserved namespaces

To prevent collision between framework, CLI, and project placeholders:

| Prefix              | Reserved for                                                                  |
| ------------------- | ----------------------------------------------------------------------------- |
| `cmd*`              | Framework command slots (this doc's catalogue)                               |
| (no prefix)         | Framework scaffolding placeholders (this doc's catalogue)                    |
| `swarm:*`           | Swarm CLI extensions                                                          |
| `project:*`         | Project-specific custom placeholders                                          |
| `<vendor>:*`        | Other CLI vendors implementing the framework                                  |

If a CLI vendor wants to introduce a new placeholder, they prefix it with their vendor name to avoid collision. Example: a vendor called `tesseract` adding a new placeholder for an experimental capability would name it `{{tesseract:experimental_x}}`.

---

## 🪜 Required vs optional placeholders

| Placeholder                                                                  | Required for…                                                                |
| ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `{{slug}}`, `{{branch}}`, `{{baseBranch}}`, `{{worktreePath}}`, `{{createdAt}}` | Every task                                                                |
| `{{agent}}`                                                                  | Every task (for traceability)                                                |
| `{{title}}`                                                                  | Every task                                                                   |
| `{{cmdInstall}}`, `{{cmdValidate}}`, `{{cmdTest}}`                           | Every code-producing task                                                    |
| `{{cmdValidateDeps}}`                                                        | `refactor`, `migration`, `upgrade` (or `n/a` documented)                    |
| `{{cmdBenchmark}}`                                                           | `performance`                                                                |
| `{{cmdBuild}}`                                                               | `upgrade` (and `feature` where applicable)                                   |
| `{{cmdTypecheck}}`                                                           | `refactor`, `feature` (where applicable)                                     |
| `{{specFile}}`                                                               | Every task with a source doc                                                 |
| `{{auditFile}}`, `{{bugReport}}`, `{{reviewFile}}`, `{{round}}`, `{{originalType}}`, `{{originalPersona}}` | Per-task type as applicable                       |

---

## 🛡️ The conformance rule

A runner is **Swarm-compliant** if and only if:

1. It substitutes every required placeholder with a valid binding before passing the task file to the agent.
2. It leaves unrecognised placeholders alone (no silent stripping).
3. It does not introduce placeholders in the framework's reserved namespace (`cmd*` or no-prefix) without first proposing them to the framework via an ADR.

Compliance lets a project switch CLIs without rewriting templates.

---

## 🪞 Why `{{cmdX}}` and not `${cmdX}` or `<cmdX>`

[ADR 0005](../adrs/0005-placeholder-syntax.md) covers the decision. Summary:

- `${X}` collides with shell variable substitution (templates are often `cat`-piped through shells).
- `<X>` collides with HTML / XML / Markdown angle-bracket syntax.
- `{{X}}` is widely recognised (Mustache, Handlebars, Jekyll) and *doesn't* collide with common syntaxes.

The convention is also model-friendly — agent CLIs see `{{X}}` and recognise it as a placeholder rather than as content to render.

---

## See also

- [`reference/flow-graph.md`](flow-graph.md) — when each `cmd*` slot fires
- [`reference/agents-md.md`](agents-md.md) — where the project binds the slots
- [ADR 0005](../adrs/0005-placeholder-syntax.md) — syntax decision
- [`tasks/`](../tasks/) — the templates that consume these placeholders
