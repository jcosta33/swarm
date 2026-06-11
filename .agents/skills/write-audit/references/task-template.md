# Audit session: {{title}}

## Metadata

- Slug: {{slug}}
- Guide: write-audit · Stance: Auditor
- Created: {{createdAt}}
- Status: active
- Deliverable: an audit in the kit template's shape (`starter-kit/advanced/audit.md`) at
  `.agents/audits/{{slug}}.md` in this repo (in an adopted workspace: `specs/<feature>/`)

---

> **AUDIT SESSION** — produces an observation-only audit document, not code and not a spec.
> No source/config/dependency changes. Copy the `## Deliverable` block to the path above at
> close.
>
> **Commands** resolve from the workspace `AGENTS.md` Commands table. If the table is missing
> or the command you need is not there, ask the user before substituting — never guess; a
> guessed command produces a false observation.

---

## Objective

What area, goal, or initiative this audit covers and why it is being audited now. One paragraph.

---

## Linked inputs

- Triggering ask: <path or one-line description of the request>
- Prior audit (if deepening): `<path>` — read with its framing CLOSED

---

## Constraints

- **Observation-only.** Record what *is* and the risk it carries. Assert no intended behavior,
  prescribe no fix inline, write no requirements (no AC items, no SOL blocks).
- **No source file changes — audit document only.** Do not switch branches, merge, rebase, or
  push unless instructed.
- Cite `file:line` or other evidence for every observation; vague impressions get demoted or
  removed.
- Verify dynamic properties, not just static text — concurrency, lifecycle, resource cleanup.
- Search for "no callers anywhere" across the whole codebase — dead code labelled as working is
  an observation.
- Read the related artifacts first: prior audits, the relevant specs, the workspace `AGENTS.md`.

---

## Progress checklist

- [ ] Define the measurable goal and the in/out scope inside the deliverable below
- [ ] List the code paths / artifacts / surfaces inspected
- [ ] If deepening: re-read with the prior audit closed; verify its cited `file:line`
      references still resolve
- [ ] Read each path adversarially
- [ ] Run cross-module caller searches for every public surface
- [ ] Verify dynamic properties (run the project's check commands where they surface them)
- [ ] Draft observations, each grounded in evidence; keep them present-state, never the fix
- [ ] Name risks with their firing conditions
- [ ] Calibrate severity by blast radius; record reasoning for any contestable call
- [ ] Record open questions / unverified areas — where the audit's evidence stops
- [ ] Write candidate requirements in prose
- [ ] Fill the completeness table in the self-review (all ✅)
- [ ] Copy the `## Deliverable` block to its final home

---

## Deliverable

> Copy everything between this line and `--- END DELIVERABLE ---` into the deliverable path at
> session close. Frontmatter follows the kit template: `type: audit`, `id: AUDIT-{{slug}}`,
> `title`, `status: draft`, `owner`, `sources[]` (the areas inspected).
>
> **Adversarial reading — always.** Do not trust that existing code works as intended. Assume
> the codebase is hiding its flaws. The audit is honest observation, not narrative validation.

### Audit: {{title}}

> Stance: **observation only.** This audit records what *is* — present-state risk, debt, drift,
> duplication, unsafe patterns. It never prescribes a fix and never writes requirements; those
> appear when a spec is written from it. Until then this document is evidence, not intent.

### Goal

What "good" looks like for this area, as a measurable target. Without a goal, "current state"
has no meaning.

### Scope

- **In scope:** (specific code paths / artifacts / surfaces under audit)
- **Out of scope:** (related areas deliberately excluded)

### Paths / surfaces inspected

- `<path>` — <one-line description of what's there>

### Observations

Each observation states what is true *today*, cites the evidence that grounds it, and carries a
severity. State the fact, never the fix.

#### O1 — <name> [Blocker | Major | Minor]

- **Evidence:** `<path>:<line>` / command output / grep result
- **Observation:** <what is true today>
- **Severity reasoning (if contestable):** <blast-radius rationale>

#### O2 — …

### Risks

Things that could go wrong but were NOT observed firing yet. Each names the failure mode and its
trigger — not the remedy.

- **R1** [severity] — <failure mode> — **fires when:** <condition>
- **R2** …

### Open questions / unverified areas

What this audit could NOT check, and questions that would change its prioritization if
answered. The self-review asks "what is the audit NOT saying" — this section is where the
answer lives, in the deliverable where the reader can see it.

- <property assumed but not verified / area not inspected> — why not: <access, time, tooling>
- <question that would reorder the risks if answered>

### Candidate requirements

What a spec written from this audit should require, in **plain prose** — leave AC numbering and
`Verify with:` lines to the spec.

- <what a future spec should require>

--- END DELIVERABLE ---

---

## Decisions

(Session-level choices — distinct from the deliverable's content.)

- …

## Assumptions

- [pending]

## Blockers

- …

## Next steps

- … (concrete starting points if this session ends incomplete)

---

## Self-review

> **Hard gate.** The session is not complete until every question below has a written answer
> directly beneath it and the completeness table is filled with all ✅. Review as a senior
> engineer about to greenlight this audit as input to spec or refactor work — look for what the
> audit does *not* say.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` → (must show only the audit doc; revert anything else — audit sessions are
  read-only)
- Project check commands run (last lines + exit):
- Cross-module caller greps for each public surface (paste results):

### Completeness table

| Item | Evidence present? | Severity | Firing condition (risks)? |
| --- | --- | --- | --- |
| O1 | ✅ / ❌ | Blocker / Major / Minor | ✅ / ❌ / n/a |

(Any ❌ → halt, fix the row, regenerate the table.)

### Goal and scope

- Is the goal a measurable target, and the scope tight enough that whoever acts on the audit
  can do so without it expanding under them?
  Answer:

### Observation specificity

- Does every observation cite `file:line` or other evidence? Are vague concerns sharpened or
  removed? Is every claim present-state — none asserting intended behavior or a fix?
  Answer:

### Stance held

- No requirements written? No inline fix? Candidate requirements in prose only?
  Answer:

### Severity calibration

- Calibrated by blast radius, not discovery order? Reasoning recorded for any contestable call?
  Answer:

### Adversarial completeness

- Prior audit (if any) read with its framing closed? Cross-module callers grepped? Dynamic
  properties verified rather than assumed from static text? What is the audit NOT saying —
  which properties did you assume held without checking?
  Answer:
