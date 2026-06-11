---
name: write-refactor
type: agent-guide
description: >-
  Implement a refactor task: restructure code while observable behavior holds,
  proven by an equivalence check that would fail on drift — a green suite is
  not one. ALWAYS apply when a task packet restructures, extracts, cleans up,
  or removes dead code with behavior preserved. Never change behavior, bulk-
  codemod, delete a symbol without pasted grep evidence of zero callers, or
  leave a shim without a removal criterion. Skip deliberate behavior changes
  (rewrite), API/version moves (migration), performance tuning, and net-new
  features.
---

# Implement a refactor

Restructure code so it reads, factors, or layers better — **without moving any observable
behavior**. A refactor fails in exactly two ways: a behavior delta smuggled in under the "purely
internal" label, and a compatibility shim that quietly becomes permanent. This guide adds the
refactor discipline on top of the base `implement-task` rules. These are conventions the review
packet inspects — nothing enforces them at edit time.

Plan the transformation first — the workspace's change plan covers baseline, waves, and rollback;
this guide is the execution half. The defining test: if any observable behavior moves, the work is
no longer a refactor — it is a rewrite (behavior changes on purpose) or a migration (API A → B).
Stop and say so; do not proceed under the wrong label.

## Rules

1. **Prove preservation with an equivalence check that would fail if behavior changed** — not with
   a green suite. A passing suite covers only what was already tested; a behavior delta in an
   untested corner passes silently. The strongest available oracle is the gate: property-based,
   differential (keep the old path reachable behind a shim and diff the two until clean), or
   golden-output pinned _before_ the change. If no stronger check than the suite exists, write down
   why the suite is a sufficient oracle for this change — "the suite is green", alone, is not that.
2. **If a test fails after your change, the behavior changed.** Investigate before touching the
   test — adapting a test to a new result is how a rewrite disguises itself as a refactor.
3. **Each file changed individually — no bulk codemods.** A `sed`/codemod sweep across hundreds of
   files hides the one context-specific callsite the pattern does not fit; the green-looking global
   edit is structurally blind to its outliers. Read, change, and check each file deliberately.
4. **Run the checks at every batch, not only at the end.** A layering violation caught one batch
   old is cheap to undo; accumulated drift is its own untangling project. Paste output as you go.
   ~10 files is a useful default batch size; tighten it where the change plan marks risk — "one
   batch" that turns out to be the whole diff is the end-loaded checking this rule exists to
   prevent.
5. **Prefer deletion over modification — and prove every deletion safe.** For each deleted symbol,
   paste the search showing zero callers across source _and_ tests, plus a separate search for the
   symbol's **string form** (dynamic dispatch, registries, reflection, generated code, config) that
   a call-syntax search cannot reach. "I checked, it's unused" is not evidence; the uncaught caller
   fails in production.
6. **Every shim gets a verifiable removal criterion before it is introduced**: its path, what it
   forwards to, and a mechanically checkable removable-when condition (e.g.
   `git grep -c '<old-name>' src/` returns 0). A shim without one is permanent by default — exactly
   the debt the refactor was meant to reduce.
7. **No "while I'm here" semantic improvements.** A tempting behavior tweak mid-move is a stop
   signal: it is a behavior change wearing a refactor's clothes. Note it as a finding candidate.
8. **After a relocation, confirm the old location is empty of what moved.** A leftover orphan is
   invisible until something still references it.
9. **Paste real output; resolve commands from `AGENTS.md`; ask when one is undefined.** And never
   write a review result on your own work.

## Refuses

| Temptation                                                | Do instead                                                                      |
| --------------------------------------------------------- | ------------------------------------------------------------------------------- |
| "It's faster to run a sed over all 200 files"             | One file at a time; the sweep buries the outlier                                |
| "I'll improve the semantics while I'm restructuring"      | That is a different change in a different scope — note it, don't fold it in     |
| "I'm pretty sure this code has no callers"                | Grep source, tests, and the string form; paste the output, then delete          |
| A shim added with no removal criterion                    | Give it a path, a forward target, and a removable-when check — or do not add it |
| "The test failed after my refactor, so I'll fix the test" | A failing test means behavior changed; investigate first                        |
| A green suite offered as equivalence evidence             | Demand the check that would fail on drift, or record why the suite suffices     |
| A public contract changed under a "cleanup" label         | That is a rewrite or migration decision — surface it                            |
| Silencing an unrelated checker complaint to get green     | Fix the violation or report it; never edit the gate                             |

## Self-review gate

Before declaring the task done:

- [ ] The equivalence check (or the recorded sufficient-oracle justification) is pasted, and it
      would fail if behavior had changed.
- [ ] Every deleted symbol carries pasted grep evidence — call syntax and string form — of zero
      callers.
- [ ] Every shim has a documented, verifiable removal criterion.
- [ ] Checks ran at every batch and after the final edit; output pasted.
- [ ] The diff is purely structural — no semantic tweak, no unauthorized contract change, no file
      touched merely because it was open.
- [ ] Old locations are empty of what moved; nothing orphaned.
- [ ] The summary names changed files, commands with output, and finding candidates; you issued no
      review result on your own work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run (equivalence check, batch
  checkpoints, shim table, deletion-safety searches, self-review). The task packet itself uses the
  kit's task template; the baseline, batch plan, and rollback live in the change plan.
