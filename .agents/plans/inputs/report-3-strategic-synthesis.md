---
title: "Swarm: Practical Spec, Change, Task, and Review Workflow"
status: "strategic synthesis"
version: "0.2"
purpose: "Synthesize market research, current Swarm audit findings, simplified positioning, and the missing Change Plan / Inventory concepts into a practical target architecture."
note: "Persisted verbatim from the owner's message (2026-06-11) as execution input for the repositioning plan. See .agents/plans/practical-swarm-repositioning-plan.md §12 for its integration."
---

# Swarm: Practical Spec, Change, Task, and Review Workflow

## 0. Executive summary

Swarm should not be positioned as a compiler, an agent runtime, or a formal language platform.

The strongest positioning is:

> **Swarm is a lightweight spec and review workflow for teams using coding agents.**

The sharper one-liner:

> **Swarm turns tickets into clear specs, specs into agent-ready tasks, and agent output into reviewable evidence.**

Market grounding (summary): users want clearer paths from vague work items to implementation; platform teams want shared artifacts, human/AI handoff boundaries, central knowledge hubs; issue trackers already use structured templates; EARS/controlled-NL is precedent for lightweight structured requirements; ambiguity measurably hurts LLM codegen and clarification loops improve it; refactoring is not automatically safe and needs preservation-oriented planning; large agent diffs shift the bottleneck to review; overproduced agent workflows create the illusion of work.

Practical loop:

    Pull → Inventory → Spec → Change Plan → Task → Run → Review → Close

Not every task needs every step. Common flows:
- Feature: Pull → Spec → Task → Run → Review → Close
- Refactor: Inventory/Audit/Finding → Change Plan → Task → Run → Review → Close
- Bug: Pull Bug → Spec check → Task → Run → Review → Close
- Brownfield rewrite: Inventory → Audit → Spec + Change Plan → Tasks → Run → Review → Close
- Small cleanup: Task → Run → Review → Close
- Spike: Question → Research/Spike → Decision: spec, change plan, or no action

Central correction: Swarm is not trying to make agents deterministic. Swarm reduces the mess around agent-assisted work (less context-pasting, vague prompting, branch/worktree chaos, unreviewable output, lost knowledge; better links from tickets to specs to tasks to reviews to PRs to findings).

Most important conceptual additions:
1. **Inventory** — a contract map for brownfield code before major change.
2. **Change Plan** — a first-class artifact for planned transformations (refactors, rewrites, migrations, upgrades, large cleanups).
3. **Review Packet** — the central product wedge.
4. **Honesty Framework** — every unenforced convention must say it is a convention, not runtime enforcement.

Most important simplifications: plain `.md` files; frontmatter `type:` as the artifact discriminator; SOL as notation, not a language; lint codes as checklist IDs until a linter exists; smallest useful starter kit; no closed-set numerology or compiler framing in first-contact docs; demote lower/decompose/IR/proof matrices/conformance to advanced/future tooling.

# 1. Product category

Best category: **spec and review workflow for coding agents.** Adjacent: coding agents (Claude Code, Codex, OpenCode, Cursor, Aider — Swarm organizes work for them); spec-driven workflows (Spec Kit, Kiro, BMAD, OpenSpec — borrow structure, avoid ceremony); issue/project systems (pull from, never replace); docs portals (may publish into, never become); review/quality tooling (adds spec/task/review evidence); refactoring/migration tooling (plans + review evidence, not transformation engines).

Swarm is: a workflow for clearer specs; a small file convention (specs, inventories, change plans, task packets, reviews, findings); lightweight structure for coding-agent work; ticket→code-change connection; reviewable evidence from agent output; a future CLI target.
Swarm is not: an agent; a model runtime; a compiler; a code generator; a Jira replacement; a docs portal; a full formal language; a complete SDLC platform; a guarantee that agent output is correct.

Promise: better inputs for agents, cleaner task setup, less manual worktree management, more useful review summaries, durable findings. Do not promise: deterministic generation, automatic correctness, formal verification, PR-review obsolescence, compilation from specs.

# 2. Market research synthesis (Swarm responses)

