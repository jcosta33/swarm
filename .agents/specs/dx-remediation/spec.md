---
type: spec
id: SPEC-dx-remediation
title: Close the convergent defects from the eleven-persona DX audit
status: draft
owner: José Costa
sources:
  - .agents/audits/dx-audit-2026-06-12.md
---

# Close the convergent defects from the eleven-persona DX audit

## Intent

The DX audit's eleven personas converged on real defects — a load-bearing artifact with no
home, an evidence model that assumes CLI-runnable checks, and missing paths for common work
shapes. This spec turns every verified register finding into a checkable requirement or a
recorded drop. It is a wide, shallow catalogue (one line of behavior per finding), so it runs
long deliberately; the frozen-format subset is sequenced by `CHANGE-dx-formats`. Every
`Verify with:` line below fails against the baseline tree (`dc10f39`) — pre-flight pasted in
the authoring session — so none can read green before its fix lands.

## Non-goals

- No runtime, enforcement, or swarm-cli features — every fix is markdown.
- No new artifact types and no ninth template — the run summary becomes a section, not a file.
- No template-repo split, no SOL grammar/catalogue changes (the shadow *claim* is scoped
  instead — AC-040), no rescoring of the audit itself.
- No cross-workspace board aggregation and no portfolio-placement guidance (recorded drop).

## Requirements

<!-- Importance order: the 9-of-11 finding first, the evidence-model cluster second,
     work-shape paths third, then packet/board/commands formats, adoption honesty,
     discoverability, and surface-consistency sweeps. One behavior per AC. -->

### AC-001 — The run summary has a home

The task packet format must carry a `## Run summary` section the implementing agent fills
(changed files, commands run with output, out-of-scope edits, blocked questions).

Verify with: `grep -q '^## Run summary' starter-kit/templates/task.md`

### AC-002 — Every surface that demands the run summary names its home

Every page or guide that asks an agent for a run summary (in any phrasing — "run summary",
"leave a summary", "the agent's summary") must name the task packet's Run summary section as
its location.

Verify with: `grep -rliE "run summary|leave a summary|agent's summary" docs starter-kit --include='*.md' | grep -v 'docs/adrs/' | xargs grep -LiE '## Run summary|Run summary section' — returns nothing`

### AC-003 — Manual evidence is Pass-grade at user tier

docs/06 (where Verify is defined), docs/08, and the kit review-output guide must each state
that a named human's recorded observation (who judged, what they saw) is Pass-grade evidence
for a `manual` verification method.

Verify with: `grep -LiE 'named human|who judged' docs/06-creating-tasks.md docs/08-reviewing-output.md starter-kit/.agents/skills/review-output/SKILL.md — returns nothing`

### AC-004 — The seed ADR does not foreclose manual evidence

The kit's seed ADR (`decisions/0001-adopt-swarm.md`) must state the evidence rule in a form
that admits the manual method, so an adopting HIL/embedded team does not formally decide its
primary verification mode can never produce a Pass.

Verify with: `grep -qiE 'named human|manual check' starter-kit/decisions/0001-adopt-swarm.md`

### AC-005 — Flaky suites cannot buy a Pass with one green run

docs/08 must state that a single green run of a known-flaky check is not Pass-grade evidence
and must point at the fix-flaky-test discipline (loop-N reproduction).

Verify with: `grep -qi 'flaky' docs/08-reviewing-output.md`

### AC-006 — Execution-restricted runs have a stated path

Both implement-task guides (kit and library) must state what an agent does when a Verify
command exists but cannot execute in its environment: produce a CI link or delegate the run,
otherwise record Blocked — never paste predicted output.

Verify with: `grep -LiE 'cannot execute|delegate the run|predicted output' starter-kit/.agents/skills/implement-task/SKILL.md docs/library/code-skills/implement-task/SKILL.md — returns nothing`

### AC-007 — Stochastic checks are protocol-pinned

docs/04's writing rules must state that a `Verify with:` over stochastic output pins its
protocol (same seed or fixed dataset, metric, threshold).

Verify with: `grep -qiE 'stochastic|same seed' docs/04-writing-specs.md`

### AC-008 — Performance discipline covers model quality

