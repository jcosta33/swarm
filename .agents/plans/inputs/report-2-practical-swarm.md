---
title: "Audit: Current Swarm Docs vs. Desired Practical Swarm"
status: "draft"
scope: "Documentation/product-shape audit"
date: "2026-06-09"
---

# Audit: Current Swarm Docs vs. Desired Practical Swarm

## 0. Purpose

This audit compares the current Swarm documentation shape against the simpler, less cluttered, more practical state Swarm should move toward.

The goal is not to criticize the ambition. The goal is to identify what currently creates adoption friction, conceptual overload, or product confusion, and then define a cleaner target state.

The desired target is:

> Swarm helps teams turn tickets into clear specs, specs into agent-ready tasks, and agent output into reviewable evidence.

That is the useful product.

Not: "Swarm is a compiler." Not: "Swarm is a formal language ecosystem." Not: "Swarm is a complete methodology for all software engineering." Not: "Swarm is an agent runtime."

---

## 1. Scope note

This audit is based on the current public repository framing, visible top-level documentation, and the current direction discussed in the product/design conversation.

This is **not** a byte-for-byte audit of every file in the repository. A true file-by-file remediation pass should follow this audit and mechanically inspect every file excluding archived/legacy material.

The audit is still sufficient to identify the main product-shape problem:

> Swarm currently contains many good ideas, but the documentation presents them as a heavy framework with too many abstractions. The next state should preserve the useful workflow while reducing theory, vocabulary, and ceremony.

---

# 2. Current state summary

## 2.1 What Swarm currently claims to be

Current public framing says, in effect:

- Swarm is a way to write software specs that AI agents can build from reliably.
- Specs are written in controlled Markdown.
- The spec is the source of truth, not the code.
- Agents implement from specs and prove they met them.
- Swarm is markdown-only and ships no runtime.
- The flow is nine steps: author; lint; improve; lower; decompose; implement; verify; review; promote.
- SOL is presented as the Swarm Obligation Language.
- Specs live in a spec/documentation repo.
- Code repos stay mostly pristine.
- The repository includes docs, starter kit, language references, model docs, passes, artifacts, library, examples, research, reference pages, and ADRs.

## 2.2 Current top-level documentation shape

The current docs tree is broad: language; model; passes; artifacts; library; reference; research; examples; ADRs; adoption; principles; non-goals; positioning.

This is coherent from a design-theory perspective, but heavy from an adoption perspective.

A newcomer is confronted with: a language; a prose standard; many pass names; many artifact names; a proof/verdict model; a starter kit; skills; rule cards; conformance concepts; references; ADRs; research; no runtime; possible future tooling contracts.

That is a lot.

## 2.3 Current strengths

### Strength 1 — Markdown-only, provider-neutral

This is good. It prevents lock-in and makes the framework adaptable. Keep it.

### Strength 2 — Specs as durable implementation contracts

This is good, but needs softer framing. "Spec is the source of intent" is better than "spec is the source of truth." Code is still implementation reality.

### Strength 3 — Structured requirements

The idea of requiring stable IDs, clearer acceptance criteria, and verification notes is practical. Keep it.

### Strength 4 — Review by exception

This is the strongest product wedge. If Swarm can help reviewers inspect failed, unverified, risky, or unauthorized changes instead of reading giant diffs blindly, it has real value. Keep it and make it central.

### Strength 5 — No runtime in the docs repo

This is good. The markdown repo should define the framework, not ship the CLI. Keep the boundary.

### Strength 6 — External spec/docs repo direction

The idea that specs can live outside code repos is strong, especially for enterprise use. Keep it, but explain it more practically.

### Strength 7 — Agent-neutrality

Swarm should organize work around existing agent tools, not replace them. Keep it.

---

# 3. Primary diagnosis

The current Swarm docs over-index on the internal design model and under-index on the developer's actual workflow.

The user does not first need to learn: SOL; APS; closed sets; proof types; verdict types; nine passes; obligation graphs; lowering; decompose; conformance; no-runtime invariant; starter-kit topology; source authority; promotion protocol; memory model; skill/pass-guide distinctions.

The user first needs to understand:

