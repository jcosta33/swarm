---
name: write-research
description: Load when authoring a research.md file. Encodes the research's discipline — every claim cites a primary source, options compared explicitly with criteria, recommendation actionable, unverified claims marked [unconfirmed].
---

# Skill: write-research

## Purpose

A research file answers a decision-informing question. The deliverable is a recommendation a spec author can lift directly into requirements. The discipline is *evidentiary*: cite or omit; vague attribution is not citation.

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

Where multiple options exist, compare them in a table with named criteria. Side-by-side, not narrative. The Architect should be able to lift the comparison directly into a `## Design decisions` section.

### 6. Recommendation is actionable

A spec author should be able to lift the recommendation directly into a spec's requirements. If no clear recommendation is possible, *say so explicitly* and state what would unblock it.

- ✅ "Adopt NATS JetStream. Three reasons: operational simplicity, gRPC-native integration, throughput exceeds target by 80×."
- ❌ "It depends on the use case."

### 7. Mark unverified claims `[unconfirmed]`

Don't fabricate. If a claim is not yet verified (couldn't reach the source, source was paywalled, the claim is conjecture from secondary materials), mark it `[unconfirmed]` rather than presenting it as fact.

### 8. Verify product-behaviour claims

Don't infer how a product behaves from its documentation; verify by interacting with it (curl, sandbox env, recorded session). The doc and the actual behaviour can diverge.

### 9. Distillation Loss Statement when distilling

When the research distils a long-running investigation, append a `## Distillation Loss Statement` per `.agents/skills/distillation-discipline/SKILL.md`.

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

## Two modes

The Researcher writes *technical* research (libraries, APIs, algorithms, standards). The Surveyor writes *UX/market* research (user expectations, competitor behaviour, design patterns). Same discipline, different subject matter.

A single research file picks one mode. If the topic is genuinely both technical and UX, split it.

## See also

- `.agents/templates/research.md` — the research doc template
- `.agents/templates/task-research.md` — the research-writing task template
- `.agents/skills/distillation-discipline/SKILL.md` — sister skill for distilling
- `.agents/skills/personas/SKILL.md` — The Researcher / The Surveyor personas
