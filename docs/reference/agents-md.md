# 📖 Reference: AGENTS.md

> Swarm's adoption of the open AGENTS.md standard. AGENTS.md is the canonical entry point every Swarm-conformant repo ships with — short, opinionated, and focused on what every agent must know.

---

## ⚡ TL;DR

`AGENTS.md` lives at the repo root. It tells the agent:

1. Where the task file lives
2. The standing convention to load `manage-task` and `documentation-gatekeeper` first
3. The repo's named verification gate bindings

It is read by every agent CLI that supports the open standard (Claude Code, Codex, Cursor, Aider, Devin, Factory, Jules, Junie, Warp, Zed, opencode, and more — the standard is stewarded by the [Agentic AI Foundation](https://agents.md/) under the Linux Foundation).

---

## 🪜 Why AGENTS.md

The format originated at OpenAI Codex and has been adopted across the agent-tooling ecosystem. The OpenAI monorepo alone reportedly ships 88 nested AGENTS.md files (closest-wins), with `AGENTS.override.md` for monorepo subdirectories that need different rules.

Swarm adopts the standard verbatim: the `AGENTS.md` is the entry point; nesting works (closest-wins); overrides are explicit.

---

## 📐 The recommended template

```markdown
# AGENTS.md

> First action: read your task file at `.agents/tasks/<your-slug>.md`. The file names your persona, lists your skills, links your source doc, and binds the verification commands you'll need. Then proceed.

## Project conventions

- Language: <e.g., TypeScript ≥ 5.5>
- Runtime: <e.g., Node.js LTS>
- Test runner: <e.g., vitest>
- Package manager: <e.g., pnpm ≥ 9>

## Verification gate bindings

The framework defines named gate slots; this project binds them to commands.

| Slot                  | Command                              | Notes                                   |
| --------------------- | ------------------------------------ | --------------------------------------- |
| `{{cmdInstall}}`      | `pnpm install`                       |                                         |
| `{{cmdValidate}}`     | `pnpm run validate`                  | runs lint + format + typecheck          |
| `{{cmdLint}}`         | `pnpm run lint`                      |                                         |
| `{{cmdFormat}}`       | `pnpm run format:check`              |                                         |
| `{{cmdTypecheck}}`    | `pnpm run typecheck`                 |                                         |
| `{{cmdTest}}`         | `pnpm test`                          |                                         |
| `{{cmdBuild}}`        | `pnpm run build`                     |                                         |
| `{{cmdValidateDeps}}` | `pnpm run validate:deps`             | dependency-cruiser                      |
| `{{cmdBenchmark}}`    | `pnpm run bench`                     | (only used by `performance` tasks)     |
| `{{cmdMarkdownLint}}` | `pnpm run lint:md`                   |                                         |
| `{{cmdLinkCheck}}`    | `pnpm run check:links`               |                                         |
| `{{cmdCitationCheck}}` | n/a                                  | not enforced; manual citation check    |

## Standing skill load

Every session starts by loading two skills:

- `manage-task` — task-file lifecycle and the pre-close gate
- `documentation-gatekeeper` — the framework's flow-graph enforcement

When your task file's `> **PERSONA:**` blockquote names a persona, also load `personas` and the named persona profile.

## Repo structure

- Source: `src/`
- Tests: `tests/`
- Agent docs / skills / templates: `.agents/`
- User-facing docs: `docs/`

## Constitution

The project's non-negotiable baselines live in `.agents/constitution.md`. Every spec, audit, and ADR operates within its constraints.

## ADRs

Architecturally significant decisions are recorded under `.agents/adrs/`.

## Subagent strategy

- Read-side parallelism (research, audit, review) is permitted via subagents.
- Write-side work (feature, fix, refactor, migration) runs single-threaded.

See `docs/concepts/10-subagent-strategy.md` for the full rationale.

## Override semantics

This file is repo-root. Subdirectories may have their own `AGENTS.md` (or `AGENTS.override.md`) for path-specific conventions. The closest file in the directory tree wins.
```

---

## 🪞 What AGENTS.md is NOT

- **Not a place to put domain rules.** Domain rules go in skills (`.agents/skills/domain/`). AGENTS.md is for *universal invariants* — what every agent in the repo must know.
- **Not a substitute for the persona profile.** The persona's hard rules live in the persona file; AGENTS.md tells the agent *to load the persona*.
- **Not a substitute for the spec.** Per-task constraints live in the task's source doc; AGENTS.md tells the agent *to read its task file first*.
- **Not where the agent stores state.** AGENTS.md is read; not written. State lives in the task file (per session) or in the source docs (durable).

---

## 🪜 Hierarchical AGENTS.md

In monorepos, multiple `AGENTS.md` files coexist. The agent reads the closest file in the directory tree (the file in the deepest enclosing directory wins).

Example monorepo:

```
.
├── AGENTS.md                            # repo-root: shared bindings
├── packages/
│   ├── api/
│   │   └── AGENTS.md                    # api-specific bindings (overrides cmdTest, etc.)
│   └── web/
│       └── AGENTS.md                    # web-specific bindings
└── tools/
    └── AGENTS.md                        # tools workspace
```

When an agent works in `packages/api/`, the `packages/api/AGENTS.md` is the active one. It can:

- **Inherit** by referencing the root: `# packages/api/AGENTS.md` *— see the root `AGENTS.md` for shared conventions; this file overrides…*
- **Override** specific bindings (e.g., `cmdTest` for the api package may be `vitest -c packages/api/vitest.config.ts`)
- **Add** workspace-specific constraints (e.g., a stricter typecheck flag)

For OpenAI Codex compatibility, you can use `AGENTS.override.md` instead of `AGENTS.md` in subdirectories that should *only* override (not replace) the parent.

---

## 🪧 Session-start hook

Skills don't apply themselves; the agent has to be told to load them. AGENTS.md is the natural place to enforce this — the first paragraph of the file is the session-start hook.

The framework recommends:

> First action: read your task file at `.agents/tasks/<your-slug>.md`. The file names your persona, lists your skills, links your source doc, and binds the verification commands you'll need. Then proceed.

This is one paragraph but it's load-bearing. Without it, the agent may default to its own helpfulness instead of adopting the persona-conditioned task file.

Some agent CLIs support hook mechanisms (Claude Code's session-start hooks, Codex's skill auto-loading) that can supplement the AGENTS.md instruction. The framework recommends both: the AGENTS.md instruction as the *content*, and the CLI's hook as the *delivery mechanism*.

---

## 🛡️ The conformance rule

A Swarm-conformant repo must have:

- `AGENTS.md` at the repo root
- The "first action" instruction (read your task file)
- Bindings for every required `{{cmdX}}` placeholder (see [`template-placeholders.md`](template-placeholders.md))
- A reference to the standing skill load convention

Optional but recommended:

- Subagent strategy section
- Constitution / ADR pointers
- Hierarchical AGENTS.md in monorepos

---

## 🧰 Aliases for vendor-specific names

Some agent CLIs look for specific filenames before checking the open AGENTS.md standard. Recommended aliases (one-line files that import AGENTS.md):

| Vendor file       | Recommended content                                    |
| ----------------- | ------------------------------------------------------ |
| `CLAUDE.md`       | `# Project context\n\n@AGENTS.md` (Claude Code import) |
| `GEMINI.md`       | A short pointer: `See AGENTS.md` (Gemini)             |
| `.cursor/rules/`  | (Cursor's per-file rules; can supplement AGENTS.md)   |

The aliases ensure cross-tool portability without duplicating AGENTS.md content.

---

## See also

- [`template-placeholders.md`](template-placeholders.md) — what each `{{cmdX}}` slot means
- [`directory-layout.md`](directory-layout.md) — what AGENTS.md sits next to
- [`concepts/10-subagent-strategy.md`](../concepts/10-subagent-strategy.md) — the subagent strategy AGENTS.md should reference
- [`concepts/12-prior-art.md`](../concepts/12-prior-art.md) — the AGENTS.md standard's origin
- [agents.md](https://agents.md/) — the open standard (external)
