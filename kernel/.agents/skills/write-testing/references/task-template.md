# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: testing

---

> **TESTING SESSION** — Test behavior, not implementation. Every test should fail for one specific reason; flip the assertion and the test should still mean something. Coverage numbers are a smell, not a target.
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

What is being tested, what coverage gap is being closed, and why now. One paragraph maximum.

---

## Linked docs

- Driving doc (spec, audit, bug-report): `{{specFile}}`

---

## Coverage gap

<coverage_gap>

The behavior currently untested or undertested. Be specific: which module, which behavior, which conditions.

</coverage_gap>

---

## Test cases

<test_cases>

The cases this task adds. Each case names the behavior, the inputs, and the expected outcome. One test per row, one reason to fail per test.

| Behavior | Inputs / setup | Expected outcome | Reason this test exists |
| -------- | -------------- | ---------------- | ----------------------- |
|          |                |                  |                         |

</test_cases>

---

## Test placement

<test_placement>

Where each test goes per the project's testing conventions. Load any project-specific testing-layout skill to confirm.

| Test case | File path | Test runner |
| --------- | --------- | ----------- |
|           |           |             |

</test_placement>

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Test behavior, not implementation; exercise the public surface
- One test, one reason to fail; do not bundle assertions across unrelated behaviors
- Place tests where the project's testing layout dictates
- Coverage numbers are a smell — a covered line that's poorly tested is worse than an uncovered one
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/audits/`, `.agents/bugs/`, `docs/`, and `AGENTS.md` as needed.

---

## Progress checklist

- [ ] Load any project-specific testing-layout skill
- [ ] Identify the coverage gap
- [ ] Enumerate test cases (the table above)
- [ ] Decide test placement (the table above)
- [ ] Write each test
- [ ] Verify each test fails when its assertion is flipped (proves the test actually tests something)
- [ ] Restore the assertions; verify each test passes
- [ ] For any test that is the oracle for a spec acceptance criterion: confirm it asserts the criterion's behavior (fails when the *criterion* is violated), not an adjacent condition
- [ ] `{{cmdTest}}` passes overall
- [ ] `{{cmdTest}}` coverage report shows the new behavior covered
- [ ] `{{cmdValidate}}` passes
- [ ] Self-review: Verification outputs pasted (`{{cmdTest}}`, coverage report, `{{cmdValidate}}`, assertion-flip proof)
- [ ] Self-review: Criterion encoding answered (or `n/a`)
- [ ] Self-review: Behavior over implementation answered
- [ ] Self-review: Failure mode clarity answered
- [ ] Self-review: Placement answered
- [ ] Self-review: Robustness answered

---

## Decisions

- ***

## Findings

If writing the tests revealed surprising behavior or hidden bugs, note them. Move durable findings to a bug report or audit.

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

Concrete starting points for the next session if this one ends incomplete.

- ***

## Self-review

Stop. Tests that pass when commented out, tests that test internals, and tests that bundle unrelated assertions are net-negative — they take maintenance and don't catch bugs. Act as a senior engineer hostile to all three.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- `{{cmdTest}}` (last 2 lines):
- `{{cmdTest}}` coverage report (the new behavior is covered — paste the relevant lines, or `n/a` with reason if the project has no coverage tooling):
- `{{cmdValidate}}` (last 2 lines):
- Assertion-flip proof — for each new test, output proving it fails when the assertion is flipped, then passes when restored (paste a representative sample):

### Criterion encoding (for any test that is the oracle for a spec acceptance criterion)

- Does each acceptance-criterion-bound test assert the behavior the *criterion* describes, in the criterion's own terms — not merely an adjacent passing condition? Map criterion → test → asserted behavior, and confirm the test fails when the *criterion* is violated. If no such criterion applies, write `n/a`. If a criterion could not be turned into a fail-when-violated test, record it as a finding for the spec author (the binding should be `command` or `manual`).
  Answer:

### Behavior over implementation

- Do the tests exercise the public surface, or did they reach into internals (private methods, module-private state)? Will the tests survive a reasonable refactor that preserves behavior?
  Answer:

### Failure mode clarity

- Does each test fail for one specific reason? When a test fails, will the failure message tell the developer what behavior broke? Did you confirm by flipping each assertion?
  Answer:

### Placement

- Is each test placed per the project's conventions? Did you consult the project's testing-layout skill rather than guessing?
  Answer:

### Robustness

- Are the tests deterministic? Do any depend on ordering, timing, or shared state that could make them flaky? Did you exercise them under conditions a CI environment might surface?
  Answer:

### Final Polish

- Did you ask yourself: "What behavior is still untested that I should have covered? What pass would still pass if the code were broken in ways my tests don't exercise?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.
