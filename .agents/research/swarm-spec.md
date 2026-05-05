# Swarm Documentation Framework for Coding Agents

Swarm should not try to win by being “Spec Kit, but with more files.” It should win by becoming the documentation control plane for agentic software work: typed source documents, deterministic routing, thin but explicit personas, lazy-loaded skills, hard verification gates, and a strict promotion protocol that separates durable knowledge from worktree-local execution scaffolding. That recommendation is strongly supported by the current landscape. Role-specialized systems like MetaGPT, AutoGen, ChatDev, CAMEL, and AgentVerse all show that specialization helps, but they also show the cost of coordination complexity and role sprawl. Current production tools have converged on the same practical pattern: planning before editing, role or mode separation, on-demand skills, and aggressively managed context. Official materials from entity["company","Anthropic","ai company"], entity["company","GitHub","software company"], entity["organization","Microsoft Research","research lab"], and entity["organization","Thoughtworks","technology consultancy"], plus the documentation architecture of entity["people","Daniele Procida","documentation author"] and the ADR movement associated with entity["people","Michael Nygard","software architect"], all point in the same direction: fewer document classes, clearer obligations, and stronger traceability beat sprawling prompt folklore. citeturn20view0turn20view1turn20view2turn20view5turn16view0turn16view1turn19view0turn21view0turn21view4turn21view5

The enterprise case is even more one-sided. Current enterprise agent products emphasize SSO, SCIM, audit logs, compliance APIs, spend controls, centralized gateways, and session attribution. Meanwhile, cloud-agent builders warn that security isolation, persistence across async review/CI gaps, orchestration, and auditability are first-order engineering problems, not afterthoughts. Swarm should therefore optimize for reviewability, provable verification, and source-of-truth hygiene rather than for maximum automation theater. entity["company","Anysphere","cursor maker"] and entity["company","Cognition","ai company"] both emphasize the same controls from the product side, while Anthropic’s enterprise posture adds compliance APIs, retention controls, and gateway-based governance. citeturn28view0turn28view1turn28view2turn32view2turn32view3turn28view3turn28view4

The clearest opportunity comes from the user-feedback trail around GitHub Spec Kit. The actively maintained open-source “Spec Kit” in this landscape is GitHub’s project, not a Google-owned framework, although Google now publishes codelabs that integrate Spec Kit into its own ADK workflows. The recurring complaints are not subtle: feature-centric coverage while most real work is bugs/refactors/modifications; missing structured debugging loops; unchecked task completion; spec canonicality problems; multi-repo drift; ordering fragility; and uncontrolled complexity escalation. Swarm should treat those complaints as design inputs, not edge cases. citeturn16view5turn23view1turn34search0turn23view3turn23view4turn23view5turn23view7turn24view1turn24view2turn24view3turn24view4turn24view5turn24view6turn31view0

The core call is therefore simple:

1. Keep the main distillation trunk narrow: `research.md -> spec.md | audit.md | bug-report.md -> task.md`.
2. Keep durable reference docs sidecar, not trunk: ADRs, architecture-overview, skills.
3. Keep personas thin and tied to proof obligations, not vibes.
4. Make every execution session terminate in a worktree-local task file with pasted evidence.
5. Require promotion into durable docs when the session learns something that should outlive the worktree.
6. Prefer one canonical document per purpose, with typed sections, over families of overlapping near-duplicates.

Everything below is optimized for that shape.

## Personas

The right Swarm persona system is smaller than the role catalogues in many research papers, but more explicit than the generic “planner/coder/reviewer” split in most tools. MetaGPT and ChatDev show the usefulness of specialized roles and SOP-like stage handoffs; Anthropic’s subagent guidance and research-system writeup show that delegation only works when task boundaries, outputs, and tool limits are explicit; and recent multi-agent research warns that excessive team size and weak role boundaries can erase the advantage of experts rather than amplify it. Swarm should therefore keep a fixed, lookup-based roster with a uniquely best-fit cell for each surviving persona. citeturn20view0turn20view2turn20view5turn19view3turn29search4

### Final persona roster

| Persona                 | One-line role                                                 | Uniquely best-fit cell                            | Triggering documents                                  | Triggering task types         | Auto-attached skills                                                                                                  | Handoff partners                                            |
| ----------------------- | ------------------------------------------------------------- | ------------------------------------------------- | ----------------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| The Researcher          | Finds and distills external technical truth.                  | `research.md × research-writing`                  | none, research.md                                     | research-writing              | personas, manage-task, documentation-gatekeeper, write-research, distillation-discipline, empirical-proof             | Architect, Auditor, Bug Hunter                              |
| The Architect           | Turns intent into bounded, verifiable design.                 | `spec.md × spec-writing`                          | research.md, ADR, architecture-overview               | spec-writing                  | personas, manage-task, documentation-gatekeeper, write-spec, architecture-violations, distillation-discipline         | Builder, Migrator, Lead Engineer, Skeptic                   |
| The Auditor             | Maps current state honestly, without repair fantasies.        | `audit.md × audit-writing`                        | repo state, postmortem imports, architecture-overview | audit-writing                 | personas, manage-task, documentation-gatekeeper, write-audit, empirical-proof, architecture-violations                | Janitor, Performance Surgeon, Skeptic                       |
| The Bug Hunter          | Reproduces, isolates, and roots-causes defects.               | `bug-report.md × bug-report-writing`              | incident notes, failing behavior, logs                | bug-report-writing, debugging | personas, manage-task, documentation-gatekeeper, write-bug-report, empirical-proof                                    | Builder, Test Author, Skeptic                               |
| The Builder             | Implements approved behavior changes.                         | `spec.md × feature`                               | spec.md                                               | feature, fix                  | personas, manage-task, documentation-gatekeeper, write-feature or write-fix, empirical-proof, architecture-violations | Skeptic, Test Author, Documentarian                         |
| The Janitor             | Restructures code without changing observable behavior.       | `audit.md × refactor`                             | audit.md                                              | refactor                      | personas, manage-task, documentation-gatekeeper, write-refactor, empirical-proof, architecture-violations             | Skeptic, Test Author                                        |
| The Migrator            | Executes high-volume, phased, compatibility-sensitive change. | `spec.md × migration`                             | spec.md, ADR                                          | migration                     | personas, manage-task, documentation-gatekeeper, write-migration, empirical-proof, architecture-violations            | Architect, Skeptic, Documentarian                           |
| The Performance Surgeon | Optimizes against measured baselines only.                    | `audit.md × performance`                          | audit.md, spec.md                                     | performance                   | personas, manage-task, documentation-gatekeeper, write-performance, empirical-proof                                   | Test Author, Skeptic                                        |
| The Test Author         | Builds regression and confidence surfaces.                    | `spec.md × testing` and `bug-report.md × testing` | spec.md, bug-report.md, audit.md                      | testing                       | personas, manage-task, documentation-gatekeeper, write-test, testing-file-layout, empirical-proof                     | Builder, Janitor, Performance Surgeon                       |
| The Documentarian       | Produces durable human-facing explanation and operation docs. | `spec.md × documentation`                         | spec.md, audit.md, architecture-overview              | documentation                 | personas, manage-task, documentation-gatekeeper, write-documentation, empirical-proof                                 | Architect, Builder                                          |
| The Skeptic             | Tries to break the case for “done.”                           | `task.md × review`                                | any durable source + task file + branch diff          | review                        | personas, manage-task, documentation-gatekeeper, adversarial-review, empirical-proof                                  | Everyone; kickback always routes to source owner + executor |
| The Lead Engineer       | Decomposes, routes, and merges parallel work.                 | `task.md × orchestration`                         | spec.md, audit.md, bug-report.md                      | orchestration                 | personas, manage-task, documentation-gatekeeper, write-orchestration, distillation-discipline                         | Architect, Skeptic, all executors                           |

### Hard constraints, proof obligations, and anti-patterns

| Persona                 | MUST DO                                                                                             | MUST NOT DO                                                               | Empirical proof required                                                                | Self-review focus                                                            | Anti-patterns                                                              |
| ----------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| The Researcher          | Cite every non-trivial claim; separate evidence from recommendation; mark unresolved uncertainty.   | Smuggle design decisions in as “research findings.”                       | Source list, excerpts or citations, dated facts, rejected alternatives.                 | “Did I prove the recommendation or just prefer it?”                          | Web-summary dumping, source laundering, pretending stale docs are current. |
| The Architect           | Produce explicit acceptance criteria, constraints, interfaces, and ADR links where needed.          | Write implementation prose that belongs in task files.                    | Acceptance criteria matrix, boundary map, decision links.                               | “Could two builders implement this and land in the same place?”              | Architecture fan fiction, implicit invariants, hiding tradeoffs.           |
| The Auditor             | Describe current state, risk, and priority with evidence.                                           | Start prescribing fixes before surveying.                                 | File paths, metrics, traces, code excerpts, ranked findings.                            | “Is every finding grounded in observed reality?”                             | Fix-by-audit, vague smell hunting, debt inflation.                         |
| The Bug Hunter          | Reproduce first, isolate second, hypothesize third.                                                 | Ship code changes without a bounded reproduction story.                   | Reproduction steps, expected/actual, root-cause status, log snippets.                   | “Can another agent reproduce this from the report alone?”                    | One-shot debugging, log confetti, jumping to fixes.                        |
| The Builder             | Implement the smallest change that satisfies the spec or bug report.                                | Re-scope the task, rewrite architecture casually, or invent requirements. | Passing commands, before/after evidence, acceptance mapping.                            | “Did I satisfy the source doc exactly, no more and no less?”                 | Gold-plating, speculative cleanup, silent requirement edits.               |
| The Janitor             | Preserve behavior, codify invariants, use shim contracts when needed.                               | Smuggle feature work into refactors.                                      | Before/after behavior checks, contract notes, unchanged outputs.                        | “What evidence proves behavior stayed the same?”                             | Cleanup sprawl, signature drift, hidden semantic edits.                    |
| The Migrator            | Phase the change, preserve compatibility windows, document rollback points.                         | Treat an upgrade like a regular feature.                                  | Inventory, phased rollout plan, compatibility matrix, smoke results.                    | “Can this be paused, resumed, or rolled back cleanly?”                       | Big-bang migrations, mixed semantics, surprise breakage.                   |
| The Performance Surgeon | Benchmark before and after; optimize the bottleneck, not the vibe.                                  | Claim wins without measurement.                                           | Baselines, methodology, before/after benchmark output, regression checks.               | “Am I faster where it matters, and did anything else regress?”               | Microbenchmark theater, anecdotal speed claims, unreadable hot paths.      |
| The Test Author         | Add the minimum test surface that closes the confidence gap.                                        | Chase 100% coverage as a goal in itself.                                  | Failing test first when appropriate, targeted coverage evidence, final passing outputs. | “Do the tests describe the real contract and catch the failure class?”       | Snapshot sprawl, brittle UI tests, coverage vanity.                        |
| The Documentarian       | Write for the operator or reader who has work to do.                                                | Bury instructions in philosophy or duplicate the spec.                    | Built docs preview or lint output, cross-reference checks.                              | “Can a reader complete the task or understand the system without guesswork?” | README bloat, stale screenshots, repeating internal-only task scaffolding. |
| The Skeptic             | Attack assumptions, evidence quality, scope discipline, and proof of done.                          | Rewrite the branch unless explicitly asked.                               | Concrete findings tied to source doc, diff, and verification outputs.                   | “If I reject this, is the rejection operationally actionable?”               | Vague negativity, taste-policing, duplicate comments.                      |
| The Lead Engineer       | Decompose only when parallelism beats coordination cost; define task boundaries and merge criteria. | Spawn subagents because it feels elegant.                                 | Sub-task list, ownership map, merge checklist, review routing.                          | “Did decomposition reduce ambiguity and context pressure?”                   | Over-sharding, duplicate search work, orphan subtasks.                     |