- Spec Kit: market validated; avoid its failure modes — README clarity, enterprise platform needs, illusion-of-work. Response: do fewer things, create fewer files, make every file useful, every command a clear state transition, center review evidence over planning prose.
- GitHub/GitLab issue templates: structured intake is mainstream. Response: don't invent a ticketing system; pull intake into a stable artifact keeping the upstream URL + timestamp.
- EARS / controlled NL: precedent for lightweight structured requirements — IDs, conditions, actors, expected behavior, verification notes; don't over-formalize.
- Ambiguity research: remove obvious ambiguity before the agent codes; not formal math.
- Clarification research: surface blocking questions early; a missing decision is a visible question, not an agent guess.
- PR research: agent summaries can be inconsistent with actual changes. Response: review packets compare claims against changed files, evidence, task scope.
- Refactoring research: refactors introduce bugs, especially tangled ones. Response: Change Plan artifact for behavior-preserving/behavior-constrained transformations.
- Backstage/Docusaurus: Git-backed workspace canonical; portals optional; no versioned-docs complexity first.
- OpenAPI lesson: meet developers where they are; familiar formats; immediate visible value; let tooling grow around the files; multiple adoption paths.
- TLA+ lesson: don't present Swarm as formal proof; evidence + checklists, close to real work.
- Rust RFC lesson: clear "substantial change" threshold; lightweight markdown; informal pre-validation; explicit owners; transparent decision history.
- Codemod/migration lesson: change plans need before/after, bridge releases, waves, rollback, cutover, preservation communication.
- Hyrum's Law: a refactor that changes observable behavior is not a pure refactor; change plans list preservation guarantees + cutover conditions.
- Agent-research lesson: tools > focused skills > broad personas; reduce persona importance; small practical skills; build checks around files.

# 3. Core thesis

> **Coding agents increase code volume. Swarm reduces the coordination and review cost of that volume.**

Upstream tools capture intent → Swarm normalizes intent into specs and change plans → bounded task packets → existing agents do the work → Swarm prepares review evidence → humans inspect exceptions → durable findings are saved.

# 4. Core workflow

Full loop: Pull → Inventory → Spec → Change Plan → Task → Run → Review → Close, with per-step outputs (intake snapshot / inventory / spec / change plan / task / code changes / review / finding+status+ledger). Not every workflow needs every step (flows as in §0).

# 5. Artifact model

Core: Intake (source snapshot), Inventory (reconstruction; core for brownfield), Spec (intent), Change Plan (planned transformation), Task (scoped execution), Review (evaluation), Finding (durable learning), Status (state).
Advanced: bug report, audit, ADR, research, PRD, RFC, threat model, release note.
Minimal set for a small team: spec/task/review/finding/status; brownfield adds inventory + change-plan; enterprise adds intake/bug/audit/ADR/research/ledger. Do not make all artifacts mandatory; the workflow must scale down to ~5 files.

# 6. File naming and extension policy

Use plain `.md` everywhere (spec.md, task.md, review.md, finding.md, change-plan.md, inventory.md, audit.md, bug.md, adr.md, research.md). Do NOT use `*.swarm.md`, `*.swarm.ir.json`, `*.swarm.plan.json`, `*.swarm.trace.md` unless a future tool proves clear value. Frontmatter `type:` is the artifact discriminator. Naming: folder-per-artifact with NNN- prefixes recommended (specs/001-auth-refresh/spec.md, change-plans/001-auth-refactor/change-plan.md, ...) or flat files for small projects; both valid.

# 7. Structured requirements / SOL

SOL = a lightweight structured requirement notation, not a language. User docs say "structured requirements"; SOL in reference/tooling docs. Default friendly form: `### AC-001 — title` + "When X, the component must Y." + `Verify with: ...`. Optional structured block: REQ/WHEN/THE/MUST/AND THE/VERIFY BY. Both acceptable. Keep: stable IDs, requirement labels, conditions/triggers, actors, expected behavior, open questions, verification notes, affected-area references. Demote: block-count numerology, proof-type matrix, verdict taxonomy, IR schemas, grammar formalism, lower/decompose terminology. Remove closed-set counts from front-door docs. Lint codes are checklists until a linter exists ("review checklist item; a future linter should flag this; teams may treat as blocking by policy").

# 8. Spec

