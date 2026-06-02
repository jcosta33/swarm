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
- Deliverable path: `.agents/research/{{slug}}.md`

---

> 🔒 **RESEARCH SESSION** — Produces a research document, not code. No source/config/dependency changes. Copy `## Deliverable` to the path above at close (or keep this file as the deliverable).
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

What question this research must answer and what decision it informs. One paragraph maximum. Be concrete: "Which scheduling approach minimises jitter at 10ms lookahead?" not "how does scheduling work".

---

## Linked docs

- Triggering ask: `{{specFile}}` (or describe the human's prompt if none)
- Prior research / audits relevant: `<paths>`
- Codebase context (if applicable): `<paths>`

---

## Constraints

- **No source file changes — research document only**
- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Use search tools aggressively — codebase, official docs, papers, library source
- Mark unverified claims `[unconfirmed]`; do not present them as findings
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/research/`, `.agents/audits/`, `docs/`, `AGENTS.md`, and the project skills directory as needed.

---

## Progress checklist

- [ ] Refine the research question in the `## Deliverable` block below
- [ ] Plan sources to consult (breadth first, then depth)
- [ ] Conduct the search; capture sources as you go
- [ ] Draft findings, organised by sub-topic
- [ ] Compare options explicitly where multiple exist
- [ ] Write actionable recommendation
- [ ] Write Distillation Loss Statement (if distilling from a longer investigation)
- [ ] Self-review: every question answered
- [ ] Copy the `## Deliverable` block to its final home

---

## Deliverable

> Copy everything between this line and the `--- END DELIVERABLE ---` marker into `.agents/research/{{slug}}.md` at session close, demoting headings as needed.
>
> ⚠️ **EVERY CLAIM CITES A SOURCE.** Vague attribution ("according to common practice") is not citation. If you cannot trace a claim to a paper, doc, repo, or verified product behaviour, mark it `[unconfirmed]` or omit it. Fabricated findings poison every downstream session that uses them.

### Status

Active / Superseded by `.agents/research/<newer-slug>.md`

### Mode

Technical (libraries / APIs / algorithms / standards / peer-reviewed sources) — or UX/market (user expectations, competitor behaviour, design patterns). Pick exactly one; if the topic is genuinely both, split it.

### Context

What decision this research informs. Who reads it (typically the author of a downstream spec).

### Research question

The specific, decision-informing question. One or two sentences. If you cannot state it concisely, the scope is unclear — clarify before continuing.

### Sources

Numbered. Primary sources preferred (papers, official docs, source code, standards). Each source includes enough specificity for a reviewer to re-find it.

1. [<short-key>] <Author / Org>. *<Title>*. <venue / URL>.
2. [<short-key>] ...

### Findings

Sub-topics, each with claims that trace to a numbered source.

#### <Sub-topic 1>

- <Claim> [1][3]
- <Claim> [2]
- <Unverified claim> [unconfirmed]

#### <Sub-topic 2>

- ...

### Comparison

Where multiple options exist, compare them explicitly with named criteria. Side-by-side, not narrative.

| Criterion | Option A | Option B | Option C |
| --------- | -------- | -------- | -------- |
|           |          |          |          |

### Recommendation

A specific, actionable recommendation. The spec author should be able to lift this into requirements. If no recommendation is possible, explain *why* and what would unblock it.

### Open questions

- [ ] **[MINOR]** <questions left for follow-up — research, spec, or human decision>

### Distillation Loss Statement

(If distilled from a longer investigation.) **Dropped:** <what>. **Why downstream doesn't need it:** <why>.

--- END DELIVERABLE ---

---

## Decisions

(Session-level choices — distinct from the deliverable.)

- ***

## Findings (session meta)

(Process-level notes — distinct from the deliverable's findings.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

- *** (concrete starting points if this session ends incomplete)

---

## Self-review

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. An unanswered question is a skipped check. Review as a senior engineer about to greenlight this research as input to a spec.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →

### The read-only constraint — check this first

- Any modified source/config/dependency files in `git status`? A research session produces one output: the research document. Revert anything else immediately.
  Answer:

### Source coverage

- Did you consult primary sources (papers, official docs, source code), not just secondary commentary? Are at least three independent sources cited? Did you verify product-behaviour claims rather than infer them?
  Answer:

### Citation discipline

- Does every significant claim in the deliverable's Findings trace to a numbered source? Are unverified claims marked `[unconfirmed]` rather than presented as fact? Are quotations attributed and bounded?
  Answer:

### Recommendation actionability

- Could a spec author lift the recommendation directly into requirements? If no clear recommendation is possible, did you explain why and what would unblock it?
  Answer:

### Open questions

- Are unresolved questions flagged for a follow-up — research, spec, or human decision? Is it clear what would close each one?
  Answer:

### Final Polish

- Did you ask yourself: "What else could I do? Did I miss a primary source? Is a competing approach more defensible than the one I recommended?"
  Answer:
