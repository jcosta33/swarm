---
name: write-spec
description: Author a forward-looking spec. ALWAYS apply this skill when the user asks for a spec, requirements doc, design doc, or acceptance criteria for a feature or rewrite — even if they say "just write up what we want". Do not include implementation details, present-state observations, or proceed past a `[CRITICAL]` open question. Skip this skill for present-state observations of existing code, defect records, or research write-ups that inform a future decision — specs are forward-looking contracts, not surveys of what is.
---

# Skill: write-spec

## Purpose

A spec is the contract between the spec author (who specifies) and the implementer (who builds). An implementer reading the spec should be able to implement without follow-up questions. This skill is the discipline that gets the spec there.

## Core rules

### 1. Every acceptance criterion is testable — and names its check

A requirement that can't be tested is a wish. Beyond being testable, each acceptance criterion **declares how it is verified** — its *check binding* — so intent is checkable, not re-interpreted by every implementer:

- **`test`** (preferred) — a test exercises it; that test must be a valid *oracle*: it fails when the criterion is violated and passes when satisfied (downstream `feature`/`testing` work proves this by flipping the assertion).
- **`command`** — the output of a project command (named via `AGENTS.md > Commands`) demonstrates it.
- **`manual`** — verification is unavoidably human; carry a one-line reason why it cannot be a runnable check.

- ✅ "GET /api/login redirects to the IdP with a valid S256 `code_challenge` (≥ 32 bytes entropy). — **check:** `test` · auth/login-redirect"
- ❌ "The login endpoint should be secure." (untestable, no check)

A criterion with no check binding is not finalisable. The bindings are what make the spec a contract the downstream `feature` task verifies *against*, rather than prose it re-interprets — the difference between a spec that is read and one that is checked.

### 2. State requirements, not implementations

The implementer picks the implementation. The spec states the *requirement*, not the mechanism.

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

When the spec is distilled from a research file, append a `## Distillation Loss Statement` stating what was dropped (e.g. narratives, alternatives explored) and why the next stage does not need it. Architectural constraints, API payload shapes, and acceptance criteria are *never* droppable.

### 7. Pre-deliver visibility gate (forced visible output)

Before delivering the spec, output the `[CRITICAL]` open-question list verbatim and confirm none remain:

```markdown
## [CRITICAL] open questions outstanding

- (none — spec is finalisable)

— or —

- <question> — blocking because <reason>; resolution path: <task / decision required>
```

If any `[CRITICAL]` remains, the spec is not finalisable. Halt, route to the resolution path (research, ADR, audit, or downgrade with a recorded design decision), then re-output the list. The agent does not deliver the spec to the user until the list is in the task file and shows `(none — spec is finalisable)`.

Also output the **acceptance-criteria bindings** and confirm every criterion carries one:

```markdown
## Acceptance-criteria bindings

- AC1 → `test`: <path or name of the test that is its oracle>
- AC2 → `command`: `AGENTS.md > Commands > <name>`
- AC3 → `manual`: <one-line reason it cannot be a runnable check>
```

A criterion with no binding is not finalisable — bind it (`test`/`command`) or record it as `manual` with a reason. This is the spec's half of the spec-as-code contract: the downstream `feature` task maps each criterion to its check and pastes the result.

## What does not belong

- **In a spec:** present-state observations (those go in an audit), implementation step-by-step (the implementer's concern), narrative storytelling (the research file's concern).
- **In `## Acceptance criteria`:** unmeasurable language ("should be intuitive", "should be performant").
- **In `## Open questions`:** decisions that have been made but not recorded (move to Decisions); rhetorical questions (be specific).

## Anti-patterns

- Speccing implementation steps instead of requirements
- Speccing without surveying prior art
- Leaving `[CRITICAL]` open questions and proceeding
- Mixing forward-looking and present-state content
- Decisions buried in prose without named alternatives
- Acceptance criteria that pass any reasonable implementation (i.e., not actually constraining)

## Bundled resources

- `references/task-template.md` — a fillable spec-writing task template combining the workflow scaffold (metadata, AGENTS.md contract, constraints, progress checklist, decisions, self-review) with the deliverable structure inlined as a `## Deliverable` block (goal, scope, user-visible behaviour, acceptance criteria, design decisions with alternatives, architectural constraints, pattern survey, open questions, tradeoffs/risks, Distillation Loss Statement). At session close, copy the `## Deliverable` block to its final home (`<your-specs-dir>/{{slug}}.md`).

Substitute the `{{...}}` placeholders and fill in as you work.
