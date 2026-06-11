---
type: research
id: spec-first-evidence
status: draft
date: 2026-06-11
question: >
  Does a SHORT, HUMAN-CURATED spec (≤1–2 pages: requirement IDs, acceptance criteria,
  verification notes, non-goals) before agent implementation measurably improve outcomes
  vs direct/iterative prompting?
provenance: >
  Deep-research workflow wf_b198d5ad-d46 (5 search angles → 14 primary-source claim
  extractions → adversarial verification votes). The verification fan-out was cut short by
  a session rate limit after 10 votes; all 10 completed votes returned refuted:false at
  high confidence (ClarifyGPT ×4, SpecFix ×4, HumanEvalComm ×2). Synthesis performed by
  the orchestrating agent from the banked, quote-verified extractions. Remaining items
  carry their per-source verification notes inline.
---

# Evidence verdict: short human-curated specs vs direct prompting

## TL;DR verdict

1. **The mechanism is established (HIGH confidence, peer-reviewed).** Ambiguous or
   incomplete task input measurably degrades agent code correctness; models do not
   self-clarify; restoring clarity **in the text itself** recovers the loss and transfers
   across models. Explicit acceptance criteria — especially executable verification
   references — are the single strongest task-input signal known.
2. **Everything the public record attacks is what the plan already avoids (HIGH).** The
   measured failures attach to heavy tool-generated pipelines, instruction counts beyond
   ~150, context bloat, and indiscriminate process on already-clear tasks — not to short
   curated specs, which sit inside the measured near-ceiling adherence regime.
3. **The end-to-end cell is genuinely empty (confirmed).** No controlled A/B of short
   human-curated specs vs prompting on real repo work exists in either direction.
   Component evidence licenses the bet; only an internal experiment can license a
   stronger claim.

## Bucket 1 — direct workflow-level evidence: NONE for our condition

- The two rigorous public head-to-heads test **heavy tool-generated pipelines only**:
  - Eberhardt/Scott Logic (2025-11-26): Spec Kit = 33.5 min agent + ~3.5 h review +
    2,577 lines of generated markdown vs ~8 min + ~24 min iterative — "around ten times
    faster" without SDD. **Explicitly scoped**: "not viable… at least not in its purest
    form, as exemplified by Spec Kit"; the task-size boundary is acknowledged as unknown.
    n=1, ~1k-LOC hobby app. (blog.scottlogic.com)
  - Böckeler/martinfowler.com (2025-10-15): Kiro turned a small bug into 4 user stories
    + 16 acceptance criteria ("sledgehammer to crack a nut"); spec-kit markdown "overkill"
    for a 3–5-point feature; **agents frequently did not follow the elaborate spec
    structures**.
- METR RCT (arXiv 2507.09089) compares AI-allowed vs not — not spec vs prompt — but is
  the methodological template (matched real issues, randomization, perceived-vs-measured
  gap: devs 19% slower while believing 20% faster).
- Two 2026 benchmarks may partially operationalize the axis (upfront vs emergent specs:
  arXiv 2603.17104; iterative spec evolution: SlopCodeBench 2603.24755) — **UNVERIFIED
  beyond title/abstract; full-text check before citing.**

## Bucket 2 — component evidence: STRONG, VERIFIED

| Finding | Source (verified) | Numbers |
|---|---|---|
| Injected ambiguity/incompleteness collapses correctness; >60% of model responses code anyway instead of asking | HumanEvalComm, ACM TOSEM (arXiv 2406.00215) — ✓ 2 adversarial votes | Pass@1 −35–52%; ChatGPT 65.58→33.77 (ambiguity), →27.95 (incompleteness) |
| Clarifying the requirement, then regenerating, recovers it | ClarifyGPT, FSE 2024 (arXiv 2310.10996, DOI 10.1145/3660810) — ✓ 4 votes | GPT-4 70.96→80.80 (human eval); 68.02→75.75 avg (simulated) |
| Repairing the requirement TEXT alone (no interaction) helps, and the repaired text transfers across models | SpecFix, ASE 2025 (arXiv 2505.07270) — ✓ 4 votes | +30.9% Pass@1 on the modified 43.58% subset; +4.09% absolute; +10.48% cross-model — *a clarified spec is a durable, reusable artifact* |
| At repo scale: specification completeness alone is worth ~16 pts | Ask-or-Assume (arXiv 2603.26233, 2026 preprint — id flagged for re-check) | SWE-bench Verified: full issue 70.80% vs underspecified 54.80%; calibrated clarification recovers to 69.40% |
| Realistic short chat queries vs formal issue text: >50% drop | Benchmark Mutation (arXiv 2510.08996) — id ✓ | public benchmarks overestimate by >50% vs realistic prompting |
| 38.3% of real GitHub issues are underspecified; filtering them doubles measured success | SWE-bench Verified (OpenAI, 2024-08) | 16% → 33.2% (conflates with test fixes; upper bound) |
| Explicit executable acceptance criteria are the strongest single input signal; with ideal input, ≥97% success — "the information content of the task input, not model capability, is the binding constraint" | ORACLE-SWE (arXiv 2604.07789) — id ✓ | Reproduction Test ≫ Execution Context ≈ API Usage ≫ Edit Location ≫ Regression Test |
| Curated verification artifacts as input lift resolution | TestPrune, FSE 2026 (arXiv 2510.18270) — id ✓ | +8.0–12.9% relative; full uncurated suites HURT (curation is necessary) |
| An explicit spec as intermediate artifact lifts agent efficacy even when machine-inferred | SpecRover, ICSE 2025 (arXiv 2408.02232) — id ✓ | >50% efficacy over AutoCodeRover, full SWE-bench |
| Requirement alignment before generation beats all baselines | REA-Coder (arXiv 2604.16198, 2026 preprint) | +7.9–30.3% across 4 models / 5 benchmarks; both QA-alignment (+5.82%) and check-back (+9.99%) contribute; costs more tokens than zero-shot |

