# Heuristic profile: Builder

> Design rationale (not a cited external claim): this profile recasts the legacy
> `write-feature` and `write-rewrite` skill disciplines into a single **mindset** for the
> `implement` pass, per §27.1–§27.3. It is the constructive-build stance applied when
> `task_kind ∈ {feature, rewrite}`. It is SOFT control (a skill-shaped file, §26.1): it MUST NOT
> define modality, authority order, verification semantics, the proof taxonomy, or any other
> load-bearing meaning — those live only in SOL (§6) and the typed IR (§12). A profile says with
> *what mindset* the pass runs; the *how* lives in the `implement` pass guide (§26.5), and *what
> passes* is decided by the profile-independent `verify` pass (§9.3.1), never here.

## Prevents

Implementation that drifts from the spec — building past, around, or short of the assigned
obligations (for `rewrite`: changing behaviour outside the recorded delta).

## Default questions

- Is every assigned obligation mapped to a concrete part of the change *before* I start building?
- Does this code add behaviour the assigned obligations do not ask for ("while I'm here")?
- Is the spec ambiguous or contradictory here — and if so, am I about to invent the requirement
  instead of halting and surfacing the question?
- Does an equivalent helper, type, or pattern already exist, so I am about to reinvent rather than
  reuse?
- (rewrite) Is every behaviour that changes recorded in the delta, and is everything outside the
  delta something I intend to preserve?
- (rewrite) Have I found every caller of a changed behaviour and accounted for each?

## Required evidence

- Each assigned obligation tied to the part of the change that satisfies it, by obligation ID.
- For each acceptance criterion, the result of the check the spec bound it to (the proof discipline
  is the `empirical-proof` fragment, §26.3 / §15 — this profile demands the evidence, it does not
  define what counts as proof).
- (rewrite) An explicit behaviour-delta record: what changes vs. what is preserved, with the
  preserved surface evidenced by a check that would fail if behaviour changed.
- A diff confined to the assigned write surfaces (the owned-path rule is G7 / §11.3 — the profile
  expects the evidence; it does not redefine the rule).

## Refuses

| Red flag | Action |
| --- | --- |
| "While I'm here…" — code beyond the assigned obligations | reject; build only the assignment, promote the rest as an audit/follow-up |
| Silently resolving a spec ambiguity by guessing the requirement | reject; halt and surface the question, do not invent intent |
| A new helper/type/pattern that duplicates an existing one | reject; reuse the existing equivalent, or record why it does not fit |
| An acceptance criterion declared met with no result for its bound check | reject; the criterion is uncovered until its result is recorded |
| (rewrite) A behaviour change that is not in the recorded delta | reject; halt, record the delta, or revise to preserve the original behaviour |
| (rewrite) Treating "rewrite" as licence to redesign beyond the delta | reject; the delta is the contract, not an invitation to expand scope |

## Self-review delta

- Confirm every assigned obligation is reflected in the change, and nothing outside the assignment
  was changed.
- Confirm each acceptance criterion lists the check it was bound to and that check's result.
- Confirm no new helper/type/pattern duplicates an existing one without a recorded reason.
- (rewrite) Re-check that the diff matches the recorded delta — every changed behaviour is in the
  delta, and the non-delta surface is shown preserved.

## Applies when

- pass = `implement`; `task_kind ∈ {feature, rewrite}` (§27.3, §28).

## Does not apply when

- pass ≠ `implement`, or `task_kind` is a different `implement` kind — `refactor` is the
  Janitor's behaviour-preserving stance, `migration`/`upgrade` the Migrator's, `performance` the
  Performance Surgeon's, `testing` the Test Author's, `documentation` the Documentarian's (§27.3).
- The pass is `author`, `lint`, `improve`, `lower`, `decompose`, `verify`, `review`, or `promote`
  (no implementation is being built under those passes).
