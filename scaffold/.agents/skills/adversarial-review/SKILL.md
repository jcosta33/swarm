---
name: adversarial-review
description: Load when reviewing a worker's branch, deepening an existing audit, root-causing a bug, or auditing a codebase area. Encodes the Skeptic's six adversarial questions, the cross-module caller search, and the "run validation yourself" rule.
---

# Skill: adversarial-review

## Purpose

Reviews fail when the reviewer accepts the worker's framing. The discipline of *adversarial review* is to set the worker's claims aside, read the code with fresh eyes, and run the validators yourself. This skill is what The Skeptic uses; The Auditor and The Bug Hunter use it too because the same hostility-to-plausible-explanations applies.

## Core rules

### 1. Run validation yourself

The reviewer runs `{{cmdInstall}}`, `{{cmdValidate}}`, `{{cmdTest}}` themselves, in their own worktree, with the branch checked out. The worker's pasted output is *evidence the worker ran the command at some past moment*; it is not evidence the command passes *now in your worktree*.

### 2. The six adversarial questions

For every diff, walk these six questions in order:

1. **What was the intent?** State, in your own words, what the change is supposed to do. If you can't, the diff is unclear or you haven't read enough.
2. **Does the code do it?** For each acceptance criterion / each "Needed" entry / each bug-report root cause, point at the lines that address it.
3. **What didn't change that should have?** Renamed types, callers, tests, docs, dependency-graph rules. Often the bug is in *unchanged* code that needed updating.
4. **What edge cases are unhandled?** Empty input, max-size input, concurrent calls, partial state, unicode, time-zone boundaries — pick the ones relevant to the change and check.
5. **What production failure modes are possible?** Network errors, race conditions, resource exhaustion, retry storms, rate-limit collisions.
6. **What was claimed but not verified?** Comb the worker's task file for "should never", "harmless", "by happy accident" — these are confessions of unverified assumptions.

Each question gets answered explicitly. If a question doesn't apply to this change, state that — don't skip silently.

### 3. Cross-module caller search

For every changed public surface, grep the codebase for callers. Read the calling code, not just the changed module. Lifecycle bugs, id-collision hazards, and contract mismatches live in the calling code as often as in the modified module.

```bash
git grep -n '<changed-symbol>' src/ tests/
```

Paste the output (or summarise the call-site count and read each).

### 4. Findings cite file and line

Every finding has:

- **Severity** (BLOCKER / MAJOR / MINOR)
- **File:line**
- **Specific issue** (what is wrong, not just "looks rough")
- **Fix sketch** (what would close it)

Vague concerns are not findings. Either sharpen them to file-line-specific findings, or remove them.

### 5. Mistrust confident-sounding language

Worker task files often contain:

- "Should never happen…"
- "Harmless edge case…"
- "By happy accident, this still works…"
- "Edge case unlikely to fire…"

These are *confessions of unverified assumptions*, not assurances. Investigate each one.

### 6. Do not trust the diff to be the work

The Skeptic verifies that the worker's small diff is actually the work that was asked for. A diff that touches 3 files when the spec called for 8 is *evidence* something was missed (or the scope is misunderstood).

## What does not belong

- **Style preferences as findings.** Style consistency is a finding when it violates project convention; "I'd write it differently" is not.
- **Soft-language findings.** "Maybe consider possibly looking at…" — sharpen or remove.
- **Findings without fix sketches.** "X is wrong; figure it out" wastes the worker's time.
- **Approving without running validation yourself.**

## Anti-patterns

- Approving a branch because the worker's Self-review claims everything passed
- Reviewing only the diff and missing the unchanged callers
- Soft-language findings
- Inheriting the worker's framing instead of reading the code with fresh eyes
- Demoting findings to "MINOR" to avoid blocking the worker
- Approving a small diff without confirming the small diff is the right work

## Interaction with other skills

- **`empirical-proof`** is the discipline of pasting verification output. `adversarial-review` is the discipline of *running it yourself* and *walking the diff hostilely*. The two pair: paste your own outputs (not the worker's), and walk the diff with the six questions.
- **`personas`** loads the persona profile. For The Skeptic / The Bug Hunter / The Auditor, the persona profile leans on this skill explicitly.
- **`documentation-gatekeeper`** enforces that the *kind* of work matches the task type. `adversarial-review` enforces that the *quality* of review meets the bar.

## See also

- `.agents/skills/personas/SKILL.md` — the personas that use this skill (The Skeptic, The Auditor, The Bug Hunter)
- `.agents/skills/empirical-proof/SKILL.md` — sister skill
- `.agents/templates/task-review.md` — where this skill is the workhorse