1. I have a ticket.
2. I want an agent to work on it.
3. I need a clearer spec.
4. I need a task file.
5. I need a safe branch/worktree.
6. I need to review the output.
7. I need to save what matters.

That is Swarm. Everything else should be progressive disclosure.

---

# 4. Main product-shape problem

Swarm currently feels like three products at once:

## 4.1 A documentation/spec methodology

How to write specs, audits, bug reports, findings; how to promote durable knowledge. This is useful.

## 4.2 A speculative language/toolchain design

SOL; APS; closed sets; proof types; verdicts; structured forms; conformance; future linter/planner/checker contracts. This is useful only if kept lightweight and tool-driven.

## 4.3 An agent-workflow scaffolding system

Skills/pass guides; task templates; starter kit; agent bootloader; future CLI/worktree flow. This is useful, but should be the practical center.

The issue is not that these pieces are incompatible. The issue is that the docs currently make them feel equally important. They are not equally important.

The priority should be:

1. practical workflow;
2. spec/task/review templates;
3. lightweight checks;
4. integrations;
5. advanced language/reference material.

---

# 5. Severity-ranked findings

## P0 — Product identity is too abstract

### Current state

Swarm is described in terms of controlled Markdown, SOL obligations, proof, nine passes, and spec-as-source.

### Why it matters

Developers and enterprise teams do not adopt "a specification compiler framework." They adopt tools that reduce pain. The pain is: vague tickets; repeated context-pasting; agent drift; branch/worktree mess; giant PRs; unclear review responsibility; lost findings.

### Recommended state

Lead with:

> Swarm is a spec and review workflow for teams using coding agents.

Use the concrete value proposition:

> Turn tickets into clear specs, specs into agent-ready tasks, and agent output into reviewable evidence.

### Remediation

Rewrite README opening to avoid: compiler-like framing; "agents build reliably" overclaiming; excessive SOL emphasis; spec-as-source absolutism.

Use:

~~~markdown
# Swarm

Swarm is a lightweight spec and review workflow for teams using coding agents.

It helps you:
- pull work from Jira, Notion, Linear, GitHub, or a PRD;
- turn it into a clear spec;
- create a bounded task for an agent;
- run that task in a clean worktree;
- review the output by evidence and exceptions;
- save durable findings for next time.

Swarm is not an agent. It organizes the work around agents.
~~~

---

## P0 — Compiler metaphor should be removed from user-facing docs

### Current state

The current docs are heavily shaped by compiler concepts: passes; lowering; decompose; structured form; proof runner; planner; checker; conformance; closed sets.

The README already avoids shipping runtime, but the conceptual model still feels like a compiler.

### Why it matters

The compiler analogy is useful internally, but misleading externally. A compiler deterministically transforms source into output every time. Swarm does not and cannot do that with agentic coding. If the public docs lean into compiler language, serious users will see it as overclaiming.

### Recommended state

Use plain workflow terms:

| Current term | Better user-facing term |
|---|---|
| pass | step |
| lower | prepare tasks |
| decompose | split work |
| obligation graph | requirement list / requirement map |
| proof type | verification method |
| verdict | review result |
| conformance | checks |
| IR | internal structured form |
| compiler | workflow / toolchain / workspace |

Keep compiler terms in advanced reference only.

### Remediation

- Remove "compiler" from README and adoption docs.
- Keep "compiler analogy" only in an ADR or advanced design note.
- Rename pass pages in user docs to workflow steps.
- Keep internal names if useful, but do not foreground them.

---

## P0 — The nine-step flow is too much for first contact

### Current state

The documented flow is:

~~~text
author → lint → improve → lower → decompose → implement → verify → review → promote
~~~

### Why it matters

This is conceptually sound but intimidating. A new user needs a smaller loop.

### Recommended state

Present the user loop as:

~~~text
Pull → Spec → Task → Run → Review → Close
~~~

Where: Pull = bring in ticket/PRD/issue context; Spec = write/check spec; Task = create bounded agent task; Run = run existing agent CLI; Review = summarize output and evidence; Close = save findings/status.

The nine-step model can remain as the advanced lifecycle.

### Remediation

README should show:

~~~text
The basic Swarm loop:

1. Pull the work.
2. Write/check the spec.
3. Create a task.
4. Run an agent.
5. Review the result.
6. Save what matters.
~~~

Then advanced docs can map:

~~~text
Pull/Spec/Task/Run/Review/Close
  ↔ author/lint/improve/lower/decompose/implement/verify/review/promote
~~~

---

## P0 — SOL is too central in the first impression

### Current state

SOL is central in the README and reference structure. The docs emphasize: seven block types; five modals; nine proof types; seven verdicts; exact closed sets.

### Why it matters

The current SOL framing can make Swarm feel like a language people must learn before getting any benefit. That is adoption friction.

### Recommended state

Present SOL as an optional structured requirement format, not as the product center.

The user-facing promise should be:

> Use clear, checkable requirements with IDs and verification notes.

Then show a simple example.

### Example target

~~~markdown
### AC-001 — Expired refresh token redirects to login

When the refresh token is expired, the client must clear the local session and redirect to `/login`.

Verify with: `auth-refresh-expired-token.test`
~~~

Advanced equivalent:

~~~text
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
AND THE client MUST redirect to `/login`
VERIFY BY test:cmdTest:auth-refresh-expired-token
~~~

The second form can remain valid, but it should not be the only approachable path.

### Remediation

Split language docs into:

1. `docs/specs/writing-specs.md` — practical;
2. `docs/reference/SOL.md` — exact formal-ish syntax;
3. `docs/reference/checks.md` — lint rules.

---

## P0 — "Spec is source of truth" is too strong

### Current state

The docs say the spec is the source of truth, not code.

### Why it matters

This is directionally useful but philosophically brittle. In real engineering: spec owns desired intent; code owns implementation reality; tests/CI show evidence; production behavior may falsify assumptions; tickets/PRDs/ADRs may supersede specs; reviews decide merge readiness.

Saying "spec is the source of truth" can sound naive.

### Recommended state

Use:

> Specs are the source of intended behavior. Code is the implementation reality. Review and status connect the two.

### Remediation

Replace broad "spec is source of truth" phrasing with:

~~~text
The spec is the source of intended behavior.
The code is the current implementation.
Swarm helps keep the two connected through tasks, review evidence, and findings.
~~~

---

## P0 — Current docs are too cluttered for the next product direction

### Current state

The docs include many categories: language; model; passes; artifacts; library; reference; research; examples; ADRs; adoption; principles; non-goals.

### Why it matters

A rich internal doc set is fine, but it should not be the user's path. The current structure makes Swarm feel bigger than the problem.

### Recommended state

Make a smaller public information architecture:

~~~text
docs/
  01-what-is-swarm.md
  02-basic-workflow.md
  03-writing-specs.md
  04-creating-tasks.md
  05-reviewing-agent-output.md
  06-saving-findings.md
  07-integrations.md

  reference/
    checks.md
    sol.md
    artifact-formats.md
    glossary.md

  examples/
    feature-from-jira.md
    bug-fix.md
    large-pr-review.md

  decisions/
    ...
~~~

Everything else becomes advanced/internal.

### Remediation

Create a new "happy path" docs layer and demote advanced references.

---

# 6. P1 findings

## P1 — Adoption through "copy this prompt to your agent" is too indirect

### Current state

Adoption docs tell the user to hand a coding agent a prompt to adopt the framework.

### Why it matters

This may be clever, but it feels fragile. It also hides what files are actually installed and why.

### Recommended state

Until a CLI exists, keep the agent prompt as one option, but lead with a manual checklist:

~~~text
1. Copy `starter-kit/templates/spec.md`.
2. Copy `starter-kit/templates/task.md`.
3. Copy `starter-kit/templates/review.md`.
4. Copy `starter-kit/templates/finding.md`.
5. Add `AGENTS.md`.
6. Start with one feature.
~~~

Then provide:

~~~text
Optional: ask an agent to do these steps for you.
~~~

### Remediation

Rewrite adoption around: "manual adoption"; "agent-assisted adoption"; "future CLI adoption."

---

## P1 — Starter kit vs docs vs `.agents` is still conceptually confusing

### Current state

