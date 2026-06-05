# Plan — a canonical worktree/branch isolation policy for Swarm

> A **plan**, not changes. Method: 10 lived dev-workflow simulations centered on the
> *worktree/branch isolation decision* (when a task warrants a worktree+branch, the naming,
> merge/cleanup, and the quick-ad-hoc escape hatch), each **adversarially pressure-tested** against
> what the model already specifies, then synthesized (workflow `wouutqjr2`, 21 agents). Honors the
> hard constraints (markdown-only, NO RUNTIME soft control, the write-surface model ADR-0039, the
> 17 `task_kind`s, the ≤200-line bootloader cap). Nothing applied yet.

## The one real hole (surfaced from eight angles)

Swarm fully specifies worktree + branch + merge-gate + cleanup **only inside the parallel-decomposition
coordination record** (`task-orchestration.md`, scoped by its own framing to "one parallel decomposition").
The **single-task load path** an ordinary task travels — `AGENTS.md` startup → `task.md` frame →
`write-*` SKILL → `implement.md` → verify/review — carries **zero isolation signal**. Verified:

- The canonical `task.md` frontmatter (both `docs/artifacts/task.md` and `kernel/.agents/templates/task.md`
  twins) has **no** `isolation`/`branch`/`base`/`worktree` field.
- `implement.md` — the pass *every* code task runs — has **zero** worktree/branch mentions.
- Only **3 of 12** per-kind templates carry Branch/Base/Worktree placeholders (`write-fix`,
  `write-migration`, `write-bug-report`), while the spec-bearing **`write-feature`/`write-rewrite` carry
  none** and **`write-refactor` ships no template at all** — so the agent gets the *inverse* of the
  owner's intended signal.
- `conformance.md:192` parks "worktree creation + branch naming" with the **unbuilt** toolchain;
  `ADR-0039` never mentions branch/worktree/isolation.

**Root insight:** the isolation axis is **missing its explicit "honest default" rung.** The proof axis has
`manual`, the surface axis has `observed` — but isolation has no equivalent, so today the ad-hoc dev's
in-place freedom survives **only by silence** (worktrees never trigger absent a `parallel_group`). Any
naive "spec ⇒ isolate" tightening that doesn't *first* grant the no-source-artifact case would therefore
**break the escape hatch.** (One claimed gap was *excluded* by the pressure-test: "unscoped decompose
serializes research" inverts the predicate — `decompose.md:141/211` already exempt any READS-only pass.)

## The fix: a three-rung isolation axis with an explicit in-place default

`worktree+branch` · `branch-only` · `in-place` — with **`in-place` as the explicit, granted ad-hoc default**
(the analogue of `manual`/`observed`), so the quick-use freedom is *encoded ahead of* the isolate default
and cannot be tightened away.

### The deterministic decision rule (NO RUNTIME — the agent reads the frame + the request; first match wins)

- **STEP 0 — escape hatch (checked FIRST, highest priority):** if the request is ad-hoc — `isolation: in-place`
  in the frame, OR the dev said "quick"/"ad-hoc"/"in place"/"on my branch", OR there is **no `task.md` frame
  and no `*.swarm.md`/audit source named** — → **in-place**, on whatever branch the dev is on. *The absence of
  a source artifact IS the signal; the dev types nothing extra.*
- **STEP 1 — explicit declaration wins:** the frame's `isolation:` value is used verbatim (lead/dev override,
  recorded for resumption).
- **STEP 2 — doc/source-only authoring:** `task_kind ∈ {spec-writing, research-writing, audit-writing,
  bug-report-writing, deepen-audit}` OR every `write_surface` is under `.swarm/sources/` → **in-place**
  (a lone doc writer conflicts with nothing; grounded in the `decompose.md` READS-only exemption).
- **STEP 3 — review/orchestration:** `review` → **branch-only**; `orchestration` → **branch-only** on the
  coordination record, and it **mints** the per-worker `worktree+branch` children (the existing model).
- **STEP 4 — tracked code work (the isolate default):** a code-producing kind
  (`feature|fix|refactor|rewrite|migration|upgrade|performance|testing|integration`) **with a source
  artifact present** (`source:` resolves to a `*.swarm.md` spec or an audit-derived spec) → **worktree+branch**.
  *This is the normative "a spec/audit is implemented off the base, not on it" rule.*
- **STEP 5 — fallthrough (code kind, no source, no ad-hoc flag):** → **dev-choice**, defaulting to in-place;
  the agent should ask or record the chosen `isolation:`.

The composing axes are exactly four: **has-source-artifact** (4 vs 5), **code-vs-doc** (2 vs 4), **task_kind**
(2/3/4), and the **ad-hoc flag** (0). Crucially, **`parallel_group` is NOT an input** — isolation is
orthogonal to it: a single task with `parallel_group: none` still isolates via STEP 4; a fan-out still mints
per-worker worktrees via STEP 3. *That decoupling is the key composition fix — isolation stops being a silent
side effect of parallelism.*

### Isolation matrix (defaults by task_kind class)

