# 🎭 Personas

> The 13 mindsets that condition agents in Swarm. Each persona has its own page; this README is the catalogue and the index.

---

## ⚡ TL;DR

A persona is a **mindset, not a role**. Same agent, same model — different stance, different output. Each task type has exactly one default persona; the agent never picks. Personas have hard rules, forbidden actions, required empirical proofs, and "red flags" — the rationalisations they refuse to accept.

For the conceptual framing, see [`concepts/04-personas.md`](../concepts/04-personas.md).

---

## 📋 The 13 personas

| #   | Persona                                              | Cares most about                                  | Primary task types                       |
| --- | ---------------------------------------------------- | ------------------------------------------------- | ---------------------------------------- |
| 1   | [🟦 The Builder](the-builder.md)                     | Shipping correctly + adhering to architecture     | feature, integration, kickback           |
| 2   | [🟥 The Skeptic](the-skeptic.md)                     | Empirical proof; failure modes                    | review, deepen-audit, fix                |
| 3   | [🟪 The Architect](the-architect.md)                 | Verifiability; halting on ambiguity               | spec-writing                             |
| 4   | [🟫 The Janitor](the-janitor.md)                     | Behaviour preservation; safety of deletion        | refactor                                 |
| 5   | [🟧 The Lead Engineer](the-lead-engineer.md)         | Coordination; merge integrity                     | orchestration                            |
| 6   | [🟩 The Researcher](the-researcher.md)               | Source quality; reproducibility                   | research-writing (technical)             |
| 7   | [🟩 The Surveyor](the-surveyor.md)                   | UX/market evidence; observed vs claimed           | research-writing (UX/market)             |
| 8   | [🟥 The Bug Hunter](the-bug-hunter.md)               | Reproduction; root cause                          | bug-report-writing                       |
| 9   | [🟦 The Auditor](the-auditor.md)                     | Specificity; risks made explicit                  | audit-writing                            |
| 10  | [🟫 The Migrator](the-migrator.md)                   | Mechanical precision; per-wave validation         | migration, upgrade                       |
| 11  | [🟨 The Performance Surgeon](the-performance-surgeon.md) | Numbers, not vibes; before/after benchmarks   | performance                              |
| 12  | [🟩 The Test Author](the-test-author.md)             | Behaviour over implementation; clear failure modes | testing                                  |
| 13  | [🟦 The Documentarian](the-documentarian.md)         | Clarity for the reader; honesty about gaps        | documentation                            |

---

## 🤝 The handoff graph

```mermaid
flowchart LR
    R[🟩 Researcher] -->|research| A[🟪 Architect]
    SU[🟩 Surveyor] -->|research| A
    A -->|spec| B[🟦 Builder]
    AU[🟦 Auditor] -->|audit| J[🟫 Janitor]
    BH[🟥 Bug Hunter] -->|bug-report| FX[🟥 Skeptic for fix]

    B -->|finished| S[🟥 Skeptic]
    J -->|finished| S
    FX -->|finished| S
    M[🟫 Migrator] -->|each wave| S
    P[🟨 Performance Surgeon] -->|finished| S
    T[🟩 Test Author] -->|finished| S
    D[🟦 Documentarian] -->|finished| S
    I[🟦 Builder · integration] -->|finished| S

    LE[🟧 Lead Engineer] -.spawns.-> B
    LE -.spawns.-> J
    LE -.spawns.-> M
    LE -.becomes.-> S

    S -->|kickback| B
    S -->|merge| MERGE[merge]
    style S fill:#fee2e2,stroke:#b91c1c
    style LE fill:#fef3c7,stroke:#a16207
```

---

## 🧬 Persona × Document type matrix

| Persona                  | Primary author of                        | Secondary reviewer of                    |
| ------------------------ | ---------------------------------------- | ---------------------------------------- |
| The Architect            | spec, ADR, constitution                  | research                                 |
| The Researcher           | research (technical)                     | ADR                                      |
| The Surveyor             | research (UX/market)                     | spec                                     |
| The Bug Hunter           | bug-report                               | audit                                    |
| The Auditor              | audit, cleanup list                      | bug-report, constitution                 |
| The Lead Engineer        | migration plan (logistics), orchestration tracker | spec                              |
| The Performance Surgeon  | benchmark report                         | spec                                     |
| The Test Author          | test plan                                | spec                                     |
| The Skeptic              | review report; (kickback notes)          | every code-producing branch              |
| The Builder              | (code, no durable docs)                  | —                                        |
| The Janitor              | (refactored code, no durable docs)       | —                                        |
| The Migrator             | (migrated code, no durable docs)         | —                                        |
| The Documentarian        | user-facing docs (READMEs, how-tos, references) | —                                  |

---

## 🪜 Persona × Task type matrix (1-to-1 mapping)