### Considered and rejected

| Candidate        | Decision | Rationale                                                                                                                                                 |
| ---------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The Surveyor     | Rejected | Too far outside a coding-agent documentation core. Swarm should keep one `research.md` with `research_mode`, not a whole product-research persona family. |
| The Integrator   | Rejected | Integration is a task phenotype, not a framework-core mindset. Use `feature` or `migration` plus provider-specific constraints in the spec and skills.    |
| The Reviewer     | Rejected | Overlaps with The Skeptic. Diff-focused review is a review mode, not a separate persona.                                                                  |
| The Debugger     | Rejected | Overlaps with The Bug Hunter. Investigation-only work is covered by the `debugging` task type under The Bug Hunter.                                       |
| The Type Surgeon | Rejected | Too language-specific for a repo-agnostic framework. Better as an optional skill pack in TypeScript-heavy repos.                                          |

### Ship-ready `.agents/skills/personas/SKILL.md`

```md
---
name: personas
description: Canonical Swarm persona catalogue. Load this when selecting mindset, constraints, handoffs, and proof obligations for a task.
---

## Purpose

Swarm does not invent personas per session. It selects from a fixed roster so tasks are predictable, reviewable, and portable across tools.

## Core rules

1. Choose the persona from the routing tables. Do not improvise a new one.
2. Treat persona as operating discipline, not flavor text. The persona changes what counts as evidence, what must halt the task, and who should review the result.
3. If a task spans multiple disciplines, keep one primary persona and name secondary handoff partners explicitly in the task file.
4. If the source document and task type disagree with the chosen persona, the routing is wrong. Fix the routing before doing work.
5. Every persona must optimize for proof, not persuasion.

## Persona catalogue

### The Researcher

Use for external technical research and citation-heavy distillation.

- Default tasks: research-writing
- Must: cite rigorously, distinguish evidence from recommendation
- Must not: smuggle design decisions in as facts

### The Architect

Use for forward-looking design, constraints, and acceptance criteria.

- Default tasks: spec-writing
- Must: define boundaries, invariants, ADR links, and verifiable acceptance criteria
- Must not: drift into implementation details that belong in task files

### The Auditor

Use for current-state surveys and prioritized issue lists.

- Default tasks: audit-writing
- Must: describe the codebase as it is, with evidence
- Must not: propose repairs before establishing findings

### The Bug Hunter

Use for reproduction, isolation, and root-cause work.

- Default tasks: bug-report-writing, debugging
- Must: reproduce before fixing
- Must not: guess at root cause without evidence

### The Builder

Use for implementing approved behavior changes.

- Default tasks: feature, fix
- Must: make the smallest change that satisfies the source document
- Must not: invent requirements or perform speculative redesign

### The Janitor

Use for behavior-preserving restructuring.

- Default tasks: refactor
- Must: preserve observable behavior and record shim contracts
- Must not: smuggle in feature work

### The Migrator

Use for phased, mechanical, compatibility-sensitive change.

- Default tasks: migration
- Must: document inventory, compatibility windows, and rollback points
- Must not: run big-bang upgrades without staged proof

### The Performance Surgeon

Use for measured optimization.

- Default tasks: performance
- Must: benchmark before and after
- Must not: claim wins without measurements

### The Test Author

Use for targeted confidence-building tests.

- Default tasks: testing
- Must: add the smallest test surface that closes the risk gap
- Must not: chase coverage vanity

### The Documentarian

Use for durable user-facing and internal guidance.

- Default tasks: documentation
- Must: write for action and comprehension
- Must not: duplicate task-local execution notes

### The Skeptic

Use for adversarial review and rejection loops.

- Default tasks: review
- Must: challenge assumptions, evidence, and proof of done
- Must not: make unrequested implementation edits

### The Lead Engineer

Use for decomposition, delegation, and merge routing.

- Default tasks: orchestration
- Must: decompose only when parallelism beats coordination cost
- Must not: spawn subagents without clear boundaries and merge criteria

## Anti-patterns

- Persona cosplay with no change in evidence standard
- Creating a new persona because the task feels nuanced
- Switching persona mid-task without updating the task file
- Treating the persona block as decorative instead of binding
```

## Document types

Swarm should adopt a deliberately asymmetric document system. Diátaxis is useful here because it reminds us that not all documents serve the same reader need; ADR practice is useful because some decisions deserve durable records in source control; and current agent systems show that context must be progressively disclosed, not dumped wholesale into every run. The best Swarm shape is therefore a narrow distillation trunk plus a small set of sidecar reference docs. This also fixes a major Spec Kit weakness visible in community feedback: canonicality gets muddy when too many document types are half-source-of-truth and half-working-scratchpad. citeturn21view0turn21view1turn21view2turn21view4turn21view5turn19view1turn24view0turn24view3turn24view4

### Final document taxonomy

| Doc type                   | Purpose                                             | Create when                                                                                     | Lives under `.agents/`                                        | Required sections                                                                                  | Done looks like                                                                | Authoring persona                               | Downstream tasks                                                                   | Verbosity     | Lifecycle                                                           |
| -------------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | ----------------------------------------------- | ---------------------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------- |
| `research.md`              | External-source grounding and option analysis       | Training data, repo context, or existing docs are insufficient or stale                         | `research/{{slug}}/research.md`                               | Question, scope, sources, findings, options, recommendation, dropped details guidance              | Claims cited, options compared, recommendation explicit                        | Researcher                                      | spec-writing, audit-writing, bug-report-writing                                    | High          | draft → reviewed → distilled → archived/superseded                  |
| `spec.md`                  | Intended future state and acceptance criteria       | New behavior, planned modifications, migrations, integrations, user-facing docs changes         | `specs/{{slug}}/spec.md`                                      | Problem, goals, non-goals, acceptance criteria, constraints, interfaces, rollout notes, references | Acceptance criteria testable, ambiguity surfaced, ADR links attached if needed | Architect                                       | feature, migration, testing, documentation, review, orchestration                  | High → medium | draft → clarified → approved → implemented → amended/superseded     |
| `audit.md`                 | Honest current-state survey                         | Brownfield work, architecture drift, debt cleanup, performance triage                           | `audits/{{slug}}/audit.md`                                    | Scope, current state, evidence, prioritized findings, risk notes, recommended routes               | Findings ranked and evidenced; no repair hand-waving                           | Auditor                                         | refactor, performance, testing, review, orchestration                              | High → medium | requested → surveyed → reviewed → acted-on → stale/superseded       |
| `bug-report.md`            | Reproducible defect input                           | A defect or incident must be isolated before repair                                             | `bugs/{{slug}}/bug-report.md`                                 | Symptom, environment, reproduction, expected/actual, evidence, root-cause status, impact           | Another agent can reproduce it from the doc                                    | Bug Hunter                                      | fix, debugging, testing, review, orchestration                                     | Medium        | reported → reproduced → root-caused → fix-ready → closed/superseded |
| `ADR-*.md`                 | Durable architecturally significant decision record | A decision changes structure, interfaces, dependencies, or non-functional behavior across tasks | `adr/ADR-{{nnnn}}-{{slug}}.md`                                | Status, context, decision, consequences, supersedes/superseded-by                                  | One decision per file, consequence explicit, status current                    | Architect                                       | co-source for spec-writing, migration, review                                      | Medium        | proposed → accepted/rejected → superseded                           |
| `architecture-overview.md` | Repo map, vocabulary, boundary overview             | Repo lacks a stable map for humans and agents                                                   | `reference/architecture-overview.md`                          | System map, modules, boundaries, glossary appendix, entrypoints, sharp edges, linked ADRs          | A new agent can orient quickly without reading the whole repo                  | Architect or Documentarian                      | co-source for spec-writing, audit-writing, feature, refactor, migration, debugging | Medium        | draft → current → stale → refreshed                                 |
| `SKILL.md`                 | Portable, reusable procedural knowledge             | A workflow recurs often enough to deserve first-class lazy loading                              | `skills/{{skill-name}}/SKILL.md`                              | Frontmatter, purpose, core rules, anti-patterns                                                    | Description is specific enough to load on demand; body stays procedural        | Any persona, usually Architect or Lead Engineer | loaded by routing, not routed into                                                 | Low → medium  | draft → validated → installed → revised/deprecated                  |
| `task.md`                  | Terminal, worktree-local execution scaffold         | Any agent is about to do work                                                                   | `tasks/{{slug}}/task-{{taskType}}.md` in worktree; gitignored | Persona block, constraints, source links, plan, proofs, self-review, promotion notes               | Verification pasted, open questions tagged, promotions recorded                | Any routed persona                              | none; terminal doc                                                                 | Low           | scaffolded → active → blocked/reviewed → accepted → discarded       |

### Considered and rejected

| Candidate                                                       | Decision                           | Rationale                                                                                                                                                     |
| --------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `migration-plan.md`                                             | Rejected as separate core doc type | Keep migrations inside `spec.md` using `change_class: migration`. A separate forward-looking doc duplicates the role of the spec and worsens canonicality.    |
| `postmortem.md`                                                 | Rejected from Swarm core           | Enterprises often already have incident systems. Distill postmortem findings into `bug-report.md`, `audit.md`, and ADRs instead of adding another trunk node. |
| `rfc.md`                                                        | Rejected                           | In Swarm, RFC energy belongs in `spec.md` plus ADR if the decision is architecturally significant.                                                            |
| `glossary.md`                                                   | Rejected as standalone             | Keep glossary as an appendix inside `architecture-overview.md`; one vocabulary file beats two half-kept ones.                                                 |
| `changelog` / `release-notes`                                   | Out of scope                       | Valuable, but not part of task conditioning.                                                                                                                  |
| Specialized `research-technical.md`, `research-market.md`, etc. | Rejected                           | One `research.md` with a `research_mode` field is leaner and avoids route explosion.                                                                          |

### Ready-to-ship document templates

#### `research.md`

```md
# {{slug}} Research

## Question

What exactly is unknown, and why does it matter?

## Research mode

technical | product | operational

## Why research is required

State why repo knowledge, model prior, or existing docs are insufficient.

## Scope

In scope:

- ...
  Out of scope:
- ...

## Sources

| Source | Why it matters | Date checked |
| ------ | -------------- | ------------ |
| ...    | ...            | ...          |

## Findings

### Finding

- Claim:
- Evidence:
- Confidence: high | medium | low

## Options considered

### Option A

- Pros:
- Cons:
- Risks:

### Option B

- Pros:
- Cons:
- Risks:

## Recommendation

Make the call. No hedging.

## What must survive distillation

- Constraints that must reach downstream docs
- Open questions that remain blockers
- Facts that are time-sensitive

## Considered and rejected

- ...
```

