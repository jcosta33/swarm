# Spec: Swarm framework repository

## Context

This spec defines the structure and contents of the **Swarm framework repository** — the canonical home for the Swarm agentic documentation framework. The CLI lives in a separate repository; this repo is documentation, scaffold artifacts, examples, and conformance tooling only. No CLI code lives here.

The framework already has substantial source material: an existing research prompt, a documentation report on agent docs (AGENTS.md, skills vs `docs/`, repo organization), a set of generic scaffold artifacts (AGENTS.md template, CLAUDE.md / GEMINI.md aliases, three cross-cutting skills, the personas skill, the flow graph reference, ten task templates), and conversational decisions about terminology, taxonomy, and design. All of that material is the input to this work. None of it should be lost in the writing pass.

The implementing agent's job is to take that material, organize it into the structure defined below, and expand it into the canonical framework documentation. Expansion is the operative word: the inputs are the floor, not the ceiling.

---

## Goal

A repository that, when complete, is the reference shape for agentic documentation frameworks. A project author can read it and adopt Swarm in their codebase. A framework author can read it and understand every design decision well enough to extend or fork. A new contributor can read it and find their footing without asking. A casual visitor can grasp the value proposition in under five minutes from the README alone.

Two simultaneous quality bars apply: **rigor** (every claim grounded, every decision justified, no content lost from the input material) and **progressive disclosure** (broad strokes accessible in seconds, full depth available when wanted, the depth never blocking the surface).

---

## Scope

**In scope:**

- The full directory structure of the framework repo
- The contents of every file in `docs/` (concepts, guides, reference, examples)
- The contents of every file in `scaffold/` (the literal artifacts that get installed in consumer repos)
- The contents of `examples/` (three fully populated example projects in different languages)
- The contents of `conformance/` (test suite that validates Swarm-compliance)
- Top-level repo files: README, CONTRIBUTING, CHANGELOG, LICENSE, MIGRATIONS, DEPRECATIONS
- Architecture Decision Records (ADRs) for the framework's significant design choices
- A design principles document and a non-goals document
- A persona × doc-type × task-type compatibility matrix as first-class reference

**Non-goals (explicitly out of scope):**

- The Swarm CLI implementation — lives in a separate repo
- `swarm.config.yaml` schema or content — CLI-specific concern
- TUI design — CLI-specific concern
- Worktree mechanics, process management, agent CLI launching — CLI-specific concern
- Logos, branding, marketing materials — premature
- A static documentation site — out of scope for v1; the docs work as Markdown alone
- Internationalization — premature
- Plugin or extension API — premature

---

## Hard rules for the implementing agent

These are non-negotiable. Violating any of them invalidates the work.

### Rule 1: No content loss from input material

The framework already has substantial written material. The implementing agent must:

- Read every input artifact end-to-end before writing
- Preserve every section, rule, anti-pattern, checklist item, and example from the input
- Move content to its proper location in the new structure rather than dropping it
- When two inputs overlap, merge them — never drop one for the other
- When in doubt about whether to keep a piece of content, keep it

The deliverable is **larger and more detailed** than the inputs, never smaller. Compression is forbidden; expansion and refinement is mandatory.

### Rule 2: Progressive disclosure at every level

Every file at every depth must support the following reading patterns simultaneously:

- **The 30-second skim** — first paragraph or first heading section delivers the core point
- **The 5-minute read** — the document's structure surfaces the essentials without the tangents
- **The 30-minute deep dive** — the full content is available below, organized so the reader can drill into the parts they care about

Concretely, this means:

- Every document opens with a TL;DR or summary paragraph that captures the load-bearing claim
- Every document has a clear hierarchy: high-level claims → supporting structure → details → examples → references
- Detail and depth never block the surface; a reader who only reads the first screen of a doc gets the point
- Drill-down content is real and complete, not stubbed — but it lives below the surface, not within it
- Cross-references between docs replace duplicated detail; depth lives where it belongs and is referenced from where it's mentioned

### Rule 3: The framework is the substance, the writing is the medium

This is documentation as much as design work. The implementing agent is not just transcribing — they are deeply understanding the framework and rendering that understanding in prose another reader can pick up. Bad writing wastes the framework. Specifically:

- Plain declarative statements; avoid hedge words unless genuinely uncertain
- Specific over general; cite the file or section when making a claim
- Lead with the load-bearing finding, then explain
- Examples earn their place in proportion to the difficulty of the concept
- The tone is the existing source material's tone — direct, opinionated, unhedged. Match it.

### Rule 4: Match the framework's voice and conventions

The existing scaffold material defines a set of conventions: XML-style content tags (`<acceptance_criteria>`, `<bug_description>`, `<root_cause>`, etc.), `> ⚠️` and `> 🔒` callouts, `> **PERSONA:**` blockquotes, hard-gate Self-review with paste-the-output requirements, "Show, Don't Tell," "Halt on Ambiguity," `[CRITICAL]` / `[MINOR]` open question tags, `[pending]` / `[confirmed]` assumption tags, `{{cmdX}}` placeholder syntax. Every new template, skill, and document the agent produces must match these conventions.

### Rule 5: Language- and runtime-agnostic, always

