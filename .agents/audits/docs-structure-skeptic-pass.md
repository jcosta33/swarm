# Audit: Framework documentation consistency (post-consolidation Skeptic pass)

## Status

Active

## Author

Skeptic (adversarial documentation review — human-initiated conditioning pass)

## Context

After consolidating legacy specs into `docs/` (reasoning layer) versus `scaffold/` (executable artefacts), a Skeptic-style review surfaced structural risks: residual duplication contradicting the separation-of-concerns goal, scaffold provenance ambiguity, pedagogical mismatches vs the flow-graph reference, and prose that contradicts observable repo contents. **This audit records those findings only** — remediation is deliberately out of scope for the session that spawned it.

## Linked docs

- Framework principles: [`docs/PRINCIPLES.md`](../../docs/PRINCIPLES.md)
- Non-goals (claims about repo contents): [`docs/NON-GOALS.md`](../../docs/NON-GOALS.md)
- Reference flow graph: [`docs/reference/flow-graph.md`](../../docs/reference/flow-graph.md)
- Skeptic framing: [`docs/personas/the-skeptic.md`](../../docs/personas/the-skeptic.md)

---

## Goal

Documentation should not **re-embed** scaffold bodies at scale; task-type pages should explain **per-type** conditioning; extended-type docs should follow the same “rationale only + pointer to `/scaffold`” pattern as the four core doc pages; cross-file claims about this repository should match the tree on disk.

---

## Scope

**In scope:** `docs/tasks/**`, `docs/documents/extended.md`, `scaffold/docs/agents/05-flow-graph.md`, `docs/reference/flow-graph.md`, `docs/NON-GOALS.md`, `docs/tasks/upgrade.md` (metadata vs reference).

**Out of scope:** Changing any of the above in this pass; CLI / launcher behaviour; consumer-project installs.

---

## Code paths inspected

- `docs/tasks/` — per-type rationale pages after template stripping
- `docs/documents/extended.md` — extended document catalogue and embedded templates
- `scaffold/docs/agents/05-flow-graph.md` — process copy shipped with scaffold
- `docs/reference/flow-graph.md` — normative task/persona/skill tables
- `docs/NON-GOALS.md` — repository shape claims

---

## Findings

### Issue 1 — Generic “structural clusters” rationale copied across task docs [MAJOR]

- **File:line:** Representative: [`docs/tasks/refactor.md`](../../docs/tasks/refactor.md) lines 38–46 (same table appears under `### Why these structural clusters exist` in most `docs/tasks/*.md`)
- **Observation:** Fifteen+ task documentation pages reuse an **identical** five-row table (Metadata, Linked docs, Banner, Plan/checklist, Self-review). The text is accurate as generic task-file hygiene but **does not differentiate** `refactor` checkpoint discipline, `fix` Skeptic proofs, `orchestration` worker tracker semantics, authoring tasks’ distillation gates, etc. That undermines the stated goal that `/docs` explains **task-specific** conditioning rather than duplicating scaffold elsewhere.
- **Needed:** Replace or augment the generic block with **per-task-type** rationale (even a short “What’s special for this type” subsection), or centralise the generic table once in `docs/tasks/README.md` / `docs/reference/task-base.md` and link from each task page without repeating verbatim.
- **Verified by:** search for heading `Why these structural clusters exist` under `docs/tasks/` — hits include `feature.md`, `fix.md`, `refactor.md`, `migration.md`, `spec-writing.md`, `orchestration.md`, `audit-writing.md`, and others with the same rows.

---

### Issue 2 — `extended.md` still embeds large template fenced blocks [MAJOR]

- **File:line:** [`docs/documents/extended.md`](../../docs/documents/extended.md) from line 39 (ADR template opener; additional fenced templates continue through ~400+ lines)
- **Observation:** Core four document pages (`spec`, `audit`, `bug-report`, `research`) were reduced to rationale + scaffold pointers. **Extended** variants still paste full Markdown skeletons (ADR Y-Statement, examples, additions to spec/audit templates, etc.). That reintroduces **docs↔scaffold drift** when templates in `scaffold/.agents/templates/` change and extended prose is not updated in lockstep.
- **Needed:** Mirror the core-doc pattern: short “design intent per extended type” + pointer to canonical templates under `/scaffold` (or explicitly state “no scaffold template yet — project-local only”) without multi-hundred-line fenced copies; or move literals to `scaffold/.agents/templates/` if missing.
- **Verified by:** open `docs/documents/extended.md` — multiple fenced `markdown` code blocks after line 39.

