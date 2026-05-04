# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: documentation

---

> **DOCUMENTATION SESSION** — User-facing docs (READMEs, contributor guides, ADRs, public API docs). Distinct from `.agents/` documentation, which is agent-facing. The reader is a human who has not read the code; lead with what they need to do.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Documentarian** persona.

---

## Objective

What document is being written or updated, who reads it, and what they need to do after reading. One paragraph maximum.

---

## Linked docs

- Driving doc (spec, audit, or human ask): `{{specFile}}`

---

## Doc target

<doc_target>

**File:** the path to the document being written or updated.

**Doc type (Diátaxis frame):** _tutorial / how-to / reference / explanation_ — pick one. Do not mix.

**Audience:** who reads this doc. Be specific. "Developers" is not specific enough; "developers integrating our SDK for the first time" is.

**Reader's question:** the question this doc answers, stated as the reader would ask it.

</doc_target>

---

## Source material

<source_material>

What this doc draws on. Code, specs, audits, prior docs, runtime behavior. Every claim in the doc must trace to one of these sources.

-

</source_material>

---

## Examples to verify

<examples_to_verify>

Every code example must run as written. List each example, the command to verify it, and the expected output.

| Example | Verification command | Expected outcome |
| ------- | -------------------- | ---------------- |
|         |                      |                  |

</examples_to_verify>

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Lead with what the reader needs to do, not with background
- Every code example must run as written — verify before committing
- Every claim about behavior must be verifiable against the code (cite file:line)
- Do not mix Diátaxis types: tutorial / how-to / reference / explanation are different shapes for different needs
- Update existing docs when their world changes; stale docs are worse than no docs
- **Proactively research and read related docs.** Browse `docs/`, `.agents/specs/`, `.agents/research/`, and `AGENTS.md` as needed.

---

## Progress checklist

- [ ] Identify the doc type (one of the four Diátaxis frames)
- [ ] Identify the audience and the question they're asking
- [ ] List source material
- [ ] List examples to verify
- [ ] Outline the doc — what's the lead, what supports it
- [ ] Write the doc
- [ ] Verify every code example runs as written; paste output
- [ ] Cross-check every behavior claim against the code (cite file:line)
- [ ] Search for existing docs that this one supersedes or contradicts; update them
- [ ] `{{cmdValidate}}` passes (some projects lint docs)
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Reader-first answered
- [ ] Self-review: Examples actually run answered
- [ ] Self-review: Currency answered
- [ ] Self-review: Doc-type integrity answered

---

## Decisions

- ***

## Findings

Discoveries about the system that emerged while writing the doc. Move durable findings to an audit if they reveal real issues.

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

Concrete starting points for the next session if this one ends incomplete.

- ***

## Self-review

<self_review>

Stop. Documentation that hedges, that has examples that don't run, or that contradicts the code is worse than no documentation — it actively misleads. Act as a senior engineer hostile to vagueness.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- For each code example: the command output proving the example runs:
- `{{cmdValidate}}` (if doc linting applies, last 2 lines):

### Reader-first

- Does the doc lead with what the reader needs to do? Or does it bury the action under background paragraphs? Read the first 100 words — does someone with the reader's question find what they need there?
  Answer:

### Examples actually run

- Did you actually execute every code example, not just believe it would work? Did you paste the verification output above? Are the examples self-contained (no missing imports, no implied setup)?
  Answer:

### Currency

- Does the doc reflect the code as of this commit? Did you grep for other docs that contradict this one and update them? Are there `TODO` / `FIXME` / `XXX` markers left behind?
  Answer:

### Doc-type integrity

- Did you stick to one Diátaxis type, or did the doc drift between tutorial and reference? Tutorials are for learning; how-tos are for tasks; references are for lookup; explanations are for understanding. Mixing them confuses readers in all four modes.
  Answer:

### Final Polish

- Did you ask yourself: "Will a reader who hasn't seen the code understand this? Did I leave hedge words ('should', 'might', 'could') that the reader cannot act on? Is anything in this doc going to be wrong in three months?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