Every framework-level artifact must be free of project-specific content. No TypeScript references, no `pnpm` commands, no `Tailwind`, no React. The framework works for Python, Rust, Go, anything. Where a placeholder is needed (validation command, install command), use the `{{cmdX}}` syntax. Where examples are useful, put them in `examples/` (which _can_ be language-specific) or mark them clearly as "example only — your project's conventions vary."

The exception is the three example projects in `examples/` — those are explicitly populated and language-specific, demonstrating what the framework looks like in practice.

---

## The directory structure

```
swarm/
├── README.md                              ← the front door
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
├── MIGRATIONS.md                          ← how to upgrade between framework versions
├── DEPRECATIONS.md                        ← what's slated for removal, with timeline
├── PRINCIPLES.md                          ← load-bearing design constraints
├── NON-GOALS.md                           ← what Swarm explicitly is not
│
├── docs/                                  ← the framework: concepts, guides, reference, examples
│   ├── README.md                          ← docs landing page / table of contents
│   │
│   ├── concepts/                          ← why and what — the framework's ideas
│   │   ├── 01-introduction.md
│   │   ├── 02-conditioning-pipeline.md
│   │   ├── 03-distillation.md
│   │   ├── 04-personas.md
│   │   ├── 05-document-types.md
│   │   ├── 06-task-types.md
│   │   ├── 07-flow-graph.md
│   │   ├── 08-recursion-and-delegation.md
│   │   └── 09-empirical-proof.md
│   │
│   ├── guides/                            ← how — task-shaped instruction
│   │   ├── adopting-swarm.md
│   │   ├── writing-a-skill.md
│   │   ├── writing-a-spec.md
│   │   ├── writing-an-audit.md
│   │   ├── writing-a-bug-report.md
│   │   ├── writing-research.md
│   │   ├── customizing-personas.md
│   │   ├── monorepo-setup.md
│   │   └── extending-the-framework.md
│   │
│   ├── reference/                         ← lookup — the canonical answers
│   │   ├── persona-catalogue.md
│   │   ├── document-types.md
│   │   ├── task-types.md
│   │   ├── skill-library.md
│   │   ├── flow-graph.md
│   │   ├── compatibility-matrix.md        ← the persona × doc × task matrices
│   │   ├── template-placeholders.md       ← the framework's placeholder contract
│   │   └── glossary.md
│   │
│   ├── examples/                          ← worked walkthroughs (in prose, not full projects)
│   │   ├── feature-walkthrough.md
│   │   ├── refactor-walkthrough.md
│   │   ├── bug-fix-walkthrough.md
│   │   ├── research-to-spec-walkthrough.md
│   │   └── orchestration-walkthrough.md
│   │
│   └── adrs/                              ← Architecture Decision Records
│       ├── README.md                      ← what ADRs are, how they're used here
│       ├── 0001-four-doc-types.md
│       ├── 0002-personas-1-to-1-with-task-types.md
│       ├── 0003-distillation-is-unidirectional.md
│       ├── 0004-task-files-are-gitignored.md
│       ├── 0005-placeholder-syntax.md
│       ├── 0006-skeptic-owns-fix-tasks.md
│       ├── 0007-bug-report-as-meta-task.md
│       ├── 0008-empirical-proof-as-framework-primitive.md
│       └── … (more as decisions accumulate)
│
├── scaffold/                              ← literal artifacts copied into consumer repos
│   ├── README.md                          ← what's in here, how it gets installed
│   ├── AGENTS.md                          ← root agent brief (with TODO markers)
│   ├── CLAUDE.md                          ← @AGENTS.md import
│   ├── GEMINI.md                          ← AGENTS.md reference
│   ├── .gitignore.additions               ← lines to append to consumer's .gitignore
│   │
│   ├── docs/
│   │   └── agents/                        ← human-facing process docs that ship with every project
│   │       ├── 01-process.md
│   │       ├── 02-file-types.md
│   │       ├── 03-workflow.md
│   │       ├── 04-standards.md
│   │       └── 05-flow-graph.md
│   │
│   └── .agents/
│       ├── skills/
│       │   ├── manage-task/SKILL.md
│       │   ├── documentation-gatekeeper/SKILL.md
│       │   ├── personas/SKILL.md
│       │   ├── distillation-discipline/SKILL.md
│       │   ├── empirical-proof/SKILL.md
│       │   ├── adversarial-review/SKILL.md
│       │   ├── write-spec/SKILL.md
│       │   ├── write-audit/SKILL.md
│       │   ├── write-research/SKILL.md
│       │   ├── write-bug-report/SKILL.md
│       │   ├── write-feature/SKILL.md
│       │   ├── write-fix/SKILL.md
│       │   ├── write-refactor/SKILL.md
│       │   └── write-rewrite/SKILL.md
│       │
│       └── templates/
│           ├── spec.md
│           ├── audit.md
│           ├── bug-report.md
│           ├── research.md
│           ├── skill.md
│           ├── task-base.md               ← shared task skeleton; type-specific templates extend it
│           ├── task-feature.md
│           ├── task-fix.md
│           ├── task-refactor.md
│           ├── task-rewrite.md
│           ├── task-research.md
│           ├── task-audit.md
│           ├── task-bug-report.md
│           ├── task-migration.md
│           ├── task-performance.md
│           ├── task-testing.md
│           ├── task-documentation.md
│           ├── task-orchestration.md
│           └── task-review.md
│
├── examples/                              ← real fully-Swarm-compliant example projects
│   ├── README.md
│   ├── typescript-monorepo/               ← worked example, every file populated
│   ├── python-library/                    ← shows scaffold in non-TS context
│   └── rust-cli/                          ← another non-TS example
│
├── conformance/                           ← tests that validate Swarm-compliance
│   ├── README.md
│   ├── checker/                           ← the validator (shell or TS, to be decided)
│   ├── fixtures/
│   │   ├── valid/                         ← projects that should pass
│   │   └── invalid/                       ← projects that should fail, with expected errors
│   └── rules.md                           ← human-readable spec of every conformance rule
│
└── .github/
    ├── workflows/
    └── ISSUE_TEMPLATE/
```

