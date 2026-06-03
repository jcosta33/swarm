---
name: fix-flaky-test
type: fragment
description: >
  The flaky-test discipline: a non-deterministic failure is a real signal, and the only acceptable
  resolution is to reproduce it, characterize the nondeterminism, fix the root cause, and prove the
  fix by re-running the bound test. Load this fragment behind an `implement` pass whose `task_kind`
  is `fix` and whose oracle is a loop-run — a flake. This fragment carries the *procedure*; it never
  redefines the verdict model, the proof types, or what counts as a proof.
---

# Pass guide: fix-flaky-test (cross-cutting fragment)

> **Fragment, not a standalone pass guide.** `fix-flaky-test` has the pass-guide shape but is
> *composed* behind the `implement` pass rather than named directly by a `task_kind`. A `fix`
> packet whose failing test is non-deterministic loads this fragment; a `task.md` does not activate
> it on its own. It pairs with the `empirical-proof` fragment — that one owns the proof discipline;
> this one owns the discipline of *what a flake is and how to stabilise it*.
>
> **This fragment owns no semantics.** It does not define the verdict values, the proof types, the
> proof-strength order, or what is and is not a proof — those belong to the language reference. Every
> load-bearing term here (`VERIFY BY`, `VERDICT`, proof type, the 7-value verdict) is delivered, not
> redefined. Where this fragment and the language reference disagree, the reference governs. This is
> the *procedure* for applying the flaky-test discipline that those layers own.

## Purpose

Stop the most tempting non-fix in software: re-running a test until it goes green, calling it
fixed, and shipping the bug. A flaky test fails non-deterministically — green sometimes, red
sometimes, and almost always worse under CI load than locally. The flake is a *real* signal about
the system: about ordering, timing, shared state, or resource coupling. The discipline is the
structural defence — a flake is treated as a `fix` whose oracle is a loop-run, and the `VERDICT`
of `PASS` cannot be recorded until the flake has been reproduced, root-caused, and the fix proven
by re-running the bound test under the conditions in which it failed.

This fragment stabilises an **existing** test. It is not for authoring new tests, not for feature
work whose tests fail deterministically, and not for a test that fails every single time after a
change — a 100%-deterministic failure is a different category of problem (a regression `fix`, or a
`feature` if the expected behaviour changed), not a flake.

## Consumes

- The flaky test under judgment, and the failing-run evidence that named it as flaky — the symptom,
  not yet the cause.
- The project's test command, resolved through `AGENTS.md > Commands` (the test slot). A flake is
  reproduced by *looping* a single test; the loop-runner ("run this test many times", a
  single-thread or seed-pinned mode, a CI matrix) is **not** in the standard Commands contract. If
  the project's loop mechanism is undefined, ask the user how the project loops one test — do not
  guess, because a guessed loop produces a false signal about reproduction.
- The conditions under which the flake last fired (CI vs local, parallel siblings, load, seed,
  clock). These are part of what gets reproduced; a flake reproduced only under *easier* conditions
  than it failed under is not yet isolated.

## Produces

- The pasted, verbatim loop-run output that *reproduces* the flake — the proof that the
  nondeterminism is real and characterised, not a one-off.
- The root-cause diagnosis: which category of nondeterminism, and where in production code or test
  setup it lives (never in the assertion).
- The fix, plus the pasted loop-run output that *proves* the fix — the same test, looped under the
  conditions in which it failed, all runs passing.
- An inline one-liner at the cause site documenting the failure mode so it is recognisable next time
  (e.g. "session ID is seeded; do not draw it from a global RNG here").
- Where the root cause is in production code (a race, an unhandled rejection, a resource leak): a
  hand-off to a downstream production fix. This work produces the diagnosis and the now-stable test
  as that fix's regression guard.

## Preserves

- **The signal.** The flake says something true about the system. The fix removes the cause, not the
  message — the test still fails when the behaviour it guards is actually broken.
- **The bound oracle.** The test that named the flake is the test that proves the fix. The proof
  binds to *that* test, re-run, not to a fresh or weakened substitute.
- **Determinism.** After the fix, the test's outcome is a function of the code under test, not of
  ordering, scheduling, the clock, or a shared neighbour.

## Rejects

These MUST NOT yield a `PASS`. Each suppresses the signal instead of acting on it:

- **Re-run until green.** "It passed on the third try" is the bug, not the fix. A test that passes
  only sometimes has not been fixed by observing it pass once.
- **Add a sleep / bump the timeout.** The race is still there; a wider window just loses less often.
  Waiting is acceptable *only* when timing is part of a documented async contract — and then you
  wait on the contract (a settled state, an emitted event), never on a hope.
- **Quarantine as the resolution.** Skipping, marking-as-allowed-to-fail, or guarding the test
  behind an environment condition is containment — a way to keep the suite honest *while* a real fix
  is investigated — never the fix itself. Without an owner and a date it becomes a permanently
  disabled test.
