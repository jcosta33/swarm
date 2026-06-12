---
type: change-plan
id: CHANGE-dx-formats
title: Amend the frozen artifact formats the DX audit faulted
status: draft
kind: schema-change
owner: José Costa
sources: [SPEC-dx-remediation, .agents/audits/dx-audit-2026-06-12.md]
preserves: [PG-001, PG-002, PG-003, PG-004, PG-005, PG-006, PG-007, PG-008]
created: 2026-06-12
---

# Change Plan: Amend the frozen artifact formats the DX audit faulted

## Intent

Change the kit's frozen formats — task packet, review packet, status board, intake, finding
and spec templates, the Commands table, the seed ADR, two advanced cards, and the checks
contract — to close the format-cluster requirements of `SPEC-dx-remediation`
(**AC-001/002, 004, 011, 012, 014–020, 033, 035, 037–042**), while every behavior the rest of the
framework depends on provably survives.

## Why this change is needed

The DX audit's highest-confidence finding (9 of 11 personas, 7 MAJOR) is that the run summary
— demanded by every surface, called the raw material of the Evidence column — has no home in
any format. The same audit faulted the Commands table (4 personas), the board's missing
blocked state (2), tracker-only intake shapes (2), the missing reviewer field, and contract
drift inside checks/. These are public interfaces of the kit: every adopter workspace, all
three examples, the checks fixtures, and a dozen guides restate them, so the change must be
sequenced, not sprinkled.

## Baseline

Per the audit's verified register and the formats as committed at `dc10f39`:

- `templates/` holds exactly eight files: `change-plan.md finding.md intake.md inventory.md
  review.md spec.md status.md task.md`.
- `templates/task.md` sections: Source · Scope · Do not change · Affected areas · Verify ·
  Agent instructions · Findings — no run-summary home; `checks/checks.yaml` v0.3.0 pins the
  same `required_sections` and declares no task status enum.
- `templates/review.md` frontmatter: `type, id, task, pr, status` — no `reviewer:` field;
  status enum draft | pass | blocked | needs-human; results Pass · Fail · Unverified ·
  Blocked; no waive-and-merge form; no stated home for non-AC Verify results.
- `templates/status.md` task-row vocabulary: ready / running / review-ready / closed — no
  blocked; the shipped root `status.md` carries `{{slug}}` placeholder rows.
- `templates/intake.md` source examples: tracker shapes only. `templates/finding.md` origin
  hint: task/review ids only. `templates/spec.md` carries the stale "copy it in" notation
  note.
- `starter-kit/AGENTS.md` Commands table: four app-shaped slots, one command per kind, no
  multi-context convention, no `cmdSecurity`; the seed ADR states the evidence rule in the
  CLI-only form.
- `checks/README.md` cites REFLEXION where docs/reference/checks.md cites EVIBOUND; the
  adversarial-review task template calls `cmdBenchmark` non-contract while checks.yaml lists
  it in the slot set; checks.yaml's header claims to be the machine-readable shadow of the
  checks reference without scoping out the SOL catalogue it does not carry;
  `advanced/threat-model.md` repeats a cross-reference on one line.

## Target state

- `templates/task.md` carries `## Run summary` (changed files · commands with output ·
  out-of-scope edits · blocked questions); checks.yaml v0.4.0 adds it to `required_sections`,
  declares the task status enum, and scopes its shadow claim to the structural checks;
  fixtures pin both (conformant-task gains the section; one new negative fixture: summary
  missing at `closed`).
