# CANONICAL REMEDIATION PLAN — Swarm repositioning
**Repo:** `/Users/josecosta/dev/swarm` · **Workflow:** single-session commits directly on `main` (producer convention) · **Next free ADR:** 0057 (ledger ends at `docs/adrs/0056-adversarial-self-review-completion-discipline.md`) · **ADR partitioning:** the tension register's consolidated 11-ADR map (0057–0067).

**Merge provenance:** newcomer-facing content (README structure, template texts, labeling convention, kit tree) from Draft A; consistency machinery (propagation matrix, derivation order, reconciliation gate, one-data-model contract, ADR forward-pointer wiring) from Draft B; increment ordering, staged-deletion strategy, and per-increment verification gates from Draft C. All inter-draft disagreements resolved explicitly in §0.

---

## 0. Disagreement resolutions (the calls, stated once)

| # | Disagreement | Call | Why |
|---|---|---|---|
| D1 | `docs/adrs/` → `docs/decisions/` rename (A: keep; B, C: rename) | **KEEP `docs/adrs/`** | Under the new IA newcomers never see the dir name — they see the nav label "Design decisions" in README/01. The rename buys cosmetic alignment with R2 §13.1 at the cost of a repo-wide link sweep during the highest-link-risk migration, plus two colliding `decisions/` concepts (framework ledger vs `starter-kit/decisions/` adopter seed). C itself called it "pure link churn" and licensed keep as fallback. Deviation from R2 §13.1 recorded in ADR-0057. |
| D2 | ADR batching (B/C: all 11 up front; tension-register note implies waves) | **All 11 in Increment 1** (may split into two commits: 0057–0061, 0062–0067) | The waves order the *doc edits*; the *decisions* already exist in full. Recording them first means every later edit cites its governing ADR and no doc is rewritten twice. |
| D3 | Core agent guides (A/B: 3 — write-spec, implement-task, review-output; C: 2) | **3 guides core** | Tension register T10 is explicit: spec authoring must not require a skill+card+manual stack, so `write-spec` (absorbing persona-architect + distillation-discipline) is core. |
| D4 | `docs/reference/golden-corpus.md` deletion timing (A/B: with the docs sweep; C: hold to conformance increment) | **Hold until Increment 8** | Its absorption into `conformance/README.md` must be the same commit as the corpus re-cut (schema+fixtures+docs atomicity, the 0054 lesson). |
| D5 | Old-page deletion strategy (B: create+delete same batch; C: create with "superseded by" banners, delete in one later sub-commit) | **C's staged strategy** | Link-coherence at every commit is B's own governing rule, served better by staging; temporary duplication inside the window is tracked in the matrix. |
| D6 | `docs/language/versioning.md` (A: delete, rationale in ADRs; B: collapse to note) | **Collapse to a short note inside `reference/structured-requirements.md`** ("framework versioned by release tags; spec files carry no language version; `format: sol` is the future parser hook"), then delete the file | Preserves the load-bearing conclusion without keeping a page whose premise (a versioned language) is parked. |
| D7 | Root `AGENTS.md` (A/B: full rewrite first; C: transition banner first, end-state later) | **C's two-phase** — banner + invariant suspension at Increment 0, end-state rewrite at Increment 6 | The dead counts-reconcile invariant must die on day one (IA risk #3), but the end-state pointers can't reference an IA that doesn't exist yet. |
| D8 | `docs/PRINCIPLES.md` (A/B: move+rewrite once; C: rewrite in place early, move later) | **C's two-step** — identity rewrite at Increment 2, physical move to `docs/reference/principles.md` at Increment 3d | Front-loads the P0 identity fix without opening the link-move surface early. |
| D9 | Forward-pointer list (B: 27 ADRs; C: 24 incl. 0034) | **Union: 28 ADRs** — 0002, 0004, 0009, 0015, 0019, 0023, 0026, 0027, 0028, 0029, 0030, 0032, 0033, 0034, 0036, 0041, 0042, 0043, 0046 (reinforced note), 0047, 0049, 0050, 0051, 0052, 0053, 0054, 0055, 0056 | Completeness; 0034 is genuinely refined by 0063 (lint-namespace reframing). |
| D10 | Kit size criterion (A: ≤22; C: ≤~18) | **Copy surface (`templates/` + `agent/`) = 10 files (symlinks excluded); whole kit excluding `advanced/` ≤ 22 files** | A's count matches the 3-guide core from D3. |

All other open calls (SKILL.md carrier, `format: sol`, trace fold, `conformance/` path) had identical defaults across drafts — adopted; restated in §8.

---

## 1. Direction (short)

**Identity:** *Swarm is a lightweight spec and review workflow for teams using coding agents.* It turns tickets into clear specs, specs into bounded agent-ready tasks, and agent output into evidence a human can review by exception — plain markdown, any agent, no runtime. The spec is the source of **intended behavior**; code is **implementation reality**; review and status connect them.

**The six-step loop (the only workflow a newcomer learns):**

```
Pull ──▶ Spec ──▶ Task ──▶ Run ──▶ Review ──▶ Close
 │        │        │        │        │          │
intake   spec     task    branch   review     finding
snapshot                  + code   packet     + status
```

The nine-step lifecycle (`author→lint→improve→lower→decompose→implement→verify→review→promote`) survives as one advanced reference page with a mapping table (Pull↔intake-capture — *not* author-source, the T18 fix; Spec↔author/lint/improve; Task↔lower/decompose; Run↔implement/verify; Review↔review; Close↔promote/status).

