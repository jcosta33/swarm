---
type: adr
id: 0044-kernel-is-derived-and-self-contained
status: accepted
created: 2026-06-04
updated: 2026-06-04
supersedes:
superseded_by:
---

# ADR-0044: The kernel is a derived, self-contained payload — `docs/` is canonical for the language/passes twins

> **Retired by [ADR-0051](./0051-complete-the-spec-repo-pivot.md).** The twin mechanism this ADR established
> is **gone**: the starter kit ships no `language/`/`passes/`, so the derived twins served no purpose and were
> **deleted**. `docs/language/` and `docs/passes/` are now the **sole** canonical home — no second copy to
> eyeball-diff. (Earlier, ADR-0049 had only relocated the twins; 0051 removes them.)

## Context

`docs/language/` ↔ `starter-kit/.agents/language/` and `docs/passes/` ↔ `starter-kit/.agents/passes/` are
maintained as **duplicate copies** (the rule recorded in this repo's `AGENTS.md`). In practice they
are *divergent re-renderings*: a 13-file-pair analysis found that neither side is uniformly more
current — the kernel is ahead on some pairs
(`errors.md` carries a ~95-line legacy-code translation table absent from `docs/`; `lint.md` carries
the `APS-`-prefix-retirement facts; `promote.md`/`improve.md` carry the self-standing clause and an
author-judgment section) while `docs/` is ahead on others (`decompose.md` is the only fully
de-sectioned pass file and carries ~140 lines of normative scope-vocabulary the kernel lost; `SOL.md`
carries a `CONSTRAINT WHERE`-clause the kernel regressed). The hand-maintained twin is the recurring
**"fix one copy, miss the twin"** defect.

The same analysis surfaced a **larger, latent defect the twins were hiding: the shipped kernel is not
actually self-contained.** An adopter installs `starter-kit/.agents/` into `.swarm/kernel/` and receives
**no `docs/`** and **no §-numbered monolith** — yet the kernel files carry **614 `§N` references and 9
`Appendix-X` references** that resolve only against the frozen, never-shipped build source
(`.agents/specs/swarm/`), including in the **always-loaded `starter-kit/AGENTS.md`** (`§14`/`§17`/`§20.5`/…)
and in `conformance.yaml` (`§21`/`§25`/`§32`/`§33`, plus `catalogue_ref: docs/language/errors.md`
pointing at a path the adopter never gets). Several kernel files also still carry **migration framing**
the de-pivot forbids ("the earlier 4-value enum is upgraded", "merges legacy Bind+Trace", "two competing
payloads are reconciled").

This ADR decides the steady-state shape of that payload. (The *execution* — the one-time reconciling
merge, the §-rewrite, and the bug fixes the analysis catalogued — is the K2 work item, run pair-by-pair
under this decision.)

## Decision

1. **`docs/` is the single canonical source** for the `docs/language/` ↔ `starter-kit/.agents/language/`
   and `docs/passes/` ↔ `starter-kit/.agents/passes/` twins. `starter-kit/.agents/language/` and
   `starter-kit/.agents/passes/` are **derived, checked copies** — established after a **one-time reconciling
   merge** that pulls every kernel-only load-bearing fact *up* into `docs/` and fixes `docs/`'s own gaps,
   so the canonical `docs/` corner is a true superset of load-bearing content. This **refines**
   [0040](./0040-kernel-payload-directory.md) and relates to [0042](./0042-skill-carrier-and-standalone-conditioning.md)/[0016](./0016-skills-are-self-contained.md) (thin skills cite-don't-define) and [0041](./0041-two-axis-versioning.md).

2. **The kernel is self-contained and MUST resolve offline** for an adopter who receives no `docs/`.
   Therefore the kernel MUST NOT cite `§N`/`Appendix-X` anchors from any document it does not ship,
   MUST NOT link into the docs-only trees (`model/`, `reference/`, `artifacts/`, `research/`,
   `PRINCIPLES.md`, `library/`, `grammar.md`), and `conformance.yaml`/`AGENTS.md` MUST NOT reference
   `docs/` paths. Deriving the kernel *from* `docs/` does **not** make `docs/` defer to the kernel — the
   kernel is a payload, not a peer; `docs/` remains self-standing.

3. **`grammar.md` stays docs-only** (not a fourth twin): no kernel file references it, and the kernel
   `SOL.md` already carries its own inline EBNF. (The docs-internal EBNF triplication — `grammar.md`
   vs `SOL.md` fragments — is a separate docs-layer item, not part of this twin decision.)

4. **The kernel is derived, NO-RUNTIME.** An agent (or a future tool) copies the canonical `docs/` file and
   applies fixed, mechanical rewrites: strip the `[[KEY]]` research citations; rewrite cross-document
   `§N`/`Appendix` refs and docs-only-tree links to the kernel file that owns the content (or inline the
   small fact); drop docs-only depth. The "check" is an **eyeball-diff** of the two on any twin edit — every
   surviving difference must map to one of those rewrites. Neither build nor check is shipped code.

5. **Self-containment + the coherence gate.** The kernel cites no `§N`/`Appendix` from a document it does
   not ship. The only legitimate `§N` use is a **local self-reference** to a file's own numbered sections —
   e.g. `versioning.md`'s `§1`–`§4` headings, or `SOL.md`'s `§2.4`/`§3.8` references to its own numbered
   `2.4`/`3.8` sections (headed as a bare number, cited with the `§` prefix). `conformance.yaml`/`starter-kit/AGENTS.md`
   reference no `docs/` paths. The gate is a grep: fail if any shipped file carries a `§N`/`Appendix` token
   that does not resolve to a numbered section heading in the **same file**, or a `docs/` path.

6. **Execution discipline:** the merge runs **pair-by-pair** (the merge direction differs per pair —
   `decompose.md` regenerates the kernel *from* docs; `errors.md`/`lint.md`/`promote.md` merge kernel→docs),
   running the eyeball-diff check **after each pair**. Never a single bulk copy — that would destroy the
   more-current side. `conformance.yaml` and `starter-kit/AGENTS.md` (always-loaded entry points) are fixed
   **first**.

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| **Kernel canonical, `docs/` rendered from it** | The reverse transform is lossy/ambiguous (you would have to *add* citations, §-context, and the docs-only-depth sections); and `docs/` is the rich human corner that carries the `[[KEY]]` research citations, which must stay there. |
| **Hybrid steady-state (different canonical side per pair)** | Multiplies the rules a human/agent must remember and reintroduces the exact "which copy is truth" confusion the effort exists to kill. (The *one-time* K2 merge is per-pair by necessity, but the steady state is single-direction.) |
| **Keep hand-maintained twins** | The status quo — the recurring "fix one, miss the twin" defect, plus it left the self-containment defect undetected. |
| **Vendor `docs/` into the adopter so the kernel can link it** | Re-bloats the install with the human tutorial layer the minimality evidence (ADR-0043) warns against, and defeats the operational-payload-vs-upstream-reference split. |
| **Add `grammar.md` as a fourth twin** | No kernel file needs it; the kernel `SOL.md` already carries its own EBNF — adding it would *create* a new twin defect. |

## Consequences

### Positive

- One canonical home per body of content; the twin becomes a **checked invariant**, not a silent-drift
  hazard. The "fix one, miss the twin" defect class is closed.
- The shipped kernel becomes **genuinely self-contained** — it resolves offline for an adopter, fixing a
  latent defect (614 dangling refs) the twins were hiding.
- The de-pivot and several real bugs (the `SOL` `WHERE`-clause regression, the dropped `review.md`
  `## Claimed coverage` row, the `improve.md` Skeptic-excludes-improve contradiction, the lost
  `lower.md` plan-before-execute sentence, the `decompose.md` content loss) are corrected as part of the
  reconciliation rather than persisting in shipped content.

### Negative

- The one-time K2 reconciliation is **large and high-risk** (shipped normative content across 13 pairs +
  a 614-reference §-rewrite + `conformance.yaml`/`AGENTS.md`); it must run pair-by-pair with the
  eyeball-diff check after each, never bulk.
- The derivation transform is mostly mechanical but has **one non-mechanical rule** — re-homing a
  docs-only-tree link or cross-document `§N`/`Appendix` ref to the kernel file that owns the content
  (item 4) — which must be maintained by hand as the docs-only tree evolves.

### Neutral / tradeoffs

- No canonical closed set changes (7 block types · 5 modals · 7 verdicts · 9 proof types · 7 phases ·
  9 passes · 10 improve ops · 5 lint layers · 7 edge types · 17 `task_kind`); the merge keeps the full
  set canonical in `docs/` and renders subsets deterministically.
- Until a future tool exists, the derivation and the check are **agent-run procedures** (Invariant 1,
  NO RUNTIME) — the contract a launcher will later automate without changing its semantics.

## Status

Accepted (v0.1). The one-time reconciling merge + §-rewrite (the K2 work) is done: the twins are
single-sourced and the kernel resolves offline.

## Affected obligations / constraints

- Adds: the canonical-direction rule (`docs/` canonical, kernel derived); the kernel self-containment
  invariant (no unshipped `§N`/`Appendix-X`, no docs-only-tree links, no `docs/` paths in
  `conformance.yaml`/`AGENTS.md`); the derive-from-`docs/` rule + the eyeball-diff check; the coherence gate.
- Modifies: the `AGENTS.md` "docs↔kernel are duplicate copies, propagate by hand" rule → "`docs/` is
  canonical; the kernel is derived and checked".
- Refines: [0040](./0040-kernel-payload-directory.md). Relates to [0042](./0042-skill-carrier-and-standalone-conditioning.md), [0016](./0016-skills-are-self-contained.md), [0041](./0041-two-axis-versioning.md), [0034](./0034-unified-lint-namespace.md).
- Does NOT change: any canonical closed set, the obligation grammar's meaning, or the artifact set.
