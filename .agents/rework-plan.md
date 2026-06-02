# Swarm repo rework — implementation plan (spec → repo)

**Status:** proposed (awaiting go-ahead + the §"Decisions to confirm" answers)
**Source of truth:** `.agents/specs/swarm/` (the finished v0.1 kernel spec — 3 adversarial review passes + remediation; converged). This plan executes that spec's own §34 migration.
**Goal:** revamp *this* repo so `docs/`, `kernel/`, and the root conform to the kernel spec. Markdown-only, **NO RUNTIME** (everything that "runs" is a contract a future tool builds against — §35.1 N1); we produce only Markdown, templates, fixtures, and inert data.

---

## 1. The gap (current → target)

| Area | Current (pre-pivot "buffet") | Target (kernel spec, §20.0) |
|---|---|---|
| `docs/` | 125 files: `tasks/ personas/ guides/ concepts/ adrs/ skills/ documents/ reference/` — the old skills+personas+task-types model | `docs/language/` (SOL, APS, errors, versioning), `docs/model/` (compiler-pipeline, source-artifacts, source-authority, conformance), `docs/artifacts/` (one page per artifact contract), `docs/passes/` (9 pass pages), `docs/library/` (pass-guides, heuristic-profiles, overlays), `docs/reference/` (glossary, proof-types, promotion-protocol, distillation-loss-budget, flow-graph), `docs/examples/` (3 pipeline-complete walkthroughs) |
| `kernel/.agents/` | 24 legacy skills (`persona-*`, `write-*`, `adversarial-review`, `empirical-proof`, `distillation-discipline`, `fix-flaky-test`); templates incl. `spec.md`, `task-base.md`, `task-orchestration.md`, `skill.md`; `docs/agents/01-05`; `conformance/` (stub) | `language/` (ref copies), `templates/` (`spec.swarm.md`, `task.md`, `trace.md`, `review.md`, `finding.md`, `adr.md`, `audit.md`, `research.md`, `bug-report.md`, `prd.md`, `rfc.md`, `memory/INDEX.md`), `passes/` (9 pass contract pages), `skills/` (9 `pass-*` guides + companion fragments), `profiles/` (6: builder/skeptic/architect/researcher/reviewer/janitor), `overlays/`, `memory/`, `conformance/` (manifest + golden corpus) |
| `kernel/AGENTS.md` | behavior-manual style | short **bootloader** ≤200 lines / ≤25 KB (§31.1), no inlined SOL/APS manual (AW4) |
| root `README.md` | pre-pivot framing | kernel framing (spec-as-source-code, no "CLI required" / "tests passed", §26) |
| workspace model | implicit | docs that establish `.swarm/` as the canonical adopted-project workspace, `.agents/` as compatibility surface, the surface-policy set, source/status/generated split, ledger, CLI/agent boundary (AW1–AW9) |
| ADR ledger | pre-pivot ADRs (0001–0026, 0011/0012 vacant) | + kernel ADRs 0027+ (SOL, APS, 9-pass, artifact set, source-authority, memory, golden corpus, lint namespace, 7-value verdict) (A17–A18) |

**Not in scope (§35.1):** no shipped CLI/parser/linter/checker/scheduler; no enforcement claim; provider-neutral; no live multi-agent orchestration. The conformance manifest + corpus are **inert data**, not a running checker.

---

## 2. The seven waves (normative order, §34.0)

Each wave is gated on the prior (a later wave reads what an earlier one froze), and must pass the **subset of the acceptance gate its outputs touch** before the next begins. I'll run a **mechanical conformance harness** (the A-/AW-checks expressed as greps + file-existence + count-reconciliation scripts — most are already automatable from the verification I've been running) between waves, and commit per wave.

| Wave | Goal | This-repo work | Acceptance subset |
|---|---|---|---|
| **W1 — Freeze the canonical kernel docs** | Pin language/artifacts/passes/reference so every later wave reads a stable target | Author `docs/language/{SOL,APS,errors,versioning}.md`, `docs/model/{compiler-pipeline,source-artifacts,source-authority,conformance}.md`, `docs/passes/` (9), `docs/reference/{glossary,proof-types,promotion-protocol,distillation-loss-budget,flow-graph}.md` — **distilled from the kernel spec** (the spec is the long form; these are the reference-doc projections). Delete/retire the old `docs/concepts,guides,skills,personas,tasks,documents` once content is migrated. | A5 (lint catalogue), A10–A16 (count reconciliation), A2 (one lint namespace / verdict set / VERIFY BY / casing) |
| **W2 — Install the payload** | Lay down the copyable kernel under `kernel/.agents/` | Build `kernel/.agents/{language,templates,passes,skills,profiles,overlays,memory,conformance}/` + the `AGENTS.md` bootloader + `.swarm-version`. Templates: the 11 core/source templates (incl. `spec.swarm.md`, `memory/INDEX.md`); **no `verdict.md`**. | A3 (7 core templates), A4 (no verdict.md), A6 (manifest) |
| **W3 — Reframe top-level docs** | Recast repo front matter onto the kernel | Rewrite root `README.md`, a `docs/PRINCIPLES.md` (the §2 invariants), a non-goals doc (§35) in kernel vocabulary; AGENTS bootloader framing | A28 (no "CLI required"/"tests passed"), AW4/AW8/AW9 (bootloader + CLI/agent boundary + no-runtime framing) |
| **W4 — Recast legacy skills & personas** | Map legacy subsystems onto the kernel without letting them own semantics | 24 skills → 9 `pass-*` guides + 2 cross-cutting fragments (§26.2 table); 13 personas → 6 heuristic profiles (§27); move all procedure out of `AGENTS.md` into lazily-loaded guides; overlays mapping | A17–A18 (ADR ledger + new ADRs), AW3 (compatibility surface), the §26/§27 mappings |
| **W5 — Migrate live sources** | Convert the repo's own working material to the kernel artifact set | Convert any live spec to `*.swarm.md` (bare-header SOL); detach research into `research.md` source artifacts; add `review.md` with VERDICT blocks. (For this framework-dev repo, the main "live source" is the kernel spec itself + this plan + the audits.) | A1 (reconciled decisions applied), AW1/AW2/AW5/AW6/AW7 (workspace model docs) |
| **W6 — Examples & evals (the conformance evidence)** | Ship the corpus | `kernel/.agents/conformance/fixtures/` golden corpus (§33: auth-refresh +/–, checkout, payment-5xx, the SOL-S negatives, research-fanout, task-file classes, the labeled SOL-P prose corpus); `docs/examples/` 3 pipeline-complete walkthroughs; review/profile rubrics. **Appendix D is the seed for auth-refresh.** | A7 (corpus), A8 (3 positives), A9 (labeled prose corpus + targets) |
| **W7 — Remove deprecated aliases** | Drive the surviving-construct count to zero | Sweep every shipped file for retired constructs | A19–A28 (each grep returns nothing): `SHALL`, `ALWAYS/NEVER` in invariants, `:::`-fenced SOL, `VERIFY_BY`, `APS-`, `POLICY/INV`, `locks`, `verdict.md`, `kickback`, CLI/tests-passed framing |

**Final gate (after W7):** all of A1–A28 + AW1–AW9 pass at the **target tier** (see Decisions).

---

## 3. Execution model

- **Per-wave agent armies** (the approach that worked cleanly for the nit-sweep and lean-fix: one agent per file/artifact, each confined to its own output, fed the relevant spec sections + a strict "produce-only-markdown / no-runtime / cite-or-design-rationale" brief — i.e. Appendix G scoped per output). Fan-out per wave, I review the combined diff + run the harness centrally, commit.
- **Mechanical conformance harness:** I'll script the A-/AW-checks (greps for retired constructs, file-existence for templates/corpus, count-reconciliation across docs, citation/fence/JSON validators) — reusing the verification I've built. It runs after every wave and is the gate.
- **Dogfooding option:** the rework can itself be Swarm's first real spec — author `swarm-rework.swarm.md` (obligations = "docs/language/ exists and reconciles counts", etc.), lower it into per-wave tasks, and record traces/verdicts. This both executes and validates the kernel. Recommended for W5+ once the templates exist; W1–W2 bootstrap by hand from the spec.
- **Git:** commit per wave on `main` (works-from-main); each commit message names the wave + the A-checks it satisfies.

---

## 4. Risks & how the plan handles them

- **Volume (125 docs + 63 kernel files reworked):** mitigated by per-wave armies + the gating order; old `docs/` content is *migrated then retired*, not edited in place.
- **Semantic drift from the spec:** every authored doc is a *projection/distillation* of the spec (the spec stays the long-form source of truth); the harness's count-reconciliation (A10–A16) + zero-retired-construct greps (A19–A28) catch drift mechanically.
- **The corpus is the hardest artifact (W6):** the golden corpus *is* the conformance oracle; Appendix D (auth-refresh) and the §33 fixtures are the seed, but checkout/payment-5xx/research-fanout/the labeled prose set are net-new authoring. Budget the most time here.
- **Distillation loss (spec → reference docs):** each W1 reference doc carries a `Preserved / Dropped / Still-uncertain` note (§21/§24) so the projection is auditable.
- **Session-limit fragility:** waves are independently committable; the harness is deterministic (no agent budget). If a wave's army is clipped, its per-output transcripts are recoverable (as we've done).

---

## 5. Decisions (confirmed)

1. **Target tier: 4 — Swarm-verifiable** (the reserved "Swarm-conformant" line; spec → obligations → task → trace → review → verdict with pasted evidence). The acceptance gate applies to the A-/AW-checks that tiers 1–4 bind; tier-5 (§18/§19 live-coordination) checks are out of scope for v0.1.
2. **Old `docs/` → archived to `docs/_legacy/`** (kept out of the shipped/canonical set so A28 still passes; preserves history + a diff reference during migration).
3. **Hand-author W1–W4, dogfood from W5** (W1–W2 bootstrap by hand since the templates/payload don't exist yet; from W5 author the rework as a real `*.swarm.md` spec and run it through `lower → implement → verify → review`).
4. **Rename `kernel/` → `kernel/` now** (pulled forward from the v0.2 deferral). Executed in **W2** (the payload wave): `git mv kernel kernel`, update the ~35 `kernel/` path refs + the "kernel" payload-noun across the spec (§20, §34, Appendix G) to `kernel/`, and record a **new ADR** ("v0.1 ships the payload under `kernel/`; supersedes the §34.0-wave-2 deferral"). The payload still installs 1:1 to a consuming repo's `.swarm/kernel/`. W1 is unaffected (it touches only `docs/`).

**Execution begins at W1.** Sequence: archive `docs/` → `docs/_legacy/`, then author the canonical `docs/language | model | passes | reference` as projections of the spec (each with a distillation-loss note), then run the conformance harness (A5, A10–A16, A2) and commit.
