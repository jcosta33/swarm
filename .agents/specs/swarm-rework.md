# Agent Task Brief: Implement the Swarm Kernel

## Mission

You are upgrading this repository into the first implementation of **Swarm as a unitary agentic specification compiler framework**.

Swarm’s global definition:

> **Swarm is an obligation-centered specification compiler framework for agentic software engineering. It turns human intent into verifiable obligations, lowers those obligations into bounded agent tasks, verifies traces against obligations, and promotes durable discoveries back into project memory.**

This pass establishes the **kernel**: the language, prose standard, artifact model, pass model, task/trace/review templates, and minimal bootloader rules needed for future automation.

Do not implement automation. Do not build a CLI. Do not assume any current repo shape. Integrate the following concepts into the repository in the cleanest structure available. If the repo already has equivalent locations, use them. If not, create a clear structure.

---

## Non-goals

Do **not** build a CLI.

Do **not** add runtime assumptions.

Do **not** make provider-specific assumptions.

Do **not** assume Claude, Codex, Cursor, Gemini, Aider, or any specific agent tool.

Do **not** turn Swarm into a general-purpose programming language.

Do **not** remove markdown readability.

Do **not** create shallow placeholder files.

Do **not** rewrite unrelated content.

Do **not** make skills responsible for defining language semantics.

Do **not** put the full language manual into `AGENTS.md`.

Do **not** claim future automation already exists.

Do **not** claim the framework enforces behavior through code.

This repository remains documentation/scaffold only.

---

## Output expectation

Produce a coherent Swarm kernel that defines:

1. **SOL** — Swarm Obligation Language.
2. **APS** — Agent Prose Semantics.
3. **Artifact contracts** — spec, task, trace, verdict, finding, memory, ADR, audit, research, bug report.
4. **Compiler passes** — author, lint, improve, lower, decompose, implement, verify, review, promote.
5. **Task/pass templates** — reusable working forms.
6. **Skill/pass-guide principles** — how skills fit without owning semantics.
7. **Memory and promotion protocol** — durable feedback loop.
8. **Source authority and conflict rules**.
9. **Acceptance criteria and lint taxonomy**.

---

# 1. Global model

Swarm is not “a set of prompts.”

Swarm is a **manual specification compiler architecture** that can later be automated.

The canonical pipeline is:

```text
human intent
  → source artifacts
  → .swarm.md specification
  → SOL obligations
  → obligation graph
  → task graph
  → task companions
  → agent execution
  → trace
  → verification
  → review verdict
  → promotion
  → durable memory update
```

The central object is the **obligation graph**.

Everything revolves around obligations:

```text
Specs produce obligations.
Tasks implement obligations.
Traces claim obligations were implemented.
Reviews judge obligations.
Verification proves obligations.
Memory records discoveries about obligations.
Orchestration schedules obligations.
```

---

# 2. Swarm layers

Swarm has six integrated layers.

```text
1. Language
   SOL + APS.

2. Artifacts
   spec, task, trace, verdict, finding, ADR, memory, audit, research, bug-report.

3. Passes
   author, lint, improve, lower, decompose, implement, verify, review, promote.

4. Templates
   copyable task/spec/trace/finding/review forms.

5. Pass guides / skills
   reusable methods for performing passes.

6. Memory
   durable project knowledge and promotion loop.
```

Use this terminology consistently.

---

# 3. Terminology

| Term                  | Meaning                                                                                       |
| --------------------- | --------------------------------------------------------------------------------------------- |
| **Swarm**             | The whole framework: language, artifacts, passes, templates, pass guides/skills, memory.      |
| **SOL**               | Swarm Obligation Language. Controlled markdown syntax for formal specification blocks.        |
| **APS**               | Agent Prose Semantics. Controlled prose standard for human-readable text.                     |
| **Obligation**        | Atomic required behavior or property. Usually `REQ AC-001`.                                   |
| **Constraint**        | A rule limiting how obligations may be satisfied.                                             |
| **Invariant**         | A truth that must remain preserved.                                                           |
| **Interface**         | A declared boundary, API, function, schema, command, module, or contract.                     |
| **Question**          | Explicit unresolved ambiguity. Blocking questions prevent implementation.                     |
| **Trace**             | Implementation claim mapped to obligations and evidence.                                      |
| **Verdict**           | Review result for obligation/constraint/invariant claims.                                     |
| **Pass**              | A transformation step: author, lint, lower, implement, review, promote.                       |
| **Pass guide**        | What may physically be represented as a skill: reusable method for a pass.                    |
| **Heuristic profile** | What may physically be represented as a persona: reusable cognitive stance applied to a pass. |
| **Kernel**            | Non-optional Swarm substrate.                                                                 |
| **Standard library**  | Default pass guides/profiles/templates installed with Swarm.                                  |
| **Overlay**           | Project-specific rules, architecture, testing, domain knowledge.                              |

---

# 4. Core doctrine

Add this doctrine to the framework.

```text
Formal semantics belong to the language, not to skills.

Pass structure belongs to task templates, not to AGENTS.md.

Heuristics belong to skills/profiles, not to the language.

Universal startup belongs to AGENTS.md, not to every artifact.

Skills may improve execution quality, but they must not be required to understand SOL.

A well-written .swarm.md file should be understandable to a strong model because it uses controlled natural language and stable formal blocks.

Swarm is unitary at rest and modular in execution.
```

“Unitary at rest, modular in execution” means:

```text
Install the whole framework.
Load only the pass/profile/context needed for the current task.
```

Swarm should not be framed as a pick-your-own-skill library.

---

# 5. Recommended kernel structure

Do not assume this exact structure already exists. Create or adapt as appropriate.

Recommended conceptual layout:

```text
docs/
  language/
    README.md
    SOL.md
    APS.md
    errors.md
    versioning.md

  artifacts/
    README.md
    spec.md
    task.md
    trace.md
    verdict.md
    finding.md
    memory.md
    adr.md
    audit.md
    research.md
    bug-report.md

  passes/
    README.md
    improve-spec.md
    lint-spec.md
    lower-spec.md
    decompose-spec.md
    implement-obligations.md
    review-trace.md
    promote-findings.md

  reference/
    source-authority.md
    promotion-protocol.md
    distillation-loss-budget.md
    glossary.md

  examples/
    README.md

scaffold/
  AGENTS.md

  .agents/
    language/
      SOL.md
      APS.md
      errors.md

    templates/
      spec.swarm.md
      task.md
      trace.md
      review.md
      finding.md
      adr.md

    memory/
      INDEX.md
      glossary.md
      patterns/
```

If the repository uses a different convention, preserve the convention while still installing the same conceptual pieces.

---

# 6. SOL v0.1 — Swarm Obligation Language

Create a canonical SOL reference in the documentation and a self-contained SOL reference in the scaffold.

The scaffold copy must not depend on repository docs.

## 6.1 SOL purpose

SOL is the controlled markdown language used inside `.swarm.md` specifications and related artifacts.

SOL exists to convert human intent into obligations that can be linted, lowered into tasks, implemented, verified, reviewed, and promoted.

SOL is not a general-purpose programming language.

SOL is not a replacement for prose.

SOL is a formal spine inside readable markdown.

## 6.2 File extension

Preferred source extension:

```text
*.swarm.md
```

Reasons:

```text
- keeps markdown rendering;
- stays human-editable;
- signals controlled syntax;
- allows future linting by filename;
- supports prose plus formal blocks.
```

---

## 6.3 Core SOL block types

SOL v0.1 defines these block types:

```text
REQ
CONSTRAINT
INVARIANT
INTERFACE
QUESTION
TRACE
VERDICT
```

---

## 6.4 `REQ`

A `REQ` block defines a required behavior.

Example:

```text
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
AND THE client MUST redirect to `/login`
VERIFY BY auth-refresh-expired-token.test
```

Rules:

```text
A REQ block must have an ID.
A REQ block must define actor, modality, response, and verification.
A REQ block should have a trigger, state, or condition unless it is globally applicable.
A REQ block must be atomic enough to verify.
```

---

## 6.5 `CONSTRAINT`

A `CONSTRAINT` block defines a restriction on how obligations may be satisfied.

Example:

```text
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
VERIFY BY dependency-boundary-check
```

Rules:

```text
A CONSTRAINT limits implementation.
A CONSTRAINT is not a behavior request.
A CONSTRAINT must identify the actor/surface being constrained.
A CONSTRAINT must have verification or explicit manual review.
```

---

## 6.6 `INVARIANT`

An `INVARIANT` block defines a truth that must remain preserved.

Example:

```text
INVARIANT I-001:
A user MUST NOT have more than one active refresh token family
VERIFY BY token-family-invariant.test
```

Rules:

```text
An INVARIANT must describe an always-preserved property.
An INVARIANT must not describe one-time behavior.
An INVARIANT must have verification or explicit manual review.
```

---

## 6.7 `INTERFACE`

An `INTERFACE` block defines a boundary, API, function, schema, command, module, or contract.

Example:

```text
INTERFACE IF-001:
`refreshSession()` RETURNS `Session | AuthExpired`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
```

Rules:

```text
An INTERFACE gives names to boundaries and contracts.
Obligations may reference interfaces.
Tasks may declare touched interfaces.
Undeclared interfaces should trigger a semantic warning.
```

---

## 6.8 `QUESTION`

A `QUESTION` block defines unresolved ambiguity.

Example:

```text
QUESTION Q-001 [blocking]:
Should expired sessions redirect to `/login` or show an inline re-auth modal?
AFFECTS AC-001
```

Rules:

```text
A blocking question prevents implementation lowering.
A non-blocking question may remain open if it does not affect assigned obligations.
Behavioral uncertainty must become a QUESTION, not prose.
```

---

## 6.9 `TRACE`

A `TRACE` block records an implementation claim.

Example:

```text
TRACE T-001:
IMPLEMENTS AC-001, AC-002
PRESERVES C-001
CHANGED src/auth/client.ts, src/auth/session-store.ts
PROOF auth-refresh-expired-token.test passed
PROOF auth-refresh-no-loop.test passed
PROOF dependency-boundary-check passed
```

Rules:

```text
A TRACE must reference obligation IDs.
A TRACE must name changed surfaces.
A TRACE must include proof references.
A TRACE is consumed by review.
```

---

## 6.10 `VERDICT`

A `VERDICT` block records review output.

Example:

```text
VERDICT AC-001: PASS
REASON The branch clears local session and redirects to `/login` when token expiry is simulated.
EVIDENCE auth-refresh-expired-token.test output in review log
```

Allowed verdict values:

```text
PASS
FAIL
UNVERIFIED
BLOCKED
```

Rules:

```text
PASS means evidence satisfies the obligation.
FAIL means evidence or diff contradicts the obligation.
UNVERIFIED means the claim may be true but evidence is missing or insufficient.
BLOCKED means review cannot proceed due to ambiguity, conflict, or missing input.
```

---

## 6.11 Modal verbs

Use RFC-style modal semantics.

| Modal      | Meaning                                           |
| ---------- | ------------------------------------------------- |
| `MUST`     | Required. Failure means non-compliance.           |
| `MUST NOT` | Forbidden.                                        |
| `SHOULD`   | Strong default; exception requires reason.        |
| `MAY`      | Optional.                                         |
| `CAN`      | Capability statement; avoid in obligations.       |
| `WILL`     | Prediction or future event; avoid in obligations. |

