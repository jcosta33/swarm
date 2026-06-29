---
type: adr
id: adr-0103
status: accepted
created: 2026-06-25
updated: 2026-06-25
---

# ADR-0103 — The spec is a living form; the task is an on-demand split slice

## Context

The dominant path is `1 spec → 1 task` (`split-work`: "most specs become exactly one task packet"),
and in that case the task **repeats the spec**: the spec's ACs already carry their own `Verify with:`
lines, so the task's `## Verify` restates them; `scope` is "all of it"; `Agent instructions` are
boilerplate. Only the execution record (`Run summary` / `Self-review` / `Findings`) carries weight —
and that is *run* content, not a second contract. The result is a pass-through station that doubles the
spec (suspec-works#72 ceremony; the session deliberation; RFC-lean-artifact-set D1).

The task earns its keep for one job the spec cannot do: a **write-disjoint scope slice** when one spec
splits into **N parallel** tasks. So the move is to **demote** the task, not delete it.

Verified safe to do additively: **no check or parser rejects an extra spec section** — the SOL parser
records an unrecognized heading and moves on; C005/C006 are presence-only; ADR-0058's "frozen list" is
a convention, not an enforced reject. So adding an optional section breaks no existing spec, check, or
parse.

## Decision

1. **The spec is the unit of work and a living form.** It is authored as intent, then **filled as the
   work is done**, with a hard internal seam:
   - **Contract — frozen at `ready`:** `## Intent`, `## Requirements` (ACs + `Verify with:`),
     `## Non-goals`, `## Open questions`, `## Affected areas`, `## Dropped from sources` (the ADR-0058
     list, unchanged). These do not change after `ready` except through spec re-review (the drift rule).
   - **Execution — append-only, after `ready`:** a new **optional** `## Execution` section the
     *implementer* fills — affected areas touched, per-AC verify results citing pasted output, a run
     summary, and the ADR-0056 self-review. Appended; it never rewrites the contract. This **refines
     ADR-0058** by adding one optional section (additive — verified to break nothing). _Level: convention._

2. **In the 1:1 case there is no task file.** The implementer reads the spec, implements, and fills the
   spec's `## Execution`. The **review packet stays a separate artifact** in `reviews/` — independence
   (`implementer ≠ reviewer`, ADR-0056/0099) holds because it attaches to the *work*, not the file, and
   the verdict lives in a file the implementer does not write.

3. **The task is an on-demand split slice.** When one spec must become **N parallel** tasks,
   `split-work` cuts a task per slice (a scope-subset + `Do not change` + `Affected areas` + a pointer
   to — or, in spec-external mode, a pinned snapshot of — the spec, ADR-0100). Each slice carries its
   own execution + review. A task is cut **only** when the work decomposes; it is no longer a
   pass-through station. This **refines ADR-0030**: `task.md` stays a shipped Tier-1 template but is
   demoted from an always-present station to an on-demand artifact. _Level: convention._

4. **Coverage keys on whatever scopes the work** (refines [ADR-0079](./0079-c012-coverage-check.md)):
   the review's coverage is checked against the **task's `scope` when a task exists**, and against the
   **spec's AC ids when it does not** (the 1:1 case). _Level: convention now; the suspec-cli reconcile
   adapts as a tracked follow-up._

## Consequences

- **Additive, not breaking.** Existing specs (no `## Execution` yet) stay valid; existing tasks stay
  valid; no parser or check change ships. The `## Execution` section is optional markdown.
- **The 1:1 path loses a file and a layer of repetition** — the spec is written once and grows its run
  record; the reviewer reads the spec's contract + execution and writes the separate packet.
- **Independence + the verdict model are untouched** — the review packet is still a separate artifact;
  the spec author / implementer / reviewer roles attach to the work (ADR-0099).
- **Reference impl (suspec-cli / suspec-mcp) adapts as a tracked follow-up** (specified-vs-shipped,
  ADR-0063): `new task` becomes the split tool; `suspec check`/`review` coverage keys on the spec when
  no task; `scan_task` reads the spec's `## Execution` in the 1:1 case. The CLI keeps working in the
  meantime (the task artifact still exists).
- **Honesty:** convention-level; no `checks.yaml` rule or contract bump lands here.

## Propagation

The kit spec template (add `## Execution`), the task template (reframed as the on-demand slice),
`docs/02-basic-workflow.md` + `docs/06-creating-tasks.md` (spec is the unit; task on-demand),
`split-work` (cut a task only when decomposing; otherwise fill the spec's `## Execution`),
`implement-task` (1:1 → fill the spec's `## Execution`; split → the task), and `review-output`
(review the spec's ACs + execution when there is no task). suspec-cli/mcp adaptation tracked.

## Affected obligations / constraints

- **Refines:** [ADR-0058](./0058-two-tier-spec-format.md) (one optional `## Execution` section added),
  [ADR-0030](./0030-unified-artifact-set.md) (`task.md` demoted to on-demand), and
  [ADR-0079](./0079-c012-coverage-check.md) (coverage keys on the spec when no task).
- **Reaffirms:** [ADR-0056](./0056-adversarial-self-review-completion-discipline.md) /
  [ADR-0099](./0099-review-orchestration-and-role-routing.md) (independence, the separate review packet)
  and [ADR-0100](./0100-spec-external-ops-local-mode.md) (the split slice carries the spec snapshot).
- **Does NOT change:** the contract section list's freeze-at-`ready`, the verdict model, or the checks
  contract.