---

### Issue 3 — Dual flow-graph narrative: scaffold `05` vs `docs/reference` [MINOR]

- **File:line:** [`scaffold/docs/agents/05-flow-graph.md`](../../scaffold/docs/agents/05-flow-graph.md) (entire file); compare [`docs/reference/flow-graph.md`](../../docs/reference/flow-graph.md)
- **Observation:** Flow-graph material exists in **two** places: reference tables under `docs/reference/` and a process doc under `scaffold/docs/agents/`. The scaffold copy is correct for **consumer** self-containment but creates a **second edit surface** that can diverge from framework reference (wording, forbidden edges, skill lists) without CI.
- **Needed:** Document an explicit **source of truth** (likely `docs/reference/flow-graph.md` + concepts) and a regeneration or “do not diverge” rule for `scaffold/docs/agents/05-flow-graph.md`; or generate one from the other.
- **Verified by:** presence of both paths in tree; content overlap is intentional but not mechanically linked.

---

### Issue 4 — `upgrade` task doc vs reader expectations on `write-refactor` [MINOR]

- **File:line:** [`docs/tasks/upgrade.md`](../../docs/tasks/upgrade.md) line 34 (metadata: `write-refactor`); [`docs/reference/flow-graph.md`](../../docs/reference/flow-graph.md) (task type → skills for `upgrade`)
- **Observation:** Assigning `write-refactor` to `upgrade` / `migration` matches the **reference** table but reads as a **category error** to newcomers (“upgrade isn’t a refactor”). Risk: teams fork skills or bypass the table without recording rationale.
- **Needed:** One explicit sentence on the **upgrade** (and optionally **migration**) doc: *why* `write-refactor` encodes wave discipline / mechanical edits shared with preservative refactor patterns, or rename skill in a future framework revision with migration notes.
- **Verified by:** `docs/tasks/upgrade.md` metadata lists `write-refactor`; `docs/reference/flow-graph.md` aligns.

---

### Issue 5 — `NON-GOALS` claims “examples” in this repo [MINOR]

- **File:line:** [`docs/NON-GOALS.md`](../../docs/NON-GOALS.md) line 37
- **Observation:** Paragraph states the framework repo includes “documentation, scaffold artefacts, **examples**, and (eventually) a conformance checker.” The `docs/examples/` tree is **not** present in this repository after consolidation; conformance tooling is also **future**. The sentence is materially misleading unless “examples” means something else (e.g. skill subfolders named `examples/`) — in context it reads as repo top-level artefacts.
- **Needed:** Rewrite line 37 to match the actual tree (`docs/`, `scaffold/`, `README.md`, ADRs, optional `.agents/` for framework self-dogfood) or restore a dedicated examples area if policy requires it.
- **Verified by:** list `docs/` — no `examples/` directory at time of audit.

---

## Risks

| Risk | If it fires |
|------|----------------|
| Duplicated templates in `extended.md` rot silently | Consumers copy stale extended shapes; gatekeeper/ref drift |
| Uniform task rationales persist | `/docs/tasks` fails as a teaching layer; remains thin wrapper around scaffold |
| Two flow-graph sources diverge | Adopters get conflicting routing rules depending on which file they read |

---

## Suggested approaches

1. **Task docs:** For each task family (implementation / authoring / process), author one **shared** generic paragraph + **one** type-specific “load-bearing differences” list; remove duplicate tables from N pages.
2. **Extended docs:** Strip fenced templates; add scaffold links or new `scaffold/.agents/templates/extended-*.md` stubs as needed.
3. **Flow graph:** Add a one-line banner at top of `scaffold/docs/agents/05-flow-graph.md`: “Normative tables: `docs/reference/flow-graph.md` in the framework repo” or automate sync.
4. **NON-GOALS:** Single-sentence patch aligning repo description with reality.

---

## Open questions

- [ ] **[MINOR]** Should this framework repo commit **framework-owned** `.agents/audits/` (dogfood) or keep audits only in consumer copies? (This file assumes dogfood is valuable.)
- [ ] **[MINOR]** Is a dedicated `migration` / `upgrade` authoring skill preferable to overloading `write-refactor` long-term?

---

## Distillation Loss Statement

**Dropped from the review session:** line-level inventory of every `docs/tasks/*.md` file and every template subsection in `extended.md`.

**Why downstream doesn’t need it:** numbered issues above cite representative paths and verification approach; a Janitor/refactor or spec-writing follow-up can grep-expand if needed.
