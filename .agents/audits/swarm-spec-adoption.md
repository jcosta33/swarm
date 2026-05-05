# Audit: Adoption review of `swarm-spec.md` against current `/docs` and `/scaffold`

## Status

Active

## Author

Auditor (adoption review — dogfood pass; the framework auditing itself against an externally-authored design recommendation)

## Context

`.agents/research/swarm-spec.md` is a 2,042-line external recommendation for what the Swarm framework "should be." It is roughly contemporaneous with our durable docs and overlaps materially with them, but it is not yet conditioned through `spec-writing`. This audit catalogues where the spec proposes structural additions we lack, where it proposes structural changes that conflict with prior accepted ADRs, and where it surfaces durable open questions we have not yet resolved.

> Note on the dogfood angle: this audit deliberately produces only ranked findings and routes — it does **not** prescribe edits. Per `write-audit` discipline (Survey before prescribing), every adoption move below should be promoted into either `spec-writing` (for changes) or new ADRs (for the divergences) before any docs PR.

## Linked docs

- Source recommendation: [`.agents/research/swarm-spec.md`](../research/swarm-spec.md)
- Framework principles: [`docs/PRINCIPLES.md`](../../docs/PRINCIPLES.md)
- Existing structural audit: [`.agents/audits/docs-structure-skeptic-pass.md`](docs-structure-skeptic-pass.md)
- Reference flow graph: [`docs/reference/flow-graph.md`](../../docs/reference/flow-graph.md)
- Personas catalogue: [`docs/personas/README.md`](../../docs/personas/README.md)
- Tasks catalogue: [`docs/tasks/README.md`](../../docs/tasks/README.md)
- Skills catalogue: [`docs/skills/README.md`](../../docs/skills/README.md)
- Documents catalogue: [`docs/documents/README.md`](../../docs/documents/README.md)
- Foundational ADRs: [`docs/adrs/0001-four-doc-types.md`](../../docs/adrs/0001-four-doc-types.md), [`docs/adrs/0006-skeptic-owns-fix-tasks.md`](../../docs/adrs/0006-skeptic-owns-fix-tasks.md)

---

## Goal

For each substantive structural piece in `swarm-spec.md`, determine whether it is:

1. **Adopt** — load-bearing structure we lack and that does not conflict with accepted ADRs; should become `spec-writing` work.
2. **Adapt** — useful concept but contradicts our current shape; should become `spec-writing` plus an ADR documenting the deviation either way.
3. **Defend / reject** — already adjudicated in our prior ADRs; surface the conflict so a future reader does not re-litigate it silently.

Severity uses our usual ladder (`CRITICAL` = framework gap, `MAJOR` = meaningful improvement, `MINOR` = nice-to-have).

---

## Direct contradictions matrix

This section enumerates every place where `swarm-spec.md` directly contradicts a current normative artefact in `/docs` (a README, reference table, ADR, or persona/task page). Each row carries a recommendation. Rows tagged **Defend** keep our current shape (the spec is the loser; the disagreement must be made explicit so it is not re-litigated). Rows tagged **Adapt** mean the spec wins (or partly wins) and we change. Rows tagged **Decide** are unresolved and require `spec-writing` + ADR before either side is binding. Detail is in the numbered findings that follow.

