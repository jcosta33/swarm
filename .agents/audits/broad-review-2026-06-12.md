# Broad repo review — 2026-06-12

Review record for the broad repo review (claims validation, scaffolding organization, whole-read
coherence). Every finding below was independently verified with pasted evidence (parser output,
grep, quoted lines) before inclusion; the lens reports and verdicts live in the orchestration
transcript. Findings are de-duplicated: the conformance.yaml parse failure was reported by three
lenses and the lintable-docs dead pointer by two; each appears once below.

## Executive summary

Thirty-four confirmed findings after de-duplication (1 blocker, 8 major, 25 minor); four candidate
findings refuted at verification. The blocker: `conformance/conformance.yaml` is not parseable YAML
— a mapping key spliced into a block sequence — so its "machine-readable shadow / testable data"
claim is flat false and C010/C011 are unreachable to any consumer, including swarm-cli. The majors
cluster in three places: caveated-preprint citations missing their required hedge (ORACLESWE in
evals/spec.md, EVIBOUND at four sites), kit-card honesty-level overclaims in starter-kit/advanced/
(two "toolable" checks that exist in no contract; a SOL-checks pointer to a card that has none),
and a stale ADR ledger index (dead backlog pointer, a "Kept" row for a fully superseded ADR, an
unleveled MUST-claim contradicting the current validity bar) plus an evals predicate stricter than
the canon it scores. Minors are drift, not walls: C010/C011 membership lagging in two reference
tables, `done`-for-`closed` in fixture prose, counts ceremony on one reference page, arithmetic
errors in the flagship demo, and ledger-row staleness. Fresh-product voice, vocabulary-tier
leakage, rejected-source citations, and happy-path link integrity came back with zero confirmed
findings.

## Findings by theme

Finding ids (F1–F34) are stable; the fix order below references them.

### Claims vs reality

- **F1 · BLOCKER · conformance/conformance.yaml:42** — The file claims to be "the machine-readable
  shadow of docs/reference/checks.md" ("restates it as testable data"; reference consumer:
  swarm-cli's `swarm spec check`), and conformance/README.md:99 tells a checker to "Read the rules
  from conformance.yaml" as step 1. The file does not parse: `change_plan_checks:` (line 42) is a
  mapping key at the same 2-space indent as the `- { id: C00x, ... }` items of the `core_checks`
  block sequence (lines 33–41), which no YAML parser accepts. Reproduced with PyYAML
  (`ParserError ... line 42, column 3`) and Ruby Psych (`did not find expected '-' indicator ...
  line 33 column 3`). C010/C011 (lines 43–44) are unreachable as data. **Fix:** fold C010/C011 into
  the `core_checks` sequence (matching the single core table at checks.md:44–56 and the README's
  "row for row" promise) or dedent `change_plan_checks:` to a top-level key; bump `version` per the
  file's own bump-on-rule-change rule; re-verify with a YAML parser.

### Links and anchors

No standalone findings. The only dead pointers confirmed anywhere live in the ADR ledger index
(F6, recorded under ADR ledger). Legacy in-body ADR links into retired trees were challenged and
refuted as a deliberate, documented convention (see the refuted appendix). No broken inline links
or `[[KEY]]` anchors were confirmed in README, docs/01–10, docs/examples/, or starter-kit core.

### Cross-surface consistency

- **F10 · MINOR · docs/03-where-files-live.md:15–30** — The canonical workspace tree omits
  `templates/`, while four surfaces place it inside the workspace (docs/ADOPTING.md:13 `cp -r
  starter-kit/templates <your-workspace>/templates`; starter-kit/agent/AGENTS.md:25;
  docs/reference/future-cli.md:43; starter-kit/README.md:19). An adopter cross-reading the tree and
  the bootloader finds a directory the canonical layout never names. **Fix:** add a `templates/`
  line to the docs/03 tree (e.g. "templates/  # the kit templates you copied in"); align ADR-0060's
  layout wording in the same pass since docs/03 mirrors it.
