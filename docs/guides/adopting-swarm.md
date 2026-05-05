# 📒 Guide: Adopting Swarm

> Step-by-step: a project author starting from a non-Swarm repo, how do they bring Swarm in. The scaffold does most of the work — copy a directory, bind a few placeholders, you're conformant.

---

## ⚡ TL;DR

Adopting Swarm is mostly *copying the scaffold* and *binding a few placeholders*. There is no runtime to install; no daemon to start. The framework is documentation; adopting it is a docs operation.

The full install:

1. Copy `/scaffold/` into your repo's root (mirror-the-paths convention)
2. Append `/scaffold/.gitignore.additions` to your `.gitignore`
3. Edit `AGENTS.md` to bind the `{{cmdX}}` placeholders to your project's commands
4. Optionally write a `.agents/constitution.md` capturing project-wide non-negotiable baselines
5. Verify the install (the conformance checker, when it ships, automates this)

---

## 🪞 The two halves of this repo

Before you start, understand what's where:

- **`/docs/`** — the framework's documentation. *Read* this when you want to understand the framework. Don't copy it.
- **`/scaffold/`** — the literal artefacts you copy into your repo. **Self-contained**: every reference inside `/scaffold/` points to other files inside `/scaffold/` (using `.agents/...` paths the consumer would have). When you copy `/scaffold/` into your repo, no links break.

**You only ever copy `/scaffold/`.** You read `/docs/` while adopting (and afterwards) for the *why*.

---

## 🪜 Pre-flight

Before adopting Swarm, confirm:

- ✅ The project has at least *some* documentation discipline. Swarm amplifies what you already do; it doesn't manufacture discipline from nothing.
- ✅ At least one developer (or AI engineer) is willing to be the framework's first user.
- ✅ You're working with an agent CLI that supports `AGENTS.md` (Claude Code, Codex, Cursor, Aider, Devin, opencode, etc.).
- ✅ You're using git, ideally with worktree support (`git worktree`).

Optional but helpful:

- A project-wide constitution (architectural invariants, security mandates) you can capture in `.agents/constitution.md`
- Existing audit-style notes you can promote to formal `audit.md` files
- A running list of architecturally significant decisions you can promote to ADRs

---

## 🪜 Step 1: Copy the scaffold

From your repo's root, with this Swarm repo cloned somewhere:

```bash
# Replace SWARM_REPO with the path to this Swarm repo
SWARM_REPO=/path/to/swarm

# Copy everything from /scaffold/ into your repo root
cp -r ${SWARM_REPO}/scaffold/.agents .
cp -r ${SWARM_REPO}/scaffold/docs/agents docs/
cp ${SWARM_REPO}/scaffold/AGENTS.md .
cp ${SWARM_REPO}/scaffold/CLAUDE.md .
cp ${SWARM_REPO}/scaffold/GEMINI.md .

# Append the gitignore additions
cat ${SWARM_REPO}/scaffold/.gitignore.additions >> .gitignore

# Create the source-doc directories (the scaffold creates the rest)
mkdir -p .agents/{tasks,specs,audits,bugs,research}
```

What this gives you:

- `AGENTS.md` (root entry point with `TODO` markers)
- `CLAUDE.md`, `GEMINI.md` (cross-tool aliases)
- `.gitignore` includes `.agents/tasks/` and `.worktrees/`
- `docs/agents/01-process.md` through `05-flow-graph.md` (process docs every project ships)
- `.agents/skills/` with all 6 cross-cutting skills + 8 authoring skills + the `personas/SKILL.md` (all 13 persona profiles)
- `.agents/templates/` with all 19 task and doc templates
- Empty `.agents/{tasks,specs,audits,bugs,research}/` directories ready for content

Verify:

```bash
ls -la .agents/skills/personas/   # should list SKILL.md
ls -la .agents/templates/         # should list 19 templates
ls -la docs/agents/               # should list 5 process docs
grep -F ".agents/tasks/" .gitignore  # should match
```

---

## 🪜 Step 2: Bind the verification gate placeholders

Open `AGENTS.md`. Search for `TODO` markers:

```bash
grep -n "TODO" AGENTS.md
```

You'll find:

- A `## Project conventions` section with `TODO` placeholders for language, runtime, test runner, package manager
- A verification gate bindings table with `TODO: <bind>` per slot

For each `{{cmdX}}` slot, replace `TODO: <bind>` with your project's command. Example for a TypeScript / pnpm project:

```markdown
| `{{cmdInstall}}`       | `pnpm install`                       |                                         |
| `{{cmdValidate}}`      | `pnpm run validate`                  | runs lint + format + typecheck          |
| `{{cmdLint}}`          | `pnpm run lint`                      |                                         |
| `{{cmdFormat}}`        | `pnpm run format:check`              |                                         |
| `{{cmdTypecheck}}`     | `pnpm run typecheck`                 |                                         |
| `{{cmdTest}}`          | `pnpm test`                          |                                         |
| `{{cmdBuild}}`         | `pnpm run build`                     |                                         |
| `{{cmdValidateDeps}}`  | `pnpm run validate:deps`             | dependency-cruiser                      |
| `{{cmdBenchmark}}`     | `n/a`                                | only used by performance tasks         |
```

Slots you don't have can be marked `n/a` with a one-line justification.

---

## 🪜 Step 3: Optionally write the constitution

If your project has architecturally invariant rules (security mandates, layering, language version pins), capture them in `.agents/constitution.md`. There's no template in scaffold for this (the constitution is project-specific by design); recommended sections:

- `## §1. Tech stack`
- `## §2. Code quality`
- `## §3. Architecture`
- `## §4. Security`
- `## §5. Testing`

The constitution is read by every persona before serious work; it's the supreme law of the project. Specs, audits, and ADRs reference it.

---

## 🪜 Step 4: Verify the install

Manual checklist (when the conformance checker ships, automates these):

- [ ] `AGENTS.md` exists at repo root
- [ ] `AGENTS.md` no longer contains `TODO` markers (`grep -c TODO AGENTS.md` → 0)
- [ ] `.gitignore` includes `.agents/tasks/` and `.worktrees/`
- [ ] `.agents/skills/personas/SKILL.md` exists
- [ ] `.agents/skills/manage-task/SKILL.md`, `documentation-gatekeeper/SKILL.md`, `personas/SKILL.md`, `distillation-discipline/SKILL.md`, `empirical-proof/SKILL.md`, `adversarial-review/SKILL.md` all exist
- [ ] `.agents/skills/write-spec/SKILL.md` and the other 7 write-skills exist
- [ ] `.agents/templates/` contains 19 templates
- [ ] `.agents/specs/`, `.agents/audits/`, `.agents/bugs/`, `.agents/research/` all exist
- [ ] `docs/agents/01-process.md` through `05-flow-graph.md` exist

---

## 🪜 Step 5: Run your first conditioned task

Pick a small piece of work — a feature, a small refactor, a doc update — and:

1. **Author the source doc** (e.g., a small spec at `.agents/specs/<slug>.md`, using the template at `.agents/templates/spec.md`).
2. **Scaffold a conditioned task file** at `.agents/tasks/<slug>.md` (use the appropriate template from `.agents/templates/task-<type>.md`; bind the placeholders).
3. **Open the task file in your agent CLI**.
4. **Tell the agent: *"Read the task file and proceed."***

The agent will:

- Read the persona profile (`.agents/skills/personas/SKILL.md`) and adopt the named persona's mindset
- Read the source doc
- Plan, implement, run gates, paste outputs
- Hand off to The Skeptic for review (if applicable)

If something feels off — the agent skipped a step, didn't load a skill, paraphrased verification output instead of pasting — the framework's discipline isn't yet sticky. That's normal for the first few sessions. The discipline tightens as the agent (and you) get the rhythm.

---

## 🪜 Step 6: Iterate

Over time:

- **Promote durable findings** to audits / specs / research (the promotion protocol; see `docs/agents/01-process.md` in your installed scaffold)
- **Add project-specific skills** under `.agents/skills/domain/` as you encounter patterns. Use `.agents/templates/skill.md` as the template.
- **Add overlay personas** if the framework's thirteen defaults miss recurring local discipline. Operational text either appends sections to **your fork** of `personas/SKILL.md` or lives beside it under `.agents/skills/personas/overlays/` with loader wiring spelled out in `AGENTS.md`.
- **Add ADRs** as you make structurally significant decisions. There's no canonical scaffold ADR template (yet); use the format documented in `docs/documents/extended.md` of this Swarm repo.
- **Update the constitution** as architectural invariants emerge.

The framework grows with the project. The discipline is in the *artefacts*, not in the tooling.

---

## 🪜 Updating an installed scaffold