---

## File-by-file requirements

### Top-level

#### `README.md`

The single highest-leverage document in the repo. A casual visitor decides in 30 seconds whether to keep reading.

Required structure:

1. **One-sentence definition** at the very top: "Swarm is an agentic documentation framework — a structured way to condition coding agents for the work they do."
2. **The conditioning pipeline diagram** — the source-doc → task type → persona → conditioned task file flow, rendered as a Mermaid or ASCII diagram, in the first screen
3. **What's in this repo** — a 5-line map (`docs/`, `scaffold/`, `examples/`, `conformance/`)
4. **Quickstart** — three to five steps that get a reader to "I see what this looks like in practice." Point to one example project. No CLI required to follow along.
5. **Is this for you?** — clear inclusion and exclusion. Who benefits, who doesn't.
6. **Status and stability** — what version, what's stable, what's evolving
7. **Links** to the conceptual docs for those who want depth, to the CLI repo for those who want automation, to CONTRIBUTING for those who want to help

Match the brevity of high-quality framework READMEs (Diátaxis, Spec Kit). Verbose READMEs lose the room.

#### `LICENSE`

Standard. Match the project's chosen license (MIT or Apache-2 expected).

#### `CONTRIBUTING.md`

How to propose changes. Required sections:

- How to file an issue
- How to propose a new persona, task type, or doc type (these are framework-level changes; the bar is high)
- How to propose a new ADR
- How to update scaffold artifacts (and how that affects MIGRATIONS.md)
- Code of conduct reference

#### `CHANGELOG.md`

Keep-a-Changelog format with one mandatory addition: a **"Scaffold changes"** subsection per release. Consumers track this section to know when to update their installed scaffold.

#### `MIGRATIONS.md`

Per minor and major version, a guide for upgrading consumer projects. Format:

```
## v1.2 → v1.3

### Scaffold changes
- New skill: `write-migration` added to scaffold/.agents/skills/
- Updated template: task-refactor.md now includes <shim_contracts> table
- Renamed: ...

### Required actions
- [ ] Copy new skill into your project's .agents/skills/
- [ ] Update task-refactor.md template if you've customized it
- [ ] ...

### Optional but recommended
- ...
```

Every version that touches the scaffold gets an entry. Versions that only touch `docs/` or `examples/` may be light or skipped.

#### `DEPRECATIONS.md`

Anything currently slated for removal, with the version it was deprecated in, the reason, the planned removal version, and the migration path.

#### `PRINCIPLES.md`

The load-bearing design constraints. Five to ten principles, each with a one-sentence statement and a paragraph of justification. Examples (the agent should write the actual list — these are illustrative):

- "Documentation-first, not tooling-first."
- "Language- and runtime-agnostic at the framework level."
- "Distillation flows downhill only."
- "Personas are 1-to-1 with task types until proven otherwise."
- "Empirical proof is non-negotiable across all personas."
- "The task is the source of truth; source documents ground it."
- "Skills are progressively disclosed; AGENTS.md only carries universal invariants."

The principles are tiebreakers when contributors disagree. Write them so they actually decide cases.

#### `NON-GOALS.md`

What Swarm explicitly will not do. The companion to PRINCIPLES.md. Examples (illustrative):

- "Swarm does not run inference; it conditions agent CLIs that do."
- "Swarm does not enforce a specific test runner, package manager, or language."
- "Swarm does not provide an agent runtime."
- "Swarm does not solve long-context coherence."
- "Swarm does not include a TUI, CLI, or any executable artifact in the framework repo."

---

### `docs/concepts/`

Each concept document follows the progressive disclosure rule: TL;DR at the top, structure that surfaces essentials, full depth below. Every concept doc has a "See also" footer linking to relevant guides, reference docs, and ADRs.

#### `01-introduction.md`

What Swarm is, why it exists, what problem it solves, who it's for. The "why" document. The reader leaves understanding the _value proposition_ — the rest of the docs explain the _mechanism_.

Required content (drawn from the existing source material):