- **F11 · MINOR · docs/reference/glossary.md:70–73** — Four definition rows (wave, preservation
  guarantee, workboard, watchlist) sit after the internal-term table separated by a blank line,
  with no header/delimiter row. GFM renders them as literal pipe text, not a table; they are also
  outside the alphabetical main table where every other everyday term lives. **Fix:** fold the four
  rows into the main alphabetical table (lines 8–50) in order.
- **F24 · MINOR · starter-kit/templates/status.md:12–13** — The HTML comment says "a spec's own
  frontmatter only goes draft / ready / stale", but docs/04-writing-specs.md:41–42 defines
  frontmatter status as draft→ready only, and docs/04:107, docs/03:83, ADR-0060:57, and
  docs/reference/drift.md:23 all place `stale` on the status board, not in frontmatter. **Fix:**
  align the comment with docs/04 (frontmatter goes draft/ready; stale is a board state) and
  reconcile artifact-formats.md:68–69 (which lists a third frontmatter-status variant including
  `stale`) in the same pass so the incoherence does not just move.

### Honesty levels

- **F3 · MAJOR · starter-kit/advanced/checks-reference.md:30–34** — Two task checks are labeled
  toolable ("Scope ids all exist in the named spec/change plan (hard error, toolable)"; "Every
  Verify item maps to a scope id (warning, toolable)"), with the card's legend (line 5) binding
  toolable to "a future `swarm spec check` can flag it". Neither check exists in
  docs/reference/checks.md, conformance/conformance.yaml, or docs/reference/future-cli.md (grep
  returns nothing); no fixture pins scope-id resolution. A checker built to the contract will never
  flag what the card promises. The card is also the rules' only home, breaching single-sourcing.
  **Fix:** add the two checks (ids, severities, fixture) to checks.md + conformance.yaml, or
  relabel them "checklist" on the card.
- **F4 · MAJOR · starter-kit/advanced/spec-check/SKILL.md:68–70** — Directs `format: sol` adopters
  to "walk the SOL checks in ../checks-reference.md", but that card contains zero SOL codes
  (`grep -c 'SOL-'` → 0; its only SOL mention is a notation aside), and sol-reference.md defers
  back to this guide — a circular pointer. The SOL catalogue lives only at
  docs/reference/checks.md:116–206, which kit-copying adopters do not have at any relative path.
  **Fix:** point the sentence at the catalogue's real home (docs/reference/checks.md in the Swarm
  repo) or ship the SOL code list on the checks-reference card.
- **F12 · MINOR · docs/reference/cheatsheet.md:113–127** — The quick list claims "toolable —
  swarm-cli's `swarm spec check` implements this list" over exactly C001–C009, while
  checks.md:39+55–56 pins "implements exactly this table" over C001–C011 and
  conformance/README.md:44 pins the transformation fixture to C010/C011. Two reference pages
  disagree about the toolable contract's membership. **Fix:** add C010/C011 rows (marked
  change-plan-only) to the quick list, or scope the cheatsheet's claim to the spec-only subset;
  batch with F1/F30 as the C010/C011 reconciliation.

### Vocabulary and voice

