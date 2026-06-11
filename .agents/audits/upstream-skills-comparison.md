# Audit: upstream skills library vs Swarm — content-delta comparison

- Date: 2026-06-12 · Status: closed (ports applied same day)
- Upstream: `/Users/josecosta/dev/skills` (23 skills + `docs/` theory layer + templates)
- Method: 4 parallel comparison agents (authoring / implementation / discipline / meta),
  each mapping upstream skill → Swarm counterpart(s) and reporting only load-bearing deltas.

## Standing hazard (read before any future port)

Upstream's `docs/` essays (task-files, body-anatomy, self-containment) lean on three sources
Swarm formally **rejected** as misattributed arXiv ids (`docs/research/sources.md`, Rejected
table): InfiAgent "21x", More with Less "24–68%", PAACE. **Never port upstream prose
verbatim** — strip or re-ground on Swarm's verified equivalents (CTXENG, SCRATCHPAD, CCTASKS,
LOSTMID).

## Verdict summary (23 skills + meta surfaces)

- **Ported (applied in this commit):**
  - `starter-kit/advanced/adversarial-review/references/task-template.md` — repaired
    substitution bugs from the kit-alignment rewrite: duplicated `{{cmdTest}}` slots (now
    `{{cmdLint}}` + `{{cmdTest}}`), duplicated run-checklist line (now `{{cmdBuild}}` +
    `{{cmdLint}}`, then `{{cmdTest}}`), `{{cmdTypecheck}}` listed as both contract and
    non-contract (removed from non-contract), `## Verdict` → `## Suggested decision` rename
    finished, duplicated `specs/<feature>/` browse path.
  - `starter-kit/agent/write-spec/SKILL.md` — new rule 6 (structural decisions recorded with
    alternatives, routed to `decisions/` or Dropped from sources); specificity bar on Dropped
    from sources (rule 8); self-review gate line: pasted `git status` shows only spec docs.
  - `docs/reference/distillation.md` — same specificity bar on Dropped-from-sources entries.
  - `starter-kit/advanced/audit.md` + `.agents/skills/write-audit/references/task-template.md`
    — "Open questions / unverified areas" section (closes the loop with the self-review's
    "what is the audit NOT saying").
  - `docs/library/code-skills/write-refactor/` — **new** `references/task-template.md`
    (equivalence check, batch checkpoints, shim table, deletion-safety searches) + Bundled
    resources section + ~10-file default batch cadence in rule 4. Was the only per-kind guide
    without a run-notes scaffold.
  - `docs/library/code-skills/implement-task/SKILL.md` — the persona-discipline line the
    persona fold dropped: constraints do not soften when the work gets hard.
  - `docs/reference/agent-guides.md` — "Authoring your own guide" section (directive
    description form, Skip-for names task types not siblings, ~500-line body / one-hop
    references per SKILLBP, numbered rules + Refuses table, verification forces pasted output).
  - `starter-kit/agent/AGENTS.md` + `starter-kit/agent/implement-task/SKILL.md` — missing-
    command degradation rule: empty `cmd*` slot → ask, never invent; unresolvable Verify =
    Unverified, not Pass.
- **Nothing to port / already superseded (Swarm is a strict superset):** empirical-proof
  (13-row evasions vs upstream 7), fix-flaky-test, write-feature, write-fix, write-rewrite,
  write-migration, write-performance, write-testing, write-documentation, persona-migrator,
  persona-performance-surgeon, all 4 authoring personas, write-research, write-bug-report,
  upstream task-files essay (category mismatch: their "task file" is an agent scratchpad, not
  Swarm's handoff packet), upstream sources.md (no entry strengthens ours), upstream
  README/CONTRIBUTING practices.
- **Deliberate differences — do not regress toward upstream:** Blocked questions over
  `Assumptions: [pending]`; ADR-0056 adversarial self-review over "Final Polish"; ADR-0046
  isolation over per-template worktree constraints; description-match as fallback not
  canonical (ADR-0037); observation-only audits (no per-issue "Needed"/"Suggested approaches");
  equivalence-check-over-green-suite; scope-bounded doc reconciliation; per-boundary loss
  budget over the four-tests ceremony.