- `templates/review.md` gains `reviewer:` (template-carried, **not** contract-required — the
  spec's recorded decision), the waive-and-merge form per Q1, and a stated home for non-AC
  Verify results.
- Board task vocabulary represents blocked (per Q2); root `status.md` ships placeholder-free.
- Intake source examples include `gh-pr` and an informal channel; the finding origin hint
  accepts `AUDIT-*`/`INV-*`; the spec template's notation note is current.
- The Commands block documents the multi-context slot convention (per Q3) and names the full
  slot set including `cmdSecurity`; the seed ADR's evidence sentence admits the manual method.
- The split-work coverage rule carries the platform carve-out (AC-012); the cmdBenchmark and
  threat-model card defects are gone; checks/README cites EVIBOUND.
- **Explicitly unchanged:** the eight-template set and filenames, every existing section name
  and enum value (additions only), the evidence rules' text, the kit's symlink topology, the
  requirement-id scheme.

## Behavioral preservation guarantees

| ID | Behavior | Verify with |
|---|---|---|
| PG-001 | The evidence rules survive verbatim — both protected texts: the `non-empty-paste` rule and "an empty Evidence cell means **Unverified**, never **Pass**" — in checks.yaml, docs/08, and the review template | per file F in the three: `diff <(git show dc10f39:F \| grep -iE 'non-empty-paste\|unverified, never') <(grep -iE 'non-empty-paste\|unverified, never' F)` — empty for all three |
| PG-002 | The template set stays exactly these eight files: change-plan.md, finding.md, intake.md, inventory.md, review.md, spec.md, status.md, task.md | `ls starter-kit/templates \| sort` equals exactly that list |
| PG-003 | Every existing enum value survives in its declaring line — additive changes only | `fail=0; for v in draft pass blocked needs-human ready running review-ready closed Pass Fail Unverified Blocked; do grep -rqw "$v" starter-kit/templates checks/checks.yaml \|\| { echo "MISSING $v"; fail=1; }; done; [ $fail -eq 0 ]` — prints nothing; plus eyeball of the four declaring lines (review status_enum, result_enum, board task row, board spec row): old values all present |
| PG-004 | The counts registry's two-home rule holds: any enum/section change updates checks/README.md and the cheatsheet appendix in the same commit as the fixtures | wave-2 commit's `git show --stat` includes both homes; counts-leakage grep returns 0 |
| PG-005 | Kit self-containment: no kit file links into docs/ | `grep -rn '](\.\./docs\|](docs/' starter-kit --include='*.md'` returns nothing |
| PG-006 | The kit's symlink topology is unchanged: exactly `CLAUDE.md→AGENTS.md`, `GEMINI.md→AGENTS.md`, `.claude/skills→../.agents/skills` | `find starter-kit -type l` lists exactly those three with those targets |
| PG-007 | A packet conformant to v0.3.0 fails v0.4.0 by exactly one rejection delta: the missing Run summary section (the reviewer field and intake/finding hints are template-level, not contract-required) | diff of checks.yaml between 0.3.0 and 0.4.0 shows in `task_file`: one `required_sections` addition + the status-enum declaration; `review_file.frontmatter` unchanged or comment-only |
| PG-008 | README stays ≤120 lines and user-tier vocabulary tiers hold across every touched page | `wc -l README.md` ≤ 120; tier banned-token greps return 0 |

## Non-goals

- The pure-doc requirements of SPEC-dx-remediation — **AC-003, 005–010, 013, 021–032, 034,
  036, 043** — cut directly from the spec as plain tasks, no sequencing needed. (AC-012 and
  AC-033 are *in* this plan: waves 4–5 already edit their surfaces.)
- No SOL grammar or catalogue changes (AC-040 scopes the claim, it does not extend the yaml).
- No future-cli contract changes beyond the checks.yaml version bump; no swarm-cli work (its
  resync stays separately owned and retargets v0.4.0 at cutover).

## Affected surfaces

| Surface | Intended change |
|---|---|
| `docs/adrs/0072-*.md` (new) | records the format amendments and the Q1–Q3 answers |
| `starter-kit/templates/task.md` | + `## Run summary` section (AC-001) |
| `starter-kit/templates/review.md` | + `reviewer:`; waiver form per Q1; non-AC results home (AC-014/015/016) |
| `starter-kit/templates/status.md` | task-row vocabulary gains blocked per Q2 (AC-017) |
| `starter-kit/templates/intake.md` | source examples gain gh-pr + informal channel (AC-011) |
| `starter-kit/templates/finding.md` | origin hint accepts AUDIT-/INV- (AC-035) |
| `starter-kit/templates/spec.md` | stale "copy it in" note removed (AC-042) |
| `starter-kit/AGENTS.md` | Commands: multi-context convention + full slot set (AC-019/020) |
| `starter-kit/status.md` | placeholder rows replaced with a seeded real-shape row (AC-018) |
| `starter-kit/decisions/0001-adopt-swarm.md` | evidence sentence admits manual method (AC-004) |
| `starter-kit/advanced/threat-model.md` | duplicated cross-reference removed (AC-041) |
| `starter-kit/advanced/adversarial-review/references/task-template.md` | cmdBenchmark contradiction removed (AC-039) |
| `starter-kit/advanced/split-work/SKILL.md` | platform carve-out (AC-012) |
| `checks/checks.yaml` | v0.4.0: Run summary required, task status enum, shadow claim scoped (AC-038/040) |
| `checks/fixtures/*` | conformant-task gains the section; one new negative fixture; EXPECTED pins |
| `checks/README.md` | EVIBOUND citation (AC-037); counts/producer note updated |
| `docs/02/06/07/08/09 + reference/{artifact-formats,cheatsheet,glossary,step-bars}` | restate amended formats; run-summary home named wherever demanded (AC-002) |
| `docs/examples/*` (all three) | re-cut: Run summary section shown; staging path agreement (AC-002, AC-033's example surfaces) |
| kit + library guides (`implement-task`, `review-output`) + `.agents/skills/` mirrors | propagate the home and the amended formats (AC-002) |

## Risk areas

- **Enum drift** — the audit class we keep re-finding: a value added in one surface and missed
  in a restating one (C004's four-word decay was exactly this). Every enum touch enumerates
  its restating surfaces before the wave starts.
- **Examples arithmetic** — three long walkthroughs get re-cut; both prior reviews found
  counting errors in exactly these files.
- **Vocabulary tier leakage** — Q1 taken carelessly drags reference-tier lifecycle vocabulary
  (Waived) onto user-tier pages.
- **Same-commit rule** — wave 2 must land templates + checks.yaml + fixtures + both count
  homes in one commit, or the contract and its oracle disagree in history.
- **Gate freshness** — every spec AC gate was pre-flighted failing at `dc10f39`; if interim
  commits land before wave 2, re-run the pre-flight so no gate has gone vacuously green.

## Transformation waves

Schema-change note: the guide mandates expand → migrate → contract with a bridge release where
external consumers exist. **There are none pre-launch** (the only consumer, swarm-cli, is
paused pending resync), so expand and contract collapse into the formats wave (wave 2) as a
recorded flag-day — the version bump is the compatibility marker, and PG-007 bounds the blast
radius to one nameable rejection delta.

1. **Decide** — write ADR-0072 (format amendments; Q1–Q3 answers recorded), ledger row;
   SPEC-dx-remediation's open questions close and the spec flips to `ready`.
   *Verify:* ledger gates (link resolver, row present); spec status is `ready` with no
   blocking open question.
2. **Formats + contract (one commit)** — every `starter-kit/` surface in the table above
   except split-work, checks.yaml 0.4.0, fixtures incl. the new negative fixture,
   checks/README + cheatsheet count homes.
   *Verify:* ruby YAML parse pasted; fixture↔contract greps; spec gates AC-001, 004, 011,
   014–020, 035, 037–042 run and pasted; PG-001…PG-008 run and pasted.
3. **Docs propagation** — happy path + reference pages restate the amended formats.
   *Verify:* AC-002 grep clean over `docs/` excluding `docs/examples/` (examples and guides
   land in waves 4–5); link
   resolver; tier greps (PG-008); citation-anchor check.
4. **Examples re-cut** — all three walkthroughs show the Run summary section and the agreed
   staging path; arithmetic re-counted against their own tables.
   *Verify:* AC-033 five-surface grep clean; per-example recount pasted; link resolver.
5. **Guides + dev subset** — kit/library implement-task and review-output, split-work
   (AC-012), mirrored dev skills.
   *Verify:* AC-002 full grep returns nothing (the cutover form); AC-012 gate; kit
   self-containment grep (PG-005).

Each wave is one commit on `main` (producer convention); a wave's gates run before the next
wave starts. No shims: markdown formats forward old → new by re-edit, not by bridge files.

## Cutover conditions

- All five waves green with pasted gate output; PG-001…PG-008 verified in the final state.
- Every plan-scoped AC gate (AC-001/002, 004, 011, 012, 014–020, 033, 035, 037–042) passes its
  Verify-with line — none was green at baseline (pre-flight pasted in the authoring session).
- Adversarial self-review (ADR-0056) of the whole landing recorded; the swarm-cli resync
  backlog retargets checks.yaml v0.4.0.

## Rollback criteria

- Any gate red after its wave's commit → `git revert` that wave (each wave is one commit).
- A contradiction discovered between checks.yaml 0.4.0 and any fixture after wave 2 → halt
  waves 3–5, fix or revert wave 2 first; the contract and its oracle never disagree across
  waves.
- Q1/Q2 answers turn out to force a rename (not an addition) of an existing enum value →
  stop; that exits PG-003's additive-only envelope and needs a superseding plan.

## Verification strategy

- [ ] `ruby -ryaml` parse of checks.yaml after every wave that touches it
- [ ] PG-001…PG-008 commands, run and pasted per wave that could move them
- [ ] Plan-scoped AC Verify-with lines, run at their landing wave and again at cutover
- [ ] The repo gate set per wave: link resolver · citation anchors · tier/banned-token greps ·
      counts-leakage · kit self-containment · symlink census · README line budget

## Review focus

- Wave 2's single commit: did templates, contract, fixtures, and both count homes really move
  together? (`git show --stat` of the wave-2 commit)
- Every enum surface enumerated before editing — hunt the one restating page the sweep missed
  (the C004 failure class).
- The three examples' recounts — verify the arithmetic against the tables, not the prose.
- Q1's landing — no reference-tier vocabulary leaked into docs/01–10.
- The reviewer field stayed OUT of the contract's required frontmatter (PG-007's envelope).

## Task split

| Task | Wave | Scope (guarantee/requirement ids) |
|---|---|---|
| TASK-dx-fmt-w1 | 1 | ADR-0072; closes Q1–Q3 |
| TASK-dx-fmt-w2 | 2 | implement AC-001, 004, 011, 014, 015, 016, 017, 018, 019, 020, 035, 037, 038, 039, 040, 041, 042 · preserve PG-001–PG-008 |
| TASK-dx-fmt-w3 | 3 | implement AC-002 (docs) · preserve PG-004, PG-008 |
| TASK-dx-fmt-w4 | 4 | implement AC-002 (examples), AC-033 (example surfaces) · preserve PG-008 |
| TASK-dx-fmt-w5 | 5 | implement AC-002 (guides), AC-012 · preserve PG-005, PG-008 |
