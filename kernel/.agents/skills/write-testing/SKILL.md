---
name: write-testing
description: Add or improve test coverage. ALWAYS apply this skill when the user asks to add tests, increase coverage, write a regression test, or improve an existing test suite — including for a feature, fix, or audit "Needed" item. Do not test implementation details, skip the assertion-flip proof, or modify production code to make a test pass without spec authorisation. Skip this skill if the task is implementing or fixing code itself — tests are part of those deliverables, not a separate phase.
---

# Skill: write-testing

## Purpose

Tests that pass when commented out, tests that test internals, and tests that bundle unrelated assertions are net-negative — they take maintenance and don't catch bugs. This skill is the discipline that keeps tests honest: behaviour-focused, one-reason-to-fail, robust against refactors that preserve behaviour.

Tests are specifications by other means. A good test fails for one reason, exercises the behaviour the user-or-caller cares about, and survives a reasonable refactor of the implementation. A test that's testing the implementation is a maintenance burden disguised as a safety net.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Test`, `Commands > Validation`. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before declaring a new test "passing" — do not guess.

## Core rules

### 1. Test behaviour, not implementation

Exercise the public surface. Do not reach into private methods, module-private state, or other internals. A test that breaks when the implementation refactors *but the behaviour is preserved* is a bad test.

### 2. One test, one reason to fail

Each test asserts one specific behaviour. Bundling multiple unrelated assertions into one test means a failure tells the developer "something broke" without saying *what*. Split.

### 3. Flip the assertion to prove the test means something

After writing each test:

- Flip its assertion (or comment out the production code path it exercises).
- Run the test → must fail.
- Restore → must pass.

Paste a representative sample of the failing-then-passing transition into the self-review. A test that passes when the assertion is flipped tests nothing.

### 4. A test bound to an acceptance criterion must encode that criterion's intended behaviour

When a test is the oracle for a spec acceptance criterion (the criterion's check binding is `test`), two things must hold, and they are *separate* proofs:

- **The assertion-flip proves the test fires** — flip it and it fails (rule 3). This shows the test is not a tautology.
- **The criterion mapping proves the test fires for the right reason** — the test must assert the *behaviour the criterion describes*, not merely some passing condition near it. A green test that exercises an adjacent code path satisfies the flip but does not verify the criterion.

So for each `test`-bound criterion, record the mapping explicitly: criterion → the test that is its oracle → the specific behaviour asserted, in the criterion's own terms. The oracle must fail when the *criterion* is violated (not just when any line changes) and pass when the *criterion* is satisfied. If you cannot construct a test that fails-when-the-criterion-is-violated, the criterion is not actually `test`-bindable — that is a finding for the spec author (the binding should be `command` or `manual`), not licence to ship a test that merely passes.

### 5. Place tests per the project's conventions

Don't guess test placement. If the project has a testing-layout convention (file naming, directory placement, runner config), follow it. If multiple conventions exist, pick the one closest to the code under test and document the choice.

### 6. Coverage numbers are a smell, not a target

A covered line that's poorly tested is worse than an uncovered one — it gives a false sense of security. Targeting "85% coverage" produces shallow tests. Focus on what behaviour deserves a test, not on the percentage.

### 7. Failure messages must be useful

When a test fails, the failure message should tell the developer what behaviour broke. Use descriptive test names, descriptive assertion messages where the runner supports them. "AssertionError: expected true" tells the developer nothing.

### 8. Tests must be deterministic

Avoid ordering dependencies, timing dependencies, shared mutable state, network calls without sandboxing, randomness without seeding. Flaky tests train developers to ignore failures — the worst outcome.

### 9. Do not modify production code to make tests easier

Unless the spec authorises it. The test exists because of the production code's behaviour; bending the production code to suit the test inverts the dependency. If the code is genuinely hard to test, that's a finding (promote to an audit), not licence to weaken the production code.

## What does not belong

- **In a test:** assertions on internal state, multiple unrelated behaviours bundled, ordering dependencies, time-of-day dependencies.
- **In a testing task:** chasing coverage percentages, refactoring production code "while you're here" to make testing easier (without spec authorisation).

## Anti-patterns

- Testing implementation details (private methods, internal state)
- Bundling assertions across unrelated behaviours
- Chasing coverage numbers for their own sake
- Tests that pass even when commented out
- A criterion-bound test that flips correctly but asserts an adjacent behaviour, not the criterion itself
- Modifying production code to make tests easier (unless spec authorises)
- Flaky tests left flaky ("it usually passes")

## Bundled resources

- `references/task-template.md` — a fillable testing-task template with coverage-gap block, test-cases table (behaviour / inputs / expected outcome / reason this test exists), test-placement table, progress checklist that includes the assertion-flip step, and a self-review hard gate covering the required verification suite (the project's test command and coverage report), the assertion-flip proof, the criterion-encoding mapping (for any acceptance-criterion-bound test), behaviour-over-implementation, failure-mode clarity, placement, and robustness.

Copy it into your project's task file location, substitute the `{{...}}` placeholders, and fill it in as you work.
