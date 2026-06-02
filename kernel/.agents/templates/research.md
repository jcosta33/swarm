# Research: <Question or topic>

## Status

Active / Superseded by `.agents/research/<newer-slug>.md`

## Author

The Researcher (technical) / The Surveyor (UX/market)

## Context

What decision this research informs. Who reads it (typically: an Architect about to write a spec).

---

## Linked docs

- Triggering ask: <path or paragraph>
- Related research files: `<paths>`
- Codebase context (if applicable): `<paths>`

---

## Research question

The specific, decision-informing question. One or two sentences. If you can't state it concisely,
the scope is unclear.

---

## Sources

Numbered. Primary sources preferred (papers, official docs, source code, standards). Each source
includes enough specificity for a reviewer to re-find it.

1. [<short-key>] <Author / Org>. *<Title>*. <venue / URL>. (consulted YYYY-MM-DD)
2. [<short-key>] ...

---

## Findings

Sub-topics, each with claims that trace to a numbered source.

### <Sub-topic 1>

- <Claim> [1][3]
- <Claim> [2]
- <Unverified claim> [unconfirmed]

### <Sub-topic 2>

- ...

---

## Comparison

Where multiple options exist, compare them explicitly with named criteria. Side-by-side, not narrative.

| Criterion | Option A | Option B | Option C |
| --------- | -------- | -------- | -------- |
|           |          |          |          |

---

## Recommendation

A specific, actionable recommendation. The spec author should be able to lift this into requirements.

If no recommendation is possible, explain *why* and what would unblock it.

---

## Open questions

- [ ] **[MINOR]** <questions left for follow-up — research, spec, or human decision>

---

## Distillation Loss Statement

(For research distilled from a longer investigation)

**Dropped from upstream:**

- <what>

**Why downstream doesn't need this:**

- <why>
