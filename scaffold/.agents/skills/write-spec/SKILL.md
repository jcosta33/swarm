---
name: write-spec
description: Load when authoring a spec.md file. Encodes the spec's discipline — every requirement testable, every design decision shows its alternatives, no implementation details, halt on `[CRITICAL]` open questions.
---

# Skill: write-spec

## Purpose

A spec is the contract between The Architect (who specifies) and The Builder (who implements). A Builder reading the spec should be able to implement without follow-up questions. This skill is the discipline that gets the spec there.

## Core rules

### 1. Every requirement is testable

A requirement that can't be tested is a wish. The Test Author can derive a test from each acceptance criterion. If you can't write the test in your head, the requirement is too vague.

- ✅ "GET /api/login redirects to the IdP with a valid S256 code_challenge derived from a cryptographically-secure verifier (≥ 32 bytes entropy)."
- ❌ "The login endpoint should be secure."

### 2. State requirements, not implementations

The Builder picks the implementation. The spec states the *requirement*, not the mechanism.

- ✅ "Lookup must be O(1) per key."
- ❌ "Use a `Map<string, X>`."

If a specific mechanism is load-bearing (e.g., compatibility with existing API), state the requirement that drives the constraint, not the mechanism.

### 3. Survey existing patterns before introducing new ones

Document the survey in `## Pattern survey`. Cite paths to consulted helpers and modules. If reusing an existing pattern, state which one. If introducing a new pattern, justify why the existing patterns don't fit.

### 4. Halt on `[CRITICAL]` open questions

A `[CRITICAL]` open question is one whose answer would change the spec's content. The spec is not finished while a `[CRITICAL]` is unresolved. Two options:

- Spawn a separate task (research, ADR, audit) to resolve the question, then resume.
- If the question can be answered by a reasonable default, *make the decision* (record in `## Design decisions`) and downgrade to `[MINOR]`.

`[MINOR]` open questions can be left and revisited; they don't block implementation.

### 5. Document structural decisions with named alternatives

Every significant decision in `## Design decisions` follows the format:

```markdown
### Decision: <name>

**Chosen:** <what was chosen>

**Considered and rejected:**

- _<alternative A>_ — rejected because <reason>
- _<alternative B>_ — rejected because <reason>
```

A decision without alternatives is incomplete — the reader can't tell if the alternatives were considered or merely overlooked.

### 6. Distillation Loss Statement when distilling from research

When the spec is distilled from a research file, append a `## Distillation Loss Statement`. State what was dropped and why the next stage doesn't need it. See `.agents/skills/distillation-discipline/SKILL.md`.

## What does not belong

- **In a spec:** present-state observations (those go in an audit), implementation step-by-step (the Builder's concern), narrative storytelling (the research file's concern).
- **In `## Acceptance criteria`:** unmeasurable language ("should be intuitive", "should be performant").
- **In `## Open questions`:** decisions that have been made but not recorded (move to Decisions); rhetorical questions (be specific).

## Anti-patterns

- Speccing implementation steps instead of requirements
- Speccing without surveying prior art
- Leaving `[CRITICAL]` open questions and proceeding
- Mixing forward-looking and present-state content
- Decisions buried in prose without named alternatives
- Acceptance criteria that pass any reasonable implementation (i.e., not actually constraining)

## See also

- `.agents/templates/spec.md` — the spec doc template
- `.agents/templates/task-research.md` — the upstream task that produces the research input
- `.agents/skills/distillation-discipline/SKILL.md` — sister skill for distilling
- `.agents/skills/personas/SKILL.md` — The Architect persona
