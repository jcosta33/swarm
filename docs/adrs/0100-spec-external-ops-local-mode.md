---
type: adr
id: adr-0100
status: accepted
created: 2026-06-24
updated: 2026-06-24
---

# ADR-0100 — Spec-external, ops-local: resolve the implementer straddle without committing ops artifacts

## Context

A dedicated workspace repo governing a sibling code repo (a field report, suspec-works #64) creates
an **implementer straddle**: the implementer reads a spec in repo A but, while editing code in repo B,
also writes a run summary and flips a board row back in repo A. It is the **writes that cross the
boundary** that break things — a single cross-repo read is cheap and safe. Observed failure modes when
writes straddle:

- path-scoped tools (repo-bound MCP context, indexers, grep helpers) refuse the second root;
- the sandbox / permission scope binds to cwd, so edits + commands in the other repo trip or block;
- no atomicity — the diff and its evidence live in different histories;
- wrong-root commands → false greens (`test`/`build` run from the workspace "pass" by not running);
- brittle relative paths and cross-boundary link rot.

The code repo's pristine principle is **[ADR-0050](./0050-suspec-is-a-spec-repo-discipline.md)** /
**[ADR-0062](./0062-code-repo-adapter.md)** (code repos stay pristine; the workspace holds intent and
evidence; a future CLI may own a **gitignored** `.suspec/` local-state dir) — *not* ADR-0001, which
#64 cited in error. #64 framed the choice as "hold pristine" vs "accept a **committed** `.suspec/`."

## Decision

Hold the pristine principle; resolve the straddle **without committing ops artifacts** to the code repo.
This is a third workspace mode alongside co-located and dedicated.

1. **Spec-external, ops-local.** Canonical specs / tasks / reviews / findings / board stay in the
   dedicated workspace (durable, cross-cutting — ADR-0050/0062). The implementer's **ops scratch** —
   its working run state — lives in a **gitignored `.suspec/`** in the code repo (the local-state dir
   ADR-0062 already sanctions), so the implementer's entire **write + command surface is one root**.
   The code repo's committed history stays pristine. _Level: convention._

2. **Snapshot the spec slice into the task at split.** When `split-work` cuts a task for this mode, it
   **snapshots the relevant spec slice into the task packet**, stamped with the spec id +
   version/commit it was cut against, and places the task in the code repo's gitignored `.suspec/`. The
   implementer then reads **zero cross-repo** (fully single-root) and the spec **cannot drift mid-task**
   (pinned). The external workspace stays canonical; the in-code copy is an explicitly-marked execution
   snapshot, not authoritative. _Level: convention._

3. **The low-frequency roles do the crossing.** The implementer reads the pinned snapshot and writes
   only in the code repo. The **review lead / closer** ([ADR-0099](./0099-review-orchestration-and-role-routing.md))
   — low-frequency, more careful — merges the run evidence back into the canonical workspace: updates
   `status.md`, the canonical task status, and writes the review packet there. The straddle is
   **relocated** from the high-frequency implementer to the low-frequency closer, not deleted.
   _Level: convention._

4. **The board stays in the workspace.** `status.md` remains the canonical index in the dedicated
   workspace; the code repo's `.suspec/` is gitignored scratch, never the board. _Level: convention._

## Named, not shipped (honesty framework, [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md))

- **Cross-root `suspec check`.** With the spec slice pinned into the task, C009 (broken-source-link)
  and C012 (coverage) can validate the task against its **embedded snapshot** in-repo (self-contained),
  with the canonical pointer kept for provenance. Teaching the checker the cross-root/snapshot case is a
  **suspec-cli toolable follow-up** — named here, not shipped; no `checks.yaml` change lands with this
  ADR.
- **The skill mechanism.** `split-work` (emit the task into the code repo's `.suspec/` + snapshot/pin
  the spec slice) and `implement-task` (assume single-root; read the pinned snapshot; never write
  outside the code repo) carry the behavior. Specified here; the kit-guide edits are the follow-up.
- **Re-snapshot policy.** If the canonical spec changes materially after a task is cut, **re-cut the
  task** (re-snapshot). The pinned snapshot is the contract for that run.
- **Findings / decisions stay external** (canonical, cross-cutting); the closer straddles for those —
  accepted, because it is low-frequency.

## Consequences

- **The pristine principle holds** (ADR-0050/0062): no committed ops artifacts in code repos. The
  gitignored `.suspec/` is ADR-0062's existing escape hatch, now given an explicit mode + a snapshot
  mechanism. The committed-`.suspec/` alternative #64 floated is **not** adopted.
- **Single-root execution for the implementer** — cwd-scoped tools, sandbox, and commands resolve
  against one root; no wrong-root false greens.
- **Code+evidence atomicity is not achieved** — evidence is canonical-external. Accepted: the closer
  reconciles and the PR links the canonical packet (ADR-0062). A team that needs hard atomicity should
  choose the co-located layout instead, and say so.
- **Pick the mode deliberately.** The failure case is running the dedicated layout with this mode's
  expectations (or vice versa); the code repo's `AGENTS.md` pointer carries a mode marker so an agent
  knows which root owns what.

## Propagation

`docs/03-where-files-live.md` (the third mode), `docs/ADOPTING.md` (its layout + the gitignored
`.suspec/` + the snapshot), the kit `split-work` + `implement-task` guides (the snapshot-at-split /
single-root mechanism — the named follow-up), and the code-repo `AGENTS.md` pointer (a mode marker:
commands + ops scratch in the code repo's gitignored `.suspec/`; never write canonical artifacts here).
The cross-root C009/C012 check is a suspec-cli follow-up.

## Affected obligations / constraints

- **Extends:** [ADR-0062](./0062-code-repo-adapter.md) (the gitignored `.suspec/` local-state dir) and
  [ADR-0050](./0050-suspec-is-a-spec-repo-discipline.md) (the code repo stays pristine).
- **Reaffirms:** [ADR-0099](./0099-review-orchestration-and-role-routing.md) — the review lead / closer
  does the cross-repo merge-back.
- **Does NOT change:** the pristine principle, the verdict model, or the checks contract.
