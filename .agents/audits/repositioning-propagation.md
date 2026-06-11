---
type: audit
id: repositioning-propagation
status: active
created: 2026-06-11
---

# Repositioning propagation matrix

Tracks ADRs 0057–0068 across the 13 derived surfaces. A cell flips to `done` only with the
commit SHA that landed it. Derivation order (never violated): ADRs → docs/ + README →
examples → starter-kit → .agents/ dev subset → docs/library/code-skills → conformance/ +
evals/ → sweep → swarm-cli → close.

| Surface | 0057 | 0058 | 0059 | 0060 | 0061 | 0062 | 0063 | 0064 | 0065 | 0066 | 0067 | 0068 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| kit agent guides | | | | | | | | | | | | |
| kit advanced reference cards | | | | | | | | | | | | |
| kit templates | | | | | | | | | | | | |
| kit shell (README/AGENTS/example/decisions/gitignore) | | | | | | | | | | | | |
| .agents/skills + manifest | | | | | | | | | | | | |
| docs/library/code-skills | | | | | | | | | | | | |
| conformance/conformance.yaml | | | | | | | | | | | | |
| conformance/fixtures + prose-corpus | | | | | | | | | | | | |
| evals/ | | | | | | | | | | | | |
| docs/examples/ | | | | | | | | | | | | |
| docs/reference/cheatsheet.md | | | | | | | | | | | | |
| root AGENTS.md + symlinks | | | | | | | | | | | | |
| swarm-cli (external) | | | | | | | | | | | | |

## Reconciliation gate (run per increment; paste outputs below)

1. Link audit: every relative `](...)` resolves; every `[[KEY]]` anchor resolves in `docs/research/sources.md`.
2. Banned-token grep, tier-scoped (lists below).
3. Counts appear only in `conformance/README.md` producer note + cheatsheet appendix.
4. Terminology one-way check (user tier uses column-A vocabulary only).
5. Same-commit rule: a format change updates its fixtures + examples + templates in that commit.

## Banned tokens — user tier (`README.md docs/ADOPTING.md docs/[0-9][0-9]-*.md docs/examples/ starter-kit/` excl. `starter-kit/advanced/`)

`compiler` · `lower` (step sense) · `\bIR\b` · `swarm.ir.json` · `structured form` (as artifact) · `lint floor` ·
`HARD CAP` · `regression check` (cap sense) · `SOL/0.1` · `swarm_language` · `aps_version` · `closed set` ·
`nine-pass|9 passes` · `pass guide` · `obligation` · `verdict` · `proof type` · `conformance` (say "checks") ·
`heuristic profile` · `.swarm.md` · `source of truth` (spec sense) · `build reliably` · `task_kind` ·
`Inventory →`/`Change Plan →` as README loop steps

## Banned tokens — all tiers

`HARD CAP` · `regression check that fails` · `lint floor` · "spec is the source of truth" · "agents build reliably" ·
enforcement claims with no named (aspirational) checker

## Gate evidence log

(appended per increment)