- **Widen the assertion.** Loosening a check because the observed value drifts (asserting "greater
  than zero" where the value should be exact) masks the bug behind a check too weak to fire.
- **Fix the assertion instead of the cause.** The assertion is the messenger. Editing it to
  accommodate the nondeterminism hides the defect rather than removing it.
- **A repro you could not actually reproduce.** A flake that will not fire under looping is
  *un-isolated*, not *unreal*. Declaring it fixed without ever reproducing it is unfalsifiable — the
  fix has nothing to prove against.

## Procedure

1. **Reproduce before you claim to understand.** Loop the test until it fires, then loop it enough
   times that you trust the failure rate you observe. If it will not reproduce, broaden the
   conditions — run it under CI-like load, run it alongside its sibling tests, pin or vary the seed,
   advance the clock — rather than concluding it was never real. Paste the loop-run output that
   shows both passes and failures: that is the repro proof.
2. **Characterise the nondeterminism.** Name the category, because the category narrows the fix:
   - **Ordering** — the test depends on the order tests or operations run in (a shared fixture left
     dirty by an earlier test, an unsorted collection iterated as if ordered).
   - **Timing / concurrency** — a race: an assertion runs before an async result settles, two tasks
     interleave, a callback fires late.
   - **Shared state** — a global, a singleton, a module-level cache, a database row, or a temp file
     that one test mutates and another reads.
   - **Resource** — exhaustion or contention: ports, file handles, memory, connection-pool slots,
     disk, or a rate limit that bites only under load.
   A flake that mixes categories is split into separate fixes — each category root-causes
   differently.
3. **Find the root cause in production code or test setup, not in the assertion.** The cause lives
   in nondeterministic production code, in un-isolated setup/teardown, in the parallel-runner
   harness, or in the environment. Trace from the reproduced failure to the line that introduces the
   nondeterminism.
4. **Fix the cause; never mask it.** Make the outcome deterministic at the source: inject the clock
   or the RNG seed instead of reading the real one; isolate the shared state (fresh fixture per
   test, scoped teardown); wait on the actual contract instead of a sleep; reserve or release the
   contended resource correctly. Do not reach for the rejected shortcuts in `## Rejects` — they move
   the flake, they do not remove it.
5. **Prove the fix with the bound test, re-run.** Loop the *same* test, under the conditions in
   which the flake reproduced, enough times to trust the result — every run passing. Paste the
   loop-run output verbatim; a flake reproduced once and fixed once is not a flake proven fixed.
6. **Document the cause inline.** Leave a one-liner at the cause site naming the failure mode, so
   the next reader recognises it before reintroducing it.
7. **Hand off a production cause downstream.** If the root cause is a real production bug, this work
   produces the diagnosis and the now-stable test; the production fix is a separate downstream task
   guarded by that test.

## Output contract

The flaky-test fix records two pasted, verbatim, re-runnable proofs against the bound test — never a
paraphrase, never a prediction:

- **The repro proof** — the test, looped, showing it fails non-deterministically *before* the fix.
- **The fix proof** — the same test, looped under the conditions in which it failed, *all* runs
  passing *after* the fix.

Both are pasted as data into fenced blocks (the resolved loop command, the run, and the runner's
pass/fail tally), the way the proof discipline requires of any `VERIFY BY` binding. The `VERDICT`
this fragment backs is a `PASS` only when the fix proof shows every looped run passing; a single
failure among many is a `FAIL`, and a flake that could not be looped (no defined loop-runner, an
environmental block) is `BLOCKED`, never a silent `PASS`.

This fragment defines no new block, verdict value, proof type, or lint code. The repro and fix
proofs land in the trace and verdict containers the `implement` and `verify` passes already own; the
`empirical-proof` fragment governs how the bytes are pasted.

## Self-review delta

When this fragment is composed into a `fix` pass, the pass's self-review additionally confirms:

- The flake was **reproduced** before any claim to understand it — the repro proof is pasted, and it
  was reproduced under conditions no easier than those it originally failed under.
- The **category** of nondeterminism is named (ordering / timing / shared state / resource), and any
  mixed-category flake was split.
- The fix removed the **root cause** in production code or test setup — not in the assertion, not by
  a sleep, a timeout bump, a widened check, or quarantine.
- The **fix proof** is pasted: the same bound test, looped under the failing conditions, every run
  passing — not a single observed pass.
- The cause is **documented inline**, and any production-side root cause was handed off downstream
  with the stabilised test as its regression guard.

## Common evasions and the response

The reasoning toward any of these should be met by running the loop and pasting the output — the
point is to make skipping reproduction a visible cost, not to win an argument.

| 🚩 Evasion                                              | Response                                                            |
| ------------------------------------------------------- | ------------------------------------------------------------------- |
| "It passed when I re-ran it, so it's fixed."            | A pass after a re-run is the bug, not the fix. Loop it and prove it. |
| "I added a small sleep and it stopped failing."         | The race is still there; the window just got wider. Wait on the contract or fix the cause. |
| "I can't reproduce it, so there's nothing to fix."      | It is un-isolated, not unreal. Broaden conditions: load, parallel siblings, seed, clock. |
| "I loosened the assertion so it tolerates the drift."   | A check too weak to fire isn't a proof. Fix what makes the value drift. |
| "I marked it skipped to keep CI green."                 | That is containment with an owner and a date — not the fix. The cause is still live. |
| "The fix is obvious from the diff."                     | A diff does not loop the test. Loop it under the failing conditions; paste the output. |
| "It only flakes in CI, and I can't run CI locally."     | Reproduce the CI conditions (load, parallelism, seed) or surface it as `BLOCKED` — not a silent `PASS`. |
