# Distillation Loss Budget

> Swarm's reference for the distillation loss budget: the MAY-drop / MUST-survive lists, the per-boundary loss matrix, the discipline-not-gatekeeper rule, and the forbidden-composition treatment.

## What distillation is

Distillation is the deliberate **dropping of detail** that happens whenever information crosses a boundary in the flow. It is most acute at two boundaries:

- the **spec → task structuring boundary** (the `lower` step), and
- the **promotion boundary** (the `promote` step).

The **loss budget** is the discipline governing *what may be dropped* versus *what must survive*. Its purpose is to let structuring and promotion compress aggressively without ever silently losing binding force.

The bright line: a distillation that drops an obligation, its modality, or its verification binding has not *compressed* the spec — it has **changed what gets built**. Compression that changes the build is not compression.

## What MAY be abstracted or dropped

At any distillation boundary, the following MAY be abstracted, summarized, or dropped entirely, because none of it carries binding force. The right column names where each piece still survives, so nothing is *lost*, only *relocated*.

| Droppable | Where it survives instead |
| --------- | ------------------------- |
| Commentary and narrative prose | The source artifact (linked, not copied). |
| Redundant restatements | The single canonical statement. |
| Rationale already recorded elsewhere | The ADR / finding / research it came from. |
| Rejected options, source digressions, low-confidence observations | The `research.md`. |
| Step-by-step execution logs | The `task.md` and the trace. |

## What MUST survive every distillation

The following MUST survive intact across **every** boundary. Dropping or weakening any of them is a **distillation error** — a lint diagnostic in the `SOL-V001` / `SOL-M…` family, not a stylistic choice.

| Must survive | Why |
| ------------ | --- |
| The obligation itself (its ID) | The traceability key; losing it severs backward trace. |
| Its modality (`MUST` / `MUST NOT` / `SHOULD` / …) | Modality *is* the binding force; losing it neutralizes the obligation. |
| Its verification bindings (`VERIFY BY …`) | An obligation with no proof path is `UNVERIFIED`. |
| Its authority and scope | The domain/artifact rank and `WRITES` / `READS` / `AFFECTS` scope. |
| Constraints, invariants, non-goals, unresolved `QUESTION`s | These bound the build; dropping a non-goal silently widens scope. |

## The per-boundary loss matrix

The two lists above generalize. This matrix is the canonical per-boundary specialization: for each named crossing it states the permitted loss (safe to drop, survives elsewhere) and the forbidden loss (binding force that must carry through).

| From | To | Permitted loss | Forbidden loss |
| ---- | -- | -------------- | -------------- |
| `research.md` | `spec.md` | Source digressions, rejected options, low-confidence observations | Constraints, unresolved ambiguity, decision-changing evidence |
| `audit.md` | `spec.md` | Low-priority cleanup details | Observed risks affecting target behavior |
| `bug-report.md` | fix task | Duplicate failed reproduction attempts | Reliable reproduction, expected/actual behavior, root-cause evidence |
| `spec.md` | task | Rationale not needed for execution | Obligation IDs, modality, constraints, invariants, verification bindings, non-goals |
| `finding.md` | task | Historical discussion | Actionable claim, applicability, evidence |
| `task.md` | `finding.md` | Step-by-step execution log | Evidence for the durable claim |
| task output | trace | Narrative detail | Obligation ID, changed files, proof |
| trace | review verdict | Implementation chatter | Claim, evidence, pass/fail reason |

## The budget is a discipline, not a gatekeeper

The loss budget is **enforced by source authority plus lint**. It is not, and MUST NOT be implemented as, a "documentation-gatekeeper" skill or persona.

Rationale: a gatekeeper is *soft control* — a model deciding whether to allow a passage, which can be talked past. A lint rule plus an authority comparison are *deterministic checks* against the typed obligation set. Concretely, the budget is caught two ways:

- **Lint catches it structurally.** A structured task that omits an obligation ID its source spec declares, or a `VERIFY BY` binding present in the spec but absent in the task, is a `SOL-V001` / `SOL-M…` diagnostic.
- **Source authority catches it semantically.** A distilled artifact that contradicts its higher-authority source is a `SOL-M004` authority-conflict, routed to amendment — the distillation cannot silently win.

The human-authored declaration the lint checks against is the **`spec.md` distillation loss statement** — the `Preserved / Dropped / Still uncertain` section. It records what the author *intends* to be droppable, so the loss is **auditable rather than accidental**.

## Forbidden compositions

A **forbidden composition** is the silent mixing of two distinct epistemic stances — most dangerously, an **observation-only artifact silently becoming intent**. Examples:

- an `audit.md` (observation of present state) read as if it were an approved `spec.md` (intended behavior);
- a `research.md` (exploratory) treated as a decision;
- a `bug-report.md` (diagnosis) treated as a fix authorization.

These compositions are prevented by the **loss budget + source authority**, NOT by a documentation-gatekeeper:

- The **loss budget** forces the crossing to be explicit. An audit *promotes to* a spec through the `audit.md → spec.md` row of the matrix above, which is an authoring act that re-states observations as obligations with their own IDs, modality, and verification bindings. There is no path by which an audit's prose becomes binding without that re-statement.
- **Source authority** ranks the stances. An `audit` (Axis A rank 4, observation) cannot silently amend an approved `spec` (rank 2); if it appears to, that is a `SOL-M004` authority-conflict routed to review.

### Worked example

An `audit.md` notes "the refresh endpoint currently accepts rotated tokens." This is an **observation**, not intent. To affect the build it must promote into `spec.md` as a re-stated obligation (`CONSTRAINT C-014`) carrying modality and `VERIFY BY`. The audit prose alone has Axis-A rank 4 and `audit` / `security` domain; it never silently overwrites the product spec — the source-authority conflict procedure governs, and the loss budget forces the explicit re-statement. The epistemic stance is preserved end-to-end: an observation stays labeled an observation until an author deliberately turns it into intent.

## Validity note

A valid repo's distillation-loss-budget reference (this document) MUST state both lists (the MAY-drop list and the MUST-survive list), the per-boundary matrix, the discipline-not-gatekeeper rule, and the forbidden-composition treatment.

## Related

- [Promotion protocol](./reference/promotion-protocol.md) — the promotion boundary this budget governs.
- [SOL](./language/SOL.md) — the lint family (`SOL-V001`, `SOL-M…`) that enforces the budget structurally and the `SOL-M004` authority-conflict that catches it semantically.
- [Drift and staleness](./reference/drift-and-staleness.md) — how distilled artifacts are kept faithful to their sources over time.
- [Proof types](./reference/proof-types.md) — the `VERIFY BY` proof paths that MUST survive every distillation.
- [Glossary](./reference/glossary.md) — canonical definitions of obligation, modality, authority, and the artifact stances.
