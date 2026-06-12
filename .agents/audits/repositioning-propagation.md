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
| kit agent guides | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| kit advanced reference cards | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| kit templates | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| kit shell (README/AGENTS/example/decisions/gitignore) | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| .agents/skills + manifest | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| docs/library/code-skills | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| conformance/conformance.yaml | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| conformance/fixtures + prose-corpus | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| evals/ | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| docs/examples/ | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| docs/reference/cheatsheet.md | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| root AGENTS.md + symlinks | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| swarm-cli (external) | pending | pending | pending | pending | pending | pending | pending | pending | pending | pending | pending | pending |

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

## Outstanding (open increments)

- **Increment 10 — swarm-cli resync** *(deferred by the owner, 2026-06-12)* (sibling repo): kit re-copy, spec suite re-cut to the new
  format, `swarm lint`/`swarm spec check` pointed at the C001–C011 contract + `format: sol`
  selector + the new fixtures (incl. equivalence pairs). Gate: pasted green run on both repos.
- ~~Increment 11~~ **CLOSED 2026-06-12** — cold re-adoption + eleven-question cold read executed
  by fresh-session agents; 0 blockers; 4 MAJOR + 7 MINOR friction items fixed same day; D6/D10
  kept, D14 kept-with-adjustment. Record: `.agents/audits/post-pivot-adoption-review.md`.
  The spec-first pilot's pair register waits with the swarm-cli backlog (owner-deferred).
- **Deliberate cuts recorded:** IR fixtures are not shipped (machine-artifact schemas live only on
  `docs/reference/future-cli.md`; reserved names spelled infix-free per ADR-0059 addendum); the
  frozen template texts live verbatim in `starter-kit/templates/` with the ADRs describing them
  (embedding waived — one verbatim home beats two).

## Tracked derived pairs

- `.agents/skills/adversarial-review/` ↔ `starter-kit/advanced/adversarial-review/` — dev copy may use
  internal vocabulary; the kit copy follows kit conventions (frontmatter `type:`, cmd* slots, packet
  vocabulary). An edit to one re-checks the other.

## Gate evidence log

(appended per increment)

## Gate evidence — 2026-06-11 (full rebuild)

```
user-tier banned-token hits: 0   (2 earlier hits were "compiler" inside is-not denial lists — allowed context)
all-tiers banned-token hits: 0
counts outside the two homes: 0  (present in conformance/README.md + cheatsheet appendix)
label problems: 0                (18 re-added after a formatting hook stripped them)
broken links outside docs/adrs/: 0
citation anchor/path problems: 0 (16 ADR files had pre-existing ./research path typos — fixed)
adr historical broken links: 33  (immutable ledger bodies referencing pages now in git history — accepted)
C-check numbering: reconciled to the canonical C001–C009 of docs/reference/checks.md across
conformance.yaml, fixtures, cheatsheet, and starter-kit/advanced/checks-reference.md
```

All 13 surfaces rebuilt this pass (single continuous execution; SHAs in the commits
"ADRs 0057-0068…" and "Rebuild: practical-first repositioning…"). The swarm-cli row
remains OPEN — sibling-repo resync is the one outstanding surface.

## Gate evidence — 2026-06-11 (post adversarial review)

Six-dimension hostile review consolidated in `.agents/audits/post-rebuild-adversarial-review.md`.
2 BLOCKERs + ~20 MAJORs + ~30 MINORs found and fixed; re-run gates all zero (user-tier tokens,
labels 28/28, links, citations, counts). Accepted-as-is items and the two open increments are
recorded in the review file.

## Gate evidence — 2026-06-12 (Increment 11 close)

```
post-friction-fix gates: user-tier tokens 0 · labels 0 problems · links 0 · citations 0
sources.md: REDEFO re-sectioned; retained-uncited-entries note added
```

## ADRs 0069–0071 — the scaffolding restructure (2026-06-12)

Owner-directed; decisions in `docs/adrs/006{9,70,71}-*.md`. Path renames mean the historical
matrix rows and gate evidence above reference **pre-rename paths** — that is the record, not
drift:

| Change | Old surface | New surface | Status |
|---|---|---|---|
| Kit reshaped to a copy-whole workspace | `starter-kit/agent/` (staging dir) | kit root `AGENTS.md` + `.agents/skills/` + `.claude/skills` symlink; seeded flow folders; root `status.md` | done @ "starter-kit/: reshape…" |
| Checks vocabulary at tree level | `conformance/`, `conformance.yaml` | `checks/`, `checks/checks.yaml` (v0.3.0) | done @ "checks/: rename…" |
| Step bars are product reference | `evals/` (8 files, island) | `docs/reference/step-bars.md` (one page; P/S/T/R/V/C ids kept; 3 live inbound links) | done @ "step-bars: …" |

Reference sweeps: `starter-kit/agent` → `.agents/skills` (7 live files), `conformance` →
`checks` (7 live files; ADR bodies keep historical names), evals inbound = 0 before deletion
(verified — it was an island). Root bootloader `AGENTS.md` repo map rewritten; ADOPTING,
root README get-started, docs/03 tree, docs/10 per-tool table, kit README rewritten.

**Outstanding register update:** the swarm-cli resync (Increment 10, owner-deferred) now
additionally covers: the workspace-shaped kit (copy-whole adoption + `.agents/skills/` home),
the `checks/checks.yaml` path + v0.3.0, and `step-bars.md` replacing `evals/` as the
step-quality reference. The template-repo split/mirror is deferred to public launch per
ADR-0069 §4.