#### `spec.md`

```md
# {{slug}} Spec

## Problem

What user or system problem is being solved?

## Goals

- ...

## Non-goals

- ...

## Acceptance criteria

- [ ] ...
- [ ] ...
- [ ] ...

## Constraints

- Architectural:
- Security/compliance:
- Compatibility:
- Rollout/rollback:

## Interfaces and contracts

- Inputs:
- Outputs:
- Error cases:
- Backwards-compatibility notes:

## Migration and rollout notes

Only fill when `change_class: migration` or compatibility matters.

## Testability notes

How downstream task files should prove success.

## Open questions

- [CRITICAL] ...
- [MINOR] ...

## Assumptions

- [pending] ...
- [confirmed] ...

## References

- research:
- ADRs:
- architecture-overview:
```

#### `audit.md`

```md
# {{slug}} Audit

## Scope

What area of the codebase or behavior is being audited?

## Current state summary

Describe reality, not aspiration.

## Evidence

| Observation | Evidence | Severity |
| ----------- | -------- | -------- | ---- | ------ | --- |
| ...         | ...      | CRITICAL | HIGH | MEDIUM | LOW |

## Findings

### Finding

- What is wrong:
- Why it matters:
- Evidence:
- Suggested route: refactor | performance | testing | documentation | review

## Prioritized issue list

1. ...
2. ...
3. ...

## Preservation notes

Behavior or contracts that must not change during remediation.

## Open questions

- [CRITICAL] ...
- [MINOR] ...

## References

- architecture-overview:
- ADRs:
- related specs:
```

#### `bug-report.md`

```md
# {{slug}} Bug Report

## Symptom

Describe the defect precisely.

## Impact

Who or what is affected?

## Environment

- branch:
- version:
- runtime:
- data/setup assumptions:

## Reproduction steps

1. ...
2. ...
3. ...

## Expected result

- ...

## Actual result

- ...

## Evidence

- logs:
- screenshots:
- traces:
- failing tests:

## Root-cause status

- current best hypothesis:
- confidence:
- unknowns:

## Regression surface

What must be tested after a fix?

## Open questions

- [CRITICAL] ...
- [MINOR] ...

## Related docs

- spec:
- audit:
- ADR:
```

#### `ADR-{{nnnn}}-{{slug}}.md`

```md
# ADR {{nnnn}} {{slug}}

## Status

proposed | accepted | rejected | superseded

## Context

What architecturally significant choice is being made?

## Decision

State the decision in one paragraph.

## Consequences

- Positive:
- Negative:
- Follow-on work:

## References

- related specs:
- related audits:
- supersedes:
- superseded by:
```

#### `architecture-overview.md`

```md
# Architecture Overview

## Purpose

What this system is, at a glance.

## System map

- Entry points:
- Primary modules:
- External boundaries:
- Data flow overview:

## Module responsibilities

| Module | Owns | Must not own |
| ------ | ---- | ------------ |
| ...    | ...  | ...          |

## Build, test, and verification entrypoints

- install:
- typecheck:
- lint:
- test:
- build:
- smoke:

## Known sharp edges

- ...

## ADR index

- ADR-0001 ...
- ADR-0002 ...

## Glossary

| Term | Meaning |
| ---- | ------- |
| ...  | ...     |
```

#### Generic `SKILL.md`

```md
---
name: { { skill-name } }
description: { { one or two sentences specific enough for routing } }
---

## Purpose

Why this skill exists.

## Core rules

1. ...
2. ...
3. ...

## Anti-patterns

- ...
- ...
```

#### Generic `task.md` abstraction

```md
# {{slug}} Task

> **PERSONA:** {{persona-name}} — {{one-line role}}
>
> ⚠️ Halt on ambiguity. Do not invent requirements. Surface blockers with evidence.
>
> 🔒 This task file is worktree-local and gitignored. Durable findings must be promoted into specs, audits, bug reports, ADRs, research, or architecture-overview.

## Source documents

- Primary:
- Secondary:
- Skills loaded:
- Verification placeholders injected:

## Open questions

- [CRITICAL] ...
- [MINOR] ...

## Assumptions

- [pending] ...
- [confirmed] ...

<plan>
...
</plan>

## Self-review

All questions answered with a written trace. Paste command output. Do not paraphrase.
```

## Task types

The strongest lesson from current tools and user reports is that feature implementation is not the whole job. Aider’s `ask/code/architect` split, Devin’s `Ask` and `Agent` modes, Anthropic’s plan mode, and Cursor’s planning guidance all converge on a two-phase reality: analyze and scope first, then change code. Spec Kit feedback makes the missing half even clearer: bugs, refactors, reviews, migrations, and post-implementation fix loops are where real teams spend most of their time. Swarm should therefore separate document-authoring tasks from execution tasks and give brownfield work equal status with greenfield features. citeturn26view1turn16view6turn16view7turn33search4turn33search17turn32view0turn23view7turn23view4turn31view0

### Final task taxonomy

| Task type            | Purpose                                                    | Source documents                                        | Primary persona     | Secondary handoffs                  | Empirical proofs required                     | Done criteria                            |
| -------------------- | ---------------------------------------------------------- | ------------------------------------------------------- | ------------------- | ----------------------------------- | --------------------------------------------- | ---------------------------------------- |
| `research-writing`   | Produce or update `research.md`                            | direct request, none, stale docs                        | Researcher          | Architect, Auditor, Bug Hunter      | citations, comparison matrix                  | recommendation explicit, findings cited  |
| `spec-writing`       | Produce or amend `spec.md`                                 | direct request, research.md, ADR, architecture-overview | Architect           | Lead Engineer, Skeptic              | acceptance matrix, constraint list            | no hidden ambiguity, testable acceptance |
| `audit-writing`      | Produce `audit.md`                                         | direct request, repo state, postmortem import           | Auditor             | Janitor, Performance Surgeon        | evidence table, ranked findings               | findings prioritized and evidenced       |
| `bug-report-writing` | Produce `bug-report.md`                                    | direct request, incident, logs                          | Bug Hunter          | Builder, Test Author                | reproduction, expected/actual, evidence       | another agent can reproduce              |
| `feature`            | Implement new or changed behavior                          | spec.md                                                 | Builder             | Skeptic, Test Author, Documentarian | passing verification, acceptance mapping      | all criteria satisfied, outputs pasted   |
| `fix`                | Repair a bounded defect                                    | bug-report.md                                           | Builder             | Bug Hunter, Test Author, Skeptic    | repro before, regression after                | defect fixed with minimal scope          |
| `refactor`           | Restructure without behavior change                        | audit.md                                                | Janitor             | Test Author, Skeptic                | before/after equivalence evidence             | behavior preserved, debt reduced         |
| `migration`          | Execute staged, mechanical, compatibility-sensitive change | spec.md plus ADR when relevant                          | Migrator            | Architect, Skeptic, Documentarian   | inventory, staged checks, rollout proof       | migration complete or cleanly phased     |
| `performance`        | Improve a measured bottleneck                              | audit.md or spec.md                                     | Performance Surgeon | Test Author, Skeptic                | baseline and after benchmark                  | target improved without regressions      |
| `debugging`          | Investigate and report findings without necessarily fixing | bug-report.md                                           | Bug Hunter          | Builder, Skeptic                    | reproduction attempts, narrowed hypotheses    | findings durable and actionable          |
| `testing`            | Improve test surface as standalone work                    | spec.md, bug-report.md, audit.md                        | Test Author         | Builder, Janitor                    | failing-then-passing or risk-closing evidence | confidence gap closed                    |
| `documentation`      | Write or update user-facing/internal docs                  | spec.md or audit.md                                     | Documentarian       | Architect, Builder                  | docs preview/lint/build output                | docs accurate, linked, and usable        |
| `review`             | Adversarially inspect branch or task outcome               | any durable source + task file + diff                   | Skeptic             | source owner, executor              | findings tied to evidence                     | PASS or explicit kickback                |
| `orchestration`      | Decompose and coordinate parallel work                     | spec.md, audit.md, bug-report.md                        | Lead Engineer       | Skeptic, all executors              | child task map, merge checklist, review map   | work decomposed cleanly and reintegrated |

### Considered and rejected

| Candidate          | Decision               | Rationale                                                                                                                                                        |
| ------------------ | ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `rewrite`          | Rejected               | “Behavior change is permitted” belongs in an amended or new `spec.md`, not in a fuzzy execution type. If behavior changes, it is feature work or migration work. |
| `upgrade`          | Rejected               | Upgrades are a migration subtype. Keep one compatibility-sensitive execution class.                                                                              |
| `integration`      | Rejected               | Third-party wiring is a feature subtype unless it is mechanically replacing existing integrations, in which case it is a migration.                              |
| `feature-revision` | Rejected as standalone | Kickbacks route to `fix` if the source doc stands, or back to `spec-writing` then `feature` if the source doc changes.                                           |

### Canonical task skeleton

All concrete `task-{type}.md` files share the same shell. Routing fills persona, source docs, skills, and verification placeholders from tables rather than improvising them at runtime.

```md
# {{slug}} {{taskType}}

> **PERSONA:** {{persona-name}} — {{one-line role}}
>
> ⚠️ Halt on ambiguity. Do not invent requirements. If the source doc is missing a decision, stop and record the blocker.
>
> ⚠️ Show, don't tell. Every important claim in this file must be backed by pasted evidence, command output, or a source-document citation.
>
> 🔒 This file is worktree-local and gitignored. Do not treat it as durable truth. Promote durable findings before closing the task.

## Routing

- task_type: {{taskType}}
- primary_source: {{primarySource}}
- secondary_sources:
  - {{secondarySource}}
- auto_loaded_skills:
  - personas
  - manage-task
  - documentation-gatekeeper
  - {{taskSpecificSkills}}

## Open questions

- [CRITICAL] ...
- [MINOR] ...

## Assumptions

- [pending] ...
- [confirmed] ...

<acceptance_criteria>

- [ ] ...
      </acceptance_criteria>

<plan>
1. ...
2. ...
3. ...
</plan>

<module_plan>

- touched modules:
- untouched modules:
- interface commitments:
  </module_plan>

<verification_plan>
pre-implementation:

- ...
  periodic:
- ...
  post-implementation:
- ...
  self-review:
- ...
  </verification_plan>

<before_state>
Paste baseline evidence here.
</before_state>

<after_state>
Paste final evidence here.
</after_state>

<shim_contracts>
List compatibility shims, temporary bridges, and removal conditions. Write "none" if none.
</shim_contracts>

<durable_promotions>

- promote_to: spec | audit | bug-report | ADR | research | architecture-overview | skill
- reason:
- link:
  </durable_promotions>

## Self-review

Answer every question with a written trace. Paste command output. Do not paraphrase.

<self_review>

- question:
- answer:
- evidence:
  </self_review>
```

### Type-specific inserts

#### `task-research-writing.md`