**Core artifacts (6):** intake (recommended when work originates in an external tracker), spec, task, review (the wedge), finding, status. Trace is absorbed (PR + review packet's evidence column). Advanced tier: audit, bug, adr, research, prd, rfc, inventory.

**Is:** a spec format agents can work from · a task-packet format that bounds agent work · a review-packet format that shows where human attention goes · a findings convention so lessons survive the session · a starter kit of markdown templates · a workspace convention keeping all of it out of code repos.
**Is not:** an agent or agent runtime · a compiler or programming language · a Jira/Linear replacement · a code generator · a replacement for PRs and CI · a formal verification system.

**Surviving constraints:** markdown-only/NO RUNTIME in this repo; provider/agent neutrality; external workspace + pristine code repos; structured requirements with stable IDs + verification notes; review by exception; findings/memory; honest soft-control framing. SOL, the checks catalogue, the 7-value result model, the IR schemas, and the nine-step lifecycle are **demoted, never forked or deleted** — one click deeper under `docs/reference/`, with `swarm-cli` (`/Users/josecosta/dev/swarm-cli`) named as the reference implementation of the checks.

---

## 2. Decision register (ADRs 0057–0067, all under `docs/adrs/`)

Every ADR carries a **Propagation section**: a closed checklist over the 13 derived surfaces in §3.0; the ADR is not closeable until every row is checked (commit SHA per row). Supersession edits to old ADRs are forward-pointer status-line additions only — neutral wording, never body rewrites.

| # | ADR | Decision | Supersedes / refines | Answers |
|---|---|---|---|---|
| 1 | **0057 — Practical-first repositioning and the six-step loop** | Public framing = the §1 one-liner; six-step loop primary; nine-step → one advanced page with the mapping table (Pull↔intake-capture fix); "spec = intended behavior, code = implementation reality, review/status connect them" replaces "source of truth" everywhere; new docs IA (`01–09` + `reference/` + `examples/`; `docs/adrs/` kept, labeled "Design decisions" — deviation from R2 §13.1 recorded here, per D1); **full rename scope** incl. skill dirs and `type:` frontmatter (no `pass-*` seam — T7); every page carries one of three works-today/future/advanced labels; risk-scaling rule ("full lifecycle for high-risk changes; six steps default" — R1 R-003); Context section records the T17 reading (O-002 praise + O-012 demotion + O-003 tooling are reconcilable) so SOL retention isn't relitigated | refines 0053, 0054, 0029; supersedes naming clauses of 0049 §2 and ADOPTING's `pass-*` upgrade story | R2 P0-product-identity, P0-spec-source-of-truth, P0-nine-step, P0-compiler-metaphor residue; R1 O-012; T7, T16, T17, T18 |
| 2 | **0058 — Two-tier spec format, one data model** | Default spec = plain structured markdown (frontmatter `type: spec` + `id/title/status/sources`; `### AC-NNN` sections; `Verify with:` notes; Intent/Non-goals/Open questions/Affected areas/Dropped from sources); SOL = optional advanced surface via `format: sol`; **one form-agnostic requirement record** (§5.0) both surfaces encode — checks, review coverage, and the structured form key on it; drop `swarm_language: SOL/0.1`, `aps_version`, `spec_version` everywhere; language-version axis parked until a parser exists; APS → "writing rules," high-risk-word catalogue advisory over both forms. **Pins the exact spec format text** (frozen target for all later increments) | supersedes 0041 + 0015's spec-file clauses; partially supersedes 0027, 0028 | R1 O-002, O-012 §4; R2 P0-SOL-centrality, §16; T2, T9, T17 |
| 3 | **0059 — Frontmatter `type:` is the sole artifact discriminator** | `type:` discriminates all artifacts (formalizes `docs/model/workspace.md:58`); `.swarm.` infix → optional convention meaning "SOL-form spec," never required/checked; "MUST NOT parse a plain `.md`" rule and the infix-partition model deleted; `*.swarm.ir.json`/`*.swarm.plan.json` survive only as future-CLI contract names | supersedes the infix-partition model (`docs/model/source-artifacts.md` §1); refines 0030, 0054 | R1 O-012 §1; T1 |
| 4 | **0060 — The Swarm Workspace: hybrid layout, committed flow artifacts** | Feature folders for durable intent (`specs/<slug>/` + co-located audit/research/prd/inventory; `NNN-` prefix optional); type folders for flow artifacts (`intake/ tasks/ reviews/ findings/` top-level) — all **committed**; `findings/` top-level (not `.agents/memory/`); **status split**: hand-edited workspace `status.md` board (core) vs per-spec coverage read-model (demoted to reference/future-CLI, renamed); committed review packet linking the PR is the default record (PR-as-verdict survives only as the no-workspace minimum); trace folds into the packet's evidence column (schema kept on future-cli page); co-located mode first-class: same tree under one visible `swarm/` dir. **Pins task (R2 §17) and review-packet (R2 §18) formats** | supersedes 0004; partially supersedes 0052 (feature folders kept; scratch rule + `.agents/memory/` home replaced); refines 0049, 0050 (§4 inverted), 0032, 0030 (trace out, status in) | R2 §21, P1-files-live, P1-review-wedge; R1 O-005; T3, T6, T15 |
| 5 | **0061 — Intake artifact + the Pull step** | Thinnest snapshot wrapper (`type: intake`, `source:`, `url:`, `captured:` + verbatim paste); never authored/linted/promoted; **recommended** (not required) when work originates in an external tool; does not replace prd/research/bug-report (advanced source-docs); zero connectors — `swarm pull` is future-CLI only; ships `templates/intake.md` in core | partially supersedes 0053 Decision §3 (intake dir now earned); reaffirms its no-connectors clause; refines 0030 | R2 §12.2, §15 (its own template gap fixed); T5 |
| 6 | **0062 — Code-repo adapter: no `.swarm/`, ever** | Code repo stays pristine: optional one-line `AGENTS.md` pointer to the workspace; task handed at run time (paste, path, or gitignored scratch path per `.gitignore.additions`); one optional `implement-task` skill; PR links the workspace review packet. R2 §6's `.swarm/work/` rejected via R2's own escape hatch | reaffirms 0049, 0050 (clarification, no supersession) | T4; ADR-0049's empirical bug evidence |
| 7 | **0063 — Tooling boundary + honest-language pass** | swarm-cli named the reference implementation of `docs/reference/checks.md`; every check labeled "checked by hand, or by swarm-cli"; lint codes = "common mistakes to check for," never floors/defects; AGENTS.md cap → "aim for ~100 lines" (no HARD CAP / regression-check claims, repo-wide); every enforcement-sounding claim either names its aspirational checker or becomes convention/reviewer guidance | refines 0023, 0026, 0034, 0043, 0055; operationalizes PRINCIPLES Invariant 2 / NON-GOALS N6 | R1 O-003, O-004, O-009, O-012 §§2/5/6, R-002, R-004; T8, T19 |
| 8 | **0064 — Minimal kit tiering** | Core: `templates/{spec,task,review,finding,status,intake}.md` + `agent/{AGENTS.md, write-spec, implement-task, review-output}` + one worked example. Advanced: audit/bug/research/adr/rfc/prd/inventory templates; guides write-audit (absorbs persona-auditor), write-research, **persona-surveyor kept standalone** (R1 O-008), write-bug-report/prd/rfc, spec-check (ex pass-lint-spec), save-findings (ex pass-promote-findings), split-work (ex pass-lower + pass-decompose), **write-inventory** + `inventory.md` template (new — R1 O-011; reconstructive stance folded into the guide, no standalone persona-archaeologist); cut as standalone: persona-architect/skeptic/documentarian/researcher, distillation-discipline, empirical-proof, pass-improve-spec (all folded per T10); SKILL.md carrier kept; threat-model deleted | partially supersedes 0019, 0002, 0009; refines 0042, 0036, 0047, 0056 | R1 O-006, O-007, O-008, O-010, O-011, R-001; R2 §14; T10, T12 |
| 9 | **0065 — Three flagship examples; corpus stays at `conformance/`** | `docs/examples/{feature-from-jira,bug-fix,large-pr-review}.md`, each end-to-end (input→spec→task→agent summary→review packet→finding/status); seeded from auth-refresh / payment-5xx / checkout respectively; **large-pr-review is the main demo**, linked from README; golden corpus keeps its path, reframed "checks fixtures," content re-cut per 0058/0059 | refines 0033 | R2 P2-examples, P1-review-wedge; T11 |
| 10 | **0066 — Checks redefinition (conformance v2)** | Adopter validity bar = populated AGENTS.md (soft length guidance) + core templates present + ≥1 spec satisfying the form-agnostic contract; six-Tier-2-doc-copy clause **dropped** (reference linked, not copied); A10–A16 + closed-set counts survive **producer-internal only** in `conformance/README.md`; reference pages list **values, never counts**; evidence rules (`non-empty-paste`, `no-open-critical`) kept verbatim | partially supersedes 0026 + 0033's conformance-bar clauses + 0051's bar; refines 0051 | R1 O-004, O-012 §3; R2 §9.6, P1-math-framing; T13 |
| 11 | **0067 — Memory tiering** | Core = `findings/` (provenance fields kept) + one Close-step rule ("before closing, record anything durable as a finding"); INDEX load-when discipline, glossary, patterns, 7-status promotion enum, stale ledger → one advanced page `docs/reference/memory.md` (research cites move with it); `memory/INDEX.md` leaves the conformance bar | refines 0032 | R1 R-003; R2 §21; T14 |

---

## 3. Phased increments

### 3.0 Standing machinery (applies to every increment)

**Fixed derivation order (never violated):** ADRs → canonical `docs/` + README → examples → starter-kit → `.agents/` dev subset → `docs/library/code-skills/` → `conformance/` + `evals/` → sweep → swarm-cli → close. Never edit a derived surface before its canonical source.

**Propagation matrix:** `.agents/audits/repositioning-propagation.md`. Rows = 13 derived surfaces: (1) kit agent guides, (2) kit advanced reference cards, (3) kit templates, (4) kit shell (README/agent AGENTS.md/example/decisions/.gitignore.additions), (5) `.agents/skills/` + manifest, (6) `docs/library/code-skills/`, (7) `conformance/conformance.yaml`, (8) `conformance/fixtures/` + prose-corpus, (9) `evals/`, (10) `docs/examples/`, (11) `docs/reference/cheatsheet.md`, (12) root `AGENTS.md`/symlinks, (13) swarm-cli (external). Columns = ADRs 0057–0067. Cells = pending/done + commit SHA.

**Reconciliation Gate (run at the end of every increment; outputs pasted into the matrix — §0.7 evidence discipline):**
1. Link audit: every relative `](...)` markdown link resolves; every `[[KEY]](…/research/sources.md#KEY)` anchor on moved pages resolves (`docs/research/sources.md` never moves).
2. Banned-token grep, tier-scoped (lists in §9.2).
3. Reference-value check: `7 block types|5 modals|7 verdicts|9 proof|9 steps|10 improve|5 lint layers|17 task_kind|A1[0-6]` hits allowed only in `conformance/README.md` producer note + the cheatsheet appendix.
4. Terminology one-way check: §4 column-B terms absent from user-tier files except inside the glossary mapping.
5. Matrix rows touched this increment flipped with SHA.
6. Same-commit rule: any commit changing a format (spec/task/review/intake schema) also updates its fixtures + examples + templates in that commit, or it doesn't land.

---

### Increment 0 — Pivot scaffolding (S)
**Goal:** machinery exists; the dead invariant is suspended.
**File ops:**
- CREATE `.agents/audits/repositioning-propagation.md` (matrix above + the §9.2 banned-token lists pasted verbatim so the gate is itself single-sourced).
- EDIT root `AGENTS.md` (symlinks `CLAUDE.md`/`GEMINI.md` follow automatically): add transition banner — "Pivot in progress per ADRs 0057–0067. The 'counts MUST reconcile everywhere' invariant is suspended; it re-scopes to the producer note in `conformance/README.md`. Do not derive skills from docs during the window."
**Gate:** read-through; matrix exists.

### Increment 1 — Decision layer: ADRs 0057–0067 (L; two commits permitted: 0057–0061, 0062–0067)
**File ops:**
- CREATE `docs/adrs/0057-practical-first-repositioning.md` … `0067-memory-tiering.md` per §2, each with a Propagation section. 0058 and 0060 embed the **frozen format texts** (§5) verbatim.
- EDIT `docs/adrs/README.md`: +11 ledger rows; add banner "Most users don't need to read these — they record why Swarm is shaped the way it is."
- EDIT the 28 ADRs from D9: append neutral forward-pointer status lines.
**Gate:** ledger row count = 67; every superseded ADR carries a forward pointer; `grep -rn "Superseded by\|Refined by" docs/adrs/` consistency output pasted.

### Increment 2 — Identity layer: README + PRINCIPLES (M) — the highest-leverage P0, front-loaded
**File ops:**
- REWRITE `README.md` (target ≤120 lines), exact structure (Draft A):
  - `# Swarm` + one-liner: **"A lightweight spec and review workflow for teams using coding agents."** Second line: **"Turn tickets into clear specs, specs into agent-ready tasks, and agent output into evidence you can review — plain markdown, any agent, no runtime."**
  - `## The problem` — vague tickets; re-pasted context; agent drift; giant unreviewable PRs; lost findings. Closing: *"Swarm is not an agent. Claude Code, Codex, Cursor, Aider, or a human does the coding — Swarm organizes the work around them."*
  - `## The loop` — the §1 diagram + six numbered one-liners.
  - `## Sixty seconds of Swarm` — 6-line spec excerpt (AC-001 + `Verify with:`) + 8-line review-packet excerpt, then: *"That table is the point: instead of reading a 3,000-line diff, you read which requirements passed with evidence, which didn't, and where your eyes are needed."*
  - `## Where files live` — Framework / your workspace / your code repos (stay clean) micro-diagram.
  - `## What works today, what comes later` — two short lists; one link to (future) `docs/reference/future-cli.md`; no-runtime reduced to two sentences (top-level "The one rule: NO RUNTIME" section deleted).
  - `## What Swarm is / is not` — the §1 lists.
  - `## Get started` — 6-line manual copy checklist + "or hand your agent `docs/ADOPTING.md`."
  - `## Going deeper` — links (point at *existing* files for now; re-pointed in 3e). **Drop** the `Swarm v0.1 · SOL/0.1 · APS 0.1` footer.
  - Strikes: `:3` "build from reliably", `:4-5`/`:15` "source of truth", `:27-31` lower/structured-form, `:34-36` closed-set counts, `:61-67` NO-RUNTIME section, `:88` footer.
- REWRITE `docs/PRINCIPLES.md` in place: R2 §24.3 preamble ("Swarm centers on clear requirements, bounded tasks, review evidence, and durable findings"); Invariant 4 (CODE IS REALITY) promoted into the preamble; Invariant 3 re-scoped to the future-CLI contract; "self-policed, not machine-enforced" added; `:95` regression-check sentence deleted. (Physical move in 3d, per D8.)
- EDIT `docs/positioning.md` body → R2 §11 one-liner/long-form (deletion deferred to 3e); EDIT `docs/NON-GOALS.md` framing only (merge deferred to 3a).
**Gate:** banned-token grep on README (`source of truth|reliably|lower|\bIR\b|closed set|SOL/0.1|obligation|verdict|compiler`) = 0 outside quotes; R2 §23 Q1/Q2/Q10 answerable from README alone.

### Increment 3 — docs IA restructure (XL; six sub-commits; staged per D5 — new pages land with old pages carrying one-line "superseded by `<path>`" banners; deletion is one atomic sub-commit)

**3a (M):** CREATE `docs/01-what-is-swarm.md` (merge `positioning.md` + NON-GOALS essence; "What Swarm is not" per R2 §11.4; N-table in plain language), `docs/02-basic-workflow.md` (six-step core from `docs/model/how-swarm-works.md`; ends: *"There is a more granular nine-step lifecycle for high-risk changes — see `reference/advanced-lifecycle.md`. The six steps are the default."*), `docs/03-where-files-live.md` (from `docs/model/workspace.md` + ADOPTING "what you end up with" + `docs/library/overlays.md`; Framework/Workspace/Code-Repo-Adapter; the T3 hybrid tree; the no-`.swarm/` adapter story; co-located `swarm/` mode first-class — R1 O-005).
**3b (M):** CREATE `docs/04-writing-specs.md` (seeds: `docs/passes/author.md`, `docs/artifacts/spec.md`, APS practical half, `write-spec` SKILL; full §5.1 format inline; ~10 writing-rule bullets, high-risk-word list *advisory*; "Dropped from sources" practice celebrated — R1 O-010; ~7 simple-form checks; closing "Stricter notation: SOL" section with R2 §16.1 side-by-side + link), `docs/05-creating-tasks.md` (from `docs/artifacts/task.md` + decompose practical half + `docs/library/code-skills/templates/task.md`; §5.2 format; split-work guidance; no merge_safe machinery), `docs/06-running-agents.md` (from `docs/passes/implement.md` + ADR-0046; worktree+branch isolation, `swarm/<spec-slug>` branch grammar kept; run-summary expectation; self-review-before-done in plain words — ADR-0056).
**3c (M) — the wedge, atomic:** CREATE `docs/07-reviewing-output.md` (consolidates the five current review homes: `docs/passes/review.md`, `verify.md` evidence basics, `docs/artifacts/review.md`, `trace.md` user-facing role, `pass-review-trace`+`empirical-proof` content; §5.3 packet format; review by exception; the two evidence rules in plain words — *"Pass needs pasted output or a CI link; an empty evidence cell means Unverified, not Pass"*, *"don't merge with an open critical item"*; refute-by-default from persona-skeptic; results = Pass/Fail/Unverified/Blocked, lifecycle values → reference), `docs/08-saving-findings.md` (from `docs/passes/promote.md` + `finding.md` + `memory.md` core + promotion-protocol core flow; the one Close rule; link to `reference/memory.md`), `docs/09-integrations.md` (mostly new: per-CLI skill-dir install notes — `.claude/skills/` vs `.agents/skills/`, fixing R1 O-007; Pull against Jira/Notion/Linear/GitHub — manual paste today, `swarm pull` future; the "Swarm organizes, your agent codes" boundary).
**3d (L):** build the reference layer.
- CREATE `docs/reference/structured-requirements.md` ← `docs/language/SOL.md` (+ `grammar.md` EBNF as appendix; "notation," never "language"; versioning note per D6). **Owns the normative "Two surfaces, one model" section** (§5.0) — checks.md, pages 04/07, templates link to it, never restate it.
- CREATE `docs/reference/checks.md` ← `docs/language/errors.md` + `docs/passes/lint.md` + `docs/model/conformance.md` adopter half + `docs/reference/proof-types.md`. Two tiers: core checks C001–C00n (both forms) and the `SOL-<LAYER>NNN` catalogue (`format: sol` only), with an explicit C↔SOL mapping table (e.g. C001 unique-IDs ↔ SOL-S005); framed "common mistakes to check for"; one line: *"Reference implementation: `swarm spec check` in swarm-cli."*
- CREATE `docs/reference/artifact-formats.md` ← all 16 `docs/artifacts/*` + `docs/model/source-artifacts.md` (§1 rewritten per 0059; core/advanced tiers; per-page "conformant repository MUST NOT" boilerplate deleted; ex-`status.md` read-model renamed "coverage read-model" here).
- CREATE `docs/reference/future-cli.md` — R2 §19 command model; `docs/reference/structured-form.md` 653-line schemas as appendix; reserved `*.swarm.ir.json`/`plan.json` names; workspace.md's five source-surface policies; trace schema; deferred verbs; honest header: *"None of this exists yet. The reference implementation in progress is swarm-cli."*
- CREATE `docs/reference/advanced-lifecycle.md` — nine-step↔six-step mapping (T18 fix), `passes/{improve,lower,decompose}` residues incl. the 10 improve ops, `task-orchestration.md` essentials, R1 R-003 risk-scaling.
- CREATE (moves): `docs/reference/principles.md` (← `docs/PRINCIPLES.md`), `source-authority.md` (← model/, "authority over *intent*," never "truth"), `memory.md` (← promotion-protocol + artifacts/memory advanced model per 0067), `agent-guides.md` (← `library/pass-guides.md`), `review-stances.md` (← `library/heuristic-profiles.md`).
- REWRITE in place: `docs/reference/cheatsheet.md` → practical **"Swarm Reference"** (requirement labels / review results / verification methods / file types — **values, never counts**; small reference-values appendix pointing at the producer note); `glossary.md` (new vocabulary primary, canonical terms as aliases, both directions); `distillation-loss-budget.md` (tone pass); `drift-and-staleness.md` (advanced pairing note).
**3e (M) — atomic deletion + link sweep:** DELETE `docs/language/` (5 files), `docs/passes/` (9), `docs/model/` (5), `docs/artifacts/` (16), `docs/library/{pass-guides,overlays,heuristic-profiles}.md`, `docs/reference/{structured-form,proof-types,promotion-protocol}.md`, `docs/positioning.md`, `docs/NON-GOALS.md`, `docs/PRINCIPLES.md`. **KEEP `docs/reference/golden-corpus.md` until Increment 8** (D4). Re-point README links to 01–09; repo-wide link audit incl. `[[KEY]]` relative prefixes on every moved page.
**Labeling (every page in 01–09, reference/, examples/, exactly one italic line under the H1):**
- `*Works today — plain markdown plus your agent; no Swarm tooling required.*`
- `*Future automation — a contract for tooling that does not exist yet; nothing on this page runs today.*` (only `future-cli.md`)
- `*Advanced design note — internal rationale; not needed to use Swarm.*` (principles, source-authority, advanced-lifecycle, adrs/README)
Inline rule: future commands appear in 01–09 only as *"(future CLI: `swarm review` will draft this packet — today you or your agent fills the template)"*, max one aside per page; command tables live on `future-cli.md` only.
**Gate per sub-commit:** `grep -rn "docs/\(language\|passes\|model\|artifacts\)/" README.md docs/ starter-kit/ .agents/` trending to 0 by 3e; citation-anchor check; banned-token grep on new pages.

### Increment 4 — Flagship examples (M)
**File ops:** CREATE `docs/examples/feature-from-jira.md` (← `auth-refresh.md` + invented JIRA-123 intake snapshot front; full chain in pinned formats), `docs/examples/bug-fix.md` (← `payment-5xx.md`; one Unverified→fixed beat; one-line brownfield `write-inventory` pointer), `docs/examples/large-pr-review.md` (**the main demo**, mostly new, seeded from `checkout.md`'s review stage: 40-file agent PR → 9-row coverage table (3 Pass-with-evidence, 1 Fail, 2 Unverified, scope-creep item) → Block → follow-up task → second packet → merge + finding). DELETE `docs/examples/{auth-refresh,checkout,payment-5xx}.md` same commit (never six examples).
**Propagation note:** conformance fixtures de-correlate from example names — accepted until Increment 8 (name-mapping lands there); matrix note added now.
**Gate:** each example's section headers diff clean against the ADR-pinned formats; link check; `large-pr-review` linked from README.

### Increment 5 — Starter-kit rebuild + ADOPTING rewrite (L; the biggest blast radius, isolated)
**File ops (target tree in §6.1; template texts in §5):**
- CREATE `starter-kit/templates/{spec,task,review,finding,status,intake}.md` per §5 (spec ← `.agents/templates/spec.swarm.md` de-SOL'd, "Dropped from sources" kept; task ← `docs/library/code-skills/templates/task.md` + R2 §17, with the self-review instruction preserving 0056; review rebuilt to the packet shape; status/finding/intake new).
- CREATE `starter-kit/agent/AGENTS.md` (← `starter-kit/AGENTS.md`): header → *"Keep this file short — aim for ~100 lines. Agents read it on every task, so every line spends always-loaded budget."* (no HARD CAP/regression-check); Commands comment → *"These are the commands an agent runs to verify work in this repo. Nothing executes them automatically today — you, your agent, the future CLI, or CI does."* (SOL-V002/BLOCKED line deleted); six-step loop replaces the step-guide pointer list. MOVE `CLAUDE.md`/`GEMINI.md` symlinks alongside; symlink rule restated.
- CREATE `starter-kit/agent/write-spec/SKILL.md` (absorbs persona-architect no-smuggled-implementation rules + distillation-discipline + improve's revision section), `agent/implement-task/SKILL.md` (← `docs/library/code-skills/implement-and-verify/` + empirical-proof worker rules; isolation + self-review kept), `agent/review-output/SKILL.md` (← `pass-review-trace` + persona-skeptic refute-by-default + `pass-promote-findings` close section).
- CREATE `starter-kit/examples/feature-from-ticket/{ticket,spec,task,review,finding}.md` (ticket invented; spec ← `specs/001-contact-form/spec.swarm.md`; derived from `docs/examples/feature-from-jira.md` — derivation note in the dir).
- CREATE `starter-kit/advanced/`: `README.md` ("all optional"); templates `{audit,bug,research,adr,rfc,prd,inventory}.md`; `sol-reference.md` (← `.agents/reference/sol.md` — closed-set counts block and lint-floors block **stripped** [the exact R1 O-012 strings]; 5 modals + AC shape + verify notes up front); `checks-reference.md` (← `proofs.md`, renamed vocabulary); guides `{write-audit,write-research,persona-surveyor,write-bug-report,write-prd,write-rfc,spec-check,save-findings,split-work,write-inventory}/SKILL.md` (renamed per §4; surveyor kept intact).
- DELETE the entire `starter-kit/.agents/` tree (20 skills incl. `pass-lower-spec`, 3 cards incl. `ir.md`, 11 templates incl. `threat-model.md` + `memory/INDEX.md`, 2 memory seeds), `starter-kit/specs/` (incl. `001-contact-form/` with audit.md/research.md), old `starter-kit/AGENTS.md` + root-level symlinks.
- REWRITE `starter-kit/README.md` (5-minute tour; copy checklist; advanced optional), `starter-kit/decisions/0001-adopt-swarm.md` (new positioning), `starter-kit/.gitignore.additions` (code-repo scratch only — workspace tasks/reviews are committed).
- REWRITE `docs/ADOPTING.md`: **Manual copy checklist first** (templates ×6, `agent/`, `.gitignore.additions`, `decisions/0001`), agent-assisted prompt second, future-CLI third; co-located variant inline; symlink rule for `agent/AGENTS.md`.
**Gate:** `find starter-kit -type f` matches ADR-0064's enumerated list; copy surface = 10 files, kit excl. `advanced/` ≤ 22 (D10); every backticked path in ADOPTING exists (`test -e` sweep, output pasted); symlinks resolve; banned-token grep on `starter-kit/` (excl. `advanced/` for reference-tier terms) = 0.

### Increment 6 — Dev surface re-derive + root AGENTS.md end-state (M)
**File ops:** REWRITE `.agents/SKILLS-MANIFEST.md` (census, included/omitted, divergence notes) and re-derive `.agents/skills/` from the new kit/advanced guides (prune all `pass-*`; curated subset: write-audit, review-output, persona-surveyor, etc.). REWRITE root `AGENTS.md` to end state: pointers → `docs/01–09`, `docs/reference/`, `docs/adrs/`, `conformance/`; "Canonical closed sets" section → one pointer to the producer note ("reference values live in exactly two places: the cheatsheet appendix and `conformance/README.md`; nowhere else states a count"); `pass-*` "stable skill identifiers" caveat deleted; derivation-order + terminology one-way rules added; transition banner **stays** until Increment 11.
**Gate:** every AGENTS.md pointer resolves (`test -e` sweep pasted); manifest census = `ls .agents/skills` count.

### Increment 7 — code-skills library rework (M)
**File ops:** REWRITE `docs/library/code-skills/README.md` as the optional advanced agent-guide library index (referenced from `docs/reference/agent-guides.md`); RENAME `implement-and-verify/` → `implement-task/` (long-form advanced guide, cross-linked to the kit guide); fold the 7 `persona-*` code personas into their `write-*` guides; vocabulary sweep across all `write-*` + `fix-flaky-test/`; DELETE `templates/task.md` (kit template landed in 5) and `templates/trace.md` (→ review-packet evidence + future-cli schema).
**Gate:** banned-token grep on `docs/library/`; zero references to deleted kit paths.

### Increment 8 — conformance + evals rework (L; one commit per format-coupled change)
**File ops:**
- REWRITE `conformance/conformance.yaml`: drop `language: SOL/0.1` discriminator (→ optional `format: sol`); task schema → Source / Scope / Do not change / Affected areas / Verify / Agent instructions (with the self-review instruction); review schema → packet shape; KEEP `non-empty-paste` + `no-open-critical` verbatim; command rows advisory.
- RE-CUT `conformance/fixtures/{auth-refresh,checkout,payment-5xx}/` + `conformant-task.md` + `violations.md`: per domain a **surface-equivalence pair** — `spec.md` (simple form) and `spec.sol.md` (`format: sol`) denoting identical requirement records, plus a fixture asserting the records reconcile (**the anti-fork proof**); new task/review shapes; one intake fixture; every `EXPECTED.md` re-pinned with rationale; `*.swarm.ir.json` fixtures → `advanced/` subdir keyed to future-cli.md; `prose-corpus/labeled.yaml` relabelled under "writing rules." Fixture dirs keep old slugs; README name-mapping added (auth-refresh↔feature-from-jira, payment-5xx↔bug-fix, checkout↔large-pr-review).
- REWRITE `conformance/README.md`: absorb `docs/reference/golden-corpus.md` (then DELETE it — held back from 3e per D4); add the **producer-internal "Reference-value reconciliation" note** (successor of A10–A16 and the counts hub — the only place counts live); reframe as "checks fixtures — test data for `docs/reference/checks.md`, consumed by swarm-cli."
- REWRITE `evals/README.md` + 9 rubrics: keyed to six steps (author/lint/improve→Spec; lower/decompose→Task-advanced; implement/verify→Run; review re-cut to packet shape; promote→Close); terminology sweep.
**Gate (same commit, reconciliation rule 6):** fixture section headers diff clean against `conformance.yaml`; counts in the producer note, cheatsheet appendix, and yaml reconcile **in this commit**; anti-fork pairs present in all three domains.

### Increment 9 — Global terminology sweep + grep gates (M)
**File ops:** sweep stragglers across user-facing trees; run the full §9.2 gates and paste outputs into the matrix; rerun the repo-wide link audit.
**Gate:** zero hits per scope; link audit clean.

### Increment 10 — swarm-cli re-sync (M; sibling repo `/Users/josecosta/dev/swarm-cli`)
**File ops (other repo):** re-sync the kit copy per its documented procedure; re-cut its spec suite `specs/00{1..4}/` to the new frontmatter/format; point `swarm lint` at the two-tier `checks.md` contract + `format: sol` selector + new fixtures; re-check the safety overlay; record in its audit backlog (known gotcha: derived layer lags ADRs).
**Gate:** `swarm lint` green on its re-cut specs **and** on this repo's prose-variant fixtures — real command output pasted into the matrix.

### Increment 11 — Cold re-adoption + adversarial self-review (M; ADR-0056 applied to the shift itself)
**File ops:** run R1's adopter exercise cold (fresh workspace, one feature, manual checklist path) + the R2 §23 10-question/10-minute test; FILE `.agents/audits/post-pivot-adoption-review.md`; adversarial self-review of the shift (vocabulary seams, dead links, contradictory tiers, surviving enforcement claims) with fixes landed; close the propagation matrix (no pending cell); remove the transition banner from root `AGENTS.md`.
**Gate:** audit filed with no open critical finding; matrix closed; §23 answers match R2's expected set.

**Effort roll-up:** S×1, M×9, L×4 (Increments 1, 3d, 5, 8); ~13–15 working sessions.

---

## 4. Terminology map

**Tier scoping (B's three tiers):** **User tier** — `README.md`, `docs/ADOPTING.md`, `docs/01–09`, `docs/examples/`, `starter-kit/` core (templates, agent/, examples, README): column A only. **Reference tier** — `docs/reference/`, `starter-kit/advanced/`: column B primary, glossary maps both directions. **Producer tier** — `conformance/`, `evals/`, `.agents/`, `docs/adrs/`: column B freely.

| A — user-facing | B — reference/internal | Notes |
|---|---|---|
| step | pass | "pass" never appears in 01–09; `type: pass-guide` → `type: agent-guide` **in all tiers** |
| agent guide | pass guide | `docs/reference/agent-guides.md` |
| requirement / acceptance criterion (AC) | obligation | |
| evidence / verification method | proof / proof type | 9 verification methods listed as values |
| review result (Pass, Fail, Unverified, Blocked) | verdict (7-value model incl. WAIVED/STALE/CONTRADICTED) | values listed, never "7 verdicts" |
| save a finding | promote | protocol → `reference/memory.md` |
| checks / "common mistakes to check for" | conformance / lint / `SOL-XNNN` codes | codes only in `reference/checks.md`; "lint floor"/"defect" banned in **all** tiers |
| structured requirements (SOL) | SOL | never "language," never "SOL/0.1" |
| writing rules / spec hygiene | APS | |
| review stance / role | heuristic profile / persona | |
| prepare tasks / split work | lower / decompose | "lower"/"IR"/"structured form"/`*.swarm.ir.json` only on `future-cli.md` |
| requirement map | obligation graph | |
| agent run summary (in the review packet) | trace | trace schema → future-cli page only |
| workspace / Swarm Workspace | spec repo | |
| reference values | canonical counts / closed sets / A10–A16 | counts only in `conformance/README.md` + cheatsheet appendix |
| "aim for ~100 lines" | — | HARD CAP / regression check banned in **all** tiers |
| "spec = source of intended behavior; code = implementation reality" | — | "spec is the source of truth" banned in **all** tiers |
| "easier to start, safer to review, less likely to lose context" | — | "agents build reliably" banned everywhere |
| intake | (new term, no predecessor) | |
| six-step loop | nine-step lifecycle | mapping table in `advanced-lifecycle.md` |

**Rename scope rules (T7 — full rename, no seam):** skill/guide **directory names**, `type:` frontmatter, and prose all rename now (`pass-review-trace`→`review-output`, `implement-and-verify`→`implement-task`, `pass-lint-spec`→`spec-check`, `pass-promote-findings`→`save-findings`, `pass-lower-spec`+`pass-decompose-spec`→`split-work`). **Keep internal names:** `SOL-<LAYER>NNN` code identifiers (in `checks.md` only), `SOL` and `APS` as proper names in reference, the `conformance/` directory path, `docs/adrs/` path (D1), `docs/research/sources.md` path, fixture dir slugs (with name-mapping), the `swarm/<spec-slug>` branch grammar, `*.swarm.ir.json`/`*.swarm.plan.json` as future-CLI contract names.

---

## 5. New/changed artifact formats

### 5.0 The one-data-model contract (normative home: `docs/reference/structured-requirements.md` § "Two surfaces, one model"; everything else links, never restates)
1. **Requirement record** (form-independent): `{ id, strength, statement, verify_refs[], kind, edges[] }` + spec-level `{ intent, non_goals[], open_questions[], affected_areas[], sources[] }`. The structured form (future-cli appendix) is defined once over this record — no simple-form IR vs SOL-form IR.
2. **Shared ID namespace:** `### AC-NNN` heading id ≡ SOL block id; both address as `spec-id#AC-NNN`; simple→SOL migration keeps every id.
3. **Shared strength enum:** the 5 SOL modals stay canonical (reference tier); simple form = one binding modal word per requirement (must / must not / should / may), mapping table in the section; zero or two modals = core check C-modal.
4. **One verification field, two precisions:** simple `Verify with: <ref>` = unresolved note; SOL `VERIFY BY <type>:<adapter>:<artifact>` = resolved binding (0038 softened: a note naming a not-yet-existing test reviews as **Unverified**, never a broken contract). Review consumes only `{id, verify_ref, result}` — identical over both forms.
5. **Kind is a projection:** simple form has one kind (requirement); the 7 SOL block types are SOL-only refinements; no simple-form block-type syntax is ever invented.
6. **Checks layer, don't fork:** core checks (both forms): unique IDs; verify note per requirement; one binding modal; no `TBD` in `status: ready`; Non-goals present; Open questions present; sources/intake named. SOL checks: full `SOL-<LAYER>NNN` catalogue when `format: sol`, with the C↔SOL table. APS high-risk wordlist: advisory over both.
7. **Selector:** no `format:` = simple; `format: sol` = SOL; the optional `.swarm.md` infix is a human convention echoing `format: sol` with no independent meaning.
8. **Anti-fork proof is a conformance asset:** each fixture domain ships the surface-equivalence pair with `EXPECTED.md` pinning identical record sets.

### 5.1 `templates/spec.md`
```markdown
---
type: spec
id: SPEC-{{slug}}
title: {{title}}
status: draft
sources:
  - {{ticket-id-or-intake-file}}
---

# {{title}}

## Intent
{{1–3 sentences: the behavior change and why}}

## Non-goals
- {{what this spec deliberately does not change}}

## Requirements
<!-- One ### AC-NNN per requirement. Each gets a "Verify with:" line.
     Prefer stricter notation? Any AC can be a SOL block instead —
     add `format: sol` to the frontmatter. See reference/structured-requirements.md. -->

### AC-001 — {{short name}}
When {{condition}}, {{the component}} must {{behavior}}.

Verify with: `{{test-name-or-command}}`

## Open questions
- {{anything unresolved — a spec with open questions is not `status: ready`}}

## Affected areas
- `{{path}}`

## Dropped from sources
<!-- Optional but recommended: what the ticket/PRD asked for that this spec
     deliberately leaves out, and why. Design rationale lives here. -->
- {{dropped item — reason}}
```

### 5.2 `templates/task.md`
```markdown
---
type: task
id: TASK-{{slug}}
spec: SPEC-{{slug}}
scope: [AC-001, AC-002]
status: ready
---

# Task: {{title}}

## Source
Spec: `specs/{{feature}}/spec.md` (SPEC-{{slug}})

## Scope
Implement:
- AC-001 — {{one line}}
- AC-002 — {{one line}}

## Do not change
- {{areas explicitly out of bounds}}

## Affected areas
- `{{path}}`

## Verify
- [ ] `{{test-or-command}}` (AC-001)
- [ ] `{{test-or-command}}` (AC-002)

## Agent instructions
1. Read the source spec first.
2. Stay inside this task's scope. If a requirement can't be met as written,
   stop and say why instead of improvising.
3. Run every Verify item and paste the real output — a claim without output
   counts as unverified.
4. Before finishing, re-read your own diff as a skeptic: what would a
   reviewer flag?
5. Leave a summary: changed files, commands run with output, and anything
   learned worth saving as a finding.
```

### 5.3 `templates/review.md`
```markdown
---
type: review
id: REVIEW-{{slug}}
task: TASK-{{slug}}
pr: {{pr-url}}
status: {{pass | blocked}}
---

# Review: {{title}}

## Summary
{{2–3 sentences: what changed, what is verified, what is not}}

## Changed files
- `{{path}}`

## Requirement coverage
| ID | Result | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass | `{{test}}` output pasted/linked | no |
| AC-002 | Unverified | no test output found | yes |

<!-- Pass requires real evidence. An empty Evidence cell means Unverified. -->

## Human attention
1. {{exception item — why it matters — suggested action}}

## Suggested decision
{{Merge / Block until …}}
```

### 5.4 `templates/finding.md`
```markdown
---
type: finding
from: {{TASK-or-REVIEW-id}}
date: {{YYYY-MM-DD}}
---

# Finding: {{title}}

## What we learned
{{the durable fact, decision, or pattern}}

## Evidence
{{link to the review packet, PR, or pasted output that grounds it}}

## Where it applies
{{paths / features / situations where this matters}}
```

### 5.5 `templates/status.md`
```markdown
---
type: status
---

# Workboard

| Item | Type | State | Link |
|---|---|---|---|
| {{SPEC-slug}} | spec | open / in-progress / blocked / done | `specs/{{feature}}/spec.md` |

<!-- One honest rule: a "verified" claim in this board needs a link to its
     review packet. -->
```
(The per-spec observed-state read-model is a different artifact — demoted to `reference/artifact-formats.md` as "coverage read-model" / future-CLI output, per T6.)

### 5.6 `templates/intake.md`
```markdown
---
type: intake
source: {{JIRA-123 / notion-page / gh-issue-url}}
url: {{link}}
captured: {{YYYY-MM-DD}}
---

# Intake: {{title}}

<!-- Paste the upstream content verbatim below. Don't edit it — the spec
     interprets; the intake preserves what was actually asked. -->
```

---

## 6. Target trees (final, exact)

### 6.1 `starter-kit/`
```
starter-kit/
  README.md                       (kit tour, copy checklist, "advanced/ is optional")
  .gitignore.additions            (code-repo scratch only)
  templates/
    spec.md  task.md  review.md  finding.md  status.md  intake.md
  agent/
    AGENTS.md                     (+ CLAUDE.md, GEMINI.md symlinks)
    write-spec/SKILL.md
    implement-task/SKILL.md
    review-output/SKILL.md
  examples/feature-from-ticket/
    ticket.md  spec.md  task.md  review.md  finding.md
  decisions/
    README.md  0001-adopt-swarm.md
  advanced/
    README.md
    audit.md  bug.md  research.md  adr.md  rfc.md  prd.md  inventory.md
    sol-reference.md  checks-reference.md
    write-audit/SKILL.md       write-research/SKILL.md   persona-surveyor/SKILL.md
    write-bug-report/SKILL.md  write-prd/SKILL.md        write-rfc/SKILL.md
    spec-check/SKILL.md        save-findings/SKILL.md    split-work/SKILL.md
    write-inventory/SKILL.md
```
Copy surface (`templates/` + `agent/`, symlinks excluded) = **10 files**; kit excl. `advanced/` ≤ **22 files** (vs 47/49 today).

### 6.2 `docs/` + repo root
```
README.md
AGENTS.md (+ CLAUDE.md, GEMINI.md symlinks)
docs/
  ADOPTING.md
  01-what-is-swarm.md      02-basic-workflow.md     03-where-files-live.md
  04-writing-specs.md      05-creating-tasks.md     06-running-agents.md
  07-reviewing-output.md   08-saving-findings.md    09-integrations.md
  reference/
    principles.md  structured-requirements.md  checks.md  artifact-formats.md
    advanced-lifecycle.md  future-cli.md  cheatsheet.md ("Swarm Reference")
    glossary.md  source-authority.md  memory.md  agent-guides.md
    review-stances.md  distillation-loss-budget.md  drift-and-staleness.md
  examples/
    feature-from-jira.md  bug-fix.md  large-pr-review.md
  library/code-skills/            (advanced agent-guide library, renamed/reworded)
  research/sources.md             (path unchanged; de-navigated)
  adrs/                           (0001–0067 + README; kept per D1, labeled "Design decisions")
conformance/                      (README + conformance.yaml + fixtures incl. equivalence
                                   pairs + intake fixture + advanced/ IR subdir + prose-corpus)
evals/                            (README + rubrics re-keyed to six steps)
.agents/                          (skills dev subset re-derived + SKILLS-MANIFEST + audits)
```
Deleted dirs: `docs/language/`, `docs/passes/`, `docs/model/`, `docs/artifacts/`, `starter-kit/.agents/`, `starter-kit/specs/`.

---

## 7. Kept / cut / demoted ledger

**KEPT unchanged (why):** NO RUNTIME / markdown-only (owner constraint; both reports) · provider neutrality + symlink bootloader rule (restated at `agent/AGENTS.md`) · external workspace + pristine code repos, no `.swarm/` ever (0049/0050 reaffirmed by 0062) · worktree+branch isolation + `swarm/<spec-slug>` grammar (0046 → the Run step) · self-contained skills (0047), load-what-the-task-names (0037), delegation/no-always-load (0014/0016/0017) · adversarial self-review (0056 — inside implement-task closing instructions + the packet; wording softened in user docs only) · evidence rules `non-empty-paste` + `no-open-critical` (verbatim in conformance v2) · review-result semantics + merge-gate predicate (0035), 5 modals, 9 verification methods, SOL grammar/EBNF (whole, in reference — demoted never redefined) · `docs/research/sources.md` path + `[[KEY]]` convention · `conformance/` path + corpus role (swarm-cli pointers) · ADR ledger immutability (0044/0045/0048 untouched) · distillation-loss practice as `## Dropped from sources` (R1 O-010, **promoted**) · audit template (R1 O-001 — advanced, flagged "recommended") · **persona-surveyor standalone** (R1 O-008) · PR as merge mechanism · feature folders for specs (0052's traceability argument) · producer main-only workflow.

**DEMOTED (intact, re-tiered):** SOL → `reference/structured-requirements.md` · `SOL-XNNN` catalogue → `reference/checks.md` "common mistakes" · 7-value verdict taxonomy + lifecycle decorators → reference · nine-step lifecycle + 10 improve ops + merge_safe/orchestration → `reference/advanced-lifecycle.md` · IR schemas + reserved filenames + phase taxonomy + five source-surface policies + trace schema → `reference/future-cli.md` · source-authority model → reference ("authority over intent") · memory INDEX/glossary/patterns/7-status protocol → `reference/memory.md` · audit/bug/adr/research/prd/rfc artifacts + templates → advanced tier · A10–A16 + counts → producer note in `conformance/README.md` · heuristic profiles → `reference/review-stances.md` · per-spec status read-model → "coverage read-model" in artifact-formats.

**CUT (recoverable from git; no `_legacy/`):** files — `docs/positioning.md`, `docs/NON-GOALS.md` (merged), `docs/PRINCIPLES.md` (moved), `docs/language/` ×5 (incl. `versioning.md`), `docs/passes/` ×9, `docs/model/` ×5, `docs/artifacts/` ×16 (incl. `threat-model.md`, `task-orchestration.md` as pages), `docs/reference/{structured-form,proof-types,promotion-protocol,golden-corpus}.md`, `docs/examples/{auth-refresh,checkout,payment-5xx}.md`, `docs/library/{pass-guides,overlays,heuristic-profiles}.md`, `docs/library/code-skills/templates/{task,trace}.md`, entire `starter-kit/.agents/` (incl. `ir.md`, `threat-model.md`, `memory/INDEX.md`, memory seeds), `starter-kit/specs/` (incl. 001-contact-form audit/research). Standalone skills folded: persona-architect/skeptic/documentarian/researcher, distillation-discipline, empirical-proof, pass-improve-spec, pass-lower-spec; pass-lint-spec/pass-decompose-spec/pass-promote-findings survive only as renamed advanced guides. Concepts cut from all adopter surfaces: `.swarm.` infix MUST-rules + "sole, sufficient discriminator" · `SOL/0.1`/`swarm_language`/`aps_version`/`spec_version` · HARD CAP + regression-check claims · lint floors/defects/"MUST be rejected" outside future-tool contract pages · closed-set count recitals · "source of truth" slogan · "build reliably" overclaim · per-artifact-page no-runtime boilerplate · README's top-level NO-RUNTIME section · prompt-first adoption as the lead path · `evals/` from user nav.

---

## 8. Open questions for the owner (recommended defaults; decide-by increment noted)

1. **Core guide carrier** — SKILL.md dirs under `starter-kit/agent/` (default: **yes** — Claude Code auto-discovery per ADR-0042; README: "copy these into the dir your agent scans, or just read them") vs R2 §14.1 plain `.md`. Decide before Increment 5.
2. **`format: sol` frontmatter field** — keep the one optional field as the parser hook (default: **keep** — it is the entire selector mechanism in §5.0) vs zero language fields. Decide in ADR-0058 (Increment 1).
3. **`docs/adrs/` vs `docs/decisions/`** — default: **keep `docs/adrs/`** per D1; if the owner overrides, the rename is its own commit with a full link sweep, after Increment 3e.
4. **Trace demotion depth** — fold worker claims into the review packet, schema kept on future-cli (default: **fold**) vs distinct advanced artifact. Decide in ADR-0060.
5. **`conformance/` dir name** — keep path, reframe as "checks fixtures" (default: **keep** — swarm-cli pointers survive) vs rename `checks/`. Decide before Increment 8.
6. **Co-located workspace dir name** — visible `swarm/` dir in single-repo adoption (default: **`swarm/`**, recorded in ADR-0060) vs root-level type folders.
7. **ADR granularity** — 11 ADRs per the tension-register map (default: **11**); acceptable merge: 0057+0058, 0061 into 0060 — but never fold 0059 or 0060 (they reverse recorded decisions and need standalone supersession entries). Decide before Increment 1.

---

## 9. Acceptance criteria / definition of done

1. **R2 §23 ten-question cold-read test (<10 min)**, surface mapping: Q1/Q2 README first 20 lines · Q3 README "Where files live" + `docs/03` · Q4 `docs/04` + spec template · Q5 `docs/05` + task template · Q6 `docs/06` + `docs/09` · Q7 `docs/07` + review template · Q8 `docs/08` · Q9 README "Going deeper" + `starter-kit/advanced/README.md` · Q10 README is/is-not. Executed in Increment 11 (fresh-session agent + one human pass), filed as `.agents/audits/post-pivot-adoption-review.md`.
2. **Grep gates, zero hits, output pasted as evidence.** *User tier* (`README.md docs/ADOPTING.md docs/0[1-9]-*.md docs/examples/ starter-kit/` excl. `starter-kit/advanced/`): `compiler` · `lower\b` (step sense) · `\bIR\b` · `swarm\.ir\.json` · `structured form` · `lint floor` · `HARD CAP` · `regression check` · `SOL/0.1` · `swarm_language` · `aps_version` · `closed set` · `nine-pass|9 passes` · `pass guide` · `obligation` · `verdict` · `proof type` · `conformance` · `heuristic profile` · `MUST contain the .swarm.` · `sole, sufficient discriminator` · `source of truth` (spec sense) · `build reliably` · `MUST (be )?reject`. *Reference tier* (`docs/reference/ starter-kit/advanced/`): `HARD CAP` · `regression check` · `lint floor` · `SOL/0.1` · `source of truth` (spec sense) · enforcement claims with no named checker. *All tiers*: `HARD CAP`, `regression check`, "spec is the source of truth," "build reliably." Positive check: `grep -c "Verify with:"` > 0 in every spec artifact.
3. **Link integrity repo-wide:** zero references to `docs/{language,passes,model,artifacts}/` or `starter-kit/.agents/`; every `[[KEY]]` resolves to a real anchor in `docs/research/sources.md`.
4. **Anti-fork proof:** all three fixture domains ship simple/SOL equivalence pairs with pinned `EXPECTED.md`; the "Two surfaces, one model" section exists in `reference/structured-requirements.md` and is the **only** normative statement of the mapping (04/07/checks/templates link, never restate).
5. **Counts confined and reconciled:** counts/A10-successors appear only in `conformance/README.md` producer note + cheatsheet appendix, agree with `conformance.yaml`, updated in one commit (Increment 8).
6. **Kit minimal:** `find starter-kit -type f` matches ADR-0064's list; copy surface = 10 files; kit excl. `advanced/` ≤ 22; every path in ADOPTING's manual checklist exists (`test -e` sweep pasted); symlinks resolve.
7. **Honesty bar:** zero enforcement-sounding claims without a named (aspirational) checker; the only enforcement pointer is "swarm-cli implements `checks.md`"; cap language is "aim for ~100 lines" everywhere.
8. **Labeling:** every page in `docs/01–09`, `docs/reference/`, `docs/examples/` carries exactly one of the three §3-Increment-3 status lines; only `future-cli.md` carries the future label; no command table outside it; max one future-CLI aside per 01–09 page.
9. **Chain-complete examples:** each flagship contains its full artifact chain; `large-pr-review.md` linked from README as the demo; exactly three files in `docs/examples/`.
10. **Ledger integrity:** ADRs 0057–0067 merged with Propagation sections fully checked; 28 prior ADRs carry neutral forward pointers; `docs/adrs/README.md` lists 67 entries + the banner.
11. **Derived-layer sync:** propagation matrix has no pending cell (13 surfaces × 11 ADRs); `.agents/SKILLS-MANIFEST.md` census matches `ls .agents/skills`; fixture headers diff clean against `conformance.yaml`; evals re-keyed.
12. **swarm-cli green:** resync recorded in its backlog; `swarm lint` output pasted showing green on its re-cut suite and this repo's prose-variant fixtures.
13. **ADR-0056 applied to the shift:** adversarial self-review critique recorded in the Increment-11 audit with fixes landed; transition banner removed from root `AGENTS.md` only after 1–12 hold. Sizes: `README.md` ≤ 120 lines; each `docs/01–09` page ≤ ~150 lines.

---

## 10. Risks and mitigations

| # | Risk | Mitigation |
|---|---|---|
| 1 | **Cross-link breakage at scale** — README, both AGENTS.md files, and nearly every page hardcode `docs/{language,passes,model,artifacts}/` paths; moved pages change their relative path to `sources.md` | Staged creation-with-banners + one atomic deletion sub-commit (3e); `docs/research/sources.md` and `docs/adrs/` never move (D1); link audit in every gate; `[[KEY]]` anchor check on every moved page |
| 2 | **Derived-layer drift (ADR-0047)** — three copies of skill content; killing vocabulary in docs while skills still cite `SOL-S012`/"7 verdicts" recreates the swarm-cli gotcha | Fixed derivation order (§3.0); propagation matrix with per-ADR Propagation checklists; kit (5) → dev subset (6) → code-skills (7) in strict sequence; transition banner forbids deriving during the window |
| 3 | **Counts-reconcile invariant inversion** — root AGENTS.md's dead invariant would fail every by-hand coherence check mid-migration | Suspended by the Increment-0 banner; re-scoped to the producer note at Increment 6; counts land in their two final homes in one commit (Increment 8) |
| 4 | **conformance/ + evals/ speak the old language mid-window** — contradictory test data once new formats land | Formats frozen in ADRs 0058/0060 (Increment 1) so Increment 8 implements a pinned target; schema+fixtures+examples same-commit rule; fixture-name mapping fixes example de-correlation from Increment 4 |
| 5 | **ADR ledger integrity** — ~10 prior ADRs assert states the new IA reverses; silent edits are banned | All reversals land as ADRs 0057–0067 before any doc edit; 28 forward pointers, neutral wording; 0044/0045/0048 untouched |
| 6 | **swarm-cli goes stale** — its kit copy, `specs/001–004`, lint, and safety overlay mirror the old layout (known memory gotcha) | Dedicated Increment 10 with a hard gate (pasted green `swarm lint` run on both repos' artifacts); resync recorded in its audit backlog; `conformance/` path and fixture slugs deliberately kept so its pointers survive |
| 7 | **Losing the wedge while moving it** — review content currently lives in 5 places; a half-moved wedge means the product's center is undocumented | Increment 3c is atomic (07 + 08 + 09 in one sub-commit); kit `review-output` guide lands with the templates in Increment 5; acceptance #4/#9 verify exactly two canonical review homes (`docs/07` + `agent/review-output/`) plus the demo |
| 8 | **Losing the rigor R1 praised** — audit template (O-001), distillation-loss statement (O-010), surveyor stance (O-008), VERIFY BY discipline (O-002/0021–0023) | Each has an explicit keep: audit advanced-but-"recommended" + `write-audit` guide; `## Dropped from sources` **promoted** into the core spec template + `docs/04`; `persona-surveyor` the one standalone persona; `VERIFY BY` survives as the resolved-precision tier of the one verification field (§5.0 item 4), full binding grammar in `structured-requirements.md`; the two evidence rules verbatim in conformance v2; ADR-0056 self-review inside `implement-task` + the task template's closing instructions |
| 9 | **Temporary duplication window confuses readers/agents** (old + new pages coexist during Increment 3) | One-line "superseded by `<path>`" banners on every old page from the moment its successor exists; window spans sub-commits of a single increment; matrix tracks the open banners |
| 10 | **Vocabulary seams re-emerge** (a renamed surface citing an unrenamed one) | Tier-scoped grep gates at every increment, not just the end; glossary maps both directions so reference pages can name old terms deliberately; Increment 9 is a dedicated final sweep with pasted evidence |
| 11 | **Scope creep / relitigating SOL** — future contributors reopen "why keep SOL at all" or "why not enforce" | ADR-0057's Context records the T17 reading (O-002 praise + O-012 demotion + O-003 tooling are one coherent position); ADR-0063 names swarm-cli as the single enforcement answer |

**Execution sequencing note:** the format-changing ADRs (0058, 0059) invalidate fixtures, examples, templates, and swarm-cli's parser targets — the increment order (formats pinned in 1 → docs 2–3 → examples 4 → kit 5 → producer surfaces 8 → swarm-cli 10) ensures each derived surface is touched exactly once.
---

## 11. Verification addendum (orchestrator coverage + feasibility pass)

**Provenance:** the workflow's three independent verifier agents failed on session limits; this
pass was performed by the orchestrating agent with both reports and the full repo in context.

**Coverage:** complete. R1 O-001..O-012 (incl. all six O-012 sub-points), R-001..R-004, and every
recommended obligation map to a decision/increment (see §2 "Answers" column and Risk 8).
R2: all six P0s, eight P1s, three P2s, and target sections §11–§24 are covered. Recorded
deviations from R2 (each justified + ADR-logged): `docs/adrs/` kept over `docs/decisions/` (D1);
hybrid workspace layout (feature folders for specs, type folders for flow artifacts) over pure
type folders (T3/ADR-0060); no `.swarm/` in code repos, using R2 §6's own escape hatch
(ADR-0062); `docs/research/sources.md` path kept (anchors) but de-navigated.

**Patches from this pass (fold into execution):**
1. **Increment 1 gate clarification** — "ledger row count = 67" means the README index covers
   0001–0067 *including* the intentionally-vacant 0011/0012 rows; file count is 65.
2. **Increment 11 addition** — update `.agents/audits/critical-review-aspects.md` resolution
   statuses (several watch-list items are answered by ADRs 0057–0067) and append a closing note
   to `.agents/audits/dx-using-swarm-to-build-swarm-cli.md` (G3 derived-layer-lag mitigated by
   the propagation matrix; F5 content_hash unaffected by this shift).
3. **Increment 3b/advanced note** — R1's "audits are insufficient for rewrites/refactors alone"
   guidance gets one explicit sentence in `write-inventory/SKILL.md` and the audit template's
   header, not just the bug-fix example pointer.

---

## 12. Report 3 integration — "Practical Spec, Change, Task, and Review Workflow" (strategic synthesis v0.2)

**Input:** `.agents/plans/inputs/report-3-strategic-synthesis.md` (R3). R3 post-dates the synthesis above;
since ADRs 0057–0067 are **not yet written**, R3 is integrated by *amending the planned ADR contents*
plus **one new ADR (0068)** — no supersession churn inside the unexecuted plan.

### 12.1 What R3 confirms (no plan change)

Identity one-liner and is/is-not lists (§1) · plain `.md` + frontmatter `type:` discriminator (ADR-0059) ·
SOL-as-notation with the two-surface model (ADR-0058; R3 §7.3 shows the same pair of forms) ·
lint-codes-as-checklists + soft AGENTS cap (ADR-0063) · minimal kit (ADR-0064) · review-by-exception as
the wedge (ADR-0060/0065) · external workspace default with co-located simplification allowed (ADR-0060)
· intake artifact + no connectors today (ADR-0061) · CLI verb set + defer list (future-cli.md) ·
"tools > focused skills > broad personas" (matches the persona folding in ADR-0064).

### 12.2 New decision — ADR-0068: Inventory & Change Plan (the transformation tier)

> **A Change Plan (`type: change-plan`) is a first-class artifact for structural transformations;
> an Inventory (`type: inventory`) is its brownfield prerequisite. Both are conditionally-core:
> required when the work is structural/brownfield, absent otherwise.**

- **Change Plan** — answers "how should the codebase change while preserving behavior" (vs the spec's
  "what behavior should exist"). Frontmatter: `type, id (CHANGE-*), title, status, kind, owner, sources
  (inventory/audit/spec), preserves ([SPEC-*#AC-*])`. Kinds (9): refactor, rewrite, migration,
  dependency-upgrade, performance, test-infra, mechanical-cleanup, architecture-cleanup, schema-change.
  Required sections: Intent / Why / Baseline / Target state / **Behavioral preservation guarantees**
  (table: ID · behavior · verification) / Non-goals / Affected surfaces / Risk areas / **Transformation
  waves** / Cutover conditions / Rollback criteria / Verification strategy / Review focus. Records the
  Hyrum's-Law rule: *a refactor that changes observable behavior is not a refactor* — design rationale in
  the ADR Context.
- **Inventory** — elevated from ADR-0064's advanced tier to conditionally-core (R1 O-011 + R3 §9 agree).
  Sections: Scope / Current modules / Current interfaces / Observed behavior (with evidence) / Known
  risks / Existing tests / Unknowns. `id: INV-*`. Inventory feeds Change Plan.
- **When-to-write thresholds** (the Rust-RFC "substantial change" lesson) recorded verbatim from R3
  §8.3/§9.3/§10.3 into docs 04/05 — including the *negative* lists (no spec for trivial renames; no
  inventory for single-file cleanups; no change plan for obvious bug fixes). This also operationalizes
  R1 R-003's risk-scaling rule at the artifact level.
- **Ripples:** `task.md` frontmatter `source:` becomes a **list** (spec and/or change plan) and Scope
  reads "Implement **or preserve**"; the review packet gains an optional **Change-plan coverage** table
  (same columns as requirement coverage) and preservation guarantees review like requirements; the
  workspace gains `inventory/` + `change-plans/` type folders (brownfield tier, ADR-0060 tree); checks.md
  gains change-plan checks (preserves-refs resolve; waves present for kind ∈ {migration, rewrite};
  ADR-0066).
- **Lineage (single-sourcing):** the *planning halves* of the nine per-kind implement guides — wave
  planning from `write-migration`, equivalence-oracle discipline from `write-refactor`, the delta table
  from `write-rewrite`, baseline/target protocol from `write-performance` — migrate into a new
  **`write-change-plan`** advanced guide + `docs/05`; their *execution halves* stay implement guidance
  (Increment 7). The old `preserves`/PRESERVES discipline survives as the `preserves:` frontmatter.
- Supersession wiring (corrected per verification B11): refines 0030 (artifact set); **partially
  supersedes the per-`task_kind` transformation-routing clauses of 0029 ("nine per-task_kind implement
  guides") and 0042 ("one skill per implementation task_kind")** at the user tier — kinds live on the
  change plan; the task stays one shape. (0036 carries no task_kind routing — it is persona×task-type
  routing, which 0036 itself eliminated; do not cite it.) Refinement of 0046 stated concretely: a
  change-plan wave decomposes into N tasks, each worktree-isolated per 0046 unchanged. Increment 1's
  forward-pointer pass: 0029, 0030, 0042, 0046 additionally cite 0068 (no count change — all four are
  already in the D9 set). **ADR-0068 also embeds the frozen change-plan + inventory template texts**
  (§5.7/§5.8 below), closing the format-freeze hole (verification B7).

### 12.3 Conflicts R3 introduces — calls (C-numbers continue the §0 ledger)

| # | Conflict | Call | Why |
|---|---|---|---|
| C1 | **R3 §15.4/§16.2 reintroduces `.swarm/` in code repos** (config.yaml + work/ + cache/ + tmp/) vs planned ADR-0062 "no `.swarm/`, ever" (reaffirming 0049) and R2's escape hatch | **Two-phase honesty.** Today (no CLI): code repo stays pristine — root `AGENTS.md` pointer + gitignored scratch; no `.swarm/` appears anywhere in adopter docs. The **future CLI's local state** is specified on `future-cli.md` only: a fully **gitignored** `.swarm/` (config.yaml, work/, cache/, tmp/) — machine state like `.git/`/`node_modules/`, never committed, never required by the markdown workflow. ADR-0062 retitled *"Code-repo adapter: pristine today; gitignored CLI state when the CLI exists."* R3's workspace-config YAML shape lands on future-cli.md as the `swarm init` contract | Reconciles R3's CLI pragmatism with the pristine-repo invariant: the ban was on committed framework litter, not on a tool's own gitignored state. **Flagged as owner decision Q8** since it softens an explicit "never" |
| C2 | **R3 §6.1 bans `.swarm.md` outright** vs ADR-0059's "optional convention meaning SOL-form" | **Tighten 0059:** no Swarm doc, template, example, or fixture uses the infix; `format: sol` is the *only* selector; the infix gets one historical/compat note in `structured-requirements.md`. The `*.swarm.ir.json`/`plan.json` names survive only as reserved future-CLI contract names (unchanged) | R3 and R1 O-012 §1 agree; the "optional convention" was a residue with no remaining function |
| C3 | **R3 §5.2 lists threat-model (and release-note) as advanced artifacts** vs planned ADR-0064 "threat-model deleted" | **Restore `threat-model.md` to `starter-kit/advanced/`** (the template already exists); add release-note as a *named type* in `artifact-formats.md` advanced table, no template | Deleting a working template R3 explicitly wants is churn in the wrong direction |
| C4 | **R3 §12.3 adds `needs-human` as a fifth review status** vs the plan's 4 results + Human-attention column | **Requirement-level results stay 4** (Pass/Fail/Unverified/Blocked — the column already carries per-row human attention); the **packet-level `status:` enum becomes `draft \| pass \| blocked \| needs-human`** | Keeps row semantics clean while honoring R3's packet-level signal |
| C5 | **R3's prominent refactor flow** vs ADR-0065's "exactly three examples" (R2 P2) | **Keep three.** `large-pr-review.md` becomes the **change-plan-driven refactor review**: inventory → change plan (waves + preservation guarantees) → 40-file agent PR → coverage **and change-plan coverage** tables → Block → re-run → merge + finding. Demo now exercises ADR-0068 end-to-end | One demo carrying both wedge and transformation tier beats a fourth example |
| C6 | **R3's 8-step full loop** (`Pull → Inventory → Spec → Change Plan → Task → Run → Review → Close`) vs the six-step loop | **Six-step loop stays the headline**; Inventory and Change Plan are the **two named conditional steps**, drawn as a rail: `Pull → (Inventory) → Spec → (Change Plan) → Task → Run → Review → Close`. `docs/02-basic-workflow.md` carries R3 §4.3's per-shape flows verbatim (feature/refactor/bug/rewrite/cleanup/spike). README keeps six + one line: *"structural or brownfield work adds two optional steps"* | R3 itself says "not every task needs every step"; the headline must stay learnable |
| C7 | **Kit grows** (+inventory, +change-plan templates; +write-change-plan guide) vs D10's 10-file copy surface | **Copy surface revised to 12 files** (8 templates + AGENTS.md + 3 guides); kit excl. `advanced/` ≤ 24; ADR-0064 amended | Two genuinely core templates are worth two files; the cap's job (no 47-file kit) still holds |
| C8 | **R3 §15.1/§20.1 puts AGENTS.md under `.agents/`** vs the root-AGENTS.md convention | **Reject** — AGENTS.md stays at repo root (the cross-tool agents.md convention reads root; symlink rule depends on it) | R3 detail conflicts with the standard it elsewhere endorses |

### 12.4 Amendments to planned ADRs (contents updated before they are written)

- **0057** + R3's thesis line (*"Coding agents increase code volume; Swarm reduces the coordination and
  review cost of that volume"*) in Context; the conditional-step rail; the product-category table →
  `docs/01`; the **illusion-of-work restraint** as a standing principle line ("fewer files, every file
  useful, review evidence over planning prose" — answers R3 §2.1).
- **0058** + `owner:` returns to spec frontmatter (R3 §8.4/§8.5 + Rust-RFC lesson; R2's template had
  dropped it); `sources:` may name ADRs, not just tickets.
- **0059** tightened per C2.
- **0060** + `inventory/`, `change-plans/` folders (brownfield tier); **both naming depths valid**
  (folder-per-artifact with `NNN-` prefix, or flat files — R3 §6.4); packet status enum per C4.
- **0062** revised per C1.
- **0063** + the **four-level Honesty Framework** (`convention | checklist | toolable | enforced`) as the
  *rule-level* taxonomy complementing the three *page-level* labels; the legend lives at the top of
  `docs/reference/checks.md`; every normative-sounding rule in reference/advanced docs tags one level;
  R3 §21.3's approved/avoided wordings adopted. Spec-check severity split (hard errors vs warnings, R3
  §8.5) pinned as the core-checks list C001–C0nn.
- **0064** per C3 + C7; advanced guides gain `write-change-plan` (seeded per §12.2 lineage).
- **0065** per C5.
- **0066** + change-plan/inventory checks; one change-plan fixture + one inventory fixture join the
  corpus (Increment 8); the spec checker's hard/warn split mirrors checks.md.
- **0067** unchanged.

### 12.5 Docs IA renumber (10 happy-path pages)

`01-what-is-swarm` (gains category table + thesis + restraint list) · `02-basic-workflow` (rail diagram +
per-shape flows) · `03-where-files-live` (workspace tree + brownfield tier; **no `.swarm/` mention**) ·
`04-writing-specs` (+ when-to-write/when-not thresholds + owner field) · **`05-brownfield-and-change-plans`
(NEW — inventory + change plan together: when, templates, Hyrum's-Law rule, spec-vs-change-plan table)** ·
`06-creating-tasks` (multi-source tasks) · `07-running-agents` · `08-reviewing-output` (+ change-plan
coverage; packet statuses per C4) · `09-saving-findings` · `10-integrations`. Increment 3b adds page 05;
3c renumbers accordingly. `future-cli.md` upgraded: per-command contract blocks (reads / writes / runs an
agent? / state change / next step — R3 §17.4+§18), the two CLI milestones + defer list (R3 §23), the
gitignored `.swarm/` local-state contract and `config.yaml` shape (C1).

### 12.6 Increment deltas

- **Increment 1:** now **12 ADRs (0057–0068)**; ledger row count gate = 68.
- **Increment 3b:** +`docs/05-brownfield-and-change-plans.md` (seeds: R3 §9–10 templates;
  `write-refactor`/`write-migration`/`write-rewrite` planning halves; `docs/artifacts/audit.md` boundary
  note "audit observes, inventory maps").
- **Increment 4:** demo re-scoped per C5.
- **Increment 5:** +`templates/{inventory,change-plan}.md` (core); `advanced/write-change-plan/SKILL.md`;
  threat-model restored to advanced; task/review templates updated per §12.2 ripples; kit gates use the
  C7 numbers.
- **Increment 7:** code-skills folding now routes planning halves → `write-change-plan` (per §12.2).
- **Increment 8:** +change-plan & inventory fixtures with EXPECTED files; checks.md C-list extended;
  honesty-level legend asserted present.
- **Increment 10:** swarm-cli roadmap aligned to R3's two CLI milestones (M1: init/pull/spec new/spec
  check/task new/review/status — no agent execution; M2: inventory new/change new/worktree create/run
  --agent/close); `spec check` severity split per ADR-0063.
- **Increment 11:** the §23 ten-question test gains an eleventh question: *"When do I need an inventory
  or a change plan?"* (answer expected from docs/02 + 05 in under a minute).
- **Effort roll-up revised:** ~15–17 working sessions (was 13–15).

### 12.7 Open questions — updated register

Q1–Q7 unchanged (Q3 default reaffirmed; Q4's trace-fold unaffected by change-plan coverage). New:
- **Q8 — gitignored `.swarm/` as future-CLI local state** (C1). Default: **accept** — spec it on
  future-cli.md only; adopter docs stay silent until the CLI ships. Decide in ADR-0062 (Increment 1).
- **Q9 — conditionally-core vs always-core for inventory/change-plan** (R3 §5.1 marks them core).
  Default: **conditionally-core** ("core when the work is brownfield/structural") — matches R3's own
  §5.4 scale-down rule. Decide in ADR-0068.
- **Q10 — honesty levels as visible badges vs prose tags.** Default: plain-text level tag in the rule
  line (no badge machinery). Decide in Increment 3d.

### 12.8 Acceptance-criteria additions

14. **Transformation tier present:** change-plan + inventory templates in the kit; `docs/05` exists;
    the demo exercises change-plan coverage; both fixture sets pinned; the spec-vs-change-plan division
    table appears exactly once (docs/05) and is linked elsewhere.
15. **Honesty framework:** the four-level legend exists at the top of `checks.md`; every MUST/required/
    blocking statement in reference+advanced tiers carries a level tag; grep for "enforced" finds only
    rules naming a shipped tool.
16. **R3 §25 flow test:** a newcomer can narrate "ticket → spec → (inventory) → (change plan) → task →
    run → review → finding" unprompted after reading README + docs/02 (checked in the Increment-11
    cold-read alongside the ten questions + Q11).

### 12.9 Risk additions

| # | Risk | Mitigation |
|---|---|---|
| 12 | **Change Plan duplicates the spec** (teams write both for everything, recreating ceremony) | The when-to-write thresholds + negative lists are part of ADR-0068 and docs/05; the division table makes the boundary one glance; templates cross-link rather than restate |
| 13 | **Conditional steps erode the simple headline** (six steps quietly become eight) | README never shows the eight-step rail; only docs/02 does, as "two optional steps"; gate: README banned-token grep extends to `Inventory →` and `Change Plan →` as loop steps |
| 14 | **`.swarm/` re-entry creeps from future-cli.md into adopter docs** | Banned-token grep adds `.swarm/` to the user-tier list (allowed only on future-cli.md); ADR-0062 wording is explicit that the dir is CLI-owned, gitignored, optional |

### 12.10 Plan-text errata (binding line edits to §§0–11, from the adversarial verification — apply before execution)

| # | Where | Edit |
|---|---|---|
| B1 | §3.0 propagation matrix · §9.11 | Columns = ADRs **0057–0068**; "13 surfaces × **12** ADRs" |
| B2 | §9.10 | "ADRs **0057–0068** merged … README lists **68** entries" |
| B3 | §11 patch 1 | Ledger gate = **68** rows (0001–0068 incl. vacant 0011/0012); ADR file count = **66** |
| B4 | §0 D10 · §3 Increment-5 gate · §6.1 · §9.6 | Copy surface = **12** files; kit excl. `advanced/` ≤ **24** (C7) — in all four places |
| B5 | §5.3 frozen review template | `status: {{draft \| pass \| blocked \| needs-human}}` (C4); add the optional **Change-plan coverage** table (same columns as Requirement coverage); Increment 8's `conformance.yaml` review schema names this packet enum |
| B6 | §5.2 frozen task template (+§2 0060 row) | Frontmatter `source: [SPEC-{{slug}}, CHANGE-{{slug}}?]` (list); `## Source` may name spec and/or change plan; Scope reads "Implement **or preserve**"; §5.1 spec template adds `owner:` (0058 amendment) |
| B7 | §5 | Add §5.7/§5.8 frozen template texts (below); ADR-0068 embeds them verbatim |
| B8 | §3 3b/3c · §4 · §6.2 · §9.1/9.2/9.4/9.8/9.13 · §10 Risk 7 · Increment 6 | Renumber to the 10-page map (§12.5): old 05→06 … 09→10; **grep scope becomes `docs/[0-9][0-9]-*.md`** (the old `0[1-9]` pattern would exempt `10-integrations.md` from every gate); §9.1 Q-mapping shifts one (Q5→06, Q6→07+10, Q7→08, Q8→09); §9.4 "04/07"→"04/08"; Risk 7 "docs/07"→"docs/08"; 3b creates `06-creating-tasks` (not 05) |
| B9 | §3 Increment 5 · §6.1 | Delete `inventory.md` from the `advanced/` template list (it is core per C7 — never ship two) |
| B10 | §6.1 · §7 | Add `threat-model.md` (C3) and `write-change-plan/SKILL.md` to the advanced tree; move threat-model from §7 CUT to KEPT-advanced; reword §7's 0062 line to C1's "pristine today; gitignored CLI state when the CLI exists" |
| B11 | §12.2 | Fixed in place above (0029/0042, not 0036) |
| A* | Advisories adopted | Plan header + §0 D2 + §2 header + §8 Q7: "11 ADRs" → "**12 (0057–0068)**", commit split 0057–0061 / 0062–0068, Q7 gains "never fold 0068"; effort line §3 → **15–17 sessions**; ADR-0062 Context grounds the C1 softening on **0050's gitignored-scratch clause** (0049's empirical bugs came from the mount/symlink structure, which a CLI-owned gitignored cache does not recreate); Increment 8's change-plan checks carry honesty-level tags like every rule; `task_kind` joins the §9.2 user-tier banned-token list; `reference/advanced-lifecycle.md`'s mapping table gains rows for the two conditional steps (Inventory → author[inventory], Change Plan → author[change-plan]); C1 fallback recorded: if Q8 is rejected, the original 0062 text stands and future-cli.md ships no local-state contract; §1's "Core artifacts (6)" line reads "6 core + 2 conditionally-core (inventory, change plan)" |

### 12.11 Coverage-gap resolutions (from the R3 coverage audit — all adopted)

| # | Gap | Resolution |
|---|---|---|
| G1 | **Review-by-exception trigger checklist (R3 §12.4) was pinned nowhere** — the wedge shipped as principle without its operational list | Pin the canonical trigger list — *unverified/failed requirements · out-of-scope changes · risky files · missing test output · changed public interfaces · DB migrations · security-sensitive changes · new finding candidates · blocked questions* — in three places, single-sourced from ADR-0060: `docs/08-reviewing-output.md` (the checklist), `templates/review.md` (as an `<!-- exception triggers: ... -->` comment block above Human attention), `checks.md` (review-packet check: "Human attention considered every trigger class or marked n/a") |
| G2 | Change-plan **`## Task split`** required section missing | Added to ADR-0068's section list + §5.7 + the Increment-5 template — it is the plan→tasks bridge feeding the multi-source task ripple |
| G3 | Finding schema thinner than R3 §13 | §5.4 template extended: `id: FINDING-{{slug}}`, `status: {{candidate \| accepted \| stale}}`, `related: [SPEC-*#AC-*]`, `## Does not apply when`, `## Future guidance` (ADR-0067 amendment; keeps R1-praised negative-scope discipline from the old finding contract) |
| G4 | Status workboard lacks the human-attention rollup | §5.5 gains an optional `## Human attention` section (blocking questions · tasks missing review packets · findings pending acceptance) |
| G5 | **Ledger** (R3 §4/§5.3/§18) neither adopted nor declined | **Demoted with a recorded call:** the ledger remains an advanced concept on `reference/memory.md` (it already lives in the promotion-protocol material being moved there); `swarm close`'s "optional ledger entry" appears on future-cli.md only; one decision line in ADR-0067 |
| G6 | CLI example flows + adapter names unpinned | future-cli.md gains R3 §19's four command sequences and the adapter list (claude, codex, opencode, aider, cursor) |
| G7 | Is-not list + do-not-promise list incomplete | README is/is-not extended with "a docs portal · a complete SDLC platform · a guarantee that agent output is correct"; the do-not-promise list (no deterministic generation, no automatic correctness, no formal verification, no PR-review obsolescence, no compilation from specs) lands as the closing lines of README's "What works today, what comes later" |
| G8 | Trivia | Adopted: `created:` on inventory/change-plan frontmatter; inventory `sources:` `code:`/`tests:` forms; task template trailing `## Findings` section; "bridge releases" named in the migration-kind guidance of `write-change-plan` |
| G9 | Preservation-guarantee verification semantics (consistency §5) | §5.0 item 4 extended: **preservation guarantees use the same one verification field** (`Verify with:` / `VERIFY BY`) and review consumes the same `{id, verify_ref, result}` triple; guarantee rows **reuse the spec's own ids** (`SPEC-*#AC-NNN` / `#C-NNN` / `#I-NNN`) via `preserves:` refs — a plan-local guarantee with no spec id gets `PG-NNN` and is itself a signal a spec amendment is owed. No third verification surface exists |

### 12.12 Frozen template texts for the two new core artifacts (embedded verbatim in ADR-0068)

#### §5.7 `templates/change-plan.md`
```markdown
---
type: change-plan
id: CHANGE-{{slug}}
title: {{title}}
status: draft
kind: {{refactor | rewrite | migration | dependency-upgrade | performance |
       test-infra | mechanical-cleanup | architecture-cleanup | schema-change}}
owner: {{team-or-person}}
sources: [{{INV-* / AUDIT-* / SPEC-* / FINDING-*}}]
preserves: [{{SPEC-*#AC-* / #C-* / #I-*}}]
created: {{YYYY-MM-DD}}
---

# Change Plan: {{title}}

## Intent
{{1–3 sentences: the transformation and its outcome}}

## Why this change is needed
{{the pressure: duplication, risk, upgrade, debt — cite the inventory/audit}}

## Baseline
- {{what the code does/looks like today, per the inventory}}

## Target state
- {{what it looks like after — including what explicitly stays unchanged}}

## Behavioral preservation guarantees
| ID | Behavior / constraint | Verify with |
|---|---|---|
| {{SPEC-*#AC-001}} | {{behavior that must not change}} | `{{test-or-check}}` |
<!-- A guarantee with no spec id gets PG-NNN — and usually means a spec
     amendment is owed. A changed observable behavior is not a refactor. -->

## Non-goals
- {{behavior/areas this plan must not touch}}

## Affected surfaces
| Surface | Intended change |
|---|---|
| `{{path}}` | {{one line}} |

## Risk areas
- {{where a reviewer should concentrate}}

## Transformation waves
1. {{each wave leaves the codebase green; name the wave's verify step}}

## Cutover conditions
- {{what must hold before the change is considered landed}}

## Rollback criteria
- {{observable conditions that trigger rollback}}

## Verification strategy
- [ ] `{{preservation suite / contract check / boundary check}}`

## Review focus
- {{the exception list a reviewer of this plan's tasks should start from}}

## Task split
| Task | Wave | Scope (guarantee/requirement ids) |
|---|---|---|
| TASK-{{slug}}-w1 | 1 | {{ids}} |
```

#### §5.8 `templates/inventory.md`
```markdown
---
type: inventory
id: INV-{{slug}}
title: {{area}} inventory
status: draft
owner: {{team-or-person}}
sources: [code:{{path}}, tests:{{path}}]
created: {{YYYY-MM-DD}}
---

# Inventory: {{area}}

<!-- Maps what exists. Observes, never judges (that is the audit) and never
     prescribes (that is the change plan). -->

## Scope
{{what this inventory covers / excludes}}

## Current modules
| Module | Responsibility | Notes |
|---|---|---|
| `{{path}}` | {{one line}} | {{quirks, duplication}} |

## Current interfaces
| Interface | Callers | Behavior |
|---|---|---|
| `{{fn/endpoint}}` | {{who calls it}} | {{observed contract}} |

## Observed behavior
| Behavior | Evidence |
|---|---|
| {{behavior to preserve}} | `{{test / file:line / output}}` |

## Known risks
- {{spread logic, duplication, inconsistent vocabulary, coverage holes}}

## Existing tests
- `{{test files covering this area}}`

## Unknowns
- {{Hyrum-risk: who may depend on shapes/values we cannot see from here}}
```

---

## 13. External-validation outcomes (from `.agents/plans/plan-validation-survey.md`, 2026-06-11)

The plan was validated against external evidence: eight web-research lanes (competitor working
products, DX feedback, review-bottleneck measurements, requirements research, brownfield/refactoring
research, official vendor guidance, workspace-topology practice, adversarial counter-evidence),
synthesized into a surveyor-stance survey with verdicts per decision. **Verdict roll-up: 4 SUPPORTED,
7 SUPPORTED-WITH-CAVEATS, 2 MIXED (D5 workspace topology, D7 pristine repos), 3 UNVERIFIED-open
(D6 intake, D10 examples, D14 findings/memory). Nothing CONTRADICTED outright.** The survey binds no
decision; this section records which of its advisory implications the plan adopts.

### 13.1 Adopted amendments (mapped to plan locations)

| # | Amendment | Where | Survey grounding |
|---|---|---|---|
| S1 | **D5 framing:** never present the external store as common practice (100% of surveyed competitors are in-repo); frame it as "a Git-native, agent-readable form of the external requirements store enterprises already run" (rust-lang/rfcs, kubernetes/enhancements, Oxide RFDs, DOORS/Jama lineage); promote **co-located mode to co-equal default** for single-repo teams; record V-021/V-024/V-025 counter-evidence in ADR-0060's Context | ADR-0060 (Increment 1), docs/03 | V-021–V-025, disagreement table 1 |
| S2 | **Spec-evolution + drift story (the one unmitigated structural gap, CE-2):** docs/04 gains a "Changing a spec after review feedback" section (amend, don't regenerate; the review packet's Unverified rows are the trigger); ADR-0060 Context records spec-kit #1191/#876/#1059 + Fiberplane Drift as motivating counter-sources; the workspace status board carries a `stale?` column; deeper drift detection stays a future-cli/`drift-and-staleness.md` concern, now cross-linked from docs/04 | docs/04 (3b), ADR-0060, §5.5 template | V-059, CE-2 |
| S3 | **D12 wording sweep:** the wedge claim is the narrow verified gap — "no tool ships a *persisted, independent, exception-routing* review packet" (OpenSpec verify is chat-only, BMAD persists into the story file, Tessl's is ephemeral self-review); position as **complementary to AI-reviewer bots** (requirement coverage + human-attention routing, never bug-detection competition) | README (Increment 2), ADR-0060 Context, docs/08 | V-046, V-049, disagreement table 3 |
| S4 | **Automation-bias countermeasure (CE-4, sharpest collision):** `templates/review.md` gains a mandatory reviewer instruction — *"Spot-check the evidence behind at least one green row before accepting the table"* — and docs/08 explains why (Thoughtworks complacency radar, vigilance-decrement research); recorded in ADR-0060 Context | §5.3 template (re-pin per B5), docs/08 | V-050, CE-4 |
| S5 | **Per-task artifact budget:** explicit defaults in docs and templates — review packet ≤ 1 page; spec ≤ ~100 lines; intake/status optional for trivial work; the skip-Spec path ("small cleanup: Task → Run → Review → Close") visible in README's loop section. Counter-sources recorded: Eberhardt's 2,577-line/3.5-h case, the "illusion of work" thread. The market reads "lightweight" as few *files per change*, not few commands | README, docs/02/04–06, ADR-0057 Context | V-001, V-008, CE-1 |
| S6 | **~100-line AGENTS.md figure labeled as Swarm's own convention** — vendor bounds are 500 lines (Cursor, Anthropic skills) and 32 KiB (Codex); IFScale is directional motivation only | ADR-0063 | V-032, V-033 |
| S7 | **ADR-0068 empirical rationale rewritten:** lead with "ad-hoc single refactorings are >3x riskier than planned composites (5.77% vs 1.75%, EASE 2025)" rather than the 2012 ~15% figure alone; rollback/cutover sections cite strangler-fig doctrine (Fowler/AWS/Azure) — not upgrade guides; **soften the slogan** "a refactor that changes observable behavior is not a refactor" to the enumerated-preserves-list form (Hyrum's Law makes zero-observable-change unsatisfiable); the artifact's defect-reduction benefit is labeled `convention` under the honesty framework (no direct study exists — V-057) | ADR-0068 (Increment 1), docs/05 | V-052, V-054, V-055, V-057 |
| S8 | **Throughput framing rule:** the claim is "generation outpaces validation" — never "AI slows teams"; METR 2025 may only be cited with its 2026 non-replication update attached; DORA 2025 found throughput *up* | README, principles, ADR-0057 Context | V-043, CE-5 |
| S9 | **D15 scope note:** worktrees presented as per-task isolation hygiene with vendor precedent (Claude Code `--worktree`, Cursor worktrees); note the practitioner ~3–5 parallel-stream ceiling and that isolation does not prevent cross-worktree conflicts; no high-fanout parallelism marketing | docs/06 (→ docs/07 after renumber) | V-060–V-062, CE-7 |
| S10 | **swarm-cli urgency:** OpenSpec ships `validate --strict` and Kiro ships spec analysis today — "checklists until a linter ships" has a **short credibility window**; ship the validator early (M1 before M2), add a visible maintenance signal (release cadence/CI badge); spec-kit's publicly-monitored zero-commit month recorded as the counter-source | Increment 10, ADR-0063 Context | V-038, V-039, V-042 |
| S11 | **D1 differentiation note:** "lightweight" language is already occupied by OpenSpec (54k stars, positioned verbatim against heavyweight SDD); README must answer "how is this different from AGENTS.md / OpenSpec?" in one visible line (the persisted review packet + evidence discipline is the honest answer) | README (Increment 2), docs/01 | V-002, V-005 |
| S12 | **Citation intake discipline:** before any survey citation enters `docs/research/sources.md` or an ADR, run the pending independent re-fetch (survey verification-status note); the Open-Question-10 figures are secondary-source only and banned until primaries are chased | Increment 1 onward | survey §Verification status |

### 13.2 New/updated open questions

- **Q11 — D5 default:** the evidence weighs toward **co-located as the co-equal (or primary) default**
  for single-repo teams, with the external workspace as the documented multi-repo/enterprise option
  carrying the RFC-repo lineage — not as "common practice." Recommended default: adopt S1's co-equal
  framing; dogfood one real external-topology adoption (survey OQ-5) before any stronger claim.
  Decide in ADR-0060 (Increment 1).
- **Q9 note:** D13's benefit is analogical, not measured (V-057) — ADR-0068 already labels it
  `convention`; no further action.
- **Validation studies to run post-pivot** (from survey OQ list, scheduled into Increment 11's audit as
  recommendations, not gates): review-packet usability test with seeded green rows (OQ-1); the
  10-minute newcomer test as a timed study (OQ-2); intake-artifact consultation tracking (OQ-3);
  lightweight-spec vs prompt-only comparison — *the single most load-bearing untested claim* (OQ-4);
  findings/ read-vs-write instrumentation (OQ-7).

### 13.3 Acceptance-criteria addition

17. **Survey-amendment compliance:** S1–S12 each verifiably landed (greppable: the D5 "common practice"
    ban, the spot-check instruction in `templates/review.md`, the artifact-budget defaults, the METR
    pairing rule, the "generation outpaces validation" framing); the Increment-11 audit re-checks the
    three UNVERIFIED-open decisions (D6, D10, D14) against dogfooding experience and records a
    keep/adjust call for each.

---

## 13. External-validation survey integration (2026-06-11)

**Input:** `.agents/plans/plan-validation-survey.md` — 62 findings (V-001..V-062) from eight web-evidence
lanes incl. a dedicated counter-evidence lane; every pattern claim ≥3 named instances; working-product
evidence only. **Verdict map:** no decision CONTRADICTED outright; D3/D4/D9 SUPPORTED; D1/D2/D8/D11/D12/
D13/D15 SUPPORTED-WITH-CAVEATS; D5/D7 MIXED; **D6/D10/D14 UNVERIFIED-open** (no external precedent either
way — Increment 11 records explicit keep/adjust calls for these three after the cold re-adoption test).

**Mixed-verdict resolutions:**
- **D5 (workspace):** every competitor keeps specs in-repo (V-021); external-store support exists at the
  RFC/requirements-repo granularity enterprises already run (V-023). Resolution: co-located mode promoted
  to **co-equal default** for single-repo teams; external store framed as "a Git-native form of the
  external requirements store enterprises already run," never as common practice; counter-evidence
  (in-repo norm; drift/discoverability failures V-024) recorded in ADR-0060's Context.
- **D7 (code-repo adapter):** gitignored CLI state has direct vendor precedent; the *nothing-committed*
  half contradicts the committed-dir norm (.github/, .vscode/) — kept anyway as a deliberate
  differentiator, with the norm recorded as counter-evidence in ADR-0062.

**Amendments S1–S11 (each lands in the named increment; provenance = the survey's advisory list):**

| # | Amendment | Lands in |
|---|---|---|
| S1 | D5 framing rules above | ADR-0060 (Incr 1) |
| S2 | Routine **spec-evolution story** (amend-after-review without regeneration; workspace↔code drift detection) — motivating counter-sources spec-kit #1191/#876/#1059, Fiberplane Drift | docs/04 + ADR-0060 (Incr 1, 3b) |
| S3 | D12 wording sweep: the verified gap is "no tool ships a persisted, independent, exception-routing review packet" — never "nobody reviews agent output"; complementary to AI-reviewer bots (coverage + attention, not bug detection) | README + ADR-0060 (Incr 2) |
| S4 | **Automation-bias countermeasure**: mandatory "spot-check one green row's evidence" instruction in the review template; V-050 sources in ADR Context — the plan's sharpest unmitigated collision | templates/review.md §5.3 (Incr 1, 5) |
| S5 | **Per-task artifact budget** visible in docs (review packet ≤1 page; spec ≤N lines; intake/status optional for trivial work; skip-Spec path in README's first example) | docs/04–06 + README (Incr 2, 3) |
| S6 | ~100-line AGENTS.md cap labeled **Swarm's own convention** (vendor bounds 500 lines/32 KiB + IFScale as directional motivation only) | ADR-0063 (Incr 1) |
| S7 | ADR-0068 empirical rationale rewritten: lead with "ad-hoc single refactorings >3× riskier than planned composites" (EASE 2025); strangler-fig sources for rollback/cutover; Hyrum line softened to the enumerated-preserves-list form; artifact benefit labeled "convention" | ADR-0068 (Incr 1) |
| S8 | Throughput framing rule: "**generation outpaces validation**," never "AI slows teams"; METR 2025 cited only with its 2026 non-replication update | README/PRINCIPLES (Incr 2) |
| S9 | D15 scope note: worktrees = per-task isolation hygiene (vendor precedent), ~3–5 parallel-stream practical ceiling stated, isolation ≠ cross-worktree conflict prevention | docs/06 (Incr 3b) |
| S10 | swarm-cli urgency: **ship the validator early** (OpenSpec/Kiro already ship validation — "checklists until a linter ships" has a short credibility window); visible maintenance signal (cadence/CI badge) | Incr 10 + ADR-0063 |
| S11 | Identity differentiation: "lightweight/minimal-ceremony" language is already occupied (OpenSpec, 54k★); README carries one explicit differentiation line (review packet + workspace + honesty framework) and a "how this differs from AGENTS.md" answer (V-002, V-005) | README (Incr 2) |

**Acceptance-criteria addition #17:** S1–S11 each verifiably present in their target artifact; D6/D10/D14
keep/adjust calls recorded in the Increment-11 audit.

---

## 14. Spec-first evidence resolution (2026-06-11)

**Input:** `.agents/plans/inputs/spec-first-evidence.md` (deep-research run `wf_b198d5ad-d46`; 14
quote-verified primary sources; 10/10 completed adversarial votes confirmed; fan-out rate-limit-truncated,
optionally resumable). **Verdict:** the central bet — short, human-curated, *conditional* specs — is
**evidence-consistent but workflow-level unproven**: the causal mechanism is established peer-reviewed
(ambiguity collapses agent correctness; text-level repair recovers it and transfers across models;
executable acceptance criteria are the strongest known input signal), every measured failure mode attaches
to configurations the plan already avoids (generated bloat, >~150-instruction density, blanket process on
trivial tasks), and no public A/B of our exact condition exists in either direction.

**Plan deltas (folded into existing increments):** claims discipline (component-level citations only; the
honest line: *the public record attacks generated spec bloat; short-curated-conditional is the
configuration that record leaves standing, and we are testing it*) → Incr 1/2; `Verify with:` framed as
the highest-value template line + "order requirements by importance" comment (IFScale primacy) → Incr
3b/5; skip-Spec path framed as evidence-required → Incr 3a; new sources.md entries (verified: SPECFIX,
CLARIFYGPT, HUMANEVALCOMM, SWEMUT; caveated: ASKORASSUME, REACODER) → Incr 1; the **pre-registered
matched-pair pilot** (10–15 pairs, medium tasks, spec-first vs prompt-only; first-pass gate, iterations,
human-minutes split, scope drift, 7-day defects, perception-before-measurement; decision rule + threats in
the evidence report) → Incr 11 kickoff. **Acceptance-criteria addition #18:** the pilot protocol is
pre-registered as a file in the swarm-cli backlog before Increment 11 closes.