- **F14 · MINOR · docs/reference/advanced-lifecycle.md:14, 35, 95, 141, 156** — Counted closed-set
  cardinalities ("the ten improve operations", "## The ten improve operations", "The four core
  results", "The three lifecycle values") on an adopter-facing reference page, outside the two
  sanctioned homes (ADR-0057 §5: "reference values are listed, never counted"). The cheatsheet
  appendix registers these exact cardinalities and claims they appear "in exactly two places ...
  and nowhere else" — this page falsifies that. The lists themselves are accurate, so this is
  drift-risk ceremony, not a wrong count. **Fix:** reword to list without counting ("## The improve
  operations", "the operations below", "The core results — exactly one per requirement per run",
  "The lifecycle values — each with required fields"). Same pattern noted (outside this finding's
  scope) at artifact-formats.md:132 and evals/advanced-lifecycle.md:38, 128.

### Citations

- **F2 · MAJOR · evals/spec.md:36–38** — "an executable acceptance criterion is the strongest
  task-input signal yet measured [[ORACLESWE]]" carries no preliminary-evidence qualifier and
  overstates the source (a preprint whose finding is a two-way comparison: reproduction test vs
  prose plans). All six sibling surfaces plus ADR-0058 use the hedged form; the post-rebuild
  adversarial review records ORACLESWE superlatives as deliberately removed ("de-superlatived ×9")
  but the fix commit never touched evals/spec.md. **Fix:** reword to match siblings: "a runnable
  check outperforms prose plans as task input (preliminary evidence)".
- **F5 · MAJOR · docs/08-reviewing-output.md:48–50 (replicated at docs/reference/principles.md:58–60,
  docs/examples/large-pr-review.md:318–320, docs/adrs/0060-swarm-workspace.md:16–17)** —
  "unsupported done-claims are the canonical agent failure [[EVIBOUND]]" is an unqualified
  empirical generalization resting solely on a Caveated-tier preprint (sources.md:144–145:
  "preprint; small N=8 — illustrative"; tier header: "cite ONLY as preliminary; never
  load-bearing"). None of the four citing sentences carries a hedge; principles.md:85 states the
  violated rule in the same file as one offending site. **Fix:** reword all four sites to a hedged
  or framework-owned form, e.g. "unsupported done-claims are the failure this step exists to catch
  — illustrated (small-N, preliminary) by [[EVIBOUND]]". ADR-0066:25 cites EVIBOUND on a rule
  statement and warrants the same treatment.
- **F15 · MINOR · docs/reference/artifact-formats.md:97–98** — "the planner→coder handoff is the
  dominant multi-agent failure surface [[PLANCODER]]" stated as settled fact; PLANCODER is a
  Caveated-tier preprint and this is the lone unhedged docs-tree site (five siblings hedge with
  "preliminary evidence places..."). **Fix:** insert the sibling-site hedge.
- **F16 · MINOR · evals/task.md:12–13** — Same PLANCODER claim, same missing hedge, on a
  producer-facing rubric. **Fix:** add the preliminary hedge.
- **F17 · MINOR · docs/reference/agent-guides.md:47–49** — "observed in vendor-published trials
  [[ACTIVATION-BLOG]]" misstates provenance: sources.md:116 records the source as a self-published
  practitioner measurement on Medium, non-peer-reviewed; the bibliography reserves "vendor" for
  company-published sources. The illustrative hedge is present; the provenance is inflated.
  **Fix:** change "vendor-published trials" to "a self-published practitioner measurement".
- **F18 · MINOR · docs/adrs/0058-two-tier-spec-format.md:29–30** — Garbled splice in the citation
  parenthetical: "— executable a runnable check outperforms prose plans as task input (preliminary
  evidence)" — the word "executable" dangles, an edit artifact from replacing the old superlative
  mid-parenthetical (confirmed in git history across d47b5a6/8353b57). **Fix:** delete the dangling
  "executable".
- **F19 · MINOR · docs/adrs/0053-structured-spec-and-review-system.md:15–26** — The Context
  presents an all-Caveated-tier evidence base (HARNESSBENCH, AHE, HAL, TERMBENCH, METR — METR's
  entry adds "do not cite the 19% figure as settled") with no tier marker anywhere in the file,
  while the house pattern (ADR-0043:67) marks preprint-grounded points as corroboration. Figures
  are accurately attributed; ADRs are an immutable ledger, so impact is low. **Fix:** add an
  "Evidence and its limits" ledger note marking the Context figures as preprint-tier corroboration,
  rather than editing the accepted text.

### Scaffolding and orphans

- **F20 · MINOR · starter-kit/advanced/README.md:30** — A lone pipe row for `adversarial-review`
  sits after the file's closing sentence with no header/delimiter — renders as literal pipe text —
  and the guides list (lines 23–26) omits `adversarial-review` even though the guide ships and
  ADR-0064's addendum adds it to the advanced tier. A misplaced append during addendum propagation.
  **Fix:** delete the stray row and add `adversarial-review` to the guides list prose.
- **F21 · MINOR · .agents/SKILLS-MANIFEST.md:56** — A dangling headerless pipe row for
  `adversarial-review` at EOF, two sections after the census table, which lists 12 of the 13
  directories actually in `.agents/skills/`. **Fix:** move the row into the census table (note the
  column order differs: census is Guide | Counterpart | Why-here — reorder cells) and delete
  line 56.
- **F22 · MINOR · docs/reference/principles.md (inbound-link graph)** — The only reference page
  with zero live inbound links: inbound references exist only in `.agents/` dev records and
  immutable ADR bodies (0021:11, 0023:9); nothing in README, docs/01–10, docs/examples/,
  starter-kit/, or any sibling reference page links to it, and docs/reference/ has no index README.
  **Fix:** add a link from a live page (cheatsheet/glossary Related lists or docs/01).

### ADR ledger

- **F6 · MAJOR · docs/adrs/README.md:65, 112** — Both the 0043 ledger row and its prose paragraph
  point to `.agents/lintable-docs-improvement-plan.md`, which does not exist (deleted in commit
  4c1917a; `git ls-files | grep -i lintable` exits 1) — a live wrong pointer in the maintained
  index, edited after the deletion. ADR-0043's own body carries the same dead link with a malformed
  `././` prefix, but ADR bodies are immutable and excluded from the fix. **Fix:** edit both README
  mentions to state the backlog plan was retired (pointer to git history), keeping ADR-0043's
  parked disposition.
- **F7 · MAJOR · docs/adrs/README.md:26** — Row 0004's disposition reads "**Kept**" though the ADR
  is fully superseded: the same ledger's 0060 row says "supersedes [0004]", ADR-0060's Status says
  "Supersedes ADR-0004", and 0004's own footer carries the supersession note. The ledger header
  promises each row carries "its current disposition"; this one misstates the current task-file
  policy. **Fix:** change the disposition to "Superseded by [0060] — flow artifacts are committed
  workspace content".
- **F8 · MAJOR · docs/adrs/README.md:110** — "A conformant repo MUST carry these ADRs (or
  equivalents)..." is a present-tense, unleveled MUST-claim in live index text that contradicts the
  current validity bar (docs/reference/checks.md:62–66, "The whole bar, nothing more", per
  ADR-0066); per ADR-0063 every normative-sounding rule carries a level and this carries none.
  **Fix:** recast as historical narration ("the kernel spec required a conformant repo to
  carry...") or delete the sentence.
- **F23 · MINOR · docs/adrs/0004-task-files-are-gitignored.md:5** — Status reads bare "Accepted"
  though 0060 fully supersedes it; the governance rule (README.md:12) says a superseded ADR "gains
  only a `Superseded by ADR-NNNN` status line", and every other fully superseded ADR (0002, 0006,
  0009, 0019, 0024, 0025) complies. 0004 has only a bottom-of-file ledger note. **Fix:** add
  "Superseded by [0060](./0060-swarm-workspace.md) — ..." as the Status line.
