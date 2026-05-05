# 07 · The flow graph

> **TL;DR.** The deterministic mapping between source documents, task types, personas, skills, and verification commands. Pick a source document and the rest follows automatically. The full operational tables live in [`reference/flow-graph.md`](../reference/flow-graph.md); this concept doc explains the *why* and the *edge cases*.

---

## 🗺️ The pipeline as a flow

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

Information flows in one direction along the verbosity gradient — high-level to low-level, never back.

```
research.md  ──▶  spec.md       ──▶  task.md   (feature)
research.md  ──▶  audit.md      ──▶  task.md   (refactor)
research.md  ──▶  bug-report.md ──▶  task.md   (fix)

research.md is OPTIONAL — only when training data is insufficient
```

Task files are terminal. They never feed another doc; durable findings are *promoted* to audits, specs, or research before the session closes (see [`03-distillation.md`](03-distillation.md)).

---

## 🚦 Document → task type (the routing rules)

Every source document has exactly one default task type. The launcher (CLI or human) can override at session start, but the default is deterministic.

| Source document                         | Default task type                                                    | Why                                                                                |
| --------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `spec.md`                               | feature                                                              | The spec describes a new capability to build                                       |
| `audit.md`                              | refactor                                                             | The audit identifies cleanup work to do                                            |
| `bug-report.md`                         | fix                                                                  | The report describes a defect to repair                                            |
| `research.md` (technical)               | spec-writing                                                         | Research is upstream input; the next step is translating into a spec               |
| `research.md` (UX/market)               | spec-writing                                                         | Same — translate findings into requirements                                        |
| _none — initial human ask_              | research-writing / spec-writing / audit-writing / bug-report-writing | A "blank slate" ask kicks off an authoring task; which one depends on the prompt   |
| _another agent's branch_                | review                                                               | Lead Engineer or Skeptic reviewing finished work                                   |
| _multiple source docs (e.g. 5 specs)_   | orchestration                                                        | Lead Engineer decomposes and delegates                                             |
| _existing audit + new investigation_    | deepen-audit                                                         | Skeptic re-walks an existing audit                                                 |
| `migration plan`                        | migration                                                            | Mechanical change across many call sites                                           |
| `benchmark report`                      | performance                                                          | Optimisation task with measured baseline                                           |
| `cleanup list`                          | refactor                                                             | Janitor proves deletion safety                                                    |
| `test plan`                             | testing                                                              | New test coverage from a structured plan                                           |

For the operational tables, see [`reference/flow-graph.md`](../reference/flow-graph.md).

---

## 🚫 Edges that look possible but aren't

The framework forbids certain "tempting" edges because they violate the distillation discipline or the doc-type epistemic stances.

| Forbidden edge                                | Why                                                                                  |
| --------------------------------------------- | ------------------------------------------------------------------------------------ |
| `research → fix` (skipping spec/audit)        | Research is input. Implementation requires a spec, audit, or bug-report to translate the input into a contract. |
| `spec → refactor`                             | Refactor tasks are driven by audits. If a spec calls for restructuring, the spec is implicitly the refactor's plan, but the task is still tracked as a feature unless the change is purely structural. |
| `bug-report → refactor`                       | A bug report drives a fix, not a cleanup. If fixing the bug reveals broader cleanup needs, surface them as findings; do not expand scope silently. |
| `audit → feature`                             | Audits do not specify new features. If the audit's recommended approach is "build something new", the next step is spec-writing, not a feature task. |
| `code → spec` (back-fill)                     | Specs are forward-looking. Narrating finished code as a spec is dishonest. Use documentation instead. |
| `task with no source doc and no task scope`   | Every task is grounded.                                                              |
| `one source doc → multiple task types`        | The mapping is rigid. Split the work.                                                |
| `multiple source docs → one task`             | One source per task. Multiple sources = multiple tasks (or use orchestration).      |
| `task file authored after implementation begins` | The task file is step one. Conditioning before action.                            |
| `persona invented per session`                | Personas are catalogued.                                                             |
| `durable findings left only in the task file` | Task files are gitignored. Migrate findings to audits/specs/research.                |

These rules are codified in [`skills/documentation-gatekeeper.md`](../skills/documentation-gatekeeper.md), the always-loaded skill that refuses to allow forbidden flows.

---

## 🎯 Task type → persona

Each task type has a primary persona that is auto-attached. Some have secondary personas for handoff.

For the full table, see [`reference/flow-graph.md`](../reference/flow-graph.md).

Highlights worth understanding:

- **`fix → The Skeptic`.** The framework's existing convention is that fix sessions adopt the Skeptic mindset because root-causing demands hostility toward the most plausible-sounding explanation. See [ADR 0006](../adrs/0006-skeptic-owns-fix-tasks.md).
- **`refactor → The Janitor`.** Behaviour preservation is the contract; the Janitor is the persona built around safety-of-change.
- **`orchestration → The Lead Engineer`.** The only persona that doesn't write code. Becomes the Skeptic for each review pass.
- **`kickback → original persona`.** When a Skeptic kicks back a Builder's branch, the kickback is itself a task — assigned to the *original* Builder (or a fresh agent in the same persona) with the Skeptic's notes attached.

---

## 🛠️ Task type → skills

Two skills are always loaded for every task: `manage-task` and `documentation-gatekeeper`. Type-specific additions:

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
| performance        | `empirical-proof`                                           |
| testing            | `empirical-proof`                                           |
| documentation      | `distillation-discipline`, `empirical-proof`                |
| review             | `adversarial-review`, `empirical-proof`                     |
| deepen-audit       | `write-audit`, `adversarial-review`, `empirical-proof`      |
| orchestration      | `adversarial-review`, `empirical-proof`                     |

