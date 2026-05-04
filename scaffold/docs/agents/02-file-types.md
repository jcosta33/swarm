# 02 · File types

> **TL;DR.** Four core source-doc types with four distinct **epistemic stances**. Plus task files (worktree-local, gitignored). Plus optional extended types (ADR, constitution, migration plan, benchmark report). Each doc type has a defined location, an authoring persona, a set of required sections, and a downstream task type it spawns.

---

## The four core source-doc types

### 📜 spec.md — *forward-looking, prescriptive*

**Purpose:** Capture deterministic technical requirements for new behaviour. Maps to Diátaxis "Reference" — neutral, descriptive, source of truth.

**Where it lives:** `.agents/specs/{{slug}}.md`. After ship: `.agents/specs/shipped/`.

**Authoring persona:** The Architect.

**Spawns:** `feature` task.

**Required sections (template at `.agents/templates/spec.md`):**

- Status, Author, Context
- Linked docs (upstream research / audit, related ADRs, constitution)
- Goal (one paragraph; no implementation)
- Scope (in / out)
- User-visible behaviour (numbered)
- **Acceptance criteria** (each testable)
- **Design decisions** (each with named alternatives considered and rejected)
- Constraints (architectural, performance, security)
- Pattern survey (cited paths to existing helpers)
- Open questions (`[CRITICAL]` / `[MINOR]`)
- Tradeoffs and risks
- Distillation Loss Statement (when distilled from research)

**Failure modes the `write-spec` skill prevents:** unverifiable requirements, implementation specification, missing acceptance criteria, `[CRITICAL]` open questions left unresolved.

---

### 📊 audit.md — *present-looking, observational*

**Purpose:** Honestly describe the current state of a codebase area against a defined goal. Make the area *legible* so downstream work can be planned.

**Where it lives:** `.agents/audits/{{slug}}.md`. After all "Needed" entries close: `.agents/audits/resolved/`.

**Authoring persona:** The Auditor (or The Skeptic for `deepen-audit`).

**Spawns:** `refactor` task (default), `performance`, `deepen-audit`, or `bug-report-writing` depending on the findings.

**Required sections (template at `.agents/templates/audit.md`):**

- Status, Author, Context
- Linked docs (triggering brief, prior audit if deepening)
- Goal (measurable target)
- Scope (in / out)
- Code paths inspected
- **Findings** (each with severity / file:line / observation / "Needed" / verified by)
- Risks (with conditions and mitigations)
- Suggested approaches
- Open questions
- Distillation Loss Statement

**Failure modes the `write-audit` skill prevents:** vague observations promoted to findings, missing "Needed" entries, flat lists not prioritised by impact, unverified structural claims.

---

### 🐛 bug-report.md — *past-looking, evidential*

**Purpose:** Reliable reproduction + root cause + regression test plan. The fixer must be able to patch from the report alone.

**Where it lives:** `.agents/bugs/{{slug}}.md`. After fix + regression test: `.agents/bugs/closed/`.

**Authoring persona:** The Bug Hunter.

**Spawns:** `fix` task.

**Required sections (template at `.agents/templates/bug-report.md`):**

- Status, Author, Context
- Linked docs (reporter, related spec/audit)
- Reported behaviour
- **Reliable reproduction** (steps + expected vs actual + conditions)
- Reproduction attempts history (optional)
- Hypothesis tracker (with `[confirmed]` / `[disproven]` / `[supports]` / `[unverified]`)
- **Root cause** (file:line + state + input + caller — not the symptom)
- Related defects nearby
- **Regression test plan**
- Open questions
- Distillation Loss Statement

**Failure modes the `write-bug-report` skill prevents:** reporting symptom as root cause, speculating without reproducing, conflating "I think" with "I have proven".

**Why bug-report is its own meta-task:** the diagnosis and the fix have *different mindsets* and *different empirical proofs*. Splitting them lets each session be done well.

---

