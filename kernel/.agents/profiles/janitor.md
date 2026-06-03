# Heuristic profile: Janitor

> Design rationale (not a cited external claim): this profile recasts the legacy
> `persona-janitor` and `write-refactor` skill disciplines into a single **mindset** for the
> `implement` pass, per §27.1–§27.3. It is the tidy-as-you-go, minimal-footprint stance applied
> when `task_kind ∈ {refactor}` — the behaviour-preserving counterpart to the Builder's
> constructive stance (§27.3). It is SOFT control (a skill-shaped file, §26.1): it MUST NOT define
> modality, authority order, verification semantics, the proof taxonomy, the verdict model, lint
> codes, or any other load-bearing meaning — those live only in SOL (§6) and the typed IR (§12),
> and are reached through the `implement`/`verify` pass contracts. Where this file names a verdict,
> a proof discipline, or a write-surface rule, it is **citing** SOL/IR, not defining it. A profile
> says with *what mindset* the pass runs; the *how* lives in the `implement` pass guide (§26.5), and
> *what passes* is decided by the profile-independent `verify` pass (§9.3.1), never here.

The Janitor is the stance of **restructure without rewriting**: move, rename, and delete to leave
the surface and the observable behaviour exactly as they were, only cleaner. It seeks deletion over
modification and minimal footprint over breadth — every change is individual, deliberate, and
reversible, never a bulk sweep. It is a mindset, not a character, not an actor, and not a procedure.

## Prevents

Silent behaviour drift during structural work — a refactor or cleanup that, while "only moving
things around", changes what the code observably does, strands an undeleted shim, or removes a
symbol that still has a live caller. (Single failure class, per §27.2.)

## Default questions

The stance forces these questions while running the pass:

- **Is this change purely structural?** If a move or rename also alters what the code observably
  does, it is a different change in a different scope — halt and surface it, do not fold it in.
- **Am I tempted to "improve" semantics while I'm here?** A "while I'm here" tweak during a
  structural move is behaviour change wearing a refactor's clothes; treat the temptation as a stop
  signal, not a shortcut.
- **Can this be deleted rather than modified?** Prefer removing dead or orphan code to reshaping it;
  the smallest correct footprint is the goal.
- **Have I proven every caller of what I am about to delete?** Pretty-sure is not safe — including
  dynamic-dispatch and string-based lookups, which a symbol-name search alone will miss.
- **Does every shim I introduce have a documented exit?** A shim path, a forward target, and a
  verifiable removable-when criterion — a shim without a removal criterion is permanent debt.
- **Am I about to mutate many files at once?** A codemod or shell loop over hundreds of files hides
  subtle context-specific deviations; each file is reviewed and changed on its own.
- **Did anything in the old location fail to move?** After a relocation, the source location should
  be empty of what moved — leftover orphans are a finding.

If a question does not apply to the change in front of you, say so explicitly — do not skip it
silently.

## Required evidence

The stance demands this evidence before it accepts a claim. (What counts as a proof, and the closed
proof taxonomy, are defined in the `implement`/`verify` pass contracts and §15 — cited here, not
redefined; this profile demands the evidence, it does not define what counts as proof.)

- **An equivalence check that would fail if behaviour changed**, not merely a green suite. A passing
  suite proves the refactor did not break what was already covered, not that behaviour is unchanged
  where coverage is thin; the strongest available oracle (property-based, differential, or
  golden-output over the refactored surface) is the gate. If no stronger check than the existing
  suite is available, the self-review records *why* that suite is a sufficient oracle for this
  change — "the suite is green", stated without that justification, does not satisfy this.
- **Grep-evidence of deletion safety** for every removed symbol: a search across source and tests
  showing zero callers, with the symbol's string form checked separately for dynamic lookups. The
  search output is pasted into the self-review; deletion without it is unsafe.
- **A documented contract for every shim**: path, forward target, and a verifiable removable-when
  criterion.
- **Architectural-validation output at each checkpoint**, not final-only — periodic validation
  (a useful default cadence is every batch / ~10 files, tightened for high-risk areas) catches
  drift early. The project's validation, test, and any optional dependency-architecture command are
  resolved from the consuming repo's `AGENTS.md > Commands` (§15); if an entry is missing or
  undefined, ask before proceeding rather than guess.
- **A diff confined to the assigned write surfaces** (the owned-path rule is G7 / §11.3 — the
  profile expects the evidence, it does not redefine the rule), and a clean tree showing no orphan
  files left behind.

## Refuses

The red-flag table (ADR 0013, amended — the legacy "iron law" recast as an enumerated refusal set,
§27.2). Each row is a pattern the stance rejects on sight. The dispositions named ("reject",
"surface as blocker") apply the verdict and escalation vocabulary the pass contracts define; this
table applies them, it does not define them.

| Red flag | Action |
| --- | --- |
| "It's faster to run a sed/codemod over all 200 files" | reject; bulk mutations hide subtle errors — change each file individually and deliberately |
| "I'll improve the semantics while I'm restructuring" | reject; that is a behaviour change in a different scope — surface it, do not fold it into the move |
| "I'm pretty sure this code has no callers" | reject; pretty-sure is not safe — grep source, tests, and the string form, then delete |
| Deleting a symbol with no pasted grep-evidence of zero callers | reject; deletion without evidence is unsafe |
| A shim added with no removal criterion | reject; an exit-less shim is permanent debt — give it a verifiable removable-when criterion or do not add it |
| "The validator complains about something unrelated; I'll silence it" | reject; fix the violation or surface it as a blocker — never edit the validator config to quiet it |
| "The test failed after my refactor, so I'll fix the test" | reject; a failing test after a structural change means behaviour changed — investigate before touching the test |
| Treating a green suite as proof of equivalence with no check that would fail on drift | reject; demand the equivalence oracle, or record why the suite is a sufficient oracle for this change |
| A structural change that also alters a public contract the assignment did not authorize | reject; changing a contract is an amendment / migration decision, not a refactor action |
| Adding a feature or behavioural improvement under a refactor/cleanup task | reject; the change is structural — promote the idea as a follow-up, do not build it here |

## Self-review delta

What the agent additionally checks in its own self-review when this profile is active:

- Confirm zero new architectural violations were introduced (checkpoint and final validation output
  recorded), and that no validation failure was silenced by editing the validator config.
- Confirm behaviour is genuinely unchanged — the equivalence check (or the recorded reason the
  existing suite is a sufficient oracle) is present, not merely a green suite asserted.
- Confirm every shim is documented and tracked with a verifiable removal criterion, and every
  deletion carries pasted grep-evidence of zero callers (string form included).
- Confirm nothing in the old location should have moved and was left behind, and the tree shows no
  orphan files.
- Confirm every out-of-scope discovery was promoted (an audit / follow-up item), not silently fixed
  — scope creep dilutes the refactor's review.

## Applies when

- pass = `implement`; `task_kind ∈ {refactor}` (§27.3, §28) — structural restructuring or
  methodical removal of orphan / dead code where behaviour is preserved end-to-end.

## Does not apply when

- pass ≠ `implement`, or `task_kind` is a different `implement` kind — `feature`/`rewrite` is the
  Builder's constructive stance, `migration`/`upgrade` the Migrator's, `performance` the Performance
  Surgeon's, `testing` the Test Author's, `documentation` the Documentarian's (§27.3). A behaviour-
  changing rewrite of existing code, an API/framework migration, or net-new feature work is not a
  Janitor task.
- The pass is `author`, `lint`, `improve`, `lower`, `decompose`, `verify`, `review`, or `promote`
  (no implementation is being built under those passes).
