---
type: adr
id: adr-0109
status: accepted
created: 2026-06-26
updated: 2026-06-26
---

# ADR-0109 — Output economy: a readable, economical agent-output convention (a floor, not a hook)

## Context

Agent output drifts verbose: persuasive prose, restated context, ceremony. Verbosity costs reader
attention and tokens, and — the non-obvious part — **long explanatory prose can make a reader trust the
output more, not check it more** ([[OVERRELIANCE-REVIEW]]: explanations often persuade rather than help
evaluation; more detail can worsen over-reliance). Suspec already implies the cure piecemeal — the
vocabulary tiers ([ADR-0057](./0057-practical-first-repositioning.md)), the ~100-line always-on
AGENTS context budget, and the format-tax evidence ([[FORMATFREE]]: format restriction *during*
reasoning degrades it; structure the frame, reason free-form, then emit the structured artifact). What
is missing is a single, stated **output convention** an agent (and a worker definition) can follow.

A maximal version of this exists as a third-party tool (the "caveman" output-compression plugin, hook-
enforced with intensity levels). Suspec deliberately does **not** copy that mechanism: a hook that
rewrites output is enforcement, and the framework is reconcile-only / honest-levels — it does not
enforce style, and an over-terse default risks the misread the caveman tool itself carves out (it drops
to normal prose for safety/confirmations/multi-step sequences). Suspec wants the *economy*, set at a
gentle floor, with the *dial* left optional.

## Decision

**A convention floor, plus an optional dial — never a hook.**

1. **Output convention (floor).** Agent-produced output (run summaries, reviews, findings, decisions,
   chat) SHOULD be: **evidence-first** (the finding/result + its evidence before any prose); **structure
   over prose** (tables/lists where they carry the same signal in less space); **signal-dense** (no
   filler, no restating the prompt, no persuasion); **free-form reasoning, structured emission** (reason
   in whatever form thinks best, then emit the lean artifact — [[FORMATFREE]]); and **justification
   sized to make checking cheap, not to convince** ([[OVERRELIANCE-REVIEW]]). _Level: convention._
2. **Clarity outranks brevity.** The floor never compresses at the cost of correctness or safety:
   security notes, irreversible-action confirmations, and multi-step sequences where order matters stay
   in full, unambiguous prose. Brevity is the default, not a mandate.
3. **An optional concision skill is the dial** (suspec-skills) for teams/agents that want stronger
   economy. It is opt-in conditioning, not a Suspec requirement and not a runtime hook.

## Consequences

- A stated floor every worker definition can point at, consistent with the vocab tiers and the context
  budget — readability and token economy without a new mechanism.
- **Not enforced.** No hook, no `checks.yaml` rule, no contract change. A reconcile pass MAY later note
  egregious verbosity as an advisory, but style is not gated (ADR-0063; ADR-0077 D8).
- The convention shapes the consolidated review skill's output (the review packet is the densest, most
  evidence-first artifact Suspec produces).

## Affected obligations / constraints

- **Refines:** [ADR-0057](./0057-practical-first-repositioning.md) (vocabulary tiers — adds an output-
  economy floor). **Grounded by:** [[FORMATFREE]], [[OVERRELIANCE-REVIEW]].
- **Does NOT change:** the artifact formats, the verdict model, or the checks contract; introduces no
  enforcement (ADR-0063) and no provider-specific mechanism (provider-neutral, [principles](../reference/principles.md)).
