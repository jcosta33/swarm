---
type: audit
id: content-economy-audit
status: open-backlog
created: 2026-06-06
updated: 2026-06-06
scope: docs/ (canonical) + kernel-unique content (skills, AGENTS.md, conformance, memory, templates)
method: 13-agent read-only fan-out (12 area scanners across the corpus + 1 adversarial calibration pass)
---

# Audit — content economy (bloat, overstatement, overexplanation, jargon, verbosity)

> **Observation-only.** This audit records what *is* — where the framework's prose wastes reader
> attention — and recommends where to cut or tighten. It prescribes no inline edits and authors no
> obligations; the `## Recommended actions` section names candidate cuts for a future editing pass.
> Each finding carries a `file:line` and a verbatim quote so it is falsifiable; severity is by **blast
> radius** (how much attention the waste costs and how much it dents credibility), not discovery order.

## Scope

**In scope.** The shipped framework prose. `docs/language/` and `docs/passes/` were audited in their
**canonical `docs/` form** (a finding there applies to the derived kernel twin too, per ADR-0044);
kernel content with no `docs/` twin (the 34 `SKILL.md` guides, `kernel/AGENTS.md`, `conformance/`,
`memory/`, `templates/`) was audited directly. Five defect classes: **bloat** (content that doesn't
earn its place), **overstated** (claims stronger than warranted / superlatives / §0.7 overreach),
**overexplained** (one point belabored), **jargon** (neologisms adding no precision), **verbose**
(wordy prose a tighter sentence conveys).

**Out of scope.** `.agents/specs/swarm/` (frozen build source), `docs/_legacy/` (pruned), the user's
global config (`RTK.md`). No code (markdown-only repo).

**Calibration discipline.** This is a *specification* framework: normative precision is not waste. The
calibration pass **dropped** every finding that flagged a closed-set count recitation, a `MUST`/gate
predicate, a necessary scope qualifier, a frontmatter/section table, a lint-code citation, the
by-design SOL↔grammar EBNF overlap, the per-file NO-RUNTIME *opener* (fine once), the term-of-art
"load-bearing", or the Nygard ADR-immutability boilerplate. What remains is text cuttable with **zero
loss of normative meaning**.

## Bottom line

The corpus is **broadly lean, with one real systemic problem: duplication, not verbosity.** The
normative core — counts, `MUST`/`MUST NOT` rules, gate predicates, tables, citations — is tight and
earns its length almost everywhere; very little prose is individually bloated. What recurs is the *same
content stated again*. The three highest-value fixes: **(1)** collapse the in-body NO-RUNTIME
re-statements and the cross-file rationale/gate paragraphs to one canonical home + pointers; **(2)**
de-duplicate the implement-guide SOFT-banner / `SOL-O005` / verdict-decorator / forced-output blocks
and the ADR supersession triplication; **(3)** strip the "single most ___" / "master distinction"
superlative openers — the cheapest credibility win, costing nothing in precision.

## Observations — systemic patterns (the high-value findings)

These recurring habits, not the one-off nits, are where the line count and credibility leak. Ranked.

- **S-1 — NO-RUNTIME disclaimer restated in-body (MAJOR; the dominant habit).** The "Swarm ships no
  runtime; every parser/linter/checker is a contract a future tool builds against" caveat opens nearly
  every file *and is then restated 2–4× inside the same file*. Worst: `verify.md` (opener + §5 + §7 +
  §8), the three conformance `EXPECTED.md` footers (verbatim ~7-line block), `source-artifacts.md:5`
  (twice in one paragraph), `task-orchestration.md` (5/27/139). The opener earns its place once; every
  in-body repeat is cuttable with zero loss. **Largest single source of genuine waste in the corpus.**
- **S-2 — Cross-file rationale duplication (MAJOR).** The PLANCODER/HILBENCH/PLANSOLVE/SCOT "why this
  discipline" paragraph is restated near-verbatim across `lint.md:179`, `improve.md:139-141`,
  `lower.md:78`, `lower.md:91`. The CLARIFY-gate / COVERAGE-gate "aggregates existing codes / bijection
  over obligations" framing recurs verbatim across `lint`/`lower`/`decompose`. One canonical home +
  pointers removes ~3 copies each.
- **S-3 — Superlative openers / "single most ___" rankings (MAJOR class, many instances).** Unfalsifiable
  #1-rankings: "the single most important honesty constraint" (`verify.md:327`), "single most
  load-bearing rule" (`conformance.md:47`, `conformance.yaml:32`), "single most load-bearing fixture"
  (`golden-corpus.md:164`), "the master distinction of the architecture" (`ir-schema.md:9`,
  `lower.md:91`), "highest-leverage pass" (`lint.md:7`), "the most-run pass" (`implement.md:71`), "most
  severe defect" (`lint.md:82`). None is anchored to a closed set or evidence; each reads better stated
  functionally. **Cheapest credibility fix.**
- **S-4 — Supersession/recast triplication in ADRs (MAJOR; ~7 ADRs).** The same supersession appears as
  a Decision parenthetical + a Status prose bullet + an Affected `Supersedes:` bullet, all atop the
  `supersedes:` frontmatter. Concentrated in `0036`/`0040`/`0041` (0041 says "extend, don't edit" 5+×;
  0040 says "cosmetic rename" 4×). `adrs/README.md` then renders the whole ledger twice (lines 69, 83).
- **S-5 — In-file triple-restatement of one normative fact (MAJOR; structural in skills/artifacts).**
  Across the ~9 implement-pass `SKILL.md` guides, the SOFT-control banner + `SOL-O005` owned-paths para
  + verdict-decorator para + forced-output para each repeat 2–4× *within* each file (Preserves / Rule /
  Output-contract / Self-review) and near-verbatim *across* files; each `## Anti-patterns` section is a
  1:1 negative restatement of the Core rules (every row ends "(rule N)"). Same shape in artifacts: the
  "stance is held by discipline, not a gatekeeper tool" ~60-word paragraph is verbatim across
  `audit`/`bug-report`/`research`/`status`; `note`-has-no-surface-producer stated 3× in `errors.md`;
  the disjointness invariant stated 6× in `task-orchestration.md`.
- **S-6 — Cross-page tree/inventory re-derivation (MINOR but pervasive).** The sources/generated/memory
  placement tree is re-derived per-artifact to place one file; the closed-set guide inventory is
  enumerated three ways in `pass-guides.md` and again in `promote.md:21`; `review.md` fully re-derives
  the verdict model + merge-gate predicate that `verify.md` owns (~40 lines).
- **S-7 — Throat-clearing meta-narration about the doc's own honesty/style (MINOR).** "so this hub does
  not overstate" (`flow-graph.md:137`), "This document keeps the counts exact…" (`compiler-pipeline.md:7`),
  "This page is a map, not a manifesto" (`positioning.md:3`), "the reason the boundary is restated this
  sharply is…" (`overlays.md:90`). The doc narrating its own discipline adds no normative content.

## Observations — MAJOR findings

