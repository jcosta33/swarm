# 📒 Guide: Adopting Swarm

> Step-by-step: a project author starting from a non-Swarm repo, how do they bring Swarm in. Manual install (no CLI required). Where files go. What to fill in. How to verify the install is correct.

---

## ⚡ TL;DR

Adopting Swarm is mostly *copying files* and *binding a few placeholders*. There is no runtime to install; no daemon to start. The framework is documentation; adopting it is a docs operation.

The full install:

1. Create the `.agents/` directory tree
2. Copy the cross-cutting framework skills
3. Copy the 13 persona profiles
4. Copy the authoring skills
5. Copy the task and document templates
6. Write the project's `AGENTS.md` (binding the framework's slots)
7. Optionally write the project's `constitution.md`
8. Verify the install (the conformance checker, when it ships, automates this)

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

## 🪜 Step 1: Create the directory tree

```bash
# In your repo root
mkdir -p .agents/{tasks,templates,specs,audits,bugs,research}
mkdir -p .agents/skills/personas
mkdir -p .agents/skills/domain
echo ".agents/tasks/" >> .gitignore
git add .gitignore
git commit -m "chore: gitignore agent task files"
```

Optional directories (add as you adopt the corresponding doc types):

```bash
mkdir -p .agents/{adrs,migrations,benchmarks,cleanups,test-plans,audit-briefs,research-questions,review-scopes,reviews}
```

---

## 🪜 Step 2: Copy the cross-cutting framework skills

From this repo's `docs/skills/`, copy:

- `manage-task.md`
- `documentation-gatekeeper.md`
- `personas.md`
- `distillation-discipline.md`
- `empirical-proof.md`
- `adversarial-review.md`

Into your `.agents/skills/`. The skills can be flat files (e.g., `.agents/skills/manage-task.md`) or folders with `SKILL.md` inside (e.g., `.agents/skills/manage-task/SKILL.md`). Folder form is preferred when the skill grows references / scripts / examples.

```bash
# Example using flat-file form
cp docs/skills/manage-task.md .agents/skills/manage-task.md
cp docs/skills/documentation-gatekeeper.md .agents/skills/documentation-gatekeeper.md
cp docs/skills/personas.md .agents/skills/personas.md
cp docs/skills/distillation-discipline.md .agents/skills/distillation-discipline.md
cp docs/skills/empirical-proof.md .agents/skills/empirical-proof.md
cp docs/skills/adversarial-review.md .agents/skills/adversarial-review.md
```

---

## 🪜 Step 3: Copy the 13 persona profiles

From this repo's `docs/personas/`:

```bash
cp docs/personas/the-builder.md .agents/skills/personas/
cp docs/personas/the-skeptic.md .agents/skills/personas/
cp docs/personas/the-architect.md .agents/skills/personas/
cp docs/personas/the-janitor.md .agents/skills/personas/
cp docs/personas/the-lead-engineer.md .agents/skills/personas/
cp docs/personas/the-researcher.md .agents/skills/personas/
cp docs/personas/the-surveyor.md .agents/skills/personas/
cp docs/personas/the-bug-hunter.md .agents/skills/personas/
cp docs/personas/the-auditor.md .agents/skills/personas/
cp docs/personas/the-migrator.md .agents/skills/personas/
cp docs/personas/the-performance-surgeon.md .agents/skills/personas/
cp docs/personas/the-test-author.md .agents/skills/personas/
cp docs/personas/the-documentarian.md .agents/skills/personas/
```

---

## 🪜 Step 4: Copy the 8 authoring skills

```bash
for skill in write-spec write-audit write-research write-bug-report write-feature write-fix write-refactor write-rewrite; do
  cp docs/skills/${skill}.md .agents/skills/
done
```

---

## 🪜 Step 5: Copy the task and document templates

The task templates are embedded in the per-task pages under `docs/tasks/`. The doc templates are in `docs/documents/`. Extract the template blocks from each page into your `.agents/templates/` directory (or use the framework's templates verbatim — they're already in copyable form).

A typical install includes templates for:

- The 18 task types (or just the ones you use)
- The 4 core doc types (spec, audit, bug-report, research)
- Plus any extended doc types (ADR, constitution, migration plan, etc.)
- The skill template (for writing project-specific skills later)

---

## 🪜 Step 6: Write your project's `AGENTS.md`

Use the template at [`reference/agents-md.md`](../reference/agents-md.md) as the starting point.

Bind every required `{{cmdX}}` placeholder to your project's commands:

```markdown
| Slot                   | Command                              |
| ---------------------- | ------------------------------------ |
| `{{cmdInstall}}`       | <your install command>               |
| `{{cmdValidate}}`      | <your validate command>              |
| `{{cmdLint}}`          | <your lint command>                  |
| `{{cmdFormat}}`        | <your format-check command>          |
| `{{cmdTypecheck}}`     | <your typecheck command>             |
| `{{cmdTest}}`          | <your test command>                  |
| `{{cmdValidateDeps}}`  | <or `n/a` with one-line justification> |
| `{{cmdBuild}}`         | <your build command>                 |
```

