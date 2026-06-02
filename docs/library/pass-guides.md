# Pass guides

> Swarm's reference for **pass guides**: the reusable, lazily-loaded procedural modules that document *how* to run a named pass — never *what the language means* — together with the legacy-skill recast, the loading doctrine, the cross-cutting fragments, and the pass-guide contract.

A **pass guide** is a procedural module that documents how to perform one of the **nine passes** of the Swarm compiler pipeline (`author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote`) — and nothing more. It is a reusable *method* an agent loads when a task names it: the prose recipe for executing a pass well, the questions to ask, the order to work in, the evidence to gather. It is **SOFT control** (Invariant 2): it influences how an agent works but binds nothing the kernel marks authoritative. Where a guide and the language reference disagree, the language reference governs.

Like everything in Swarm, a pass guide has **no runtime**: it is text a human, an agent, or a future harness reads. Loading a guide changes how work gets done; it never executes anything and never enforces anything.

## The one rule a pass guide must never break

> **The semantic-ownership prohibition.** No pass guide may define, redefine, or be required to interpret SOL or APS semantics. All load-bearing meaning lives in SOL and the typed IR; a pass guide is a procedure, not a semantic home.

This is the load-bearing constraint of the whole pass-guide layer. A pass guide MUST NOT define a block type, a modal, a clause keyword, a verdict value, a proof type, a lint code, or any IR field. Those live exclusively in the language reference. A guide MAY cite, link to, or quote that reference, but the citation is **non-authoritative delivery** — the authoritative text is the reference itself.

The reason is adherence: meaning that lived in a lazily-loaded, optional guide would make the meaning of a spec depend on whether that guide happened to load. So a correctly written `*.swarm.md` file MUST be understandable to a strong model **without any guide loaded**, because it uses the controlled obligation language and stable formal blocks. The guide tells you how to *work*; the spec already tells you what the work *means*.

A conformant repo confirms, by regression check, that no pass guide, profile, fragment, or `AGENTS.md` section defines modality, authority order, or verification semantics.

## The recast: 24 legacy skills onto 9 passes

The pass-guide model replaces a legacy framework that shipped **24 self-contained "skills."** A skill was a procedural module a model loaded to do a unit of work — the same shape as a pass guide, but with no discipline preventing it from quietly owning semantics. The recast preserves every skill's procedural value while removing that one failure mode, by re-homing each skill as exactly one of three things: a **pass guide** (one per pass), a **cross-cutting fragment** (shared procedure), or a **profile** (a cognitive stance, documented separately).

The mapping is **many-skills-to-one-pass**: a single pass MAY carry more than one guide. The `implement` pass, for instance, carries one guide per implementation kind.

| Legacy skill | Recast role | Owning pass |
|---|---|---|
| `write-spec` | author guide | `author` (spec) |
| `write-research` | author guide | `author` (research) |
| `write-audit` | author guide | `author` (audit) |
| `write-bug-report` | author guide | `author` (bug-report) |
| `write-feature` | implement guide | `implement` |
| `write-fix` | implement guide | `implement` |
| `write-refactor` | implement guide | `implement` |
| `write-rewrite` | implement guide | `implement` |
| `write-migration` | implement guide | `implement` |
| `write-performance` | implement guide | `implement` |
| `write-testing` | implement guide | `implement` |
| `write-documentation` | implement guide | `implement` |
| `fix-flaky-test` | narrow implement guide | `implement` |
| `adversarial-review` | **folds into** `review` as the Skeptic profile — no longer a skill | `review` |
| `empirical-proof` | cross-cutting fragment | shared (behind `verify` / `review`) |
| `distillation-discipline` | cross-cutting fragment | shared (behind `lower` / `decompose` / `promote`) |
| `persona-architect` | becomes a profile | `author` (spec) |
| `persona-auditor` | becomes a profile | `author` (audit) |
| `persona-janitor` | becomes a profile | `implement` |
| `persona-migrator` | becomes a profile | `implement` |
| `persona-performance-surgeon` | becomes a profile | `implement` |
| `persona-skeptic` | becomes a profile | `review` / `verify` |
| `persona-surveyor` | becomes a profile | `author` (research) |
| `persona-lead-engineer` | becomes a profile | `decompose` / merge-gate |