| Default | Kinds / class | Why |
| --- | --- | --- |
| **worktree+branch** | `feature`, `rewrite` (spec-implementing, source is a `*.swarm.md`) | The kinds the owner explicitly wants isolated — yet today carry *no* branch field. Source-is-spec + code = strongest isolate trigger. |
| **worktree+branch** | `fix`, `refactor`, `migration`, `upgrade`, `performance`, `testing` (code, source = spec or audit-derived spec) | All route through `implement` and produce code against a governed surface; an audit remediation, a refactor, a migration — each isolates. Finally creates the worktree `write-fix`/`write-migration` prose already *assumes*. |
| **worktree+branch** | `integration` | Assembles workers' merged branches + cross-contract proofs; the merge-target consumer isolates off the base. |
| **branch-only** | `review`, `orchestration` | `review` reads evidence (no code write); `orchestration` doesn't isolate — it *mints* the worker worktrees. |
| **in-place** | `spec-writing`, `research-writing`, `audit-writing`, `bug-report-writing`, `deepen-audit` (write only under `.swarm/sources/`) | A lone doc writer conflicts with nothing. (`write-bug-report`'s existing Branch field is a *no-switch prohibition* during observation, not a worktree grant — preserved as-is.) |
| **in-place** | any code kind, **no source artifact + ad-hoc flag** | The zero-ceremony escape hatch — a 3-file rename must not trigger worktree setup. |
| **dev-choice** | `generated`-surface-only regen, or a borderline one-file edit | The frame's `isolation:` records the call for the next session; defaults in-place absent a source. |

## Branch nomenclature + `base:`

Extend the one existing pattern (`swarm/<spec-slug>/<task-slug>`, the worker form in `task-orchestration.md`)
with a **single-task collapse** so a lone task and a fan-out worker reconcile under one grammar:

- **Single task implementing a whole spec:** `swarm/<spec-slug>` (worktree `.worktrees/swarm/<spec-slug>`).
- **Single task for one obligation/sub-scope:** `swarm/<spec-slug>/<task-slug>` (identical to a fan-out worker — by design).
- **Audit remediation:** keyed on the **promoted** spec slug (`swarm/<spec-slug>[/<task-slug>]`) — the audit
  *becomes* a spec via the `author` pass, so it inherits the spec-anchored form (resolving "an audit has no
  spec-slug": post-promotion, it does).
- **Fan-out workers:** unchanged (`swarm/<spec-slug>/<task-slug>`).

`base:` is recorded on the frame — default `main`, but **the dev's current HEAD** when they hand off mid-stream
on a feature branch (resolving the nested-branch case where merge-into-main is wrong). These stay **design
rationale, not parsed grammar** (a loose convention an agent re-derives) — so they cost nothing against NO RUNTIME.

## Where the policy lives (all NO-RUNTIME, agent-readable, twin-respecting)

1. **The model + escape-hatch grant** — a new ADR (`isolation-axis-model`): the three rungs, the "spec/audit off
   the base" rule, `in-place` as the honest default; cites `ADR-0039` (the parallel-only gap it fills) and
   `ADR-0010` (the single-fork precedent it operationalizes).
2. **The recording home (fixes resumption)** — add `isolation:` + `base:` to the canonical `task.md` frontmatter
   in **both twins**, decoupled from `parallel_group`.
3. **The decision rule (the load path every code task hits)** — a `## Isolation` section in `docs/passes/implement.md`
   and its kernel twin carrying STEP 0–5, inherited by all 12 per-kind guides without 12× duplication.
4. **The startup trigger** — one line in `kernel/AGENTS.md` startup pointing at the rule + the bare-ad-hoc default
   (a pointer, not a spec; well under the cap).
5. **Per-kind template reconciliation** — align all 12 so the isolation metadata is consistently present (fixing
   the 3-of-12 inversion).

## Merge / cleanup — one lifecycle, two cardinalities

The single-task path **borrows the existing orchestration machinery** rather than forking a second story (the
merge gate is already cardinality-independent). A lone task clears the **same 6-condition merge gate** with
**condition 5 (cross-worker write-disjointness) vacuously true** for one writer (`implement.md` states this so
the agent skips it). `base:` supplies condition 6's operand + the merge target. **Cleanup** mirrors orchestration
phase 4 (merge → remove worktree → compact trace/review into `.swarm/ledger/` → drain promotion queue); with no
launcher to auto-remove, `implement.md` names the **closing session + `persona-janitor`** as the by-hand cleanup
owner, and `status/worktrees/` gets a one-line schema note for resumption. **Single-task = the same lifecycle with
worker-count 1** — same branch grammar, same gate, same cleanup; a task that later fans out simply has its frame
re-derived by `decompose` into per-worker frames.

## The plan (P1–P8)

| # | Title | Effort·Risk | Change |
| --- | --- | --- | --- |
| **P1** | ADR: the isolation-axis model + honest `in-place` default | M·low | The three-rung axis, the "spec/audit off the base" norm, `in-place` as the explicit zero-ceremony default; cites ADR-0039/0010; ledger row. |
| **P2** | Add `isolation:` + `base:` to the `task.md` frame (both twins) | S·low | New frontmatter fields, decoupled from `parallel_group`, with the recording-for-resumption rationale; twins kept in sync. |
| **P3** | Write the STEP 0–5 decision rule into `implement.md` (both twins) | M·med | A `## Isolation` section (escape-hatch-first; doc/source-only → in-place; code+source → worktree+branch; condition-5-vacuous note). Inherited by all 12 per-kind guides. |
| **P4** | One-line startup trigger in `kernel/AGENTS.md` | S·low | Points at the implement-pass rule + the bare-ad-hoc-no-source → in-place default. Pointer, not spec. |
| **P5** | Single-task branch-naming collapse + `base:` policy | S·low | Extend the `task-orchestration.md` naming note with `swarm/<spec-slug>`, the audit-promoted form, and `base:` (default main; dev HEAD for nested). Design rationale, not parsed grammar. |
| **P6** | Reconcile the per-kind template field set (fix the 3-of-12 inversion) | M·med | Give `write-feature`/`write-rewrite` + the code kinds the isolation metadata the rule implies; create the missing `write-refactor` template; clarify `write-bug-report`'s Branch field is a no-switch prohibition. |
| **P7** | Single-task merge/cleanup + `status/worktrees/` schema pointer | S·low | Point single-task merge/cleanup at the existing 4-phase reconciliation (condition 5 vacuous); name the closing session + `persona-janitor`; add a `status/worktrees/` resumption schema note in `workspace.md`. |
| **P8** | Annotate the producer-repo vs adopted-project workflow split | S·low | One line in `CLAUDE.md`/`workspace.md`: "work from main, no branches/PRs" is the *framework-dev producer-repo* workflow only and does **not** supply the adopted-project isolation default — removes a live unannotated contradiction an agent reading `CLAUDE.md` hits. |

## Adjacent gaps the simulations surfaced (worth tracking)

- **`status/worktrees/` has no schema** for either a single-task or a long-lived multi-session worktree
  (base/branch/liveness/owning-task undefined) — a multi-day migration has no committed resumption home.
- **ADR-0004 tension:** task files are tied to disposable, gitignored worktrees, but `workspace.md` says the
  workspace *is* the resumption record — for a long-lived solo migration, durable wave/callsite state needs to
  externalize to a committed `status/` entry. One-line reconciliation needed.
- **No rebase / refresh-from-base cadence** for a long-lived branch — a multi-wave migration's green-per-wave
  invariant is defined against the working tree, not a base that moves over days.
- **No urgency/hotfix fast-path** — the verify ceremony is fixed-cost; there's a `WAIVED` verdict but no
  documented urgency path to ship before the suite is green. (Adjacent, out of isolation scope.)
- **Doc-write-as-write-surface** has no formal answer — `ADR-0039`'s conflict model is code-only, so a
  `.swarm/sources/**` write sits outside the conflict graph (harmless for isolation, but unstated).
- **Harness seam:** the `EnterWorktree` tool *defaults to NOT isolating* for "fix a bug / work on a feature" and
  creates under `.claude/worktrees/`, contradicting both this policy's default and Swarm's `.worktrees/swarm/`
  root — a real seam markdown can name but cannot close.

## Honest caveats (the NO-RUNTIME / soft-control line)

- **Nothing enforces the policy.** The agent *can* ignore `isolation:`, skip the worktree, and land a spec on the
  base. This is a specification-completeness fix, not an operational guarantee — the same soft-control limit as
  every Swarm gate; a future launcher (`conformance.md:192`) is what would enforce it.
- **The escape-hatch guard is ordering-dependent.** STEP 0 is normative prose, not parsed precedence — a model
  that reaches for "spec → isolate" without checking the ad-hoc flag first re-introduces the ceremony. Re-derivable
  but ignorable.
- **Simpler-vs-safe on the frame field.** `isolation:`+`base:` grow the (already 18-field) frontmatter and add
  twin-sync surface. A leaner alternative (derive isolation purely from the rule, no recorded field) is simpler but
  loses the resumption record. The plan chooses *safe* (record it); a reviewer may prefer the field only for overrides.
- **`task_kind` is ambiguous at the edges** (a "documentation" kind editing code comments inside a code file; a
  sourceless-but-tracked "fix"). STEP 5's dev-choice fallthrough is honest but means the rule is closed only over the
  well-formed cases the four axes cover.
- **The harness `EnterWorktree` default contradicts this policy** and uses a different path root — the plan documents
  the framework-side rule but cannot make the harness obey it.

## Note on ADR numbering

The adoption-redesign plan also reserves `ADR-0045`+. **ADR numbers are provisional** — assign the next free slot
at execution time in commit order, so the isolation ADR and the adoption ADRs don't collide.

---

*No framework changes made. Workflow `wouutqjr2` (21 agents). Execution awaits review; sequence after the adoption
preconditions or interleave — the isolation policy is independent of the adoption bundle.*