```md
<acceptance_criteria>

- [ ] The research question is explicit.
- [ ] Every non-trivial factual claim is cited.
- [ ] Competing options are compared.
- [ ] A recommendation is made.
- [ ] Distillation notes state what must survive downstream.
      </acceptance_criteria>

## Self-review

- Did I distinguish facts from synthesis?
- Did I resolve stale or time-sensitive facts?
- Did I mark uncertainty instead of smoothing it over?
```

#### `task-spec-writing.md`

```md
<acceptance_criteria>

- [ ] The intended behavior is concrete and testable.
- [ ] Non-goals are explicit.
- [ ] Acceptance criteria are observable.
- [ ] Constraints and interfaces are written down.
- [ ] Any architectural decision that should outlive the spec is linked to an ADR.
      </acceptance_criteria>

## Self-review

- Could a Builder implement this without asking a preference question I failed to surface?
- Are the acceptance criteria objective enough for a Skeptic to review?
- Did I accidentally write task-local implementation advice into a durable spec?
```

#### `task-audit-writing.md`

```md
<acceptance_criteria>

- [ ] Findings describe current reality.
- [ ] Each finding has evidence.
- [ ] Findings are prioritized.
- [ ] Preservation notes clarify what must not regress.
- [ ] Suggested downstream routes are explicit.
      </acceptance_criteria>

## Self-review

- Did I prove each finding with code or runtime evidence?
- Did I rank by impact rather than annoyance?
- Did I avoid prescribing repairs before finishing the survey?
```

#### `task-bug-report-writing.md`

```md
<bug_description>
Describe the user-visible or system-visible defect in one paragraph.
</bug_description>

<reproduction_steps>

1. ...
2. ...
3. ...
   </reproduction_steps>

<root_cause>

- status: pending | confirmed
- hypothesis:
- supporting evidence:
  </root_cause>

## Self-review

- Can a different agent reproduce this bug exactly?
- Is expected vs actual behavior unambiguous?
- Did I separate confirmed cause from plausible cause?
```

#### `task-feature.md`

```md
<acceptance_criteria>

- [ ] Every spec criterion is mapped to code and verification.
- [ ] New behavior is implemented with minimal surprise to adjacent modules.
- [ ] Any user-facing changes are documented or explicitly deferred.
      </acceptance_criteria>

## Self-review

- Which acceptance criterion is each changed file serving?
- What did I deliberately not change?
- If I touched architecture, did I promote it out of the task file?
```

#### `task-fix.md`

```md
<bug_description>
Summarize the defect and link the source bug report.
</bug_description>

<reproduction_steps>
Paste the reproduction used before the fix.
</reproduction_steps>

<root_cause>
State the confirmed cause or the narrowest supported hypothesis.
</root_cause>

## Self-review

- Did I reproduce before editing?
- What is the smallest change that removes the defect?
- What test or proof prevents this from silently returning?
```

#### `task-refactor.md`

```md
<acceptance_criteria>

- [ ] Targeted audit findings are addressed.
- [ ] Observable behavior is preserved.
- [ ] Shim contracts are documented when temporary bridges are required.
      </acceptance_criteria>

## Self-review

- What proof shows behavior stayed the same?
- Did I sneak in any user-visible change?
- Are all temporary shims named with removal conditions?
```

#### `task-migration.md`

```md
<acceptance_criteria>

- [ ] The migration inventory is complete for the scoped area.
- [ ] Compatibility windows and rollback points are explicit.
- [ ] Verification is staged, not only end-state.
      </acceptance_criteria>

## Self-review

- What happens if the migration pauses halfway?
- Can old and new paths coexist safely during rollout?
- Which evidence proves the old path is no longer needed?
```

#### `task-performance.md`

```md
<acceptance_criteria>

- [ ] A baseline benchmark was captured.
- [ ] The optimization targets a named bottleneck.
- [ ] Post-change benchmarks and regression checks are pasted.
      </acceptance_criteria>

## Self-review

- Did I optimize the measured bottleneck rather than the suspicious-looking code?
- Did any latency, memory, correctness, or readability regression appear elsewhere?
- Is the benchmark reproducible?
```

#### `task-debugging.md`

```md
<acceptance_criteria>

- [ ] The investigation narrows the search space.
- [ ] Reproduction attempts, probes, and findings are recorded.
- [ ] Durable findings are promoted into bug-report or audit.
      </acceptance_criteria>

## Self-review

- What is now ruled out?
- What remains unknown?
- Did I stop at findings instead of drifting into an unscoped fix?
```

#### `task-testing.md`

```md
<acceptance_criteria>

- [ ] The targeted risk gap is named.
- [ ] Tests are placed in the correct location.
- [ ] Tests fail for the right reason before the fix when applicable.
- [ ] Final passing outputs are pasted.
      </acceptance_criteria>

## Self-review

- What failure class do these tests catch?
- Are these tests too brittle for the confidence they buy?
- Did I add the minimum surface that closes the risk gap?
```

#### `task-documentation.md`

```md
<acceptance_criteria>

- [ ] The document serves a named reader doing a named job.
- [ ] Steps and references are accurate.
- [ ] Any screenshots or examples match the current behavior.
      </acceptance_criteria>

## Self-review

- Who is this for, and what do they need to accomplish?
- What stale or internal-only detail did I remove?
- Did I build or lint the docs where supported?
```

#### `task-review.md`

```md
<acceptance_criteria>

- [ ] Every finding is tied to source-doc intent, diff evidence, or verification evidence.
- [ ] PASS / REJECT is explicit.
- [ ] Kickbacks are actionable and minimally scoped.
      </acceptance_criteria>

## Self-review

- Did I challenge proof of done, not just code style?
- Which comments are blockers vs suggestions?
- Did I avoid duplicate or taste-based findings?
```

#### `task-orchestration.md`

```md
<acceptance_criteria>

- [ ] Work is decomposed into independent, reviewable slices.
- [ ] Each child task has a concrete source doc, task type, persona, and merge criteria.
- [ ] Merge order and skeptic review plan are explicit.
      </acceptance_criteria>

## Self-review

- Did decomposition reduce context pressure or just create meetings in markdown?
- Which tasks can truly run in parallel?
- What evidence must each child return before merge?
```

## Flow graph

The Swarm flow graph should be table-first and narrow by default. GitHub Spec Kit’s own issues and discussions show what happens when a framework leaves too many routing choices implicit: users invent parallel workflows for debugging, change requests, canonical spec maintenance, and multi-repo setups. Swarm should fix that by making every primary edge explicit, every sidecar edge typed as “co-source,” and every exception rule documented. citeturn23view4turn24view0turn24view3turn24view4turn24view5

### Full source-doc to task-type edge list

| Source doc                 | Task type                                          | Edge type   | Rationale                                                                                                |
| -------------------------- | -------------------------------------------------- | ----------- | -------------------------------------------------------------------------------------------------------- |
| none / direct request      | `research-writing`                                 | primary     | Start here when external facts are needed before any reliable design or repair can happen.               |
| none / direct request      | `spec-writing`                                     | primary     | Start here for requested future behavior when research is unnecessary.                                   |
| none / direct request      | `audit-writing`                                    | primary     | Start here for brownfield cleanup, structure questions, or “what is wrong here?” prompts.                |
| none / direct request      | `bug-report-writing`                               | primary     | Start here when the user reports a defect but reproduction and scope are not yet stabilized.             |
| `research.md`              | `spec-writing`                                     | primary     | Feature or migration work should distill external findings into a forward-looking spec before execution. |
| `research.md`              | `audit-writing`                                    | primary     | When research reveals current-state risk or mismatch, write an audit before remediation.                 |
| `research.md`              | `bug-report-writing`                               | primary     | When research is needed to understand an external dependency or protocol before defect isolation.        |
| `spec.md`                  | `feature`                                          | primary     | New or changed behavior from approved intent.                                                            |
| `spec.md`                  | `migration`                                        | primary     | Large mechanical or compatibility-sensitive change is still future-state work.                           |
| `spec.md`                  | `testing`                                          | primary     | Standalone confidence work tied to future-state acceptance.                                              |
| `spec.md`                  | `documentation`                                    | primary     | User-facing/internal docs that are part of the intended change.                                          |
| `spec.md`                  | `review`                                           | primary     | Skeptic can review spec completeness before implementation or branch conformance after implementation.   |
| `spec.md`                  | `orchestration`                                    | primary     | Lead Engineer decomposes large specs into child tasks.                                                   |
| `audit.md`                 | `refactor`                                         | primary     | Audit findings are the canonical input to behavior-preserving structural work.                           |
| `audit.md`                 | `performance`                                      | primary     | Current-state performance pathologies belong here.                                                       |
| `audit.md`                 | `testing`                                          | primary     | Audits often surface missing regression surfaces.                                                        |
| `audit.md`                 | `documentation`                                    | primary     | Brownfield cleanup frequently requires operator docs or architecture-overview refreshes.                 |
| `audit.md`                 | `review`                                           | primary     | Skeptic validates that selected findings were actually addressed.                                        |
| `audit.md`                 | `orchestration`                                    | primary     | Large audits may route into multiple refactor/performance/testing child tasks.                           |
| `bug-report.md`            | `fix`                                              | primary     | A fix should be downstream of a reproducible bounded defect.                                             |
| `bug-report.md`            | `debugging`                                        | primary     | Investigation-only tasks continue from the bug report without forcing repair.                            |
| `bug-report.md`            | `testing`                                          | primary     | Regressions often need test-first closure before or along with the fix.                                  |
| `bug-report.md`            | `review`                                           | primary     | Skeptic validates that the fix matches the defect and preserves bounds.                                  |
| `bug-report.md`            | `orchestration`                                    | primary     | Large incident clusters may split into several defect tasks.                                             |
| `ADR-*.md`                 | `spec-writing`                                     | co-source   | ADRs rarely replace specs; they constrain them.                                                          |
| `ADR-*.md`                 | `migration`                                        | co-source   | Accepted decisions can directly force compatibility or topology migrations.                              |
| `ADR-*.md`                 | `review`                                           | co-source   | Skeptic uses ADRs to reject code that violates accepted decisions.                                       |
| `architecture-overview.md` | `spec-writing`                                     | co-source   | Gives the Architect the repo map and vocabulary.                                                         |
| `architecture-overview.md` | `audit-writing`                                    | co-source   | Scopes audits against known module boundaries and sharp edges.                                           |
| `architecture-overview.md` | `feature` / `refactor` / `migration` / `debugging` | co-source   | Helps route work without making the overview itself a source-of-truth for intent.                        |
| `SKILL.md`                 | none                                               | non-routing | Skills attach to tasks; they do not originate them.                                                      |
| `task.md`                  | none                                               | terminal    | Task files are leaves, never roots.                                                                      |

### Persona attachment table

| Task type          | Primary persona     | Secondary handoffs                    |
| ------------------ | ------------------- | ------------------------------------- |
| research-writing   | Researcher          | Architect, Auditor, Bug Hunter        |
| spec-writing       | Architect           | Lead Engineer, Skeptic, Documentarian |
| audit-writing      | Auditor             | Janitor, Performance Surgeon, Skeptic |
| bug-report-writing | Bug Hunter          | Builder, Test Author                  |
| feature            | Builder             | Test Author, Skeptic, Documentarian   |
| fix                | Builder             | Bug Hunter, Test Author, Skeptic      |
| refactor           | Janitor             | Test Author, Skeptic                  |
| migration          | Migrator            | Architect, Skeptic, Documentarian     |
| performance        | Performance Surgeon | Test Author, Skeptic                  |
| debugging          | Bug Hunter          | Builder, Skeptic                      |
| testing            | Test Author         | Builder, Janitor, Performance Surgeon |
| documentation      | Documentarian       | Architect, Builder                    |
| review             | Skeptic             | source owner, executor                |
| orchestration      | Lead Engineer       | Skeptic, all child personas           |

