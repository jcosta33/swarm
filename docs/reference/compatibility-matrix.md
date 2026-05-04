# 📖 Reference: Compatibility matrix

> Three printable tables. Designed to be the single most-referenced document in the repo.

---

## Table 1: Personas × Document types

Who authors what, who reviews what.

| Persona                  | Primary author of                          | Secondary reviewer of                  |
| ------------------------ | ------------------------------------------ | -------------------------------------- |
| The Architect            | spec, ADR, constitution                    | research                               |
| The Researcher           | research (technical)                       | ADR                                    |
| The Surveyor             | research (UX/market)                       | spec                                   |
| The Bug Hunter           | bug-report                                 | audit                                  |
| The Auditor              | audit, cleanup list                        | bug-report, constitution               |
| The Lead Engineer        | migration plan (logistics), orchestration tracker | spec                              |
| The Performance Surgeon  | benchmark report                           | spec                                   |
| The Test Author          | test plan                                  | spec                                   |
| The Skeptic              | review report, kickback notes              | every code-producing branch            |
| The Builder              | (code, no durable docs)                    | —                                      |
| The Janitor              | (refactored code, no durable docs)         | —                                      |
| The Migrator             | (migrated code, no durable docs)           | —                                      |
| The Documentarian        | user-facing docs (READMEs, how-tos, references) | —                                 |

---

## Table 2: Personas × Task types

The 1-to-1 mapping. Each task type has exactly one default lead persona.

| Task type                       | Lead persona                  | Secondary (handoff)                       |
| ------------------------------- | ----------------------------- | ----------------------------------------- |
| `feature`                       | The Builder                   | The Skeptic                               |
| `fix`                           | The Skeptic                   | (kickback returns to original)            |
| `refactor`                      | The Janitor                   | The Skeptic                               |
| `rewrite`                       | The Builder                   | The Skeptic                               |
| `migration`                     | The Migrator                  | The Skeptic (per wave)                    |
| `upgrade`                       | The Migrator                  | The Skeptic (per wave)                    |
| `performance`                   | The Performance Surgeon       | The Skeptic                               |
| `testing`                       | The Test Author               | The Skeptic                               |
| `integration`                   | The Builder                   | The Skeptic                               |
| `kickback`                      | (original persona)            | The Skeptic (re-review)                   |
| `spec-writing`                  | The Architect                 | —                                         |
| `research-writing` (technical)  | The Researcher                | —                                         |
| `research-writing` (UX/market)  | The Surveyor                  | —                                         |
| `audit-writing`                 | The Auditor                   | —                                         |
| `bug-report-writing`            | The Bug Hunter                | —                                         |
| `review`                        | The Skeptic                   | —                                         |
| `deepen-audit`                  | The Skeptic                   | —                                         |
| `orchestration`                 | The Lead Engineer             | The Skeptic (merge-gate)                  |
| `documentation`                 | The Documentarian             | The Skeptic                               |

The 1-to-1 mapping is the value: the agent never picks a persona; the framework picks. See [ADR 0002](../adrs/0002-personas-1-to-1-with-task-types.md).

---

## Table 3: Document types × Task types

What triggers what.

| Source document                              | Spawned task type(s)                                                | Information loss budget                  |
| -------------------------------------------- | ------------------------------------------------------------------- | ---------------------------------------- |
| `research.md` (technical or UX)              | `spec-writing`, `audit-writing`                                     | High (fluff dropped, findings kept)      |
| `spec.md`                                    | `feature`, `testing`, `rewrite`, `integration`                      | Zero (lossless execution)                |
| `audit.md`                                   | `refactor`, `performance`, `deepen-audit`                            | Medium (preserves numbered issues)       |
| `bug-report.md`                              | `fix`                                                               | Zero (exact root cause required)         |
| `migration plan`                             | `migration`, `upgrade`                                              | Zero (mechanical, surface-preserving)    |
| `benchmark report`                           | `performance`                                                       | Zero (numbers preserved)                 |
| `cleanup list`                               | `refactor`                                                          | Zero (deletion-safety preserved)         |
| `test plan`                                  | `testing`                                                           | Zero (test-case list preserved)          |
| `audit brief`                                | `audit-writing`                                                     | n/a (the brief is the framing)          |
| `research question`                          | `research-writing`                                                  | n/a                                      |
| `review scope`                               | `review`                                                            | n/a                                      |
| `ADR`                                        | `feature`, `refactor` (when ADR introduces a constraint to apply)   | Low (constraints immutable)              |
| `constitution.md`                            | `audit-writing`, adversarial-review                                 | Zero (supreme guidelines)                |
| `task scope` (one-paragraph in task file)    | `documentation`, small `testing`                                    | n/a (the scope is the framing)          |

The "information loss budget" column is the *maximum* loss permitted at the transition. See [`concepts/03-distillation.md`](../concepts/03-distillation.md) for the loss-budget concept.

---

## 🛡️ How to use these matrices

- **As a routing oracle.** "I have an `audit.md` — what's the task type?" Look at Table 3.
- **As a persona oracle.** "I have a `feature` task — what's the persona?" Look at Table 2.
- **As an authorship guide.** "Who should write the ADR?" Look at Table 1.
- **As a conformance reference.** Every cell of these tables is enforced by `documentation-gatekeeper`. Violations are blocked.

---

## See also

- [`flow-graph.md`](flow-graph.md) — the routing tables (with skills + verification commands)
- [`personas/`](../personas/) — per-persona pages
- [`tasks/`](../tasks/) — per-task pages
- [`documents/`](../documents/) — per-doc pages
- [ADR 0002](../adrs/0002-personas-1-to-1-with-task-types.md) — why 1-to-1
