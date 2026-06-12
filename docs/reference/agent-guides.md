# Agent guides

*Works today — plain markdown plus your agent; no Swarm tooling required.*

The guides are short procedural documents an agent CLI loads on demand (each ships as a
`SKILL.md`, auto-discoverable by agent tools and plainly readable by humans). They carry
procedure; the templates carry shape; this page is the index.

## Core (ship in `starter-kit/agent/`, copied beside your own skills)

| Guide | Use when |
|---|---|
| `write-spec` | turning a ticket/intake into a spec — intent not implementation, one behavior per requirement, every requirement verifiable |
| `implement-task` | executing a task packet — stay in scope, run every Verify item, paste real output, self-review the diff before handoff |
| `review-output` | filling a review packet — refute by default, re-run checks, evidence rules, route the exception triggers |

## Advanced (ship in `starter-kit/advanced/`, copy when needed)

| Guide | Use when |
|---|---|
| `write-audit` | recording the present state of an area — observation only, evidence per finding |
| `write-inventory` | mapping brownfield code before structural change — the contract map |
| `write-change-plan` | planning a refactor/rewrite/migration — baseline, preservation guarantees, waves, rollback |
| `write-research` / `persona-surveyor` | depth research on one question / breadth surveys across many examples |
| `write-bug-report` | reproducing and root-causing a defect — diagnosis, never the fix |
| `write-prd` / `write-rfc` | upstream intent and proposals |
| `spec-check` | running the checks of `checks.md` by hand |
| `split-work` | partitioning a large change into parallel-safe tasks |
| `save-findings` | the Close step — routing durable discoveries to findings |
| `adversarial-review` | a deep, hostile re-review of an agent branch — beyond the packet: re-run validation yourself, six adversarial questions, caller search |

## Implementation guides (library, for code-side depth)

`docs/library/code-skills/` carries long-form execution guides per change shape
(feature, fix, refactor, rewrite, migration, performance, testing, documentation,
flaky tests) plus `implement-task` in long form. Optional — copy what your team uses.

## Authoring your own guide

The kit's guides are conventions, and so is their shape — copy it when your team writes its
own:

- **Make the `description` directive.** Open with the verb of the work ("Implement…",
  "Review…"), say when the guide ALWAYS applies, name what it refuses to bypass, and end with
  a Skip clause that names **task types**, never sibling guide names — "skip for reviewing
  output", not "use review-output instead", so the description survives a renamed or absent
  sibling. Agent tools load guides by matching the description against the task, and directive
  phrasing is what gets a guide picked — observed in a self-published practitioner
  measurement, illustrative rather than proven
  [[ACTIVATION-BLOG]](../research/sources.md#ACTIVATION-BLOG).
- **Keep the body short; put depth one hop away.** A loaded guide is read whole — official
  guidance caps the useful body around 500 lines and moves detail into `references/` files
  loaded on demand [[SKILLBP]](../research/sources.md#SKILLBP).
- **Number the rules and attach the why.** A rule without its one-line rationale gets traded
  away under pressure. Add a Refuses table (temptation → do instead) — it catches the failure
  modes prose rules miss; the kit's core guides all carry one.
- **Make verification steps force output.** A step that says "verify X" invites a claim; a
  step that says "paste the output of X" produces evidence. End with a self-review gate the
  agent answers in writing.

Guides are conventions: they steer an agent, nothing enforces them. Review stances —
the cognitive postures the guides embed — are described in
[review-stances.md](review-stances.md).