### Skill attachment table

| Task type          | Auto-loaded skills                                                                                            |
| ------------------ | ------------------------------------------------------------------------------------------------------------- |
| research-writing   | personas, manage-task, documentation-gatekeeper, write-research, distillation-discipline, empirical-proof     |
| spec-writing       | personas, manage-task, documentation-gatekeeper, write-spec, architecture-violations, distillation-discipline |
| audit-writing      | personas, manage-task, documentation-gatekeeper, write-audit, empirical-proof, architecture-violations        |
| bug-report-writing | personas, manage-task, documentation-gatekeeper, write-bug-report, empirical-proof                            |
| feature            | personas, manage-task, documentation-gatekeeper, write-feature, empirical-proof, architecture-violations      |
| fix                | personas, manage-task, documentation-gatekeeper, write-fix, empirical-proof                                   |
| refactor           | personas, manage-task, documentation-gatekeeper, write-refactor, empirical-proof, architecture-violations     |
| migration          | personas, manage-task, documentation-gatekeeper, write-migration, empirical-proof, architecture-violations    |
| performance        | personas, manage-task, documentation-gatekeeper, write-performance, empirical-proof                           |
| debugging          | personas, manage-task, documentation-gatekeeper, write-bug-report, empirical-proof                            |
| testing            | personas, manage-task, documentation-gatekeeper, write-test, testing-file-layout, empirical-proof             |
| documentation      | personas, manage-task, documentation-gatekeeper, write-documentation, empirical-proof                         |
| review             | personas, manage-task, documentation-gatekeeper, adversarial-review, empirical-proof                          |
| orchestration      | personas, manage-task, documentation-gatekeeper, write-orchestration, distillation-discipline                 |

### Verification command table

Verification placeholders are configuration-injected, never invented in-session. Swarm should standardize the placeholder vocabulary even though the underlying commands are repo-specific. Current agent guidance from Anthropic, Cursor, Aider, and Devin all lands on the same core point: agents perform better when success is objectively checkable. citeturn19view0turn32view0turn26view0turn16view6

| Task type          | Pre-implementation                                                                                 | Periodic                               | Post-implementation                                                              | Self-review                                         |
| ------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------- |
| research-writing   | none by default; collect citations and file evidence                                               | n/a                                    | `{{cmdDocsLint}}` if available                                                   | paste citations and notes on dropped uncertainty    |
| spec-writing       | read-only repo evidence only                                                                       | n/a                                    | `{{cmdDocsLint}}` if available                                                   | acceptance trace and blocker list                   |
| audit-writing      | read-only repo evidence only                                                                       | n/a                                    | `{{cmdDocsLint}}` if available                                                   | paste evidence table excerpts                       |
| bug-report-writing | `{{cmdRepro}}` if available                                                                        | focused repro probes                   | rerun repro or failing tests                                                     | paste expected/actual evidence                      |
| feature            | `{{cmdInstall}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`                                        | focused `{{cmdTypecheck}}`, near tests | `{{cmdTypecheck}}`, `{{cmdLint}}`, `{{cmdTest}}`, `{{cmdBuild}}`, `{{cmdSmoke}}` | paste outputs for every command run                 |
| fix                | `{{cmdRepro}}`, `{{cmdTypecheck}}`                                                                 | focused failing tests                  | `{{cmdTypecheck}}`, `{{cmdTest}}`, `{{cmdBuild}}`, `{{cmdSmoke}}`                | paste repro before/after plus final outputs         |
| refactor           | `{{cmdTypecheck}}`, `{{cmdTest}}`, `{{cmdBuild}}` baseline                                         | focused invariants                     | same full suite                                                                  | paste before/after equivalence evidence             |
| migration          | `{{cmdInstall}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`, `{{cmdTest}}`, `{{cmdBuild}}`         | staged compatibility checks            | full suite plus `{{cmdSmoke}}`                                                   | paste phased outputs and rollback status            |
| performance        | `{{cmdBenchmark}}`, `{{cmdTypecheck}}`, `{{cmdTest}}` baseline                                     | focused micro/macro benchmarks         | `{{cmdBenchmark}}`, `{{cmdTypecheck}}`, `{{cmdTest}}`, `{{cmdBuild}}`            | paste benchmark methodology and results             |
| debugging          | `{{cmdRepro}}`, `{{cmdTypecheck}}`                                                                 | focused probes only                    | rerun repro where useful                                                         | paste narrowed findings, not just conclusions       |
| testing            | `{{cmdTypecheck}}`, `{{cmdTest}}` baseline                                                         | target tests                           | `{{cmdTypecheck}}`, `{{cmdTest}}`, `{{cmdBuild}}`                                | paste failing-then-passing traces when applicable   |
| documentation      | `{{cmdDocsLint}}` or docs build baseline                                                           | preview/build as needed                | `{{cmdDocsLint}}`, `{{cmdBuild}}` if docs site exists                            | paste docs preview/build output                     |
| review             | relevant suite for reviewed branch or diff; respect comments-only mode if only PR comments changed | optional targeted reruns               | full review evidence set                                                         | PASS/REJECT with proof references                   |
| orchestration      | none mandatory in parent; child tasks own verification                                             | child checkpoints                      | merge verification is child-driven                                               | paste child evidence inventory and unresolved risks |

### Edge cases

If a document is ambiguous, Swarm should classify by dominant informational direction. If it describes the system as it is, it is an audit. If it describes external evidence and alternatives, it is research. If it describes a bounded failure with reproduction, it is a bug report. If it mixes several, split it before execution. A research note that quietly became an audit should not route directly to a refactor; distill it into `audit.md` first. citeturn21view2turn24view5

If no source document is provided, Swarm should not default straight to code in enterprise settings. It should author the missing source doc first: `spec-writing` for desired change, `audit-writing` for brownfield cleanup, or `bug-report-writing` for defect repair. The only default exception is truly trivial work where the user has explicitly overridden the safeguard and the diff can be stated in one sentence. Anthropic’s own guidance on plan mode says planning adds overhead, but that overhead is worth paying when scope is unclear, the change spans files, or the codebase is unfamiliar; Swarm should formalize that judgment rather than leave it to mood. citeturn33search3turn33search4turn19view4

If the user overrides routing, allow it, but force the override into the task file with a written reason and upgraded self-review. If multiple source docs apply, choose one primary doc by intent and list the rest as co-sources. If they conflict, halt and surface the conflict instead of silently reconciling it. This is where Swarm should be stricter than typical agent tools. Spec Kit discussions around canonical specs and multi-repo setups show that “just keep going” is exactly how drift is created. citeturn24view0turn24view3turn24view4

### Recursion and kickback rules

When The Lead Engineer decomposes work, each child is its own conditioned triple:

`(source doc bundle, task type, persona) -> task-{{type}}.md`.

The parent task does not leak its persona into children. A child refactor spawned from a larger feature still becomes `audit-derived -> refactor -> Janitor`, not “feature work by Builder, but smaller.” Anthropic’s multi-agent work is clear on this point: subagents need explicit objectives, outputs, boundaries, and tool guidance or they duplicate work and leave gaps. citeturn19view3

When The Skeptic rejects a branch, the rejection itself becomes new conditioned work. The loop is:

1. Keep the original durable source doc as primary truth.
2. Add Skeptic findings as a secondary source.
3. Route to `fix` if the source doc still stands.
4. Route to `spec-writing` first, then back to `feature`, if the findings prove the source doc itself is wrong or incomplete.

Swarm should not keep a separate `feature-revision` task type. A revision is either a fix against the standing spec or a new/amended spec followed by feature work.

### Mermaid distillation graph

Swarm’s main graph should look like this, with ADR and architecture-overview as sidecars rather than extra trunk nodes. That structure keeps the distillation model legible while still preserving durable rationale and repo map material. citeturn21view4turn21view5turn19view1

```mermaid
flowchart TD
    U[Direct request / issue / incident] --> RW[research-writing]
    U --> SW[spec-writing]
    U --> AW[audit-writing]
    U --> BW[bug-report-writing]

    RW --> R[research.md]
    SW --> S[spec.md]
    AW --> A[audit.md]
    BW --> B[bug-report.md]

    R --> SW
    R --> AW
    R --> BW

    S --> F[feature]
    S --> M[migration]
    S --> T[testing]
    S --> D[documentation]
    S --> O[orchestration]
    S --> RV[review]

    A --> RF[refactor]
    A --> P[performance]
    A --> T
    A --> D
    A --> O
    A --> RV

    B --> X[fix]
    B --> G[debugging]
    B --> T
    B --> O
    B --> RV

    ADR[ADR sidecar] -. co-source .-> SW
    ADR -. co-source .-> M
    ADR -. co-source .-> RV

    AO[architecture-overview sidecar] -. co-source .-> SW
    AO -. co-source .-> AW
    AO -. co-source .-> F
    AO -. co-source .-> RF
    AO -. co-source .-> M
    AO -. co-source .-> G

    F --> TK[task-feature.md]
    M --> TM[task-migration.md]
    RF --> TR[task-refactor.md]
    X --> TX[task-fix.md]
    G --> TG[task-debugging.md]
    P --> TP[task-performance.md]
    T --> TT[task-testing.md]
    D --> TD[task-documentation.md]
    RV --> TV[task-review.md]
    O --> TO[task-orchestration.md]
```

## Skills

Current tool design has converged on a powerful pattern: instructions that are portable, discoverable, and loaded only when relevant. Anthropic’s skills model is explicit about metadata-first progressive disclosure; OpenCode and OpenHands both support skill directories and `.agents/skills` compatibility; Cursor now positions Agent Skills as an open standard distinct from always-on rules; and Aider’s convention-file model plus the broader AGENTS.md push shows why Swarm should treat tool-specific prompt files as adapters, not source of truth. At the same time, community reports from Cursor show that rule systems can drift, bifurcate, or be incompletely documented in ways that make product-specific instruction files unreliable as canonical artifacts. Swarm should therefore keep skills in `.agents/skills/` as the home format, with adapters or mirrors into tool-native systems as optional projections. citeturn19view1turn16view0turn16view4turn27view0turn27view1turn17search1turn35view0turn30view0turn30view1turn30view3

### Surviving skills