The write-performance guide's trigger and rules must cover model-quality metrics (eval-gated
requirements), not only systems metrics.

Verify with: `grep -qiE 'model quality|eval metric' docs/library/code-skills/write-performance/SKILL.md`

### AC-009 — Post-merge evidence has a documented pattern

The advanced lifecycle page must document the pattern for requirements whose only honest
evidence is producible after merge (infra applies, soak metrics): Waived-with-expiry at the
gate, closed when the post-merge evidence lands.

Verify with: `grep -qiE 'post-merge|soak' docs/reference/advanced-lifecycle.md`

### AC-010 — Work that arrives as code has a documented flow

docs/08 must carry the post-hoc flow for work with no upstream artifacts (an external PR, an
unspecced bug): snapshot the code-shaped work as intake, write the spec as an acceptance bar,
the reviewer produces all evidence.

Verify with: `grep -qiE 'arrives as code|post-hoc|without a task packet' docs/08-reviewing-output.md`

### AC-011 — Intake recognizes code-shaped and informal sources

The intake template's source examples must include a pull request shape and an informal
channel (email / DM) alongside tracker shapes.

Verify with: `grep -qE 'gh-pr|pull-request' starter-kit/templates/intake.md && grep -qiE 'email|dm' starter-kit/templates/intake.md`

### AC-012 — One spec, many platforms is legal

The split-work guide's coverage rule must carve out the platform case: the same requirement id
may be scoped to N platform tasks when each task verifies it on its own platform.

Verify with: `grep -qi 'platform' starter-kit/advanced/split-work/SKILL.md`

### AC-013 — Solo adopters get an independence default

docs/08 must state the solo default for the implementer-≠-reviewer rule: one party implements
and the other reviews, where a party may be the human or the agent.

Verify with: `grep -qi 'solo' docs/08-reviewing-output.md`

### AC-014 — Waive-and-merge is representable at user tier

The review packet must give a reviewer who waives a non-Pass row and merges a documented way
to record it (form per Q1), without weakening "an empty Evidence cell means Unverified".

Verify with: `grep -qi 'waiv' starter-kit/templates/review.md`

### AC-015 — The review packet names its reviewer

The review template's frontmatter must carry a `reviewer:` field, so the high-oversight band's
named-human requirement has a place to land.

Verify with: `grep -qE '^reviewer:' starter-kit/templates/review.md`

### AC-016 — Non-requirement Verify items have a row home

The review template must state where results for non-AC Verify items (full suite, typecheck)
land for plain spec tasks.

Verify with: `grep -qi 'suite' starter-kit/templates/review.md`

### AC-017 — A blocked task is visible on the board

The status board's task-row vocabulary must include a blocked state (depth per Q2).

Verify with: `grep -E 'review-ready' starter-kit/templates/status.md | grep -qi 'blocked'`

### AC-018 — The shipped board carries no template residue

`starter-kit/status.md` (the live board instance) must contain no `{{placeholder}}` rows.

Verify with: `! grep -q '{{' starter-kit/status.md`

### AC-019 — The Commands table documents multi-context slots

The kit `AGENTS.md` Commands block must document the convention for multiple commands per
kind — polyglot and multi-repo estates (form per Q3).

Verify with: `grep -qiE 'per-repo|polyglot' starter-kit/AGENTS.md`

### AC-020 — The full slot set is named in the kit

The kit `AGENTS.md` Commands block must name the full contract slot set, including
`cmdSecurity`.

Verify with: `grep -q 'cmdSecurity' starter-kit/AGENTS.md`

### AC-021 — Adoption does not claim two minutes

docs/ADOPTING.md must state an honest time for path 1 (the measured 10–16 minutes, or no
number).

Verify with: `! grep -qi 'two minutes' docs/ADOPTING.md`

### AC-022 — The copy-out pointer is its own step

docs/ADOPTING.md must state the For-code-repos copy-out as its own numbered step, not a
mid-sentence aside.

Verify with: `grep -qE '^[0-9]+\..*For code repos' docs/ADOPTING.md`

### AC-023 — The dedicated-repo path ends in a commit

docs/ADOPTING.md's dedicated-repo path must include the first commit, not stop at `git init`.

