# `.agents/skills/` — curated dev subset (manifest)

`.agents/skills/` is **not** the shipped catalogue. It is a **curated subset** of the canonical authoring
kit (`starter-kit/.agents/skills/`, 20 skills), kept here for working **on this repo** — which is itself a
docs/spec repo, not a typical adopter.

## Canonical source

The kit is canonical (ADR-0047, single-sourcing): a rule lands in `docs/` first, then the kit skill, then —
for the skills mirrored here — this subset. **Make rule changes in `docs/` → the kit, never only here**, so
this subset never becomes a competing authority.

## Included (12)

- **Analysis / discipline:** `empirical-proof`, `pass-review-trace`, `pass-promote-findings`
- **Authoring personas (6):** `persona-architect`, `persona-auditor`, `persona-documentarian`,
  `persona-researcher`, `persona-skeptic`, `persona-surveyor`
- **Author guides exercised in this repo's own work (3):** `write-audit`, `write-research`, `write-rfc`

## Omitted (8) — and why

The spec-pipeline passes (`pass-lint-spec`, `pass-improve-spec`, `pass-lower-spec`, `pass-decompose-spec`),
the remaining source-author guides (`write-spec`, `write-prd`, `write-bug-report`), and the
`distillation-discipline` fragment ship in the kit but are **not loaded here**: this repo is developed by
editing the framework docs/specs directly, so it doesn't run the full author→lower→decompose pipeline on its
own specs. They remain available in the kit for adopters.

## Intentional divergence (NOT drift to reconcile)

The copies here point to **framework-internal references** (`docs/…`, the manuals) rather than the *shipped*
`reference/` cards an adopter loads — because this repo's `.agents/` carries no `reference/` dir (the canonical
references live in `docs/`). So minor wording / pointer-target differences from the kit are **by design**: the
load-bearing *rules* track the kit, only the reference targets are repo-appropriate. A diff against the kit
that shows only reflow or pointer-target differences is expected, not a defect — do not "resync" it.