Rules:

```text
Use MUST or MUST NOT for binding behavior.
Use SHOULD only with BECAUSE or EXCEPT.
Do not use “needs to,” “should probably,” “try to,” or “ideally” in obligations.
```

---

## 6.12 Requirement grammar

Use this simplified grammar.

```text
REQ <AC-ID>:
[WHERE <context>]
[WHILE <state/precondition>]
[WHEN <trigger/event>]
[IF <fault/error condition>]
THE <actor> <MUST|SHOULD|MAY|MUST NOT> <response>
[AND THE <actor> <MUST|SHOULD|MAY|MUST NOT> <response>]*
[BECAUSE <rationale>]
[EXCEPT <exception>]
VERIFY BY <verification reference>
[DEPENDS ON <id-list>]
[TOUCHES <surface-list>]
[RISK <low|medium|high|critical>]
```

Examples:

```text
REQ AC-001:
WHEN the user submits the signup form
AND the email field is empty
THE client MUST show "Email is required"
AND THE client MUST NOT send a signup request
VERIFY BY signup-empty-email.test
```

```text
REQ AC-002:
WHILE the user is unauthenticated
WHEN the user opens `/settings`
THE client MUST redirect to `/login`
VERIFY BY unauthenticated-settings-redirect.test
```

```text
REQ AC-003:
IF the payment provider times out
THE server MUST NOT create an order
AND THE server MUST record a retryable payment attempt
VERIFY BY payment-timeout.test
```

---

## 6.13 Constraint grammar

```text
CONSTRAINT <C-ID>:
THE <actor/surface> <MUST|MUST NOT|SHOULD|MAY> <constraint>
VERIFY BY <verification reference>
```

Example:

```text
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
VERIFY BY dependency-boundary-check
```

---

## 6.14 Invariant grammar

```text
INVARIANT <I-ID>:
<state/property> <MUST|MUST NOT> <always hold>
VERIFY BY <verification reference>
```

Example:

```text
INVARIANT I-001:
A user MUST NOT have more than one active refresh token family
VERIFY BY token-family-invariant.test
```

---

## 6.15 Interface grammar

```text
INTERFACE <IF-ID>:
`<name/signature>` RETURNS `<return-type>`
[ACCEPTS:]
  - <input>
[ERRORS:]
  - <error>
[OWNED BY <surface/team/module>]
```

Example:

```text
INTERFACE IF-001:
`refreshSession()` RETURNS `Session | AuthExpired`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
```

---

## 6.16 Question grammar

```text
QUESTION <Q-ID> [blocking|non-blocking]:
<question text>
AFFECTS <id-list or surface>
```

Rules:

```text
A blocking question prevents implementation lowering.
A non-blocking question may remain open if it does not affect assigned obligations.
```

---

## 6.17 Trace grammar

```text
TRACE <T-ID>:
IMPLEMENTS <obligation-id-list>
PRESERVES <constraint-or-invariant-id-list>
CHANGED <path-list>
PROOF <verification reference and result>
```

Example:

```text
TRACE T-001:
IMPLEMENTS AC-001, AC-002
PRESERVES C-001
CHANGED src/auth/client.ts, src/auth/session-store.ts
PROOF auth-refresh-expired-token.test passed
PROOF auth-refresh-no-loop.test passed
PROOF dependency-boundary-check passed
```

---

## 6.18 Verdict grammar

```text
VERDICT <id>: PASS | FAIL | UNVERIFIED | BLOCKED
REASON <text>
EVIDENCE <reference>
```

Example:

```text
VERDICT AC-001: PASS
REASON The branch clears local session and redirects to `/login` when token expiry is simulated.
EVIDENCE auth-refresh-expired-token.test output in review log
```

---

# 7. SOL error taxonomy

Create a SOL and APS error reference.

## 7.1 SOL syntax errors

| Code       | Error                                                                 |
| ---------- | --------------------------------------------------------------------- |
| `SOL-S001` | Dangling `WHEN`, `IF`, or `WHILE` without consequence.                |
| `SOL-S002` | Missing actor after trigger. Use `THE <actor>`.                       |
| `SOL-S003` | Missing modal verb. Use `MUST`, `SHOULD`, `MAY`, or `MUST NOT`.       |
| `SOL-S004` | Missing obligation ID.                                                |
| `SOL-S005` | Invalid ID prefix for block type.                                     |
| `SOL-S006` | `SHOULD` used without `BECAUSE` or `EXCEPT`.                          |
| `SOL-S007` | `VERIFY BY` missing for binding obligation.                           |
| `SOL-S008` | `QUESTION [blocking]` exists in approved implementation source.       |
| `SOL-S009` | `TRACE` references unknown obligation.                                |
| `SOL-S010` | `VERDICT` uses value outside `PASS`, `FAIL`, `UNVERIFIED`, `BLOCKED`. |

## 7.2 SOL semantic errors

| Code       | Error                                                          |
| ---------- | -------------------------------------------------------------- |
| `SOL-M001` | Duplicate obligation ID.                                       |
| `SOL-M002` | Conflicting obligations for same trigger/state.                |
| `SOL-M003` | Unbound verification reference.                                |
| `SOL-M004` | Referenced interface is undeclared.                            |
| `SOL-M005` | Constraint or invariant has no preservation path.              |
| `SOL-M006` | Task covers obligation but omits required constraint.          |
| `SOL-M007` | Trace claims implementation without proof.                     |
| `SOL-M008` | Verdict passes obligation with missing or irrelevant evidence. |
| `SOL-M009` | Write surface conflict blocks parallel execution.              |
| `SOL-M010` | Non-goal contradicted by assigned obligation.                  |

---