The repo currently says: docs are complete; starter-kit is copied; `.agents/` holds tooling; no `.swarm/`; spec repo holds intent; code repo remains mostly pristine.

This is close, but still not obvious.

### Why it matters

Users need to know exactly: what lives in a spec repo; what lives in a code repo; what is copied; what is not copied; what is optional; where specs live; where tasks live; where review packets live.

### Recommended state

Use three terms:

1. **Swarm Framework** — this repo;
2. **Swarm Workspace** — a user's spec/review store;
3. **Code Repo Adapter** — tiny local files for agent execution.

### Target model

~~~text
swarm/
  framework docs and starter kit

company-swarm/
  specs/
  tasks/
  reviews/
  findings/
  status/

app-repo/
  AGENTS.md
  .swarm/work/
~~~

If you do not want `.swarm/` at all, then say so clearly and use:

~~~text
app-repo/
  AGENTS.md
  swarm-task.md
~~~

But do not leave the model halfway.

### Remediation

Add a single page:

~~~text
docs/02-where-files-live.md
~~~

With explicit diagrams.

---

## P1 — Artifact taxonomy is too large

### Current state

Current docs include many artifact types: spec; task; trace; review; finding; ADR; audit; research; bug report; PRD; RFC; status; threat model; task orchestration; memory.

### Why it matters

This is good for reference, bad for first adoption. Most teams need only: spec; task; review; finding; status.

### Recommended state

Use two tiers.

#### Core artifacts

| Artifact | Purpose |
|---|---|
| spec | what should be built |
| task | what the agent should do |
| review | what changed and what needs human attention |
| finding | what we learned |
| status | what is open, blocked, or ready |

#### Advanced artifacts

| Artifact | Purpose |
|---|---|
| bug | structured defect intake |
| audit | structured inspection |
| ADR | durable decision |
| research | evidence collection |
| PRD/RFC | upstream source |

### Remediation

Move advanced artifacts out of the first path.

---

## P1 — Review should be the central wedge, not SOL

### Current state

Current docs strongly center specs and obligations.

### Why it matters

The actual user pain is not only writing specs. It is reviewing large agent output. The strongest adoption hook is:

> Swarm makes giant agent PRs easier to review.

### Recommended state

Make review packets first-class in README and examples.

Show:

~~~markdown
## Human attention

| Item | Why it matters | Action |
|---|---|---|
| AC-002 unverified | no test output found | block |
| retry logic changed | high-risk file | inspect |
| new provider behavior found | durable knowledge | save finding |
~~~

### Remediation

Add a canonical example:

~~~text
docs/examples/large-pr-review.md
~~~

Make it the main demo.

---

## P1 — Language references are too mathematically framed

### Current state

Reference pages include closed sets, canonical counts, acceptance checks, proof types, verdict models, etc.

### Why it matters

This reads like a formal methods project rather than practical tooling. It may be useful internally, but it should not be visible early.

### Recommended state

Rename "canonical counts" to "Reference values."

Tone down the language: "Swarm accepts these values" instead of "closed set." "Review result" instead of "verdict model." "Verification method" instead of "proof type." "Check" instead of "conformance."

### Remediation

Rewrite cheat sheet as:

~~~markdown
# Swarm Reference

## Requirement labels
...

## Review statuses
...

## Verification methods
...

## File types
...
~~~

---

## P1 — Future-tool contracts are too prominent

### Current state

The docs repeatedly say parser, linter, planner, checker, CLI, LSP are future tool contracts.

### Why it matters

This creates the impression of a big unbuilt system. Users ask: "What does it actually do today?"

### Recommended state

Separate current from future.

Use:

~~~text
Works today:
  templates, specs, tasks, review packets, findings

Future CLI could automate:
  pull, check, task creation, worktree, review summary
~~~

### Remediation

Every page should carry either: "usable today"; "future automation reference"; "advanced design note."

---

## P1 — Research layer is valuable but too visible

### Current state

Research is present as a top-level docs section.

### Why it matters

Research supports credibility but can overwhelm.

### Recommended state

Keep research, but make it secondary. Use it for: evidence appendix; rationale for advanced users; citations for claims. Do not make it part of the adoption journey.

### Remediation

Move `docs/research/` under:

~~~text
docs/reference/evidence/
~~~

or leave it as-is but remove it from primary navigation.

---

## P1 — "Agents do the work" needs sharper boundaries

### Current state

Docs say agents build from specs.

### Why it matters

Swarm is not an agent. It should be precise about what happens: Swarm writes or stores task files. Existing agent tools read them. The agent edits code. Swarm-style review summarizes results.

### Recommended state

Use:

~~~text
Swarm organizes the work.
Your agent tool does the coding.
~~~

### Remediation

Add to README:

~~~markdown
Swarm is not an agent runtime. It works with Claude Code, Codex, OpenCode, Aider, Cursor, or a human developer by giving them clearer tasks and review expectations.
~~~

---

# 7. P2 findings

## P2 — ADR count and decision history may overwhelm public readers

Keep ADRs, but make them clearly advanced. Add: "Most users do not need to read ADRs. They document why Swarm is shaped this way."

## P2 — Examples should be fewer and more complete

Have exactly three flagship examples: 1. feature from Jira; 2. bug fix; 3. large PR review.

Each should show: input; spec; task; agent output summary; review packet; finding/status.

## P2 — Naming should be simplified

### Current names to soften

| Current | Suggested |
|---|---|
| SOL | structured requirements / SOL reference |
| APS | writing rules / spec hygiene |
| pass guide | agent guide |
| heuristic profile | review stance / role |
| proof | evidence |
| verdict | review result |
| promote | save finding |
| obligation | requirement / acceptance criterion |
| conformance | checks |

Keep exact terms in reference docs only.

---

# 8. What to keep

The following parts should remain central.

## 8.1 External spec/docs repo — Keep. Useful for enterprise and multi-repo teams.
## 8.2 Markdown-first files — Keep. Readable, diffable, agent-friendly.
## 8.3 Lightweight structured requirements — Keep. IDs, requirements, non-goals, questions, verification notes are real improvements.
## 8.4 Task packets — Keep. They reduce prompt ambiguity and let agents work with bounded scope.
## 8.5 Review packets — Keep and emphasize. This is the strongest productivity feature.
## 8.6 Findings — Keep. They prevent repeated learning loss.
## 8.7 No-runtime boundary in docs repo — Keep. The framework repo should not pretend to ship tools.
## 8.8 Agent neutrality — Keep. Swarm should work with any coding agent or human developer.

---

# 9. What to demote

The following should remain but move deeper into reference/advanced docs.

## 9.1 SOL as formal language — Demote to reference. User docs should say "structured requirements."
## 9.2 APS — Demote to "writing rules" or "spec hygiene."
## 9.3 Closed sets and cardinalities — Demote to reference.
## 9.4 Proof adapter matrix — Demote to reference. User docs should say "evidence."
## 9.5 Nine-pass flow — Demote to advanced lifecycle. User docs should use six-step workflow.
## 9.6 Conformance — Demote to validation checks.
## 9.7 IR/structured form — Hide unless tooling is being implemented.

---

# 10. What to cut from the main path

Cut or remove from first-contact docs:

- compiler analogy;
- spec-as-source absolutism;
- excessive proof/verdict taxonomy;
- too many artifact types;
- heavy "closed set" phrasing;
- conformance language;
- future-tool contract density;
- "agents build reliably" overclaiming;
- any suggestion that syntax itself is the main breakthrough.

---

# 11. Target product definition

## 11.1 One-liner

> Swarm helps teams turn tickets into clear specs, specs into agent-ready tasks, and agent output into reviewable evidence.

## 11.2 Slightly longer

> Swarm is a lightweight spec and review workflow for teams using coding agents. It gives you templates, writing rules, task packets, review packets, and findings so agent work is easier to start, safer to review, and less likely to lose context.

## 11.3 What Swarm is

- a spec workflow;
- a task-packet format;
- a review-packet format;
- a findings/memory pattern;
- an external knowledge-store convention;
- a starter kit for teams using coding agents;
- a future CLI target.

## 11.4 What Swarm is not

