# Pass guide: distillation-discipline

> Cross-cutting **fragment** (§26.3), not a standalone pass guide: it has the pass-guide shape (§26.5) but is named by another guide rather than by a task `task_kind`. It is composed behind the three passes that cross an artifact boundary — `lower`, `decompose`, and `promote`.
>
> This guide is **procedure only**. The loss budget it applies — what MAY be dropped, what MUST survive, the per-boundary matrix, the discipline-not-gatekeeper rule, the forbidden-composition treatment — is defined authoritatively in the conformant repo's reference `docs/reference/distillation-loss-budget.md` (§24). This fragment does not define modality, authority order, verification semantics, the droppable/must-survive lists, or any lint code; those live only in SOL and the reference layer (§26.1). Where this guide and that reference disagree, the reference governs.

## Purpose

Information loses detail every time it crosses a boundary in the pipeline — most acutely at the **spec → task lowering boundary** (§11) and the **promotion boundary** (§23.4). Compression is the point; *silent* compression is the hazard. A distillation that drops an obligation, its modality, or its verification binding has not compressed the spec — it has changed what gets built (§24, Rationale).

This fragment carries the *procedure* for distilling accountably: before a boundary crossing is treated as complete, the agent makes the loss **visible** so a reviewer can read source and target side by side and confirm nothing binding went missing. The visibility surface is the **`Preserved / Dropped / Still-uncertain`** statement, which §24.2 names as the human-authored declaration that lint (`SOL-V001`/`SOL-M…`) and source authority (`SOL-M004`) check against. The statement does not enforce the budget — it records the loss so the enforcing checks have something to compare.

## Consumes

- The higher-verbosity **source artifact** being distilled, with its load-bearing items still intact: a `research.md`, `audit.md`, `bug-report.md`, an approved `spec.swarm.md`, a `finding.md`, a `task.md`, or a trace — whichever the composing pass reads.
- The **§24 loss budget** as the governing reference: the §24.1 MAY-drop list, the §24.2 MUST-survive list, and the per-boundary matrix row for the crossing in hand.
- The composing pass's own contract (`lower`, `decompose`, or `promote`), which fixes the target artifact and the obligation/discovery set in scope.

## Produces

No artifact of its own. The fragment contributes a **`Preserved / Dropped / Still-uncertain`** statement to the target artifact the composing pass produces, plus the visible per-item check that backs it. It is the procedure the composing pass runs *while* producing its artifact, not a separate output.

## Preserves

Everything §24.2 marks MUST-survive crosses the boundary intact; this fragment never authorizes dropping any of it. Restating the §24.2 categories as the items to confirm (the budget is §24's, not this guide's):

- The **obligation itself** (its ID) — the backward-trace key.
- Its **modality** (`MUST` / `MUST NOT` / `SHOULD` / `SHOULD NOT` / `MAY`) — modality *is* the binding force.
- Its **verification bindings** (`VERIFY BY …`) — an obligation with no proof path is `UNVERIFIED`.
- Its **authority and scope** — the domain/artifact rank (§22) and the `WRITES`/`READS`/`AFFECTS` scope (§18).
- **Constraints, invariants, non-goals, and unresolved `QUESTION`s** — dropping a non-goal silently widens scope.

## Rejects

- A **`Preserved / Dropped / Still-uncertain` statement that says "nothing was dropped."** If nothing was dropped, the crossing was a copy, not a distillation — either embrace the copy and omit the statement, or distil and record the real loss.
- A statement that lists **categories without specifics** ("dropped: implementation details"). Specific: "dropped: the comparison of three retry strategies; the chosen one is recorded as `C-014`."
- **Silent dropping of any §24.2 item.** This is a distillation error, surfaced by lint as `SOL-V001`/`SOL-M…` (§24.3), not a stylistic choice — halt, do not finalize.
- A **forbidden composition** (§24.4): letting an observation-only artifact silently become intent (an `audit.md` read as an approved spec, a `research.md` treated as a decision, a `bug-report.md` treated as a fix authorization). The fragment forces the crossing to be an explicit re-statement; it does not adjudicate authority — source authority (§22) does, and a distilled artifact contradicting its higher-authority source is a `SOL-M004` routed to amendment.
- A statement appended **after the fact** without re-running the per-item check below.

## Procedure

1. **Identify the boundary and pull its matrix row.** Name the crossing (e.g. `spec.swarm.md → task`, `audit.md → spec.swarm.md`, `task.md → finding.md`). Read the matching row of the §24.2 per-boundary matrix to learn the *permitted loss* and *forbidden loss* for exactly this crossing. The budget differs per boundary; do not generalize one row to another.

2. **Enumerate the source's load-bearing items.** From the source artifact, list every item the §24.2 MUST-survive list covers that is present here: each obligation ID, its modality, its `VERIFY BY` bindings, its authority and scope, and every constraint, invariant, non-goal, and unresolved `QUESTION` in range of the crossing.