- The problem statement: agentic dev fails in predictable ways (drift, conflict with existing architecture, no resumable trail, hallucinated completion)
- Swarm's response: a documentation-first conditioning framework
- The core conditioning pipeline at a high level (no exhaustive routing yet)
- The framework / CLI distinction
- A clear positioning relative to prior art (Spec Kit, Diátaxis, Anthropic Skills, agent runtimes)
- "What this is not" — pointer to NON-GOALS.md

#### `02-conditioning-pipeline.md`

The framework's central mechanism. Source document → task type → persona → conditioned task file (with skills and verification commands attached).

Required content:

- The pipeline as a diagram
- Each stage in detail with examples
- The deterministic-routing claim and how it's enforced
- The override semantics (when and how a user changes the routing)
- Recursion at each stage
- Cross-reference to the flow graph (concept) and the routing rules (reference)

#### `03-distillation.md`

Verbosity gradient, lossless distillation, doc lifecycle. The discipline that prevents content loss between stages.

Required content (preserve all from the existing distillation-discipline skill, expanded):

- The verbosity gradient (research → spec/audit/bug-report → task)
- What "lossless" means in practice
- The four tests (requirements, behavior, edge case, empirical)
- The "research is optional" rule
- The promotion protocol (task findings to durable docs)
- The lifecycle of each doc type (in-progress → resolved/done)
- Worked examples of distillation done right and done wrong

#### `04-personas.md`

Why personas, how they differ from roles, how they compose. The conceptual frame; the catalogue lives in reference.

Required content:

- The case for persona-as-mindset rather than persona-as-role
- The 1-to-1 with task types decision (link to ADR)
- How personas hand off to each other
- The recursion in the orchestration pattern (Lead Engineer with workers)
- Cross-reference to persona catalogue (reference) and the personas skill (scaffold)

#### `05-document-types.md`

Why four types and not fewer or more. The epistemic-stance argument: spec is forward-looking and prescriptive, audit is present-looking and observational, bug-report is past-looking and evidential, research is outward-looking and citational. The unification question — should they all be specs of a particular type? — addressed and answered.

Required content (this draws from the explicit conversation about whether to unify doc types — preserve that reasoning):

- The four epistemic stances and what makes each distinct
- The shared skeleton (BaseDocument concept) and where it factors out
- Why unification was considered and rejected
- The lifecycle of each doc type
- Cross-reference to document types (reference) and the four authoring skills

#### `06-task-types.md`

The full task-type taxonomy and why each one earns its place. The 1-to-1 with personas rule. The handoff conventions.

Required content:

- The full list (feature, fix, refactor, rewrite, spec-writing, research-writing, audit-writing, bug-report-writing, migration, performance, testing, documentation, review, deepen-audit, orchestration, integration, upgrade, kickback)
- Why each one is distinct from its neighbors (refactor vs rewrite, fix vs debugging, refactor vs migration, etc.)
- The shared task skeleton and how type-specific templates extend it
- Cross-reference to task types (reference) and the templates (scaffold)

#### `07-flow-graph.md`

The deterministic mapping at the conceptual level (the operational reference is in `docs/reference/flow-graph.md`).

Required content:

- The full edge list (doc type → task type → persona)
- The forbidden flows (research → implementation skipping spec, code → spec back-fill, etc.)
- Edge cases (ambiguous source doc, no source doc, multiple source docs)
- The kickback loop
- Recursion in delegation
- Cross-reference to the operational flow graph (reference)

#### `08-recursion-and-delegation.md`

The Lead Engineer pattern. Recursive Swarm-in-Swarm (renamed to "delegation" or "sub-orchestration" for clarity). The merge protocol, the kickback protocol, the parallelism semantics.

Required content:

- The conceptual model (a task can spawn sub-tasks; the conditioning pipeline runs recursively)
- The Lead Engineer's worker tracker and merge log
- The Skeptic stance for the merge gate
- The recursion-limit decision (link to ADR)
- Failure modes (worker crash, empty diff, divergent merges)

#### `09-empirical-proof.md`

The Show Don't Tell discipline. The hard-gate Self-review. The framework's response to hallucinated completion.

Required content (preserve all from the existing empirical-proof skill, expanded):

- The failure mode being defeated (confident-but-unfounded "done")
- The core rules (run, capture, paste; one verification per claim; re-run after change)
- What proof looks like (good examples, bad examples)
- Where proof lives (the Self-review verification block)
- Type-specific proof requirements (refactor, performance, etc.)

---

### `docs/guides/`

Task-shaped, present-tense, imperative. Each guide answers "how do I do X" with a complete walkthrough.

#### `adopting-swarm.md`

Step-by-step: a project author starting from a non-Swarm repo, how do they bring Swarm in. Manual install (no CLI required). Where files go. What to fill in. How to verify the install is correct (point to conformance checker).

#### `writing-a-skill.md`

How to write a project-specific skill. The frontmatter contract, the description-triggers-loading rule, the format, examples of good and bad descriptions. When to write a skill vs add to AGENTS.md vs add to `docs/`.

#### `writing-a-spec.md`, `writing-an-audit.md`, `writing-a-bug-report.md`, `writing-research.md`

One per authoring task. Walk through the corresponding template, show what good filled-in versions look like, link to the corresponding `write-*` skill. These guides reference the templates, the skills, and the reference docs — they don't duplicate them.