- **F25 · MINOR · docs/adrs/README.md:71** — Row 0049's title summarizes the rejected original form
  ("no pre-built workspace tree", "dirs are created on first write") that the ADR's same-day
  goldilocks Update explicitly reversed (0049:48–49 "Swarm prescribes six folders"; 0049:88 the
  zero-folder form "over-corrected"). **Fix:** reword the row to the amended decision: in-place
  `.agents/` install, no mount/bridge, six prescribed flow folders, future-toolchain dirs created
  lazily.
- **F26 · MINOR · docs/adrs/README.md:81** — Row 0059 carries the pre-addendum infix spelling
  "`*.swarm.ir.json`/`plan.json`"; the ADR's addendum (0059:49–51) respelled the reserved names
  without the infix, and future-cli.md follows the addendum. **Fix:** respell the row to
  `*.ir.json`/`*.plan.json`.
- **F27 · MINOR · docs/adrs/README.md:24–78 (rows 0002, 0009, 0015, 0019, 0026–0029, 0033, 0041,
  0042, 0051–0053)** — Each of these files carries a dated "Ledger note (2026-06-11)" recording
  partial supersession/refinement by the 0057–0068 layer, but no pre-0057 README row mentions any
  0057–0068 ADR (grep over the row range returns nothing), against the header's "current
  disposition" promise. **Fix:** append the file-level ledger notes to the corresponding README
  rows (include row 0004 — covered separately as F7).
