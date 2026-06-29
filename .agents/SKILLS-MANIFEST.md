# `.agents/skills/` — the dev subset (manifest)

`.agents/skills/` is **not** the shipped catalogue. It is the small set of guides for working
**on this repo** — implementing changes to the docs and the checks contract. The shipped
surfaces are the starter kit's guides
([suspec-starter-kit](https://github.com/jcosta33/suspec-starter-kit) — the core loop plus the
workspace authoring guides), the optional catalog
([suspec-skills](https://github.com/jcosta33/suspec-skills) — conditioning stances and
code-authoring depth), and the reference pages under `docs/reference/`. The family workspace
that plans and reviews changes to this repo is the sibling `suspec-works` repo.

## Single-sourcing

A rule lands in `docs/` first (with an ADR under `docs/adrs/`), then the kit repo, the catalog,
and every derived surface. Never change a rule only here; this subset must not become a
competing authority.

## Census — included, and why

| Guide             | Counterpart                                                                    | Why it is here                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| `implement-task`  | mirror of the kit's `.agents/skills/implement-task/` (suspec-starter-kit repo) | Tasks cut in the suspec-works workspace are implemented in this repo; the implementing session loads the core guide here.             |
| `empirical-proof` | the catalog's `empirical-proof` (repo-adapted copy)                            | The evidence rules in standalone form: a completion claim binds to pasted output; without it the result is Unverified, never Pass. |

## Census — omitted, and why

| Guide                                                                                                                                                              | Why not here                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `write-spec`, `review-output`, and the workspace authoring guides (`write-audit`, `write-research`, `write-rfc`, …)                                                | Authoring, review, and Close-step work runs from the suspec-works workspace; its `.agents/skills/` carries them.                                                                                 |
| The conditioning stances (`persona-challenger` / `persona-surveyor`, and `adversarial-review`)                                                                     | They live in the suspec-skills catalog (the universal set); install into whichever workspace needs them.                                                                                       |
| The per-change-shape implementation guides (the `write-*` family) and `implement-task`                                                                             | They live in the suspec-starter-kit (the kit's `.agents/skills/`), per [ADR-0112](../docs/adrs/0112-two-tier-skills.md); install into whichever workspace needs them.                          |
| The documentarian discipline (was a local `persona-documentarian` copy)                                                                                            | Folded into the kit's `write-documentation`, its single source ([ADR-0093](../docs/adrs/0093-collapse-1to1-personas.md)); install that guide from the kit when writing this repo's human-facing pages. |

Templates are not skills: the frozen formats ship in the kit repo's `templates/` and
`advanced/` — link to them, never restate them.

Keep `implement-task` byte-identical to the kit repo's copy — the kit is where it is edited;
a drift here is a defect.