| # | file:line | class | quote / target | why it's waste | recommended cut |
|---|---|---|---|---|---|
| M-1 | `improve.md:139-141` (+ `lint.md:179`, `lower.md:78`, `lower.md:91`) | cross-file dup | the PLANCODER/HILBENCH/PLANSOLVE/SCOT rationale block | same 4-citation paragraph on four pass pages | one canonical home; siblings get a one-line pointer |
| M-2 | `review.md:23-70` vs `verify.md:21-111` | structural dup | full 7-value verdict model + tables + merge-gate predicate | `review.md` re-derives ~40 lines `verify.md` owns | point to `verify.md`; keep only review's per-value disposition table |
| M-3 | `verify.md:327` | overstated | "the single most important honesty constraint in Swarm" | unfalsifiable ranking | "This honesty constraint governs what a verdict is allowed to mean." |
| M-4 | `ir-schema.md:9` | overstated / §0.7 | "measurably outperforms free-form prose… the master distinction of the architecture" | "measurably outperforms" is an **uncited empirical claim** in a §0.7 repo; "master distinction" is marketing | drop both; state functionally (human authors surface, tool reasons over IR) |
| M-5 | `workspace.md:75-78` | bloat / over-justified | "The resumption record" section | two paras + four citations re-derive the externalise-state point the source/status/ledger split already made | compress to one sentence + a single `[[CTXENG]]` cite |
| M-6 | `versioning.md:50-57` | bloat | "§2.1 — Editions / MSRV analogues" (Rust/C# exposition) | a full section of ecosystem analogy with no normative rule | cut to the one-line analogy |
| M-7 | `NON-GOALS.md:25` (N4) | bloat / tangent | ~250-word cell with a batch-invariance digression | uncited inference-kernel tangent buries the normative content | cut the aside; state the two scope clauses plainly |
| M-8 | `audit.md:15` / `bug-report.md:17` / `research.md:17` / `status.md:20` | cross-file dup | "stance is held by discipline… MUST NOT ship a tool to police composition" | ~60-word para near-verbatim in four pages; only the `MUST NOT` is load-bearing | reduce each to one sentence |
| M-9 | `task-orchestration.md:101` (+106/146/152-160) | verbose / dup | branch-naming + isolation re-stated in a cell, a §, and a phases table | owned by `implement.md` + ADR-0046; the longest artifact (242 ln) re-derives it | replace with a pointer; collapse the repeats |
| M-10 | `pass-guides.md:60-64` | bloat | "### What ships in v0.1" prose re-enumeration | third presentation of the closed module set (after the mapping table + installed-guides table) | cut; fold the one normative point into the installed-guides section |
| M-11 | `heuristic-profiles.md:73-93` | bloat / dup table | "The full thirteen-stance set, mapped to passes" | duplicates the "Pass(es) it parameterizes" column of the stdlib-profiles table above | cut the table; keep the three clarifying sentences |
| M-12 | ~9 `write-*` implement guides | structural dup | SOFT-banner + `SOL-O005` + verdict-decorator + forced-output | each restated 2–4× within each file and across files | state each once + reference; **highest-value cut** (these are SOFT-activation guides where tightness aids the model) |
| M-13 | `write-migration:272-292` (+ performance/rewrite/refactor/fix) | bloat | `## Anti-patterns` rows each ending "(rule N)" | 1:1 negative restatement of the Core rules — a third copy | cut the section where every row maps to a numbered rule |
| M-14 | `write-performance:46-57` (+ migration/fix/refactor Stance blocks) | overexplained / dup | "Adopt the Performance-Surgeon stance…" | re-derives the persona `SKILL` the guide already activates by profile | compress to 2 sentences + "see `persona-performance-surgeon`" |
| M-15 | conformance `EXPECTED.md` footers (auth-refresh/checkout/payment-5xx) | bloat / verbatim dup | "## How this is validated (no runtime)" ~7-line block | identical across all three; each opener + `conformance.yaml` already say it | cut to one line per file |
| M-16 | ADR `0036`/`0040`/`0041` | bloat / triplication | supersession in Decision + Status prose + Affected bullet + frontmatter | stated 3–5× per ADR | state once in the Decision; cut the Status list + Affected `Supersedes:` bullet |
| M-17 | `ADR-0043:17` | overstated | "contradicted by the strongest, most recent measured evidence" | a parked ADR headlines with a superlative its own §0.7 section retracts | "contradicted by the measured evidence" |

## Observations — MINOR findings (representative; ~30 total)

A sample of the highest-value local tightenings; the full set follows the S-1…S-7 patterns.

| file:line | class | target | fix |
|---|---|---|---|
| `verify.md:5`/`:333`, `review.md:7`, `promote.md:7` | overexplained | in-body NO-RUNTIME repeats after the opener | keep opener; cut repeats |
| `implement.md:71` | overstated | "the most-run pass" | drop or soften to "typically high-volume" |
| `lint.md:7` / `pass-lint-spec:31` | overstated | "the highest-leverage pass" | "It catches defects before any work is committed." |
| `compiler-pipeline.md:13` | overstated | "at an extremely high and evidenced level of confidence" | cut "extremely high" ("proven, not asserted" already follows) |
| `golden-corpus.md:164`/`:197` | overstated | "single most load-bearing fixture" / "perfectly well-formed" | drop both |
| `SOL.md:18`/`:20`/`:88` | overexplained | 3rd/4th restatement of the §0 meta-vs-object fence | cut; bullets 15-16 already gave it |
| `errors.md:71`/`:82`/`:350` | bloat | `note` has no surface producer (stated 3×) | keep one |
| `APS.md:159`/`:169` | verbose | 5-sentence "no capability ceiling" block making one point four ways | keep the `MUST` + first three sentences |
| `review.md:124` | overexplained | the `[[TRUSTALIGN]]` clause on a non-proof sentence | loosely tied; tighten or drop the tail |
| `promote.md:21` | bloat | full pipeline-wide guide inventory in one cell | "Yes (ADR-0042)" |
| `positioning.md:5`/`:20-26` | bloat | three axes stated in prose, a table, and a numbered list | keep the numbered list; cut the prose restatements |
| `README.md:5`/`:89`/`:98` | overstated / dup | OpenAPI/Terraform/Smithy/K8s name-drop list; "self-standing" stated twice | one example; state once |
| `PRINCIPLES.md:99-103`/`:107`/`:110` | bloat / dup | slogan + gloss duplicating `README:15`; rationale+consequence say the same | keep the two definitional bullets; cut the rest |
| `write-research:33-39` / `write-rewrite:29-33` | jargon | "inquiry stance / inquiry hardening" (6×); "preserved non-delta" | define once, then use the plain phrasing |
| `flow-graph.md:137`, `compiler-pipeline.md:7`, `positioning.md:3`, `overlays.md:90` | meta-narration | doc narrating its own honesty/style | drop the meta-framing |

## Incidental correctness findings (surfaced, out of the economy scope)

Not waste, but flagged because the scan found them:

- **kernel/.agents/memory/glossary.md:1 vs :3** — self-labels as a "Tier-1 term store" on line 1 and a
  "Tier-2 … term store" on line 3; `INDEX.md` consistently calls it the **Tier-2** companion.
  Reconcile to Tier-2. *(Live kernel file — fixable.)*
- **ADR-0019:15/25/31** — internal count contradiction: "8 of the 13 mindsets ship" vs "7 ship". The
  canonical fact is 7 shipped at the time of that ADR (all 13 ship standalone post-ADR-0042). The ADR
  body is a historical decision record; **note only**, do not rewrite history.

## Risks

- **Credibility (the §0.7 ethos).** The "single most ___" / "master distinction" / "measurably
  outperforms" register is the same inflation §0.7 polices in *sources*, applied to *self-claims*. A
  reader who trusts the evidence discipline will read the superlatives as the thing the discipline warns
  against. Low blast radius per instance, but cumulative.
- **Drift between duplicated copies.** Every restated fact (S-1, S-2, S-5) is a future "fix one, miss the
  twin" — the exact defect class ADR-0044 was written to close, reappearing within `docs/` rather than
  across the docs↔kernel boundary. Duplication is a *maintenance* liability, not just a length one.
- **Over-correction.** The opposite failure: cutting a NO-RUNTIME *opener*, a count recitation, or a
  scope qualifier would remove load-bearing precision. Any cleanup pass must hold the calibration line
  this audit drew (see the dropped-false-positives discipline in `## Scope`).

## Recommended actions

In priority order (all are prose recommendations for a future editing pass; none authors an obligation):

1. **One NO-RUNTIME statement per file.** Keep the opener; delete in-body repeats. Start with `verify.md`,
   the three `EXPECTED.md` footers, `source-artifacts.md`, `task-orchestration.md`. *(S-1, M-15.)*
2. **Single-source the cross-file rationale + gate paragraphs.** Pick the canonical home (the rationale
   → `lint.md` or a model page; the verdict model/predicate → `verify.md`) and replace sibling copies
   with one-line pointers. *(S-2, S-6, M-1, M-2.)*
3. **De-duplicate the implement-guide blocks.** State the SOFT-banner / `SOL-O005` / verdict-decorator /
   forced-output once per guide; cut the `## Anti-patterns` sections that 1:1 mirror the Core rules.
   Highest line-count win and it sharpens activation. *(S-5, M-12, M-13, M-14.)*
4. **Strip the superlatives.** Mechanical pass over the S-3 list + `ADR-0043:17`; restate each
   functionally. Cheapest credibility win. *(S-3, M-3, M-17.)*
5. **Collapse the ADR supersession triplication** (state once in the Decision) and the double-rendered
   README ledger. *(S-4, M-16.)*
6. **Cut the standalone tangents/sections that carry no rule:** `versioning.md` §2.1, `NON-GOALS.md` N4
   aside, `workspace.md` resumption over-justification, the duplicate `heuristic-profiles.md` and
   `pass-guides.md` inventory tables. *(M-5…M-11.)*
7. **Fix the two incidental correctness items** (glossary Tier-1→Tier-2; note the ADR-0019 count).

## How this was produced (no runtime)

Read-only: 12 area scanners swept the corpus against the five defect classes (each finding required a
verbatim quote + a concrete tighter rewrite, to keep it falsifiable), then one adversarial calibration
pass deduplicated, ranked, and dropped false-positives (precision mislabeled as waste). No file was
edited. The verdicts are validated by hand; nothing here ran a checker.
