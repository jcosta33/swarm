---
name: write-bug-report
description: Author a bug-report. ALWAYS apply this skill when the user reports a bug, observed defect, regression, or unexpected behaviour — including when the symptom is reproducible only intermittently. Do not include the fix in the bug-report, conflate symptom with root cause, or finalise the report without a verbatim reproduction output pasted into it. Skip this skill for fixing the bug (a separate downstream task once the report is in hand) or authoring a present-state audit — a bug-report is a defect record, not a fix and not a survey.
---

# Skill: write-bug-report

## Purpose

A bug report is the input to a fix task. The fixer must be able to patch from the report alone, with zero re-investigation. This skill is the discipline that gets the report there.

## Project context (the AGENTS.md contract)

The reproduction step (rule 1) requires running the project's test or runtime entry point. Resolve via the consuming repo's `AGENTS.md`: `Commands > Test` for test-suite reproductions, plus any project-specific run/start command for runtime defects. The pasted reproduction output (rule 8) must come from one of these commands. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run — do not guess.

## Core rules

### 1. Reproduce before explaining

A bug is a hypothesis until reproduced. If you cannot reproduce, *say so* — don't speculate about the cause. The reproduction command output is the proof that the bug fires.

### 2. Isolate to the smallest reproduction

Once reproduced, narrow it: minimal input, minimal env, fewest steps. The reproduction in the final report is *the* reproduction; all the attempts that didn't repro are noise (capture them in `## Reproduction attempts` for context but don't lead with them).

### 3. State the root cause precisely

The root cause is *file:line + state + input + caller*. The symptom alone is not the cause.

- ❌ "The function returns null."
- ✅ "`getPricing()` (`src/billing/pricing-adapter.ts:42`) returns null when the cache is cold and the upstream Stripe call is rate-limited; the caller `quote.ts:88` interprets null as 'fallback to default tier' instead of throwing."

### 4. Distinguish observation from inference

- **Observation:** "Reproduction fires deterministically with `NODE_ENV=production` and 12 MB input."
- **Inference:** "The proxy is dropping bytes."

Both are useful; conflating them obscures the trail. Mark inferences in `## Hypothesis tracker` with status `[supports]` / `[disproven]` / `[confirmed]`.

### 5. Search for related defects

For every root cause, grep the codebase for the *pattern* (not just the file). Note related vulnerabilities. The fix task may expand scope to include the related cases (or spawn a separate bug-report).

### 6. Propose a regression test

Identify the test that would catch the regression. State its location and assertion. If the project's test framework makes the test difficult to write, note the gap.

### 7. Adversarial mindset

A bug report that gets the cause wrong wastes the fixer's session and lets the bug ship. Mistrust your own first plausible explanation. If you find yourself stopping at the first hypothesis that fits, push past it: "Could the cause be elsewhere? Have I disproven the alternatives?"

### 8. Pre-deliver visibility gate (forced visible output)

Do not finalise the bug-report until you have pasted the failing reproduction output verbatim into `## Reliable reproduction`. Before declaring the report done, the section must contain:

```markdown
## Reliable reproduction

**Command:** <exact command>

**Output (verbatim):**

\`\`\`
<paste full failing output here, unedited>
\`\`\`

**Determinism:** fires every run / fires N of M runs / [unable to reproduce]
```

A `## Reliable reproduction` section without verbatim pasted output, or marked `[unable to reproduce]` without an explanation in `## Reproduction attempts`, means the report is not finalisable. The agent does not deliver the bug-report to the user until the section is filled with verbatim output (or an explicit `[unable to reproduce]` justification).

## What does not belong

- **In a bug report:** the fix. The fix is a downstream task.
- **In `## Root cause`:** speculation. State only what's verified.
- **In `## Reliable reproduction`:** "should reproduce" or "in theory". Either it reproduces deterministically, or you mark the report as `[unable to reproduce]` and document why.

## Anti-patterns

- Reporting the symptom as the bug
- Speculating about cause without reproducing
- Conflating "I think this is the problem" with "I have proven this is the problem"
- Bug reports that read as "module X is broken"
- Fixing the bug instead of reporting it
- Skipping the related-defects search

## Why bug-report is its own meta-task

The diagnosis and the fix have *different mindsets*, *different empirical proofs*, and *different ways of being wrong*. Splitting them into two tasks lets each session be done well:

- **bug-report-writing:** forensic, hypothesis-driven, read-only on code.
- **fix:** adversarial about the patch, runs the regression test, verifies the cause.

A combined "diagnose-and-fix" task tends to short-circuit the diagnosis at the first plausible explanation. The split forces the diagnosis to stand on its own.

## Bundled resources

- `references/task-template.md` — a fillable bug-report-writing task template combining the workflow scaffold (metadata, AGENTS.md contract, constraints, progress checklist, decisions, self-review for reproduction reliability and root-cause depth) with the deliverable structure inlined as a `## Deliverable` block (reported behaviour, reliable reproduction, reproduction attempts history, hypothesis tracker, root cause, related defects, regression test plan, open questions, Distillation Loss Statement). At session close, copy the `## Deliverable` block to its final home (`<your-bugs-dir>/{{slug}}.md`).

Substitute the `{{...}}` placeholders and fill in as you work.