# 8. APS v0.1 — Agent Prose Semantics

Create a canonical APS reference in documentation and a self-contained APS reference in the scaffold.

APS controls the human-readable prose around SOL blocks.

## 8.1 APS doctrine

```text
Every word in Swarm prose should do at least one of these jobs:

- constrain behavior;
- clarify context;
- define scope;
- identify evidence;
- bind traceability;
- aid retrieval;
- mark uncertainty;
- explain rationale.

If a word does none of those, remove it.
```

Good Swarm prose is:

```text
concrete
observable
atomic
scoped
verifiable
traceable
non-decorative
low-entropy
```

---

## 8.2 High-risk words

Define this list.

```text
robust
clean
simple
intuitive
user-friendly
fast
performant
scalable
secure
safe
reliable
modern
seamless
flexible
consistent
graceful
correct
appropriate
proper
reasonable
flamboyant
elegant
beautiful
polished
nice
improve
optimize
enhance
streamline
handle
support
manage
```

Rule:

```text
A high-risk word is allowed only if the same sentence, bullet, or immediately following line turns it into observable behavior.
```

Bad:

```text
Improve checkout so it handles failures gracefully.
```

Good:

```text
IF the payment provider times out
THE server MUST NOT create an order
AND THE server MUST record a retryable payment attempt
AND THE client MUST show "Payment temporarily unavailable".
```

---

## 8.3 Preferred verbs

Prefer observable verbs:

```text
return
show
hide
redirect
persist
delete
reject
record
emit
retry
stop
start
sort
filter
validate
serialize
deserialize
authorize
deny
enqueue
dequeue
render
create
update
archive
restore
notify
log
```

Avoid vague verbs unless followed by specifics:

```text
handle
support
improve
optimize
streamline
enhance
modernize
clean up
make robust
```

---

## 8.4 Pronoun policy

Avoid pronouns in obligations and review claims.

Bad:

```text
It should show an error.
```

Good:

```text
THE checkout form MUST show "Payment temporarily unavailable".
```

Use stable IDs instead of phrases like:

```text
the above
the previous one
this thing
that case
```

---

## 8.5 One semantic job per sentence

Bad:

```text
When users upload files, validate them, resize images, store metadata, reject bad files, show progress, and make it fast.
```

Good:

```text
REQ AC-001:
WHEN the user uploads an image larger than 5MB
THE server MUST reject the upload
AND THE client MUST show "Image must be 5MB or smaller"
VERIFY BY upload-large-image.test

REQ AC-002:
WHEN the user uploads a valid image
THE server MUST store the image metadata
VERIFY BY upload-metadata.test
```

---

## 8.6 Context versus obligation

Context explains. Obligations command.

Bad:

```text
Because the existing auth flow is messy and users get confused, when sessions expire, redirect them to login.
```

Good:

```markdown
## Context

Users currently remain on the settings page after session expiry and see repeated failed refresh calls.

## Obligations

REQ AC-001:
WHEN the session is expired
THE client MUST redirect to `/login`
VERIFY BY expired-session-redirect.test
```

---

## 8.7 Improvement operations

Define “improve” as a closed set of operations.

| Operation    | Meaning                                                             |
| ------------ | ------------------------------------------------------------------- |
| `Normalize`  | Convert prose into Swarm-standard phrasing/headings.                |
| `Atomize`    | Split compound requirements into one obligation per block.          |
| `Concretize` | Replace vague words with observable behavior.                       |
| `Quantify`   | Replace unbounded qualities with thresholds or measurable criteria. |
| `Bind`       | Attach verification, source, interface, obligation, or trace IDs.   |
| `Scope`      | Add non-goals, affected surfaces, exclusions.                       |
| `Clarify`    | Turn ambiguity into explicit interpretation or blocking question.   |
| `Deconflict` | Detect and resolve inconsistent claims.                             |
| `Compress`   | Remove non-load-bearing words without changing semantics.           |
| `Trace`      | Add IDs and downstream references.                                  |
| `Promote`    | Move durable facts to finding/spec/ADR/memory.                      |
| `Stabilize`  | Rewrite so future agents interpret text consistently.               |

“Improve this spec” means:

```text
Apply the named operations needed to reduce ambiguity, incompleteness, unverifiability, scope drift, conflict, and prose noise while preserving intended behavior.
```

It does **not** mean:

```text
make nicer
add features
rewrite stylistically
make it sound more polished
change meaning without approval
```

---

## 8.8 APS lint errors

| Code       | Category          | Example                                           |
| ---------- | ----------------- | ------------------------------------------------- |
| `APS-A001` | Ambiguity         | Vague adjective without observable criterion.     |
| `APS-A002` | Ambiguity         | Pronoun reference unclear.                        |
| `APS-V001` | Verifiability     | Behavior has no verification path.                |
| `APS-C001` | Completeness      | Action lacks actor/object.                        |
| `APS-S001` | Scope             | Spec has no non-goals.                            |
| `APS-T001` | Traceability      | Acceptance criterion lacks stable ID.             |
| `APS-X001` | Conflict          | Requirement contradicts another artifact.         |
| `APS-Q001` | Question handling | Behavioral uncertainty not marked as `QUESTION`.  |
| `APS-R001` | Redundancy        | Repeated context adds no constraint.              |
| `APS-M001` | Modality          | `should` used informally instead of `SHOULD`.     |
| `APS-P001` | Prose noise       | Decorative phrase adds no constraint.             |
| `APS-O001` | Overload          | Sentence contains multiple separable obligations. |

---

# 9. Source authority

Create a source authority reference.

Default authority order:

```text
accepted ADR
  > approved .swarm.md spec
  > accepted finding
  > reviewed audit
  > reviewed research
  > task notes
  > chat transcript
```