| Skill                      | Purpose                                                               |
| -------------------------- | --------------------------------------------------------------------- |
| `personas`                 | Canonical persona catalogue and selection rules                       |
| `manage-task`              | Maintain task files as live execution records rather than stale plans |
| `documentation-gatekeeper` | Enforce sequencing, blockers, and source-doc hygiene                  |
| `distillation-discipline`  | Control what can and cannot be dropped between document stages        |
| `empirical-proof`          | Require pasted evidence and explicit verification claims              |
| `architecture-violations`  | Guard module boundaries, ownership, and contract discipline           |
| `write-research`           | Citation-heavy research discipline                                    |
| `write-spec`               | Acceptance-criteria-first design writing                              |
| `write-audit`              | Evidence-first brownfield surveying                                   |
| `write-bug-report`         | Reproduction and root-cause discipline                                |
| `write-feature`            | Source-doc-constrained implementation discipline                      |
| `write-fix`                | Minimal, regression-safe defect repair discipline                     |
| `write-refactor`           | Behavior-preserving restructuring discipline                          |
| `write-migration`          | Compatibility-sensitive phased-change discipline                      |
| `write-performance`        | Benchmark-first optimization discipline                               |
| `write-test`               | Risk-targeted test-writing discipline                                 |
| `write-documentation`      | Reader-task-oriented documentation discipline                         |
| `write-orchestration`      | Decomposition and merge discipline                                    |
| `adversarial-review`       | Skeptic review protocol                                               |
| `testing-file-layout`      | Test placement and naming conventions                                 |

### Ship-ready skill files

#### `manage-task`

```md
---
name: manage-task
description: Maintain a Swarm task file as the live execution ledger for a session, including blockers, assumptions, evidence, and promotion notes.
---

## Purpose

Prevent task files from becoming fiction. The task file must describe the current session truth, not an optimistic plan from thirty minutes ago.

## Core rules

1. Update the task file before and after any meaningful shift in scope, evidence, or blockers.
2. Record open questions and assumptions explicitly with `[CRITICAL]` / `[MINOR]` and `[pending]` / `[confirmed]`.
3. Treat the task file as the place where proofs are pasted, not summarized.
4. If the task no longer matches the source document, halt and repair routing before coding.

## Anti-patterns

- Leaving the task plan untouched after discoveries invalidate it
- Writing “done” without pasted evidence
- Hiding blockers in chat instead of in the task file
```

#### `documentation-gatekeeper`

```md
---
name: documentation-gatekeeper
description: Enforce Swarm sequencing rules so execution only starts from the right source document and durable findings are promoted out of task files.
---

## Purpose

Make the documentation layer authoritative instead of advisory.

## Core rules

1. Do not start execution tasks without a valid source doc unless the framework explicitly allows it.
2. If the source document is missing, author it first.
3. If an execution task discovers durable truth, promote it before closing the task.
4. Do not let task files become durable truth.

## Anti-patterns

- Coding directly from a user request when a spec, audit, or bug report is required
- Editing specs casually inside a worktree-local task session
- Closing a task with unresolved durable findings still trapped in the task file
```

#### `distillation-discipline`

```md
---
name: distillation-discipline
description: Control information flow from high-verbosity documents to low-verbosity execution scaffolds without losing constraints, proofs, or open blockers.
---

## Purpose

Keep context small without letting important truth evaporate.

## Core rules

1. Preserve constraints, acceptance criteria, root causes, invariants, and blocker questions across distillation.
2. Drop dead ends, duplicated rationale, and narrative detail only when they are no longer decision-relevant.
3. Add a “what must survive distillation” note to research documents.
4. If you are unsure whether something is droppable, keep it one level longer.

## Anti-patterns

- Compressing away the very fact that makes the task safe
- Passing entire research dumps into task files
- Treating summarization as a synonym for lossy paraphrase
```

#### `empirical-proof`

```md
---
name: empirical-proof
description: Enforce proof-before-closure by requiring pasted command output, measured baselines, and concrete evidence for every important completion claim.
---

## Purpose

Replace “should work” with visible evidence.

## Core rules

1. Paste command output for all verification gates run.
2. Use before/after evidence for fixes, refactors, migrations, and performance work.
3. Prefer failing-then-passing traces over assertions that the issue is gone.
4. If no command exists, paste the closest inspectable artifact.

## Anti-patterns

- “All tests passed” with no output
- Benchmark claims with no methodology
- Reviewer confidence based on prose instead of proof
```

#### `architecture-violations`

```md
---
name: architecture-violations
description: Detect and prevent boundary breaks, ownership drift, and contract leaks during spec, feature, refactor, and migration work.
---

## Purpose

Keep agents from solving local tasks by violating global structure.

## Core rules

1. Name the owning module or boundary before moving responsibilities.
2. Flag cross-layer imports, contract leakage, and duplicated domain logic.
3. Prefer narrow adapters over broad reach-through access.
4. If the right ownership is unclear, escalate as a blocker.

## Anti-patterns

- Fixing architecture drift with more architecture drift
- Smearing domain logic across convenience layers
- Silent ownership changes without ADR or spec updates
```

#### `write-research`

```md
---
name: write-research
description: Produce a research.md that is citation-first, option-comparative, and explicit about what must survive later distillation.
---

## Purpose

Create external-source grounding that downstream docs can trust.

## Core rules

1. State the research question exactly.
2. Compare alternatives, not just findings.
3. Separate facts, judgments, and recommendations.
4. Record time-sensitive facts with check dates.

## Anti-patterns

- Source dumping
- Uncited claims
- Recommendations with no rejected alternatives
```

#### `write-spec`

```md
---
name: write-spec
description: Produce a spec.md with objective acceptance criteria, explicit constraints, and no hidden implementation assumptions.
---

## Purpose

Turn intent into a buildable, reviewable source of truth.

## Core rules

1. Make every acceptance criterion observable.
2. Write non-goals so downstream agents do not expand scope.
3. Record interface and compatibility constraints explicitly.
4. Link ADRs when decisions should outlive the feature.

## Anti-patterns

- Ambiguous “support X” language
- Sneaking detailed implementation steps into durable specs
- Omitting non-goals and letting scope bloat
```

#### `write-audit`

```md
---
name: write-audit
description: Produce an audit.md that describes current state with evidence, prioritizes findings, and preserves behavior constraints for remediation.
---

## Purpose

Give brownfield work the same rigor greenfield specs get.

## Core rules

1. Survey before prescribing.
2. Attach evidence to every meaningful finding.
3. Rank findings by risk and impact.
4. Record preservation notes for downstream refactors.

## Anti-patterns

- Writing a fix plan disguised as an audit
- Untiered finding lists
- Code smell claims with no proof
```

#### `write-bug-report`

```md
---
name: write-bug-report
description: Produce a bug-report.md that makes a defect reproducible, bounded, and repairable by another agent without extra interpretation.
---

## Purpose

Prevent “fixing” a bug that was never properly isolated.

## Core rules

1. Reproduce first.
2. Separate expected from actual clearly.
3. Mark root cause as confirmed or pending.
4. Name the regression surface that must be retested.

## Anti-patterns

- Vague symptom reports
- Root-cause certainty without evidence
- Missing environment/setup assumptions
```

#### `write-feature`

```md
---
name: write-feature
description: Implement feature tasks by following the source spec exactly, proving each acceptance criterion with concrete verification.
---

## Purpose

Keep feature work aligned to the approved spec.

## Core rules

1. Map each changed file to a spec criterion.
2. Prefer the smallest design that satisfies the spec.
3. Raise blockers instead of inventing missing decisions.
4. Promote durable discoveries out of the task file.

## Anti-patterns

- Gold-plating
- Silent scope expansion
- Architecture changes with no durable record
```

#### `write-fix`

```md
---
name: write-fix
description: Repair a bounded defect with the minimum safe change, anchored to a bug report and closed by regression evidence.
---

## Purpose

Make bug repair disciplined instead of improvisational.

## Core rules

1. Reproduce before editing.
2. Confirm or narrow the root cause.
3. Prefer surgical fixes over opportunistic cleanup.
4. Leave behind a regression barrier.

## Anti-patterns

- “Could not reproduce, but I changed some stuff”
- Drive-by refactors inside bug work
- No regression proof
```

#### `write-refactor`

```md
---
name: write-refactor
description: Perform behavior-preserving structural change with explicit before/after evidence and documented shim contracts where needed.
---

## Purpose

Let agents clean up structure without moving product behavior accidentally.

## Core rules

1. State the invariants being preserved.
2. Capture before-state evidence.
3. Use shim contracts for temporary compatibility bridges.
4. Remove or schedule shim removal explicitly.

## Anti-patterns

- Hidden semantic edits
- Refactors with no equivalence proof
- Permanent “temporary” shims
```

#### `write-migration`

```md
---
name: write-migration
description: Execute high-volume or compatibility-sensitive changes in phases, with inventory, rollback points, and staged verification.
---

## Purpose

Make upgrades and mechanical changes survivable in enterprise codebases.

## Core rules

1. Maintain an inventory of affected surfaces.
2. Prefer phased compatibility over big-bang replacement.
3. Capture rollback conditions.
4. Verify each stage, not just the final state.

## Anti-patterns

- One-shot upgrades with no rollback
- Mixing old/new semantics invisibly
- Treating migration status as binary when it is staged
```

#### `write-performance`

```md
---
name: write-performance
description: Improve performance only against measured baselines and with regression checks for correctness, stability, and maintainability.
---

## Purpose

Stop speculative optimization from masquerading as engineering.

## Core rules

1. Benchmark before changing code.
2. Name the bottleneck you are targeting.
3. Benchmark after.
4. Check for regressions outside the primary metric.

## Anti-patterns

- Vibes-based optimization
- Microbenchmarks for macro problems
- Faster code that is now wrong or impossible to maintain
```

#### `write-test`

```md
---
name: write-test
description: Add the smallest effective set of tests that closes a specific risk gap, with correct placement and clear contract coverage.
---

## Purpose

Use tests as confidence surfaces, not as decoration.

## Core rules

1. Name the risk the test closes.
2. Put the test in the correct layer and file location.
3. Prefer tests that describe contracts over implementation trivia.
4. Use failing-then-passing traces when appropriate.

## Anti-patterns

- Coverage vanity
- Snapshot sprawl
- Tests that break on harmless refactors
```

#### `write-documentation`

```md
---
name: write-documentation
description: Write user-facing or operator-facing docs that optimize for reader action, correctness, and maintenance rather than internal process dumping.
---

## Purpose

Keep durable docs useful for humans and discoverable for agents.

## Core rules

1. Write for a named reader doing a named job.
2. Prefer concrete steps and accurate examples.
3. Remove task-local execution chatter from durable docs.
4. Validate links, builds, or docs lint where available.

## Anti-patterns

- README bloat
- Repeating specs verbatim
- Stale examples and screenshots
```

#### `write-orchestration`

```md
---
name: write-orchestration
description: Decompose large work into independently reviewable child tasks with explicit routing, merge criteria, and skeptic review points.
---

## Purpose

Make parallelism pay for itself.

## Core rules

1. Split by independence, not by symmetry.
2. Give each child a source doc, task type, persona, and merge contract.
3. Minimize duplicate search and context acquisition across children.
4. Route all child outputs through Skeptic before merge where risk is non-trivial.

## Anti-patterns

- Over-sharding
- Child tasks with overlapping ownership
- Merge plans that assume consistency without checking
```

#### `adversarial-review`