Purpose: desired behavior — what/who/scope/out-of-scope/how-verified/open questions. Not a task, design brainstorm, change plan, review, PR description, audit, or bug report. When to write: behavior/user-visible/API/business-rule changes, shared acceptance criteria, bug revealing missing expected behavior. Not for trivial renames, formatting, covered one-liners, housekeeping.
Template: frontmatter (type: spec, id: SPEC-AUTH-001, title, status, owner, sources incl. JIRA + ADR refs) + Intent / Non-goals / Requirements (### AC-NNN + Verify with:) / Open questions / Affected areas.
Checker: hard errors — missing ID, duplicate ID, missing owner, broken source link, approved spec with unresolved blocking question, requirement without verification note. Warnings — vague words, missing non-goals, missing affected areas, unlinked source, bundled behaviors, unclear actor, unclear outcome.

# 9. Inventory

Maps existing brownfield code before major change: what exists, module responsibilities, public/private interfaces, hidden dependencies, current test coverage, observed behaviors to preserve, risks for the change plan. Needed because brownfield change fails when nobody reconstructs the current contract: specs describe desired behavior, audits observe problems, change plans define transformation, **inventory maps the terrain**. Write before: major refactor, rewrite, migration, module split, subsystem replacement, wide dependency upgrade, unfamiliar brownfield agent tasks, high Hyrum-risk work. Not for simple features, small fixes, single-file cleanups, test-only updates.
Template sections: Scope / Current modules (table) / Current interfaces (table: interface, caller, behavior) / Observed behavior (table: behavior, evidence) / Known risks / Existing tests / Unknowns. Frontmatter: type: inventory, id: INV-*, title, status, owner, sources (code:/tests: paths), created. Inventory feeds Change Plan.

# 10. Change Plan

Defines an intended codebase transformation: what structure changes, why, what behavior must be preserved vs may change, in/out of scope, reviewer risk focus, verification plan, task split. A spec says what behavior should exist; a change plan says how the codebase should change while preserving/modifying/migrating behavior. Write when work is primarily internal structure, multi-module, risky-but-preserving, public-interface-changing, needs sequencing, splits across agents, or yields a large/hard-to-interpret diff. Not for small cleanups, tiny renames, formatting, obvious bug fixes.
Kinds: refactor, rewrite, migration, dependency-upgrade, performance, test-infra, mechanical-cleanup, architecture-cleanup, schema-change.
Required sections: baseline; target state; behavioral preservation guarantees (table: ID, behavior/constraint, verification); transformation waves; rollback criteria; cutover conditions; verification strategy; review focus; task split. Frontmatter: type: change-plan, id: CHANGE-*, title, status, kind, owner, sources (inventory/audit/spec), preserves (SPEC-*#AC-* refs), created. Plus Intent / Why / Non-goals / Affected surfaces (table: surface, intended change) / Risk areas.
Spec vs Change Plan: spec answers "what should the system do"; change plan answers "how should the codebase change"; change plan usually preserves behavior; main readers are developer/reviewer/tech lead.

# 11. Task

Bounded work packet. Frontmatter: type: task, id: TASK-*, source: [SPEC-*, CHANGE-*], scope: [SPEC-*#AC-*...], status. Sections: Source (spec and/or change plan) / Scope (implement or preserve) / Do not change / Affected areas / Verify (checklist) / Agent instructions (read sources first; only this scope; leave summary of changed files, tests run, findings) / Findings.

# 12. Review

Turns agent output into evidence + human-attention items: what changed, mapping to spec/change-plan/task, satisfied vs unverified requirements, out-of-scope changes, what a human inspects, findings to save.
Template adds (vs spec-only): **Change-plan coverage** table (item, status, evidence, human attention) alongside Requirement coverage. Statuses: pass / fail / unverified / blocked / needs-human — keep simple, no complicated verdict taxonomy up front. Review-by-exception is the main wedge: surface unverified/failed requirements, unauthorized changes, risky files, missing test output, changed public interfaces, DB migrations, security-sensitive changes, new findings, blocked questions. Goal: make large agent PRs reviewable by exception.

# 13. Finding

Durable knowledge: Claim / Evidence / Applies when / Does not apply when / Future guidance. Frontmatter: type, id FINDING-*, title, status, source (task/review ids), related (SPEC-*#AC-*).

# 14. Status

Status file/dashboard: specs (status, open questions, active tasks), tasks (status, agent, review), human attention list (blocking questions, missing review packets, findings pending acceptance).

# 15. Workspace model

Minimal (two-person): project/ with .agents/AGENTS.md, specs/001-feature/spec.md, tasks/, reviews/, findings/, decisions/. Copyable in five minutes. Brownfield adds inventory/, change-plans/, audits/. Enterprise: external Git-backed swarm-workspace/ with intake/{jira,notion,github,linear}/, specs/, inventory/, change-plans/, tasks/, reviews/, findings/, audits/, bugs/, decisions/, status.md, templates/.
Code repo local state: app-repo/AGENTS.md + `.swarm/` (config.yaml; work/{tasks,reviews}; cache/; tmp/). Config example: knowledge {type: git, path: ../swarm-workspace, default_branch}, project {id, code_repo}, agents {default, available list}.
External workspace by default for enterprise (multi-repo specs; non-engineering stakeholders; deduplicated findings; code repos stay focused; central search/status/history). Small teams may co-locate — an allowed simplification, not the enterprise default.

# 16. AGENTS.md

Keep short; hard caps are too authoritarian — soft cap "keep under 100 lines unless the team has a documented reason." Minimal content: Swarm startup (read task first, follow scope, check linked specs/change plans, no unassigned behavior, record checks actually run, leave review notes + findings); local workspace pointer (.swarm/work/ + config); agent role ("Swarm organizes the work; you perform only the assigned task").

# 17–18. CLI model and command behavior

Initial command set: init, pull, spec new, spec check, inventory new, change new, task new, worktree create, run, review, status, close. Defer: compile, lower, decompose, graph, conformance, promote, trace validate. Every command must answer: what does it read? what does it write? does it run an agent? what state changes? what should the user do next? Per-command contracts specified (reads/writes/does-not) for init, pull (intake/jira/JIRA-123.md; never auto-spec), spec new (--from intake; --agent drafts via external CLI), spec check (gaps; optional report), inventory new, change new, task new, worktree create, run (launches external agent; never becomes it; no correctness guarantee), review (drafts packet; agent fill stays a draft), status, close (findings prompt; status update; cleanup; optional ledger entry).

# 19. Example flows

Feature / refactor / bug / brownfield-rewrite command sequences (pull → spec/inventory/change → task → worktree → run → review → close), each naming --agent adapters (claude, codex, opencode).

# 20. Minimal viable Swarm

Four-five files to start; minimal starter kit = AGENTS.md + templates/{spec,task,review,finding,inventory,change-plan}.md + README. Full kit (audits, bugs, ADRs, research, memory, advanced checks, SOL reference, review stances, more skills) must not be the default first experience.

# 21. Honesty Framework

If no CLI/linter/runtime exists, docs must not imply automated enforcement. Any page using MUST/BLOCKING/lint/error/fail/gate/required indicates the rule's level:
| Level | Meaning |
|---|---|
| convention | humans/agents are expected to follow it |
| checklist | review should inspect it |
| toolable | future or optional tool can check it |
| enforced | a current shipped tool enforces it |
Use: "This is a convention in the markdown-only framework. No automated enforcement ships in this repository." / "A future `swarm check` command should flag this. Until then, treat it as a review checklist item." Avoid "this fails lint / blocks merge / is enforced" unless a tool actually enforces it.

# 22. Remove / demote / keep

Remove from front-door docs: compiler analogy; `.swarm.md` extension; closed-set counts; "language" overclaiming; proof-type taxonomy; verdict taxonomy; IR schemas; lower/decompose as user-facing steps; hard AGENTS caps; unenforced-enforcement claims.
Demote to advanced reference: structured requirement block details; future lint codes; pass model; conformance corpus; JSON schemas; proof/evidence categories; extended source-authority rules; advanced skill guides.
Keep central: spec; inventory; change plan; task; review; finding; status; pull from upstream; external agent runners; worktree quality-of-life.

# 23. What to build first

Docs milestone: README, basic-workflow, writing-specs, writing-change-plans, creating-tasks, reviewing-output, honesty-framework, starter-kit/minimal. CLI milestone 1 (no agents required): init, pull, spec new, spec check, task new, review, status. Milestone 2: inventory new, change new, worktree create, run --agent, close. Defer: full linter, parser, LSP, GUI, graph view, multi-agent scheduler, conformance suite, auto-merge, complex review AI.

# 24. Final framing

Product sentence + one-liner as §0. Main loop: Pull → Spec → Change Plan → Task → Run → Review → Close. Main artifacts: intake, inventory, spec, change-plan, task, review, finding, status. Main promise: less vague prompting, less manual worktree setup, less unreviewable output, less lost knowledge, better ticket→PR continuity. Main restraint: no compiler claims, no fake enforcement, no giant starter kit, no syntax worship, no agent runtime.

# 25. Final conclusion

The best Swarm makes this flow feel obvious: ticket → clear spec → (inventory if brownfield) → (change plan if structural) → task → agent run → prepared review → inspect the important parts → save what we learned. Missing concepts now supplied: Inventory, Change Plan, Honesty Framework, minimal starter kit, review-by-exception. A practical, low-astrology workflow layer around coding agents — not a compiler, not a formal language fantasy.