- **F28 · MINOR · docs/adrs/0049-minimal-install-no-mount-no-imposed-workspace.md:131** — The
  ledger note says only "refined by ADR-0057, ADR-0062", while ADR-0057's Status and its README row
  assert "supersedes the naming clauses of ADR-0049 §2" — the partial supersession is asserted on
  one end and downgraded on the other; sibling notes record clause-level supersession explicitly.
  **Fix:** amend to "naming clauses (§2) superseded by ADR-0057; refined by ADR-0062".
- **F29 · MINOR · docs/adrs/README.md:1** — H1 reads "Architecture Decision Records (Swarm
  kernel)"; ADR-0049 §5 retired "kernel" everywhere, adopter-facing and producer-side, and the
  README is the live-maintained index, not an immutable body. A sweep leftover. **Fix:** retitle to
  "Architecture Decision Records" (or "... (Swarm)").

### Conformance and evals

- **F9 · MAJOR · evals/spec.md:25 (predicate S3)** — "a spec with open questions is not `status:
  ready`" omits the non-blocking carve-out that every canonical surface grants: checks.md C007
  ("one not marked non-blocking"), conformance.yaml:39, starter-kit/templates/spec.md:38,
  docs/04:48. The rubric demands literal boolean scoring, so a scorer applying S3 fails a spec the
  frozen template and the toolable check explicitly permit. **Fix:** reword S3 to "a spec with
  unresolved open questions not marked non-blocking is not `status: ready`".
- **F30 · MINOR · docs/reference/checks.md:240–243** — The severity-split table ("the `swarm spec
  check` contract") omits C010 and C011 from both rows, though the core table on the same page
  (lines 55–56) and conformance.yaml pin C010 hard-error / C011 warning. **Fix:** add C010 to the
  Hard error row and C011 to the Warning row; batch with F1/F12.
- **F13 · MINOR · conformance/fixtures/violations.md:97, 108** — Fixture V6's heading and Expected
  text name status `done`; the task contract's terminal value is `closed` (conformance.yaml:72–73;
  artifact-formats.md:91), and the V6 snippet itself uses `status: closed`. Prose drift inside the
  oracle. **Fix:** replace `done` with `closed` at both lines.
- **F31 · MINOR · conformance/fixtures/conformant-task.md:5** — Header comment says "the status is
  terminal (done)" while the fixture's frontmatter is `status: closed` and the contract names
  `closed` as terminal. **Fix:** change "(done)" to "(closed)"; same edit pass as F13.

### Whole-read coherence

- **F32 · MINOR · README.md:66–68** — "a 40-file agent PR" links a demo that is 41-file throughout
  (large-pr-review.md:1, :308 "41 files changed, +1,816 −1,204", :16). The same "40-file" string
  also appears at docs/examples/feature-from-jira.md:372 and docs/examples/bug-fix.md:343.
  **Fix:** change all three user-tier occurrences to "41-file".
- **F33 · MINOR · docs/examples/large-pr-review.md:343–345** — Packet summary says "Six of nine
  rows verified with output", but by docs/08:113's own definition (Fail = "Verified and the
  requirement is not met") the AC-004 Fail row with pasted failing output is verified: 6 Pass + 1
  Fail = 7 verified, 2 Unverified. The flagship demo's summary blurs Fail vs Unverified. **Fix:**
  "Seven of nine rows verified with output (six pass, AC-004 fails)" or drop the verified count.
- **F34 · MINOR · docs/examples/large-pr-review.md:14–16 and 552–554** — "about twelve table rows"
  in the punchline and closing; the two packets contain 18 rows (9 + 9, each 4 coverage + 5
  change-plan), and the closing reaches 12 only by counting the 3 exception items as rows while
  dropping the second packet's 9. **Fix:** recount ("eighteen table rows and three exception items
  across two packets") in both places, or drop the aggregate and keep the per-packet counts.

## Recommended fix order

1. **F1 (blocker) + F30 + F12 — the C010/C011 reconciliation, one commit.** Fix conformance.yaml's
   structure (fold C010/C011 into `core_checks` or dedent the key; bump `version`), add C010/C011
   to checks.md's severity-split table, and reconcile the cheatsheet quick list — so the three
   surfaces agree row for row. Verify with a YAML parser and paste the output.
2. **Majors, batched by surface:**
   - **evals/**: F2 (ORACLESWE reword) + F9 (S3 carve-out) in evals/spec.md; pick up F16 (PLANCODER
     hedge in evals/task.md) in the same pass.
   - **starter-kit/advanced/**: F3 (add the two checks to the contract, or relabel checklist) + F4
     (SOL pointer); pick up F20 (stray row + guides list) in the same pass.
   - **Citation sweep**: F5 at all four sites (plus ADR-0066:25 per the verdict note); fold in F15,
     F17, F18, F19 so every caveated-source citation is hedged in one commit.
   - **docs/adrs/README.md**: F6, F7, F8 plus the minor index rows F25, F26, F27, F29 in one
     editing pass; file-level notes F23 and F28 alongside.
3. **Remaining minors, batched:**
   - Reference layer: F10 (docs/03 tree + ADR-0060 wording), F11 (glossary rows), F14 (counts
     ceremony; also sweep the noted artifact-formats.md:132 and evals/advanced-lifecycle.md
     instances), F24 (status.md template comment + artifact-formats.md:68–69 enum reconcile), F22
     (principles.md inbound link).
   - Conformance fixtures: F13 + F31 (done→closed, one commit).
   - Examples/README numbers: F32 + F33 + F34.
   - Dev surface: F21 (SKILLS-MANIFEST census row).

## Verified clean

The following lenses returned zero confirmed findings; that absence is itself a review result.

- **Fresh-product voice** — no migration framing confirmed on any non-exempt surface.
- **Vocabulary tiers** — no internal-term leakage into user-tier pages; the sole vocabulary finding
  is counts ceremony (F14).
- **Rejected-source citations** — no `[[KEY]]` anywhere cites a rejected sources.md entry.
- **Happy-path links and anchors** — no broken inline links or citation anchors confirmed in
  README, docs/01–10, docs/examples/, or starter-kit core; all dead pointers found are confined to
  the ADR ledger index.
- **Canon facts** — six-step loop, review-packet status enum, review results, and the
  frontmatter-type discriminator are consistent across surfaces; the only status-value drift found
  is fixture/template prose (F13, F24, F31).

## Refuted at verification

- docs/reference/cheatsheet.md — "two places and nowhere else" challenge refuted: in context the
  sentence scopes to the reconciliation registry (the eight rows with member lists), a misreading.
- evals/advanced-lifecycle.md:38, 128 — "the ten improve operations" challenge refuted by its
  reviewer as the set's proper name rather than a registry count (note: F14's verdict reads the
  same phrase on the canonical page as counts ceremony; resolve the naming question when fixing
  F14).
- docs/reference/artifact-formats.md — extended-result-lifecycle counts challenge refuted:
  misreading of the counts-ceremony rule's scope (it bans registry-style cardinality recitations,
  not every numbered phrase).
- docs/adrs/0055 (and sibling ADR bodies) — legacy in-body links into retired trees do 404, but
  this is the deliberate, documented convention: ADR bodies are immutable historical records.

## Resolution (2026-06-12)

All 34 findings fixed in the commit that lands this note; every fix re-verified mechanically
(YAML parse pasted, leftover-pattern greps 0, link/citation gates green on live surfaces).
Disposition choices worth recording:

- **F1** fixed by folding C010/C011 into `core_checks` (matching checks.md's single 11-row core
  table "row for row"); `version` bumped 0.2.0 → 0.2.1. Parser evidence: ruby Psych
  `PARSED OK / C001,…,C011`.
- **F3** resolved by **relabeling the two task checks "checklist"**, not by adding them to the
  contract — "toolable" requires existing in a named tool's contract (ADR-0063), and inventing
  contract entries mid-fix would be a design change no ADR covers.
- **F5/F18** ADR-body edits are citation hygiene only (hedge wording, a dangling word), consistent
  with the prior practice of mechanical citation repairs in the fresh 0057–0068 layer; **F19** got
  a dated ledger note instead, since it re-frames an older ADR's evidence base.
- **F8** recast as historical narration with a pointer to the current validity bar (checks.md /
  ADR-0066).
- **F14** also swept the noted siblings (evals/advanced-lifecycle.md heading-anchor users,
  artifact-formats "four results"); the `#the-ten-improve-operations` anchor was renamed with its
  one inbound link updated in the same pass.