Project-specific skills attach in addition based on description-matching to the task domain. The convention: skills with a `description` field that semantically matches the task's objective attach automatically.

---

## ♻️ Recursion

A task can spawn sub-tasks. The conditioning pipeline runs **recursively** at each level — each sub-task is itself a `(source doc, task type, persona)` triple, conditioned in exactly the same way as the parent.

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

Recursion depth is bounded. The framework's default is **2** (a Lead Engineer may spawn workers; those workers are not themselves Lead Engineers). Higher limits are possible — Lead-Engineer-of-Lead-Engineers — but raise carefully.

For the pattern's mechanics, see [`08-recursion-and-delegation.md`](08-recursion-and-delegation.md).

---

## 🔁 Kickback

When the Skeptic rejects a worker's branch, the rejection itself becomes a conditioned task. The kickback is a `(source doc + skeptic notes) → fix task` triple. The original worker (or a fresh agent in the same persona) takes the kickback notes as additional input.

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

A kickback is a *normal task with normal conditioning*. The only special input is the Skeptic's notes — they ride alongside the original spec in `## Linked docs`.

Kickback loops are bounded too — the framework recommends a hard limit of **3 kickback rounds** per branch. After 3, the orchestrator (or human) escalates: re-spec the work, re-scope, or abandon. See [`08-recursion-and-delegation.md`](08-recursion-and-delegation.md) for the escalation protocol.

---

## ❓ Edge cases

The framework anticipates several common ambiguities and has a defined response for each.

### 🤔 Ambiguous source document

A document is unclear — a research file that's really an audit, a spec that contains too much current-state.

**Framework response:** The launcher (CLI or human) should *ask the human to confirm the doc type* rather than guess. The framework strongly prefers explicit reclassification over silent re-routing.

**In practice:** When the agent encounters an ambiguous source doc, it halts and surfaces the ambiguity in `## Findings`, then waits for a human (or a separate `audit-writing` / `spec-writing` task) to reclassify.

### 📭 No source document

A "blank slate" ask. The human says "research X" or "audit Y" or "find the bug in Z" with no upstream artefact.

**Framework response:** The launcher selects the *authoring* type from the human's prompt — `research-writing`, `audit-writing`, `spec-writing`, `bug-report-writing` — or asks if it cannot tell.

**In practice:** Most blank-slate asks are handled by `research-writing` followed by `spec-writing`. The framework prefers two crisp authoring tasks over one ambiguous task.

### 📑 Multiple source documents

A task may legitimately have multiple sources (spec + research, audit + research, original spec + skeptic notes for a kickback).

**Framework response:** All sources go in `## Linked docs`. The task type follows the *primary* source's routing rule. The other sources are *grounding context*, not separate routing inputs.

**In practice:** The Lead Engineer pattern (orchestration) is the canonical case for multiple-source-doc routing; everything else is one-primary-with-context.

### 🛠️ No research, no spec — trivial task

Trivial tasks may skip the full doc chain. Examples: a one-line documentation update, a small Test Authoring task, a typo fix.

**Framework response:** The task file's `## Objective` and `## Linked docs` sections are sufficient grounding. The `## Decisions` section records the skip with a reason.

**In practice:** The threshold is judgement-based. Heuristic: if the work has *structured content* (lists of items, repro steps, target metrics, acceptance criteria), it needs a separate doc. If it's a paragraph of prose, task scope is enough.

### 🔬 Research that's "sufficient without a spec"

The agent has done the research, the answer seems clear, and the temptation is to implement directly without writing the spec.

**Framework response: forbidden.** If you find yourself implementing directly from research, *stop and write the spec first*. Research is input; spec is contract. The failure mode (drift between research findings and implementation) is severe and silent — the framework treats this as a hard rule.

### ⚖️ Optimisation overlapping structural edits (resolved tension)

Older exploratory drafts debated precedence when **performance improvements require internal reorganisation**. Default stance:

1. **Prefer sequential specialised tasks** — `performance` carries measurement obligations; follow-on `refactor` (Janitor persona) absorbs behaviour-neutral extraction—wire dependencies through orchestration metadata so reviewers grasp ordering.
2. **Merged single-task exception** permitted only when `## Linked docs` explicitly ranks the benchmark/report above cosmetic debt *and* the conditioned Self-review inherits **both** measurement + behavioural invariance checks.
3. **Never** disguise semantic deltas as refactors (`documentation-gatekeeper` blocks) or cite perf wins without artefacts (`empirical-proof` blocks).

ADR / constitution notes for storage layout (research vs specs): prefer `.agents/adrs/` chronology distinct from drafts in `.agents/specs/` when teams need divergence tracking—launcher paths remain project conventions as long as routing tables stay deterministic.

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

- [`02-conditioning-pipeline.md`](02-conditioning-pipeline.md) — the mechanism end-to-end
- [`08-recursion-and-delegation.md`](08-recursion-and-delegation.md) — recursion and kickback in detail
- [`../reference/flow-graph.md`](../reference/flow-graph.md) — the operational tables
- [`../reference/compatibility-matrix.md`](../reference/compatibility-matrix.md) — the doc × task × persona matrices
- [`../skills/documentation-gatekeeper.md`](../skills/documentation-gatekeeper.md) — the enforcement skill
