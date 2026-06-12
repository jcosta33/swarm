# `.agents/skills/` — the dev subset (manifest)

`.agents/skills/` is **not** the shipped catalogue. It is the small set of guides for working
**on this repo** — implementing changes to the docs, kit, and checks contract. The shipped
surfaces are the kit's core guides (`starter-kit/.agents/skills/`), the optional templates and
cards (`starter-kit/advanced/`), the optional guide catalog
([swarm-skills](https://github.com/jcosta33/swarm-skills)), and the reference pages under
`docs/reference/`. The family workspace that plans and reviews changes to this repo — and
carries the authoring, review, and persona guides — is the sibling `swarm-hq` repo.

## Single-sourcing

A rule lands in `docs/` first (with an ADR under `docs/adrs/`), then the kit and every derived
surface. Never change a rule only here; this subset must not become a competing authority.

## Census — included, and why

| Guide                   | Counterpart                                             | Why it is here                                                                                                      |
| ----------------------- | -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `implement-task`        | mirror of `starter-kit/.agents/skills/implement-task/`   | Tasks cut in the swarm-hq workspace are implemented in this repo; the implementing session loads the core guide here. |
| `empirical-proof`       | folded into the kit's three core guides                  | The evidence rules in standalone form: a completion claim binds to pasted output; without it the result is Unverified, never Pass. |
| `persona-documentarian` | none shipped (docs are this repo's product)              | The stance for the human-facing pages this repo ships: one frame throughout, every example run, every claim cited.    |

## Census — omitted, and why

| Guide                                                                                  | Why not here                                                                                       |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `write-spec`, `review-output`, `write-audit`, `write-research`, `write-rfc`, the personas, `adversarial-review`, `save-findings` | Authoring, review, and Close-step work runs from the swarm-hq workspace; its `.agents/skills/` carries them. |
| The optional-tier guides (`write-bug-report`, `write-prd`, `write-change-plan`, `write-inventory`, `spec-check`, `split-work`) and the per-change-shape implementation guides | They live in the swarm-skills catalog; install into whichever workspace needs them.                  |

Templates are not skills: the frozen formats live at `starter-kit/templates/` and
`starter-kit/advanced/` — link to them, never restate them.

## Known consequence of ADR-0069

The kit ships `starter-kit/.claude/skills → ../.agents/skills`, so Claude sessions in THIS
repo also discover the kit's three adopter-facing guides (`write-spec`, `implement-task`,
`review-output`). They are kit content; only `implement-task` doubles as dev guidance (the
copies are kept byte-identical — a drift is a defect). Do not apply the kit's `write-spec`
or `review-output` to work on this repo: specs and reviews for this repo live in swarm-hq.