- **F24** reconciled both ends: the status-template comment (stale = board state) and
  artifact-formats' spec-frontmatter enum (draft / ready only).

Gap from the original run closed separately: the `find:self-claims` lens died on an API error
mid-run; it was re-run as its own find→adversarial-verify sweep after these fixes landed (results
recorded below if any survived).

## Self-claims sweep (2026-06-12, follow-up run)

The re-run found **16 confirmed failures (all minor) and refuted 1**; all 16 fixed in the
follow-up commit. The themes:

- **Strength-word enum drift (six sites).** The canonical five-word enum (must, must not,
  should, should not, may — checks.md C004, the count registry, sol-reference) had decayed to
  four words ("should not" dropped) in cheatsheet C004, distillation's must-survive table,
  structured-requirements' shared-enum paragraph, docs/04 rule 5, and both kit echo sites
  (checks-reference, spec-check). All six now carry five.
- **Guide overpromises (three sites).** starter-kit/README and ADOPTING promised "their
  guides" for templates that have none (adr, threat-model); the kit AGENTS.md claimed
  "Templates for every artifact" while templates/ has no ADR shape. All scoped to what ships.
- **Example-internal contradictions.** bug-fix's spec frontmatter carried the board-only
  `status: done` (→ `ready`, narrative re-worded to the workboard); large-pr-review's
  exception aggregate undercounted (3 → 4 end to end: the second packet's finding candidate
  is an exception by the framework's own trigger list).
- **Registry-claim absolutism.** "These counts appear in exactly two places … and nowhere
  else" was falsifiable as written (docs/02's "Swarm's workflow is six steps"); both registry
  homes now scope the claim to registry rows and exempt numeral-bearing model names. This
  adjudicates the confirmed-vs-refuted split both verifiers reached on the same line.
- **Smaller drifts.** docs/07 called the skeptic re-read "the final instruction" (it is 4 of
  5); the kit write-audit guide named a nonexistent "recommended-requirements" section
  (template says Candidate requirements; the dev copy was already right);
  evals/review.md now restates "Re-parses clean" as the README table promises; the
  agent-guides authoring section (added this morning) overclaimed "every kit guide carries"
  a Refuses table (now scoped to the core guides).
- **Closed the negative-oracle gap.** violations.md promised one negative fixture per
  violation class but covered 7 of the contract's 15 rule classes; V8–V15 added (C002,
  C004–C006, C008–C011) so every class has a negative oracle, including the three hard
  errors that had none (C002, C009, C010).

Refuted: the broad reading of the cheatsheet two-places claim as banning every numbered
phrase (the model names are mandated by ADR-0057); resolved by the scoping fix above rather
than by scrubbing names.