#### `customizing-personas.md`

How to override the default persona for a task type. How to add a project-specific persona. The bar for adding a persona to the framework itself (link to CONTRIBUTING).

#### `monorepo-setup.md`

Nested AGENTS.md, the closest-wins rule, workspace conventions. Concrete example of a multi-package repo with different stacks per workspace.

#### `extending-the-framework.md`

The contributor's-eye view of how the framework grows. New doc types, new task types, new personas, new placeholders. The conformance impact of each. The bar for accepting a proposal.

---

### `docs/reference/`

Lookup material. Dense, exhaustive, structured for skimming. Every reference doc has a TOC at the top.

#### `persona-catalogue.md`

The 13 personas in full. Built from the existing personas skill, expanded with cross-references to the docs they consume and produce, the task types they own, the skills they auto-attach. Per-persona structure matches the format in the existing personas skill exactly.

#### `document-types.md`

The four doc types in full. Per type: purpose, when to create, where it lives, required sections, completion criteria, authoring persona, downstream task types, lifecycle. Built from the existing `02-file-types.md` content, expanded.

#### `task-types.md`

Every task type with its full metadata: source documents, default persona, secondary personas, attached skills, verification commands, type-specific Self-review questions, common anti-patterns. Built from the existing task templates, with the metadata extracted into reference form.

#### `skill-library.md`

Every skill the framework ships, with its description, purpose, and trigger conditions. Cross-references to `scaffold/.agents/skills/` for the actual skill files. The agent must distinguish _cross-cutting framework skills_ (manage-task, documentation-gatekeeper, distillation-discipline, empirical-proof, adversarial-review, personas) from _authoring skills_ (write-spec, write-audit, write-research, write-bug-report, write-feature, write-fix, write-refactor, write-rewrite).

#### `flow-graph.md`

The operational version of the flow graph. The full edge list, the persona attachment table, the skill attachment table, the verification command attachment table, the edge cases, the recursion rules, the kickback rules. Built from the existing `05-flow-graph.md` artifact, expanded. Tables and diagrams; minimal prose.

#### `compatibility-matrix.md`

The persona × doc-type, persona × task-type, doc-type × task-type matrices. Three printable tables. Designed to be the single most-referenced document in the repo.

#### `template-placeholders.md`

The framework's placeholder contract — the interface a CLI or runner must honor. Required content:

- Every recognized `{{...}}` placeholder
- Each placeholder's semantics (what it represents, how it should be filled)
- Required vs optional placeholders per task type
- Reserved namespace rules (so CLIs can extend without colliding)
- The split between _command placeholders_ (`{{cmdInstall}}`, `{{cmdValidate}}`, etc.) and _scaffolding placeholders_ (`{{slug}}`, `{{branch}}`, `{{worktreePath}}`, etc.)
- The conformance rule: a runner is Swarm-compliant if it honors the placeholder contract

This document is what makes the framework usable by tools other than the Swarm CLI. It must be exhaustive and precise.

#### `glossary.md`

Every term the framework uses, defined precisely. Built from the terminology discussion in the source material — preserve the distinctions that were drawn (task vs task file, persona vs role vs agent, document vs documentation, conditioning vs configuration, distillation vs summarization, source doc vs grounding doc, etc.). Cross-reference to the concept doc that introduces each term.

---

### `docs/examples/`

Worked walkthroughs in prose. Different from `examples/` (which is full example projects); these are narrative explanations of "here's what a feature workflow looks like end-to-end" using a hypothetical scenario. Each walkthrough renders the framework's mechanics concretely.

Structure for each walkthrough:

1. The scenario (what's the human's ask, what's the starting state)
2. The doc that grounds the work (a representative spec / audit / bug-report)
3. The task file the launcher would scaffold (with all placeholders resolved to plausible values)
4. The session itself — what the agent does, what the persona constrains, what the Self-review looks like
5. The handoff (review, merge, audit update)
6. What changed in the durable docs as a result

Five walkthroughs:

- `feature-walkthrough.md` — spec to merged feature
- `refactor-walkthrough.md` — audit to merged refactor
- `bug-fix-walkthrough.md` — bug report to merged fix
- `research-to-spec-walkthrough.md` — research file becoming a spec, then a feature task
- `orchestration-walkthrough.md` — Lead Engineer with five parallel workers

---

### `docs/adrs/`

Architecture Decision Records for the framework's significant design choices. Standard ADR format (Michael Nygard's): Title, Status, Context, Decision, Consequences. The agent must seed the ADR log with at least the following decisions, drawn from the source material's reasoning:

1. **0001-four-doc-types.md** — Why four document types (spec, audit, research, bug-report) and not fewer or more. Why unification into "specs of a particular type" was considered and rejected.
2. **0002-personas-1-to-1-with-task-types.md** — Why each task type has exactly one default persona, and why this isn't a many-to-many mapping.
3. **0003-distillation-is-unidirectional.md** — Why information flows downhill only; why back-filling specs from finished code is forbidden.
4. **0004-task-files-are-gitignored.md** — Why task files don't get committed; the worktree-local convention.
5. **0005-placeholder-syntax.md** — Why `{{cmdX}}` and not `${cmdX}` or some other form. The contract this defines for runners.
6. **0006-skeptic-owns-fix-tasks.md** — Why fix tasks adopt the Skeptic persona rather than a dedicated Fixer.
7. **0007-bug-report-as-meta-task.md** — Why bug-report-writing is a separate meta-task that produces a document, with the fix happening in a downstream task.
8. **0008-empirical-proof-as-framework-primitive.md** — Why "Show Don't Tell" is a framework-level rule rather than per-persona advice.

