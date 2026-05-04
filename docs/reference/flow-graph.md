# 📖 Reference: The flow graph

> The deterministic mapping between source documents, task types, personas, skills, and verification commands. The operational form of [`concepts/07-flow-graph.md`](../concepts/07-flow-graph.md).

---

## 🪞 Pipeline overview

```
┌──────────────────┐
│  Source document │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐    Determined by document type
│    Task type     │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐    Determined by task type
│     Persona      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐    Skills + verification commands attached
│  Conditioned     │
│   task.md        │
└──────────────────┘
```

Information flows downhill: research → spec/audit/bug-report → task → terminal output.

---

## 📋 Document → task type

| Source document                                | Default task type                                                    | Why                                                                              |
| ---------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `spec.md`                                      | `feature`                                                            | The spec describes a new capability to build                                     |
| `audit.md`                                     | `refactor`                                                           | The audit identifies cleanup work to do                                          |
| `bug-report.md`                                | `fix`                                                                | The report describes a defect to repair                                          |
| `research.md` (technical)                      | `spec-writing`                                                       | Research is upstream input; next step is translating into a spec                |
| `research.md` (UX/market)                      | `spec-writing`                                                       | Same                                                                             |
| _none — initial human ask_                     | `research-writing` / `spec-writing` / `audit-writing` / `bug-report-writing` | Authoring task; type depends on the prompt                              |
| _another agent's branch_                       | `review`                                                             | Lead Engineer or Skeptic reviewing finished work                                 |
| _multiple source docs (e.g., 5 specs)_         | `orchestration`                                                      | Lead Engineer decomposes and delegates                                           |
| _existing audit + new investigation request_   | `deepen-audit`                                                       | Skeptic re-walks an existing audit                                               |
| `migration plan`                               | `migration`                                                          | Mechanical change across many call sites                                         |
| `benchmark report`                             | `performance`                                                        | Optimisation with measured baseline                                              |
| `cleanup list`                                 | `refactor`                                                           | Janitor proves deletion safety                                                  |
| `test plan`                                    | `testing`                                                            | New test coverage from a structured plan                                         |

### Forbidden edges

| Forbidden                                       | Why                                                                    |
| ----------------------------------------------- | ---------------------------------------------------------------------- |
| `research → fix` (skipping spec/audit)          | Research is input. Implementation requires a translating doc.          |
| `spec → refactor`                               | Refactor tasks are driven by audits, not specs                        |
| `bug-report → refactor`                         | Bug-report drives a fix, not a cleanup                                 |
| `audit → feature`                               | Audits do not specify new features                                     |
| `code → spec` (back-fill)                       | Specs are forward-looking; back-filling is documentation, not spec    |
| `task with no source doc and no task scope`     | Every task is grounded                                                |
| `one source doc → multiple task types`          | Mapping is rigid; split the work                                      |
| `multiple source docs → one task`               | One source per task (or use orchestration)                            |
| `task file authored after implementation begins` | Conditioning before action                                            |
| `persona invented per session`                  | Personas are catalogued                                               |
| `durable findings left only in the task file`   | Task files are gitignored                                             |

---

## 🎯 Task type → persona

| Task type                       | Primary persona                                                | Secondary (handoff)                                                  |
| ------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------- |
| `feature`                       | The Builder                                                    | The Skeptic (review)                                                 |
| `fix`                           | The Skeptic                                                    | (kickback returns to original persona)                              |
| `refactor`                      | The Janitor                                                    | The Skeptic (review)                                                 |
| `rewrite`                       | The Builder                                                    | The Skeptic (review)                                                 |
| `spec-writing`                  | The Architect                                                  | —                                                                    |
| `research-writing` (technical)  | The Researcher                                                 | —                                                                    |
| `research-writing` (UX/market)  | The Surveyor                                                   | —                                                                    |
| `audit-writing`                 | The Auditor                                                    | —                                                                    |
| `bug-report-writing`            | The Bug Hunter                                                 | —                                                                    |
| `migration`                     | The Migrator                                                   | The Skeptic (review of each wave)                                    |
| `upgrade`                       | The Migrator                                                   | The Skeptic (review of each wave)                                    |
| `performance`                   | The Performance Surgeon                                        | The Skeptic (review)                                                 |
| `testing`                       | The Test Author                                                | The Skeptic (review)                                                 |
| `documentation`                 | The Documentarian                                              | The Skeptic (review)                                                 |
| `review`                        | The Skeptic                                                    | —                                                                    |
| `deepen-audit`                  | The Skeptic                                                    | —                                                                    |
| `orchestration`                 | The Lead Engineer                                              | The Skeptic (the merge-gate review pass)                             |
| `integration`                   | The Builder                                                    | The Skeptic (review)                                                 |
| `kickback`                      | (Original persona, e.g., The Builder)                          | The Skeptic (re-review after fix)                                   |