```md
---
name: adversarial-review
description: Review a task outcome against the source documents, diff, and verification evidence, and either pass it or kick it back with actionable findings.
---

## Purpose

Turn review into a real quality gate.

## Core rules

1. Review against source-doc intent first, code style second.
2. Tie every finding to evidence.
3. Separate blockers from suggestions.
4. If rejecting, define the smallest rescuable next task.

## Anti-patterns

- Taste-based review
- Generic negativity
- Re-running the world when only new PR comments need processing
```

#### `testing-file-layout`

```md
---
name: testing-file-layout
description: Keep test files in the correct layer, naming pattern, and proximity so agents add confidence in the right place instead of scattering tests randomly.
---

## Purpose

Prevent test suites from becoming unsearchable and structurally misleading.

## Core rules

1. Place tests in the layer they validate.
2. Use the repo’s canonical naming and directory conventions.
3. Keep helper fixtures separate from assertion-bearing tests.
4. Avoid hidden cross-suite coupling.

## Anti-patterns

- Dumping all tests into one directory
- Integration behavior disguised as unit tests
- Reusable fixtures that quietly become global state
```

### Attachment rule for `(persona × task type)` combinations

Swarm should use a formula, not a giant ad hoc matrix:

- **Every valid combination** auto-loads: `personas + manage-task + documentation-gatekeeper`.
- **Every task type** then adds its task bundle from the task-type table.
- **The persona itself** is expressed in the `> **PERSONA:**` task header and the `personas` skill, not via one skill file per persona.

That makes the effective attachment table deterministic and compact:

| Valid combination                 | Effective skills                                                      |
| --------------------------------- | --------------------------------------------------------------------- |
| Researcher × research-writing     | base + write-research + distillation-discipline + empirical-proof     |
| Architect × spec-writing          | base + write-spec + architecture-violations + distillation-discipline |
| Auditor × audit-writing           | base + write-audit + empirical-proof + architecture-violations        |
| Bug Hunter × bug-report-writing   | base + write-bug-report + empirical-proof                             |
| Bug Hunter × debugging            | base + write-bug-report + empirical-proof                             |
| Builder × feature                 | base + write-feature + empirical-proof + architecture-violations      |
| Builder × fix                     | base + write-fix + empirical-proof                                    |
| Janitor × refactor                | base + write-refactor + empirical-proof + architecture-violations     |
| Migrator × migration              | base + write-migration + empirical-proof + architecture-violations    |
| Performance Surgeon × performance | base + write-performance + empirical-proof                            |
| Test Author × testing             | base + write-test + testing-file-layout + empirical-proof             |
| Documentarian × documentation     | base + write-documentation + empirical-proof                          |
| Skeptic × review                  | base + adversarial-review + empirical-proof                           |
| Lead Engineer × orchestration     | base + write-orchestration + distillation-discipline                  |

## Distillation

Swarm’s distillation model should borrow aggressively from context engineering and note-making theory, but adapt it for software delivery. Anthropic’s context-engineering guidance is explicit that effective agent behavior depends on curating what enters a bounded context window over time, not merely writing a clever prompt. Progressive summarization adds the right compression instinct; evergreen notes add the idea that durable knowledge should evolve and accumulate across projects; Diátaxis clarifies that different documents serve different needs; and atomicity warns against giant, overloaded artifacts. Swarm should apply all four lessons directly: durable documents should accrete, terminal task files should compress, and no stage should be allowed to silently drop constraints that later make work unsafe. entity["people","Andy Matuschak","notes writer"] and entity["people","Tiago Forte","productivity author"] are especially useful here because they frame compression as a deliberate processing discipline rather than as random shortening. citeturn19view2turn22view0turn22view1turn22view3turn22view4turn22view5turn22view6turn21view1turn21view3

### The verbosity gradient

From highest to lowest verbosity:

1. `research.md` — highest verbosity; source-rich, option-rich, uncertainty-rich.
2. `spec.md` / `audit.md` — high but bounded; durable, decision-bearing, meant to be read.
3. `bug-report.md` — medium; tightly scoped around one failure class.
4. `ADR-*.md` / `architecture-overview.md` — medium reference; durable but not session-saturating.
5. `task-{{type}}.md` — lowest verbosity; only what the current session must do, prove, and promote.
6. `SKILL.md` metadata — lowest startup verbosity, higher body verbosity only when loaded.

### Information-loss budget

| From            | To              | Permitted loss                                                  | Forbidden loss                                                                                           |
| --------------- | --------------- | --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `research.md`   | `spec.md`       | literature breadth, dead-end alternatives, deep source excerpts | acceptance-relevant facts, constraints, safety/compliance facts, unresolved blockers, decision rationale |
| `research.md`   | `audit.md`      | broader industry context, non-local examples                    | evidence about current-state risk or mismatch                                                            |
| `research.md`   | `bug-report.md` | wide option space                                               | reproduction-relevant external facts, version/protocol details                                           |
| `spec.md`       | `task.md`       | narrative framing, rejected alternatives, background motivation | acceptance criteria, constraints, interfaces, rollout notes, open blockers                               |
| `audit.md`      | `task.md`       | non-selected findings, long inventories outside scope           | selected findings, evidence, preservation notes, risk ranking                                            |
| `bug-report.md` | `task.md`       | exploratory dead ends, extra logs not needed for repair         | reproduction steps, expected/actual, impact scope, root-cause status, regression surface                 |

### Research-is-optional decision tree

Write `research.md` **only if one or more of these are true**:

1. The task depends on external APIs, libraries, protocols, laws, or product behavior that may have changed recently.
2. The repo lacks enough current documentation to safely infer the solution.
3. The change has security, compliance, privacy, or performance claims that require outside evidence.
4. The team is choosing among materially different approaches and needs a written option comparison.
5. The agent cannot answer “what facts am I relying on?” without hand-waving.

Skip `research.md` and go straight to `spec-writing`, `audit-writing`, or `bug-report-writing` when:

1. The needed truth is already in the repo and current.
2. The change is local, bounded, and structurally familiar.
3. There are no meaningful external dependencies or freshness risks.
4. The spec could be written from current code and user intent alone.

That decision rule is the practical fix for two opposing failure modes visible in the market: under-researched guesswork on the one hand, and Spec Kit-style document bloat on the other. citeturn19view2turn23view3turn31view0

### Why task files are terminal leaves

Task files are leaves because they are for execution state, not durable truth. They should be gitignored and worktree-local for three reasons:

1. They contain high-churn plan updates and pasted command output that would create noisy, fast-stale version history.
2. They often include branch-local assumptions, temporary shims, and session-specific blockers that should be promoted selectively.
3. They are the last compression stage before action, so they should stay minimal and disposable.

Tool guidance across Anthropic, OpenCode, and Aider points in the same direction even when the file names differ: stable instructions and reusable procedures should live in durable files, while active work should stay tightly scoped and context-efficient. citeturn19view0turn35view0turn26view0

### Promotion protocol

| Discovery in task session                                       | Promote to                 | Why                                       |
| --------------------------------------------------------------- | -------------------------- | ----------------------------------------- |
| A requirement or acceptance criterion was wrong                 | `spec.md`                  | Future work needs the corrected intent    |
| Current-state structural problem larger than the scoped task    | `audit.md`                 | Debt should become durable and triageable |
| A reproducible defect was found while doing other work          | `bug-report.md`            | Defects need bounded, replayable inputs   |
| A cross-cutting architectural decision was made                 | `ADR-*.md`                 | Rationale must outlive the task           |
| A repo map, boundary, or vocabulary insight is broadly reusable | `architecture-overview.md` | Orientation knowledge should accrete      |
| Reusable procedural knowledge emerged                           | `SKILL.md`                 | Future agents should load it lazily       |
| External-source fact or evaluation matters beyond this task     | `research.md`              | Keep source-backed truth durable          |

### Lifecycle state machines

| Doc type                   | States                                                              | Trigger                                                              |
| -------------------------- | ------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `research.md`              | draft → reviewed → distilled → archived/superseded                  | recommendation accepted and distilled                                |
| `spec.md`                  | draft → clarified → approved → implemented → amended/superseded     | questions resolved, then task generation, then later change requests |
| `audit.md`                 | requested → surveyed → reviewed → acted-on → stale/superseded       | remediation begins, then codebase moves on                           |
| `bug-report.md`            | reported → reproduced → root-caused → fix-ready → closed/superseded | defect understood and then resolved or obsoleted                     |
| `ADR-*.md`                 | proposed → accepted/rejected → superseded                           | architectural decision lands or is later replaced                    |
| `architecture-overview.md` | draft → current → stale → refreshed                                 | repo evolution invalidates parts of the map                          |
| `SKILL.md`                 | draft → validated → installed → revised/deprecated                  | repeated usage proves or disproves value                             |
| `task.md`                  | scaffolded → active → blocked/reviewed → accepted → discarded       | session ends; durable content promoted                               |

### Cross-reference rules

Canonical links:

- `spec.md` must link upstream to any `research.md` and ADRs it depends on.
- `audit.md` should link to `architecture-overview.md` and any related ADRs.
- `bug-report.md` should link to the violated spec if one exists.
- `task.md` must link to its primary source doc and any promotions it created.

Agent-discoverable, not mandatory:

- `architecture-overview.md` may mention relevant specs or audits, but it is a map, not a log.
- Skills can reference other files lazily; they should not require eager loading of every dependency.
- `.agents/` discovery is encouraged proactively, but reference docs should still be linkable.

### Worked verbosity diffs

#### `research.md -> spec.md`

**Source paragraph in research.md**

A vendor SDK changed its retry semantics in version 6, moving from idempotent backoff defaults to explicit policy configuration. In current docs, transient 429s are not retried unless a retry policy is installed. Two official examples also changed the pagination helper signature. Teams on older blog posts will likely mis-implement retries and silently under-fetch pages.

**Correct distillation into spec.md**

Add explicit retry policy configuration for 429 and 5xx responses. Acceptance criteria: transient 429s are retried with bounded backoff; pagination uses the v6 helper signature; no request loop exceeds the configured max attempts.

**Dropped and why permitted**

Dropped the source-walk narrative and broader option analysis. Kept the acceptance-relevant facts and freshness-sensitive API behavior.

#### `spec.md -> task.md`

**Source paragraph in spec.md**

Users can rename project labels inline from the board view. The rename must propagate everywhere labels are rendered, preserve sort order, and remain available to users with existing label-edit permission. No bulk label editing is part of this change.

**Correct distillation into task-feature.md**

`<acceptance_criteria>`

- [ ] Inline rename works from board view.
- [ ] Renamed label renders consistently everywhere in scope.
- [ ] Existing label-edit permission gate remains unchanged.
- [ ] No bulk label editing is implemented.  
       `</acceptance_criteria>`

**Dropped and why permitted**

Dropped prose framing and reader-oriented explanation. Kept every constraint the executor and reviewer need.

#### `audit.md -> task.md`

**Source paragraph in audit.md**

Three modules duplicate currency-formatting logic with slightly different rounding behavior. Most UI paths call `formatMoney`, but checkout and export paths bypass it and implement their own conversions. This creates user-visible inconsistency and makes locale changes risky. Current behavior in checkout is the de facto contract and must be preserved for existing receipts.

**Correct distillation into task-refactor.md**

`<before_state>`

- checkout rounding behavior is the preservation baseline
- currency formatting duplicated in checkout, export, and shared UI paths  
  `</before_state>`

