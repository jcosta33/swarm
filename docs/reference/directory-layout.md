# 📖 Reference: Directory layout

> The minimum directory structure for a Swarm-conformant repo. Empty directories exist by convention so agents know where to place new artefacts without inventing locations.

---

## 🏠 Repo root

```
.
├── AGENTS.md                          # entry point — see reference/agents-md.md
├── .gitignore                         # must include .agents/tasks/
└── .agents/
    ├── tasks/                         # gitignored; worktree-local task files
    ├── templates/                     # task + doc templates with placeholders
    ├── skills/                        # cross-cutting + domain-specific skills
    ├── specs/                         # source doc: feature specs
    ├── audits/                        # source doc: codebase audits
    ├── bugs/                          # source doc: bug reports
    └── research/                      # source doc: external knowledge
```

---

## 🗄️ Optional but recommended

```
.agents/
    ├── adrs/                          # Architecture Decision Records
    ├── constitution.md                # project-wide non-negotiable baselines
    ├── migrations/                    # migration plans (specialised specs)
    ├── benchmarks/                    # benchmark reports (specialised audits)
    ├── cleanups/                      # cleanup lists (specialised audits)
    ├── test-plans/                    # test plans (specialised specs)
    ├── audit-briefs/                  # framing for audit-writing tasks
    ├── research-questions/            # framing for research-writing tasks
    ├── review-scopes/                 # framing for review tasks
    └── reviews/                       # review reports (Skeptic verdicts)
```

---

## 🛠️ Skill subdirectories

```
.agents/skills/
    ├── personas/
    │   ├── SKILL.md                   # the personas skill itself (loads profiles)
    │   ├── the-builder.md
    │   ├── the-skeptic.md
    │   ├── the-architect.md
    │   ├── the-janitor.md
    │   ├── the-lead-engineer.md
    │   ├── the-researcher.md
    │   ├── the-surveyor.md
    │   ├── the-bug-hunter.md
    │   ├── the-auditor.md
    │   ├── the-migrator.md
    │   ├── the-performance-surgeon.md
    │   ├── the-test-author.md
    │   └── the-documentarian.md
    │
    ├── manage-task/SKILL.md            # always loaded
    ├── documentation-gatekeeper/SKILL.md # always loaded
    ├── distillation-discipline/SKILL.md # for distilling tasks
    ├── empirical-proof/SKILL.md        # for verification-running tasks
    ├── adversarial-review/SKILL.md     # for review / audit / bug-hunt
    │
    ├── write-spec/SKILL.md
    ├── write-audit/SKILL.md
    ├── write-research/SKILL.md
    ├── write-bug-report/SKILL.md
    ├── write-feature/SKILL.md
    ├── write-fix/SKILL.md
    ├── write-refactor/SKILL.md
    ├── write-rewrite/SKILL.md
    │
    └── domain/                         # project-specific skills accumulate here
        └── (e.g., architecture-violations, testing-file-layout, etc.)
```

Skills can be:

- **Folders** (`<name>/SKILL.md` plus optional `references/`, `scripts/`, `examples/` subdirectories) — preferred for skills that benefit from progressive disclosure
- **Flat files** (`<name>.md`) — fine for short skills

The `name` and `description` in the YAML frontmatter is what the agent uses; the format is borrowed from Anthropic Skills / OpenAI Codex Agent Skills.

---

## 📄 Templates directory

```
.agents/templates/
    ├── task-base.md                    # documents the shared task skeleton
    ├── task-feature.md
    ├── task-fix.md
    ├── task-refactor.md
    ├── task-rewrite.md
    ├── task-migration.md
    ├── task-upgrade.md
    ├── task-performance.md
    ├── task-testing.md
    ├── task-integration.md
    ├── task-kickback.md
    ├── task-spec-writing.md
    ├── task-audit-writing.md
    ├── task-research-writing.md
    ├── task-bug-report-writing.md
    ├── task-review.md
    ├── task-deepen-audit.md
    ├── task-orchestration.md
    ├── task-documentation.md
    │
    ├── doc-base.md                     # documents the shared doc skeleton
    ├── doc-spec.md
    ├── doc-audit.md
    ├── doc-research.md
    ├── doc-bug-report.md
    ├── doc-adr.md                      # optional
    ├── doc-constitution.md             # optional
    ├── doc-migration-plan.md           # optional
    ├── doc-benchmark-report.md         # optional
    └── skill.md                        # template for new skills
```

The templates contain `{{placeholders}}` (see [`template-placeholders.md`](template-placeholders.md)). The launcher resolves them per task.

---

## 📁 Worktrees

When the agent CLI uses git worktrees (recommended for parallel work):

```
.worktrees/
    ├── <slug-1>/                       # one worktree per active task
    ├── <slug-2>/
    └── ...
```

Each worktree has its own `.agents/tasks/<slug>.md` (gitignored). The other `.agents/` directories are shared (via the worktree's git linkage).

---

## ✅ Conformance checklist

A repo is Swarm-conformant if:

- [ ] `AGENTS.md` exists at the repo root
- [ ] `.gitignore` includes `.agents/tasks/`
- [ ] `.agents/tasks/` exists (and is empty in the committed state)
- [ ] `.agents/templates/` contains a template per task type and per core doc type
- [ ] `.agents/skills/personas/` contains a profile for each of the 13 framework personas
- [ ] `.agents/skills/` contains the cross-cutting skills (`manage-task`, `documentation-gatekeeper`, `personas`, `distillation-discipline`, `empirical-proof`, `adversarial-review`)
- [ ] `.agents/skills/` contains the 8 authoring skills (`write-spec`, `write-audit`, `write-research`, `write-bug-report`, `write-feature`, `write-fix`, `write-refactor`, `write-rewrite`)
- [ ] `.agents/specs/`, `.agents/audits/`, `.agents/bugs/`, `.agents/research/` all exist (even if empty)
- [ ] Every persona profile includes the 6 framework subsections (Role / Mindset / Hard constraints / Forbidden actions / Decision heuristics / Checklist)
- [ ] Every `write-<type>` skill includes the 4 framework subsections (Purpose / Core rules / What does not belong / Anti-patterns)
- [ ] AGENTS.md instructs every agent to read its task file at `.agents/tasks/<slug>.md` as its first action
- [ ] AGENTS.md binds every required `{{cmdX}}` placeholder for the project

A conformance checker (when it ships) automates this validation.

---

## 🎨 Variations

The above is the *minimum*. Projects can:

- Use folder-based skills (with sub-files) for progressive disclosure
- Add `.agents/personas/` overlay personas (project-specific)
- Add `.agents/skills/domain/` skills as the project accumulates patterns
- Separate active and shipped specs into `.agents/specs/active/` and `.agents/specs/shipped/`
- Separate active and resolved audits similarly
- Add additional doc types (extended) under their own subdirectories

The framework cares about the *minimum*; everything beyond it is a project choice.

---

## See also

- [`agents-md.md`](agents-md.md) — what AGENTS.md should contain
- [`template-placeholders.md`](template-placeholders.md) — placeholder contract
- [`flow-graph.md`](flow-graph.md) — what each task type expects
- [`guides/adopting-swarm.md`](../guides/adopting-swarm.md) — how to install the layout
