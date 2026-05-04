# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: performance

---

> ⚠️ **PERFORMANCE SESSION** — Numbers, not vibes. Every change is benchmarked before and after. Never regress correctness for speed; the test suite must pass after every change.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Performance Surgeon** persona.

---

## Objective

What is being optimized, on what input, under what conditions. One paragraph maximum. "Make X faster" is not an objective; "reduce p95 latency of X under load Y from N ms to M ms" is.

---

## Linked docs

- Spec / audit / bug-report driving this work: `{{specFile}}`

---

## Baseline

<baseline>

The measured starting point. Do not optimize until this is filled in with real numbers from your worktree.

**Benchmark command:** `{{cmdBenchmark}}` _(or specific invocation)_

**Conditions:** environment, input, load profile that the benchmark exercises.

**Measurement:**

```
[paste actual benchmark output here]
```

**Key metric:** _(the one number that matters — p95 latency, throughput, allocation count, etc.)_

</baseline>

---

## Target

<target>

The number you must hit and the conditions under which it must hold. Be specific.

**Target metric:** _(same metric as baseline)_

**Target value:**

**Hard ceiling:** the regression threshold below which the change is rolled back regardless of other improvements.

</target>

---

## Hypothesis

<hypothesis>

What you believe is the bottleneck and why. Frame as a falsifiable claim — a measurement that would disprove the hypothesis.

</hypothesis>

---

## Measurement protocol

<measurement_protocol>

How you measure. The protocol must be the same before and after — different conditions give different numbers and the comparison is meaningless.

- Warmup runs:
- Sample count:
- Statistical aggregate (mean / median / p95 / p99):
- Hardware / environment notes:

</measurement_protocol>

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Measure before changing code; do not optimize from intuition
- Every change is benchmarked before and after with the same protocol
- Run `{{cmdTest}}` after every change — never regress correctness
- Distinguish "faster" from "faster on this input under this load"; document conditions
- If your fix makes the code unreadable, document why the readability cost is justified
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/research/`, `.agents/audits/`, `docs/`, and `AGENTS.md` as needed.

---

## Progress checklist

- [ ] Define baseline above (benchmark command, conditions, key metric)
- [ ] Run baseline benchmark; paste output
- [ ] Define target above
- [ ] Define measurement protocol above
- [ ] State hypothesis (the falsifiable claim about the bottleneck)
- [ ] Profile if applicable; paste profile data
- [ ] Implement first change
- [ ] Re-run benchmark; compare to baseline
- [ ] `{{cmdTest}}` passes (no correctness regression)
- [ ] _… iterate per change …_
- [ ] Final benchmark meets target
- [ ] Final test suite passes
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Baseline and target answered
- [ ] Self-review: Correctness preservation answered
- [ ] Self-review: Conditions and generality answered
- [ ] Self-review: Readability tradeoff answered

---

## Decisions

- ***

## Findings

Performance investigation often surfaces architectural smells (allocations on hot paths, cache pollution, etc.). Note them here. Move durable findings into an audit if they extend beyond the optimization at hand.

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

<self_review>

Stop. Performance work fails in two ways: a number that improved on the benchmark but not in production, and a speedup that quietly broke correctness. Act as a senior engineer hostile to both.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Baseline `{{cmdBenchmark}}` output:
- Final `{{cmdBenchmark}}` output:
- Final `{{cmdTest}}` (last 2 lines):
- Final `{{cmdValidate}}` (last 2 lines):

### Baseline and target

- Did you measure the baseline before changing code? Did the final benchmark hit the target under the same conditions as the baseline? Are both outputs pasted, not paraphrased?
  Answer:

### Correctness preservation

- Did `{{cmdTest}}` pass after every change? Are there test paths your benchmark exercises that the suite doesn't cover (you might need to add them)? Could the optimization fail on inputs the benchmark doesn't include?
  Answer:

### Conditions and generality

- Under what conditions does the speedup hold? Does it survive different inputs, different load profiles, different hardware? Are the conditions documented for whoever inherits the code?
  Answer:

### Readability tradeoff

- If the optimization made the code less readable, is the cost justified by the speedup? Did you document the rationale at the call site? Is there a comment explaining what the unusual structure is for?
  Answer:

### Final Polish

- Did you ask yourself: "What might still be slow that I didn't profile? Could the speedup be giving back what it gained somewhere downstream?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
