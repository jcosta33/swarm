# 📖 Reference: Glossary

> Every term Swarm uses, defined precisely. The framework's vocabulary is deliberate — terms that look like synonyms often aren't.

---

## A

### accountable distillation
The discipline of moving content down the verbosity gradient *with a Distillation Loss Statement* recording what was dropped and why the next stage doesn't need it. Distinct from *summarisation* (which need not be accountable). See [`concepts/03-distillation.md`](../concepts/03-distillation.md).

### acceptance criteria
Testable conditions a spec lists that an implementation must satisfy. Each one is a checkbox; each one corresponds to at least one test.

### ADR
Architecture Decision Record. An immutable Markdown doc capturing an architecturally significant decision in the Y-Statement format (Context · Decision · Consequences). See [`documents/extended.md`](../documents/extended.md).

### adversarial review
The Skeptic's discipline of reading code with hostility — the six adversarial questions, run validation yourself, don't trust upstream claims. Encoded in the [`adversarial-review`](../skills/adversarial-review.md) skill.

### agent
A model+CLI instance acting on the codebase. Distinct from *persona* (the mindset the agent adopts) and *task* (the work the agent does). See [`reference/agents-md.md`](agents-md.md).

### AGENTS.md
The open-standard entry-point file every Swarm-conformant repo ships with. See [`reference/agents-md.md`](agents-md.md).

### audit
A *present-looking, observational* document describing the current state of a codebase area. Authored by The Auditor; spawns `refactor` tasks. See [`documents/audit.md`](../documents/audit.md).

### audit brief
An optional small spec framing an upcoming `audit-writing` task. The audit produces an `audit.md`; the brief frames *what to audit*.

### authoring task
A task type whose deliverable is a *source document* (rather than code). The four authoring tasks: `spec-writing`, `audit-writing`, `research-writing`, `bug-report-writing`. See [`concepts/06-task-types.md`](../concepts/06-task-types.md).

---

## B

### benchmark report
An audit specialised for performance — establishes a measured baseline, target, and methodology. Authored by The Performance Surgeon; spawns `performance` tasks. See [`documents/extended.md`](../documents/extended.md).

### blocker
Something preventing confident progress. Recorded immediately in `## Blockers` of the task file. Blocking means halting the task, not "I might come back to this".

### bug report
A *past-looking, evidential* document describing a defect: reliable reproduction, root cause, regression test plan. Authored by The Bug Hunter; spawns `fix` tasks. See [`documents/bug-report.md`](../documents/bug-report.md).

---

## C

### cleanup list
An audit specialised for deletion — items to remove with safety proofs. See [`documents/extended.md`](../documents/extended.md).

### CLI (agent CLI vs Swarm CLI)
*Agent CLI:* the tool that runs a model (Claude Code, Codex, Cursor, Aider, Devin, opencode, etc.). *Swarm CLI:* a tool that *implements the Swarm framework* — scaffolds task files, manages worktrees, runs verification gates. The Swarm CLI uses the agent CLI; they're different layers.

### conditioned task file
A task file that has been processed through the conditioning pipeline — persona named, skills listed, source doc linked, verification gates bound. The agent's first read. See [`concepts/02-conditioning-pipeline.md`](../concepts/02-conditioning-pipeline.md).

