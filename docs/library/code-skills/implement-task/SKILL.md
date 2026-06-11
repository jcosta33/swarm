---
name: implement-task
type: agent-guide
description: >-
  Implement a Swarm task packet, long form: read the sources first, stay inside
  scope, run every Verify item and paste real output, adversarially self-review
  your diff before handoff. ALWAYS apply when given a task packet (`type: task`)
  or asked to implement against a spec's requirements. Do not edit outside the
  task's scope, claim a result without pasted output, or write a review result
  on your own work. Skip for writing specs, reviewing another agent's output,
  and splitting work into tasks.
---

# Implement a task — long form

This is the deep version of the starter kit's `implement-task` guide — same rules, more rationale,
for teams that want the full conditioning in the code repo. The task packet bounds your work: a
scope of requirement IDs, areas not to change, and a Verify checklist. Your job is to satisfy
exactly that scope and leave behind evidence a reviewer can check without trusting you. Every rule
here is a convention the review packet inspects — nothing enforces them at edit time. And none of
them are fair-weather rules: the moment the work gets hard is precisely when they matter most — do
not soften a constraint under pressure to get to done.

## Rules

1. **Read the sources first.** The task packet, then the linked spec (and change plan, if any),
   before touching code. The packet says what to do; the spec says why, and how success will be
   judged. An agent that starts from the diff it imagines, rather than the requirements it was
   handed, optimizes for plausibility — and an ambiguity it never resolved becomes wrong code, not
   a question.
2. **One worktree (or branch) per task.** Keep this task's changes isolated so parallel tasks stay
   write-disjoint and the reviewer sees one clean diff. A diff that interleaves two tasks cannot be
   judged as either.
3. **Stay in scope.** Implement the ACs the packet lists — no more. If a requirement cannot be met
   as written, stop and say why instead of improvising. An improvised interpretation is a decision
   nobody made, landing where it is most expensive to find: in the code. The cheap place to resolve
   it is a blocked question in the summary, before more code stacks on the guess.
4. **No out-of-scope edits.** "While I'm here" fixes belong in your summary as finding candidates,
   not in the diff. If an out-of-scope edit is truly unavoidable (a broken import on your path),
   keep it minimal and list every one explicitly in the summary. An unlisted out-of-scope change is
   an exception trigger at review; a listed one is a judgment call the reviewer can make in
   seconds. The difference is not the edit — it is whether the reviewer finds it or you declare it.
5. **Run every Verify item and paste the real output** — the command, its exit status, and the
   summary lines, fenced and unmodified. A claim without output counts as unverified. No
   predictions ("should pass"), no paraphrase ("all green"), no pre-edit runs. Confident prose
   comes out whether or not the claim is true; pasted output is the only part of your report a
   reviewer can re-check instead of trust.
6. **Re-run after your last change.** Output pasted before a later edit is stale: it proves
   something about a tree that no longer exists. The discipline is mechanical — final edit, then
   the full Verify list, then the summary, in that order.
7. **If a Verify command is missing or unclear, ask — never guess.** Resolve commands from the
   code repo's `AGENTS.md` Commands table. A guessed test command produces a false signal about
   whether the work is done, which is worse than no signal.
8. **Adversarially self-review your diff before handoff.** Re-read it as a hostile reviewer:
   - Which path did you not exercise — edge, error, concurrency?
   - What changed that the spec did not ask for?
   - Which callers of a changed surface did you not look at? Grep for them, including string-form
     references (registries, reflection, config) that a call-syntax search misses.
   - Which AC would you challenge first if this were someone else's diff?
     Fix what you find and note what you fixed. The cheapest review round is the one you run on
     yourself — but it yields fixes and notes, never a result (rule 10).
9. **Leave a summary**: changed files, commands run with their output, anything that could not be
   met as written, out-of-scope edits if any, and anything durable worth saving as a finding (drop
   candidates in the packet's `## Findings` section — a lesson that lives only in the session is
   lost when the session ends).
10. **Never write a review result on your own work.** Self-review yields fixes and a recorded
    critique — never a Pass. The review packet is filled by someone who did not write the diff.
    Authors favor their own output; independence is the point of the review step, and a
    self-issued Pass quietly removes it.

## Refuses

| Temptation                                               | Do instead                                                                              |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| "Tests passed" with no output                            | Run the command; paste command + exit + summary                                         |
| A drive-by refactor next to your change                  | Note it as a finding candidate; leave the code alone                                    |
| The AC seems wrong or unbuildable as written             | Stop; report why in the summary — do not reinterpret it                                 |
| Editing the spec to match what you built                 | Flag the mismatch in the summary; the spec changes through its own review, not mid-task |
| Marking your own work `pass`                             | Leave the result to the review packet                                                   |
| Reusing output from before your last edit                | Re-run; paste the fresh output                                                          |
| Guessing the test command because `AGENTS.md` is missing | Ask which command to run; a guessed run is a false signal                               |
| Weakening a test so the diff goes green                  | A failing check is information; fix the code or report the conflict                     |
| Quietly absorbing work the packet never named            | Surface it as a blocked question or finding candidate                                   |

## Working in parallel

When several agents implement at once, each takes a task packet whose affected areas are disjoint
from every other running task — two tasks that touch the same file run in sequence, not together.
Each agent verifies its own scope independently and leaves its own summary; the green is only as
trustworthy as the pasted evidence behind it. Coordination conventions live in this library's
[README](../README.md).

## Specialized kinds

For a defect, a flaky test, a refactor, a rewrite, a migration, performance work, tests as the
deliverable, or human-facing docs, this library carries a per-kind guide with the discipline that
kind demands (the regression-test transition, the loop reproduction, the equivalence check, the
callsite-zero grep, the same-protocol baseline, the assertion flip). Load the matching guide on top
of this one; its rules add to these, never replace them.

## Self-review gate

Before declaring the task done:

- [ ] Every Verify item ran after your final edit, output pasted.
- [ ] The diff contains only in-scope changes — or every exception is listed in the summary.
- [ ] You hunted at least one path you had not exercised (edge / error / concurrency) and recorded
      what you found.
- [ ] Anything you could not meet as written is reported, not silently adapted.
- [ ] The summary names changed files, commands with output, and finding candidates.
- [ ] You issued no review result on your own work.
