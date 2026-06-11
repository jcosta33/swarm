# Source Authority

Source authority is the **deterministic procedure** a conformant Swarm repo uses to decide, when two artifacts assert conflicting obligations, **which obligation governs** — and, by the same ladder, **who may approve** an edit to the obligation set. It is the conflict-resolution complement to the spec's obligations: the obligations record *what* must hold and how they relate; source authority records *which wins* when they disagree and *whose authoring act* settles a change.

Authority is **not** a planning hint and **not** a confidence score. It is the binding precedence order, and it is the only sanctioned alternative to silently letting the most recently written artifact win.

As with everything in Swarm, this is **NO-RUNTIME**: source authority is a contract (a precedence procedure plus lint codes) that a future tool builds against. Nothing here ships a resolver.

## The two axes

The model has **two orthogonal axes**, applied **lexicographically — domain first, then artifact**. The two questions ("how authoritative is the *container*" and "how authoritative is the *domain*") are genuinely independent, so the spec ranks them independently and combines them in a fixed order rather than collapsing them into one ladder.

### Axis A — artifact authority (backward trace)

Axis A ranks an obligation by **the kind of artifact that contains it** and that artifact's lifecycle status. It answers "how settled is the container this obligation was traced back *from*." It is the **backward-trace** axis: follow an obligation back to its source artifact and read its rank.

| Rank | Artifact (with required status) | Notes |
| ---- | ------------------------------- | ----- |
| 1 (highest) | accepted `adr.md` | Immutable decision; the strongest recorded intent. |
| 2 | approved `spec.md` | The behavioral contract (`status: approved`). |
| 3 | accepted `finding.md` | A durable project fact (`status: accepted` or `promoted`). |
| 4 | reviewed `audit.md` | Present-state observation that passed a `review` step. |
| 5 | reviewed `research.md` | External / exploratory evidence that passed a `review` step. |
| 6 | task notes (`task.md`) | Execution-local; durable only after promotion. |
| 7 (lowest) | chat | Conversational context; never authoritative on its own. |

A conformant tool MUST reject (lint `SOL-M004` authority-conflict) any claim that a **lower-ranked** artifact silently amended a **higher-ranked** one. (An irreconcilable *equal-rank* conflict is the distinct `SOL-M002`; see step 3 below.) An artifact below `approved`/`accepted` status occupies the rank of its **draft tier**, one step below its accepted tier — e.g. a `proposed` ADR does not outrank an `approved` spec.

### Axis B — domain authority (forward governing force)

Axis B ranks an obligation by **the governance domain it belongs to**, independent of where it is written. It answers "how much *forward* governing force this obligation projects over everything downstream." It is the **forward-governing-force** axis.

| Rank | Domain | Examples |
| ---- | ------ | -------- |
| 1 (highest) | `enforced-policy` | Deterministic, externally-enforced rules: write-surface gates, secret redaction, permission denies. |
| 2 | `compliance` | Regulatory / legal obligations (data residency, retention, audit trails). |
| 3 | `security` | Authn / authz, secret handling, attack-surface constraints. |
| 4 | `architecture` | Module boundaries, ownership, layering, public interfaces. |
| 5 | `product` | User-visible behavior, acceptance criteria. |
| 6 | `team` | Conventions, style, process agreements. |
| 7 | `task-map` | Per-task execution scoping. |
| 8 (lowest) | `memory` | Promoted findings / patterns. |

An obligation's domain MUST be discoverable **deterministically**. The `lower` step populates each structured node's `authority` by this precedence: the obligation's own `DOMAIN <name>` clause if present, else the spec frontmatter `domain:`, else the default `product`. The eight legal domain names are exactly the Axis-B ranks above (`enforced-policy` … `memory`); the two lowest, `task-map` and `memory`, are also the two axis **floors** (see Invariants).

## The conflict rule (normative)

Two obligations *conflict* when they constrain the same trigger / state / surface with **incompatible modality**. A conformant tool MUST resolve a conflict by this exact procedure, in order:

1. **Compare DOMAIN rank (Axis B) first — but only when at least one obligation is in the hard-policy band (Axis-B ranks 1–3: `enforced-policy`, `compliance`, `security`).** When a hard-policy-band obligation is involved, the **higher domain wins regardless of artifact rank** (a `security` obligation governs a `product` obligation even from a lower-ranked artifact). If **neither** obligation is in the hard-policy band, domain rank does **not** override artifact authority — go to step 2.
   - The in-band obligation exercises domain-dominance **only when it lives in a durable, reviewed artifact** (Axis-A rank ≤ 5 — accepted ADR, approved spec, accepted finding, or reviewed audit/research). A hard-policy claim living only in un-promoted task notes or chat (Axis-A ranks 6–7) MUST first be promoted to a durable artifact before it can govern; an un-reviewed note cannot override an accepted ADR.
2. **Otherwise** — neither obligation is in the hard-policy band, or the two are in the same domain — **compare ARTIFACT authority (Axis A).** The obligation in the higher-ranked artifact wins; if artifact rank also **ties**, the higher domain rank breaks the tie.
3. **If both axes are equal, STOP.** A conformant tool MUST NOT auto-select a winner. It MUST emit `SOL-M002` (semantic-layer contradiction) and route the conflict to amendment / review. **Resolution is an authoring act, never an inference.**

### The hard-policy band, restated

This ordering is **lexicographic with a hard-policy gate**:

- **Inside the hard-policy band** (Axis-B ranks 1–3): domain rank is decisive.
- **Below the band**: artifact authority is the most-significant key, and domain rank is only a tie-breaker.

This prevents a low-criticality domain note (e.g. a `team`-rank remark in a reviewed audit) from overriding a higher-authority artifact (e.g. a `product` obligation in an approved spec). Domain rank is decisive *only* inside the band; everywhere else, the container's settledness governs.

## Worked tie-break example

A reviewed `audit.md` records a **`security`** obligation: *the refresh endpoint MUST reject reuse of a rotated refresh token*. An approved `spec.md` records a **`product`** obligation: *the refresh endpoint MUST accept the most recent token presented, for a seamless re-login*. They conflict on the same trigger (reuse of a prior refresh token).

Applying the conflict rule:

1. **Axis B (domain).** `security` (rank 3) vs `product` (rank 5). Security outranks product, and security is in the hard-policy band. **Resolution stops here: the security obligation governs.**
2. **Axis A is never consulted** — even though the product obligation sits in a *higher*-ranked artifact (approved spec, rank 2) than the security obligation (reviewed audit, rank 4).

```sol
CONSTRAINT C-014: # from reviewed audit.md, domain: security
THE refresh endpoint MUST NOT accept a refresh token that has already been rotated
VERIFY BY security:cmdScan:auth-replay#rotated-token
AFFECTS auth.refresh
```

```sol
REQ AC-031: # from approved spec.md, domain: product
WHEN a client presents the most recent refresh token
THE refresh endpoint MUST issue a new access token
VERIFY BY test:cmdTest:auth-refresh#happy-path
AFFECTS auth.refresh
```

`C-014` (security) governs. The product REQ `AC-031` is **not deleted** — it is routed to amendment so its trigger can be narrowed to exclude rotated tokens. Had **both** obligations been `product`, the procedure would fall to Axis A and the approved spec would win over the reviewed audit.

### Second example (below the hard-policy band)

A reviewed `audit.md` records a **`team`**-domain note: *new modules SHOULD live under `src/v2/`*. An approved `spec.md` records a **`product`** obligation on the same surface. Neither is in the hard-policy band (ranks 1–3), so domain rank does **not** decide — **artifact authority does** (step 2), and the approved spec (rank 2) outranks the reviewed audit (rank 4). The product obligation wins; the audit note is advisory. Were the audit note instead a `security` obligation (in-band), step 1 would flip the result.

## Invariants on both axes

These hold on Axis A and Axis B simultaneously; no precedence computation may violate them.

| Invariant | Statement |
| --------- | --------- |
| **Code is reality, not intent** | Code and tests are implementation reality. They MAY **falsify** an obligation (producing `FAIL` / `CONTRADICTED` / `STALE`) but MUST NOT **silently amend** intent. A divergence routes to the three-way reconcile, never to a quiet edit of the obligation. |
| **Memory and task-map are a floor** | `memory` (Axis-B rank 8) and `task-map` (rank 7) are the lowest domains and never outrank any governing domain: a promoted finding or task-scoping note can **inform** but never **weaken** an obligation. A promotion that would weaken an obligation *as memory* is itself a `SOL-M004` authority-conflict. Promotion to a spec is a **domain-promotion**, not memory overriding intent — once a finding is re-stated as a spec obligation via the `promote` step it carries its **new container's** authority. That is intent acquiring rank, not the `memory` floor being breached. |
| **Planning hints reorder, never weaken** | `DEPENDS ON`, `parallel_group`, and other planning metadata change the **order** work runs in. They MUST NOT change modality, scope, or verification bindings of any obligation. |

