---
name: write-research
description: Author a research doc grounded in primary sources. ALWAYS apply this skill when the user asks for research, comparison, evaluation of options, or a recommendation that informs a downstream decision — including UX/market research and library/API/protocol research. Do not present opinion as finding, cite blog posts without finding the primary source, or output "it depends" without saying on what. Skip this skill for forward-looking spec authoring or present-state audit authoring — research is the upstream input to those, not a substitute.
---

# Skill: write-research

## Purpose

A research file answers a decision-informing question. The deliverable is a recommendation a spec author can lift directly into requirements. The discipline is *evidentiary*: cite or omit; vague attribution is not citation.

Two modes share this skill:

- **Technical research** — libraries, APIs, algorithms, standards, peer-reviewed sources.
- **UX/market research** — user expectations, competitor behaviour, design patterns. Same evidentiary discipline, applied to a softer subject.

A single research file picks one mode. If the topic is genuinely both technical and UX, split it.

## Core rules

### 1. State the decision-informing question

The research is bounded by the question. If you can't state the question in one or two sentences, the scope is unclear — clarify before searching.

- ✅ "Which message-broker library minimises operational complexity for our 10K msg/sec throughput target?"
- ❌ "Look into message brokers."

### 2. Every Findings claim cites a numbered source

Use `[1]`, `[2]`, `[short-key]` inline citations matched to entries in `## Sources`. A claim without a citation is opinion.

### 3. Primary sources preferred

Order of preference:

1. Standards documents (RFC, W3C, ISO)
2. Peer-reviewed papers
3. Official documentation of the library / API in question
4. The library's source code (cite repo + commit/version)
5. Verified product behaviour (interactive testing or recorded behaviour)
6. Secondary commentary (cite the primary source the commentary is based on)

If you cite a blog post, ask: what's the primary source the blog is based on? Cite that instead (or in addition).

### 4. At least three independent sources

Three is a minimum, not a target. The discipline is *coverage* of the space, not citation count. If the topic is genuinely small, three may suffice. If the topic is broad, more is needed.

### 5. Compare options explicitly

Where multiple options exist, compare them in a table with named criteria. Side-by-side, not narrative. The spec author should be able to lift the comparison directly into a `## Design decisions` section.

### 6. Recommendation is actionable

A spec author should be able to lift the recommendation directly into a spec's requirements. If no clear recommendation is possible, *say so explicitly* and state what would unblock it.

- ✅ "Adopt NATS JetStream. Three reasons: operational simplicity, gRPC-native integration, throughput exceeds target by 80×."
- ❌ "It depends on the use case."

### 7. Mark unverified claims `[unconfirmed]`

Don't fabricate. If a claim is not yet verified (couldn't reach the source, source was paywalled, the claim is conjecture from secondary materials), mark it `[unconfirmed]` rather than presenting it as fact.

### 8. Verify product-behaviour claims

Don't infer how a product behaves from its documentation; verify by interacting with it (curl, sandbox env, recorded session). The doc and the actual behaviour can diverge.

### 9. UX/market mode — concrete examples, not generalisations

For UX/market research:

- "Common practice" must cite at least three concrete examples
- User-expectation claims cite the research that produced them, not the agent's intuition
- Distinguish "what users do" (observed) from "what users want" (claimed) — they are different things
- Where competitors disagree, compare explicitly and state which approach this project should follow and why

### 10. Distillation Loss Statement when distilling

When the research distils a long-running investigation, append a `## Distillation Loss Statement` listing what was dropped from the upstream notes/transcript and why the next stage doesn't need it.

### 11. Pre-deliver visibility gate (forced visible output)

Do not finalise the research doc until every paragraph in `## Findings` ends with a `[N]` citation **and** every claim not yet verified is bracketed `[unconfirmed]`. Before declaring the doc done, output the verification table:

| Findings paragraph | Citation `[N]` present? | Claim verified or `[unconfirmed]`? |
| --- | --- | --- |
| <paragraph 1> | ✅ / ❌ | verified / `[unconfirmed]` |

A row with any ❌ means the doc is not finalisable — halt, fix the row, output the table again. The agent does not deliver the research doc to the user until this table is in the task file with all ✅.

## What does not belong

- **In `## Findings`:** opinion, intuition, "best practice" without citation.
- **In `## Sources`:** sources you didn't actually consult.
- **In `## Recommendation`:** "it depends" without saying *on what*; nothing-burgers ("further investigation needed" without naming what investigation).

## Anti-patterns

- Opinion presented as finding
- Sources listed but not actually consulted
- Vague attribution ("according to common practice")
- Recommendations that say "it depends" without saying on what
- Inferring product behaviour without verifying
- Citing blog posts without finding the primary source
- Research without a decision-informing question
- Treating one example as a pattern (UX mode)
- Conflating "users said they want X" with "users actually do X" (UX mode)

## Bundled resources

- `references/task-template.md` — a fillable research-task template combining the workflow scaffold (metadata, AGENTS.md contract, constraints, progress checklist, decisions, self-review) with the deliverable structure inlined as a `## Deliverable` block (research question, sources, findings, comparison table, recommendation, open questions, Distillation Loss Statement). At session close, copy the `## Deliverable` block to its final home (`<your-research-dir>/{{slug}}.md`).

Substitute the `{{...}}` placeholders and fill in as you work.