Three rows are normative and worth calling out:

- **`adversarial-review` folds into `review`.** It does **not** survive as a standalone skill. Its adversarial method becomes the **Skeptic profile** applied to the `review` (and `verify`) passes, because skepticism is a *parameter to a pass*, not a separate pass of its own.
- **`fix-flaky-test` survives as a narrow `implement` guide.** It is the one legacy skill that maps to a procedure specific enough (de-flaking a non-deterministic test) to stay its own guide rather than collapse into the general fix guide.
- **The eight `persona-*` skills become profiles.** A profile is a heuristic stance — what an agent looks for and refuses — not a procedure module. Profiles are documented on their own page; this page covers the procedure layer.

### What ships in v0.1

The pass-guide set spans all nine passes as a *contract*, but only **five stdlib pass guides ship in v0.1**: those for `lint`, `decompose`, `implement`, `review[profile: skeptic]`, and `promote`. The remaining four passes — `author`, `improve`, `lower`, `verify` — are fully specified by their pass contracts but ship **no guide yet**, and MAY gain one in a later framework release with no language-version change. A guide-less pass is **not** a conformance gap: the pass contract is the binding artifact, and the guide is an optional aid to performing it.

The `lint` and `decompose` guides are **net-new** — no legacy guide seeded them. The recast table seeds guides only onto `author` and `implement`; the one legacy item touching `decompose` was the Lead Engineer *profile*, not a guide.

## The two cross-cutting fragments

Two procedural disciplines apply across multiple passes, so they ship as **fragments** rather than as guides bound to a single pass. A fragment has the same shape as a pass guide (the contract below) but is **named by another guide** rather than by a task's `task_kind` — a guide composes it the way a function calls a helper.

| Fragment | Discipline it carries | Passes that compose it |
|---|---|---|
| `empirical-proof` | the proof / `VERIFY BY` discipline — every completion claim maps to an independent, re-runnable proof; "tests passed" with no pasted output is not a proof | `verify`, `review` |
| `distillation-discipline` | the loss-budget discipline — what MUST be preserved and what MAY be dropped when meaning crosses an artifact boundary | `lower`, `decompose`, `promote` |