- an agent runtime;
- a compiler;
- a programming language;
- a Jira replacement;
- a code generator;
- a PR replacement;
- a full documentation portal;
- a formal verification system.

---

# 12. Target workflow

## 12.1 Basic workflow

~~~text
Pull → Spec → Task → Run → Review → Close
~~~

## 12.2 What each step means

| Step | Meaning | Output |
|---|---|---|
| Pull | Capture upstream work from Jira/Notion/GitHub/PRD | intake snapshot |
| Spec | Write/check intended behavior | spec |
| Task | Create a bounded agent work packet | task |
| Run | Hand task to an external coding agent | branch/worktree/code changes |
| Review | Summarize evidence and human attention | review packet |
| Close | Save findings and update status | finding/status/ledger |

## 12.3 Advanced mapping

| Basic step | Advanced Swarm lifecycle |
|---|---|
| Pull | author source artifact |
| Spec | author/lint/improve |
| Task | prepare/split work |
| Run | implement/verify |
| Review | review |
| Close | promote/status |

---

# 13. Target docs structure

## 13.1 Recommended tree

~~~text
docs/
  01-what-is-swarm.md
  02-basic-workflow.md
  03-where-files-live.md
  04-writing-specs.md
  05-creating-tasks.md
  06-running-agents.md
  07-reviewing-output.md
  08-saving-findings.md
  09-integrations.md

  reference/
    structured-requirements.md
    checks.md
    artifact-formats.md
    glossary.md
    future-cli.md

  examples/
    feature-from-jira.md
    bug-fix.md
    large-pr-review.md

  decisions/
    README.md
    ...
~~~

## 13.2 What leaves the main docs

Move these to advanced/reference: full SOL grammar; full APS; proof types; closed sets; conformance; pass internals; research citations; IR schemas; exhaustive artifact catalogue.

---

# 14. Target starter kit

The starter kit should be small.

## 14.1 Core starter kit

~~~text
starter-kit/
  README.md

  templates/
    spec.md
    task.md
    review.md
    finding.md
    status.md

  agent/
    AGENTS.md
    implement-task.md
    review-output.md

  examples/
    feature-from-ticket/
      ticket.md
      spec.md
      task.md
      review.md
      finding.md
~~~

## 14.2 Advanced starter kit

Optional:

~~~text
starter-kit/advanced/
  audit.md
  bug.md
  research.md
  adr.md
  rfc.md
  prd.md
  sol-reference.md
  checks-reference.md
~~~

## 14.3 Why this is better

It lets users start with: spec; task; review; finding. That is enough.

---

# 15. Target artifact model

## 15.1 Core artifacts

| Artifact | Purpose | Required? |
|---|---|---|
| Intake | Snapshot of upstream work | yes for external tools |
| Spec | Intended behavior | yes |
| Task | Agent work packet | yes |
| Review | Review summary and human-attention list | yes |
| Finding | Durable lesson learned | optional |
| Status | Current state summary | optional initially |

## 15.2 Advanced artifacts

| Artifact | Purpose |
|---|---|
| Bug | Structured defect evidence |
| Audit | Structured inspection result |
| ADR | Durable architectural decision |
| Research | Evidence and options |
| PRD/RFC | Upstream product/technical proposal |

---

# 16. Target spec format

The default spec should be readable without knowing SOL.

~~~markdown
---
id: SPEC-AUTH-001
title: Auth refresh behavior
status: draft
owner: auth-team
sources:
  - JIRA-123
---

# Auth refresh behavior

## Intent

Users with expired sessions are redirected to login without retry loops.

## Non-goals

- Do not change signup.
- Do not change server token issuance.

## Requirements

### AC-001 — Expired refresh token redirects to login

When the refresh token is expired, the client must clear the local session and redirect to `/login`.

Verify with: `auth-refresh-expired-token.test`

### AC-002 — 401 does not retry forever

When the refresh endpoint returns 401, the client must not retry more than once.

Verify with: `auth-refresh-no-loop.test`

## Open questions

- None.

## Affected areas

- `src/auth/client.ts`
- `src/auth/session-store.ts`
- `tests/auth/`
~~~

## 16.1 Advanced SOL equivalent