| #   | Topic                              | Our position (file:line)                                                                | Spec position (line)               | Severity | Recommendation                                                                                                                                      |
| --- | ---------------------------------- | --------------------------------------------------------------------------------------- | ---------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1  | Persona count                      | 13 (`docs/personas/README.md:17`)                                                       | 12 (line 26; rejects Surveyor at 62) | MAJOR    | **Decide.** Either ADR defending the Researcher / Surveyor split, or fold Surveyor into Researcher with `research_mode`. See Issue 12.              |
| C2  | Task type count                    | 18 (`docs/tasks/README.md:13`)                                                          | 14 (line 612 onward)               | MAJOR    | **Adapt.** Collapse `rewrite → feature`, `upgrade → migration`, `integration → feature`. ADRs needed for each surviving and each removed. See Issue 13. |
| C3  | `kickback` as a standalone task    | First-class type (`docs/tasks/README.md:32`, `docs/reference/flow-graph.md:93`)         | Not a type; route to `fix` or `spec-writing+feature` (lines 1115–1122) | MAJOR    | **Adapt.** Rename `kickback` to a routing pattern (the loop), not a task type. Keep the loop semantics; remove the standalone row.                  |
| C4  | `deepen-audit` as a standalone task | First-class type (`docs/tasks/README.md:48`, `docs/reference/flow-graph.md:90`)        | Not present; treats as `audit-writing` second pass | MAJOR    | **Adapt.** Fold into `audit-writing` with `audit_pass: deepen` mode. Keep the Skeptic-as-primary-on-deepen rationale in an ADR.                       |
| C5  | Lead persona on `fix`              | Skeptic (ADR 0006, `docs/reference/flow-graph.md:76`)                                   | Builder (lines 31, 619)            | MAJOR    | **Defend.** ADR 0006 stands. Append a "Considered and rejected: Builder-on-fix per `swarm-spec.md`" note to ADR 0006. See Issue 14.                  |
| C6  | `research.md` modes                | Two task subtypes — `research-writing (technical)` and `research-writing (UX/market)` (`docs/reference/flow-graph.md:42–43, 80–81`) | One `research.md` with `research_mode: technical \| product \| operational` field (line 235) | MAJOR    | **Decide.** If C1 collapses Surveyor, the mode field replaces the subtype split. Bundle decision with C1.                                            |
| C7  | ADR's home in the taxonomy         | "Extended doc type" orbiting spec (`docs/documents/README.md:30`, ADR 0001)             | Sidecar to the trunk, co-source for spec-writing/migration/review (line 206, 1031–1033) | MAJOR    | **Adapt.** Reclassify ADR as sidecar rather than extended-of-spec. Update ADR 0001 and `docs/documents/README.md`. See Issue 15.                      |
| C8  | `migration plan`, `constitution`, `audit brief`, `research question`, `review scope`, `test plan`, `cleanup list`, `benchmark report` as separate doc types | All listed as extended types in `docs/documents/README.md:30–38` and `docs/documents/extended.md` | Rejected as separate types; absorbed by core types via fields (lines 215–220) | MAJOR    | **Adapt.** Collapse into core types with field discriminators (`change_class: migration`, `audit_pass: brief`, etc.). The prior skeptic-pass audit's Issue 2 already supports this. See Issue 15. |
| C9  | `architecture-overview.md` location | `docs/reference/architecture-overview.md` is not present in the framework repo; `docs/guides/monorepo-setup.md` exists | Spec calls it sidecar reference doc, co-source for spec-writing/audit-writing/feature/refactor/migration/debugging (lines 207, 1034–1036) | MAJOR    | **Decide.** Either author the framework-level guidance (one repo-wide vs per-bounded-context monorepo shape — spec's CRITICAL open question) or note explicitly that `architecture-overview.md` is consumer-authored only.            |
| C10 | `architecture-violations` skill home | Project-specific only (`docs/skills/README.md:97–104`)                                  | Core auto-loaded skill (line 1196, 1729–1732) | MAJOR    | **Adapt.** Promote to core, ship a canonical `docs/skills/architecture-violations.md` + scaffold SKILL. See Issue 9.                                  |
| C11 | `write-migration` skill            | Not shipped; `write-refactor` is overloaded (`docs/reference/flow-graph.md:113–114`, `docs/tasks/README.md:155, 158` "overlap") | Separate first-class skill (line 1208, 1530–1554) | MAJOR    | **Adapt.** Either ship `write-migration` separately (preferred — closes the prior skeptic-pass audit's Issue 4 category-error risk) or ADR defending the overload. |
| C12 | `write-performance` skill          | Not shipped; `performance` task auto-loads only `empirical-proof` (`docs/reference/flow-graph.md:115`) | Separate skill (line 1209, 1556–1580) | MAJOR    | **Adapt.** Ship `write-performance`. Benchmark-first discipline is too specific to encode only via `empirical-proof`.                                  |
| C13 | `write-test` skill                 | Not shipped; `testing` task auto-loads only `empirical-proof` (`docs/reference/flow-graph.md:117`) | Separate skill (line 1210, 1582–1606) | MAJOR    | **Adapt.** Ship `write-test`.                                                                                                                        |
| C14 | `write-documentation` skill        | Not shipped; `documentation` task auto-loads `distillation-discipline + empirical-proof` (`docs/reference/flow-graph.md:118`) | Separate skill (line 1211, 1608–1632) | MINOR    | **Adapt.** Ship `write-documentation` if Issue 17's `documentation` task pages are restructured.                                                      |
| C15 | `write-orchestration` skill        | Not shipped; `orchestration` task auto-loads `adversarial-review + empirical-proof` (`docs/reference/flow-graph.md:120`) | Separate skill (line 1212, 1634–1658) | MINOR    | **Adapt.** Ship `write-orchestration` once Issue 8 (no-persona-leak) lands.                                                                          |
| C16 | `write-rewrite` skill              | Shipped (`docs/skills/README.md:45`, `docs/skills/write-rewrite.md`)                    | Not in the catalogue (consequence of `rewrite` task rejection) | MAJOR    | **Adapt** if C2 lands. Deprecate alongside the `rewrite` task type. Keep historical access via supersession.                                          |
| C17 | `testing-file-layout` skill home   | Project-specific (`docs/skills/README.md:99`)                                           | Core skill (line 1214, 1686–1709)  | MINOR    | **Adapt** with care. The skill's content is genuinely repo-specific (test directory naming); shipping a framework default risks consumer mismatch. ADR either way. |
| C18 | Auto-loaded skills as enumerated table vs `base + task bundle` formula | Two enumerated tables (`docs/reference/flow-graph.md:103–124`, `docs/tasks/README.md:142–163`) | Formula: `personas + manage-task + documentation-gatekeeper + task bundle` (lines 1716–1737) | MAJOR    | **Adapt.** Replace both tables with one per-task-bundle list. See Issue 7.                                                                            |
| C19 | Verification placeholder vocabulary | `cmdInstall, cmdValidate, cmdValidateDeps, cmdTypecheck, cmdTest, cmdBuild, cmdBenchmark` (`docs/reference/template-placeholders.md`) | Adds `cmdRepro, cmdSmoke, cmdLint, cmdDocsLint`; uses pre/periodic/post/self-review four-phase split (lines 1082–1097) | MAJOR    | **Adapt.** Spec the closed v1 vocabulary (CRITICAL open question on both sides). See Issues 10 + 16.                                                    |
| C20 | Verification phases per task type  | Three phases (Pre / Periodic / Post / Self-review collapsed) (`docs/reference/flow-graph.md:130`) | Four phases — pre-implementation, periodic, post-implementation, self-review — clearly separated (lines 1082) | MINOR    | **Adapt.** Adopt the four-phase split when C19 lands.                                                                                                |
| C21 | Persona expressed as a skill file vs in the task header | Both — persona blockquote AND a `personas` skill catalogue file (`docs/skills/README.md:27`, ADR 0009) | Header only; `personas` skill is the catalogue but not a per-persona skill (lines 1718) | MINOR    | **Already aligned.** ADR 0009 is consistent with the spec; `docs/personas/the-*.md` are reference pages, not loaded skills. Document this explicitly to remove ambiguity. |
| C22 | Information flow into `task.md`    | Markdown headers + `[Paste output]` placeholders (`docs/reference/task-base.md`, `docs/tasks/README.md:54–71`) | XML-style closed tag vocabulary (`<acceptance_criteria>`, `<plan>`, `<verification_plan>`, `<before_state>`, `<after_state>`, `<shim_contracts>`, `<durable_promotions>`, `<self_review>`) (lines 642–733) | MINOR    | **Adapt.** Define the closed tag vocabulary as the framework's machine-readable layer; keep headers as the human layer. See Issue 11.                  |
| C23 | Trivial-task fast path             | Allowed via task scope only, no override mechanism (`docs/reference/flow-graph.md:217`) | Allowed with explicit user override + reduced scaffolding (lines 1103, 2034) | MINOR    | **Adapt.** Add a one-line override mechanism with mandated written reason, per Spec's Risks-table entry "Over-constraint."                            |
| C24 | Conflict between source docs       | Forbidden edge: "multiple source docs → one task" — split (`docs/reference/flow-graph.md:62`) | Halt and surface the conflict explicitly, do not silently reconcile (line 1105) | MINOR    | **Adapt.** Both rules can coexist; add halt-and-surface to `documentation-gatekeeper` skill as the procedural counterpart to the forbidden edge.       |

Findings 12–17 below treat the load-bearing rows in detail. Rows that fold cleanly into adopt-only items (C20, C21, C24) are folded into other findings rather than getting their own.

---

## Scope

**In scope:**

- `.agents/research/swarm-spec.md` lines 1–2042 (full file)
- `docs/personas/`, `docs/tasks/`, `docs/skills/`, `docs/documents/`, `docs/reference/`, `docs/PRINCIPLES.md`, `docs/adrs/`
- `scaffold/` only as referenced by the docs being compared

**Out of scope:**

- Editing any of the above. Remediation routes via `spec-writing` and new ADRs only.
- Citation links inside the spec (`turnXX...`). Treated as opaque; not de-referenced for this pass.
- The spec's narrative tone, marketing-style positioning, and prose style.

---

## Doc paths inspected

- `.agents/research/swarm-spec.md` — full read, in three slices (1–500, 500–1100, 1100–1700, 1700–2042)
- `docs/PRINCIPLES.md:1–103`
- `docs/personas/README.md:1–173` (13-persona roster, persona × task matrix)
- `docs/tasks/README.md:1–174` (18-type catalogue, skill auto-attach)
- `docs/skills/README.md:1–142` (cross-cutting + authoring split, project-specific home)
- `docs/documents/README.md:1–110` (four-core + extended)
- `docs/reference/flow-graph.md:1–253` (operational tables, kickback, recursion, edge cases)
- `docs/adrs/0001-four-doc-types.md`, `docs/adrs/0006-skeptic-owns-fix-tasks.md`
- `.agents/audits/docs-structure-skeptic-pass.md` (prior dogfood audit)

---

## Findings

### Issue 1 — Information-loss budget table is missing from our distillation layer [CRITICAL — Adopt]

- **File:line:** Spec [`swarm-spec.md`](../research/swarm-spec.md) lines 1756–1764 (table: `From | To | Permitted loss | Forbidden loss`); compare [`docs/skills/distillation-discipline.md`](../../docs/skills/distillation-discipline.md) and [`docs/concepts/03-distillation.md`](../../docs/concepts/03-distillation.md).
- **Observation:** We have a `distillation-discipline` skill and a "Distillation Loss Statement" convention, but no **typed contract** for what may and may not be dropped on each edge (`research → spec`, `research → audit`, `research → bug-report`, `spec → task`, `audit → task`, `bug-report → task`). The spec's table makes the budget enforceable at review time — a Skeptic can point at a row to reject. Right now our distillation rules are stance + checklist, not a per-edge matrix.
- **Needed:** Adopt the six-row matrix as a normative table inside `docs/concepts/03-distillation.md` (and mirror to `scaffold/.agents/skills/distillation-discipline/SKILL.md`). Route as `spec-writing` against `research.md` because it changes the framework contract, not just prose.
- **Verified by:** grep for "permitted loss" / "forbidden loss" under `docs/` returns nothing; the matrix has no current home.
- **Suggested route:** `spec-writing` (Architect) → `documentation` (Documentarian) for prose mirroring.

---

### Issue 2 — Promotion protocol exists as principle but lacks a routing table [CRITICAL — Adopt]

- **File:line:** Spec lines 1796–1804 (`Discovery in task session | Promote to | Why` — seven-row table covering spec, audit, bug-report, ADR, architecture-overview, skill, research as promotion targets); compare [`docs/PRINCIPLES.md:71–76`](../../docs/PRINCIPLES.md) (Principle 8 narrative) and [`docs/adrs/0004-task-files-are-gitignored.md`](../../docs/adrs/0004-task-files-are-gitignored.md).
- **Observation:** Principle 8 says "durable findings migrate" and ADR 0004 enforces gitignore. Neither tells the agent **where** to promote each kind of discovery. The spec's table closes that gap with a deterministic seven-row routing.
- **Needed:** Add the table as a normative section inside `docs/concepts/03-distillation.md` or a new `docs/reference/promotion-protocol.md`, linked from `manage-task` and `documentation-gatekeeper` skills. The `<durable_promotions>` block proposed for `task.md` (Issue 11 below) becomes mechanically driven by this table.
- **Verified by:** `docs/skills/manage-task.md` and `docs/concepts/03-distillation.md` were inspected; neither carries the table; Principle 8 contains the rule in prose only.
- **Suggested route:** `spec-writing` paired with Issue 11 (task-shell tags).

---

### Issue 3 — Per-doc lifecycle state machines are missing; we ship one generic stateDiagram [CRITICAL — Adopt]

- **File:line:** Spec lines 1808–1817 (per-doc-type state ladders, e.g., `spec.md: draft → clarified → approved → implemented → amended/superseded`; `audit.md: requested → surveyed → reviewed → acted-on → stale/superseded`; `bug-report.md: reported → reproduced → root-caused → fix-ready → closed/superseded`; etc.); compare [`docs/documents/README.md:50–67`](../../docs/documents/README.md) (one Mermaid `stateDiagram-v2` shared across all four core types plus an "Active until / Then archived to" table).
- **Observation:** Our current lifecycle is a generic `Draft → Active → Resolved → Archived` graph plus a four-row "Active until" table. That collapses meaningful differences (e.g., a `bug-report.md` is not "Active" — it is `reproduced` or `root-caused`; a `spec.md` is not "Active" — it is `clarified` or `approved`). The collapse leaks into agent behaviour: the gatekeeper cannot say "this spec is `draft`, you cannot route a `feature` task off it yet."
- **Needed:** Replace the single stateDiagram with one per core doc type, each with the explicit transition trigger from the spec. Each state name should be machine-readable so it can become a frontmatter field (`status: clarified`).
- **Verified by:** `docs/documents/README.md` lines 50–67 contain exactly one shared diagram; no per-type variant exists in `docs/concepts/05-document-types.md` either.
- **Suggested route:** `spec-writing` (Architect) — small, constrained scope.

---

### Issue 4 — Verbosity gradient is implied but never written down [MAJOR — Adopt]

- **File:line:** Spec lines 1745–1752 (six-tier list: `research → spec/audit → bug-report → ADR/architecture-overview → task → SKILL.md`); compare [`docs/concepts/03-distillation.md`](../../docs/concepts/03-distillation.md).
- **Observation:** The framework already implicitly believes that `research.md` is high-verbosity and `task.md` is low-verbosity, but the explicit ranked list is absent. Without it, the `distillation-discipline` skill cannot answer the basic question "which way is downhill from here?"
- **Needed:** A six-row table in `docs/concepts/03-distillation.md` listing every durable artefact in verbosity order, with a one-line note per tier explaining what verbosity means at that level (source-rich, decision-bearing, scoped-around-failure-class, durable-but-not-saturating, terminal, lazy-load).
- **Verified by:** `docs/concepts/` table of contents lists distillation but the content discusses direction (downhill) without ranking the artefacts by verbosity.
- **Suggested route:** Bundle into Issue 1's `spec-writing` task — same author, same audience.

---

### Issue 5 — Worked distillation examples (`research → spec`, `spec → task`, `audit → task`, `bug-report → task`) are absent from our pedagogy [MAJOR — Adopt]

- **File:line:** Spec lines 1834–1921 (four full worked examples with "Source paragraph / Correct distillation / Dropped and why permitted"); compare [`docs/guides/`](../../docs/guides/) tree — no equivalent.
- **Observation:** Our docs assert distillation discipline. They do not show it. The spec's worked diffs are the most teachable artefact in the entire 2,042-line file because they convert an abstract rule into a copyable example. Our `docs/guides/quickstart.md` and `writing-source-docs.md` carry no equivalent before/after pair.
- **Needed:** A new `docs/guides/distillation-by-example.md` (or an "Examples" section in `docs/concepts/03-distillation.md`) reproducing the four worked diffs in framework-agnostic form (i.e., `{{cmdX}}` placeholders, no React/SDK literals).
- **Verified by:** `ls docs/guides/` shows seven guides; none teaches distillation by worked example.
- **Suggested route:** `documentation` task (Documentarian) sourced from the conceptual spec drafted in Issue 1.

---

### Issue 6 — Cross-reference rules are implicit; the spec proposes a canonical/discoverable split [MAJOR — Adopt]

- **File:line:** Spec lines 1821–1832 (`Canonical links` vs `Agent-discoverable, not mandatory`); compare [`docs/reference/flow-graph.md`](../../docs/reference/flow-graph.md), [`docs/documents/README.md`](../../docs/documents/README.md).
- **Observation:** Our docs link freely. They do not declare which links are **load-bearing** (`spec.md` MUST link upstream `research.md` and ADRs) vs **discoverable** (`architecture-overview.md` MAY mention specs; not required). Without the split, a Skeptic cannot reject "this spec lacks an upstream research link" because the obligation has never been written down.
- **Needed:** A short "Cross-reference rules" subsection in `docs/concepts/05-document-types.md` and `docs/reference/document-base.md` separating MUST and MAY edges.
- **Verified by:** `docs/reference/document-base.md` was read; it carries shared structural fields but no MUST/MAY edge list.
- **Suggested route:** `spec-writing`.

---

### Issue 7 — Effective-skills attachment is enumerated case-by-case rather than derived from a formula [MAJOR — Adapt]

- **File:line:** Spec lines 1716–1737 (`Every valid combination auto-loads: personas + manage-task + documentation-gatekeeper. Every task type then adds its task bundle. Persona is in the task header, not a per-persona skill file.`); compare [`docs/reference/flow-graph.md:103–122`](../../docs/reference/flow-graph.md) and [`docs/tasks/README.md:142–164`](../../docs/tasks/README.md), which present the attachment as a hand-edited table.
- **Observation:** Our skill auto-attach is two enumerated tables (one in `flow-graph.md`, one duplicated in `tasks/README.md`). They drift trivially (cross-checking shows minor differences in wording and ordering). The spec's formula `base + task_bundle` collapses both tables into a one-line rule plus per-task-bundle additions, which is what the launcher should compute anyway.
- **Needed:** Adopt the formula and replace both tables with a single per-task-bundle list (e.g., `feature: [write-feature, empirical-proof, architecture-violations]`). Keep persona out of the skill set entirely (consistent with [ADR 0009](../../docs/adrs/0009-personas-are-mindsets.md): personas are mindsets carried in the header).
- **Verified by:** Compare wording across `docs/reference/flow-graph.md:99–124` (skill table), `docs/tasks/README.md:141–163` (skill table). Both exist; wording diverges in ordering.
- **Suggested route:** `spec-writing` + ADR ("Skill attachment is `base + task bundle`, never enumerated") + `refactor` against the two tables.

---

### Issue 8 — Recursion rule "parent does not leak persona to children" is sharper in the spec than ours [MAJOR — Adapt]

- **File:line:** Spec lines 1109–1113 (`The parent task does not leak its persona into children. A child refactor spawned from a larger feature still becomes audit-derived → refactor → Janitor, not "feature work by Builder, but smaller."`); compare [`docs/concepts/08-recursion-and-delegation.md`](../../docs/concepts/08-recursion-and-delegation.md), [`docs/adrs/0014-recursion-renamed-delegation.md`](../../docs/adrs/0014-recursion-renamed-delegation.md), [`docs/reference/flow-graph.md:158–177`](../../docs/reference/flow-graph.md).
- **Observation:** ADR 0014 reframes recursion as delegation. Our recursion section in `flow-graph.md` shows the Lead Engineer pattern but does not state the no-leak rule explicitly — it is only implied by "each sub-task is itself a `(source doc, task type, persona)` triple." That phrasing is correct but quiet; the spec's negative formulation ("does not leak") is operationally stronger because it tells reviewers what to reject.
- **Needed:** Add a one-paragraph "No persona leak" rule to `docs/concepts/08-recursion-and-delegation.md` and reference it from the `write-orchestration` skill.
- **Verified by:** Concept page reviewed; the explicit anti-rule is missing.
- **Suggested route:** `documentation` (small) — concept page edit only, no contract change.

---

### Issue 9 — `architecture-violations` is a project skill in our docs, a core skill in the spec [MAJOR — Adapt]

- **File:line:** Spec lines 1196 (catalogue: `architecture-violations | Guard module boundaries, ownership, and contract discipline`) and 1729–1732 (auto-attached to `Architect × spec-writing`, `Auditor × audit-writing`, `Builder × feature`, `Janitor × refactor`, `Migrator × migration`); compare [`docs/skills/README.md:97–104`](../../docs/skills/README.md) — `architecture-violations` is listed as a "Project skill" in the example overlay table, not a shipped framework skill, and **does not exist** under `docs/skills/`.
- **Observation:** The spec promotes `architecture-violations` to a core auto-loaded skill alongside `empirical-proof`. Our framework currently provides no canonical implementation; consumers are expected to author it themselves. That is a real coverage gap: every implementation task type ought to have boundary discipline at the framework level, not at project discretion.
- **Needed:** Either (a) ship a canonical `architecture-violations` skill under `docs/skills/architecture-violations.md` + `scaffold/.agents/skills/architecture-violations/SKILL.md` and add it to the auto-attach table, or (b) ADR explicitly committing it to project-overlay scope only and explaining why.
- **Verified by:** `ls docs/skills/` returns no `architecture-violations.md`; `docs/skills/README.md:97–99` lists it as project-specific.
- **Suggested route:** `spec-writing` to settle the policy, then either `documentation` (publish skill) or ADR (defend project-only stance).

---

### Issue 10 — Verification placeholder vocabulary is leaner here than in the spec; a CRITICAL open question is unresolved [MAJOR — Adapt]

- **File:line:** Spec lines 1082–1097 (per-task-type table with `{{cmdInstall}}, {{cmdValidateDeps}}, {{cmdTypecheck}}, {{cmdLint}}, {{cmdTest}}, {{cmdBuild}}, {{cmdSmoke}}, {{cmdRepro}}, {{cmdBenchmark}}, {{cmdDocsLint}}` across pre-implementation / periodic / post-implementation / self-review phases) and 2023 (CRITICAL open question: "standardize a closed verification placeholder set in v1, or allow arbitrary repo-defined placeholders?"); compare [`docs/reference/flow-graph.md:128–153`](../../docs/reference/flow-graph.md) (`cmdInstall, cmdValidate, cmdValidateDeps, cmdTypecheck, cmdTest, cmdBuild, cmdBenchmark` only) and [`docs/reference/template-placeholders.md`](../../docs/reference/template-placeholders.md).
- **Observation:** Two divergences: (1) the spec carries `cmdRepro`, `cmdSmoke`, `cmdLint`, `cmdDocsLint` that we do not; (2) the spec splits into four lifecycle phases (pre / periodic / post / self-review), while our table uses three. The spec's CRITICAL open question is also ours: do we lock the placeholder set or allow arbitrary additions?
- **Needed:** A `spec.md` for "Verification placeholder vocabulary v1" listing the closed set, the lifecycle phases, and the override mechanism (project-defined extensions allowed via `swarm.config`, but with a contract).
- **Verified by:** `docs/reference/template-placeholders.md` was inspected (file exists; defines `cmdInstall`, `cmdValidate*`, `cmdTypecheck`, `cmdTest`, `cmdBuild`, `cmdBenchmark`, plus `slug` family). `cmdRepro`, `cmdSmoke`, `cmdLint`, `cmdDocsLint` are absent.
- **Suggested route:** `spec-writing` (Architect) + ADR ("Verification placeholder vocabulary is closed at v1; project extensions live in `swarm.config`").

---

### Issue 11 — `task.md` shell uses our prose-with-Markdown structure; the spec proposes an XML-tag vocabulary [MINOR — Adopt]

- **File:line:** Spec lines 642–733 (canonical `task.md` skeleton with `<acceptance_criteria>`, `<plan>`, `<module_plan>`, `<verification_plan>`, `<before_state>`, `<after_state>`, `<shim_contracts>`, `<durable_promotions>`, `<self_review>` tags) and 738–997 (per-type inserts); compare [`docs/reference/task-base.md`](../../docs/reference/task-base.md) and [`docs/tasks/README.md:54–71`](../../docs/tasks/README.md).
- **Observation:** Our task base lists section names in prose: `Metadata, Objective, Linked docs, Required skills, Constraints, Plan, Progress checklist, Decisions / Findings / Assumptions / Blockers, Validation gates, Self-review, Next steps`. The spec's named-tag vocabulary is parsable, lintable, and round-trips cleanly to other tools (Anthropic-style prompt blocks, structured outputs). It also makes `<durable_promotions>` first-class — the missing handle that Issue 2's promotion table needs.
- **Needed:** Define a closed tag vocabulary at the framework level. Either (a) replace section headers with XML tags, or (b) keep headers and add tags as machine-readable anchors. Either way, `<durable_promotions>` is the new explicit hook for the promotion protocol.
- **Verified by:** `docs/reference/task-base.md` was read; it uses Markdown headers throughout and has no tag vocabulary.
- **Suggested route:** `spec-writing` (Architect) — bundle with Issue 2 since they share the `<durable_promotions>` block.

---

### Issue 12 — The Surveyor persona: spec rejects, we keep, no ADR yet defends our choice [MAJOR — Defend or remove]

- **File:line:** Spec lines 62 (`The Surveyor | Rejected | Too far outside a coding-agent documentation core. Swarm should keep one research.md with research_mode, not a whole product-research persona family.`); compare [`docs/personas/README.md:27`](../../docs/personas/README.md) (Surveyor in the 13-roster), [`docs/personas/the-surveyor.md`](../../docs/personas/the-surveyor.md), [`docs/reference/flow-graph.md:81`](../../docs/reference/flow-graph.md) (`research-writing (UX/market) → The Surveyor`).
- **Observation:** The Surveyor splits `research-writing` along source-evidence-type (technical citations vs UX/market evidence). The spec's counter-proposal is one `research.md` with a `research_mode: technical | product | operational` field and one Researcher persona. Either side is defensible; **we have no ADR explaining the split**. Without a defence, the next reader will perceive the Surveyor as persona inflation (a violation of Principle 10, "the catalogue grows slowly and with evidence").
- **Needed:** Either (a) write an ADR ("Research is split by evidence type, not by mode field, because UX/market discipline differs operationally from citation-heavy technical research"), or (b) collapse Surveyor into Researcher with `research_mode` and ship a migration note.
- **Verified by:** `ls docs/adrs/` shows ADRs 0001–0015 with no Surveyor-specific entry; `docs/personas/the-surveyor.md` exists but does not justify the split against the simpler alternative.
- **Suggested route:** `spec-writing` (decide) → ADR (commit).
- **Recommendation:** **Adapt to spec.** Collapse Surveyor into Researcher with `research_mode: technical | product | operational`. Reasoning: (a) Principle 10 places the burden of proof on the catalogue; we have not paid it. (b) The Surveyor's distinguishing discipline (UX/market evidence quality, observed-vs-claimed) is a *check* the Researcher can also perform when `research_mode != technical`; the persona is not load-bearing on top of the field. (c) C6 in the matrix above resolves alongside this. Migration: deprecate `docs/personas/the-surveyor.md` (keep as supersession-only stub with a pointer), add `research_mode` to the `research.md` template, fold `research-writing (UX/market)` into `research-writing` in `docs/reference/flow-graph.md:42–43, 80–81`. Project-overlay path stays open (a consumer that genuinely runs heavy product research can re-introduce Surveyor as an overlay). If we keep Surveyor instead, ADR must explicitly engage with the spec's `research_mode` alternative on the merits, not by silence.

---

### Issue 13 — `rewrite`, `upgrade`, `integration` task types: spec rejects all three [MAJOR — Defend or fold]

- **File:line:** Spec lines 633–636 (`rewrite | Rejected | behavior change belongs in spec.md, not in a fuzzy execution type`; `upgrade | Rejected | upgrades are a migration subtype`; `integration | Rejected | third-party wiring is a feature subtype unless mechanically replacing existing integrations, in which case migration`); compare [`docs/tasks/README.md:21–32`](../../docs/tasks/README.md) (`rewrite`, `upgrade`, `integration` ship as standalone task types) and [`docs/reference/flow-graph.md:78, 85, 92`](../../docs/reference/flow-graph.md).
- **Observation:** We currently ship 18 task types; the spec argues for 14. Three of our types collapse into existing ones in the spec's model. The previous skeptic-pass audit (Issue 4 in `.agents/audits/docs-structure-skeptic-pass.md`) already noted the `upgrade ↔ migration ↔ write-refactor` overload as a category-error risk. The spec's stricter taxonomy resolves it cleanly. Per Principle 10 (catalogue grows slowly with evidence), the burden of proof is on keeping the extras.
- **Needed:** ADR for each retained type explaining why it survives collapse; or `spec-writing` to fold `rewrite → feature with explicit behaviour delta`, `upgrade → migration`, `integration → feature` and ship a migration table. The earlier skeptic-pass audit Issue 4 should be referenced as supporting evidence.
- **Verified by:** Cross-check of `docs/tasks/README.md`, `docs/reference/flow-graph.md`, and the previous audit. The three types appear in our routing tables; the spec routing table omits them by design.
- **Suggested route:** `spec-writing` (Architect) + 1–3 ADRs depending on outcome. Highest-impact change in this audit; touches every task-type doc, scaffold template, and routing table.
- **Recommendation:** **Adapt to spec, with one carve-out.** Fold all three:
  - `rewrite → feature` with a mandatory `<behavior_delta>` block in the task header. Reasoning: the spec is right that "rewrite" is a fuzzy execution category — the discipline difference between feature and rewrite is exactly the explicit-delta block, and that belongs in the source `spec.md`, not in a separate task type. Deprecate `write-rewrite` (C16) alongside.
  - `upgrade → migration` unconditionally. The prior skeptic-pass audit Issue 4 already documents the category-error risk; collapse is overdue.
  - `integration → feature` for greenfield wiring; route to `migration` when the integration mechanically replaces an existing integration. This is the spec's exact rule (line 636) and removes a real source of misrouting.
  - **Carve-out:** Keep the `kickback` and `deepen-audit` semantics live (see Issue 18) — those are routing patterns, not task types, and they should not be collapsed to "follow the spec by reflex." The spec is silent on `deepen-audit`, which is not the same as rejecting it.

  Rollout: One `spec-writing` task per collapse (three total) producing three ADRs that explicitly cite spec lines 633–636 and the prior skeptic-pass audit. Follow with one `migration` task that sweeps `docs/tasks/`, `docs/reference/flow-graph.md`, `docs/reference/compatibility-matrix.md`, scaffold templates, and the per-task README headers. Touch surface is large (~10 files); land before any of the additive adoption issues to keep the taxonomy stable while structure work is in flight.

---

### Issue 14 — Skeptic owns `fix`: spec disagrees; defended by ADR 0006 [MAJOR — Defend, do not adopt]

- **File:line:** Spec lines 31–32, 619 (`fix | Builder | Bug Hunter, Test Author, Skeptic`); compare [`docs/adrs/0006-skeptic-owns-fix-tasks.md`](../../docs/adrs/0006-skeptic-owns-fix-tasks.md) and [`docs/reference/flow-graph.md:76`](../../docs/reference/flow-graph.md) (`fix → The Skeptic`).
- **Observation:** ADR 0006 explicitly chose Skeptic-on-fix over Builder-on-fix because "fixes fail when engineers accept the first plausible narrative." The spec's recommendation reverts to the conventional Builder-on-fix. We have a written defence; the spec does not engage with it.
- **Needed:** Append a "Considered and rejected: Builder on fix (per `swarm-spec.md`)" entry to ADR 0006's Consequences/References, so a future reader sees the disagreement is adjudicated, not unread.
- **Verified by:** ADR 0006 is `Accepted`; spec text on line 619 conflicts; both can be true if we cite the disagreement.
- **Suggested route:** `documentation` task (Documentarian) — single-paragraph addition to ADR 0006.
- **Recommendation:** **Defend, do not adopt.** ADR 0006 wins. Append two artefacts: (1) a "Considered and rejected" subsection on ADR 0006 explicitly citing spec lines 31, 619 and rebutting on the merits ("the spec's roster optimises for the median bug, where Builder discipline suffices; ADR 0006 optimises for the long tail of fixes that fail because the first plausible narrative was accepted — the persona switch is the cheapest available counterweight"); (2) a row in `docs/personas/README.md`'s persona × task matrix and `docs/reference/flow-graph.md`'s persona table flagged with a footnote "this row diverges from `swarm-spec.md` line 619; see ADR 0006." Reasoning: silently disagreeing produces persistent re-litigation; explicit disagreement is cheap insurance.

---

### Issue 15 — ADR / extended docs: spec models them as sidecars; we shipped an extended-doc catalogue [MAJOR — Adapt cautiously]

- **File:line:** Spec lines 206–210 (ADR is a durable doc, sidecar role; `architecture-overview.md` is a sidecar reference doc; spec lines 215–220 explicitly reject `migration-plan.md`, `postmortem.md`, `rfc.md`, `glossary.md` as separate types; `change_class: migration` field absorbs migration-plan); compare [`docs/documents/extended.md`](../../docs/documents/extended.md) and [`docs/documents/README.md:24–39`](../../docs/documents/README.md) (extended catalogue: ADR, constitution.md, migration plan, benchmark report, cleanup list, test plan, audit brief, research question, review scope).
- **Observation:** Two related divergences. (1) The spec models ADR as a **sidecar** (durable but not on the main distillation trunk), while we treat it as an extended doc orbiting `spec`. (2) The spec collapses `migration-plan.md`, `constitution.md`, `audit brief`, `research question`, `review scope` into existing core types via fields (e.g., `change_class: migration` on a spec). The previous skeptic-pass audit Issue 2 already flagged `extended.md` template sprawl as a real maintenance hazard. The spec's purer model would close the sprawl.
- **Needed:** A `spec-writing` decision against ADR 0001 ("four core + extended"). Three viable shapes: keep status quo with a tighter `extended.md` (per the prior skeptic-pass audit); adopt the spec's pure four-core + sidecar model; or hybrid (keep ADR + architecture-overview as sidecars; collapse the rest into core types via fields).
- **Verified by:** `docs/documents/extended.md` exists with multi-hundred-line embedded templates (per `.agents/audits/docs-structure-skeptic-pass.md` Issue 2); ADR 0001 enumerates four core but does not name ADR/architecture-overview as sidecars vs extended.
- **Suggested route:** `spec-writing` + ADR superseding parts of ADR 0001. Touch surface is large (every doc in `docs/documents/`); should not happen before Issue 13 settles, since both reshape the taxonomy.
- **Recommendation:** **Hybrid.** Adopt the spec's sidecar role for ADR and `architecture-overview.md`; collapse `migration plan`, `audit brief`, `research question`, `review scope` into core types with mode/class fields; keep `constitution.md`, `cleanup list`, `benchmark report`, `test plan` only if a project genuinely uses them and document them as project-overlay templates rather than framework-shipped types. Sequencing: (1) ADR superseding the relevant clauses of ADR 0001 with the new four-core + two-sidecar model; (2) `spec-writing` for "Field discriminators on core docs" (`change_class`, `audit_pass`, `research_mode`, `review_scope`); (3) `migration` task to strip the embedded templates from `docs/documents/extended.md` (closes the prior skeptic-pass audit's Issue 2). Do not start before Issue 13 lands; doing both in flight risks tangling the taxonomy revision.

---

### Issue 16 — Spec's CRITICAL open questions surface gaps in our framework that are also unresolved here [MAJOR — Adopt as new specs]

- **File:line:** Spec lines 2023–2025 (three CRITICAL open questions for the spec author).

The three CRITICAL items, mapped to our state:

1. **Closed verification placeholder set in v1?** — Same gap, see Issue 10 above.
2. **Can a task promote durable findings into versioned docs in the same branch, or must promotion be a follow-up doc-only review step?** — Our docs do not address this. `docs/PRINCIPLES.md:71–76` and ADR 0004 say findings migrate, but not whether the promotion commit lives on the worker branch or on a separate PR. Highly relevant for enterprise / regulated environments.
3. **For monorepos, is `architecture-overview.md` one repo-wide file, or one file per bounded context plus an index?** — Our `docs/guides/monorepo-setup.md` exists; needs cross-checking against this question.

- **Needed:** Three small `spec-writing` tasks, one per question, each producing an ADR. These are short but block Issues 9, 10, 15 from completing cleanly.
- **Verified by:** `docs/guides/monorepo-setup.md` exists; spec's question 3 may be partially answered there. The other two are unanswered.
- **Suggested route:** Three `spec-writing` tasks (Architect), parallelisable.

---

### Issue 18 — `kickback` and `deepen-audit` as standalone task types vs routing patterns [MAJOR — Adapt with carve-out]

- **File:line:** Spec lines 1115–1122 (kickback is a routing loop, not a task type: "Swarm should not keep a separate `feature-revision` task type. A revision is either a fix against the standing spec or a new/amended spec followed by feature work."); spec lines 612–628 do **not** list `deepen-audit` at all. Compare [`docs/tasks/README.md:32, 48`](../../docs/tasks/README.md), [`docs/tasks/kickback.md`](../../docs/tasks/kickback.md), [`docs/tasks/deepen-audit.md`](../../docs/tasks/deepen-audit.md), [`docs/reference/flow-graph.md:90, 93`](../../docs/reference/flow-graph.md).
- **Observation:** The two types behave differently and the spec treats them differently:
  - **`kickback`** is a routing pattern in the spec (the Skeptic-rejection loop), not a separate task type. Our framework currently models the same loop with a dedicated row in the task table whose primary persona is "(original persona)" and whose source doc is "original source + Skeptic notes." That is a routing pattern wearing the costume of a task type. The spec's collapse is correct: kickback is a `fix` (when the spec stands) or a `spec-writing → feature` loop (when the spec is wrong). A standalone task type is not pulling its weight.
  - **`deepen-audit`** is silent in the spec — neither rejected nor adopted. Our framework uses it for a Skeptic re-walk of an existing audit. There are two readings: (a) it is a second pass of `audit-writing` and should be folded with a mode field, or (b) the persona switch (Auditor → Skeptic) is the load-bearing distinction and deserves a separate row.
- **Needed:** Two decisions:
  - **`kickback`:** Reclassify as a routing pattern in `docs/reference/flow-graph.md` (the Kickback section already exists, lines 180–204). Remove the row from the task table. Keep the conceptual page if it teaches the loop, but rename to clarify it is not a routable task.
  - **`deepen-audit`:** ADR ("Audit second-pass with Skeptic primary remains a distinct task type because the persona-switch ought to be made auto-routable, not hidden behind a mode field"), or fold into `audit-writing` with `audit_pass: deepen` and let the persona override mechanism (`swarm.config`) carry the Skeptic-on-deepen-audit choice.
- **Verified by:** `docs/tasks/kickback.md` was inspected via `ls`; the task type appears in `docs/tasks/README.md:32` and `docs/reference/flow-graph.md:93`. `deepen-audit` similarly listed at line 48 and 90.
- **Suggested route:** Two `spec-writing` tasks (one per decision); both bundle into Issue 13's task-taxonomy revision because they share the same routing-table edits.
- **Recommendation:** **Adapt to spec on `kickback`; defend with ADR on `deepen-audit`.** Reasoning: the spec is right that `kickback` is a loop — its "task type" row is the only one whose primary persona is "(original persona)" rather than a named persona, which is itself a smell. Folding it removes a special case. `deepen-audit`'s Skeptic-as-primary is genuinely load-bearing (audit re-walks need adversarial bias by default; a project should not have to override `swarm.config` to get the right persona on the most common second-pass scenario), so it should survive — but with an explicit ADR engaging with the spec's silence ("the spec did not consider deepen-audit; we keep it because the persona switch should be auto-routable").

---

### Issue 19 — Missing authoring skills: `write-migration`, `write-performance`, `write-test`, `write-documentation`, `write-orchestration` [MAJOR — Adapt cluster]

- **File:line:** Spec lines 1208–1212 (each named as a separate skill with `---` frontmatter and full Core rules / Anti-patterns body in the spec text, lines 1530–1658); compare [`docs/skills/README.md:38–46`](../../docs/skills/README.md) (authoring skills shipped: `write-spec`, `write-audit`, `write-research`, `write-bug-report`, `write-feature`, `write-fix`, `write-refactor`, `write-rewrite`) and [`docs/reference/flow-graph.md:103–124`](../../docs/reference/flow-graph.md) (auto-attach table for `migration`, `performance`, `testing`, `documentation`, `orchestration`).
- **Observation:** Five task types currently auto-attach `empirical-proof` (and sometimes `distillation-discipline` or `adversarial-review`) but no specialised authoring-discipline skill. The spec ships all five as first-class skills with concrete Core rules. This is the largest single skill-catalogue gap. Specifically:
  - `migration`: we use `write-refactor` "(overlap)" — `docs/reference/flow-graph.md:113`. The prior skeptic-pass audit Issue 4 already flagged the overload as a category-error risk. The spec's `write-migration` (lines 1532–1554) carries phased-change discipline (`Maintain inventory`, `Phased compatibility over big-bang`, `Capture rollback conditions`, `Verify each stage`) that `write-refactor` does not.
  - `performance`: only `empirical-proof`. The benchmark-first stance (`Benchmark before changing code`, `Name the bottleneck`) is not generic empirical proof.
  - `testing`: only `empirical-proof`. The risk-targeted minimum-surface stance is not generic.
  - `documentation`: `distillation-discipline + empirical-proof`. The reader-task orientation is missing.
  - `orchestration`: `adversarial-review + empirical-proof`. Decomposition discipline is missing.
- **Needed:** Five new skill files under `docs/skills/` and `scaffold/.agents/skills/`, plus auto-attach updates in the per-task-bundle list (Issue 7 / C18). Each skill is small (~30 lines per the spec's bodies); the catalogue work is mostly mechanical.
- **Verified by:** `ls docs/skills/` returns 14 files; the five proposed skills are absent. `docs/reference/flow-graph.md:103–124` confirms the auto-attach gap.
- **Suggested route:** One `spec-writing` task ("Authoring skills v2: complete the per-task-type set") producing all five SKILL.md files in `scaffold/.agents/skills/` and matching reference pages in `docs/skills/`. Followed by a `documentation` task to update the auto-attach table.
- **Recommendation:** **Adapt all five.** Specifically:
  - **`write-migration`:** Ship now. Highest priority of the five because it closes the prior skeptic-pass audit's Issue 4. Decouple `migration` task from `write-refactor` in the auto-attach table.
  - **`write-performance`:** Ship now. The benchmark-first discipline does not naturally encode in `empirical-proof` and consumer projects keep re-deriving it.
  - **`write-test`:** Ship now. Pair with `testing-file-layout` (C17) — both are needed to make the `testing` task type reliable.
  - **`write-documentation`:** Ship after Issue 17 ("Considered and rejected" convention) lands so the discipline page reflects the convention.
  - **`write-orchestration`:** Ship after Issue 8 (no-persona-leak rule) lands so the discipline page can cite it.
  Keep skill bodies close to the spec's Core rules / Anti-patterns shape (lines 1530–1658) but rephrase to match the framework's voice convention from Principle 9 (direct, opinionated, unhedged). Do **not** copy the spec's prose verbatim; the spec is `research`, not `spec`, and verbatim copying would re-import unchecked recommendations into durable docs.

---

### Issue 20 — "Considered and rejected" pattern in framework artefacts is uneven [MINOR — Adopt as a convention]

- **File:line:** Spec uses "Considered and rejected" sub-tables consistently (lines 60–67 personas; 213–221 doc types; 631–637 task types; etc.); compare our docs — only some pages use it. ADRs do (good). `docs/personas/README.md` does not enumerate rejected personas. `docs/tasks/README.md` does not list rejected types. `docs/documents/README.md` does not list rejected types.
- **Observation:** The convention is cheap and high-value: it stops the next reader from re-proposing an already-rejected option. The previous skeptic-pass audit's Issue 1 (generic clusters table copied across task pages) is downstream of this — pages have copy-paste rationale instead of trade-off rationale.
- **Needed:** Add "Considered and rejected" sections to `docs/personas/README.md`, `docs/tasks/README.md`, `docs/documents/README.md`, sourced from the relevant ADRs and from this audit's findings. Small, mechanical.
- **Verified by:** Read of all three READMEs; none has a rejected-options block.
- **Suggested route:** `documentation` task (Documentarian).

---

## Risks

| Risk                                                                       | If it fires                                                                                                                                                                                  |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Adopting the spec wholesale without dogfooding it                          | We import 2,042 lines of unverified design as durable truth; canonicality drift exactly like Spec Kit's complaint trail                                                                       |
| Adopting Issue 13 (collapse rewrite/upgrade/integration) without migration plan | Every existing task-type doc, scaffold template, and consumer onboarding page breaks at once                                                                                                |
| Defending Issue 14 (Skeptic owns fix) only in chat / PR comments           | ADR 0006 stays correct but the next reader wastes time re-litigating because the spec's contradiction is unanswered                                                                           |
| Issue 1 + Issue 2 + Issue 11 land separately                               | The information-loss budget, promotion protocol, and `<durable_promotions>` task tag are mutually-reinforcing; landing them piecewise produces inconsistent partial coverage                  |
| Issue 9 (`architecture-violations` to core) without Issue 10 (verification vocabulary v1) | Auto-attaching a skill that depends on placeholders we have not yet closed = silent breakage of consumer projects                                                                            |
| Treating this audit as a checklist rather than as ranked findings          | Findings are routes, not work tickets; each one needs `spec-writing` (or ADR) before any docs PR — skipping that hop puts us back into the prose-folklore failure mode the framework opposes |

---

## Suggested approaches

Recommended order of adoption (each step gates the next where noted):

1. **Adjudicate the contradictions first.** Issues 12 (Surveyor), 13 (rewrite/upgrade/integration), 14 (Skeptic-on-fix), 15 (extended docs vs sidecars), 18 (kickback / deepen-audit), and the contradictions matrix rows C1–C24 should be settled before any additive work, because they reshape the taxonomy that all later issues sit on top of. Issues 12 and 14 close by ADR alone; the rest need `spec-writing`.
2. **Bundle Issues 1, 2, 4, 11** into one `spec-writing` task ("Distillation contract v2"). Mutually reinforcing: verbosity gradient → loss budget → promotion protocol → `<durable_promotions>` tag. Depends on Issue 16 question 2 (in-branch promotion vs follow-up) being decided first.
3. **Bundle Issues 9, 10, 19** into one `spec-writing` task ("Skill catalogue v2: complete the per-task-type set + verification vocabulary v1"). Promotes `architecture-violations` to core, defines the closed `cmdX` set, and ships the five missing authoring skills (`write-migration`, `write-performance`, `write-test`, `write-documentation`, `write-orchestration`). Decouples `migration` from the overloaded `write-refactor`. Highest-leverage cluster.
4. **Issue 13** is the highest-impact and highest-risk single change (taxonomy collapse). Its own `spec-writing` task plus a multi-ADR fan-out. Lands before Issues 15 and 19, which both touch routing tables.
5. **Issue 15** must follow Issue 13. Reshaping the document taxonomy while the task taxonomy is in flight multiplies churn.
6. **Issues 5, 8, 20** are Documentarian-scope and can land in parallel with the harder structural work; they reduce the next reviewer's confusion without changing contracts.

Sequencing summary: **contradictions → distillation → skills → taxonomy collapse → doc-type reshape → pedagogy.** This order is deliberately the inverse of the risk-of-churn order; each later step lands on a stable substrate.

---

## Open questions

- [CRITICAL] Should the spec itself be re-routed through `spec-writing` before any of these adoptions land, so that contradictions with our ADRs are explicit in `spec.md` rather than implicit in `research.md`? (My recommendation: yes — current research-style file is not the right authority shape for framework changes.)
- [CRITICAL] Issue 16 question 2 (in-branch promotion vs follow-up) blocks Issue 11 from being fully prescriptive. Decide first.
- [MINOR] Does the spec's `research_mode` field (Issue 12) generalise to `audit_mode` and `bug_report_mode` for symmetry, or does that re-introduce the persona-mode coupling we are trying to remove?
- [MINOR] If Issue 13 collapses `integration → feature`, do existing project-overlay personas like `The Integrator` (`docs/personas/README.md:124`) still have a clean home, or do they become orphans?
- [MINOR] Is the spec's recommendation that personas live only in the task header (Issue 7) compatible with our per-persona pages under `docs/personas/`, or do those become reference-only after the formula lands?

---

## Distillation Loss Statement

**Dropped from the review session:**

- Line-by-line diff between the spec's persona constraint table (lines 43–56) and our individual persona pages under `docs/personas/the-*.md`. The 13 persona files were not opened individually; only `docs/personas/README.md` and the prior skeptic-pass audit were used.
- The spec's Mermaid diagrams (lines 1128–1185, 1939–1958) were read but not compared against `docs/concepts/07-flow-graph.md` or `docs/personas/README.md`'s embedded Mermaid for routing-edge equivalence.
- The spec's enterprise-positioning prose (lines 5, 1925–1960, 2012–2019) was read for structural cues only; no audit on whether our `docs/guides/adopting-swarm.md` or root `README.md` carries equivalent claims.
- Spec citations (`turnXX...`) were not de-referenced; this audit treats the spec as opaque secondary research, not as primary evidence about external tools.

**Why downstream doesn't need it:**

- Each finding cites the specific spec lines and the specific present-doc path, so a follow-up `spec-writing` or `documentation` task can grep-expand the source paragraphs without re-reading the whole spec.
- The skeptic-pass audit (`.agents/audits/docs-structure-skeptic-pass.md`) already covers the mechanical duplication / extended-template issues; this audit deliberately layers on top of it instead of duplicating its scope.
- The spec's tone, marketing prose, and citation provenance are not framework concerns; they would only matter if we were importing the spec verbatim, which Issue 0 (the framing of this audit) explicitly rejects.