Verify with: `grep -qi 'git commit' docs/ADOPTING.md`

### AC-024 — The placeholder step names the board

docs/ADOPTING.md's fill-the-placeholders step must name `status.md` among the files with
placeholders.

Verify with: `grep -A4 'Fill the' docs/ADOPTING.md | grep -q 'status.md'`

### AC-025 — The advanced tier is not under-enumerated

docs/ADOPTING.md must not carry a partial enumeration of the advanced tier's guides; it points
at the tier's own index instead.

Verify with: `! grep -q 'plus guides for the audit' docs/ADOPTING.md`

### AC-026 — Windows adopters are warned about symlinks

docs/ADOPTING.md or docs/10 must state what a default Windows clone does to the kit's symlinks
and the fallback (copy instead of symlink).

Verify with: `grep -qri 'windows' docs/ADOPTING.md docs/10-integrations.md`

### AC-027 — The integrations table covers Copilot

docs/10's per-tool table must carry a GitHub Copilot row.

Verify with: `grep -qi 'copilot' docs/10-integrations.md`

### AC-028 — The Cursor row carries a concrete recipe

docs/10's Cursor row must state how a rule file is actually made from a guide (`.mdc`,
frontmatter).

Verify with: `grep -qi '\.mdc' docs/10-integrations.md`

### AC-029 — The implementation-guide library is discoverable from the user tier

docs/06 or docs/07 must point at `docs/library/code-skills/` for per-kind execution guides.

Verify with: `grep -ql 'library/code-skills' docs/06-creating-tasks.md docs/07-running-agents.md`

### AC-030 — Teams get a role note

docs/ADOPTING.md or docs/02 must state team defaults: who writes specs, who reviews, and that
the implementing agent's session never fills its own review packet.

Verify with: `grep -qiE 'who writes|who reviews|never fills its own' docs/ADOPTING.md docs/02-basic-workflow.md`

### AC-031 — "Worktree" is glossed at first user-tier use

The first user-tier use of "worktree" (README or docs/02) must carry a one-clause gloss.

Verify with: `grep -qiE 'worktree \(|worktrees? \(' README.md docs/02-basic-workflow.md`

### AC-032 — The glossary defines worktree

docs/reference/glossary.md must carry a worktree entry.

Verify with: `grep -qi 'worktree' docs/reference/glossary.md`

### AC-033 — Finding candidates have one staging path

docs/09, the task template, and all three examples must agree that finding candidates stage in
the task packet's Findings section (the run summary may mirror, never replace).

Verify with: `grep -LiE 'Findings section' docs/09-saving-findings.md starter-kit/templates/task.md docs/examples/feature-from-jira.md docs/examples/bug-fix.md docs/examples/large-pr-review.md — returns nothing`

### AC-034 — The flow table has a performance shape

docs/02's flow-by-shape table must carry a performance-work row (baseline-first discipline,
pointing at the per-kind guide).

Verify with: `grep -qi 'performance' docs/02-basic-workflow.md`

### AC-035 — Findings can originate from audits and inventories

The finding template's origin hint must accept `AUDIT-*` and `INV-*` ids alongside task and
review ids.

Verify with: `grep -qE 'AUDIT-|INV-' starter-kit/templates/finding.md`

### AC-036 — The exception triggers name infrastructure risk classes

docs/08's exception-trigger examples must include infrastructure risk classes (IAM policies,
security groups, state moves, destroys).

Verify with: `grep -qiE 'IAM|security group' docs/08-reviewing-output.md`

### AC-037 — One citation for the evidence rule

checks/README.md must cite the same source as docs/reference/checks.md for the
non-empty-paste rule (EVIBOUND, not REFLEXION).

Verify with: `! grep -q 'REFLEXION' checks/README.md`

### AC-038 — The contract declares the task status enum

checks.yaml's task_file must declare the task status enum
(ready / running / review-ready / closed, plus Q2's answer).

Verify with: `grep -qE 'ready.*running.*review-ready.*closed' checks/checks.yaml`

### AC-039 — cmdBenchmark is not called non-contract

The adversarial-review task template must not describe `cmdBenchmark` as a non-contract value
while checks.yaml lists it in the slot set.

Verify with: `! grep -qE 'Non-contract.*cmdBenchmark|cmdBenchmark.*Non-contract' starter-kit/advanced/adversarial-review/references/task-template.md`

### AC-040 — The shadow claim is scoped to what it shadows

checks.yaml's header must scope its machine-readable-shadow claim to the structural checks it
actually carries — it does not carry the SOL catalogue.

Verify with: `grep -qiE 'shadows? (only )?the (core|structural)' checks/checks.yaml`

### AC-041 — The threat-model template has no duplicated cross-reference

`starter-kit/advanced/threat-model.md` must not repeat the sol-reference cross-reference on
one line.

Verify with: `! grep -qE 'sol-reference.*sol-reference' starter-kit/advanced/threat-model.md`

### AC-042 — The spec template's notation note is current

`templates/spec.md` must not instruct adopters to "copy it in" for a card that already ships
inside the copied workspace.

Verify with: `! grep -qi 'copy it in' starter-kit/templates/spec.md`

### AC-043 — One evidence bar, kit and docs

The kit review-output guide and docs/08 must state the same rule for trusting the worker's
pasted output (re-run what you can; spot-check at least one green row) — no stricter shadow
bar in the kit.

Verify with: `manual — side-by-side read of the two rules, recorded with who judged in the review packet`

## Open questions

- Q1 — Does **Waived** graduate to the user tier (a review status / coverage-row value), or
  does waive-and-merge stay a documented convention pointing at the advanced lifecycle?
  Blocks the exact form of AC-014 and the review-format wave of CHANGE-dx-formats.
- Q2 — Does the task frontmatter status enum gain `blocked`, or is blocked board-vocabulary
  only? Blocks the depth of AC-017 and AC-038's final enum.
- Q3 — Multi-command slot syntax: suffix-namespaced slots (`cmdTest:web`) or per-repo
  sub-tables? Blocks AC-019's exact form.

Decisions already made (recorded, closed): the run summary lives **in the task packet** as a
section — it travels with the work order, the review packet quotes it, and the template set
stays at eight. The retrofit flow lands in **docs/08** plus the intake template's source
shapes (no new page). The reviewer field (AC-015) is template-carried but **not**
contract-required — keeps CHANGE-dx-formats' single-rejection-delta envelope.

## Affected areas

- `starter-kit/templates/{task,status,intake,review,finding,spec}.md`, `starter-kit/AGENTS.md`,
  `starter-kit/status.md`, `starter-kit/decisions/0001-adopt-swarm.md`,
  `starter-kit/advanced/{split-work/,threat-model.md,adversarial-review/}` — sequenced by
  `CHANGE-dx-formats`
- `checks/checks.yaml`, `checks/fixtures/`, `checks/README.md`
- `docs/02, 04, 06, 07, 08, 09, ADOPTING, 10`, `docs/reference/{glossary,advanced-lifecycle,
  artifact-formats,cheatsheet,step-bars}.md`
- `starter-kit/.agents/skills/{implement-task,review-output}/`,
  `docs/library/code-skills/{implement-task,write-performance}/`
- `docs/examples/` (all three)
- one new ADR recording the format amendments (Q1–Q3)

## Dropped from sources

<!-- Every register finding not covered by an AC above, with the reason. -->

- Elena docs/03:54, both halves — cross-workspace board aggregation **and** per-engagement
  portfolio placement guidance: deferred together to the swarm-cli `swarm status` design;
  placement advice without the aggregation answer would promise what the board cannot deliver.
- Priya advanced/README:26 — save-findings ships in the optional tier though Close is core:
  deliberate for now; the Close rule itself is taught in core docs (02/09) and the kit
  AGENTS.md instruction 5, and the kit's core stays three guides (ADR-0064). Revisit if pilot
  evidence shows the Close step skipped because the guide was missing.
- Sofia spec-template Affected-areas — authoring guidance for non-coders: deferred; the field
  is legitimately engineer-filled and a PM-facing variant needs its own design pass.
- Marco docs/03:47 — flat-vs-folder naming tiebreaker: deliberate optionality stands; revisit
  only on evidence of the two schemes colliding inside one workspace.
- The audit's methodology limitations (score uniformity, enacted products) — about the audit
  instrument, not the product.
