# 📚 Document: research.md

> **TL;DR.** Outward-looking, citational document gathering external knowledge to inform a downstream decision. Maps to Diátaxis "Explanation". Authored by The Researcher (technical) or The Surveyor (UX/market). Spawns `spec-writing` tasks. Every claim cites a primary source; recommendation is actionable.

---

## 🎯 Purpose

Answer a specific, decision-informing question with cited evidence. The deliverable feeds a downstream `spec-writing` task; the spec author should be able to lift the recommendation directly into requirements.

The "research is optional" rule: if the agent's training data covers the topic adequately, research is not required. The framework forbids invented research files for trivia. The `write-research` skill includes a self-check: *"Could a competent agent answer this from training data alone? If yes, the research file is unjustified."*

---

## 📍 Where it lives

`.agents/research/{{slug}}.md`

Research files are *terminal* — they don't get "updated", they get *superseded* by newer research files when the world changes. (You can move superseded research to `.agents/research/superseded/` if the project finds the distinction useful.)

---

## ✍️ Authoring persona

[The Researcher](../personas/the-researcher.md) for technical topics (libraries, APIs, algorithms, standards, peer-reviewed sources). [The Surveyor](../personas/the-surveyor.md) for UX/market topics (user expectations, competitor behaviour, design patterns).

---

## 📐 Template

```markdown
# Research: <Question or topic>

## Status

Active / Superseded by `.agents/research/<newer-slug>.md`

## Author

The Researcher (technical) / The Surveyor (UX/market)

## Context

What decision this research informs. Who reads it (typically: an Architect about to write a spec).

## Linked docs

- Triggering ask: <path or paragraph>
- Related research files: `<paths>`
- Codebase context (if applicable): `<paths>`

## Research question

The specific, decision-informing question. One or two sentences. If you can't state it concisely,
the scope is unclear.

## Sources

Numbered. Primary sources preferred (papers, official docs, source code, standards). Each source
includes enough specificity for a reviewer to re-find it.

1. [<short-key>] <Author / Org>. *<Title>*. <venue / URL>. (consulted YYYY-MM-DD)
2. [<short-key>] ...

## Findings

Sub-topics, each with claims that trace to a numbered source.

### <Sub-topic 1>

- <Claim> [1][3]
- <Claim> [2]
- <Unverified claim> [unconfirmed]

### <Sub-topic 2>

- ...

## Comparison

Where multiple options exist, compare them explicitly with named criteria. Side-by-side, not narrative.

| Criterion | Option A | Option B | Option C |
| --------- | -------- | -------- | -------- |
|           |          |          |          |

## Recommendation

A specific, actionable recommendation. The spec author should be able to lift this into requirements.

If no recommendation is possible, explain *why* and what would unblock it.

## Open questions

- [ ] **[MINOR]** <questions left for follow-up — research, spec, or human decision>

## Distillation Loss Statement

(For research distilled from a longer investigation; see [`concepts/03-distillation.md`](../concepts/03-distillation.md))
```

---

## 🛠️ Worked example

See [The Researcher's worked example](../personas/the-researcher.md#%EF%B8%8F-example-how-the-researcher-resolves-a-representative-issue) — the message-broker comparison (NATS vs Redpanda vs RabbitMQ).

For the UX/market mode, see [The Surveyor's worked example](../personas/the-surveyor.md#%EF%B8%8F-example-how-the-surveyor-resolves-a-representative-issue) — the checkout-flow research with observed-vs-claimed reconciliation.

---

## 📖 Citation conventions

The framework's preferred citation format:

- **Numbered references** in the `## Sources` section, with `[1]`, `[2]`, etc. (or short keys like `[NATS]`, `[Anthropic-2026]`).
- **Inline citations** in `## Findings`: `[1]`, `[1][3]`, etc.
- **Primary source preferred:** papers > official docs > source code > standards > secondary commentary. Cite the most primary source available.
- **Verification stamp:** `(consulted YYYY-MM-DD)` so reviewers know how stale a source is.
- **Versions matter:** for libraries / specs, cite the version (e.g., `react@19.0.0`, `RFC 7636 §4.1`).

---

## ⚠️ Failure modes the `write-research` skill prevents

- **Opinion presented as finding** (no source citation)
- **Sources listed but not actually consulted**
- **Vague attribution** ("according to common practice")
- **Recommendations that say "it depends"** without saying *on what*
- **Inferring product behaviour** without verifying
- **Research without a decision-informing question** (research-for-its-own-sake)

---

## 🔭 Research vs Surveyor mode

| Mode                | Subject                                       | Persona                  | Sources lean toward                              |
| ------------------- | --------------------------------------------- | ------------------------ | ------------------------------------------------ |
| **Technical**       | Libraries, APIs, algorithms, standards        | The Researcher           | Papers, official docs, source code, standards    |
| **UX/market**       | User expectations, competitor behaviour, design patterns | The Surveyor   | User-research studies, competitor product behaviour, design references |

A single research file picks one mode. If the topic is genuinely both technical and UX (e.g., "what's the best library for SDK ergonomics"), split it: one technical research, one UX research.

---

## See also

- [`tasks/research-writing.md`](../tasks/research-writing.md) — the authoring task
- [`personas/the-researcher.md`](../personas/the-researcher.md) — technical mode
- [`personas/the-surveyor.md`](../personas/the-surveyor.md) — UX/market mode
- [`skills/write-research.md`](../skills/write-research.md) — the authoring skill
- [`skills/distillation-discipline.md`](../skills/distillation-discipline.md) — for distilling research into spec
- [`concepts/05-document-types.md`](../concepts/05-document-types.md) — the type's conceptual frame
