# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Change plan (baseline, batches, rollback): `change-plans/{{slug}}.md`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Refactor task** — restructure code while observable behavior holds, proven by an
> equivalence check that would fail on drift (a green suite is not one). Each file changed
> individually (no bulk codemods); checks run at every batch; every deletion proven safe by
> pasted search; every shim carries a removal criterion.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table; the test and check
> commands run together at every batch. For any command you need that is undefined, ask the
> user — do not guess.
>
> **Behavior moving?** If any observable behavior changes, this is no longer a refactor — it
> is a rewrite (behavior changes on purpose) or a migration (API A → B). Relabel the task and
> load that guide; do not proceed under the wrong label.

## Scope (from the task packet)

- Restructure: {{what moves / extracts / collapses / gets deleted}}
- Preserve: the ACs and guarantees the packet lists as held behavior.
- Do not change: {{areas the packet rules out}}; "while I'm here" improvements go to Findings.

## Equivalence check (captured before touching code)

How preservation is proven — the check that would *fail* if behavior changed: property-based,
differential (old path kept reachable behind a shim and diffed until clean), or golden-output
pinned before the change. If the existing suite is the only check, state why it is a
sufficient oracle for this change.

-

## Batch checkpoints

One row per batch — ~10 files is a useful default cadence; tighten it where the change plan
marks risk. Paste check output per batch: drift caught one batch old is cheap to undo;
accumulated drift is its own untangling project.

| Batch | Files in batch | Check output (pasted) |
|---|---|---|
| 1 | | |

## Compatibility shims

Record each shim *before* introducing it. A shim with no removable-when criterion is
permanent by default — exactly the debt the refactor was meant to reduce.

| Shim path | Forwards to | Removable when (verifiable) |
|---|---|---|
| | | e.g. `git grep -c '<old-name>' src/` = 0 |

## Deletion safety

For each deleted symbol: paste the search showing zero callers across source *and* tests,
plus a separate search for the symbol's **string form** (dynamic dispatch, registries,
reflection, generated code, config) that a call-syntax search cannot reach.

| Deleted symbol | Caller search (pasted) | String-form search (pasted) |
|---|---|---|
| | | |

## Progress checklist

- [ ] Packet and change plan read; scope recorded above
- [ ] Equivalence check captured; suite green before any change
- [ ] Each batch changed file by file — no bulk codemods; check output pasted per batch
- [ ] Every deletion proven safe — caller and string-form searches pasted
- [ ] Every shim documented with a verifiable removal criterion
- [ ] Old locations confirmed empty of what moved — nothing orphaned
- [ ] Equivalence check run after the final edit; output pasted
- [ ] Findings recorded; self-review answered

## Evidence (paste actual command output — never paraphrase)

- Per-batch check output (each batch):
- Final test + check output (last lines + exit):
- Equivalence check output (or the recorded sufficiency justification):
- Deletion searches (per symbol — call syntax and string form):

## Decisions

-

## Findings

Semantic improvements the restructuring tempted, neighboring debt, missing tests — candidates
for the workspace's `findings/` at Close.

-

## Blocked questions

-

## Next steps

Larger refactors span sessions — leave the next batch's concrete starting point.

-

## Self-review

Answer in writing, evidence pasted. Refactors fail in exactly two ways — a behavior delta
smuggled in under the "purely internal" label, and a shim that quietly becomes permanent.

- **Equivalence:** would the check fail if behavior had changed — and did it pass after the
  final edit, output pasted? If the suite was the only oracle, is the sufficiency reasoning
  written down?
- **Scope:** is the diff purely structural — no semantic tweak, no contract change? Anything
  in the old location that should have moved? Anything moved that should not have?
- **Deletions:** every deleted symbol backed by pasted caller and string-form searches?
- **Shims:** every shim carries a mechanically checkable removal criterion; none that this
  task should have removed survives?
- **Cadence:** did checks run at every batch with output pasted — or did checking slip to
  the end?
- **Handoff:** findings recorded; no review result issued on your own work.