~~~text
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
AND THE client MUST redirect to `/login`
VERIFY BY test:cmdTest:auth-refresh-expired-token
~~~

This should be available, but not required for understanding the product.

---

# 17. Target task format

~~~markdown
---
id: TASK-AUTH-001
spec: SPEC-AUTH-001
scope:
  - AC-001
  - AC-002
status: ready
---

# Task: Implement auth refresh client behavior

## Source

Spec: `SPEC-AUTH-001`

## Scope

Implement:

- AC-001: expired refresh token redirects to login;
- AC-002: 401 does not retry forever.

## Do not change

- signup;
- server token issuance;
- billing;
- profile editing.

## Affected areas

- `src/auth/client.ts`
- `src/auth/session-store.ts`
- `tests/auth/`

## Verify

- [ ] `auth-refresh-expired-token.test`
- [ ] `auth-refresh-no-loop.test`

## Agent instructions

Read the source spec first.
Implement only this task scope.
Leave a summary of changed files, tests run, and any findings.
~~~

---

# 18. Target review format

~~~markdown
---
id: REVIEW-AUTH-001
task: TASK-AUTH-001
status: blocked
---

# Review: Auth refresh client

## Summary

The task implements AC-001 but AC-002 is not verified.

## Changed files

- `src/auth/client.ts`
- `src/auth/session-store.ts`
- `tests/auth/auth-refresh.test.ts`

## Requirement coverage

| ID | Status | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass | `auth-refresh-expired-token.test` output present | no |
| AC-002 | Unverified | no test output found | yes |

## Human attention

1. AC-002 has no pasted test output.
2. Retry counter logic changed in `src/auth/client.ts`.
3. New finding candidate: 401 appears to invalidate token family.

## Suggested decision

Block until AC-002 is verified.
~~~

This is practical and powerful.

---

# 19. Target command model for future CLI

## 19.1 Core commands

~~~text
swarm init
swarm pull
swarm spec new
swarm spec check
swarm task new
swarm worktree create
swarm run
swarm review
swarm status
swarm close
~~~

## 19.2 What each command means

| Command | Meaning |
|---|---|
| `swarm init` | Create/link Swarm workspace |
| `swarm pull` | Snapshot Jira/Notion/GitHub/Linear input |
| `swarm spec new` | Create spec from intake |
| `swarm spec check` | Check spec for obvious gaps |
| `swarm task new` | Create bounded task packet |
| `swarm worktree create` | Create branch/worktree for task |
| `swarm run` | Launch external agent CLI with task |
| `swarm review` | Prepare review packet and human-attention list |
| `swarm status` | Show open specs/tasks/reviews/findings |
| `swarm close` | Save findings and close task |

## 19.3 Commands to defer

Defer: `swarm lower`; `swarm decompose`; `swarm graph`; `swarm conformance`; `swarm compile`; `swarm promote`; `swarm trace validate`.

These may exist later, but they should not be the first product surface.

---

# 20. Target repo/product packaging

## 20.1 Repos

Start with:

~~~text
jcosta33/swarm
  framework, docs, starter kit, examples

jcosta33/swarm-cli
  future practical CLI
~~~

Later optional: swarm-integrations, swarm-vscode, swarm-app. Do not split too early.

## 20.2 Product pieces

| Piece | Role |
|---|---|
| Swarm Framework | defines templates, docs, writing rules, workflow |
| Swarm CLI | automates pull/spec/task/worktree/run/review/close |
| Swarm Workspace | user's external spec/review/finding store |
| Agent adapters | thin wrappers for Claude Code, Codex, OpenCode, Aider, Cursor |
| Optional app | dashboard for active tasks/reviews |

---

# 21. Ideal external workspace

## 21.1 Practical default

~~~text
swarm-workspace/
  README.md

  intake/
    jira/
    notion/
    github/

  specs/
    auth-refresh.md
    checkout-payment.md

  tasks/
    auth-refresh-client.md

  reviews/
    auth-refresh-client.md

  findings/
    auth-refresh-401-token-family.md

  status.md

  templates/
    spec.md
    task.md
    review.md
    finding.md
~~~

## 21.2 Enterprise expansion

~~~text
swarm-workspace/
  intake/
  specs/
  tasks/
  reviews/
  findings/
  audits/
  bugs/
  adrs/
  research/
  memory/
  status/
  archive/
~~~

The simple version should be the default.

---

# 22. Migration plan from current docs to ideal docs

## Phase 1 — Reframe README

Replace current top-level framing with: lightweight spec and review workflow; practical developer loop; no compiler/product overclaiming; simple diagram; one concrete example.

## Phase 2 — Add a new happy path

Create:

~~~text
docs/02-basic-workflow.md
docs/examples/feature-from-jira.md
docs/examples/large-pr-review.md
~~~

## Phase 3 — Split user docs from reference docs

Move heavy concepts into reference:

~~~text
docs/reference/sol.md
docs/reference/checks.md
docs/reference/artifact-formats.md
~~~

## Phase 4 — Simplify starter kit

Create a minimal starter kit:

~~~text
templates/spec.md
templates/task.md
templates/review.md
templates/finding.md
~~~

Mark advanced templates as optional.

## Phase 5 — Rename or soften terminology

Rewrite user-facing docs using: requirement, not obligation; evidence, not proof; review result, not verdict; step, not pass; split work, not decompose; prepare task, not lower.

## Phase 6 — Create "future CLI" page

Document the CLI as future quality-of-life tooling: pull, spec, task, worktree, run, review, status, close. Explain exactly what each command reads/writes.

## Phase 7 — Archive or demote advanced material

Keep ADRs, research, proof matrices, conformance, and closed sets, but move them out of first-contact docs.

---

# 23. Acceptance criteria for the less cluttered state

Swarm has reached the desired state when a newcomer can answer these in under 10 minutes:

1. What is Swarm?
2. What problem does it solve?
3. Where do specs live?
4. What is a spec?
5. What is a task packet?
6. How does an agent use the task?
7. What does a review packet show?
8. What gets saved after the task?
9. What is optional/advanced?
10. What does Swarm not do?

And the answers should be:

1. A lightweight spec and review workflow for coding agents.
2. It reduces vague prompts, worktree mess, huge-review pain, and lost findings.
3. In a Swarm workspace/spec repo, usually outside code repos.
4. A clear implementation contract with requirements and verification notes.
5. A bounded work file for an agent or developer.
6. Existing agent tools read it and edit code.
7. Requirement coverage, evidence, risks, and human attention.
8. Findings, status, and review outcome.
9. SOL formal syntax, advanced artifacts, audit/research/ADR, conformance.
10. It is not an agent runtime, compiler, or code generator.

---

# 24. Recommended immediate edits

## 24.1 README

Rewrite around: What Swarm is / The problem / The basic workflow / Example / Where files live / What Swarm is not / Next steps.

## 24.2 ADOPTING.md

Rewrite around: Manual adoption / Agent-assisted adoption / Future CLI adoption / Spec repo vs code repo / Minimal starter kit.

## 24.3 PRINCIPLES.md

Keep principles, but reduce absolutist language. Replace "the single object every principle turns on is obligations" with "Swarm centers on clear requirements, bounded tasks, review evidence, and durable findings."

## 24.4 NON-GOALS.md

Keep no-runtime boundaries, but make it simpler.

## 24.5 Cheatsheet

Rewrite as practical reference. Current closed-set reconciliation can remain in an advanced appendix.

## 24.6 Starter kit

Simplify to core templates first.

---

# 25. Final recommendation

Swarm should become:

> A lightweight spec and review workflow for teams using coding agents.

The current docs are too internally rigorous and too externally heavy.

The less cluttered version should center:

~~~text
Pull → Spec → Task → Run → Review → Close
~~~

and the core artifacts:

~~~text
spec
task
review
finding
status
~~~

SOL survives as a structured requirement option and reference format, not as the public center.

The CLI, when built, should be a quality-of-life tool for: pulling tickets; creating/checking specs; creating tasks; managing worktrees; running external agent CLIs; preparing review summaries; closing work and saving findings.

The product promise should be practical:

> Swarm makes agent-assisted development easier to start, easier to review, and less likely to lose important context.

That is the coherent shape.