Caveat:

```text
Code and tests are implementation reality, not intent.
They can falsify assumptions, but they do not automatically amend specs.
```

Conflict rule:

```text
If a lower-authority artifact conflicts with a higher-authority artifact, stop and route to amendment/review.
```

Examples:

```text
If chat conflicts with an approved spec, chat cannot silently override the spec.

If a finding conflicts with an accepted ADR, create an ADR review or supersession task.

If code conflicts with a spec, either fix the code or amend/supersede the spec. Do not backfill intent silently.
```

---

# 10. Promotion protocol

Create a promotion protocol reference.

| Discovery during task          | Promote to             | Why                                              |
| ------------------------------ | ---------------------- | ------------------------------------------------ |
| New intended behavior          | `spec.swarm.md`        | Behavior belongs in a spec.                      |
| Present-state risk/debt        | `audit.md`             | Current-state observation belongs in audit.      |
| Defect evidence                | `bug-report.md`        | Reproducible failure belongs in bug report.      |
| One reusable project fact      | `finding.md`           | Future agents need recall.                       |
| Recurring pattern              | `memory/patterns/*.md` | Repeated knowledge should become indexed memory. |
| Architectural/product decision | `ADR.md`               | Tradeoff requires durable rationale.             |
| Terminology                    | `memory/glossary.md`   | Shared language improves retrieval.              |
| Universal workflow rule        | `AGENTS.md`            | Every future task needs it.                      |
| Task-only execution detail     | stay in `task.md`      | Not durable.                                     |

Promotion statuses:

```text
pending
promoted
deferred
rejected
blocked
```

Rules:

```text
A task may discover durable knowledge.
Durable knowledge must not remain only in a task log.
Before task close, every promotion item must be promoted, deferred, rejected, or blocked with reason.
```

---

# 11. Distillation loss budget

Create a distillation loss budget reference.

| From            | To              | Permitted loss                                                     | Forbidden loss                                                             |
| --------------- | --------------- | ------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| `research.md`   | `spec.swarm.md` | Source digressions, rejected options, low-confidence observations. | Constraints, unresolved ambiguity, decision-changing evidence.             |
| `audit.md`      | `spec.swarm.md` | Low-priority cleanup details.                                      | Observed risks affecting target behavior.                                  |
| `bug-report.md` | fix task        | Duplicate failed reproduction attempts.                            | Reliable reproduction, expected/actual behavior, root-cause evidence.      |
| `spec.swarm.md` | task            | Rationale not needed for execution.                                | Obligation IDs, constraints, invariants, verification bindings, non-goals. |
| `finding.md`    | task            | Historical discussion.                                             | Actionable claim, applicability, evidence.                                 |
| `task.md`       | `finding.md`    | Step-by-step execution log.                                        | Evidence for durable claim.                                                |
| task output     | trace           | Narrative detail.                                                  | Obligation ID, changed files, proof.                                       |
| trace           | review verdict  | Implementation chatter.                                            | Claim, evidence, pass/fail reason.                                         |

Rule:

```text
If lowering drops an obligation ID, modality, actor, trigger, response, constraint, invariant, or verification binding, that is a distillation error.
```

---

# 12. Artifact contracts

Add or update artifact documentation to reflect these roles.

## 12.1 `spec.swarm.md`

Purpose:

```text
A spec is a behavioral contract.
It contains prose plus SOL blocks.
It compiles into obligations.
```

Must contain:

```text
Intent
Non-goals
Context
Interfaces
Obligations
Constraints
Invariants
Questions
Verification coverage
Downstream tasks
Distillation loss statement
```

## 12.2 `task.md`

Purpose:

```text
A task is a pass frame and execution companion.
It is the lowered work packet for one pass.
```

Must contain:

```text
primary source
assigned obligations
constraints/invariants
interfaces
write surfaces
verification bindings
implementation/review trace requirements
promotion queue
self-review
```

## 12.3 `trace.md`

Purpose:

```text
A trace records implementation claims against obligations and evidence.
```

Must contain:

```text
TRACE blocks
verification matrix
unassigned changes
promotion items
```

## 12.4 `review.md`

Purpose:

```text
A review compares trace claims against obligations, constraints, invariants, diffs, and verification evidence.
```

Must contain:

```text
claimed coverage
obligation verdicts
constraint/invariant verdicts
unauthorized changes
final verdict
promotion queue
```

## 12.5 `finding.md`

Purpose:

```text
A finding is one durable project fact discovered during work.
```

Must contain:

```text
claim
evidence
why it matters
applies when
does not apply when
related obligations
promotion target
status history
```

## 12.6 `memory/INDEX.md`

Purpose:

```text
A compact recall map.
It links to findings, ADRs, patterns, glossary, and relevant durable knowledge.
It does not contain full explanations.
```

Must contain:

```text
always-relevant facts
topic files
durable findings
decisions
stale/superseded memory
```

---

# 13. Pass model

Create pass documentation. At minimum, document these passes.

## 13.1 `improve-spec`

Purpose:

```text
Rewrite a spec to satisfy SOL and APS without changing intended meaning unless explicit amendment is requested.
```

Consumes:

```text
draft spec
related source artifacts
SOL reference
APS reference
```

Produces:

```text
improved spec
improvement report
new blocking questions
remaining lint warnings
```

Required report:

```markdown
# Spec improvement report

## Summary

- Input artifact:
- Output artifact:
- Intent preserved: yes/no/partial
- Human decisions required: yes/no

## Applied operations

| Operation                      | Count | Notes |
| ------------------------------ | ----: | ----- |
| Normalize                      |       |       |
| Atomize                        |       |       |
| Concretize                     |       |       |
| Quantify                       |       |       |
| Bind verification              |       |       |
| Add trace IDs                  |       |       |
| Add non-goals                  |       |       |
| Convert ambiguity to questions |       |       |
| Remove prose noise             |       |       |

## Semantic changes

| Change | Type                    | Requires approval? |
| ------ | ----------------------- | -----------------: |
|        | clarification/amendment |             yes/no |

## New blocking questions

| ID  | Question | Why blocking |
| --- | -------- | ------------ |

## Remaining lint warnings

| Code | Location | Explanation |
| ---- | -------- | ----------- |
```

## 13.2 `lint-spec`

Purpose:

```text
Detect SOL and APS defects without changing semantics.
```

Consumes:

```text
spec.swarm.md
SOL reference
APS reference
```

Produces:

```text
lint report
error list
warning list
blocking status
```

## 13.3 `lower-spec`

Purpose:

```text
Convert approved SOL blocks into an obligation graph and task candidates.
```

Consumes:

```text
approved spec.swarm.md
source authority rules
distillation budget
```

Produces:

```text
obligation list
constraint/invariant list
dependency/write-surface notes
candidate task graph
```

## 13.4 `implement-obligations`

Purpose:

```text
Implement assigned obligations only.
```

Consumes:

```text
task.md
assigned obligations
constraints/invariants
interfaces
verification bindings
```

Produces:

```text
code/docs/tests changes
trace
verification output
promotion items
```

## 13.5 `review-trace`

Purpose:

```text
Compare branch/output against assigned obligations and trace claims.
```

Consumes:

```text
review task
source spec
trace
diff/output
verification evidence
```

Produces:

```text
verdict matrix
unauthorized-change list
failed/unverified obligations
promotion items
```

Review output:

```markdown
# Review: <branch or output>

## Claimed coverage

| Trace | Claims | Evidence                        |
| ----- | ------ | ------------------------------- |
| T-001 | AC-001 | auth-refresh-expired-token.test |

## Obligation verdicts

| Obligation | Verdict                            | Reason | Evidence checked |
| ---------- | ---------------------------------- | ------ | ---------------- |
| AC-001     | PASS / FAIL / UNVERIFIED / BLOCKED |        |                  |

## Constraint and invariant verdicts

| ID  | Verdict | Reason | Evidence checked |
| --- | ------- | ------ | ---------------- |

## Unauthorized changes

| Change | Authorized by          | Verdict                    |
| ------ | ---------------------- | -------------------------- |
|        | AC/C/I/IF ID or `none` | allowed / suspect / reject |

## Final verdict

PASS / FAIL / BLOCKED

## Promotion queue

| Item | Target | Status |
| ---- | ------ | ------ |
```

## 13.6 `promote-findings`

Purpose:

```text
Move durable discoveries out of task-local state into durable artifacts.
```

Consumes:

```text
task discoveries
trace
review verdict
promotion protocol
source authority rules
```

Produces:

```text
finding/spec amendment/ADR/audit/memory update
promotion report
```

---

# 14. Skills / pass guides

Update the skill philosophy.

Skills are **pass guides**, not language definitions.

A pass guide may improve how an agent performs a pass, but SOL and APS must be understandable without the skill.

A good pass guide declares:

```text
Consumes
Produces
Preserves
Rejects
Procedure
Output contract
Self-review delta
```

Template:

```markdown
# Pass guide: <name>

## Purpose

## Consumes

## Produces

## Preserves

## Rejects

## Procedure

1.
2.
3.

## Output contract

## Self-review delta
```

Example explanation:

```text
An adversarial-review guide consumes obligations, traces, diffs, and verification output. It produces verdicts. It does not define what REQ, TRACE, or VERDICT mean.
```

Skill dependency rule:

```text
Skills may depend on shared language/artifact/pass contracts.
Skills must not create circular dependencies.
Skills must not be required to interpret SOL.
```

Allowed dependency direction:

```text
language definitions → artifact contracts → pass contracts → pass guides → heuristic profiles → project overlays
```

Forbidden:

```text
SOL semantics depending on a skill.
AGENTS.md containing a full skill or language manual.
A skill overriding approved SOL obligations.
```

---

# 15. Heuristic profiles

Heuristic profiles are optional cognitive stances applied to passes.

They are not characters.

A profile contract:

```markdown
# Heuristic profile: <name>

## Prevents

## Default questions

## Required evidence

## Refuses

## Self-review delta

## Applies when

## Does not apply when
```

Example:

```markdown
# Heuristic profile: Skeptic

## Prevents

Premature acceptance of plausible but unverified claims.

## Default questions

- What would falsify this?
- Does the evidence prove the exact obligation?
- Did the branch change unassigned behavior?

## Required evidence

- Proof mapped to obligation IDs.
- Diff review for unauthorized changes.
- Constraint/invariant preservation.

## Refuses

- Summary-only proof.
- “Tests passed” without relevant output.
- Passing a trace with missing evidence.
```

---

# 16. `AGENTS.md` bootloader

Keep `AGENTS.md` short.

It should contain only startup and universal behavior.

Recommended content:

```markdown
# AGENTS.md

## Swarm startup

1. Read the task file first.
2. Treat formal `.swarm.md` blocks as authoritative over prose summaries.
3. Use obligation IDs as scope.
4. Load only the pass/profile files named by the task.
5. Map every completion claim to evidence.
6. Promote durable discoveries before closing.
7. If a task references SOL or APS and you need the language rules, read `.agents/language/SOL.md` and `.agents/language/APS.md`.

## Universal rules

- Do not implement behavior outside assigned obligations.
- Do not treat chat as higher authority than approved specs or ADRs.
- Do not close a task with unhandled promotion items.
- Do not claim completion without evidence.
```

Do not paste the full SOL or APS manual into `AGENTS.md`.

