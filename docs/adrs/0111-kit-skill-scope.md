---
type: adr
id: adr-0111
status: accepted
created: 2026-06-26
updated: 2026-06-26
---

# ADR-0111 — Kit skills are Suspec concepts; style / stance / depth lives in the catalog

## Context

The starter kit ships its `.agents/skills/` as "essential" ([ADR-0075](./0075-starter-kit-template-repo.md)
D2 / [ADR-0064](./0064-minimal-kit-tiering.md)), and the catalog (suspec-skills) holds the optional
layer. The boundary was stated as "what every workspace needs" — true but imprecise, and one skill sat
on the wrong side of it: `adversarial-review`. A review is a Suspec concept (the review artifact, the
no-self-verdict gate, coverage); but **adversarial / three-lens / refute-by-default is a review *style***
— Suspec mandates the artifact, never the style. A user reaching for the adversarial-review discipline
in a repo with no Suspec install found it trapped in the kit.

## Decision

**A skill stays in the kit iff it authors or operates a *Suspec concept*.** Concretely:

- **Kit (required):** a skill that builds a Suspec **artifact type** — spec, task, review, finding,
  intake, inventory, change-plan, audit, research, RFC, PRD, bug-report — or runs a **core-loop method**
  (Spec → Task → Run → Review → Close, incl. `split-work`, `spec-check`). These are the concepts the
  method is made of; a workspace can't follow Suspec without them.
- **Catalog (suspec-skills):** a skill that encodes a **style, stance, or depth** that is *not itself a
  Suspec concept* — a way of doing the work, not a Suspec artifact. Suspec requires neither it nor any
  particular version of it.

The test that decides the boundary case: *does Suspec mandate this thing, or a style of doing a
mandated thing?* A review is mandated (kit: `review-output` builds the packet); *adversarial* review is
a style (catalog). **Relocate `adversarial-review` from the kit to suspec-skills.** This also explains,
post-hoc, why the catalog's existing residents are correctly placed — `persona-skeptic`/`-challenger`/
`-surveyor` (stances), `empirical-proof` (a discipline), the `write-fix`/`-refactor`/… depth guides:
none is a Suspec artifact type.

## Consequences

- The kit holds only artifact-authoring + loop guides; the catalog holds style/stance/depth. The split
  is now stated by a single test, not a per-skill audit.
- `adversarial-review` is installable into any repo (`npx skills add`), Suspec or not — its natural home.
  The skill moves intact; its best-in-class consolidation is a separate change (the Improvement Program
  WS-C, Wave 4).
- `review-output` (build the review packet — a Suspec concept) stays in the kit; the review *style*
  leaves. No core-loop guide moves.
- Accepted ADRs 0064/0075 are not edited (Nygard immutability); this ADR refines them and the README
  ledger carries the disposition.

## Affected obligations / constraints

- **Refines:** [ADR-0064](./0064-minimal-kit-tiering.md) (the kit/advanced tiering criterion),
  [ADR-0075](./0075-starter-kit-template-repo.md) (the "essential guides" list — `adversarial-review`
  leaves it). **Reaffirms:** [ADR-0093](./0093-collapse-1to1-personas.md) (stances live in the catalog,
  not the kit), single-sourcing.
- **Does NOT change:** the core-loop guides, the artifact formats, the verdict model, or the checks
  contract.