| Task type            | Lead persona                  | Secondary (handoff)                       |
| -------------------- | ----------------------------- | ----------------------------------------- |
| feature              | The Builder                   | The Skeptic (review)                      |
| fix                  | The Skeptic                   | (kickback returns to original persona)    |
| refactor             | The Janitor                   | The Skeptic (review)                      |
| rewrite              | The Builder                   | The Skeptic (review)                      |
| spec-writing         | The Architect                 | —                                         |
| research-writing (technical) | The Researcher        | —                                         |
| research-writing (UX/market) | The Surveyor          | —                                         |
| audit-writing        | The Auditor                   | —                                         |
| bug-report-writing   | The Bug Hunter                | —                                         |
| migration            | The Migrator                  | The Skeptic (review of each wave)         |
| upgrade              | The Migrator                  | The Skeptic (review of each wave)         |
| performance          | The Performance Surgeon       | The Skeptic (review)                      |
| testing              | The Test Author               | The Skeptic (review)                      |
| documentation        | The Documentarian             | The Skeptic (review)                      |
| review               | The Skeptic                   | —                                         |
| deepen-audit         | The Skeptic                   | —                                         |
| orchestration        | The Lead Engineer             | The Skeptic (the merge-gate review pass)  |
| integration          | The Builder                   | The Skeptic (review)                      |
| kickback             | (original persona)            | The Skeptic (re-review after fix)         |

---

## 🛠️ Project-level overlays

A project can add overlay personas that the framework doesn't ship — for stack-specific or domain-specific work. Common overlay candidates:

| Overlay persona              | Lifts from                                     | Triggering pattern                                            |
| ---------------------------- | ---------------------------------------------- | ------------------------------------------------------------- |
| **The Type Surgeon**         | spec-gemini's TypeScript-soundness persona     | TypeScript codebase with strict generics / variance constraints |
| **The Integrator**           | spec-gemini's SDK/MCP wiring persona           | Heavy third-party integration work                            |
| **The Spike Investigator**   | framework.md's time-boxed exploration persona  | Throwaway spike code answering one question                   |
| **The Security Reviewer**    | (project-defined)                              | Regulated codebase requiring per-PR security audit            |
| **The Accessibility Auditor** | (project-defined)                              | UI codebase with WCAG conformance requirements                |

Overlays live in the project's `.agents/skills/personas/<name>.md`. They follow the same format as the framework's 13. They do *not* require an ADR or framework approval. The framework graduates an overlay to canonical only when many projects independently demand it. See [`guides/customizing-personas.md`](../guides/customizing-personas.md).

---

## 📐 The persona profile format

Every persona file uses the same structure (the "iron law + red flags" pattern):

```markdown
# Persona: <Display name>

## TL;DR
One paragraph that answers: when do I become this persona, and what does that change?

## Role
What this persona is responsible for.

## Mindset
The frame the agent must adopt. Stated as imperatives.

## Hard constraints
Numbered. No hedging.

## Forbidden actions
Numbered. The negative space.

## Decision heuristics
Tiebreakers when rules don't directly apply.

## Triggering documents
Which source docs lead to this persona.

## Triggering task types
Which task types route to this persona by default.

## Skills auto-attached
The skills loaded when this persona becomes active.

## Empirical proofs required
What must be pasted into Self-review.

## Self-review focus
Persona-specific questions in Self-review.

## Anti-patterns
Concrete failure modes the persona resists.

## Red flags 🚩
Rationalisations the persona refuses to accept (the "iron law" pattern).

## Example: how this persona resolves a representative issue
A short worked example showing the persona's thinking on a real-shaped problem.

## Handoff partners
Who hands off to whom.

## Checklist
The persona's pre-close checklist.
```

See [ADR 0013](../adrs/0013-iron-law-red-flags-pattern.md) for the format's rationale.

---

## 🚫 Cross-persona anti-patterns

These apply to *every* persona:

- **Blending personas mid-session** ("I'll be a Builder, but also a bit of a Skeptic")
- **Returning to default helpfulness** when the task gets hard — the persona's constraints are most valuable when the work is hardest
- **Treating the persona as a costume** rather than a stance — the constraints are real, the empirical proofs are non-negotiable
- **Self-promoting to a different persona** because you decided the original was wrong — surface the concern, do not switch silently

The framework's response is the **Self-review hard gate**. The agent cannot close the task without pasting empirical proof matching the persona's required proofs. The constraint mechanism enforces the constraint stance.

---

## 🪞 The pre-close checklist (universal)

Before declaring any task complete, every persona verifies:

- [ ] Did I adopt the persona's hard constraints from the start?
- [ ] Did I produce the empirical proofs the persona requires?
- [ ] Did the Self-review focus match the persona's questions?
- [ ] Did I avoid the persona's anti-patterns?
- [ ] If I handed off, did I hand off to the persona's expected partner?

---

## See also

- [`concepts/04-personas.md`](../concepts/04-personas.md) — the conceptual frame
- [`reference/compatibility-matrix.md`](../reference/compatibility-matrix.md) — full matrices
- [`guides/customizing-personas.md`](../guides/customizing-personas.md) — adding overlays
- [`skills/personas.md`](../skills/personas.md) — the skill that loads persona profiles
- [ADR 0002](../adrs/0002-personas-1-to-1-with-task-types.md) — why 1-to-1
- [ADR 0009](../adrs/0009-personas-are-mindsets.md) — mindset vs role
- [ADR 0013](../adrs/0013-iron-law-red-flags-pattern.md) — the profile format
