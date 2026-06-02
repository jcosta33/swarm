---
name: write-performance
description: Optimise a measured bottleneck under a target. ALWAYS apply this skill when the user asks to optimise, profile, speed up, reduce latency / memory / CPU, or hit a perf target — under a stated metric and measurement condition. Do not change code without first establishing a baseline, compare benchmarks under different conditions, or skip the test suite because "it's just a perf change". Skip this skill for correctness fixes against a defect or net-new feature work against a spec — performance work is targeted optimisation, not opportunistic.
---

# Skill: write-performance

## Purpose

Performance work fails in two characteristic ways: a number that improved on the benchmark but not in production, and a speedup that quietly broke correctness. This skill is the discipline against both: numbers, not vibes; same protocol before and after; never regress correctness for speed.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Test`. A benchmark command is not in the standard contract; performance work needs one — ask the user which command to use and record it in the task file's `Measurement protocol`. If `AGENTS.md` is missing or an entry is undefined, ask the user before establishing a baseline — do not invent or guess.

## Core rules

### 1. Measure first; do not optimise from intuition

Establish a baseline benchmark in your worktree before changing any code. The baseline is real numbers from a real run, not "we know it's slow". Without a baseline, "improvement" has no meaning.

### 2. State the target as a number under conditions

The target is a specific value of a specific metric under specific conditions: "p95 latency of `getQuote()` under 1k RPS sustained load drops from 240 ms to ≤ 80 ms". "Make X faster" is not a target.

### 3. State the hypothesis as a falsifiable claim

What do you believe is the bottleneck, and what measurement would disprove it? "Allocations in the hot loop dominate; reducing them by 50% should drop latency by ≥ 30%" is falsifiable. "I think this is slow" is not.

### 4. Same protocol before and after

The measurement protocol — warmup runs, sample count, statistical aggregate (mean / median / p95 / p99), hardware, environment — must be identical for baseline and final. Different conditions give different numbers; the comparison is meaningless.

### 5. Every change is benchmarked

Each iteration: change → re-run the benchmark → compare to baseline. Don't batch optimisations; you can't tell which one mattered. Don't skip benchmarks because "I'm sure this helps".

### 6. Run the full test suite after every change

A speedup that broke correctness is a bug in performance clothing. The project's test command runs after every change. Performance work does not get to skip the test suite.

### 7. Document the conditions

The speedup holds *under specific conditions*. Document them: which input shape, which load profile, which hardware, which warm/cold cache state. Whoever inherits the code needs to know when the optimisation might stop helping.

### 8. Readability is on probation

If the optimisation made the code harder to read, the cost is real. Document why the readability tradeoff is justified and add a comment at the call site explaining what the unusual structure is for. Otherwise it gets unwound by the next refactor.

### 9. Define a hard ceiling

The regression threshold below which the change is rolled back regardless of other improvements. Without a ceiling, "small regression on metric Y for big improvement on metric X" creeps into shipping.

## What does not belong

- **In a performance task:** "feels faster" without measurement; optimisations bundled across unrelated bottlenecks; measurements taken under different conditions for baseline vs. final.
- **In `## Decisions`:** "the optimisation worked" — that's a verification output, not a decision.

## Anti-patterns

- "It feels faster" without measurement
- Optimising without a baseline
- Skipping the test suite because "it's just a perf change"
- Comparing benchmarks under different conditions
- Making the code unreadable for marginal gains
- Bundling optimisations so you can't attribute the gain

## Bundled resources

- `references/task-template.md` — a fillable performance-task template with baseline block (benchmark command, conditions, key metric, measurement), target block (target value, hard ceiling), hypothesis, measurement protocol, progress checklist, and a self-review hard gate covering baseline-and-target proof, correctness preservation, conditions and generality, and the readability tradeoff.

Copy it into your project's task file location, substitute the `{{...}}` placeholders, and fill it in as you work.
