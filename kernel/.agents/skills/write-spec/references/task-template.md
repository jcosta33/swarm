# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: spec-writing
- Deliverable path: `.agents/specs/{{slug}}.md`

---

> 🔒 **SPEC-WRITING SESSION** — Produces a spec, not code. No source/config/dependency changes. Halt on `[CRITICAL]` open questions. Copy `## Deliverable` to the path above at close.
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

What capability is being specified and what decision it informs. One paragraph maximum.

---

## Linked docs

- Triggering ask: `{{specFile}}` · Upstream research / audit: `<paths>` · Related ADRs: `<paths>` · Constitution (if applicable): `<path>`

---

## Constraints

- **No source file changes — spec document only.** Work only inside this worktree; do not switch branches unless instructed.
- Survey existing patterns before introducing new ones; identify downstream breakages before a change ships
- Document structural decisions rigorously (alternatives considered, alternatives rejected, with reasoning)
- Halt on `[CRITICAL]` open questions; do not proceed
- Use Distillation Loss Statements when distilling from research
- **Proactively research and read related docs** under `.agents/specs/`, `.agents/audits/`, `.agents/research/`, `.agents/adrs/`, `docs/`, `AGENTS.md`, and source code (read-only).

---

## Progress checklist

- [ ] Read upstream sources (research, audit) in full
- [ ] Survey existing patterns; record consulted modules in the deliverable's `## Pattern survey`
- [ ] Draft the deliverable's `## Goal`, `## Scope`, `## User-visible behaviour`, `## Acceptance criteria` (each criterion carrying a check binding — `test` / `command` / `manual`)
- [ ] Draft `## Design decisions` with named alternatives + reasoning
- [ ] Identify and flag `[CRITICAL]` and `[MINOR]` open questions
- [ ] Distillation Loss Statement (if distilling from research)
- [ ] Self-review: every question answered; every acceptance criterion confirmed bound (`test` / `command` / `manual`)
- [ ] Copy the `## Deliverable` block to its final home

---

## Deliverable

> Copy everything between this line and `--- END DELIVERABLE ---` into `.agents/specs/{{slug}}.md` at close, demoting headings as needed. ⚠️ **VERIFIABILITY OVER COMPLETENESS** — every requirement testable; rewrite or remove wishes.

### Status — Draft / Active / Shipped / Superseded

### Context

Why this spec exists. The triggering ask, the upstream research / audit, the audience.

### Linked docs

- Upstream research / audit: `<paths>` · Related ADRs: `<paths>` · Constitution (if applicable): `<path>`

### Goal

What's true when this is built. One paragraph; no implementation.

### Scope

- **In scope:** (specific capabilities being specified)
- **Out of scope:** (related work explicitly not covered; one-line reason if not obvious)

### User-visible behaviour

(Numbered list of behaviours an end-user / downstream consumer experiences when this is built.)

1. **<behaviour>** — when X, the system does Y.

### Acceptance criteria

(Each testable; a downstream test-authoring session can derive a test directly. Each criterion **declares its check binding** — how it is verified — so the downstream `feature` task checks *against* the spec rather than re-interpreting it. `test` is preferred (a valid oracle: fails when the criterion is violated, passes when satisfied — proven downstream by an assertion-flip); `command` cites an `AGENTS.md > Commands` entry whose output demonstrates it; `manual` carries a one-line reason it cannot be a runnable check. A criterion with no binding is not finalisable.)

| Criterion | Check kind (`test` / `command` / `manual`) | Binding (test path / command / reason) | Result (paste slot) |
| --------- | ------------------------------------------ | --------------------------------------- | ------------------- |
| **AC1:** <criterion> | `test` | `<test file path / name of the oracle test>` | (paste at delivery — for `manual`, n/a) |
| **AC2:** <criterion> | `command` | `AGENTS.md > Commands > <name>` | (paste the command output) |
| **AC3:** <criterion> | `manual` | <one-line reason it cannot be a runnable check> | n/a (human judgement) |

### Design decisions

(For each significant structural choice. Any decision without alternatives listed is incomplete.)

#### Decision: <name>

**Chosen:** <what was chosen>

**Considered and rejected:** _<alternative A>_ — rejected because <reason>; _<alternative B>_ — rejected because <reason>.

### Architectural constraints

- (architectural / performance / security constraints the implementation must honour; link project-wide constraints from constitution or ADRs)

### Pattern survey

(Existing helpers/modules/patterns consulted to avoid reinvention.)

- `src/<file>:<line>` — <what it does> — <why this spec uses / avoids it>

### Open questions

- [ ] **[CRITICAL]** Blocks implementation; spec is on hold until resolved.
- [ ] **[MINOR]** Worth recording but not blocking; implementation may proceed.

### Tradeoffs and risks

**Risk: <name>.** <Description.> _Mitigation:_ <plan>.

### Distillation Loss Statement

(If distilled from research.) **Dropped:** <what>. **Why downstream doesn't need it:** <why>.

--- END DELIVERABLE ---

---

## Decisions

(Session-level choices — distinct from the deliverable's `## Design decisions`.)

- ***

## Findings (session meta)

(Process-level notes — distinct from the spec's content.)

- ***

## Assumptions

- [pending]

## Blockers

- *** (including `[CRITICAL]` open questions that halt the spec)

## Next steps

- ***

---

## Self-review

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. Review as a senior engineer about to greenlight this spec for implementation — look for what's missing.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` → (must show only the spec doc; revert anything else immediately — spec sessions are read-only)

### Implementability

- Could a downstream implementation session deliver from this spec with no follow-up questions? Pick the most ambiguous-feeling acceptance criterion — would the implementer know exactly what to build?
  Answer:

### Verifiability

- Is every requirement testable? Any "the system should be fast"-style requirements lurking?
  Answer:

### Acceptance-criteria bindings

> Every acceptance criterion carries a check binding (`test` / `command` / `manual`), else the spec is not finalisable. Confirm each below; an unbound criterion blocks delivery.

- AC1 → `test`: <path or name of the test that is its oracle>
- AC2 → `command`: `AGENTS.md > Commands > <name>`
- AC3 → `manual`: <one-line reason it cannot be a runnable check>

- Does every criterion in the table above appear here with a binding? Any criterion still unbound?
  Answer:

### Pattern survey

- Did the survey actually happen? Are reuse decisions justified? Existing helpers the spec re-implements unintentionally?
  Answer:

### `[CRITICAL]` open questions

- All resolved (or the spec halted)? Did I push past one with "will figure out at implementation"?
  Answer:

### Distillation Loss Statement (if distilling from research)

- Loss Statement complete — what was dropped, why downstream doesn't need it?
  Answer:

### Final Polish

- "What requirement did I assume the implementer would infer?" Inference is the failure mode the spec exists to prevent.
  Answer:
