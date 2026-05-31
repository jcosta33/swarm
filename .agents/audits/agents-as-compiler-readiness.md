# Audit: Agents-as-compiler readiness — can Swarm condition output to compiler-grade, multi-agent confidence?

## Status

Active

## Author

The Auditor — multi-agent dogfood pass. Produced by applying Swarm's own audit machinery to Swarm: `persona-auditor` (observation-not-prescription, file:line, severity-by-impact, every finding a "Needed"), `write-audit` (the nine rules + the completeness gate), `adversarial-review` (every candidate finding independently re-verified against the cited file before inclusion), and `empirical-proof` (each citation grep-checked). 7 facet auditors → 45 candidate findings → 34 confirmed after adversarial verification (11 rejected as misreads of intended design or wrong citations).

> **Dogfood caveat (and a live instance of Finding 3).** This audit's verification layer is itself LLM-grading-LLM. The same correlated-failure risk it names in Findings 1, 3, and 9 applies to the audit: an executable oracle independent of the model distribution was not available for most claims. File:line citations were grep-verified (mechanical, trustworthy); severity calibration and the "is this a real gap against the goal" judgments were not. Read the severities as argued positions, not measurements — which is exactly the ceiling the audit says the framework itself sits at.

---

## Linked docs

- Triggering ask: human request — "audit the entire repository toward the most-perfect multi-agent agentic framework; the goal is spec-as-code / agents-as-a-compiler with extremely high confidence in every task's output."
- Audit machinery used: [`personas/the-auditor.md`](../../docs/personas/the-auditor.md), [`skills/write-audit.md`](../../docs/skills/write-audit.md), [`skills/adversarial-review.md`](../../docs/skills/adversarial-review.md), [`skills/empirical-proof.md`](../../docs/skills/empirical-proof.md), [`skills/distillation-discipline.md`](../../docs/skills/distillation-discipline.md)
- Prior audits (this one layers on top, does not duplicate): [`docs-structure-skeptic-pass.md`](docs-structure-skeptic-pass.md) (doc↔scaffold consistency — largely resolved by the skills-repo merge), [`swarm-spec-adoption.md`](swarm-spec-adoption.md) (taxonomy/skill-coverage vs an external spec — partly resolved, partly superseded by ADR 0017)
- Framework principles & non-goals: [`docs/PRINCIPLES.md`](../../docs/PRINCIPLES.md), [`docs/NON-GOALS.md`](../../docs/NON-GOALS.md)
- Research grounding (2024–2026 state of the art): [`.agents/research/`](../research/), [`docs/skills/building/sources.md`](../../docs/skills/building/sources.md), plus fresh web research on multi-agent orchestration and verifiable-output patterns (summarised under *Best-practice context*)

---

## Goal

What "good" means for this audit — the north star the human set:

> Swarm should condition agent output so thoroughly that **spec-as-code becomes real and agents act as a compiler**: a source document deterministically and reproducibly yields correct, *independently verified* output, with **extremely high confidence in EVERY task's output**, and this holds for **multi-agent setups** (many agents / many sessions coordinating).

Three properties define the bar, and the audit judges every facet against them:

1. **Independent, executable verification** — output is trusted because a check *independent of the generator* (an executable oracle, not the same model re-reading prose) confirms it, mechanically, before promotion. A compiler does not ask the author whether the program type-checks.
2. **Reproducibility** — the same input yields the same verified result; a pass is shown stable, not captured once.
3. **Coordinated multi-agent confidence** — decomposition, hand-off, ownership, liveness, and merge are specified to a *buildable, auditable* degree so confidence survives across agents and sessions.

A standing constraint frames every finding: by Principle 1 ([`PRINCIPLES.md:9-15`](../../docs/PRINCIPLES.md)) and [`NON-GOALS.md:15`](../../docs/NON-GOALS.md), **Swarm-the-framework has no runtime and will not execute anything.** That is deliberate and correct. The audit therefore never faults Swarm for not running code. It faults Swarm where it (a) makes a confidence claim the conditioning layer cannot earn alone, or (b) fails to *specify the contract a compliant runtime must enforce* — which is the framework's job and its path to the goal.

---

## Scope

**In scope:**

- The whole repository judged against the goal above: `docs/` (concepts, personas, tasks, skills + `skills/building`, reference, ADRs, guides, PRINCIPLES, NON-GOALS), `scaffold/` (AGENTS.md, skills, templates, process docs), and the root README — read as the contract a consumer adopts.

**Out of scope:**

- Editing anything. Per `write-audit` discipline, this pass produces ranked observations + routes only. Every remediation routes through `spec-writing` (for contract changes) or a new ADR (for the divergences) before any docs PR.
- The doc↔scaffold mechanical-consistency surface already covered by the two prior audits and re-verified clean during the recent merge (0 broken links, counts reconcile).
- Anything requiring Swarm to become a runtime. The findings about "enforcement" are about *specifying the enforcement contract*, never about shipping an executor in this repo.

---

## Current state — the baseline (what is strong, and the one-sentence thesis)

An audit needs a baseline; here it is. **Swarm's input-conditioning layer is genuinely strong and, on its own terms, close to best-in-class.** Directive skill descriptions hit ~100% activation where passive phrasing collapses to ~55% ([`skills/building/activation.md`](../../docs/skills/building/activation.md)); `empirical-proof` makes missing evidence *conspicuous* (an empty paste block is visible); the flow graph gives repeatable routing; `distillation-discipline` makes information loss accountable; the skill layer is self-contained and portable. Against the question "did the agent read the right frame before it acted?", Swarm is excellent.