The project's `swarm.config` (a CLI artefact) may override the primary persona for any task type. Common override: routing `fix` to a dedicated Fixer persona instead of the Skeptic.

---

## 🛠️ Task type → skills attached

Two skills always: `manage-task` and `documentation-gatekeeper` (per the framework's standing convention). Plus `personas` (loads on persona-blockquote presence). The table below lists the *additional* skills.

| Task type             | Additional skills                                            |
| --------------------- | ------------------------------------------------------------ |
| `feature`             | `write-feature`, `empirical-proof`                           |
| `fix`                 | `write-fix`, `adversarial-review`, `empirical-proof`         |
| `refactor`            | `write-refactor`, `empirical-proof`                          |
| `rewrite`             | `write-rewrite`, `empirical-proof`                           |
| `spec-writing`        | `write-spec`, `distillation-discipline`                      |
| `research-writing`    | `write-research`, `distillation-discipline`                  |
| `audit-writing`       | `write-audit`, `adversarial-review`                          |
| `bug-report-writing`  | `write-bug-report`, `adversarial-review`, `empirical-proof`  |
| `migration`           | `write-refactor` (overlap), `empirical-proof`                |
| `upgrade`             | `write-refactor` (overlap), `empirical-proof`                |
| `performance`         | `empirical-proof`                                            |
| `testing`             | `empirical-proof`                                            |
| `documentation`       | `distillation-discipline`, `empirical-proof`                 |
| `review`              | `adversarial-review`, `empirical-proof`                      |
| `deepen-audit`        | `write-audit`, `adversarial-review`, `empirical-proof`       |
| `orchestration`       | `adversarial-review`, `empirical-proof`                      |
| `integration`         | `write-feature`, `empirical-proof`                           |
| `kickback`            | (same as the original task type) + `adversarial-review`      |

Project-specific skills attach in addition based on description-matching to the task domain.

---

## 🔌 Task type → verification commands

The framework defines **slots**; the project binds slots to commands. The table below shows *when* slots fire.

| Task type             | Pre-implementation                       | Periodic                              | Post-implementation                                              | Self-review                            |
| --------------------- | ---------------------------------------- | ------------------------------------- | ---------------------------------------------------------------- | -------------------------------------- |
| `feature`             | `cmdInstall`                             | `cmdValidate` after each batch        | `cmdValidate`, `cmdTest`                                         | All above                              |
| `fix`                 | `cmdInstall`                             | —                                     | `cmdValidate`, `cmdTest`                                         | + `git diff --stat`                    |
| `refactor`            | `cmdInstall`                             | `cmdValidateDeps` every 10 files      | `cmdValidateDeps`, `cmdTypecheck`                                | All above                              |
| `rewrite`             | `cmdInstall`                             | `cmdValidate` after each module       | `cmdValidate`, `cmdTest`                                         | All above                              |
| `spec-writing`        | —                                        | —                                     | `git status` (clean on source)                                   | + `git status`                         |
| `research-writing`    | —                                        | —                                     | `git status`                                                     | + `git status`                         |
| `audit-writing`       | —                                        | —                                     | `git status`                                                     | + `git status`                         |
| `bug-report-writing`  | —                                        | —                                     | `git status` (reproduction proof is its own verification)        | + reproduction output                  |
| `migration`           | `cmdInstall`                             | `cmdValidate` after each wave         | `cmdValidate`, `cmdTest`                                         | All above                              |
| `upgrade`             | `cmdInstall`                             | `cmdBuild` + `cmdValidate` per wave   | `cmdBuild`, `cmdValidate`, `cmdTest`                             | All above                              |
| `performance`         | `cmdInstall`, baseline `cmdBenchmark`    | `cmdTest` after each change           | target `cmdBenchmark`, `cmdTest`                                 | All above                              |
| `testing`             | `cmdInstall`                             | `cmdTest` after each new test         | `cmdTest`, coverage report                                       | All above + assertion-flip proof       |
| `documentation`       | —                                        | —                                     | run any code examples                                            | + example output                       |
| `review`              | `cmdInstall`                             | —                                     | `cmdValidate`, `cmdTest` (run yourself)                          | + `git diff` of branch under review    |
| `deepen-audit`        | `cmdInstall`                             | —                                     | `cmdValidate`, `cmdValidateDeps` (where structural claims rely) | All above                              |
| `orchestration`       | `cmdInstall`                             | per-worker review pass                | merged-branch `cmdValidate`, `cmdTest`                           | + per-worker review log                |
| `integration`         | `cmdInstall`                             | `cmdValidate` after each batch        | `cmdValidate`, `cmdTest` (incl. integration)                     | All above                              |
| `kickback`            | (same as original task type)             | (same)                                | (same)                                                           | (same) + delta from prior head         |

For the placeholder contract (what `cmdInstall`, `cmdValidate`, etc. mean for tool builders), see [`template-placeholders.md`](template-placeholders.md).

---

## ♻️ Recursion

A task can spawn sub-tasks. The conditioning pipeline runs recursively at each level. Each sub-task is itself a `(source doc, task type, persona)` triple.

The most common recursion is the **Lead Engineer pattern**:

```
human → orchestration task (Lead Engineer)
            │
            ├── feature task (Builder, on spec A)
            ├── feature task (Builder, on spec B)
            ├── refactor task (Janitor, on audit C)
            └── feature task (Builder, on spec D)
```

Each child task gets its own worktree, branch, conditioned task file, and agent CLI session. The Lead Engineer's task file tracks all children — slug, branch, status, last review verdict.

The recursion limit is set per project (CLI concern); framework default is **2**. Higher limits permit Lead-Engineer-of-Lead-Engineers patterns; raise carefully.

See [`concepts/08-recursion-and-delegation.md`](../concepts/08-recursion-and-delegation.md).

---

## 🔁 Kickback

When the Skeptic rejects a worker's branch, the rejection itself becomes a conditioned task. The kickback is a `(source doc + skeptic notes) → fix-style task` triple. The original worker (or a fresh agent in the same persona) takes the kickback notes as additional input.

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

Kickback round limit (recommendation, not hard rule): 3. After 3, escalate (re-spec / re-scope / abandon / human).

See [`tasks/kickback.md`](../tasks/kickback.md).

---

## ❓ Edge cases

| Edge case                            | Framework response                                                              |
| ------------------------------------ | ------------------------------------------------------------------------------- |
| Ambiguous source document            | Launcher asks human to confirm doc type. Explicit reclassification, not silent re-routing |
| No source document                   | Authoring task (research-writing / spec-writing / audit-writing / bug-report-writing) |
| Multiple source documents            | Either orchestration (decompose) or one primary source + others as context     |
| Trivial task with no source doc      | Allowed — task scope captures the ask in the task file's `## Objective`        |
| "Research is sufficient without spec" | Forbidden — write the spec first                                              |

---

## 🧭 Decision flow when starting a task

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

- [`concepts/07-flow-graph.md`](../concepts/07-flow-graph.md) — the conceptual frame
- [`compatibility-matrix.md`](compatibility-matrix.md) — the persona × doc × task matrices
- [`template-placeholders.md`](template-placeholders.md) — the placeholder contract
- [`skills/documentation-gatekeeper.md`](../skills/documentation-gatekeeper.md) — the enforcement skill
- [`personas/`](../personas/), [`tasks/`](../tasks/), [`documents/`](../documents/), [`skills/`](../skills/)
