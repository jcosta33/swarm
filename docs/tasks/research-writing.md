# 📋 Task: research-writing

> **TL;DR.** Produce a research file an Architect can lift directly into spec requirements. Lead persona is The Researcher (technical mode) or The Surveyor (UX/market mode). Every claim cites a primary source. End with an actionable recommendation. Read-only on source code.

---

## 🎯 When to use

A `research-writing` task is right when:

- A decision-informing question needs an external knowledge gathering session.
- The training-data answer is insufficient (or unverifiable).
- The output will feed a `spec-writing` task or an ADR.

If the answer is simple enough to capture in a task file's `## Findings`, you don't need a research file. The framework's "research is optional" rule: if a competent agent can answer from training data alone, the research file is unjustified.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `research question` (optional) / human ask         |
| **Lead persona**     | [The Researcher](../personas/the-researcher.md) (technical) **or** [The Surveyor](../personas/the-surveyor.md) (UX/market) |
| **Output**           | `research.md` at `.agents/research/{{slug}}.md`    |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-research`, `distillation-discipline` |
| **Verification gate slots** | post: `git status` (clean on source)        |

---

## 📐 Template

````markdown
# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: research

---

> 🔒 **RESEARCH SESSION** — This session produces a research document, not code. You may NOT modify any source files, configuration files, or dependencies. Output: `.agents/research/{{slug}}.md`.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Researcher** persona (technical mode). If the topic is UX/market rather than technical, switch to **The Surveyor** and document the choice in `## Decisions`.

---

## Objective

What question this research must answer and what decision it informs. One paragraph maximum. Be concrete: "Which scheduling approach minimises jitter at 10ms lookahead?" not "how does scheduling work".

---

## Linked docs

- Triggering ask: `{{specFile}}` (or describe the human's prompt if none)

---

## Research output

Write your research to: `.agents/research/{{slug}}.md`
Use the research template at `.agents/templates/research.md`.
Load `.agents/skills/write-research/SKILL.md` before starting.

> ⚠️ **EVERY CLAIM CITES A SOURCE.**
> Vague attribution ("according to common practice") is not citation. If you cannot trace a claim to a paper, doc, repo, or verified product behavior, mark it `[unconfirmed]` or omit it. Fabricated findings poison every downstream session that uses them.

---

## Research question

<research_question>

The specific, decision-informing question this research answers. If you cannot state the question in one or two sentences, the scope is unclear — clarify before continuing.

</research_question>

---

## Sources to consult

<sources>

Plan the search before doing it. Aim for breadth first, then depth on the most promising lines.

- [ ] Official docs of relevant libraries / standards
- [ ] Peer-reviewed papers (cite author, title, venue, year)
- [ ] Library source code (cite repo, file, commit/version)
- [ ] Comparable products' real behavior (verify, don't assume)
- [ ] Standards documents (cite spec and section)

</sources>

---

## Findings outline

<findings_outline>

Sub-topics this research covers. Fill in as the research progresses; restructure as understanding deepens.

1.
2.
3.

</findings_outline>

---

## Constraints

- **No source file changes — research document only**
- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Use search tools aggressively — codebase, official docs, papers, library source
- Mark unverified claims `[unconfirmed]`; do not present them as findings
- **Proactively research and read related docs.** If context from another spec, research, or audit is needed, you are empowered to browse `.agents/specs/`, `.agents/research/`, or `.agents/audits/` on your own. Codebase docs (`docs/`, `AGENTS.md`, `.agents/skills/`) are also fair game.

---

## Progress checklist

- [ ] Load `.agents/skills/write-research/SKILL.md`
- [ ] Load `.agents/skills/distillation-discipline/SKILL.md`
- [ ] Refine the research question above
- [ ] List sources to consult
- [ ] Conduct the search; capture sources as you go
- [ ] Draft findings, organised by sub-topic
- [ ] Compare options explicitly where multiple exist
- [ ] Write actionable recommendation
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Read-only constraint answered
- [ ] Self-review: Source coverage answered
- [ ] Self-review: Citation discipline answered
- [ ] Self-review: Recommendation actionability answered
- [ ] Self-review: Open questions answered

---

## Decisions

- ***

## Findings

(Session-level meta-observations. Durable findings move into the research file itself.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

- ***

## Self-review

<self_review>

Stop. Research that ships with shaky sources or vague recommendations sends every downstream session in the wrong direction. Act as a senior engineer about to greenlight this research as input to a spec, looking for every reason not to.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. An unanswered question is a skipped check. Incomplete Self-review is an invalid session output.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →

### The read-only constraint — check this first

- Any modified source/config/dependency files in `git status`? A research session produces one output: the research document. Revert anything else immediately.
  Answer:

### Source coverage

- Did you consult primary sources (papers, official docs, source code), not just secondary commentary? Are at least three independent sources cited? Did you verify product-behavior claims rather than infer them?
  Answer:

### Citation discipline

- Does every significant Findings claim trace to a numbered source in `## Sources`? Are unverified claims marked `[unconfirmed]` rather than presented as fact? Are quotations attributed and bounded?
  Answer:

### Recommendation actionability

- Could a spec author lift the recommendation directly into requirements? If no clear recommendation is possible, did you explain why and what would unblock it?
  Answer:

### Open questions

- Are unresolved questions flagged for a follow-up — research, spec, or human decision? Is it clear what would close each one?
  Answer:

### Final Polish

- Did you ask yourself: "What else could I do? Did I miss a primary source? Is a competing approach more defensible than the one I recommended?" Do not second-guess every decision, but do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

See [The Researcher's worked example](../personas/the-researcher.md#%EF%B8%8F-example-how-the-researcher-resolves-a-representative-issue) — the message-broker comparison (NATS vs Redpanda vs RabbitMQ) with primary sources and a single recommendation.

For UX/market mode, see [The Surveyor's worked example](../personas/the-surveyor.md#%EF%B8%8F-example-how-the-surveyor-resolves-a-representative-issue) — the checkout flow research with observed-vs-claimed reconciliation.

---

## ⚠️ Common anti-patterns

- Opinion presented as finding
- Sources listed but not actually consulted
- Recommendations that say "it depends" without saying on what
- Vague attribution ("according to common practice")
- Inferring product behaviour without verifying
- Research without a decision-informing question

---

## See also

- [`personas/the-researcher.md`](../personas/the-researcher.md) — technical mode
- [`personas/the-surveyor.md`](../personas/the-surveyor.md) — UX/market mode
- [`documents/research.md`](../documents/research.md)
- [`skills/write-research.md`](../skills/write-research.md)
- [`skills/distillation-discipline.md`](../skills/distillation-discipline.md)
