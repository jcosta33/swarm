---
type: adr
id: adr-0101
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0101 — Open decisions carry options + a recommendation, in decision-bearing authoring

## Context

When an authoring agent hits a genuine fork — a behavioral choice the artifact cannot settle on its
own — the framework's handling is uneven. The **review template** does it well: `## Open decisions`
([ADR-0089](./0089-decision-handoff-open-decisions.md)) — 2–4 comparable options, the case FOR and
AGAINST, a recommendation + why, what it blocks. The **spec authoring path** is thinner: `write-spec`
rule 7 routes ambiguity to a bare `## Open questions` list — no options, no recommendation. So whether
the human receives a *decidable fork* or a *vague question* depends on which artifact is in hand. The
good pattern already exists; it just isn't standard. (From the session deliberation; RFC-authoring-open-decisions.)

## Decision

1. **A decision-bearing authoring artifact surfaces each genuine fork as options + a recommendation**,
   in the ADR-0089 shape — never a bare question, never a silent guess. The spec's existing
   `## Open questions` section (**frozen by [ADR-0058](./0058-two-tier-spec-format.md), checked by
   C006**) is **filled with options + a recommendation** — *not renamed*: the decision in one line ·
   2–4 options with FOR/AGAINST · a recommendation + a brief why · what it blocks. A real "don't know
   yet" is a one-option decision whose recommendation is "find out how." This is a **content-discipline
   change, not a format change** — the section name, the frozen list, and C006 are untouched.
   _Level: convention._

2. **Runner-honest interaction.** Where the runner supports an interactive prompt (e.g. Claude Code's
   question UI), the agent asks and proceeds on the answer; where it does not (a file-only worker,
   another harness, a human), it records the same `## Open decisions` for the owner. The **principle**
   (options + a lean, never a guess) is runner-agnostic; the *interactive mechanism* is a Claude-Code
   affordance that does not travel ([ADR-0098](./0098-codex-emitter-and-universal-layer.md)) — additive
   in the suspec-agents layer, never required of the format. _Level: convention._

3. **Genuine forks only (anti-ceremony).** This fires on a behavioral choice that changes the
   artifact's meaning, not on every micro-wording choice. An empty `## Open decisions` is correct when
   there is no real fork; padding it is the ceremony overhead (suspec-works#72) this must not add.
   _Level: convention._

4. **Scope: where the artifact decides.** The convention binds artifacts that make a **behavioral
   decision** — the **spec** (primary) and the **RFC** (which already carries Alternatives + a
   decision requested). **Observation/intent stances are exempt:** an **audit** records present state
   and recommends only in prose, a **PRD** states intent, **research** surveys without
   deciding. Forcing an options-block on them would manufacture decisions the stance forbids.
   _Level: convention._

## Consequences

- No `checks.yaml` rule, no contract bump — a convention, consistent with the honesty framework
  ([ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)).
- Reaffirms [ADR-0089](./0089-decision-handoff-open-decisions.md) (the open-decisions shape) and
  [ADR-0098](./0098-codex-emitter-and-universal-layer.md)'s no-travel boundary (interactive is additive,
  not required).
- The spec gains a decidable fork where it had a vague list; the human gets a lean, not a quiz.
- **No format change.** The `## Open questions` heading is the frozen ADR-0058 section and the C006
  target; both are untouched. Existing specs stay valid — only the guidance on *how to fill* the
  section changes.

## Propagation

The kit spec template (upgrade the `## Open questions` guidance to options + a recommendation —
**no rename**), the `write-spec` guide (rule 7), and a note that `write-rfc` already complies and
audit/PRD/research are exempt. suspec-agents worker definitions may wire the interactive prompt
(Claude-Code only, marked non-portable). No review-packet or spec *format* break.

## Affected obligations / constraints

- **Refines:** the `write-spec` ambiguity rule and the spec template's `## Open questions` guidance.
- **Reaffirms:** [ADR-0089](./0089-decision-handoff-open-decisions.md), the **frozen section list of
  [ADR-0058](./0058-two-tier-spec-format.md) (C006 untouched)**, and
  [ADR-0098](./0098-codex-emitter-and-universal-layer.md)'s no-travel boundary.
- **Does NOT change:** any closed set, the verdict model, the spec format, or the checks contract.