The agent should add more ADRs as warranted by the decisions in the source material — there are likely 12 to 20 worth recording. Read the conversational source material carefully; every decision that has a "considered and rejected" alternative deserves an ADR.

ADRs are _not_ the place for hand-wringing. Each ADR is decisive: here's what we chose, here's why, here's what we considered, here's the consequence. Every ADR's Status starts as "Accepted" unless explicitly proposed-but-not-adopted.

---

### `scaffold/`

The literal artifacts a project copies in to become Swarm-compliant. This directory mirrors what the consumer's repo looks like at the relevant paths.

Existing source material to preserve and expand:

- `AGENTS.md` (generic version with TODO markers — already drafted)
- `CLAUDE.md`, `GEMINI.md` (alias files — already drafted)
- `.gitignore.additions` (must include `.agents/tasks/` and any other framework-level gitignores)
- The five `docs/agents/` process docs (preserve all content from the existing `01-process.md`, `02-file-types.md`, `03-workflow.md`, `04-standards.md`, plus the new `05-flow-graph.md`)
- All shipped skills (the six framework-level cross-cutting skills are partly drafted; the eight authoring skills `write-spec`, `write-audit`, `write-research`, `write-bug-report`, `write-feature`, `write-fix`, `write-refactor`, `write-rewrite` need writing — `write-spec` and `write-audit` already exist and must be preserved verbatim)
- All task templates (the existing `task.md`, `task-feature.md`, `task-fix.md`, `task-refactor.md`, `task-spec.md` plus the ten new templates already drafted: `task-research`, `task-audit`, `task-bug-report`, `task-rewrite`, `task-migration`, `task-performance`, `task-testing`, `task-documentation`, `task-orchestration`, `task-review`)
- All doc templates (`spec.md`, `audit.md`, `bug-report.md`, `research.md`, `skill.md`)

The agent must produce a `task-base.md` template that captures the shared task skeleton (Metadata, Objective, Linked docs, Constraints, Progress checklist, Decisions, Findings, Assumptions, Blockers, Next steps, Self-review). The type-specific templates conceptually "extend" this base — in practice, since markdown has no inheritance, each type-specific template repeats the base sections plus its own additions, and the base file documents which sections every task template should contain.

Same for documents: the agent produces a base document skeleton documented in `scaffold/.agents/templates/` showing the shared sections (Context, Linked docs, Open questions, Decisions, etc.) that all four doc templates include.

`scaffold/README.md` explains the install procedure, the mirror-the-paths convention, and the placeholder contract (with a pointer to `docs/reference/template-placeholders.md`).

---

### `examples/`

Three full example projects demonstrating Swarm-compliance in different language ecosystems.

Each example project is a complete project skeleton — directory structure, source files (minimal but plausible), AGENTS.md filled in, `.agents/` populated with at least one filled-in spec, audit, research file, and bug report, a few sample task files (some completed, some in progress), and a believable codebase that gives the docs something to refer to.

The three examples:

- **`typescript-monorepo/`** — multi-package TS repo with nested AGENTS.md, real `swarm.config.yaml` content (yes, the example _can_ show this even though it's a CLI artifact — flag it as "what a CLI consumer would generate"), realistic verification commands using `pnpm`
- **`python-library/`** — single-package Python project, pytest, ruff, mypy
- **`rust-cli/`** — Rust binary crate, cargo, cargo-deny

Each example has its own `README.md` explaining what it demonstrates and how to read it. The examples also serve as fixtures for the conformance checker — running the checker against any of them must pass.

---

### `conformance/`

The test suite that validates Swarm-compliance.

#### `conformance/README.md`

What conformance means, how to run the checker, what failures look like.

#### `conformance/checker/`

The validator. The agent should propose an implementation language (TypeScript script with no runtime dependencies preferred, since the framework repo otherwise has no code; pure shell with `find` and `grep` is acceptable; Python is a fallback). The checker takes a path to a project directory and produces:

- A list of conformance violations with file:line references
- A pass/fail exit code

The checker validates:

- Required directories exist (`.agents/`, `.agents/skills/`, `.agents/templates/`, `docs/agents/`)
- AGENTS.md exists and contains the four mandatory sections
- All shipped skills are present in `.agents/skills/`
- All shipped templates are present in `.agents/templates/`
- Skill files have valid frontmatter (`name`, `description`)
- Task templates use only recognized placeholders (per `docs/reference/template-placeholders.md`)
- `.gitignore` includes `.agents/tasks/`
- (More rules as the agent identifies them)

#### `conformance/fixtures/valid/`

At least three projects that should pass conformance, including the three example projects from `examples/` (or symlinks to them).

#### `conformance/fixtures/invalid/`

At least eight projects that should fail conformance, each demonstrating a different violation:

- Missing `AGENTS.md`
- Missing required skill
- Skill with no frontmatter
- Task template with unrecognized placeholder
- Task files committed (not gitignored)
- Doc template missing required section
- (More violations the agent identifies)

Each invalid fixture has a `EXPECTED_ERRORS.md` file listing the violations the checker should report.

#### `conformance/rules.md`

Human-readable specification of every conformance rule, with:

- Rule ID (e.g., `R001`)
- Rule statement
- Rationale
- How to fix
- Example violation
- Severity (`MUST`, `SHOULD`, `MAY` — RFC 2119 conventions)

The checker's reports use the rule IDs so violations are looked-up-able.

---

## Constraints

These apply to the implementing agent throughout.

- **Match the framework's voice in every produced document.** Direct, opinionated, unhedged. The existing source material is the style reference.
- **Preserve every section, rule, anti-pattern, and example from the input material.** Compression is forbidden; expansion is mandatory. When in doubt, keep the content.
- **Progressive disclosure at every level.** TL;DR up top, structure surfaces essentials, depth available below.
- **Cross-references over duplication.** When two docs cover related material, one is canonical and the other links to it.
- **No CLI content.** No mentions of `swarm.config.yaml` schema, no TUI references, no process management, no agent CLI invocation mechanics. Pointer to "the CLI repo" is acceptable; describing the CLI's behavior is not.
- **Language- and runtime-agnostic at framework level.** Project-specific content is permitted only in `examples/`.
- **Cite ADRs from concept docs.** When a concept doc states a decision, link to the ADR. ADRs are the receipts; concept docs are the explanation.
- **Every cross-reference is real.** No `TODO: link to X` placeholders left in delivered files. If a referenced document doesn't exist yet, write a stub with the section structure and mark it `[STUB]` so it's visible in conformance.
- **No content lost from input material.** Every existing template, skill, document, and conversational decision must survive, possibly reorganized but never dropped.

---

## Design decisions

Several decisions are already made and the implementing agent must respect them. They are not open for revisiting in this work.

### Decision: Four document types, not unified

**Chosen:** Spec, audit, research, bug-report remain as four distinct document types with different epistemic stances.

**Considered and rejected:** Unifying into a single "document with kind discriminator" type. Rejected because the four types have distinct ways of being wrong, distinct lifecycles, distinct failure modes the corresponding `write-*` skill is built to prevent, and distinct routing targets — collapsing them either fattens a single discipline beyond usefulness or thins it past the point where it catches the failure modes.

ADR: `0001-four-doc-types.md`.

### Decision: Personas 1-to-1 with task types

**Chosen:** Each task type has exactly one default primary persona; secondary personas attach for handoff (e.g., the Skeptic reviews after a Builder task). `swarm.config` (the CLI's concern) may override the primary persona per task type, but the framework default is 1-to-1.

**Considered and rejected:** Many-to-many mapping requiring runtime selection. Rejected because the determinism is the value — adopters get the auto-conditioning benefit only if the routing is unambiguous.

ADR: `0002-personas-1-to-1-with-task-types.md`.

### Decision: Distillation is unidirectional

**Chosen:** Information flows research → spec/audit/bug-report → task, never reverse. Task findings can promote to durable docs, but specs are not back-filled from finished code.

**Considered and rejected:** Allowing spec generation from implemented code as a documentation-of-what-was-built artifact. Rejected because it conflates spec (forward-looking, prescriptive) with documentation (descriptive, after-the-fact).

ADR: `0003-distillation-is-unidirectional.md`.

### Decision: `swarm.config.yaml` is a CLI artifact, not a framework artifact

**Chosen:** The framework defines the placeholder contract (`docs/reference/template-placeholders.md`); the CLI is one tool that implements the contract via its config file. The framework repo does not include a config schema or example.

**Considered and rejected:** Including `swarm.config.yaml` as a framework artifact in `scaffold/`. Rejected because the framework should be installable and usable without any specific tool, and the config is the CLI's mechanism, not the framework's contract.

### Decision: Recursion / Swarm-in-Swarm renamed to "delegation"

**Chosen:** User-facing prose uses "delegation" or "sub-orchestration" for the Lead Engineer pattern. "Recursion" is reserved for technical descriptions of the conditioning pipeline.

**Considered and rejected:** Keeping "Swarm-in-Swarm" as the canonical name. Rejected because it reads as marketing and obscures what's actually happening.

### Decision: Task vs task file terminology

**Chosen:** "Task" refers to the unit of work; "task file" refers to the markdown artifact that tracks it. Documentation must be deliberate about which one is meant.

**Considered and rejected:** Treating them as synonyms (which the existing source material occasionally does). The implementing agent must clean this up wherever it occurs in source material being incorporated.

---

## Acceptance criteria

This work is done when:

- [ ] The full directory structure exists as specified above
- [ ] Every concept doc, guide, reference doc, and ADR listed above exists with substantive content
- [ ] Every input artifact (existing templates, skills, scaffold files, conversational decisions) is preserved in some form, expanded or refined where the implementing agent identifies opportunities
- [ ] Every concept doc opens with a TL;DR or summary section that delivers the core point in the first screen
- [ ] Every reference doc has a TOC at the top
- [ ] Every cross-reference in delivered files resolves (no `TODO: link to X` markers)
- [ ] No content from the input material has been dropped without explicit justification in the new structure
- [ ] The README has the seven required sections (definition, pipeline diagram, repo map, quickstart, "is this for you", status, links)
- [ ] PRINCIPLES.md and NON-GOALS.md exist with five to ten entries each
- [ ] At least eight ADRs exist, covering the design decisions enumerated above
- [ ] The conformance checker exists, runs, and validates the three example projects as passing and the eight invalid fixtures as failing
- [ ] All three example projects (`typescript-monorepo`, `python-library`, `rust-cli`) exist with full Swarm-compliant structure and plausible filled-in content
- [ ] CHANGELOG.md exists with the v0.1.0 / v1.0.0 entry (whichever is appropriate) and a "Scaffold changes" subsection
- [ ] MIGRATIONS.md and DEPRECATIONS.md exist (possibly empty for v1.0, but with the format documented)
- [ ] No CLI-specific content has leaked into the framework documentation
- [ ] No project-specific content (TypeScript, pnpm, React, Tailwind, etc.) has leaked into framework-level artifacts; project-specific content appears only in `examples/`
- [ ] The terminology cleanup is complete: task vs task file, delegation vs recursion, document vs documentation, conditioning vs configuration, distillation vs summarization, source doc / grounding doc consistently used, persona vs role vs agent distinguished

---

## Test plan

After delivery, verify:

- [ ] **The 30-second test:** Open the README. Within 30 seconds, can you state what Swarm is, what it does, and whether you're its target audience?
- [ ] **The 5-minute test:** Skim `docs/concepts/01-introduction.md` and the conditioning pipeline doc. Within 5 minutes, can you describe the framework's central mechanism?
- [ ] **The reference test:** Look up "what persona handles fix tasks" using only `docs/reference/`. Should take under 30 seconds.
- [ ] **The adoption test:** Follow `docs/guides/adopting-swarm.md` from start to finish on a fresh project. Should produce a Swarm-compliant project that passes the conformance checker.
- [ ] **The conformance test:** Run the conformance checker against each `examples/` project — all must pass. Run against each `conformance/fixtures/invalid/` project — all must fail with the expected violations.
- [ ] **The rigor test:** Pick five claims at random from concept docs. Each should be backed by either a cross-reference to a reference doc, an ADR, or an example.
- [ ] **The depth test:** Pick three concept docs. Each should pass the progressive disclosure check: useful in 30 seconds, complete in 30 minutes.

---

## Open questions

- [ ] **[MINOR]** The implementing agent should propose the conformance checker's implementation language. TypeScript with zero dependencies and bundled into a single executable script is the recommended default.
- [ ] **[MINOR]** Whether `examples/` projects should be full git repos (with their own `.git/`) or just directory trees within the framework repo. Recommended: directory trees, with a note in their README that consumers should `git init` to make them real projects.
- [ ] **[MINOR]** Whether the version-numbering scheme should be semver tied to scaffold-breaking changes, or a separate "framework spec version" decoupled from repo versioning. Recommended: semver, with major bumps reserved for scaffold-breaking changes.

No `[CRITICAL]` open questions remain. The implementing agent has full latitude on the remaining minors but should record decisions in `Decisions` in the task file.

---

## Tradeoffs and risks

**Risk: The framework repo becomes too large to navigate.**
The structure has many files. _Mitigation:_ the README is the front door; `docs/README.md` is the docs landing; every directory has its own README explaining what's in it. A reader should never face an undifferentiated tree.

**Risk: Drift between docs/ and scaffold/.**
A change to the framework's understanding (in `docs/`) might not propagate to the artifacts (in `scaffold/`), or vice versa. _Mitigation:_ the conformance checker validates structural correctness; the CHANGELOG's "Scaffold changes" subsection forces explicit consideration on every release; the implementing agent should establish that wherever a `docs/` reference doc has scaffold counterparts, the doc states this dependency explicitly.

**Risk: The conformance checker becomes a bottleneck.**
Adding a new rule to the checker is now a code change in the framework repo. _Mitigation:_ keep the checker small and rule-focused; complex rules belong in human-readable conformance guidance, not enforced checks.

**Risk: ADRs become an afterthought.**
The implementing agent might write ADRs as perfunctory boxes-checked rather than serious documents. _Mitigation:_ every ADR must show its work in the "Considered and rejected" section. ADRs without alternatives are not finished. The acceptance criteria require minimum eight ADRs, but quality is the actual bar.

**Risk: Examples become stale relative to the framework.**
A change to a template invalidates the example projects that show the old version. _Mitigation:_ the conformance checker run against examples on every release catches this. Treat example-project updates as a release task, not a follow-up.

**Risk: The framework's voice gets diluted in the writing pass.**
The implementing agent might soften the existing source material's directness in favor of more conventional documentation prose. _Mitigation:_ explicit rule in the constraints (Rule 4) plus the test plan's "rigor test." The voice is part of what the framework is. Losing it loses the thing.