---

# 17. Scaffold template: `spec.swarm.md`

Create a copyable specification template.

```markdown
---
type: spec
swarm_language: 0.1
aps_version: 0.1
id: { { slug } }
status: draft
created: { { createdAt } }
updated: { { createdAt } }
---

# Spec: {{title}}

## Intent

State the user-visible or system-visible outcome in one paragraph.

## Non-goals

- Explicitly out of scope.

## Context

Only include load-bearing background. Link research, findings, ADRs, audits instead of pasting everything.

## Interfaces

INTERFACE IF-001:
`<name>()` RETURNS `<type>`

## Obligations

REQ AC-001:
WHEN <trigger>
THE <actor> MUST <observable response>
VERIFY BY <test/check/manual-review>

## Constraints

CONSTRAINT C-001:
THE <actor/surface> MUST NOT <forbidden action>
VERIFY BY <check/manual-review>

## Invariants

INVARIANT I-001:
<state/property> MUST <always hold>
VERIFY BY <test/check/manual-review>

## Questions

QUESTION Q-001 [blocking]:
<question>
AFFECTS <id-or-surface>

## Verification coverage

| ID     | Verification |
| ------ | ------------ |
| AC-001 |              |
| C-001  |              |
| I-001  |              |

## Downstream tasks

| Task | Covers |
| ---- | ------ |
|      |        |

## Distillation loss statement

### Preserved

### Dropped

### Still uncertain
```

---

# 18. Scaffold template: `task.md`

Create or update a copyable task template.

```markdown
---
type: task
id: { { slug } }
status: active
task_kind: implementation | fix | refactor | review | source-authoring | promotion
source:
assigned_obligations:
constraints:
invariants:
interfaces:
write_surfaces:
verification_bindings:
parallel_group:
blocked_by:
produces:
created: { { createdAt } }
---

# Task: {{title}}

## 0. Assignment

This task performs one pass over assigned source artifacts.

| Field                 | Value |
| --------------------- | ----- |
| Task kind             |       |
| Source                |       |
| Assigned obligations  |       |
| Constraints           |       |
| Invariants            |       |
| Interfaces            |       |
| Write surfaces        |       |
| Verification bindings |       |
| Parallel safety       |       |

## 1. Assigned obligations

Paste the exact assigned SOL blocks here.

## 2. Constraints and invariants

Paste all constraints and invariants this task must preserve.

## 3. Do not do

- Do not implement unassigned obligations.
- Do not change behavior outside the assigned scope.
- Do not ignore constraints, invariants, or non-goals.

## 4. Plan before edits

1.
2.
3.

## 5. Implementation or pass trace

| Obligation / target | Files changed / artifact changed | How satisfied |
| ------------------- | -------------------------------- | ------------- |
|                     |                                  |               |

## 6. Verification matrix

| Obligation / constraint / invariant | Required proof | Actual proof | Status                       |
| ----------------------------------- | -------------- | ------------ | ---------------------------- |
|                                     |                |              | pass/fail/unverified/blocked |

## 7. Discoveries

| Discovery | Evidence | Promote to |
| --------- | -------- | ---------- |

## 8. Promotion queue

| Item | Target | Status |
| ---- | ------ | ------ |

## 9. Self-review

<self_review>

- Did I perform only the assigned pass?
- Did I preserve all assigned SOL semantics?
- Did I map every completion claim to evidence?
- Did I avoid unassigned behavior changes?
- Did I handle every promotion item?
- What remains blocked or unverified?

</self_review>
```

---

# 19. Scaffold template: `trace.md`

Create a copyable trace template.

```markdown
---
type: trace
id: {{slug}}-trace
source_task: .agents/tasks/{{slug}}.md
source_spec:
created: {{createdAt}}
---

# Trace: {{title}}

## Claimed implementation

TRACE T-001:
IMPLEMENTS AC-001
PRESERVES C-001
CHANGED <path>
PROOF <verification output reference>

## Verification matrix

| ID     | Required proof | Actual proof | Status                       |
| ------ | -------------- | ------------ | ---------------------------- |
| AC-001 |                |              | pass/fail/unverified/blocked |

## Unassigned changes

| Change | Reason | Authorized by |
| ------ | ------ | ------------- |

## Promotion items

| Discovery | Target | Status |
| --------- | ------ | ------ |
```

---

# 20. Scaffold template: `review.md`

Create a copyable review template.

```markdown
---
type: review
id: {{slug}}-review
source_trace:
source_spec:
reviewed_output:
created: {{createdAt}}
---

# Review: {{title}}

## Claimed coverage

| Trace | Claims | Evidence |
| ----- | ------ | -------- |
| T-001 | AC-001 |          |

## Obligation verdicts

| Obligation | Verdict                            | Reason | Evidence checked |
| ---------- | ---------------------------------- | ------ | ---------------- |
| AC-001     | PASS / FAIL / UNVERIFIED / BLOCKED |        |                  |

## Constraint and invariant verdicts

| ID  | Verdict | Reason | Evidence checked |
| --- | ------- | ------ | ---------------- |

## Unauthorized changes

| Change | Authorized by          | Verdict                    |
| ------ | ---------------------- | -------------------------- |
|        | AC/C/I/IF ID or `none` | allowed / suspect / reject |

## Final verdict

PASS / FAIL / BLOCKED

## Promotion queue

| Item | Target | Status |
| ---- | ------ | ------ |
```

---

# 21. Scaffold template: `finding.md`

Create a copyable finding template.

