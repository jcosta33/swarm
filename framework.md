# Swarm — Agentic Documentation Framework

## Context

Swarm is a documentation framework for coding agents. It exists because agents fail predictably without grounded context — they drift, they make irreversible decisions on unverified assumptions, and they leave no trail for the next session.

The framework's organising principle is that **the task is the source of truth**. Agents do tasks. Documentation surrounds tasks: it grounds them, conditions the agent's mindset, defines what success looks like, and captures decisions for the next session. Every artefact in the framework — every template, every skill, every persona — exists to make a real, recurring task succeed.

This spec defines the task taxonomy (what kinds of work agents do, repeatedly, in any repo), the persona for each task type (the mindset that makes that work succeed), the source documents that ground each task, the templates and skills that support them, and the sequencing rules that keep information flowing downhill from broad to narrow.

Source files informing this spec:

- `process.md`, `workflow.md`, `file-types.md`, `standards.md`
- `documentation-gatekeeper.md`, `manage-tasks.md`, `write-spec.md`, `write-audit.md`, `personas.md`
- `spec-template.md`, `research-template.md`, `skill-template.md`, `task-template.md`

This spec extends and supersedes those where they conflict; where they agree, this spec ratifies them.

---

## Goal

A repository operating under Swarm has, on disk:

- A task-file template that pre-conditions the agent: links the persona, the supporting skills, the source doc, and the validation gate slots, leaving only repo-specific details to fill in.
- A complete persona catalogue, one per task type, each with hard rules and forbidden actions.
- A complete set of source-doc templates and `write-<type>` skills, one per task type that needs grounding in a structured input.
- Sequencing rules that forbid backward distillation (no narrating finished code as a spec, no implementing from research without a spec).
- A `documentation-gatekeeper` skill that enforces those rules.

When this is in place, an agent assigned a task can produce a fully-conditioned task file as its first action, and proceed without inventing structure, mindset, or success criteria.

---

## User-visible behaviour

A developer or agent operating inside a Swarm-bootstrapped repo experiences the framework as follows:

1. **The task is named first.** Every session starts by identifying which of the task types in §3 applies. The task type determines the persona, the supporting skills, and the validation gates — deterministically.

2. **The task file is the first thing written.** Before any code, before any edit to any other doc, the task file exists. It contains the Objective, the Linked docs (source + skills + persona + optional research), the Constraints, the Plan, the Validation gates, the Self-review block. Repo-specific commands (the literal `pnpm test`, `cargo check`, etc.) are filled in from the repo's known conventions.

3. **Source docs ground the task; they don't drive it.** Some tasks need a substantive source doc (a Feature task needs a spec, a Bug Fix needs a bug report). Some don't (a Documentation task can be launched from a one-line scope captured in the task file's Objective). The task file is always primary; source docs feed into it.

4. **Personas are catalogued, not improvised.** Each task type has one lead persona with a written profile. The agent reads the profile before starting work. No persona is invented per session.

5. **Distillation is downhill only.** Research feeds spec / audit / migration plan / etc. Source docs feed task files. Task files produce code or terminal docs. Reverse flow — back-filling specs from finished code, narrating decisions retroactively — is forbidden.

6. **Validation gates are named, not prescribed.** The framework declares which gate slots must run for each task type (typecheck, test, dependency validation, etc.). The literal commands are repo-specific and live wherever the repo lists them — the framework does not mandate `pnpm`, `cargo`, `npm`, or any tool.

---

## Scope

**In scope:**

- The task type catalogue, defended by real-world frequency.
- The persona catalogue, one lead per task type.
- The source-doc catalogue with templates and write-skills.
- The task file template structure.
- The sequencing and directionality rules.
- The skill catalogue that must exist for the framework to function.
- The minimum directory layout under `.agents/`.

**Non-goals (explicitly out of scope):**

- Any CLI, TUI, launcher, or runtime tooling.
- Worktree, branching, PR, merge mechanics.
- Parallelism, delegators, sub-agent orchestration.
- The literal commands a repo runs for typecheck, lint, test, build, dependency validation.
- Specific domain skills a repo needs (e.g., audio engine, React state). The framework only requires that domain skills _can_ be referenced from the task file.

---

## 3. Task type catalogue

These are the kinds of work agents do in any non-trivial repository. Each is defended by ubiquity — if a task type is here, agents do it constantly across projects, languages, and stacks.

### Implementation tasks (output: code)

| Task                    | Lead persona  | Source doc                | When to use                                                              |
| ----------------------- | ------------- | ------------------------- | ------------------------------------------------------------------------ |
| **Feature Development** | Builder       | spec                      | Building new behaviour from a written specification                      |
| **Bug Fix**             | Debugger      | bug report                | Diagnosing and fixing a defect with a reproduction                       |
| **Refactor**            | Refactorer    | audit                     | Restructuring code without changing observable behaviour                 |
| **Migration**           | Migrator      | migration plan            | Applying one mechanical change uniformly across many call sites          |
| **Optimisation**        | Optimiser     | benchmark report          | Improving speed, memory, or bundle size against measured baselines       |
| **Cleanup**             | Janitor       | cleanup list              | Deleting dead code, removing obsolete patterns, consolidating duplicates |
| **Test Authoring**      | Test Engineer | test plan _or_ task scope | Adding or improving coverage as standalone work                          |

### Investigation tasks (output: a document)

| Task               | Lead persona       | Source doc              | When to use                                                                             |
| ------------------ | ------------------ | ----------------------- | --------------------------------------------------------------------------------------- |
| **Research**       | Researcher         | research question       | Gathering external knowledge to inform a downstream decision                            |
| **Audit**          | Cartographer       | audit brief             | Surveying a codebase area honestly to make its state legible                            |
| **Spec Authoring** | Specifier          | research _and/or_ audit | Translating upstream findings into a verifiable spec                                    |
| **Review**         | Skeptic            | review scope            | Adversarial inspection of finished work (a branch, PR, file, or another agent's output) |
| **Spike**          | Spike Investigator | spike brief             | Time-boxed exploration to answer a single question; code is throwaway                   |

### Communication tasks (output: documentation)

| Task              | Lead persona | Source doc | When to use                                                   |
| ----------------- | ------------ | ---------- | ------------------------------------------------------------- |
| **Documentation** | Documenter   | task scope | Writing or updating docs (READMEs, API docs, internal guides) |

**Total: 13 task types.** The mapping from task type to persona is rigid 1-to-1.

Several plausible task types fold into the above:

- **Hotfix** is a Bug Fix; urgency is a property of the bug report, not a separate task type.
- **Security Fix** is a Bug Fix where the bug is a vulnerability; security context is captured in the bug report.
- **Algorithm Implementation** is Feature Development with an algorithmically tricky spec.
- **Architecture Design** is Spec Authoring for systemic-impact features, with the Architect persona consulted on boundary decisions inside the spec's `## Design decisions` section.
- **Dependency Upgrade** is a Migration when it changes call sites, or a Cleanup when it only removes obsolete usages.

If a recurring real-world task can't be served by one of these 13, the catalogue grows. The bar is "agents do this all the time across many repos."

---

## 4. Persona catalogue

Each persona must exist as a profile in `.agents/skills/personas/<name>.md`. The profile is short — one screen — and follows the format in §6.1.

| #   | Persona                | Cares most about                                    | Forbidden from                                        |
| --- | ---------------------- | --------------------------------------------------- | ----------------------------------------------------- |
| 1   | **Builder**            | Shipping correctly + adhering to architecture       | Skipping tests; deviating from spec without flagging  |
| 2   | **Debugger**           | Reproduction first, then root cause                 | Scope creep; speculative fixes; refactor-while-fixing |
| 3   | **Refactorer**         | Behaviour preservation; test coverage as safety net | Adding features; changing public contracts            |
| 4   | **Migrator**           | Mechanical precision; consistency                   | Local cleverness; one-off variations                  |
| 5   | **Optimiser**          | Measurement-first; before/after numbers             | Optimising without measuring; correctness regressions |
| 6   | **Janitor**            | Provable safety of deletion                         | Modifying behaviour; "while I'm here" refactors       |
| 7   | **Test Engineer**      | Edge cases; readable failures                       | Modifying production code; flaky tests                |
| 8   | **Researcher**         | Source quality; reproducibility                     | Stating uncited claims; opinion-as-finding            |
| 9   | **Cartographer**       | Accuracy of observation; specificity                | Prescribing fixes; speculating about future work      |
| 10  | **Specifier**          | Verifiability; halting on ambiguity                 | Inventing requirements; specifying implementation     |
| 11  | **Skeptic**            | Empirical proof; failure modes; edge cases          | Trusting checkbox claims; "looks fine to me" review   |
| 12  | **Spike Investigator** | Discarding code; capturing the answer               | Productionising spike code; expanding scope           |
| 13  | **Documenter**         | Clarity for the reader; honesty about gaps          | Marketing prose; documenting what doesn't exist       |

Personas are derived from the work, not invented. If two personas have the same hard rules and forbidden actions, they collapse.

---

## 5. Source documents

Documents that ground tasks. Each source-doc type has a template and a `write-<type>` skill.

| Source doc            | Grounds task                | Location                                | Notes                                                                      |
| --------------------- | --------------------------- | --------------------------------------- | -------------------------------------------------------------------------- |
| **spec**              | Feature Development         | `.agents/specs/`                        | Forward-looking; verifiable acceptance criteria                            |
| **bug report**        | Bug Fix                     | `.agents/bugs/`                         | Repro, expected vs actual, environment                                     |
| **audit**             | Refactor                    | `.agents/audits/`                       | Honest survey of current state; prioritised issue list                     |
| **migration plan**    | Migration                   | `.agents/migrations/`                   | Target state, call-site list, ordering                                     |
| **benchmark report**  | Optimisation                | `.agents/benchmarks/`                   | Baseline numbers, methodology, target metrics                              |
| **cleanup list**      | Cleanup                     | `.agents/cleanups/`                     | Items to remove, each with safety proof                                    |
| **test plan**         | Test Authoring              | `.agents/test-plans/`                   | Coverage gaps and tests to add                                             |
| **research question** | Research                    | `.agents/research-questions/`           | The framing for a research task                                            |
| **audit brief**       | Audit                       | `.agents/audit-briefs/`                 | Scope and goal of the survey                                               |
| **review scope**      | Review                      | `.agents/review-scopes/` _or_ task file | Code reference + review focus; often light enough to live in the task file |
| **spike brief**       | Spike                       | `.agents/spikes/`                       | Question, time-box, exit criteria                                          |
| **research file**     | Spec Authoring              | `.agents/research/`                     | Terminal output of a Research task; input to Spec Authoring                |
| **task scope**        | Documentation, Test (small) | task file Objective                     | When the source is a one-paragraph ask, no separate doc is needed          |

A separate source doc exists when the task requires durable structure — a spec gets referenced after the feature ships; an audit gets revisited; a migration plan tracks dozens of call sites. For lightweight tasks (Documentation, small Test additions, Reviews), the task file's Objective and Linked docs sections are sufficient grounding.

**Audit and spec are both source and terminal.** A human-authored audit or spec is a source doc. An audit produced by a Cartographer or a spec produced by a Specifier is a terminal doc that becomes the source for a later task. This is the distillation chain in action.

---

## 6. The task file

The task file is the framework's leverage point. Every section is structured to remove a class of agent failure.

### 6.1 Required sections

In order:

1. **Metadata** — slug, branch, base, worktree path, source doc reference, task type, lead persona, created, status.
2. **Objective** — one paragraph; what is true when this task is done.
3. **Source doc** — link to the spec / audit / bug report / etc. that grounds this task. May be empty for tasks launched from task scope alone.
4. **Lead persona** — link to `.agents/skills/personas/<name>.md`.
5. **Required skills** — always: `manage-task`, `documentation-gatekeeper`, the persona skill. Plus any `write-<type>` skill if the task produces a doc.
6. **Domain skills** — links to repo-specific skills the agent has determined are relevant by inspecting `.agents/skills/domain/` and matching descriptions to the work.
7. **Optional research** — link to a research file if one exists upstream; otherwise note "none required" or "Research task must precede this one" with the question.
8. **Constraints** — task-specific constraints (from the source doc) plus the lead persona's forbidden actions.
9. **Plan** — step-by-step, written before implementation begins.
10. **Progress checklist** — discrete items, marked as they complete.
11. **Decisions** — significant choices made during the session, with rationale.
12. **Findings** — codebase discoveries worth preserving. Durable findings must also be migrated to an audit, spec, or research file before session close.
13. **Assumptions** — every assumption marked `[pending]` or `[confirmed]`.
14. **Blockers** — anything preventing confident progress, recorded immediately.
15. **Validation gates** — named slots per §6.2, with the literal commands and pasted output.
16. **Self-review** — written answers to the persona's checklist, with empirical proof (pasted command output, not checkboxes).
17. **Next steps** — concrete starting points if the session ends incomplete.

Sections 1, 4, 5, 8 (constraints from persona), and 15 (gate slot names) are deterministic from the task type and persona. The agent fills in everything else.

### 6.2 Validation gate slots

The framework declares the gate slots; the repo binds them to commands. The agent runs them and pastes output.

**Universal slots** (every task):

- `git-status` — only intended files changed
- `lint`
- `format`
- `typecheck`

**Code-producing tasks add:**

- `test`
- `dependency-validation` (architectural boundary check)
- `build`

**Optimisation adds:**

- `benchmark-before`
- `benchmark-after`
- `benchmark-comparison` — improvement on targeted metric, no regression elsewhere

**Migration adds:**

- `migration-coverage-check` — every call site listed in the plan was visited

**Bug Fix adds:**

- `regression-test` — test for the specific defect, fails before fix and passes after

**Spike replaces universal slots with:**

- `lint`, `typecheck` only — spike code is throwaway
- `spike-report-completeness` — the report answers the question

**Doc-producing tasks** (Research, Audit, Spec Authoring, Review, Documentation) **use:**

- `markdown-lint`
- `link-check`
- `citation-check` for Research only — every claim sourced

A repo that lacks a particular gate (e.g., no architectural validation tooling) marks the slot `n/a` with a one-line justification rather than silently skipping it.

---

## 7. Skill catalogue

The `.agents/skills/` tree must contain, at minimum:

```
.agents/skills/
├── documentation-gatekeeper.md   # always-loaded; sequencing rules
├── manage-task.md                # always-loaded; task-file authoring/maintenance
├── personas/
│   ├── builder.md
│   ├── debugger.md
│   ├── refactorer.md
│   ├── migrator.md
│   ├── optimiser.md
│   ├── janitor.md
│   ├── test-engineer.md
│   ├── researcher.md
│   ├── cartographer.md
│   ├── specifier.md
│   ├── skeptic.md
│   ├── spike-investigator.md
│   └── documenter.md
├── write/
│   ├── write-spec.md
│   ├── write-bug-report.md
│   ├── write-audit.md
│   ├── write-audit-brief.md
│   ├── write-migration-plan.md
│   ├── write-benchmark-report.md
│   ├── write-cleanup-list.md
│   ├── write-test-plan.md
│   ├── write-research-question.md
│   ├── write-research.md
│   ├── write-review-scope.md
│   ├── write-review-report.md
│   ├── write-spike-brief.md
│   └── write-spike-report.md
└── domain/
    └── (repo-specific, accumulates over time)
```

Two always-loaded skills, 13 persona skills, 14 write-skills. Domain skills accumulate as the team encounters areas where agents repeatedly violate constraints.

### 7.1 Persona profile format

```
---
name: <persona-name>
description: <one or two sentences — when this persona is the lead>
---

# Persona: <Display name>

## Role
What this persona is responsible for. One paragraph.

## Mindset
The frame the agent must adopt. Stated as imperatives.

## Hard rules
Numbered. No hedging.

## Forbidden actions
Numbered. The negative space — what this persona must never do, even if asked.

## Decision heuristics
Tiebreakers when rules don't directly apply.

## Checklist (before declaring done)
- [ ] ...
```

### 7.2 Write-skill format

Every `write-<type>` skill includes:

- **Purpose** — what good output of this type looks like, and what it protects against
- **Core rules** — numbered hard rules for authoring this doc type
- **What does not belong** — negative space; what to put elsewhere
- **Anti-patterns** — concrete failure modes with corrections

The existing `write-spec.md` and `write-audit.md` define the style.

---

## 8. Sequencing and directionality

Distillation is downhill only. Information flows from broad/external (research) to narrow/actionable (task) to terminal output. Reverse flow is forbidden.

### Allowed flows

```
research question → Research task → research file
research file → Spec Authoring task → spec → Feature Development → code
research file → Audit task (with audit brief) → audit → Refactor → code
audit brief → Audit task → audit → Refactor → code
spec (human-authored) → Feature Development → code
bug report → Bug Fix → code
migration plan → Migration → code
benchmark report → Optimisation → code
cleanup list → Cleanup → code
test plan → Test Authoring → tests
spike brief → Spike → spike report
review scope → Review → review report
task scope → Documentation → docs
```

### Forbidden flows

| Forbidden                                       | Why                                                                    |
| ----------------------------------------------- | ---------------------------------------------------------------------- |
| Research → implementation (skipping spec/audit) | Research is input. Implementation requires spec, audit, or bug report. |
| Code → spec (back-fill)                         | Specs are forward-looking. Narrating finished code is dishonest.       |
| Task with no source doc and no task scope       | Every task is grounded.                                                |
| One source doc → multiple task types            | The mapping is rigid. Split the work.                                  |
| Multiple source docs → one task                 | One source per task. Multiple sources = multiple tasks.                |
| Task file authored after implementation begins  | The task file is step one.                                             |
| Persona invented per session                    | Personas are catalogued.                                               |
| Durable findings left only in the task file     | Task files are gitignored. Migrate findings to audits/specs/research.  |

The `documentation-gatekeeper` skill enumerates these flows and refuses to allow forbidden ones.

---

## 9. Minimum scaffolding

A repo conformant with the framework contains, at minimum:

```
.
├── AGENTS.md                          # entry point: "first action is to read your task file in .agents/tasks/"
├── .gitignore                         # must include .agents/tasks/
└── .agents/
    ├── tasks/                         # gitignored; worktree-local
    ├── templates/
    │   ├── task-template.md
    │   ├── spec-template.md
    │   ├── audit-template.md
    │   ├── bug-report-template.md
    │   ├── migration-plan-template.md
    │   ├── benchmark-report-template.md
    │   ├── cleanup-list-template.md
    │   ├── test-plan-template.md
    │   ├── research-question-template.md
    │   ├── research-template.md
    │   ├── audit-brief-template.md
    │   ├── review-scope-template.md
    │   ├── review-report-template.md
    │   ├── spike-brief-template.md
    │   └── spike-report-template.md
    ├── skills/                        # see §7
    ├── specs/
    ├── bugs/
    ├── audits/
    ├── audit-briefs/
    ├── migrations/
    ├── benchmarks/
    ├── cleanups/
    ├── test-plans/
    ├── research/
    ├── research-questions/
    ├── reviews/
    ├── review-scopes/
    └── spikes/
```

Empty directories exist by convention so agents know where to place new artefacts without inventing locations.

---

## Constraints

1. **One source doc per task.** Multiple source docs require multiple tasks.
2. **One task type per source doc.** No source doc spawns more than one task type.
3. **One lead persona per task type.** No task type has multiple leads.
4. **Personas are catalogued, not invented.** Every persona referenced must exist as a profile.
5. **Validation gates are named slots.** Concrete commands are repo-specific.
6. **Task files are gitignored.** Durable findings migrate to audits/specs/research before session close.
7. **Distillation is downhill.** The gatekeeper enforces forbidden flows.
8. **Tool-agnostic.** The framework encodes no specific runtime, language, package manager, or agent CLI.
9. **The task is primary.** Source docs ground tasks; they do not replace them.

---

## Design decisions

### Decision: 13 task types, 13 personas, rigid 1-to-1

**Chosen:** Each task type has exactly one lead persona; each source-doc type grounds exactly one task type.

**Considered and rejected:**

- _Larger taxonomy with niche types_ (Algorithmist, Architect, Security Auditor as task leads, Hotfix as a separate task). Rejected: each collapsed into an existing type plus context. Hotfix is a Bug Fix with an urgent bug report. Security Fix is a Bug Fix where the bug is a vulnerability. Algorithm work is Feature Development with a tricky spec. Architecture is Spec Authoring with the Architect overlay.
- _N-to-M mapping with launch-time prompt_. Rejected: the decision of "is this audit a refactor or a feature?" should be made when the source doc is authored, not at task launch.

### Decision: Drop briefs that don't earn their keep

**Chosen:** No spec-brief, no design-brief, no doc-brief.

**Considered and rejected:** A separate brief for every task that produces a doc. Rejected because:

- _Spec-brief_ is just "here's the research/audit, write a spec from it." The research/audit is the source; no extra brief needed.
- _Design-brief_ would commission an Architecture Design task whose output is a design doc that then needs a spec-brief that produces a spec. Four-step ceremony for what's really "write a spec for this systemic change with the Architect persona."
- _Doc-brief_ over-formalises one-line scope ("update the README to reflect new export options") that fits naturally in the task file's Objective.

Briefs that survived (`audit-brief`, `research-question`, `spike-brief`, `review-scope`) carry real structure: scope, exit criteria, the question being asked. They earn their keep.

### Decision: Validation gates as named slots

**Chosen:** The framework names the slots; the repo binds commands.

**Considered and rejected:** Hardcoded `pnpm` / `cargo` / `npm` commands in templates. Rejected because it ties the framework to a stack.

### Decision: Task file is primary; source docs are grounding

**Chosen:** The task is the source of truth. Source docs ground the task. Light tasks can be launched from a task scope alone.

**Considered and rejected:** Requiring a separate source doc for every task. Rejected because Documentation, Reviews, and small Test additions don't carry enough durable structure to justify a separate file.

### Decision: Architecture work folds into Spec Authoring

**Chosen:** No standalone Architecture Design task. Systemic-impact specs are authored by the Specifier with the Architect persona consulted on boundary decisions inside the spec's `## Design decisions` section.

**Considered and rejected:** A separate design-brief → design-doc → spec-brief → spec chain. Rejected as ceremony — the substance is "write a spec for this big change with extra care about boundaries," which is one task, not three.

### Decision: Task files are gitignored

**Chosen:** `.agents/tasks/` is gitignored. Durable findings migrate to audits/specs/research.

**Considered and rejected:** Committing task files. Rejected because they're worktree-local execution scaffolding; committing them would couple branches in unhelpful ways and pollute history with decisions already captured durably elsewhere.

---

## Acceptance criteria

A repository conforms to the framework if and only if all of the following are true. Each is verifiable by file inspection.

- [ ] `AGENTS.md` exists at repo root and instructs any agent to read its task file in `.agents/tasks/<slug>.md` as its first action.
- [ ] `.agents/tasks/` exists and is listed in `.gitignore`.
- [ ] `.agents/templates/` contains a template for every source-doc type in §5 plus the master task template plus the terminal-doc templates (research, review report, spike report).
- [ ] `.agents/skills/personas/` contains a profile for each of the 13 personas in §4, each in the format defined in §7.1.
- [ ] `.agents/skills/write/` contains a `write-<type>.md` skill for every doc type that needs authoring guidance (14 in total per §7).
- [ ] `.agents/skills/manage-task.md` and `.agents/skills/documentation-gatekeeper.md` exist.
- [ ] All source-doc directories listed in §5 exist (even if empty).
- [ ] The master task template includes every section listed in §6.1 in order.
- [ ] Every persona profile includes the six subsections required in §7.1.
- [ ] Every `write-<type>` skill includes the four subsections in §7.2.
- [ ] The gatekeeper skill enumerates by name every persona, every source-doc type, and every forbidden flow.
- [ ] No persona profile names an Orchestrator / Lead Engineer / Delegator role.
- [ ] A test task file generated for each of the 13 task types loads cleanly: it links the correct persona, the correct supporting skills, the correct validation gate slots, and (where applicable) the correct source-doc reference.

---

## Open questions

- [ ] **[MINOR]** Whether the Architect deserves a place in the persona catalogue as a secondary/overlay persona for systemic Spec Authoring tasks, or whether the Specifier persona is enough on its own with extra `[CRITICAL]` open questions for boundary decisions.
- [ ] **[MINOR]** Whether `cleanup` and `refactor` should fold (they share a lot of mindset). Default: keep separate because the rules differ — Janitor proves safety of deletion, Refactorer proves preservation of behaviour. If real usage shows they collapse in practice, fold.
- [ ] **[MINOR]** Whether `test plan` is overkill for small Test Authoring tasks. Default: when the scope fits in the task file's Objective, skip the test-plan doc. The framework allows this.
- [ ] **[MINOR]** Where repo-specific gate command bindings live (inside `AGENTS.md`, in a separate file). Defer until first repo bootstrap; the framework only requires the bindings exist somewhere the agent can find.

No `[CRITICAL]` open questions remain.

---

## Tradeoffs and risks

**Risk: Persona proliferation produces decision fatigue.**
13 personas is a lot to navigate. _Mitigation:_ the task-type-to-persona mapping is rigid, so the agent never chooses; the framework chooses for them.

**Risk: The 1-to-1 mapping is too rigid for some real cases.**
A repo might have a doc that legitimately spans bug-fix-and-feature. _Mitigation:_ split it. Two source docs, two tasks. The cost of splitting is lower than the cost of ambiguity.

**Risk: Task scope as source for Documentation/Review/small Test tasks introduces a soft boundary.**
The line between "fits in task scope" and "needs a separate doc" is judgement-based. _Mitigation:_ the gatekeeper provides a heuristic — if the source has structured content (lists of items, repro steps, target metrics, acceptance criteria), it needs a separate doc; if it's a paragraph of prose, task scope is enough.

**Risk: The gatekeeper skill is the linchpin and can rot.**
If the gatekeeper falls behind the catalogues, it stops enforcing real rules. _Mitigation:_ the gatekeeper enumerates by name every persona and every source-doc type. A test in the acceptance criteria verifies this enumeration is current.

**Risk: Distillation is unidirectional, but real understanding sometimes requires reversing.**
Implementing a feature occasionally reveals the spec was wrong. _Mitigation:_ when this happens, the agent halts, records a finding, updates the spec, and resumes. The update is an explicit upstream edit, not a downstream improvisation. The chain stays acyclic.

**Risk: The framework doesn't help repos that have no source docs yet.**
A greenfield repo has no specs, no audits — just a feature request. _Mitigation:_ the first task in such a repo is often Spec Authoring, launched from a research file or directly from a written user prompt captured in the task file's Objective. The framework supports this; it just requires the spec to exist before Feature Development begins.
