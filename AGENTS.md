# AGENTS.md — working on the Swarm framework

## What this repo is

This repo **is** the Swarm framework — *a lightweight spec and review workflow for teams using
coding agents*, shipped as markdown: docs, templates, and a starter kit. It ships **no runtime**:
anything described as checkable names its checker (the reference implementation in progress is
`swarm-cli`, a sibling repo); everything else is convention or review checklist, and says so.

- `docs/` — the product: a numbered happy path (`01`–`10`), `reference/` (the deep layer:
  structured requirements, checks, step bars, artifact formats, advanced lifecycle, future CLI,
  memory), `examples/` (three flagship walkthroughs; `large-pr-review.md` is the demo),
  `ADOPTING.md`, `adrs/` (the decision ledger), `research/sources.md` (the evidence bibliography).
- `starter-kit/` — a complete workspace adopters copy whole (ADR-0069): `AGENTS.md` + symlinks,
  `.agents/skills/` (3 core guides; `.claude/skills` symlink), `templates/` (8), seeded flow
  folders, `status.md`, `examples/`, `decisions/`, `advanced/` (optional tier).
- `checks/` — the checks contract as data (`checks.yaml`) + fixtures (test data for
  `docs/reference/checks.md`; swarm-cli's oracle). `.agents/` — this repo's own dev tooling,
  audits, and plans.

## Startup

1. Read the current task/request first; load only the skill or reference it names.
2. Treat the ADRs (`docs/adrs/`) as the recorded intent; the build brief
   (`.agents/plans/build-brief.md`) carries voice/vocabulary rules for doc work.
3. Map every completion claim to evidence — paste real output; a claim without it is unverified.
4. Adversarial self-review before declaring done (ADR-0056): re-read your own diff as a skeptic;
   never self-issue a review verdict.

## Universal rules

- **Fresh-product voice.** No migration framing ("previously/renamed/now") anywhere except
  `docs/adrs/`. The framework is presented as originally designed.
- **Honesty framework (ADR-0063).** Rules carry a level: convention · checklist · toolable
  (names swarm-cli's command) · enforced (only with a shipped tool — today, nothing). Never
  write enforcement-sounding claims without a level.
- **Vocabulary tiers (ADR-0057).** User tier (README, `docs/01–10`, `docs/examples/`,
  kit core): step · requirement/AC · evidence · review result (Pass/Fail/Unverified/Blocked) ·
  checks · structured requirements · writing rules · workspace · save a finding. Reference tier
  may also use the precise internal terms (pass, obligation, proof, verdict, SOL codes);
  `docs/reference/glossary.md` maps both directions.
- **No counts ceremony.** Closed-set cardinalities live in exactly two places:
  `checks/README.md` (producer reconciliation note) and the cheatsheet appendix.
  Everywhere else lists values, never counts.
- **Citations are contextual.** Every load-bearing empirical claim cites a verified entry
  inline — the `[[KEY]]` form linking the matching anchor in `docs/research/sources.md` — and the citation moves with the claim.
  Non-verified sources never carry a MUST-level claim; fact-shaped statements without a
  source are labeled design rationale. Web-verify before adding to `sources.md`.
- **Single-sourcing.** Formats are frozen in ADRs 0058/0060/0061/0067/0068 and shipped at
  `starter-kit/templates/` — everything else links, never restates. A rule lands in `docs/`
  first; kit guides and dev skills derive from it (propagation matrix:
  `.agents/audits/repositioning-propagation.md`).

## Pointers

- Decisions: `docs/adrs/README.md` (0001–0071; 0057–0071 are the current architecture)
- Plans: `.agents/plans/practical-swarm-repositioning-plan.md` (+ inputs/, validation survey)
- Dev skills (curated subset for working on this repo): `.agents/skills/` — see
  `.agents/SKILLS-MANIFEST.md`
- Evidence: `docs/research/sources.md` (verified / caveated / rejected — never cite rejected)
- Outstanding: swarm-cli resync + cold re-adoption (Increments 10–11) — see the propagation matrix

## Commands

| Slot | Command | Resolves |
|---|---|---|
| — | (none) | markdown-only repo; coherence is checked by the gates in the propagation matrix |

## Workflow

Work from `main`: commit and push directly to `main` (producer convention only — adopters
follow their own branching; tasks run in worktrees per `docs/07-running-agents.md`).
Commit messages end: `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.

## Compatibility

`CLAUDE.md` and `GEMINI.md` are symlinks to this file — one bootloader, many agent tools.