## Bidirectional traceability framing

The two axes are the two directions of requirements traceability:

- **Axis A is the backward trace.** Given an obligation, you trace it *back* to the artifact it came from; the artifact's rank tells you how settled the provenance is.
- **Axis B is the forward governing force.** Given an obligation, you trace its domain *forward* over everything it governs; the domain's rank tells you how much force it projects downstream.

## Lint codes referenced here

| Code | Meaning |
| --- | --- |
| `SOL-M002` | Semantic-layer contradiction — an irreconcilable **equal-rank** conflict (conflict-rule step 3). Routes to amendment / review. |
| `SOL-M004` | Authority-conflict — a lower-ranked artifact (or actor) silently amending a higher-ranked one. |

(Both are in the `SOL-M` semantic layer; today they are enforced by hand or by the documented lint step, aspirational until tooling exists.)

## The high-oversight band (HITL escalation)

The `RISK` clause is otherwise inert in Swarm; the high-oversight band is where it is wired to a normative obligation. The rationale is that agents are unreliable at knowing **when to stop and ask a human**, so high-stakes work must not proceed on agent self-assessment alone. This too is a contract (a lint plus a verdict-field requirement), not a shipped escalation engine.

**An obligation is in the high-oversight band iff either holds:**

| Trigger | Condition |
| --- | --- |
| Declared critical risk | The obligation carries `RISK critical`. |
| Irreversible / shared write surface | Any surface in the obligation's `WRITES` set is tagged `integration` or `shared`. (Irreversible actions — migrations, destructive or non-replayable operations — MUST be modelled with an `integration` surface tag or `RISK critical` so band membership stays machine-checkable.) |

`RISK high` / `medium` / `low` do **not** enter the band on the strength of the tier alone, but any obligation at any tier enters the moment its `WRITES` touches an `integration` / `shared` surface, or it carries `RISK critical`.

**For an in-band obligation, a conformant repo MUST satisfy both:**

1. **Named-human REVIEW binding.** The obligation MUST carry a `manual @ REVIEW` proof binding (`VERIFY BY manual:…`) in addition to whatever executable proofs its task-kind default suite requires. The band's work cannot reach the merge gate on executable proofs alone.
2. **Named human on the verdict and on any waiver.** That `manual` verdict MUST name its human **authority**; and any `WAIVED` verdict on a band obligation MUST be issued by a **human or the spec owner**, never self-issued by a skill, persona, or the implementing agent. An in-band `manual` verdict or waiver lacking a named human authority is a `SOL-V010` diagnostic.

| Risk / surface | REVIEW binding | Verdict / waiver authority |
| --- | --- | --- |
| `RISK critical` (any surface) | `manual @ REVIEW` REQUIRED | Named human (verdict + any waiver) |
| Any tier, `WRITES` an `integration` / `shared` / irreversible surface | `manual @ REVIEW` REQUIRED | Named human (verdict + any waiver) |
| `RISK low` / `medium` / `high`, ordinary exclusive `WRITES` | Per task-kind default suite | MAY be agent-verified |

The "named human" is **not a new Swarm role**: *who* the human is stays unspecified and is bound locally by the adopting repository. Approval **authority** is resolved through the source-authority ladder above — the approver is the owner of the highest-ranked governing artifact in the relevant domain. A waiver on a band obligation is the ordinary `WAIVER` lifecycle, with mandatory `authority + reason + expiry` and auto-expiry on source-hash change; there are no permanent waivers and no agent-self-issued waivers in the band. Recording an agent-only verdict on a band obligation, or letting a skill self-issue a band waiver, is additionally a `SOL-M004` authority-conflict.

## Approval-required changes

