# Swarm: Comprehensive Repository Report

This report synthesizes the entirety of the Swarm framework based on an exhaustive analysis of the repository's files (excluding internal `.agents` tooling). It details the core philosophy, workflows, workspace layout, roles and skills, review framework, and architectural decisions (ADRs) that define Swarm.

---

## 1. What is Swarm and Its Core Philosophy

**Swarm is a lightweight spec and review workflow for teams using coding agents.** It is shipped as plain markdown—docs, templates, and a starter kit—and operates entirely with **no runtime**.

### Core Philosophy
* **Generation Outpaces Validation:** Coding agents dramatically increase code volume but do not naturally increase the capacity to direct or validate it. Swarm shifts the investment to the validation side, ensuring that generated code is checked against strict requirements.
* **Review by Exception:** Instead of reading massive agent-generated diffs line-by-line, developers review specific requirement coverages, verifiable evidence, and flagged exceptions.
* **Evidence or it Didn't Happen:** Claims of "tests passed" are invalid without verbatim pasted output or CI links. An empty evidence cell means **Unverified**, never Pass.
* **Code is Reality, Specs are Intent:** Code can falsify a requirement but cannot silently amend it. Conflicts between code and intent require explicit reconciliation (drift management).
* **The Code Repo Stays Pristine:** Swarm is fundamentally a spec-repo discipline. The workspace holds intent (specs) and evidence (reviews, findings), while the code repositories remain clean from agent scratch files.

---

## 2. The Basic Workflow and Lifecycle

The Swarm workflow is centered around a six-step loop for standard feature work, augmented by two conditional steps for structural/brownfield changes:

```
Pull → (Inventory) → Spec → (Change Plan) → Task → Run → Review → Close
```

### The Steps
1. **Pull:** Capture upstream requests (Jira, Linear, GitHub) verbatim into an `intake/` snapshot file to preserve what was actually asked before interpretation.
2. **(Inventory):** For brownfield work. A reconstructive map of existing modules, interfaces, and observed behavior with evidence. It observes and maps, never judges.
3. **Spec:** Translates the ask into intended behavior. Contains Intent, Non-goals, Requirements (with `AC-NNN` IDs and `Verify with:` lines), Open questions, and Affected areas.
4. **(Change Plan):** For structural work (refactors, migrations). Dictates how the codebase changes safely. Specifies baseline, target state, transformation waves, and explicitly enumerates **behavioral preservation guarantees**.
5. **Task:** A bounded work packet for an agent. Specifies the source spec, the exact scope of requirement IDs to implement/preserve, areas not to change, verification commands, and agent instructions.
6. **Run:** The agent executes the task in an isolated branch/worktree, pasting real output for every verification item, and leaving a run summary.
7. **Review:** The reviewer creates a review packet. It assesses requirement coverage via a table (`ID | Result | Evidence | Human attention`) and flags exception triggers (e.g., unverified requirements, out-of-scope changes, database migrations) for targeted human attention.
8. **Close:** Workboard is updated, merge/block decisions are finalized, and any durable lessons learned are saved to `findings/`.

### The Advanced 9-Step Lifecycle
For high-risk changes, the workflow expands into nine granular passes:
`author → lint → improve → lower → decompose → implement → verify → review → promote`

---

## 3. Folder Structure and Workspace Layout

Swarm dictates a dual-topology model: the **Workspace** (where Swarm lives) and the **Code Repo** (which stays clean).

### Repository Structure (Framework)
* `docs/`: The product manuals (01-10 happy path), advanced reference docs (`reference/`), decision ledger (`adrs/`), and flagship walkthroughs (`examples/`).
* `starter-kit/`: The complete, copyable workspace adopted by teams.
* `checks/`: The toolable checks contract (`checks.yaml`) and positive/negative testing fixtures.

### The Adopter Workspace Layout
An initialized Swarm workspace has a hybrid layout balancing intent curation and flow management:
* `AGENTS.md`: The bootloader file loaded by agents for global commands and conventions.
* `status.md`: A hand-edited workboard tracking the state of all specs, tasks, reviews, and findings.
* `templates/`: Frozen markdown templates for artifacts.
* `.agents/skills/`: Tooling and agent guides (e.g., `write-spec`, `implement-task`, `review-output`).
* **Feature Folders (`specs/<feature>/`):** Hold the `spec.md` and any co-located supporting docs (audits, research, RFCs, PRDs).
* **Flow Folders (Committed):**
  * `intake/`: Captured upstream tickets.
  * `inventory/`: Brownfield maps.
  * `change-plans/`: Structural transformation plans.
  * `tasks/`: Bounded task packets.
  * `reviews/`: Resulting review packets containing coverage tables and evidence.
  * `findings/`: Durable discoveries and lessons learned.
  * `decisions/`: Architecture Decision Records (ADRs) tracking immutable, numbered decisions.

---

## 4. Roles, Personas, and Agent Skills

Personas in Swarm are not organizational roles; they are **heuristic profiles**—optional cognitive stances applied to specific tasks that dictate what an agent/reader should look for, demand, and refuse.

### Key Profiles
* **Architect:** (Used in `write-spec`) Focuses on intent over implementation. Refuses "how" dressed as "what."
* **Skeptic:** (Used in `review-output` & `adversarial-review`) Refutes by default. Demands re-run checks and pasted evidence. Refuses self-issued passes and "tests passed" claims without output.
* **Auditor:** (Used in `write-audit`) Observation only. Grounds findings in `file:line` evidence. Refuses prescribing fixes or writing requirements.
* **Surveyor:** (Used in breadth surveys) Demands at least three named instances for "common practice" claims. Refuses generalizing from single examples or marketing copy.
* **Researcher:** (Used in `write-research`) Depth inquiry against primary sources committing to NO decision. Refuses settling open questions or writing requirements.
* **Documentarian:** (Used in documentation tasks) Human-facing, single-frame docs. Demands every code example runs as written and behavior claims trace to source.

### Agent Skills Integration
Skills are standalone, surgically activated `SKILL.md` files. They follow a "load what the task names" doctrine, explicitly pulling in the required stance and operational rules (e.g., `write-spec`, `implement-task`, `fix-flaky-test`).

---

## 5. Review Framework and Checks Mechanism

### The Review Packet
The core of Swarm's value proposition is the review packet. It shifts the burden from reading massive diffs to reviewing exception tables.
* **Coverage Table:** Evaluates each requirement. `ID | Result | Evidence | Human attention`.
* **Exception Routing:** Reviewers only deep-dive into out-of-scope edits, missing evidence, failed requirements, or risky files (security/DB changes).

### The 7-Value Verdict Model
* **Core Results:** `Pass` (requires pasted evidence), `Fail`, `Unverified` (empty evidence cells), `Blocked`.
* **Lifecycle Decorators:** `Waived` (accepted by a human with expiry), `Stale` (code/spec changed since the pass), `Contradicted` (evidence conflicts).

### Checks and Lints
Swarm enforces quality through a checks catalogue (`C001`-`C011`) categorized into Hard Errors and Warnings.
* **Core Checks:** Ensure unique IDs, non-empty `Verify with:` lines, presence of Non-goals, and no TBDs in `ready` specs.
* **Writing Rules Watchlist (APS):** Advisory rules against subjective terms (robust, simple), vague action verbs, loopholes, and comparatives without baselines, unless paired with same-line observable criteria.

### Structured Requirements Notation (SOL)
For high-risk environments, specs can opt-in to a strict EARS-like notation (`format: sol`).
* **Blocks:** `REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`.
* **Modals:** `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY`.
* **Verification Binding:** Explicit `VERIFY BY <method>:<adapter>:<artifact>` lines that tie into `AGENTS.md` commands.

---

## 6. Key Architectural Decisions (ADRs)

Swarm's design is heavily documented in its immutable ADR ledger. The pivotal decisions shaping the framework include:

* **ADR-0050 / ADR-0051 / ADR-0060 (The Spec-Repo Pivot & Workspace Layout):** Swarm is a spec-repo discipline. Intent lives in the workspace; code repos stay pristine. The workspace utilizes a hybrid layout combining per-feature intent folders and committed flow-type folders.
* **ADR-0053 (Structured Specification & Review System):** Foregrounds Swarm as a system for turning messy inputs into specs, bounded tasks, and review-as-exceptions, addressing measured multi-agent failure surfaces without requiring runtime components.
* **ADR-0008 (Empirical Proof as Primitive):** Verbatim pasted output is mandatory for completion claims. "Tests passed" without output is inherently unverified.
* **ADR-0036 (Heuristic Profiles):** Personas are redefined as heuristic stances/profiles rather than job titles, removing organizational-chart misinterpretations.
* **ADR-0068 (Transformation Tier):** Introduced `inventory` and `change-plan` artifacts as conditionally-core elements to safely map and execute brownfield/structural modifications (refactors, migrations, rewrites).
* **ADR-0069 (Starter Kit as a Workspace):** The `starter-kit` is copied whole. Adoption is instantaneous, dropping the piecemeal staging folder approaches of earlier versions.
* **ADR-0035 (7-Value Verdict Model):** Formalized the core and lifecycle review statuses replacing flat pass/fail prose.
* **ADR-0039 (Write-Surface Model):** Formalizes safe parallelism during task decomposition by determining disjoint sets of written files.
* **ADR-0046 (Isolation Axis):** Code tasks implementing specs are assigned isolated worktrees/branches off the base to prevent multi-agent collisions.
* **ADR-0063 (Honesty Framework):** Every rule specifies its enforcement level (convention, checklist, toolable, enforced). Swarm prevents over-claiming tool capabilities.
* **ADR-0071 (Step Bars):** Evals were replaced by clear, qualitative step bars (checklist predicates) defining exactly what constitutes faithful execution at each loop step (e.g., Pull, Spec, Task, Run, Review, Close).

---
*Report synthesized entirely from Swarm repository documentation, ADRs, starter-kit templates, and internal reference guides.*