```markdown
---
type: finding
id: { { slug } }
status: candidate | accepted | promoted | rejected | stale | superseded
created: { { createdAt } }
updated: { { createdAt } }
related_obligations:
related_constraints:
related_invariants:
confidence: high | medium | low
---

# Finding: {{title}}

## Claim

One durable project fact.

## Evidence

- File:
- Command:
- Output:
- Source:

## Why this matters

What future agents should do differently.

## Applies when

-

## Does not apply when

-

## Related obligations

-

## Promotion target

- [ ] Keep as scoped finding
- [ ] Promote into spec
- [ ] Promote into audit
- [ ] Promote into ADR
- [ ] Promote into memory pattern
- [ ] Mark stale/superseded

## Status history

- {{createdAt}} — candidate — created during task
```

---

# 22. Scaffold template: `adr.md`

Create a copyable ADR template.

```markdown
---
type: adr
id: { { slug } }
status: proposed | accepted | superseded | rejected
created: { { createdAt } }
updated: { { createdAt } }
supersedes:
superseded_by:
---

# ADR: {{title}}

## Context

What forced the decision.

## Decision

What we chose.

## Alternatives considered

| Alternative | Why rejected |
| ----------- | ------------ |

## Consequences

### Positive

### Negative

### Neutral / tradeoffs

## Applies when

-

## Does not apply when

-

## Affected obligations / constraints

- Adds:
- Modifies:
- Supersedes:

## Related artifacts

- Specs:
- Findings:
- Audits:
- Research:
```

---

# 23. Memory index template

Create a memory index template.

```markdown
---
type: memory-index
id: memory-index
status: active
updated: { { createdAt } }
---

# Memory index

## Purpose

This file is the compact map of durable project knowledge.

Read this before tasks that may depend on prior discoveries.
Follow links to topic files only when relevant.

## Always-relevant project facts

-

## Topic files

| Topic                 | File                       | Load when                                                    |
| --------------------- | -------------------------- | ------------------------------------------------------------ |
| Architecture patterns | `patterns/architecture.md` | Editing module boundaries, ownership, or cross-cutting flows |
| Testing patterns      | `patterns/testing.md`      | Adding, moving, or interpreting tests                        |
| Debugging patterns    | `patterns/debugging.md`    | Investigating repeated failures                              |

## Durable findings

| Finding | Status | Load when |
| ------- | ------ | --------- |
|         |        |           |

## Decisions

| ADR | Status | Load when |
| --- | ------ | --------- |
|     |        |           |

## Stale or superseded memory

| Item | Replacement | Action |
| ---- | ----------- | ------ |
|      |             |        |
```

Rules:

```text
The memory index links. It does not explain everything.
Every entry must include a “Load when” condition.
If an entry cannot name when it matters, remove it from the index.
```

---

# 24. Documentation principles to add

Add these principles to the framework.

## 24.1 Obligation-centered

```text
The obligation graph is the center of Swarm.
```

## 24.2 Semantics in language

```text
Formal semantics live in SOL, not skills.
```

## 24.3 Prose is controlled

```text
Human-readable prose follows APS.
```

## 24.4 Tasks are pass frames

```text
A task is a lowered work packet for one pass.
```

## 24.5 Skills are pass guides

```text
Skills improve pass execution but do not define language semantics.
```

## 24.6 Verification is mandatory

```text
Every completion claim maps to evidence.
```

## 24.7 Promotion closes the loop

```text
Durable discoveries leave task-local state and become durable artifacts.
```

## 24.8 Unitary at rest, modular in execution

```text
Swarm installs as a coherent framework and activates only what a task needs.
```

---

# 25. Acceptance criteria for the repository update

This implementation pass is complete only if:

- Swarm is defined as an obligation-centered specification compiler framework.
- SOL is documented with block types, grammar, trace, verdict, syntax errors, and semantic errors.
- APS is documented with prose rules, high-risk words, preferred verbs, improvement operations, and lint errors.
- `improve-spec` is operationally defined.
- `review-trace` is operationally defined.
- Source authority is defined.
- Promotion protocol is defined.
- Distillation loss budget is defined.
- Scaffold has self-contained SOL and APS references.
- Scaffold has templates for `spec.swarm.md`, `task.md`, `trace.md`, `review.md`, `finding.md`, `adr.md`, and memory index.
- `AGENTS.md` remains short and acts only as a bootloader.
- Skills/pass guides are framed as optional methods for passes, not as language semantics.
- Tasks are framed as pass frames, not generic prompt logs.
- No file claims a CLI is required.
- No file claims automation already exists.
- No skill is required to understand SOL semantics.
- Formal semantics live in language docs.
- Pass behavior lives in pass docs/templates.
- Heuristics/profiles remain optional improvement layers.
- The repo does not present Swarm as only “conditioning prose.”
- The repo presents Swarm as a manual-to-automatable specification compiler framework.

---

# 26. Manual regression checks

After editing, inspect or run equivalent searches.

Search for old or forbidden framing:

```text
CLI required
pick only what you need
tests passed
improve this spec
kickback task type
language defined by skill
```

Expected:

```text
No CLI-required claim.
No “pick only what you need” as central doctrine.
No unqualified “tests passed” proof language.
“Improve” has an operational definition.
No language semantics are owned by skills.
```

Search for required language terms:

```text
SOL
APS
REQ
CONSTRAINT
INVARIANT
INTERFACE
QUESTION
TRACE
VERDICT
PASS
FAIL
UNVERIFIED
BLOCKED
promotion queue
distillation loss
source authority
```

Expected:

```text
All required terms appear in language/pass/scaffold materials.
```

---

# 27. Final instruction

This is not a prose cleanup.

This is the Swarm kernel.

Every added file, section, and rule must support this pipeline:

```text
intent
  → .swarm.md source
  → obligation graph
  → task frame
  → agent execution
  → trace
  → review verdict
  → durable promotion
  → memory update
```

If a proposed addition does not support that pipeline, do not add it.
