---
type: audit
id: dx-dogfooding-swarm-cli
status: living
created: 2026-06-08
updated: 2026-06-08
title: DX of using Swarm to build swarm-cli (dogfooding findings)
---

# Audit: the DX of using Swarm to build the swarm-cli toolchain

> **Stance: observation-only, living.** Findings from *using the Swarm framework by hand* to build its
> dogfooding adopter, `swarm-cli` (the TS toolchain that will one day automate Swarm). Recorded as the work
> happened — kit re-sync, ADR propagation, parser increments, the command-garden audit + collapse, a bug
> fix, and (in progress) `swarm lint`. It records experience + risk; it authors no obligations. Some gaps
> below are **already fixed** (noted inline). Appended to as dogfooding continues.

## §1 What worked — the framework earned its keep here

- **Adversarial self-review (ADR-0056) caught real defects, repeatedly.** It is the single highest-value
  discipline in practice. Concrete catches this session: a count error (45 → 52 non-canonical commands); a
  **circular** parser proof (the source-map test recomputed the hash over the parser's *own* reported span,
  so a wrong `line_end` still matched); the ADR ledger row inserted out of order; and — biggest — a
  pre-commit dangling-dependency catch (`new`/`open` → `launch-agent`) that would have broken the build.
  Mandating it (ADR-0056) was the right call; dogfooding confirms it.
- **The artifact-home model (ADR-0052) is legible.** `specs/<feature>/` (spec + co-located audit/research),
  `decisions/` (ADRs), `.agents/memory/findings/` — every artifact had an obvious home; the audit→spec
  promotion (command-surface audit → spec 005) was clean.
- **The audit → spec → (decompose) → implement flow** matched real work: the skeptic review became an
  observation-only `audit.md`, which authored the collapse obligations in a spec, which drove the cut.
- **`VERIFY BY` → test mapping is frictionless.** Each binding's `#anchor` became a test name 1:1; the
  obligation set gave an unambiguous test list.
- **dependency-cruiser as the boundary gate** (in the adopter) is the one *enforced* check, and it paid off:
  it caught the `new`/`open` → `launch-agent` coupling before a cut, and confirmed `Sol`'s `core-isolation`.

## §2 Friction — DX pain points

- **F1 — Bootstrapping circularity.** The tool that lints/parses specs (`swarm lint`, the SOL parser) is
  itself the spec being built. So every spec had to be lint-ed **by hand** against the 5 layers, because the
  linter does not exist yet. The toolchain that would enforce Swarm is built *using Swarm by hand*.
- **F2 — Worktrees live inside the repo.** `.worktrees/` under the repo root means `vitest run <path>`
  path-matches the worktree's copy too and **double-runs** (saw 34 tests reported for a 17-test run); and a
  fresh git worktree has **no `node_modules`**, so the bound proofs can't run until you symlink it. The
  isolation rule (worktree+branch) says nothing about dependency availability or worktree placement.
- **F3 — The merge gate / verify is entirely manual (Invariant 1, NO RUNTIME).** Every "green" was me
  running `typecheck` + `deps:validate` + `vitest` by hand and reading the output; nothing enforces the
  gate. Workable, but the discipline lives entirely in the operator. rtk-style output filtering also
  *masked* the real test result once (condensed to "PASS (461)"), and I had to read the raw JSON report to
  see `numFailedTests` — a reminder that "summary-only proof" is exactly what the skeptic rejects.
- **F4 — Renaming a spec cascades by hand.** `swarm-core-parser` → `sol-parser` meant a folder rename + id +
  every cross-reference, all manual. No tool keeps spec ids ↔ folders ↔ refs consistent.
- **F5 — `content_hash` is genuinely undefined (spec 002 Q-001).** The framework does not pin whether it is
  the raw span, normalized text, or the lowered node — which matters for staleness stability. I had to pick
  (raw span) without guidance.

## §3 Framework gaps the dogfooding surfaced

- **G1 — Specs can smuggle an architecture decision with no ADR gating it.** spec 001 / `AGENTS.md` encoded
  a **pnpm monorepo `packages/{core,cli,…}`** and a "swarm-core" package as if decided — they never were.
  Following the specs "to a T" propagated that premature structure (duplicated `Result`, an unspecced
  "bootstrap", build-config churn) until the operator questioned it, and it was reversed (ADR-0001:
  one tool, `/src`). **The framework has no notion that an architecture choice baked into a spec should
  trace to a decision.** A spec's load-bearing structural claims (layout, packaging, module topology)
  should cite an ADR, the way an empirical claim must cite a source (§0.7). *Recommend:* a discipline that a
  spec's structural/packaging assumptions name the ADR that decided them.
- **G2 — "No dangling" (C-002-style) is import-only in practice; runtime name-references slip through.**
  `typecheck` caught every *import* dangler after the command cut, but two **runtime** danglers
  (`dashboard.ts` and `pick.ts` spawn deleted commands *by file-name string*) compiled fine and only
  surfaced as a hung test. The framework's drift/dangling model is built on the import/`READS`/`WRITES`
  graph; **dynamic, string-keyed dispatch is invisible to it.** *Recommend:* name dynamic-dispatch surfaces
  as a known blind spot, and (for a future linter) a check for command-name references with no target.
- **G3 — Single-source derived layer silently lags ADRs (ADR-0047's "then" step).** Twice, an ADR landed in
  `docs/` but the derived `reference/` cards + pass-skills still carried the old rule (ADR-0055 hadn't
  reached `proofs.md`/`pass-review-trace`/`ir.md`; ADR-0056 had to be propagated by hand). The single-source
  rule is sound, but nothing flags a derived artifact as stale relative to its `docs/` source. *Recommend:*
  a derived-artifact freshness check (a hash/marker tying each card/skill to the `docs/` rule it derives).
- **G4 — A spec's command/closed-set contract (e.g. C-001's 14-command surface) is unenforced until a tool
  exists.** Nothing checked C-001, so the surface grew to 59 commands — the exact "garden" the spec forbade.
  Same root as F1/F3: the contracts are real but only a future tool (or a by-hand reviewer) enforces them.
- **G5 — Doc-vs-code drift in the adopter's own conventions.** `repo-conventions.md` claimed camelCase +
  "one function per useCase file"; the actual code is `snake_case` + cohesive multi-function files. The
  surveyor stance (observe the code, not the doc) caught it — but it shows convention docs drift from code
  with nothing reconciling them.

## §4 Recommendations (for the framework, distilled)

1. **G1 is the headline:** require a spec's structural/packaging assumptions to cite a deciding ADR — the
   monorepo detour cost the most and was the least grounded.
2. **G2/G3 are checkable-document candidates:** a future lint could flag (a) dynamic command-name references
   with no target, and (b) a derived card/skill stale vs its `docs/` source.
3. **F2:** the adoption/isolation guidance should address worktree placement (outside the scanned tree) and
   dependency availability, so the bound proofs can actually run in isolation.
4. **Keep ADR-0056 front-and-center** — it is the discipline that repeatedly saved correctness.

## Method / evidence

Findings are grounded in this session's swarm-cli commits (the kit re-sync, the parser increments 1–3, the
`packages/core` → `src/modules/Sol` migration, the command-surface audit + collapse, the dashboard fix) and
the swarm-repo commits (ADR-0055/0056 + their derived-layer propagation). Living doc — appended to as the
`swarm lint` build and later increments add experience.
