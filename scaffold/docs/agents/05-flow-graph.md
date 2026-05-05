# 05 · The flow graph

> The deterministic mapping between documents, tasks, and personas. This is the core of the framework's auto-conditioning: pick a source document and the task type, the persona, the skills, and the verification commands all follow.

This document is reference material — agents consult it when deciding what to do, but the rules themselves are enforced by the launcher (the Swarm CLI or any compliant tool), the task templates, and the `documentation-gatekeeper` skill.

For the personas referenced here, see `.agents/skills/personas/SKILL.md`. For the documentation tiers, see `01-process.md`. For document types and their structure, see `02-file-types.md`.

---

## The pipeline

```
┌──────────────────┐
│  Source document │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐    Determined by document type:
│    Task type     │    audit → refactor, spec → feature, etc.
└────────┬─────────┘
         │
         ▼
┌──────────────────┐    Determined by task type:
│     Persona      │    refactor → Janitor, feature → Builder, etc.
└────────┬─────────┘
         │
         ▼
┌──────────────────┐    Skills + verification commands attached.
│  Conditioned     │    Worktree + branch created. Agent CLI launches.
│   task.md        │
└──────────────────┘
```

Information flows in one direction along the verbosity gradient: high-level to low-level, never back.

```
research.md  ──▶  spec.md       ──▶  task.md   (feature)
research.md  ──▶  audit.md      ──▶  task.md   (refactor)
research.md  ──▶  bug-report.md ──▶  task.md   (fix)

research.md is OPTIONAL — only when training data is insufficient
```

Task files are terminal. They never feed another doc; durable findings are promoted to audits, specs, or research before the session closes.

---

## Document → task type

Every document the human (or an upstream agent) hands to the framework has exactly one default task type. The user can override at session start, but the default is deterministic.

| Source document                              | Default task type                                                    | Why                                                                              |
| -------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `spec.md`                                    | feature                                                              | The spec describes a new capability to build                                     |
| `audit.md`                                   | refactor                                                             | The audit identifies cleanup work to do                                          |
| `bug-report.md`                              | fix                                                                  | The report describes a defect to repair                                          |
| `research.md` (technical)                    | spec-writing                                                         | Research is upstream input; the next step is translating into a spec             |
| `research.md` (UX/market)                    | spec-writing                                                         | Same — translate findings into requirements                                      |
| _none — initial human ask_                   | research-writing / spec-writing / audit-writing / bug-report-writing | A "blank slate" ask kicks off an authoring task; which one depends on the prompt |
| _another agent's branch_                     | review                                                               | Lead Engineer or Skeptic reviewing finished work                                 |
| _multiple source docs (e.g. 5 specs)_        | orchestration                                                        | Lead Engineer decomposes and delegates                                           |
| _existing audit + new investigation request_ | deepen-audit                                                         | Skeptic re-walks an existing audit                                               |
| `migration plan`                             | migration                                                            | Mechanical change across many call sites                                         |
| `benchmark report`                           | performance                                                          | Optimisation with measured baseline                                              |
| `cleanup list`                               | refactor                                                             | Janitor proves deletion safety                                                  |
| `test plan`                                  | testing                                                              | New test coverage from a structured plan                                         |

### Edges that look possible but aren't

- **research → fix** — forbidden. Research must go through a spec or audit before becoming actionable. Implementing directly from research means skipping the stage whose job is to translate.
- **spec → refactor** — uncommon. Refactor tasks are driven by audits. If a spec calls for restructuring, the spec is implicitly the refactor's plan, but the task is still tracked as a feature unless the change is purely structural.
- **bug-report → refactor** — forbidden. A bug report drives a fix, not a cleanup. If fixing the bug reveals broader cleanup needs, surface them as findings; do not expand scope silently.
- **audit → feature** — forbidden. Audits do not specify new features; they describe current state and recommend cleanup. If the audit's recommended approach is "build something new", the next step is a spec, not a feature task.

---

## Task type → persona

Each task type has a primary persona that is auto-attached. Some have secondary personas for handoff (e.g. a feature task ends with a Skeptic review; a refactor task ends the same way).

