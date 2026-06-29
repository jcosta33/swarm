---
type: adr
id: adr-0107
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0107 — Fast-track solo review via staleness detection, not an agent verdict

## Context

Solo / AI-heavy use is the hardest adoption case: the no-self-verdict gate
([ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) D8, [ADR-0056](./0056-adversarial-self-review-completion-discipline.md),
[ADR-0095](./0095-review-model-grounding.md), [ADR-0099](./0099-review-orchestration-and-role-routing.md))
is load-bearing but assumes a human who will look, so solo users pay full ceremony per change.
suspec-works#72.1 proposed a **provisional agent verdict** — but a self-issued verdict, even timed, is
exactly what the framework refuses. Ratified from RFC-fast-track-verdict.

## Decision

**Keep the human/independent gate; add an evidence-hash staleness signal — never an agent verdict.**

- The review packet pins the **reviewed commit SHA + an evidence hash** (over the diff + the cited
  evidence). `suspec check` re-validates the hash on any later check; a SHA/hash mismatch flips the
  packet to **`Stale`** — the lifecycle marker that already exists
  ([advanced-lifecycle](../reference/advanced-lifecycle.md): "prior Pass no longer trusted after text
  or evidence path changed") — and **re-routes to re-review (warns; does not hard-block merge).**
- The solo flow: the independent reviewer agent (`suspec-reviewer`, fresh context, no verdict) prepares
  the packet + the hash; the **human ratifies fast** because the prep is done and any later drift
  auto-flags. The verdict stays the human's; automation removes the *toil*, not the *judgment*.
- **Reconcile-only until measured** — no `checks.yaml` change lands here (ADR-0063). _Level:
  convention now / toolable when the hash re-validation ships._

This reframes #72.1's "verdict + expiry + escalate" as **detection + escalation** — the protective
intent survives; the no-self-verdict principle is untouched.

## Consequences

- Preserves no-self-verdict (the generator never scores its own loop); speeds solo prep + ratification.
- **Build deferred** (suspec-cli reconcile feature: the hash + the `Stale` re-validation). Reuses the
  existing `Stale` marker — no new lifecycle token.
- Open at implementation: exactly what the hash covers (diff / evidence cells / spec text). Recorded as
  a follow-up, not blocking the decision.

## Affected obligations / constraints

- **Reaffirms:** ADR-0077 D8 / ADR-0056 / ADR-0095 / ADR-0099 (the human owns the verdict; no
  self-verdict). **Reuses:** the `Stale` review marker.
- **Does NOT change:** the verdict model (Pass/Fail/Unverified/Blocked), or the checks contract.
