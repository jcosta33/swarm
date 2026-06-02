---
name: fix-flaky-test
description: Diagnose and stabilise a flaky test. ALWAYS apply this skill when the user reports non-deterministic test failures, when CI shows occasional failures of the same test, when a test is quarantined / `.skip`'d for flakiness, or when the user says "passes locally but fails in CI" — even without the word "flaky". Do not re-run until green and declare it fixed, add sleeps or longer timeouts as the fix, swallow the nondeterminism in try/catch, or quarantine as the resolution. Skip this skill for deterministic failures, authoring tests from scratch, or feature work whose tests fail.
---

# Skill: fix-flaky-test

## Purpose

A flaky test is a test that fails non-deterministically — sometimes pass, sometimes fail, often more flaky in CI than locally. The failure mode this skill exists to prevent: re-running until green, calling it fixed, and shipping a bug. Flakiness is almost always a real signal — about timing, ordering, shared state, or environmental coupling — and the only acceptable resolution is identifying the root cause and removing it. This skill enforces reproduction first, categorisation, root-cause-not-symptom, and a quantitative re-run proof before declaring the test stable.

## Project context (the AGENTS.md contract)

Resolves the test command via the consuming repo's `AGENTS.md > Commands > Test`. A loop-runner ("run this test 500 times") is not in the standard contract; ask the user how the project loops a single test (e.g. `pnpm test --runInBand --testNamePattern=… --repeat=500`, `cargo test -- --test-threads=1`, custom CI matrix). If `AGENTS.md` is missing or the test command is undefined, ask before declaring reproduction reliable — guessing the command produces false signals.

## Core rules

### 1. Reproduce the flake before claiming you understand it

Loop the test repeatedly — typically 100×, often 500×–1000× for low-frequency flakes — until it fires. If the flake won't reproduce in 1000 runs, broaden the conditions: run in CI, run under load, run with a different seed, run in parallel with sibling tests. A flake that won't reproduce is *un-isolated*, not *unreal*.

### 2. Categorise the source

Every flake belongs to one of a small set of categories. Naming the category narrows the fix:

- **Timing / ordering** — test depends on a `setTimeout`, polls without bound, or assumes operation A finishes before operation B
- **Shared state** — module-level state, singleton caches, file-system fixtures, database rows mutated by another test
- **Network / external service** — real HTTP, real DNS, an unmocked clock, a flaky test container
- **Randomness** — unmocked `Math.random`, unmocked UUID generation, unseeded shuffles
- **Time** — unmocked `Date.now`, time-of-day-dependent assertions, DST boundaries
- **Resource exhaustion** — file handles, ports, database connections, memory pressure under parallel runs
- **Environment** — locale, timezone, hostname, env vars, `NODE_ENV`, terminal width, ANSI

The category appears in the task file's `## Flake category` field. Mixed-category flakes get split into separate fixes.

### 3. Find the root cause in production code or test setup, not in the assertion

The assertion is the messenger. The cause lives in:

- the production code's nondeterminism (un-seeded random, un-mocked time, race condition)
- the test's setup / teardown (shared state not isolated)
- the test's harness (parallel runners on shared resources)
- the environment

Modifying the assertion to *accommodate* nondeterminism is hiding the bug. Modifying the production code or the test harness to *remove* nondeterminism is the fix.

### 4. Reject "add a sleep" / "increase the timeout" patches — unless timing is part of the contract

`await sleep(500)` "fixes" the symptom by widening the window in which the race condition is rare. The race is still there. The legitimate exceptions are narrow: the system-under-test genuinely has a documented async contract (e.g. *"the cache eviction job runs at 1Hz"*), in which case the test waits on the contract, not on a hope. In every other case, sleep-based patches are escalations of the bug, not fixes.

### 5. Reject quarantine as the resolution

`.skip`, `.fail`, conditional `it.if(env)` blocks, and `// TODO unflake` markers are containment, not resolution. Quarantine has its place — keeping CI green while a real fix is investigated — but it is *not* the fix. A quarantine that does not have a tracking issue and a date is a permanent disabled test.

### 6. Verify the fix by loop-running 100×–1000× and pasting the output

A flake reproduced once is not a flake fixed once. The fix is verified by running the test repeatedly under the same conditions in which the flake reproduced, with all runs passing. The pasted output (last lines or pass/fail summary) lives in `## Self-review > Verification outputs`. Without this, "I think it's fixed" is unfalsifiable.

### 7. Document the cause inline

A short note in the test file or in the production code (a one-liner — *"// session ID is seeded; do not use Math.random here, see <task slug>"*) makes the failure mode recognisable next time. Without the note, the next contributor with a similar problem rediscovers the cause from scratch.

### 8. If the root cause is in production code, hand off to a downstream fix task

A flaky test is sometimes the symptom of a real production bug (race condition, unhandled rejection, resource leak). When the cause lies in production code rather than in test setup, the proper resolution is a downstream bug-fix task targeting the production bug — with the regression test being the existing flaky test, now stable. This skill produces the diagnosis; the production fix is downstream.

## What does not belong

- **Authoring new tests.** That belongs in test-authoring work. This skill stabilises an existing test.
- **Feature work that happens to break tests.** A feature whose tests fail deterministically is feature-implementation work, not stabilisation.
- **Deterministic test failures.** *"Test fails 100% of the time after my change"* is bug-fix work (if a regression) or feature work (if the feature changed expected behaviour) — not flake stabilisation.

## Anti-patterns

- ❌ *Re-running until green.* "Three reruns later it passed" — that's the bug, not the fix.
- ❌ *`await sleep(500)` as the fix.* The race condition is still present; the window just got wider.
- ❌ *Quarantining without a tracking issue.* `.skip` becomes permanent the moment it lands without a follow-up date.
- ❌ *Try / catch on the source of nondeterminism.* Swallowing the error suppresses the assertion's signal.
- ❌ *"Works on my machine" without reproducing in CI.* Local determinism is not global determinism. Reproduce where the flake fires.
- ❌ *Assertion-flipping the symptom.* Changing `expect(x).toBe(5)` to `expect(x).toBeGreaterThan(0)` because the value drifts is widening the assertion to mask the bug.
- ❌ *Declaring stable after one passing run.* The verification is loop-run output, not a single green tick.

## Bundled resources

- [`references/task-template.md`](./references/task-template.md) — task-file scaffold for a flaky-test session. Includes the category field, the loop-run reproduction protocol, and the verification table.