| Task type                    | Primary persona                                               | Secondary (handoff)                                                                                                           |
| ---------------------------- | ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| feature                      | The Builder                                                   | The Skeptic (review)                                                                                                          |
| fix                          | The Skeptic                                                   | — (the framework's existing convention is that fix sessions adopt the Skeptic mindset because root-causing demands hostility) |
| refactor                     | The Janitor                                                   | The Skeptic (review)                                                                                                          |
| rewrite                      | The Builder                                                   | The Skeptic (review)                                                                                                          |
| spec-writing                 | The Architect                                                 | —                                                                                                                             |
| research-writing (technical) | The Researcher                                                | —                                                                                                                             |
| research-writing (UX/market) | The Surveyor                                                  | —                                                                                                                             |
| audit-writing                | The Auditor                                                   | —                                                                                                                             |
| bug-report-writing           | The Bug Hunter                                                | —                                                                                                                             |
| migration                    | The Migrator                                                  | The Skeptic (review of each wave)                                                                                             |
| performance                  | The Performance Surgeon                                       | The Skeptic (review)                                                                                                          |
| testing                      | The Test Author                                               | The Skeptic (review)                                                                                                          |
| documentation                | The Documentarian                                             | The Skeptic (review)                                                                                                          |
| review                       | The Skeptic                                                   | —                                                                                                                             |
| deepen-audit                 | The Skeptic                                                   | —                                                                                                                             |
| orchestration                | The Lead Engineer                                             | The Skeptic (the merge-gate review pass adopts this stance)                                                                   |
| integration                  | The Builder                                                   | The Skeptic (review)                                                                                                          |
| upgrade                      | The Migrator                                                  | The Skeptic (review of each wave)                                                                                             |
| kickback                     | The Builder (or whichever persona produced the original work) | The Skeptic (re-review after fix)                                                                                             |

The project's `swarm.config` (a CLI artefact) may override the primary persona for any task type. The most common override: routing fix tasks to a dedicated Fixer persona instead of the Skeptic, when a team prefers minimality-focus over adversarial-focus.

---

## Task type → skills attached

Every task type loads `manage-task` and `documentation-gatekeeper` by default (per the framework's standing convention). The table below lists the *additional* skills the task type loads.

| Task type          | Additional skills                                           |
| ------------------ | ----------------------------------------------------------- |
| feature            | `write-feature`, `empirical-proof`                          |
| fix                | `write-fix`, `adversarial-review`, `empirical-proof`        |
| refactor           | `write-refactor`, `empirical-proof`                         |
| rewrite            | `write-rewrite`, `empirical-proof`                          |
| spec-writing       | `write-spec`, `distillation-discipline`                     |
| research-writing   | `write-research`, `distillation-discipline`                 |
| audit-writing      | `write-audit`, `adversarial-review`                         |
| bug-report-writing | `write-bug-report`, `adversarial-review`, `empirical-proof` |
| migration          | `write-refactor` (overlaps), `empirical-proof`              |
| upgrade            | `write-refactor` (overlaps), `empirical-proof`              |
| performance        | `empirical-proof`                                           |
| testing            | `empirical-proof`                                           |
| documentation      | `distillation-discipline`, `empirical-proof`                |
| review             | `adversarial-review`, `empirical-proof`                     |
| deepen-audit       | `write-audit`, `adversarial-review`, `empirical-proof`      |
| orchestration      | `adversarial-review`, `empirical-proof`                     |
| integration        | `write-feature`, `empirical-proof`                          |
| kickback           | (same as the original task type) + `adversarial-review`     |

Project-specific skills (architecture-violations, testing-file-layout, etc.) attach in addition based on description-matching to the task domain.

---

## Task type → verification commands

Each task type fires verification commands at specific phases. The commands themselves come from your project's bindings in `AGENTS.md`; the table below shows *when* they fire.

| Task type          | Pre-implementation                    | Periodic                         | Post-implementation                                              | Self-review                         |
| ------------------ | ------------------------------------- | -------------------------------- | ---------------------------------------------------------------- | ----------------------------------- |
| feature            | `cmdInstall`                          | `cmdValidate` after each batch   | `cmdValidate`, `cmdTest`                                         | All above                           |
| fix                | `cmdInstall`                          | —                                | `cmdValidate`, `cmdTest`                                         | + `git diff --stat`                 |
| refactor           | `cmdInstall`                          | `cmdValidateDeps` every 10 files | `cmdValidateDeps`, `cmdTypecheck`                                | All above                           |
| rewrite            | `cmdInstall`                          | `cmdValidate` after each module  | `cmdValidate`, `cmdTest`                                         | All above                           |
| spec-writing       | —                                     | —                                | `git status` (must be clean on source)                           | + `git status`                      |
| research-writing   | —                                     | —                                | `git status`                                                     | + `git status`                      |
| audit-writing      | —                                     | —                                | `git status`                                                     | + `git status`                      |
| bug-report-writing | —                                     | —                                | `git status` (the reproduction proof is its own verification)    | + reproduction output               |
| migration          | `cmdInstall`                          | `cmdValidate` after each wave    | `cmdValidate`, `cmdTest`                                         | All above                           |
| upgrade            | `cmdInstall`                          | `cmdBuild` + `cmdValidate` per wave | `cmdBuild`, `cmdValidate`, `cmdTest`                          | All above                           |
| performance        | `cmdInstall`, baseline `cmdBenchmark` | `cmdTest` after each change      | target `cmdBenchmark`, `cmdTest`                                 | All above                           |
| testing            | `cmdInstall`                          | `cmdTest` after each new test    | `cmdTest`, coverage report                                       | All above + assertion-flip proof    |
| documentation      | —                                     | —                                | run any code examples                                            | + example output                    |
| review             | `cmdInstall`                          | —                                | `cmdValidate`, `cmdTest` (run yourself, not trusting the worker) | + `git diff` of branch under review |
| deepen-audit       | `cmdInstall`                          | —                                | `cmdValidate`, `cmdValidateDeps` (where structural claims rely)  | All above                           |
| orchestration      | `cmdInstall`                          | per-worker review pass           | merged-branch `cmdValidate`, `cmdTest`                           | + per-worker review log             |
| integration        | `cmdInstall`                          | `cmdValidate` after each batch   | `cmdValidate`, `cmdTest` (incl. integration)                     | All above                           |

---

## Recursion

A task can spawn sub-tasks. The conditioning pipeline runs recursively at each level, with no special cases — each sub-task is itself a (source doc, task type, persona) triple.

The most common recursion is the Lead Engineer pattern:

```
human → orchestration task (Lead Engineer)
            │
            ├── feature task (Builder, on spec A)
            ├── feature task (Builder, on spec B)
            ├── refactor task (Janitor, on audit C)
            └── feature task (Builder, on spec D)
```

Each child task gets its own worktree, branch, conditioned task file, and agent CLI session. The Lead Engineer's task file tracks all children — slug, branch, status, last review verdict.

The recursion limit is set per project (CLI concern). Default: 2 (a Lead Engineer may spawn workers, and those workers are not themselves Lead Engineers). Higher limits permit Lead-Engineer-of-Lead-Engineers patterns; raise carefully.

---

## Subagent strategy

The framework's position on parallelism (per the field consensus that converged through 2025-2026):

- **Read-side parallelism is permitted.** Research, audit, and review tasks may run in subagents (separate context windows reporting back digests).
- **Write-side parallelism is forbidden.** Implementation tasks (feature, fix, refactor, migration) run in the main thread; the Lead Engineer pattern serialises writes through a single-threaded merge protocol.

Two Builders must never write to the same file at the same time. The Lead Engineer's decomposition rule: **disjoint file scopes**.

---

## Kickback

When the Skeptic rejects a worker's branch, the rejection itself becomes a conditioned task. The kickback is a (source doc + skeptic notes) → fix task triple. The original worker (or a fresh agent in the same persona) takes the kickback notes as additional input.

```
Builder finishes feature task
         │
         ▼
Skeptic reviews (review task)
         │
   ┌─────┴─────┐
   │           │
 PASS       FAIL → kickback task
                       │ (source: original spec + skeptic notes)
                       │ (task type: feature kickback)
                       │ (persona: Builder)
                       ▼
                   Builder revises
                       │
                       ▼
                Skeptic reviews again
```

A kickback is a normal task with normal conditioning. The only special input is the Skeptic's notes — they ride alongside the original spec in `## Linked docs`.

Round limit (recommendation, not hard rule): 3. After 3, escalate (re-spec / re-scope / abandon / human).

---

## Edge cases

**Ambiguous source document.** If a doc is unclear — a research file that's really an audit, a spec that contains too much current-state — the launcher should ask the human to confirm the doc type rather than guess. The framework strongly prefers explicit reclassification over silent re-routing.

**No source document.** A "blank slate" ask kicks off an authoring task. The launcher selects the authoring type from the human's prompt — "research X", "audit Y", "spec Z", "find the bug in W" — or asks if it cannot tell.

**Multiple source docs.** A task may legitimately have multiple sources (spec + research, audit + research, original spec + skeptic notes for a kickback). All sources go in `## Linked docs`. The task type follows the *primary* source's routing rule.

**No research, no spec.** Trivial tasks may skip the docs entirely — see `01-process.md` on what counts as trivial. For non-trivial work, document the skip in the task file's `## Decisions` with the reason.

**Research that's sufficient without a spec.** Forbidden. If you find yourself implementing directly from research, stop and write the spec first. Research is input; spec is contract. The framework treats this as a hard rule because the failure mode (drift between research findings and implementation) is severe and silent.

---

## Decision flow when starting a task

```
Does a source document exist?
├── No → authoring task
│         │
│         └── Which authoring type matches the human's ask?
│             ├── "research X"      → research-writing
│             ├── "audit Y"         → audit-writing
│             ├── "spec Z"          → spec-writing
│             └── "find bug W"      → bug-report-writing
│
└── Yes → look up the source doc type in "Document → task type" above
              │
              └── Route to the default task type
                       │
                       └── Look up persona in "Task type → persona"
                                │
                                └── Attach skills, inject commands, scaffold task file
```

The launcher does this. The agent does not need to think about it — the agent reads the conditioned task file and adopts the persona named in the `> **PERSONA:**` blockquote.

---

## See also

- `01-process.md` — the documentation-first workflow
- `02-file-types.md` — what each document type contains
- `03-workflow.md` — step-by-step session flow
- `04-standards.md` — writing and execution standards
- `.agents/skills/personas/SKILL.md` — full persona definitions
- `.agents/skills/documentation-gatekeeper/SKILL.md` — enforcement of the routing rules