When this Swarm framework releases a new version with scaffold changes:

1. **Read the project's CHANGELOG and `MIGRATIONS.md`** to see what changed
2. **Diff your installed copy against the new scaffold** (e.g., `diff -r .agents/skills /path/to/swarm/scaffold/.agents/skills`)
3. **Apply changes** — copy in new files; merge changes to modified files; remove deprecated files
4. **Re-bind any new `{{cmdX}}` placeholders** introduced by new templates

Treat the scaffold like any vendored dependency: track the version you installed, update deliberately.

---

## ⚠️ Common adoption pitfalls

| Pitfall                                                                | Symptom                                                            | Fix                                                              |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------- |
| Skipping the first-action paragraph in AGENTS.md                       | Agents don't read the task file first; default to helpfulness     | The scaffold's AGENTS.md ships with this paragraph. Don't remove it |
| Binding placeholders to commands that don't exist                      | Tasks fail at the verification gate                                | Either implement the command or mark the slot `n/a`             |
| Trying to copy from `/docs/` instead of `/scaffold/`                  | Cross-references break (because `/docs/` files reference each other) | Always copy from `/scaffold/`. `/docs/` is documentation; `/scaffold/` is artefacts |
| Installing skills as "just files" without reading them                 | Discipline doesn't take hold                                       | Read each skill at least once; understand what it enforces       |
| Writing the first task before any source doc                           | Forbidden flow (no grounding) — `documentation-gatekeeper` halts  | Author a source doc first, even a tiny one                       |
| Trying to bend Swarm to a tooling-first mental model                   | Frustration that the framework "doesn't do" the work for you     | Re-read [`PRINCIPLES.md`](../PRINCIPLES.md); Swarm is documentation, not tooling |

---

## 🪞 What you've installed

After step 1, your repo contains:

```
your-project/
├── AGENTS.md                          # entry point (with TODO markers to fill in)
├── CLAUDE.md                          # @AGENTS.md import
├── GEMINI.md                          # AGENTS.md pointer
├── .gitignore                         # includes .agents/tasks/, .worktrees/
│
├── docs/
│   └── agents/                        # human-facing process docs
│       ├── 01-process.md
│       ├── 02-file-types.md
│       ├── 03-workflow.md
│       ├── 04-standards.md
│       └── 05-flow-graph.md
│
└── .agents/
    ├── tasks/                         # gitignored, worktree-local
    ├── templates/                     # 19 task and doc templates
    ├── skills/
    │   ├── personas/SKILL.md          # all 13 persona profiles
    │   ├── manage-task/SKILL.md
    │   ├── documentation-gatekeeper/SKILL.md
    │   ├── distillation-discipline/SKILL.md
    │   ├── empirical-proof/SKILL.md
    │   ├── adversarial-review/SKILL.md
    │   └── write-{spec,audit,research,bug-report,feature,fix,refactor,rewrite}/SKILL.md
    ├── specs/                         # populate as your project authors specs
    ├── audits/                        # populate as your project audits areas
    ├── bugs/                          # populate as bugs are reported
    └── research/                      # populate as research is gathered
```

After step 5 (your first task), you'll also have:

- `.agents/specs/<your-first-slug>.md` — your first spec
- `.agents/tasks/<your-first-slug>.md` — your first conditioned task file (gitignored)
- A branch in your worktree with the work the agent did

After many sessions, you'll have:

- Many specs, audits, bugs, research files in `.agents/`
- A `.agents/skills/domain/` directory with your project-specific skills
- A `.agents/constitution.md` capturing your invariants
- A `.agents/adrs/` directory if you adopted ADRs
- A growing pattern library that future agents can lean on

---

## See also

- [`/scaffold/README.md`](../../scaffold/README.md) — the scaffold's own install procedure (with placeholder catalogue)
- [`quickstart.md`](quickstart.md) — the 10-minute version
- [`reference/agents-md.md`](../reference/agents-md.md) — the AGENTS.md anatomy
- [`reference/directory-layout.md`](../reference/directory-layout.md) — the canonical layout
- [`reference/template-placeholders.md`](../reference/template-placeholders.md) — the placeholder contract
- [`customizing-personas.md`](customizing-personas.md) — adding overlay personas
- [`monorepo-setup.md`](monorepo-setup.md) — nested AGENTS.md
- [`PRINCIPLES.md`](../PRINCIPLES.md) — the load-bearing constraints