Neither fragment defines semantics. `empirical-proof` does not define the proof taxonomy or the verdict model — it carries the *procedure* for applying the proof discipline the language reference owns. `distillation-discipline` does not define the loss-budget table — it carries the *procedure* for distilling accountably (making each boundary crossing's loss visible, via a `Preserved / Dropped / Still-uncertain` statement) against the budget the reference owns.

## The loading doctrine: load what the task names

> **Load the pass guide(s) and profile(s) that the task file names.** Description-matching is the launcher-less fallback, not the primary mechanism.

A pass guide is **lazily loaded** — never always-on. The canonical way it activates is by being **named in the task** that frames the pass:

- A `task.md` SHOULD name, in its frontmatter or assignment block, the pass guide(s) and profile(s) it activates for the pass it frames. When named, the agent **MUST load exactly those, and SHOULD NOT load others** — because always-on density harms adherence and cost.
- When no launcher and no explicit naming is present, an agent MAY fall back to matching a guide's self-activating `description` field against the task. This is a **degraded mode**, retained for the launcher-less, à-la-carte case (a task dropped into an arbitrary agent CLI with no router) — not the contract.
- A pass guide MUST NOT be always-loaded. There is no standing gatekeeper that pre-loads guides; that would itself be an always-loaded skill (forbidden) and would not be guaranteed present on a consumer's machine.

The recommended primary path — naming the guides in the task — looks like this:

```text
task.md frontmatter:
  task_kind: fix
  pass: implement
  pass_guides: [write-fix, fix-flaky-test]
  profiles: [skeptic]
```

The agent loads `write-fix`, `fix-flaky-test`, and the Skeptic profile for this `implement` pass, and **nothing else**. Routing (which conditioning loads) stays **orthogonal** to verification (what proof a task must carry once active): they are independent axes, and naming a guide neither adds nor relaxes any obligation.

## The pass-guide contract

Every pass guide declares the following sections. A conformant guide satisfies this contract:

```markdown
# Pass guide: <name>

## Purpose
## Consumes
## Produces
## Preserves
## Rejects
## Procedure
1.
2.
3.
## Output contract
## Self-review delta
```

Guide bodies are **self-contained**: a reader following one guide should not have to hop across a chain of other guides to perform the pass. A guide MAY *depend on* — cite, link, or quote — the shared language definitions, artifact contracts, and pass contracts upstream of it. What it MUST NOT do:

- **MUST NOT introduce a circular dependency.** Dependency direction is one-way and acyclic:

  ```text
  language definitions -> artifact contracts -> pass contracts -> pass guides -> heuristic profiles -> project overlays
  ```

  A guide depends only on nodes to its left; nothing to its left depends on a guide.
- **MUST NOT be required to interpret SOL.** A correctly authored spec is readable without the guide; the guide only says how to run the pass over it.
- **MUST NOT override an approved obligation.** A guide is procedure; it cannot weaken, waive, strengthen, or reinterpret an obligation the spec already approved. Waiver authority is a human or the spec owner — never a guide.
- **MUST NOT be always-loaded.** It is lazily loaded by name, per the doctrine above.

## The installed guides

The stdlib pass guides and the two fragments ship under `kernel/.agents/skills/`. Each is a self-contained `GUIDE.md` carrying the contract above, plus a self-activating `description` for the launcher-less fallback:

| Installed module | Role | Pass |
|---|---|---|
| `kernel/.agents/skills/pass-lint-spec/` | stdlib pass guide | `lint` |
| `kernel/.agents/skills/pass-decompose-spec/` | stdlib pass guide | `decompose` |
| `kernel/.agents/skills/pass-implement-obligations/` | stdlib pass guide (branches by `task_kind`) | `implement` |
| `kernel/.agents/skills/pass-review-trace/` | stdlib pass guide (carries the Skeptic profile) | `review` |
| `kernel/.agents/skills/pass-promote-findings/` | stdlib pass guide | `promote` |
| `kernel/.agents/skills/empirical-proof/` | cross-cutting fragment | `verify`, `review` |
| `kernel/.agents/skills/distillation-discipline/` | cross-cutting fragment | `lower`, `decompose`, `promote` |

These directories carry legacy-vocabulary names (`skills/`); in kernel vocabulary they are pass guides and fragments. The four guide-less passes (`author`, `improve`, `lower`, `verify`) ship no module here — their pass contracts stand on their own.

## Related

- [The compiler pipeline](../model/compiler-pipeline.md) — the nine passes and seven phases a guide runs against, and the five-stdlib-guide summary.
- [The `lint` pass](../passes/lint.md), [the `decompose` pass](../passes/decompose.md), [the `implement` pass](../passes/implement.md), [the `review` pass](../passes/review.md), and [the `promote` pass](../passes/promote.md) — the contracts the five shipped guides perform.
- [The `verify` pass](../passes/verify.md) — the proof model and verdict vocabulary the `empirical-proof` fragment applies but never defines.
- [The `task.md` artifact](../artifacts/task.md) — where a task names the pass guides and profiles to load.
- [SOL](../language/SOL.md) and [the errors reference](../language/errors.md) — the authoritative homes of the meaning a pass guide MUST NOT own.
- [The distillation loss budget](../reference/distillation-loss-budget.md) — the budget the `distillation-discipline` fragment applies across boundary-crossing passes.
- [The glossary](../reference/glossary.md) — canonical definitions of *pass guide*, *profile*, *pass*, and *phase*.