3. **Classify each item as it lands in the target.** For each enumerated item, record one disposition:
   - **preserved** — survives in the target in some form (a requirement, a behavioural constraint, or a structural choice that enforces it).
   - **promoted to `<target>`** — moved upstream rather than dropped (a discovery routed by §23.4.2 — see *the sister discipline* below).
   - **dropped (justified)** — only legitimate for items on the §24.1 MAY-drop list or the *permitted loss* column of this boundary's matrix row; record where it survives instead (the linked source, the canonical statement, the ADR/finding/research it came from).
   - A MUST-survive item marked dropped is a **distillation error** — return to step 2 and either carry it across or, if the boundary's matrix row permits deferral, mark it explicitly deferred to a named downstream artifact. Never leave it implicit.

4. **Emit the visible per-item check.** Output one row per enumerated item so the classification is auditable, not asserted. A row showing a MUST-survive item as `dropped` without justification is a gate failure: halt and revise before the composing pass finalizes its artifact.

   | Source item | Disposition | Survives as / why droppable |
   | ----------- | ----------- | --------------------------- |
   | `<obligation ID + modality, or other §24.2 item>` | preserved / promoted to `<target>` / dropped (justified) | `<where it lands, or the §24.1 / matrix-row justification>` |

5. **Write the `Preserved / Dropped / Still-uncertain` statement** into the target artifact. This is the declaration §24.2 names; keep it real and complete:
   - **Preserved** — the load-bearing items carried across (named concretely, not "all obligations").
   - **Dropped** — each dropped item in concrete terms, with where it survives instead (§24.1) or the matrix-row clause that permits it.
   - **Still-uncertain** — anything left open for the next stage rather than guessed (an unresolved `QUESTION` carried forward, a decision deferred). Lowering past an unresolved blocking `QUESTION` would commit a guess as an obligation — leave it visible here, do not silently resolve it.

6. **Check for a forbidden composition (§24.4).** If the crossing changes the artifact's epistemic stance — observation → intent, exploration → decision, diagnosis → authorization — confirm it is an explicit authoring re-statement (the source item becomes a target obligation with its own ID, modality, and `VERIFY BY`), not a silent re-read. If the target appears to contradict a higher-authority source, that is a `SOL-M004` for source authority to resolve, not something this fragment overrides.

7. **Do not finalize until every per-item row is justified.** The composing pass MUST NOT treat the crossing as complete while any MUST-survive row is dropped-without-justification or any forbidden composition is unresolved. Halt and revise; only then hand the target artifact to the composing pass for its own output contract.

## Output contract

- The target artifact carries a complete **`Preserved / Dropped / Still-uncertain`** statement whose three parts are specific (no "nothing dropped", no bare category names).
- The per-item check (step 4) exists and shows every §24.2 MUST-survive item from the source as `preserved` or `promoted to <target>`; no MUST-survive item is `dropped`.
- Every `dropped (justified)` row cites where the item survives (§24.1) or the matrix-row clause that permits the loss for this boundary.
- No epistemic stance crossed silently (§24.4); any stance change is a recorded re-statement, and any apparent contradiction with a higher-authority source is left to the `SOL-M004` authority path.

## Self-review delta

Before the composing pass treats the crossing as done, confirm:

- Did I pull the **correct per-boundary matrix row** (§24.2) for *this* crossing, rather than apply a generic budget? `spec → task` permits dropping only rationale-not-needed-for-execution; `research → spec` permits dropping rejected options and digressions — the columns differ.
- Is every **obligation ID, modality, `VERIFY BY` binding, authority, scope, constraint, invariant, non-goal, and unresolved `QUESTION`** from the source accounted for in the per-item check as `preserved` or `promoted`?
- Does the `Dropped` list name **concrete items with where they survive**, never categories?
- Did I avoid inventing any semantic meaning? This guide cites §24, §22, §15, and §18 for the budget, authority, proof, and scope rules — it defines none of them. If I found myself *deciding* what a modal means, what outranks what, or what counts as a valid proof, I overstepped; that is SOL/IR and the reference layer, not this fragment.
- For a stance-crossing boundary, is the crossing an **explicit re-statement** (§24.4), not a silent promotion of observation to intent?

## The sister discipline: promotion (the upward direction)

Distillation flows downhill; **promotion** flows up. When a task discovers something durable, the finding is promoted *upstream* (§23.4) rather than silently dropped at the boundary — routed to its target by the §23.4.2 discovery-to-target table and resolved to one of the seven promotion statuses before the task closes (§23.4). "Keep in the task only" is itself a recorded disposition (`rejected`, reason "execution-local"), not an omission. This is why step 3 admits **promoted to `<target>`** as a first-class disposition: a load-bearing item not carried *across* a downhill boundary may instead be promoted *up* one — what it must never do is vanish. The `promote` pass owns that routing; this fragment only marks the item as promoted rather than dropped.

## Bundled resources

- [`references/worked-example.md`](./references/worked-example.md) — a full `research.md → spec.swarm.md` walk-through applying this procedure, including the per-item check and the resulting `Preserved / Dropped / Still-uncertain` statement.