`<acceptance_criteria>`

- [ ] duplication removed behind one formatting module
- [ ] checkout receipt output remains unchanged  
       `</acceptance_criteria>`

**Dropped and why permitted**

Dropped the broader risk story once the scoped preservation baseline and objective were extracted.

#### `bug-report.md -> task.md`

**Source paragraph in bug-report.md**

On mobile Safari, opening the profile drawer after a fresh login can freeze the UI for 3–5 seconds. Reproduction rate is roughly 80% on first open only. Console logs show repeated avatar image decode attempts. Expected behavior is a responsive drawer open under 300ms with a single avatar fetch.

**Correct distillation into task-fix.md**

`<bug_description>`  
Profile drawer freezes on first open after fresh login in mobile Safari.  
`</bug_description>`

`<reproduction_steps>`

1. Fresh login on mobile Safari
2. Open profile drawer once
3. Observe 3–5s freeze and repeated avatar decode logs  
   `</reproduction_steps>`

`<acceptance_criteria>`

- [ ] first drawer open is responsive
- [ ] avatar decode happens once per open path  
       `</acceptance_criteria>`

**Dropped and why permitted**

Dropped the narrative estimate language and kept the scoped repro, evidence, and success condition.

## Synthesis

Swarm should be read as a documentation framework for safe agentic execution, not as a prompt collection. That is the key divergence from many current tools. MetaGPT and ChatDev prove the value of roles and stages; Anthropic proves the value of skills, context management, and explicit plan mode; Cursor, Aider, OpenCode, OpenHands, and Devin prove the value of splitting planning from execution and rules from on-demand skills; and enterprise deployments prove that guardrails, attribution, reviewability, and migration speed matter as much as raw autonomy. The result should be a framework that is stricter than today’s mainstream agent UX, but more portable and less tool-fragmented than the current ecosystem. citeturn20view0turn20view2turn16view0turn16view1turn19view0turn32view0turn26view1turn16view3turn35view0turn27view0turn16view6turn16view7turn32view1

### Recommended reading order

1. **Flow graph** — understand the routing discipline first.
2. **Document types** — know what each durable source doc is for.
3. **Task types** — see how source docs become executable work.
4. **Personas** — understand who owns which proof obligations.
5. **Skills** — understand how Swarm stays tool-agnostic and lazy-loaded.
6. **Distillation** — learn what is allowed to shrink and what must survive.
7. **Templates** — copy the shapes once the philosophy is clear.

### Sequence diagram from request to conditioned task

```mermaid
sequenceDiagram
    participant U as User / trigger
    participant R as Routing table
    participant D as Durable docs
    participant S as Skills
    participant T as Task scaffold

    U->>R: request arrives
    R->>D: classify source-doc need
    alt missing source doc
        R->>D: create research/spec/audit/bug-report authoring task
        D-->>R: durable source doc produced
    end
    R->>R: lookup task type from source doc
    R->>R: lookup primary persona from task type
    R->>S: attach base + task skills
    R->>T: inject persona block, source links, placeholders, self-review questions
    T-->>U: conditioned task-{{type}}.md ready
```

The important part is what does **not** happen: the agent does not invent a persona, does not invent verification commands, and does not decide ad hoc whether a task file is durable. Routing chooses the task type, routing chooses the persona, skills are attached deterministically, and repo-config placeholders are injected into a task scaffold that remains local to the active session. That is the correct enterprise-safe inversion of control. citeturn23view5turn19view4turn28view2

### Taxonomy summary tables

#### Personas × document types

| Persona             | research | spec              | audit             | bug-report        | ADR            | architecture-overview | skill   | task    |
| ------------------- | -------- | ----------------- | ----------------- | ----------------- | -------------- | --------------------- | ------- | ------- |
| Researcher          | author   | consult           | consult           | consult           | —              | consult               | author  | execute |
| Architect           | consult  | author            | consult           | consult           | author/consult | author                | author  | execute |
| Auditor             | consult  | consult           | author            | consult           | —              | consult               | author  | execute |
| Bug Hunter          | consult  | consult           | consult           | author            | —              | consult               | author  | execute |
| Builder             | consult  | consume           | consume minimally | consume           | consult        | consult               | consume | execute |
| Janitor             | consult  | consume minimally | consume           | —                 | consult        | consult               | consume | execute |
| Migrator            | consult  | consume           | consume minimally | —                 | consume        | consult               | consume | execute |
| Performance Surgeon | consult  | consume           | consume           | consume minimally | —              | consult               | consume | execute |
| Test Author         | consult  | consume           | consume           | consume           | —              | consult               | consume | execute |
| Documentarian       | consult  | consume           | consume           | consume minimally | consult        | author/consume        | author  | execute |
| Skeptic             | consult  | review            | review            | review            | review         | review                | consult | execute |
| Lead Engineer       | consult  | consume           | consume           | consume           | consult        | consult               | author  | execute |

#### Personas × task types

| Persona             | research-writing | spec-writing | audit-writing | bug-report-writing | feature            | fix                | refactor           | migration          | performance        | debugging          | testing            | documentation      | review  | orchestration |
| ------------------- | ---------------- | ------------ | ------------- | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------- | ------------- |
| Researcher          | primary          | secondary    | secondary     | secondary          | —                  | —                  | —                  | —                  | consult            | consult            | —                  | —                  | consult | —             |
| Architect           | secondary        | primary      | —             | —                  | secondary          | —                  | —                  | secondary          | —                  | —                  | —                  | secondary          | consult | secondary     |
| Auditor             | —                | —            | primary       | —                  | —                  | —                  | secondary          | —                  | secondary          | —                  | secondary          | —                  | consult | —             |
| Bug Hunter          | secondary        | —            | —             | primary            | —                  | secondary          | —                  | —                  | —                  | primary            | secondary          | —                  | consult | —             |
| Builder             | —                | —            | —             | —                  | primary            | primary            | —                  | —                  | —                  | secondary          | secondary          | secondary          | consult | —             |
| Janitor             | —                | —            | secondary     | —                  | —                  | —                  | primary            | secondary          | —                  | —                  | secondary          | —                  | consult | —             |
| Migrator            | —                | secondary    | —             | —                  | —                  | —                  | secondary          | primary            | —                  | —                  | —                  | secondary          | consult | —             |
| Performance Surgeon | —                | —            | secondary     | —                  | —                  | —                  | —                  | —                  | primary            | —                  | secondary          | —                  | consult | —             |
| Test Author         | —                | —            | —             | —                  | secondary          | secondary          | secondary          | secondary          | secondary          | —                  | primary            | —                  | consult | —             |
| Documentarian       | —                | secondary    | —             | —                  | secondary          | —                  | —                  | secondary          | —                  | —                  | —                  | primary            | consult | —             |
| Skeptic             | consult          | consult      | consult       | consult            | secondary reviewer | secondary reviewer | secondary reviewer | secondary reviewer | secondary reviewer | secondary reviewer | secondary reviewer | secondary reviewer | primary | secondary     |
| Lead Engineer       | —                | secondary    | —             | —                  | —                  | —                  | —                  | —                  | —                  | —                  | —                  | —                  | —       | primary       |

#### Document types × task types

| Source doc            | Authoring tasks                                                   | Execution tasks                                                       |
| --------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------- |
| none / direct request | research-writing, spec-writing, audit-writing, bug-report-writing | none by default                                                       |
| research.md           | spec-writing, audit-writing, bug-report-writing                   | none directly                                                         |
| spec.md               | —                                                                 | feature, migration, testing, documentation, review, orchestration     |
| audit.md              | —                                                                 | refactor, performance, testing, documentation, review, orchestration  |
| bug-report.md         | —                                                                 | fix, debugging, testing, review, orchestration                        |
| ADR                   | —                                                                 | migration, review as co-source only                                   |
| architecture-overview | —                                                                 | supports spec/audit/feature/refactor/migration/debugging as co-source |
| SKILL.md              | authorable anywhere                                               | never routes directly                                                 |
| task.md               | scaffold only                                                     | terminal only                                                         |

### Where Swarm specifically beats today’s best-known frameworks

Swarm’s strongest differentiators should be explicit:

- **Better than “spec-first only” systems** because it treats bug work, refactors, performance work, review loops, and debugging as first-class citizens instead of extensions or afterthoughts. Spec Kit’s own user base is asking for precisely this expansion. citeturn23view7turn23view4turn24view1
- **Better than prompt-file ecosystems** because it makes `.agents/` the durable home format and treats tool-native files as adapters. That matters because rule systems across tools are still in motion and can even diverge from their own docs. citeturn30view0turn30view1turn35view0
- **Better than role-factory frameworks** because it keeps personas thin, fixed, and tied to proof obligations, reducing the coordination drag that increasingly shows up in both official writeups and recent multi-agent research. citeturn19view3turn29search4
- **Better for enterprise** because auditability is built into the document system itself: exact source-doc lineage, explicit task routing, repo-injected verification placeholders, pasted outputs, and promotion rules. That aligns directly with what enterprise buyers are already demanding from agent platforms. citeturn28view0turn28view1turn28view2turn32view2turn32view3

### Open questions for the spec author

- **[CRITICAL]** Should Swarm standardize a closed verification placeholder set in v1 (`{{cmdLint}}`, `{{cmdTest}}`, `{{cmdBuild}}`, etc.), or allow arbitrary repo-defined placeholders beyond the core mandatory set?
- **[CRITICAL]** Can an execution task promote durable findings into versioned docs in the same branch, or must promotion happen in a follow-up doc-only review step for high-regulated environments?
- **[CRITICAL]** For monorepos, is `architecture-overview.md` one repo-wide file, or one file per bounded context plus an index?
- **[MINOR]** Should `bug-report.md` require a confirmed root cause before any fix task, or allow `[pending]` root cause so long as reproduction is stable?
- **[MINOR]** How long should worktree-local task files and pasted verification artifacts be retained outside Git history?
- **[MINOR]** Should Swarm define optional domain skill packs for language-specific deep work like TypeScript soundness, or leave them entirely out of core?

### Risks

| Risk               | Failure mode                                              | Mitigation                                                                                    |
| ------------------ | --------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Over-constraint    | Tiny changes feel bureaucratic                            | Explicit fast path for trivial, one-sentence diffs with user override and reduced scaffolding |
| Under-constraint   | Teams skip authoring docs and route straight to execution | Gate execution behind source-doc presence by default                                          |
| Misrouting         | Mixed documents blur current state vs intended state      | Require document splitting before execution                                                   |
| Role inflation     | Too many personas create coordination tax                 | Keep the roster fixed; reject persona creation inside sessions                                |
| Evidence bloat     | Task files become unreadable log dumps                    | Paste only load-bearing outputs; promote durable truth elsewhere                              |
| Canonicality drift | Specs, ADRs, and architecture docs diverge                | Promotion protocol plus Skeptic review against source-doc lineage                             |
| Tool capture       | One vendor’s file conventions distort the framework       | Keep `.agents/` as canonical, project adapters as projections                                 |

Swarm should be specified as a **typed, evidence-first, distillation-driven documentation system** for coding agents. If the spec stays faithful to that sentence, it will outperform the current market not by being louder, but by being the framework that enterprises can actually trust.