## Bucket 3 — counter-evidence: BOUNDS the bet, does not refute it

- **AGENTS.md context files reduce success +20% cost** (arXiv 2602.11988, ETH — id ✓):
  but agents *comply*; the harm is unnecessary standing requirements; authors' own
  prescription = "human-written files describe only minimal requirements." Tests
  **persistent repo config, not per-task specs**. Efficiency counter exists (arXiv
  2601.20404 — id ✓): −28.6% runtime, −16.6% tokens with AGENTS.md (no correctness
  measure). Net: keep AGENTS.md minimal (the plan's soft ~100-line guidance), distinct
  from the per-task spec.
- **IFScale (arXiv 2507.11538 — id ✓):** near-perfect adherence through ~100–150
  simultaneous instructions; beyond that, failures are **silent omissions** with primacy
  bias. A 1–2-page spec with tens of requirements sits in the near-ceiling regime;
  ordering matters (critical requirements first).
- **Context Rot (Chroma, vendor research):** focused prompts beat full prompts across 18
  models — the dose makes the poison; indicts bloat, not brevity.
- **Indiscriminate process hurts (the conditionality evidence):** HumanEvalComm's
  clarification-forcing agent scored 27.45% vs 65.58% on already-clear tasks; Ask-or-
  Assume's always-clarify baseline was the *worst* condition (47.20%, below no-
  clarification). **Blanket spec/clarification on clear, trivial tasks measurably
  hurts** — this directly validates the plan's when-to-write thresholds and the
  skip-Spec path for small tasks.

## Bucket 4 — boundary

- Spec detail should scale with task complexity (Osmani 2026-01, experience-based; GitHub
  2,500-file analysis quoted there: dominant agent-file failure is **vagueness**, not
  over-specification — under-spec is the common real-world defect).
- Calibrated systems conserve questions on simple tasks, spend on complex ones
  (Ask-or-Assume); agents do better on simpler codebases → decompose (SANER 2025,
  arXiv 2410.12468 — id ✓, figures need full-text check).
- Spec↔code sync cost grows with structural complexity (Breunig 2026-03; honest about
  toy-scale limits).

## What this changes in the repositioning plan

1. **Keep the bet, keep it conditional.** Spec-first stays the default for non-trivial
   work; the when-to-write/when-NOT-to-write thresholds are not a convenience — they are
   what the evidence demands (indiscriminate process measurably hurts).
2. **Verification notes are the highest-value line in the template.** ORACLE-SWE +
   TestPrune justify making `Verify with:` effectively mandatory per requirement and
   preferring executable refs; say so in docs/04.
3. **Claims discipline for README/docs:** cite only component-level evidence
   ("ambiguous input measurably degrades agent output; clear acceptance criteria are the
   strongest known input signal") — never "specs make agents reliable." The honest line:
   *the public record attacks generated spec bloat; Swarm's bet — short, curated,
   conditional — is the configuration that record leaves standing, and we are testing it.*
4. **Order requirements by importance in templates** (IFScale primacy bias) — one
   template comment.
5. **Run the internal experiment** (below); record this report's sources into
   `docs/research/sources.md` during Increment 1 (new verified entries: SPECFIX,
   CLARIFYGPT, HUMANEVALCOMM, SWEMUT; caveated: ASKORASSUME, REACODER; ORACLESWE,
   AGENTSMD-HARM, METR already present).

## The internal experiment (Increment 11 kickoff; pilot, decision-informing)

- **Setting:** swarm-cli backlog (real repo, real tasks); optional second site: promptly.
- **Design:** pre-registered matched pairs (10–15 pairs, ~30–60-min medium-complexity
  tasks — the contested boundary zone). Within each pair, randomize: (A) direct
  prompting — hand the ticket text + ad-hoc chat; (B) spec-first — author the kit's
  1–2-page spec template (authoring time hard-capped at 15 min), hand only the spec.
  Same model, same CLI, same worktree discipline, same human.
- **Metrics per task:** first-pass gate result (review packet passes without a follow-up
  task) · follow-up iterations · human minutes split (authoring / prompting / review) ·
  out-of-scope diff hunks · defects surfaced within 7 days · predicted-better condition
  recorded BEFORE outcomes (METR perception check).
- **Decision rule:** spec-first must win on (review minutes + scope drift) or first-pass
  rate without losing on total human minutes for medium tasks; otherwise demote Spec from
  default-for-non-trivial to recommended-optional and reword docs/02.
- **Threats (recorded, not hidden):** n too small for significance — report directions +
  raw table, treat as pilot; same-human/no-blinding; task-matching subjectivity (pairs
  pre-registered before condition assignment); learning effects (alternate order);
  authoring time counted in total cost.

## Residual to close when the rate-limit window clears (optional)

Resume run `wf_b198d5ad-d46` (cached: all search + extraction + 10 votes) to finish the
remaining adversarial votes + formal synthesis; re-check ids 2603.26233, 2603.17104,
2603.24755 and the SANER-2025 issue-quality figures at full text.