The two axes decide which obligation *governs* when two conflict. A separate but adjacent question is which **edits** to the obligation set a conformant tool MAY apply on its own and which require an authoring act — an approval. The two questions share the same ladder: who governs a conflict is also who may approve a change in that domain.

The dividing line is **semantic effect**, expressed as a closed twelve-category semantic diff: an edit either *preserves* the meaning of every obligation it touches (pure normalization) or it *changes* what the system is obligated to build, what counts as proof, or which decision governs (an amendment). Only the single normalization category may be applied without approval; the other eleven are amendments and MUST route to amendment / review rather than being applied silently as a routine cleanup.

| Change type | Approval required |
| --- | --- |
| Add, remove, or renumber an obligation id (`AC-NNN` / `C-NNN` / `I-NNN` / `IF-NNN`) | Yes |
| Change an obligation's actor, trigger, modality, response, or non-goal | Yes |
| Make a breaking `INTERFACE` (`IF-NNN`) change | Yes |
| Materially resolve a `[blocking]` `QUESTION` | Yes |
| Accept a `manual` proof where no automated proof previously existed | Yes |
| Approve or supersede an `adr.md` | Yes |
| Promote a `finding.md` into an approved `spec.md` | Yes |
| Add, remove, or repoint a `VERIFY BY` proof binding | Yes — what counts as proof changed |
| Normalize formatting, casing, or surface-keyword form | No — normalization |
| Fix an editorial typo with no semantic effect | No — normalization |
| Add a missing link, or complete a reference to an **already-declared** proof, without changing meaning | No — normalization |
| Compress redundant prose while preserving semantics | No — normalization |

The "Yes" rows are exactly the edits that alter what the system must build, what counts as proof, or which decision governs — each is a non-normalization category in the semantic diff, so each MUST route to amendment / review, never be folded into a mechanical improvement step. The "No" rows are the single normalization category: semantics-preserving by definition, a conformant tool MAY apply them without approval. The rationale is that a normalization edit cannot, by construction, change any verdict; an amendment can, so it inherits the same authoring discipline as the obligation it edits.

### R-APPROVAL-AUTHORITY

Swarm defines **what** requires approval; it is deliberately silent on **who** approves. Approval **authority** for any "Yes" row is resolved through the same source-authority ladder that resolves conflicts: the approver is the **owner of the highest-ranked governing artifact in the relevant domain**.

- An ADR change is approved by the owner of the accepted `adr.md` (Axis-A rank 1).
- An obligation or `INTERFACE` change is approved by the owner of the approved `spec.md` (Axis-A rank 2).
- A cross-domain change is approved by the owner of the governing domain (Axis B) — e.g. a change touching a `security` obligation answers to the security-domain owner, not a `product` owner.

There is **no** undefined "human role" in Swarm. "Approval required: Yes" means precisely "an authoring act by the relevant source-authority owner is required," never an appeal to an unspecified gatekeeper. *Who* that owner is — identity, title, headcount — stays a local org decision bound by the adopting repository, exactly as the high-oversight band's named human does; Swarm fixes only that the act must come from the resolved owner. A change applied without the authority resolved by this ladder is itself a `SOL-M004` authority-conflict: a lower-ranked actor (an agent, a skill, an un-promoted note) silently amending a higher-ranked artifact.

This is the same authority that governs the high-oversight band above: a band obligation's `manual @ REVIEW` verdict, standing in for an automated proof, is the "Accept a `manual` proof where no automated proof previously existed" row of this table — an approval-required change whose authority is the relevant source-authority owner, not a new role.

## Related

- [SOL — the obligation language](./language/SOL.md) — the surface form of the obligations whose conflicts and edits this procedure governs.
- [Verify — verdict model and proof taxonomy](./passes/verify.md) — the `WAIVED` / `STALE` / `CONTRADICTED` lifecycle and the named-authority discipline a band verdict and waiver carry.
- [The `improve` step](./passes/improve.md) — where the single normalization category MAY be applied without approval; the "Yes" rows are exactly what `improve` may not silently apply.
- [The `promote` step](./passes/promote.md) — promotion of a `finding.md` into a spec, an approval-required change that gives the finding its new container's authority.
- [Swarm lint codes](./language/errors.md) — `SOL-M002`, `SOL-M004`, and `SOL-V010`, the diagnostics this procedure emits.
