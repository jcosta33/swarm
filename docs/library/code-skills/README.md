# Implementation guide library

Optional, advanced guides for agents implementing tasks in a **code repo**. The starter kit's
`implement-task` guide already covers every task: read the sources first, stay in scope, run every
Verify item and paste real output, self-review your diff before handoff. The guides here add depth
for specific shapes of change — a bug fix, a refactor, a migration — where the generic rules are
necessary but not sufficient. None of this ships in the starter kit, and none of it is required.

Copy a guide into a code repo's skills directory when its kind of work comes up often enough to
deserve the conditioning. Each guide is a `SKILL.md` — auto-discoverable by agent CLIs, plainly
readable by humans. Everything in a guide is a convention the review packet inspects; nothing here
runs or enforces anything.

## The guides

| Guide                                                  | Use for                                          | The rule that does the work                                              |
| ------------------------------------------------------ | ------------------------------------------------ | ------------------------------------------------------------------------ |
| [`implement-task/`](implement-task/SKILL.md)           | any task packet — the long form of the kit guide | evidence or it didn't happen; no review result on your own work          |
| [`write-feature/`](write-feature/SKILL.md)             | net-new behavior                                 | map every AC to a part of the change before coding                       |
| [`write-fix/`](write-fix/SKILL.md)                     | a reported defect                                | regression test red before the patch, green after                        |
| [`fix-flaky-test/`](fix-flaky-test/SKILL.md)           | a test that fails sometimes                      | reproduce by looping the test; prove the fix the same way                |
| [`write-testing/`](write-testing/SKILL.md)             | tests as the deliverable                         | flip the assertion — the test must fail, then pass when restored         |
| [`write-refactor/`](write-refactor/SKILL.md)           | restructuring, behavior preserved                | an equivalence check that would fail on drift — a green suite is not one |
| [`write-rewrite/`](write-rewrite/SKILL.md)             | behavior changes on purpose                      | the recorded delta is the contract; everything else is preserved         |
| [`write-migration/`](write-migration/SKILL.md)         | API A → API B at scale                           | old-API callsites grepped to zero, string forms included                 |
| [`write-performance/`](write-performance/SKILL.md)     | a measured bottleneck                            | baseline before any edit; identical protocol on both sides               |
| [`write-documentation/`](write-documentation/SKILL.md) | docs humans read                                 | run every example; cite every behavior claim to file:line                |

Each per-kind guide bundles a `references/task-template.md` — a working-notes scaffold for the run. The task
packet itself always uses the kit's task template; the scaffold is where the agent keeps its plan,
pasted outputs, and self-review while working.

The `write-documentation` guide carries the Documentarian review stance folded in; the other
stances fold into the kit and advanced guides (see
[review stances](../../reference/review-stances.md)).

## Coordinating parallel tasks

When several agents run at once, preliminary evidence places the failure surface at the handoff, not in the workers
[[PLANCODER]](../../research/sources.md#PLANCODER) — and merges add their own. Conventions that hold the line — review
inspects them; nothing enforces them:

- **One worktree (or branch) per task, and write-disjoint scopes.** Two tasks that need the same
  file are sequenced, never run together. Decide this from the task packets' affected areas before
  any agent starts.
- **Hand off data, not vibes.** Each task packet names its sources, scope (requirement IDs),
  do-not-change list, and Verify checklist. A vague subtask description is the defect; the packet
  is the countermeasure.
- **A stalled task gets one recorded decision** — re-scope, escalate, or abandon, with the reason —
  so the run can be reconstructed from the artifacts, not from memory.
- **A non-trivial merge conflict is not resolved by a green suite.** The suite may not cover the
  interaction; check that both sides' intent survived the resolution.
- **Behavior a task discovers it needs but was not given goes back to the spec** as a finding or a
  blocked question — never silently absorbed into the task.
- **Merge on the review packet, not on the worker's summary.** Whoever coordinates does not skip
  the review step, and never reviews a diff they wrote.

## Related

- The starter kit's core guides: `starter-kit/agent/{write-spec,implement-task,review-output}/`.
- The kit's templates (task packet, review packet, finding): `starter-kit/templates/`.