Write the *first action* paragraph (the session-start hook):

```markdown
> First action: read your task file at `.agents/tasks/<your-slug>.md`. The file names your persona,
> lists your skills, links your source doc, and binds the verification commands you'll need.
> Then proceed.
```

Add cross-tool aliases:

```bash
# CLAUDE.md (one-line import)
echo "# Project context" > CLAUDE.md
echo "" >> CLAUDE.md
echo "@AGENTS.md" >> CLAUDE.md

# GEMINI.md (pointer)
echo "See AGENTS.md" > GEMINI.md
```

---

## 🪜 Step 7: Optionally write the constitution

If your project has architecturally invariant rules (security mandates, layering, language version pins), capture them in `.agents/constitution.md`. Use the template in [`documents/extended.md`](../documents/extended.md).

The constitution is read by every persona before serious work; it's the supreme law of the project. Specs, audits, and ADRs reference it.

---

## 🪜 Step 8: Verify the install

Manual checklist (when the conformance checker ships, automates these):

- [ ] `AGENTS.md` exists at repo root and contains the "first action" paragraph
- [ ] `.gitignore` includes `.agents/tasks/`
- [ ] `.agents/tasks/` exists
- [ ] `.agents/templates/` contains templates for the task types you use
- [ ] `.agents/skills/personas/` contains all 13 persona profiles
- [ ] `.agents/skills/` contains the 6 cross-cutting skills + 8 authoring skills
- [ ] `.agents/specs/`, `.agents/audits/`, `.agents/bugs/`, `.agents/research/` all exist
- [ ] Every `{{cmdX}}` placeholder in `AGENTS.md` is bound (or marked `n/a` with reason)
- [ ] At least one source doc has been authored (or one is planned for the next session)

---

## 🪜 Step 9: Run your first conditioned task

Pick a small piece of work — a feature, a small refactor, a doc update — and:

1. Author the source doc (e.g., a small spec at `.agents/specs/<slug>.md`).
2. Scaffold a conditioned task file at `.agents/tasks/<slug>.md` (use the template; bind the placeholders).
3. Open the task file in your agent CLI.
4. Tell the agent: *"Read the task file and proceed."*

The agent will:

- Read the persona profile
- Adopt the persona's mindset
- Read the source doc
- Plan, implement, run gates, paste outputs
- Hand off to The Skeptic for review (if applicable)

If something feels off — the agent skipped a step, didn't load a skill, paraphrased verification output instead of pasting — the framework's discipline isn't yet sticky. That's normal for the first few sessions. The discipline tightens as the agent (and you) get the rhythm.

---

## 🪜 Step 10: Iterate

Over time:

- Promote durable findings to audits / specs / research (the promotion protocol)
- Add project-specific skills under `.agents/skills/domain/` as you encounter patterns
- Add overlay personas if the project needs work the framework's 13 don't cover
- Add ADRs as you make structurally significant decisions
- Update the constitution as architectural invariants emerge

The framework grows with the project. The discipline is in the *artefacts*, not in the tooling.

---

## 🪜 Common adoption pitfalls

| Pitfall                                            | Symptom                                                            | Fix                                                              |
| -------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------- |
| Skipping the first-action paragraph in AGENTS.md   | Agents don't read the task file first; default to helpfulness     | Add the paragraph; make it the first thing in AGENTS.md         |
| Binding placeholders to commands that don't exist  | Tasks fail at the verification gate                                | Either implement the command or mark the slot `n/a`             |
| Installing skills as "just files" without reading them | Discipline doesn't take hold                                   | Read each skill at least once; understand what it enforces       |
| Writing the first task before any source doc       | Forbidden flow (no grounding) — `documentation-gatekeeper` halts  | Author a source doc first, even a tiny one                       |
| Adopting all 13 personas immediately               | Overwhelm; nobody knows where to start                            | Start with the personas you'll use first (Builder, Skeptic, Architect); add others as needed |
| Trying to bend Swarm to a tooling-first mental model | Frustration that the framework "doesn't do" the work for you     | Re-read [`PRINCIPLES.md`](../PRINCIPLES.md); Swarm is documentation, not tooling |

---

## See also

- [`quickstart.md`](quickstart.md) — the 10-minute version
- [`reference/agents-md.md`](../reference/agents-md.md) — the AGENTS.md anatomy
- [`reference/directory-layout.md`](../reference/directory-layout.md) — the canonical layout
- [`reference/template-placeholders.md`](../reference/template-placeholders.md) — the placeholder contract
- [`customizing-personas.md`](customizing-personas.md) — adding overlay personas
- [`monorepo-setup.md`](monorepo-setup.md) — nested AGENTS.md
- [`PRINCIPLES.md`](../PRINCIPLES.md) — the load-bearing constraints