### 📚 research.md — *outward-looking, citational*

**Purpose:** Gather external knowledge to inform a downstream decision. Maps to Diátaxis "Explanation".

**Where it lives:** `.agents/research/{{slug}}.md`. Terminal — superseded by newer research when the world changes.

**Authoring persona:** The Researcher (technical) or The Surveyor (UX/market).

**Spawns:** `spec-writing` task.

**Required sections (template at `.agents/templates/research.md`):**

- Status, Author, Context
- Linked docs (triggering ask, related research)
- **Research question** (one or two sentences; decision-informing)
- **Sources** (numbered; primary preferred)
- **Findings** (every claim cites a numbered source)
- Comparison (where multiple options exist)
- **Recommendation** (actionable; or "no recommendation" with what would unblock)
- Open questions
- Distillation Loss Statement

**Failure modes the `write-research` skill prevents:** opinion presented as finding, sources listed but not consulted, recommendations that say "it depends".

**The "research is optional" rule:** if the agent's training data covers the topic adequately, research is not required. The framework forbids invented research files for trivia.

---

## Task files

**Purpose:** The worktree-local execution scaffolding. Names the persona, lists the skills, links the source doc, captures plan / progress / decisions / findings / blockers / next steps / self-review.

**Where it lives:** `.agents/tasks/{{slug}}.md` — **gitignored**.

**Authoring:** the launcher (CLI or human) scaffolds the file from the source doc. The agent fills in the in-flight sections.

**Lifecycle:** Active → (Paused if session ends mid-task) → Self-review → Done (or Kicked-back / Abandoned).

**Why gitignored:** task files are execution scaffolding. Durable findings migrate upstream (to audits/specs/research/bug-reports) before the worktree is deleted. Committing them would couple branches in unhelpful ways and pollute history.

The shared task skeleton lives at `.agents/templates/task-base.md`. Type-specific templates extend it (`task-feature.md`, `task-fix.md`, `task-refactor.md`, etc.).

---

## Extended doc types

These are optional but increasingly common. Projects adopt them when the structure earns its keep. They are *not* required for framework conformance.

| Doc                  | Specialises             | Where it lives                |
| -------------------- | ----------------------- | ----------------------------- |
| **ADR**              | spec (decision-only)    | `.agents/adrs/`               |
| **constitution.md**  | spec (project-wide)     | `.agents/constitution.md`     |
| **migration plan**   | spec (mechanical change) | `.agents/migrations/`         |
| **benchmark report** | audit (perf-specialised) | `.agents/benchmarks/`         |
| **cleanup list**     | audit (deletion)        | `.agents/cleanups/`           |
| **test plan**        | spec (test scope)       | `.agents/test-plans/`         |
| **audit brief**      | spec (small, up-front)  | `.agents/audit-briefs/`       |
| **research question** | spec (small, up-front) | `.agents/research-questions/` |
| **review scope**     | spec (small, up-front)  | `.agents/review-scopes/`      |

These are *specialisations* of the core types — an ADR is conceptually a small decision-only spec; a benchmark report is an audit specialised to performance.

---

## Forbidden compositions

The framework refuses:

- **A spec that contains current-state observations.** That's an audit. Split.
- **An audit that prescribes new behaviour.** That's a spec. Split.
- **A bug-report that fixes the bug.** Bug-report is a meta-task; the fix is downstream.
- **A research file that doubles as a spec.** The transition is `spec-writing` — separate task.
- **One doc with multiple `## Recommendation` sections covering different concerns.** Split.

The `documentation-gatekeeper` skill enforces these rules at the structural level.

---

## See also

- `01-process.md` — the documentation-first workflow
- `03-workflow.md` — step-by-step session flow
- `04-standards.md` — writing and execution standards
- `05-flow-graph.md` — the deterministic routing graph
- `.agents/templates/` — the actual templates
- `.agents/skills/documentation-gatekeeper/SKILL.md` — boundary enforcement