**The thesis of this audit, in one sentence:** *Swarm has built an excellent layer for conditioning what an agent reads before it acts, but the agents-as-compiler goal lives almost entirely in the layer Swarm has barely specified — independent, executable, reproducible, measured verification of what the agent produced — and the single highest-leverage move is to specify the verification/enforcement contract a compliant runtime must honour, the same way Swarm already specifies the conditioning contract.*

Every BLOCKER/MAJOR finding below is an instance of that one gap: the framework conditions the **input** richly and verifies the **output** by self-attestation.

### Best-practice context (what the field does that the goal implies)

From the research pass, the patterns leading 2024–2026 systems use to reach the bar Swarm aims at — cited here because the findings measure Swarm against them, not against an internal promise:

- **Execution-based gates, not self-report.** The trust mechanism is a check that *mechanically blocks* promotion on failure (programs-as-verifiers beat voting for code/math; compiled executable checks lifted instruction compliance from ~50% to ~88% in one cited study). Swarm sits one layer below this and says so.
- **Orchestrator-worker with up-only reporting + explicit per-worker contracts** (Anthropic's research system: lead spawns workers with explicit objective/output-format/tools/boundaries; "vague subtask descriptions" is the named #1 failure mode). No peer-to-peer worker coordination.
- **The orchestrator as a stateful ledger machine** with stall-detection-and-replan (Microsoft Magentic-One: Task Ledger + Progress Ledger).
- **Isolation + ownership for parallel writes** (git worktrees, Cursor 2.0 up to 8 concurrent, Claude Code built-in) with upfront file-ownership decomposition; file-sharing tasks are *sequenced*, not parallelised.
- **Durable execution / deterministic replay** (Temporal + OpenAI Agents SDK; LangGraph checkpointer/time-travel) — journal every step so a deterministic loop replays without re-running completed work.
- **Verifier multiplicity as a test-time-compute axis** (verifier ensembles, multi-agent verification, LLM-as-judge with a single-call 0–1 + pass/fail rubric). Self-consistency helps but amplifies error when the right answer is a minority mode — which is the correlated-failure trap.
- **Standardised hand-off / interop** (OpenAI Agents SDK Handoffs+Guardrails; A2A protocol, now Linux Foundation; MCP for capability discovery).

Swarm can *specify the contracts* for these even though it cannot enforce them. That boundary is its honest position **and** its current shortfall: it specifies the conditioning contracts in depth and the verification/coordination contracts barely.

---

## Findings

Each finding is severity-by-impact-on-the-goal, with file:line, observation, and a concrete **Needed** (what would close it — *what*, not *how*; the design choice routes to `spec-writing`). Findings are consolidated across the 7 facets (the raw 34 collapse to 14; cross-facet duplicates are merged). Ordered by impact.

### Part A — The output-verification gap (conditioning → compiler)

#### Issue 1 — Acceptance criteria are prose, never compiled to an executable oracle; the named "oracle" is the same prose the generator read [BLOCKER — against the goal]

- **File:line:** [`docs/skills/write-spec.md:9`](../../docs/skills/write-spec.md) ("executable contracts pretending to be Markdown"); [`docs/documents/spec.md:37`](../../docs/documents/spec.md) (acceptance criteria = the "oracle"); `scaffold/.agents/skills/write-feature/references/task-template.md:121` (spec-adherence check is "does every acceptance criterion *map to an implementation I can point at*?" — human/agent judgement); [`docs/skills/adversarial-review.md:13,29`](../../docs/skills/adversarial-review.md); [`docs/concepts/12-prior-art.md:35`](../../docs/concepts/12-prior-art.md) ("specifications become executable, first-class artifacts").
- **Observation:** Specs are *called* executable contracts and acceptance criteria are *called* the completeness oracle, but they are human/agent-graded prose. They are never compiled into fail-on-violation / pass-on-satisfaction assertions, and no rule requires a generated test to be validated as a true oracle before it is trusted. The closing gate for the dominant feature lane is prose-matching by the same model distribution that wrote the code; the Skeptic then re-runs the *same* worker-authored suite derived from the *same* prose spec — a correlated check, not an independent one. (One lane already meets the bar: `write-fix` rule 3 requires a regression test that fails before the fix and passes after, anchored to a concrete reproduction. That proves the pattern is reachable — it just isn't generalised to acceptance criteria or to refactor/migration equivalence.)
- **Needed:** Decide and state one of: **(a)** acceptance criteria MUST be expressible as executable assertions, validated as oracles (fail-on-violation / pass-on-satisfaction) and bound to a verification gate a compliant runtime runs at promotion — making the intent→test binding mechanical, not interpretive; or **(b)** explicitly scope down the "executable contract / spec-as-code / Spec-Kit parity" language (`write-spec.md:9`, `spec.md:37`, `12-prior-art.md:35`) to "human/agent-graded prose interpreted downstream into tests." This is *the* gap between Swarm and agents-as-a-compiler; it is BLOCKER **against the stated goal** (not against the framework functioning as conditioning).
- **Verified by:** grep `oracle` across `docs/`+`scaffold/` returns only metaphorical uses; `write-spec.md:9` and `spec.md:37` quoted verbatim; `write-fix/SKILL.md` rule 3 confirmed as the one real oracle; feature template:121 confirmed as a point-at judgement.

#### Issue 2 — The central confidence gate is self-attested, not harness-enforced; evidence is forgeable free text in a deletable file [MAJOR]

- **File:line:** [`docs/skills/empirical-proof.md:17`](../../docs/skills/empirical-proof.md) ("still gameable with fabricated output"), `:31` ("sabotage via selective tail-paste"); [`docs/concepts/09-empirical-proof.md:3,13`](../../docs/concepts/09-empirical-proof.md) ("hard gate" / "the agent cannot complete the pattern without first pasting evidence"); [`docs/PRINCIPLES.md:49-53`](../../docs/PRINCIPLES.md) (Principle 5, "non-negotiable hard gate"); `scaffold/.agents/skills/write-feature/references/task-template.md:149` ("Only when every answer above is written is this task complete"); [`docs/PRINCIPLES.md:75-79`](../../docs/PRINCIPLES.md) (task files gitignored/deletable).
- **Observation:** Empirical-proof — the strongest confidence primitive — relies entirely on the agent *running* a command and *pasting* output; nothing mechanically re-runs the verifier or blocks `status: done` on failure (no runtime, by Principle 1). The skill's own body concedes gameability and selective tail-paste; completion is defined as "answers written." The evidence lives as free-text paste blocks in a gitignored, deletable task file — not a tamper-evident, machine-parseable trace (commands, exit codes, artifact lineage). The "hard gate / non-negotiable" framing in the concept and principle docs never carries this caveat up to where the claim is made.
- **Needed:** Reconcile the two principles where the claim is asserted (`09-empirical-proof.md:3`, `PRINCIPLES.md:49-53`): state that pasted evidence is agent-self-attested and forgeable absent a re-running harness. Then either **(a)** define the *harness contract* a compliant launcher MUST implement — re-run the bound `{{cmd*}}` commands, block promotion on non-zero exit or empty/placeholder paste, emit a tamper-evident trace; the `AGENTS.md > Commands` contract is the natural attachment point — or **(b)** scope the confidence claim down to "discipline and mechanical conspicuousness, not enforcement," so the docs do not assert compiler-grade per-task confidence the self-attestation mechanism cannot earn.
- **Verified by:** `empirical-proof.md:17,31` quoted verbatim; `PRINCIPLES.md:9-15` + `NON-GOALS.md:15` confirm no re-run harness by design; feature template:149 confirms completion = answers written.

#### Issue 3 — Independent verification is multi-agent-only and optional; absent entirely for solo work (the stated default) [MAJOR]

- **File:line:** [`docs/PRINCIPLES.md:41,43`](../../docs/PRINCIPLES.md) (routing is "recommended, not enforced"; nothing in-session blocks re-assessment); `scaffold/AGENTS.md` Routing + Subagent-strategy sections (`:88,90,97`); [`scaffold/.agents/skills/adversarial-review/SKILL.md:3`](../../scaffold/.agents/skills/adversarial-review/SKILL.md) ("Skip this skill for original authoring work"); [`docs/concepts/09-empirical-proof.md:100`](../../docs/concepts/09-empirical-proof.md) (rule 5 opens "When reviewing another agent's branch"); [`docs/concepts/12-prior-art.md:172-178`](../../docs/concepts/12-prior-art.md) ("what this research did not resolve").
- **Observation:** The only non-self oracle is the Skeptic / adversarial-review re-run "in your own worktree." It (a) only fires in multi-agent review — `adversarial-review` explicitly skips solo authoring; (b) is non-binding (recommended routing; the `feature → Skeptic` handoff is a "suggested default, not a binding"); and (c) when it fires, is a single uncalibrated LLM judgement with no agreement/voting/ensemble (no verifier multiplicity). Solo single-threaded work — which AGENTS.md names the default for all write-side tasks — terminates at the *same* agent's `## Self-review`. No document distinguishes "self-reviewed" from "independently-reviewed" confidence. So "extremely high confidence in EVERY task" lacks an independent oracle precisely in the common case.
- **Needed:** Name explicitly which task types reach the bar via *independent* verification versus which terminate at self-certification, and record the single-LLM-judge reliability ceiling (the `12-prior-art.md` "did not resolve" section is the natural home). For the compiler bar, identify where an independent oracle and/or verifier multiplicity (panel / voting / self-consistency with reported agreement) is expected.
- **Verified by:** `PRINCIPLES.md:41,43`, `AGENTS.md:88,90,97`, `adversarial-review/SKILL.md:3`, `09-empirical-proof.md:100` all read in context; repo-wide grep found no mandatory-review rule and no self-vs-independent confidence distinction.

#### Issue 4 — No rerun-stability of verification: a pass captured once-by-luck satisfies the gate identically to a reliable pass [MINOR]

- **File:line:** [`docs/reference/verification-gates.md`](../../docs/reference/verification-gates.md) (gate model captures each slot once); `scaffold/.agents/skills/empirical-proof/SKILL.md:30-32` (rule 4 "re-run after every change" = freshness, not stability); [`docs/concepts/01-what-is-swarm.md:151`](../../docs/concepts/01-what-is-swarm.md) (determinism scoped to persona); [`docs/NON-GOALS.md:9`](../../docs/NON-GOALS.md) (sampling/model is the CLI's job).
- **Observation:** Output-model determinism (seeds/temperature) is correctly an explicit NON-GOAL — not faulted. But within scope, the verification gate captures each result exactly once; "re-run after every change" means after *edits*, not for stability. A flaky gate that passed once is indistinguishable from one that passes reliably. Only `fix-flaky-test` currently requires rerun-stability.
- **Needed:** Co-locate a one-line scope statement with the determinism claims (deterministic = starting conditioning, not output), and consider a rerun-stability / flake-suspect slot in the verification-gate model so "ran green once" is distinguishable from "runs green reproducibly." Observation-level; model determinism stays out of scope.
- **Verified by:** `verification-gates.md` read (no rerun/stability slot); repo grep for `reproducib*`/`idempoten*` finds only test-flakiness and bug-repro uses; `NON-GOALS.md:9` confirms sampling is out of scope.

### Part B — Multi-agent orchestration is under-specified for high-confidence coordination

#### Issue 5 — Orchestration — the highest-stakes multi-agent task — has no self-activating conditioning surface [MAJOR]

- **File:line:** [`docs/personas/the-lead-engineer.md:3`](../../docs/personas/the-lead-engineer.md) ("ships no persona skill and no workflow skill"); [`docs/concepts/07-flow-graph.md:108,126`](../../docs/concepts/07-flow-graph.md) (no always-loaded skill; orchestration lists only `adversarial-review`, `empirical-proof`); [`docs/tasks/integration.md:34-40`](../../docs/tasks/integration.md) (credential/boundary discipline) vs `scaffold/.agents/skills/write-feature/SKILL.md` (no credential/secret content).
- **Observation:** Every other task type self-activates via a directive skill `description`. Orchestration is the explicit exception — the Lead-Engineer discipline (decompose, ownership, merge order, kickback) lives only in a flat template that a launcher must pre-scaffold. With no always-loaded skill and recommended-not-enforced routing, an agent handed a 5-spec ask has *zero* in-session conditioning to assume the orchestration stance: the most complex, highest-stakes multi-agent path is the only one with no self-activation surface. The same shape recurs for `integration` (its secret/boundary non-negotiables live only in a recommended docs page, not in `write-feature`, which it routes to), `upgrade`, `kickback`, `review`, and `deepen-audit`.
- **Needed:** The orchestration discipline (and integration's boundary discipline) must be reachable *in-session* by directive-description match — the same mechanism every single-agent path uses — not solely by a launcher copying the flat template once at scaffold time. (Whether via a description-activating orchestration skill, a Lead-Engineer persona skill, or a description added to an existing skill is the design call.)
- **Verified by:** `the-lead-engineer.md:3` and `07-flow-graph.md:126` quoted verbatim; `ls scaffold/.agents/skills | grep -i orch` → no match; grep `decompose|orchestrat|lead engineer` over `scaffold/.agents/skills/*/SKILL.md` → none.

#### Issue 6 — The disjoint-file-ownership invariant — the linchpin of write-side safety — is recorded nowhere and is uncheckable [MAJOR]

- **File:line:** `scaffold/.agents/templates/task-orchestration.md:43-45` (Worker tracker columns: Slug / Source doc / Task type / Persona / Branch / Status / Last review verdict — **no owned-paths column**); [`docs/concepts/10-subagent-strategy.md:159`](../../docs/concepts/10-subagent-strategy.md) ("Two workers must not touch the same file"); `.agents/research/swarm-spec.md:56` (Lead Engineer's "ownership map" deliverable — research only, never shipped).
- **Observation:** Disjoint file scopes is named the linchpin of write-side parallel safety, yet the canonical orchestration artifact records every per-worker fact *except* which files each worker may touch. No checklist item or self-review question confirms scopes are non-overlapping at decomposition time. The "ownership map" exists only in research prose. So decomposition correctness — the property that makes parallel writes safe at all — is neither captured in nor re-derivable from the task file. (Backstopped by serial merges + per-merge validation, which is why this is MAJOR not BLOCKER — the failure surfaces at merge, not silently.)
- **Needed:** Per-worker owned/forbidden paths, plus a recorded confirmation that worker scopes do not overlap, must become fields in the canonical orchestration artifact, so disjointness is auditable and re-derivable rather than unwritten advice.
- **Verified by:** `task-orchestration.md:43-45` read (no scope column); grep `file|scope|disjoint|overlap|owns` on the template → only incidental matches; `10-subagent-strategy.md:159` verbatim; "ownership map" found only in `.agents/research/swarm-spec.md`.

#### Issue 7 — No structured spawn / hand-off contract; workers inherit a generic task file, not lead-authored boundaries [MAJOR]

- **File:line:** [`docs/concepts/08-recursion-and-delegation.md:36-40`](../../docs/concepts/08-recursion-and-delegation.md) (spawn described in prose: "scaffolds a conditioned task file… spawns an agent CLI session"); `scaffold/.agents/templates/task-base.md` (no parent-contract / boundary / expected-output section); contrast `scaffold/.agents/skills/write-audit/references/task-template.md` and `write-spec/references/task-template.md` (both already use a structured `## Scope` In/Out).
- **Observation:** SOTA orchestrator-worker spawns workers with explicit objective + output-format + tools + boundaries; "vague subtask descriptions" is the field's named #1 failure mode. Swarm's spawn is prose; the shared `task-base.md` every child inherits has no parent-contract section; the worker gets a generic "work only inside this worktree" constraint, not lead-authored lane boundaries, an expected deliverable shape, or the acceptance bar the parent will review against. The framework already uses structured `## Scope` fields in its audit/spec templates — so this is an inconsistency on the delegation path, not a deliberate stance.
- **Needed:** The delegated worker's task file (and the tracker row that seeds it) should carry the boundary clauses as explicit fields — owned/forbidden scope, expected deliverable, acceptance bar — mirroring the `## Scope` pattern already shipped. (Achievable bar is "structured fields a reviewer reads," not "machine-enforced," given no runtime.)
- **Verified by:** `08-recursion-and-delegation.md:36-40` read; grep `parent|received|handoff|boundary|ownership` over `task-base.md` and the write-feature child template → no parent-contract section; `## Scope` confirmed present in audit/spec templates.

#### Issue 8 — No liveness / stall-detection / re-plan loop; a stalled or diverging worker is an invisible state [MAJOR]

- **File:line:** `scaffold/.agents/templates/task-orchestration.md:47` (Status enum: not-started / in-progress / awaiting-review / kicked-back / merged / abandoned — terminal stages only); `:96-103` (one-pass linear checklist); [`docs/concepts/08-recursion-and-delegation.md:170-177`](../../docs/concepts/08-recursion-and-delegation.md) ("Failure modes the protocol defeats" — a stalled/diverging worker is not among them).
- **Observation:** The SOTA liveness mechanism (Magentic-One's Progress Ledger: detect N stalled steps → re-plan) has no analogue here. The tracker's Status enum is terminal-state only — no progress marker, timestamp, or stall field; grep `stall|replan|stuck|no progress|liveness` across all multi-agent docs returns nothing. The 3-round kickback limit is a *quality* mechanism (fires only after a worker reports done), not a *liveness* one. A worker hung in `in-progress`, or two workers silently diverging, is unrecorded and undetected — and the framework's own defeated-failure-modes table omits it.
- **Needed:** A recorded per-worker liveness marker (a last-progress field), a defined stall condition (a documented threshold of no-progress observations), the explicit action it triggers (re-plan / re-scope / escalate / abandon), and a "stalled / diverging worker" row in the failure-modes table. A documented contract the lead must maintain — not a runtime daemon.
- **Verified by:** `task-orchestration.md:47` read (terminal states only); repo grep `stall|stalled|replan|stuck|liveness|heartbeat` → no relevant matches; `08:170-177` failure-modes table read (no stalled-worker row).

#### Issue 9 — Conflict resolution has no verification beyond a suite the docs themselves say is blind to the bug [MAJOR]

- **File:line:** [`docs/concepts/08-recursion-and-delegation.md:109-126`](../../docs/concepts/08-recursion-and-delegation.md) (merge protocol = ordering advice + "validate after each merge"); [`docs/concepts/10-subagent-strategy.md:151-156`](../../docs/concepts/10-subagent-strategy.md) (conceded failure: a plausible resolution introduces an ordering bug, "tests pass… the bug ships"); `scaffold/.agents/templates/task-orchestration.md:67-77` (Merge log: Conflicts / Resolution as free text); [`docs/tasks/refactor.md:15`](../../docs/tasks/refactor.md) + [`docs/skills/write-migration.md:31`](../../docs/skills/write-migration.md) ("tests pass before/during/after").
- **Observation:** The single riskiest write-side step — conflict resolution — is verified only by re-running the same suite the framework's own walkthrough admits can miss exactly this class of bug, plus a Skeptic reading of the merged diff (correlated LLM-on-LLM review). The Merge log records the resolution as free text with no requirement to prove both branches' intent survived. The identical gap covers refactor/migration behaviour-preservation: "re-run the same suite," no differential / property-based / metamorphic equivalence oracle.
- **Needed:** Conflict resolution and behaviour-preservation should name property-based / differential / metamorphic checking as the recommended equivalence oracle (so "same suite passes" is not the sole proof), or explicitly record the omission in `12-prior-art.md`'s "what this research did not resolve."
- **Verified by:** `10-subagent-strategy.md:151-156` quoted verbatim; merge protocol + Merge log read; refactor/migration disciplines confirmed to rest equivalence on the existing suite only.

### Part C — Determinism vs the compiler claim

#### Issue 10 — The determinism story is unreconciled after ADR 0020 and over-claimed relative to the goal [MAJOR]

- **File:line:** [`docs/adrs/0020-activation-by-self-assessment.md:9-24`](../../docs/adrs/0020-activation-by-self-assessment.md); [`docs/adrs/0002-personas-1-to-1-with-task-types.md:11-15`](../../docs/adrs/0002-personas-1-to-1-with-task-types.md) (superseded); [`docs/concepts/01-what-is-swarm.md:3`](../../docs/concepts/01-what-is-swarm.md) ("deterministic conditioning pipeline"); [`docs/concepts/02-conditioning-pipeline.md:3,224`](../../docs/concepts/02-conditioning-pipeline.md); [`docs/concepts/12-prior-art.md:35`](../../docs/concepts/12-prior-art.md) (Spec-Kit "executable" parity).
- **Observation:** ADR 0020 demoted routing from deterministic to "recommended" + agent self-assessment, but the headline "deterministic conditioning pipeline" survives un-scoped in the concept TL;DRs, and even the surviving determinism covers only *persona selection*, never output. ADR 0020 frames the loss merely as "Negative: loses hard determinism," without naming the multi-agent reproducibility consequence or the continuation-bias hazard from 0002 it reintroduces. This is the direct tension with the goal the human stated: a compiler is deterministic, and the framework just traded determinism for flexibility without compensating for it on the verification side.
- **Needed:** ADR 0020 should name the tension with the agents-as-compiler/determinism goal explicitly and state how — or concede that it does not — preserve cross-agent / cross-session conditioning consistency when no launcher is present. Co-locate a scope statement with every determinism claim (deterministic = starting conditioning, not output). Soften `12-prior-art.md:35`'s Spec-Kit "executable artifacts" parity claim to match Issue 1.
- **Verified by:** ADR 0020 and 0002 read; `01-what-is-swarm.md:3` + `02-conditioning-pipeline.md:3,224` confirm the un-scoped determinism headline; `12-prior-art.md:35` quoted.

### Part D — No measurement: the reliability claim is untested

#### Issue 11 — Zero eval harness or effectiveness metric; the conditioning-works claim is asserted, never measured [MAJOR]

- **File:line:** [`docs/concepts/09-empirical-proof.md:3,13`](../../docs/concepts/09-empirical-proof.md) ("defeats hallucinated completion" / "the structural defence"); `.agents/research/empirical-evidence.md:15,85,306` (conditioning effectiveness = untested hypothesis, no benchmark realised); [`docs/concepts/03-distillation.md:98-109`](../../docs/concepts/03-distillation.md) + `scaffold/.agents/skills/distillation-discipline/SKILL.md:54-69` (the four-test fidelity table is self-graded by the distilling agent); [`docs/tasks/kickback.md:44-52`](../../docs/tasks/kickback.md) (round count lives only in the gitignored task file).
- **Observation:** The docs assert empirical-proof "defeats" hallucinated completion and is "the framework's structural defence," but the framework's *own* research records conditioning effectiveness as an untested hypothesis with no benchmark, and no effectiveness metric exists anywhere in shipped docs/scaffold. Distillation fidelity is self-graded by the same agent (no second-agent or mechanical upstream-vs-downstream coverage diff — unlike empirical-proof's rule 5, there is no independence requirement). Per-task binary gates never compose into a set-level integrity signal for the multi-agent goal. The kickback round-count — the one structural error-correction limit — is not durable across sessions/worktrees, so a fresh session cannot reliably tell that a branch has hit the escalation threshold.
- **Needed:** Either downgrade the effectiveness language to match the untested-hypothesis status the research already records, or define the measurement contract: what would demonstrate that empirical-proof reduces hallucinated completion; an independent or mechanical distillation-fidelity check at the spec→task boundary; a cross-session-durable escalation state; and a composite, promotion-blocking integrity condition for multi-worker sets.
- **Verified by:** `09-empirical-proof.md:3,13` quoted; `empirical-evidence.md:15,85,306` read; distillation four-test table confirmed self-graded; `kickback.md:44-52` confirms round count is per-task-file only.

### Part E — The framework's own rules are not machine-checkable

#### Issue 12 — Conformance is 100% prose; nothing — not even "is this a well-formed task file?" — is machine-checkable [MAJOR]

- **File:line:** [`scaffold/README.md:207`](../../scaffold/README.md) (conformance checker "when it ships"); [`docs/reference/directory-layout.md:148-166`](../../docs/reference/directory-layout.md) (itemised checklist, prose); [`docs/reference/agents-md.md:163-170`](../../docs/reference/agents-md.md) (required-section list, prose); [`docs/reference/template-placeholders.md:150-158`](../../docs/reference/template-placeholders.md) (the runner "iff" rule, prose); `scaffold/.agents/templates/task-base.md:1-159` (structure is convention).
- **Observation:** The conformance *rules* exist and are mechanizable, but there is no machine-readable encoding (schema/manifest of required task-file sections, required `AGENTS.md > Commands` rows, legal placeholder namespaces) and no shipped contract/fixtures for an executable gate. There is no definition of a "well-formed task file" any tool could validate — so the verification-gate sections that carry the entire compiler bar (`## Verification outputs`, `## Self-review`) are present-by-convention, with no check that a `[Paste output]` block is non-empty. For a framework whose goal is spec-as-code, its own rules should be the first thing that is machine-verifiable.
- **Needed:** A machine-readable encoding of the existing conformance rules, plus — at minimum — the framework repo shipping the *contract* for an executable gate (fixtures of a conformant repo and of each violation class with expected pass/fail), so a compliant runtime has something precise to enforce. (The checker itself is a CLI concern; the contract is the framework's job.)
- **Verified by:** `directory-layout.md:148-166`, `agents-md.md:163-170`, `template-placeholders.md:150-158` read (all prose); `NON-GOALS.md:37`, `README.md:33`, `scaffold/README.md:207` confirm the checker is unshipped.

#### Issue 13 — Command-contract and version/migration inconsistencies make the contract internally unbindable [MINOR]

- **File:line:** [`docs/reference/template-placeholders.md:67,74,75,76`](../../docs/reference/template-placeholders.md) (`cmdLint`, `cmdMarkdownLint`, `cmdLinkCheck`, `cmdCitationCheck`); `scaffold/AGENTS.md:30-42` (Commands table — no rows for those four); [`scaffold/README.md:213`](../../scaffold/README.md) (`MIGRATIONS.md`); [`docs/adrs/0015-versioning-scheme.md:15`](../../docs/adrs/0015-versioning-scheme.md) (`MIGRATION.md`, singular).
- **Observation:** The placeholder catalogue lists 12 `{{cmd*}}` slots, but four have no `AGENTS.md > Commands` row and no shipped-template usage — unbindable by construction (and `write-documentation/SKILL.md:16` separately calls the doc-lint family "not in the standard contract"). `MIGRATIONS.md` / `DEPRECATIONS.md` / a CHANGELOG are promised by the docs but do not exist, and the versioning ADR even disagrees with the README on the filename (singular vs plural). No framework version is recorded anywhere machine-locatable in the vendored scaffold, so an adopter cannot answer "what version do I hold."
- **Needed:** Reconcile the placeholder catalogue with the bindable contract and mark each slot's contract status (required / extended / out-of-contract); ship-or-remove the upgrade ledger the docs promise; reconcile the filename so every reference agrees; record the framework version somewhere an adopter (or a checker) can read.
- **Verified by:** `template-placeholders.md` slots cross-checked against `scaffold/AGENTS.md:30-42`; `find` confirms no MIGRATIONS/DEPRECATIONS/CHANGELOG; `0015:15` vs `scaffold/README.md:213` filename mismatch quoted.

#### Issue 14 — The internal research/design corpus now contradicts the shipped framework, unmarked [MINOR]

- **File:line:** `.agents/research/swarm-spec.md:1076,1634-1737` (specifies `write-orchestration`, `manage-task`, `documentation-gatekeeper` skills + a 12-persona / 14-task taxonomy); contrast the shipped 23-skill surface and [`docs/adrs/0017-no-always-load-skills.md`](../../docs/adrs/0017-no-always-load-skills.md).
- **Observation:** The research/design docs under `.agents/research/` still specify skills and a taxonomy the post-merge framework deliberately does not contain (ADR 0017 removed the always-loaded skills; the persona/task taxonomy diverged). Neither doc carries a superseded/historical marker, so a reader cannot tell originating design exploration from current canon. (This overlaps the prior `swarm-spec-adoption.md` audit, which is itself now partly superseded by the merge — a second instance of the same staleness.)
- **Needed:** Add a top-of-file banner to each `.agents/research/` design doc: "originating design exploration; superseded on the skill layer by ADR 0017; `docs/` + ADRs are canonical" — or re-ship the items. Same for the prior audit's resolved findings.
- **Verified by:** `swarm-spec.md:1076,1634-1737` read; cross-checked against the 23 shipped skill dirs and ADR 0017.

---

## Risks

Things that could go wrong, named explicitly with their firing condition.

| Risk | Fires when | Consequence |
| --- | --- | --- |
| **Compiler claim outruns the mechanism** | Adopters read "executable contracts," "hard gate," "deterministic," "spec-as-code" (Issues 1, 2, 10) as guarantees | They skip the human re-check the framework actually still requires; fabricated/lucky-pass output ships with false confidence — the exact "hallucinated completion" failure empirical-proof exists to defeat, now at the framework's own claim layer |
| **Silent parallel-write corruption** | A multi-agent orchestration runs with overlapping worker scopes that were never recorded (Issue 6) and a conflict resolution introduces a bug the shared suite doesn't cover (Issue 9) | Two workers' assumptions collide; the merge is green; the bug ships — the failure the disjoint-scope rule exists to prevent, undetected because the invariant was never an auditable field |
| **Stalled-worker deadlock at scale** | An orchestration with many workers/sessions has one hung in `in-progress` (Issue 8) | No trigger fires; the single Lead-Engineer agent must notice by hand, in a model the research says degrades superlinearly with coordination load |
| **Correlated-verifier false confidence** | Solo work, or a Skeptic re-running the same spec-derived suite (Issues 1, 3) | LLM-grades-LLM against the same prose; an intent error encoded in both spec and tests passes generator *and* reviewer — confidence is high and wrong |
| **Unmeasured regression** | A future change weakens conditioning effectiveness (Issue 11) | Nothing detects it — there is no metric, so the framework cannot tell improvement from regression |
| **Adopter version drift** | A consumer holds a vendored scaffold and the framework changes (Issues 13, 14) | No version marker, no migration ledger, contradictory internal design docs — the adopter cannot tell what they have or how to upgrade |
| **Treating this audit as a worklist** | Findings are pasted into PRs directly | They are routes, not tickets; each needs `spec-writing` (contract change) or an ADR (divergence) first — skipping that hop is the prose-folklore failure mode the framework opposes |

---

## Suggested approaches

How a downstream effort could address the findings — *approach*, not implementation, sequenced because several interact. Each routes through `spec-writing` and/or a new ADR.

1. **Decide the framework's honest altitude first (gates everything).** One `spec-writing` task + ADR answering the load-bearing question behind Issues 1, 2, 10: *does Swarm aim to specify a verification/enforcement contract a compliant runtime must honour, or does it scope its confidence claims down to "disciplined conditioning, independently verified elsewhere"?* Every other finding's resolution depends on this answer. The audit's recommendation: **specify the contract** — it is the only path to the goal and it stays within Principle 1 (a contract is not a runtime).

2. **Specify the verification/enforcement contract (Issues 1, 2, 12).** Bundle: an executable-acceptance-criteria layer (acceptance criteria expressible as oracle-validated assertions bound to a gate), the harness contract a launcher MUST implement (re-run bound commands, block promotion on failure/empty paste, emit a tamper-evident trace), and a machine-readable conformance schema (well-formed task file, required `AGENTS.md > Commands` rows, legal placeholders) with fixtures. This is the single highest-leverage cluster: it converts "discipline" into "enforceable contract."

3. **Specify the multi-agent coordination contract (Issues 5, 6, 7, 8, 9).** Bundle: a self-activating orchestration conditioning surface; per-worker owned/forbidden-scope and hand-off fields in the orchestration artifact + child template; a liveness/stall state + re-plan trigger; and an equivalence-oracle (property/differential) expectation for conflict resolution and behaviour-preservation. Grounds directly in the orchestrator-worker + Progress-Ledger + ownership-map patterns the research documents.

4. **Add verifier independence and (optionally) multiplicity (Issues 3, 9, 11).** Name where an independent oracle / verifier panel is expected; record the single-LLM-judge ceiling; define the measurement contract (what demonstrates conditioning works; cross-session-durable escalation; composite integrity signal).

5. **Reconcile claims and hygiene (Issues 4, 10, 13, 14).** Documentarian-scope, parallelisable, low-risk: scope the determinism claims, fix the placeholder/version/migration inconsistencies, and mark the stale research/design corpus. Land any time; they reduce the next reader's confusion without changing contracts.

Sequencing summary: **decide altitude → verification contract → coordination contract → verifier independence/measurement → claim & hygiene reconciliation.** Steps 2–4 are where the agents-as-compiler goal is actually won or conceded.

---

## Open questions

- [ ] **[CRITICAL]** Altitude (Suggested approach 1): specify an enforcement contract a runtime must honour, or scope the confidence claims down? Unanswered, this blocks Issues 1, 2, 10, 12 from being resolvable in a consistent direction.
- [ ] **[CRITICAL]** Does "agents-as-a-compiler" require Swarm to define an executable-acceptance-criteria format (a spec sub-schema that compiles to assertions), or is that explicitly a consumer/runtime concern the framework only references? Issue 1 cannot close without this call.
- [ ] **[CRITICAL]** Is cross-agent / cross-session *conditioning* reproducibility a framework guarantee after ADR 0020 (same source-doc + task-type → same starting conditioning, launcher-independently), or is it now best-effort? (Issue 10.)
- [ ] **[MINOR]** Should the orchestration coordination contract (Issue 5–9) ship as a new self-activating skill, a Lead-Engineer persona skill, or fields added to the existing template — and does adding it reopen the ADR 0019 "a persona ships only when its mindset adds beyond the workflow skill" rule?
- [ ] **[MINOR]** Do verifier multiplicity / voting (Issue 3) belong in the framework contract at all, or are they a runtime/CLI strategy the framework merely names as available?

---

## Distillation Loss Statement

**Dropped from the audit (the raw run produced more than is carried here):**

- The 11 candidate findings the adversarial-verification phase rejected (45 → 34) are not reproduced; they were misreads of intended design (e.g. faulting output-sampling determinism that NON-GOALS.md:9 explicitly disclaims) or carried wrong citations.
- The full 34 verified findings were consolidated to 14; the per-facet duplicates (self-attestation appeared in 3 facets, no-executable-oracle in 5, no-handoff-contract in 2) are merged with all their citations preserved in the surviving issues.
- The complete research corpus (multi-agent + verifiable-output, ~2M tokens across 54 agents) is distilled to the *Best-practice context* block and the citations woven into findings; the full source list and per-framework detail were not transcribed.
- Verbose verifier reasoning (severity recalibrations, citation corrections) is folded into final severities and "Verified by" lines rather than reproduced.

**Why downstream doesn't need it:**

- Every surviving finding cites the specific file:line and the specific gap, so a follow-up `spec-writing` task can grep-expand without re-running the audit.
- The rejected candidates were rejected *because* they were not real against the goal; carrying them would re-import noise.
- The research is grounding, not a deliverable; the patterns that bear on a finding are cited at that finding.

---

## Completeness gate (write-audit rule 9)

| Issue | `file:line` present? | Severity | `Needed` non-empty? |
| --- | --- | --- | --- |
| 1 — acceptance criteria not compiled to an oracle | ✅ | BLOCKER (vs goal) | ✅ |
| 2 — confidence gate is self-attested, not enforced | ✅ | MAJOR | ✅ |
| 3 — independent verification optional / absent solo | ✅ | MAJOR | ✅ |
| 4 — no rerun-stability of verification | ✅ | MINOR | ✅ |
| 5 — orchestration has no self-activating conditioning | ✅ | MAJOR | ✅ |
| 6 — disjoint-ownership invariant unrecorded | ✅ | MAJOR | ✅ |
| 7 — no structured spawn/hand-off contract | ✅ | MAJOR | ✅ |
| 8 — no liveness / stall-detection loop | ✅ | MAJOR | ✅ |
| 9 — conflict resolution unverified beyond a blind suite | ✅ | MAJOR | ✅ |
| 10 — determinism unreconciled / over-claimed | ✅ | MAJOR | ✅ |
| 11 — no eval harness / effectiveness metric | ✅ | MAJOR | ✅ |
| 12 — conformance 100% prose, nothing machine-checkable | ✅ | MAJOR | ✅ |
| 13 — command-contract / version / migration inconsistencies | ✅ | MINOR | ✅ |
| 14 — internal research corpus contradicts shipped framework | ✅ | MINOR | ✅ |

All rows ✅ — audit is finalisable. 1 BLOCKER (against the goal), 10 MAJOR, 3 MINOR.