### conditioning
The process by which a source document determines a task type, persona, skills, and verification gates. Distinct from *configuration* (which is what the project does to the framework's slots).

### configuration
The project's bindings of framework slots (verification commands, project-level overlay personas, recursion limit, etc.). Configuration is the project's responsibility; conditioning is the framework's mechanism.

### constitution.md
A project-wide spec capturing non-negotiable baselines (tech stack, code quality, security mandates, architectural invariants). See [`documents/extended.md`](../documents/extended.md).

### `[CRITICAL]`
A marker for an open question whose answer would change the doc's content. The doc halts on `[CRITICAL]` open questions; they must be resolved (or downgraded with reasoning) before the doc finalises. Distinct from `[MINOR]`.

### cross-cutting framework skill
A skill loaded by default (or near-default) for every task: `manage-task`, `documentation-gatekeeper`, `personas`, `distillation-discipline`, `empirical-proof`, `adversarial-review`. Distinct from *authoring skills* (per-task-type) and *project-specific skills*.

---

## D

### deepen-audit
A task type that re-walks an existing audit with fresh adversarial eyes. Lead persona: The Skeptic. See [`tasks/deepen-audit.md`](../tasks/deepen-audit.md).

### delegation
The Lead Engineer pattern: decomposing work into sub-tasks, spawning workers in their own worktrees, reviewing as the Skeptic, merging in a chosen order. The user-facing name for *recursion* in the conditioning pipeline. See [ADR 0014](../adrs/0014-recursion-renamed-delegation.md).

### Diátaxis
The documentation framework distinguishing *tutorial / how-to / reference / explanation*. Swarm's core docs map to: research = explanation, spec/audit = reference, task = how-to.

### Distillation Loss Statement
The explicit record of what was dropped during a downhill transition, plus the justification for why the next stage doesn't need it. Required for docs distilled from upstream. See [`concepts/03-distillation.md`](../concepts/03-distillation.md).

### document vs documentation
*Document:* a structured artefact with a defined type (spec, audit, bug-report, research). *Documentation:* the broader category of written explanation, including user-facing docs (READMEs, how-to guides) authored via the `documentation` task type.

### domain skill
A project-specific skill living in `.agents/skills/domain/`. Accumulates over time as the team encounters areas where agents repeatedly violate constraints.

---

## E

### empirical proof
The Show-Don't-Tell discipline: every claim in `## Self-review` is backed by verbatim pasted command output. Encoded in the [`empirical-proof`](../skills/empirical-proof.md) skill. See [`concepts/09-empirical-proof.md`](../concepts/09-empirical-proof.md).

### epistemic stance
The kind of claim a doc type makes. Spec is forward-looking and prescriptive; audit is present-looking and observational; bug-report is past-looking and evidential; research is outward-looking and citational. See [`concepts/05-document-types.md`](../concepts/05-document-types.md).

---

## F

### feature
A task type that builds new behaviour from a complete spec. Lead persona: The Builder. See [`tasks/feature.md`](../tasks/feature.md).

### fix
A task type that repairs a defect documented in a bug-report. Lead persona: The Skeptic. See [`tasks/fix.md`](../tasks/fix.md).

### flow graph
The deterministic mapping between source documents, task types, personas, skills, and verification commands. See [`concepts/07-flow-graph.md`](../concepts/07-flow-graph.md) and [`reference/flow-graph.md`](flow-graph.md).

### forbidden flow
A `(source-doc → task-type)` or `(task-type → other)` edge the framework refuses. Examples: `research → fix` (skipping spec); `code → spec` (back-fill). Enforced by [`documentation-gatekeeper`](../skills/documentation-gatekeeper.md).

---

## G

### gate
A *named slot* the framework defines for verification. The project binds the slot to a command. Examples: `cmdValidate`, `cmdTest`, `cmdValidateDeps`. See [`reference/verification-gates.md`](verification-gates.md).

### gitignored task file
The framework's standing convention: `.agents/tasks/` is in `.gitignore`. Task files are worktree-local execution scaffolding. Durable findings migrate to audits/specs/research before close. See [ADR 0004](../adrs/0004-task-files-are-gitignored.md).

### grounding doc
A source document that grounds a task. Synonym: *source doc*. The framework prefers *source doc* in formal contexts.

---

## H

### hard gate
The Self-review section's closing requirement: every question has a written answer; every `[Paste output]` placeholder is filled with verbatim output. The agent cannot close the task without satisfying every gate. See [`skills/empirical-proof.md`](../skills/empirical-proof.md).

### handoff
The convention by which one persona's task completes and another's begins. Examples: Builder → Skeptic (review); Auditor → Janitor (refactor); Researcher → Architect (spec-writing). See [`concepts/04-personas.md`](../concepts/04-personas.md).

### hallucinated completion
The framework's named failure mode: an agent declaring "done" without empirical support. The discipline that defeats it is empirical proof.

---

## I

### integration
A task type that wires a third-party SDK / API / MCP server into the codebase per a spec. Lead persona: The Builder (in integration mode). See [`tasks/integration.md`](../tasks/integration.md).

### iron law
The Superpowers-derived pattern of stating a rule absolutely and refusing rationalisations. Adopted in Swarm's persona profiles via the "Hard constraints" + "Red flags" sections. See [ADR 0013](../adrs/0013-iron-law-red-flags-pattern.md).

---

## K

### kickback
A task spawned when The Skeptic rejects a worker's branch. The original persona revises per the Skeptic's specific notes, then hands back for re-review. Round limit (recommendation): 3. See [`tasks/kickback.md`](../tasks/kickback.md).

---

## L

### Lead Engineer
The persona that orchestrates parallel sub-tasks. Doesn't write code; coordinates workers, reviews as the Skeptic, merges. See [`personas/the-lead-engineer.md`](../personas/the-lead-engineer.md).

### Loss Statement
Short for *Distillation Loss Statement*.

---

## M

### manage-task
The always-loaded skill that owns the task file's lifecycle: pre-flight, in-flight maintenance, pre-close gate, promotion protocol. See [`skills/manage-task.md`](../skills/manage-task.md).

### migration
A task type that moves the codebase from API A to API B mechanically across many call sites. Lead persona: The Migrator. Plans in waves; per-wave validation. See [`tasks/migration.md`](../tasks/migration.md).

### migration plan
A spec specialised for migration — adds wave plan, callsite tracker, shim contracts. See [`documents/extended.md`](../documents/extended.md).

### `[MINOR]`
A marker for an open question worth recording but not blocking the doc. Distinct from `[CRITICAL]` (which halts the doc).

---

## O

### orchestration
A task type for the Lead Engineer pattern — decomposing complex asks into independent sub-tasks. See [`tasks/orchestration.md`](../tasks/orchestration.md).

### overlay persona
A project-specific persona added beyond the framework's 13. Lives in the project's `.agents/skills/personas/`. See [`guides/customizing-personas.md`](../guides/customizing-personas.md).

---

## P

### `[pending]` / `[confirmed]`
Markers for assumptions in a task file. Every assumption starts as `[pending]`; the agent promotes to `[confirmed]` when verified. Closing a task with unresolved `[pending]` assumptions is forbidden by `manage-task`.

### performance
A task type for optimising a specific bottleneck under a measured target. Lead persona: The Performance Surgeon. See [`tasks/performance.md`](../tasks/performance.md).

### persona
A *mindset*, not a role. Each task type has exactly one default lead persona. See [`concepts/04-personas.md`](../concepts/04-personas.md). Distinct from *role* (which implies a job title) and *agent* (the model+CLI running the work).

### persona blockquote
The `> **PERSONA:**` line in a conditioned task file naming the persona the agent must adopt. Example: `> **PERSONA:** Load .agents/skills/personas/SKILL.md and adopt **The Builder** persona.`

### placeholder
A `{{name}}` token in a task or doc template, resolved by the launcher per task. See [`reference/template-placeholders.md`](template-placeholders.md).

### promotion
The act of moving a durable finding from a task file (gitignored, ephemeral) to an upstream doc (audit, spec, research, bug-report). See [`concepts/03-distillation.md`](../concepts/03-distillation.md). The companion to *distillation*.

---

## R

### red flags
A persona-profile section listing rationalisations the persona refuses to accept (the *iron law* enforcement). See [ADR 0013](../adrs/0013-iron-law-red-flags-pattern.md).

### refactor
A task type that restructures code without changing observable behaviour. Lead persona: The Janitor. Source: `audit.md`. See [`tasks/refactor.md`](../tasks/refactor.md).

### research
An *outward-looking, citational* document gathering external knowledge. Authored by The Researcher (technical) or The Surveyor (UX/market). Spawns `spec-writing`. See [`documents/research.md`](../documents/research.md).

### review
A task type that adversarially inspects a worker's branch. Lead persona: The Skeptic. Output: a verdict and findings. See [`tasks/review.md`](../tasks/review.md).

### rewrite
A task type that re-implements a module with explicit behaviour changes. Lead persona: The Builder. Distinct from refactor (which preserves behaviour). See [`tasks/rewrite.md`](../tasks/rewrite.md).

### role
What an agent is *paid to do*. The framework deliberately prefers *persona* over *role* — personas are mindsets, not job titles.

---

## S

### Self-review
The hard-gated section of every task file. Filled in at task close with persona-specific questions answered and verification outputs pasted verbatim. See [`concepts/09-empirical-proof.md`](../concepts/09-empirical-proof.md).

### session
The lifespan of an agent CLI instance working on a task. May be one task or part of a multi-session task. The task file is the resumption record across sessions. See [`concepts/11-session-lifecycle.md`](../concepts/11-session-lifecycle.md).

### shim
A compatibility layer added during a refactor or migration so the old surface continues to work while consumers migrate. Every shim has a documented removable-when criterion. See [`skills/write-refactor.md`](../skills/write-refactor.md).

### Show, Don't Tell
The empirical-proof discipline's slogan. Paste actual output, not paraphrase. See [`concepts/09-empirical-proof.md`](../concepts/09-empirical-proof.md).

### skill
A Markdown file with YAML frontmatter that the agent loads on demand based on its `description`. Format borrowed from Anthropic Skills / OpenAI Codex Agent Skills. See [`skills/README.md`](../skills/README.md).

### Skeptic
The framework's universal terminal node for code-producing work. Reviews adversarially; runs validation themselves; refuses confident-sounding claims. Also adopts for `fix` (root-causing demands hostility). See [`personas/the-skeptic.md`](../personas/the-skeptic.md).

### slot
A *named verification gate* the framework defines. The project binds slots to commands. Synonym: *gate*. See [`reference/verification-gates.md`](verification-gates.md).

### source doc
A document that grounds a task. The four core types: spec, audit, bug-report, research. Synonym: *grounding doc*.

### spec
A *forward-looking, prescriptive* document describing what should be true of the system. Authored by The Architect. Spawns `feature` tasks. See [`documents/spec.md`](../documents/spec.md).

### subagent
An agent running in its own context window, reporting back a digest. The framework permits subagents for *read-side* work (research, audit, review); writes are single-threaded. See [`concepts/10-subagent-strategy.md`](../concepts/10-subagent-strategy.md).

---

## T

### task
A unit of work. Distinct from *task file* (the markdown artefact tracking the task).

### task file
The Markdown file at `.agents/tasks/<slug>.md` that tracks a task. Gitignored; worktree-local; the resumption record across sessions.

### task scope
A one-paragraph capture of the task's framing in the task file's `## Objective` section, used for trivial tasks that don't need a separate source doc.

### task type
A category of work. The 18 types in three families: implementation, authoring, process. See [`concepts/06-task-types.md`](../concepts/06-task-types.md).

### test plan
A spec specialised for test coverage projects too large for one task file. See [`documents/extended.md`](../documents/extended.md).

### testing
A task type that adds or improves test coverage. Lead persona: The Test Author. See [`tasks/testing.md`](../tasks/testing.md).

---

## U

### upgrade
A task type for dependency / framework / language version bumps. Same persona and discipline as `migration`; different source. See [`tasks/upgrade.md`](../tasks/upgrade.md).

---

## V

### verbosity gradient
The spectrum from highest-verbosity research files down to lowest-verbosity task files and terminal outputs. Information flows downhill only. See [`concepts/03-distillation.md`](../concepts/03-distillation.md).

### verification gate
See *gate*.

---

## W

### wave
A bounded chunk of a migration. The codebase compiles and passes tests after each wave. See [`tasks/migration.md`](../tasks/migration.md).

### worktree
A git worktree (`git worktree add`) — a separate working directory linked to the same repo. Each Swarm task runs in its own worktree, with its own task file. See [`reference/directory-layout.md`](directory-layout.md).

### write skill
An authoring skill paired with a doc type or task type. Examples: `write-spec`, `write-audit`, `write-feature`, `write-fix`. See [`skills/README.md`](../skills/README.md).

---

## See also

- [`concepts/`](../concepts/) — the conceptual frame for these terms
- [`reference/`](.) — the operational tables
- [`PRINCIPLES.md`](../PRINCIPLES.md) — the load-bearing constraints
- [`NON-GOALS.md`](../NON-GOALS.md) — what Swarm explicitly is not
