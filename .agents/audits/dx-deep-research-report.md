# Swarm DX Deep Research Report

> Stance: skeptical senior engineer evaluating whether Swarm is worth the overhead.
> Scope: internal codebase audit + external research on spec-writing DX, change documentation, and agent instruction design.
> Date: 2026-06-08

---

## Executive Summary

Swarm's core conventions — typed obligation blocks, `VERIFY BY` binding, the distillation loss statement, per-feature folders, and the audit→spec promotion flow — are **genuinely valuable**. They solve real problems that engineering teams face when coordinating AI agents and documenting intent.

But Swarm currently asks for **full framework adoption before proving value**. It ships 49 files in the starter kit, prescribes a 9-step flow with no tooling, claims lint codes and hard caps that no linter enforces, and is missing the critical bridge artifacts for brownfield work and planned refactoring.

This report identifies **40 gaps** across 7 categories, synthesizes external research from OpenAPI, Rust RFCs, Google Design Docs, React codemods, and Anthropic's agent research, and proposes a **minimal viable Swarm** that a two-person team could adopt in an afternoon.

**The single most important finding:** Swarm needs a `change-plan.md` artifact — a first-class document for planned transformations with behavioral preservation guarantees. Audit describes what *is*. Spec declares what *must be*. Neither bridges "how we safely transform A to B."

---

## 1. What We Removed (And Why)

### 1.1 The `.swarm.md` file extension

**Status: REMOVED from the entire framework.**

The `.swarm.md` infix was pure ceremony. No parser checked it. No tool validated it. It created friction with editors, GitHub rendering, and casual file operations. The PRD I converted from was `prd.md`; specs could just as well be `spec.md`. The `.swarm.` infix added no value and signaled unjustified self-importance.

**What changed:**
- All `*.swarm.md` files renamed to `*.md`
- All `*.swarm.ir.json` renamed to `*.ir.json`
- All `*.swarm.plan.json` renamed to `*.plan.json`
- All `*.swarm.trace.md` renamed to `*.trace.md`
- Core conceptual documents (`docs/artifacts/README.md`, `docs/artifacts/spec.md`, `docs/model/source-artifacts.md`) rewritten to use **frontmatter `type: spec`** as the sole discriminator, not filename extensions
- Hundreds of prose references updated across the repo

**The new rule:** A spec is identified by `type: spec` in its YAML frontmatter. Filename is `spec.md` by convention only. This is honest — it admits what was already true (no parser checks extensions) and removes friction.

---

## 2. The Artifact Taxonomy Gap

### 2.1 The missing concept: planned change with behavioral preservation

Swarm's artifact taxonomy has a hole:

| Artifact | Stance | Captures |
|----------|--------|----------|
| `audit.md` | observation-only | What *is* |
| `spec.md` | intent | What *must be* |
| `task.md` | scoped execution | What *to do now* |
| **`change-plan.md`** | **planned transformation** | **How to get from A to B safely** |

**The user's exact question:** "Are we missing a concept like spec but for changes to code like refactor? Like a detailed plan with proper prose but for refactors."

**Answer: Yes. We are missing `change-plan.md`.**

A refactor is not an audit (it doesn't just observe). It's not a spec (it doesn't just declare intent). It's a **transformation plan** that must guarantee behavioral preservation across a delta. Swarm's `refactor`, `rewrite`, and `migration` task kinds reference "equivalence checks" and "wave-planning," but these disciplines live only in the *implement* step guide, not in a durable source artifact.

### 2.2 Proposed `change-plan.md` artifact

**Epistemic stance:** planned transformation with behavioral preservation guarantees.

**Required sections:**

| Section | Purpose |
|---------|---------|
| `## Baseline` | Cites `inventory.md` / `audit.md` — the as-is state |
| `## Target state` | Cites `spec.md` — the to-be intent |
| `## Behavioral preservation guarantees` | Binding equivalence checks (property/model/test proofs) |
| `## Transformation waves` | Ordered steps, each with acceptance criteria |
| `## Rollback criteria` | When to abort a wave |
| `## Cutover conditions` | When the old path can be deleted |
| `## Verification strategy` | Per-wave equivalence checks |

**Promotion path:** `audit.md` + `inventory.md` → `change-plan.md` → `spec.md` + `task.md`

**Relationship to existing artifacts:**
- An `rfc.md` MAY produce a `change-plan.md` as its implementation contract
- A `bug-report.md` that requires structural fix MAY require `change-plan.md`
- The `refactor`, `rewrite`, and `migration` task kinds SHOULD require an upstream `change-plan.md`

### 2.3 The companion artifact: `inventory.md`

A `change-plan.md` needs a baseline. Swarm has `audit.md` (observation-only), but audits find violations; they do not produce the **contract map** required to fix them safely.

**Proposed `inventory.md`:**

| Section | Purpose |
|---------|---------|
| `## Entry points` | Public APIs, CLI commands, event handlers |
| `## Implicit contracts` | Behaviors callers depend on that aren't documented |
| `## Data flows` | How data moves through the system |
| `## Hot paths` | Performance-critical code paths |
| `## Dead code` | Code with no callers (candidate for deletion) |
| `## Dependency graph` | Module/crate/package relationships |

**Skill:** `persona-archaeologist` — "map before you judge." Systematic extraction of module graphs, public surfaces, implicit contracts, data flows.

---

## 3. Missing Artifacts (The Full List)

| # | Artifact | Severity | Why it matters |
|---|----------|----------|----------------|
| 001 | `inventory.md` / `contract-map.md` | **Critical** | Brownfield reconstruction needs a baseline before any rewrite |
| 002 | `change-plan.md` / `refactor-plan.md` | **Critical** | Bridge between "what is" and "what must be" for planned changes |
| 003 | `deprecation-notice.md` | Major | API lifecycle management; no `DEPRECATED` block type exists |
| 004 | `runbook.md` | Major | Operational procedures (incident response, recovery) |
| 005 | `onboarding.md` | Major | New engineer journey; `AGENTS.md` is for agents, not humans |
| 006 | `nfr.md` / `slo.md` | Major | Performance budgets, numeric targets; `perf` proof type has no upstream artifact |
| 007 | `post-mortem.md` | Major | Incident learning; `bug-report.md` is for defects, not incidents |
| 008 | `test-plan.md` | Minor | Complex features need verification strategy beyond the spec's summary table |
| 009 | `spike.md` | Minor | Time-boxed exploration that may be discarded; `research.md` assumes durable output |

---

## 4. Overstated / Complicated Concepts

### 4.1 "SOL/0.1" as a named language

**Problem:** Calling it the "Swarm Obligation Language" with version numbers implies parsers, grammars, compatibility concerns — infrastructure no one has built. It is a lightweight markup convention, not a language.

**Evidence:** The adoption experience review noted: "SOL is not a language; it is a lightweight markup convention. Calling it 'SOL/0.1' with version numbers implies parsers, grammars, compatibility concerns."

**Recommendation:** Reframe SOL as a **notation** or **convention** in all positioning docs. Keep `swarm_language` frontmatter for future-proofing, but change the displayed name. Remove version-number marketing until a parser exists.

### 4.2 Closed-set numerology

**Problem:** "7 block types · 5 modals · 7 verdicts · 9 proof types · 7 phases · 9 steps · 10 improve ops · 5 lint layers" reads like cult doctrine. A senior engineer's first reaction is suspicion that the framework values taxonomy over utility.

**Evidence:** The adoption review: "I found myself counting to make sure I hadn't invented an 8th block type. The actual useful constraints are tiny: use 5 modals, write requirements as WHEN..THE..VERIFY BY, and bind each to a proof. Everything else is taxonomy trivia."

**Recommendation:** Trim reference cards to only the subsets that constrain authoring: the 5 modals, the proof-type list, and the block-type prefixes. Move all other counts to an appendix titled "Framework taxonomy for tooling authors" with a clear disclaimer: "You do not need to memorize these to write a good spec."

### 4.3 Lint codes presented as "floors" and "defects" with no linter

**Problem:** `SOL-S001` through `SOL-O005` are presented as BLOCKING/ADVISORY "lint floors." No linter exists. They are naming conventions for manual review mistakes.

**Evidence:** The adoption review: "Calling them 'lint floors' and 'defects' implies automated enforcement that does not exist. They are naming conventions for manual review mistakes."

**Recommendation:** Reframe all `SOL-` codes as **"common mistakes to avoid"** or **"review checklist items."** Remove the words "lint floor," "defect," and "BLOCKING" from starter-kit reference cards. Reserve those terms for a future machine-readable conformance manifest. Add a prominent banner: "These codes are a human review aid; no automated checker ships today."

### 4.4 The 200-line AGENTS.md "HARD CAP"

**Problem:** "HARD CAP: MUST stay <= 200 lines / 25 KB; SHOULD target ~50-150 lines. A valid repo MUST have a regression check that fails when this file exceeds the cap." No regression check ships.

**Evidence:** The adoption review: "The cap is a good lint rule; framing it as a 'HARD CAP' with 'regression check' language feels authoritarian for a framework with no runtime."

**Recommendation:** Reframe as a **soft guideline**: "Aim for ~100 lines. Longer files degrade model attention; if you exceed 200 lines, consider moving procedural content to lazily-loaded skills." Remove "HARD CAP," "MUST," and "regression check" language. Ship an optional shell script in `conformance/`, not a normative requirement.

### 4.5 "NO RUNTIME" framed as doctrine

**Problem:** "## The one rule: NO RUNTIME" is framed as doctrine. It is simply the correct design choice for a writing convention.

**Evidence:** The adoption review: "The 'NO RUNTIME' principle is framed as doctrine when it is simply the correct design. The issue is not 'no runtime'; the issue is that the framework simultaneously claims enforceable rules while correctly having no runtime to enforce them."

**Recommendation:** Keep "No runtime" as a standing principle, but pair every enforcement claim with an explicit honesty clause: "This is a convention self-policed by human review; no automated enforcement ships today."

### 4.6 Structured-form and plan JSON schemas as aspirational fiction

**Problem:** `*.ir.json` and `*.plan.json` are documented as "emitted contracts" that every step produces. No emitter exists. No human can realistically produce valid `*.ir.json` by hand for non-trivial specs.

**Evidence:** `docs/reference/structured-form.md`: "Swarm ships no emitter, no parser, no validator, and no scheduler." Yet `docs/passes/lower.md` and `docs/passes/decompose.md` describe complex node-id assignment, typed edge building, and glob-pattern intersection as if they were human-performable steps.

**Recommendation:** Either (a) ship a minimal reference parser/emitter, or (b) demote `*.ir.json` and `*.plan.json` from "reserved contract names every step produces" to "future-tool contracts" and redesign `lower` and `decompose` to operate on markdown tables inside `spec.md` that humans can actually write and read.

---

## 5. DX Friction

### 5.1 The starter kit is massive

**Problem:** 49 files before writing a single line of project-specific content. 20 skills. 11 templates (715 lines total). Several skills (`persona-architect`, `persona-skeptic`, `distillation-discipline`) are generic cognitive stances an experienced engineer already internalizes.

**Evidence:** Adoption review: "Copying all of this into `promptly-docs/` added 49 files before I wrote a single line of project-specific content."

**Recommendation:** Ship a **minimal kit** containing exactly: `audit.md` template, `spec.md` template, `AGENTS.md` seed, and one reference card (`sol.md`). Move the full kit to `starter-kit/full/`. Offer the minimal path first, with opt-in to the full kit.

### 5.2 The spec-repo / code-repo split assumes a team size most projects don't have

**Problem:** For a solo developer, it means context-switching between directories and maintaining two `.gitignore` files for a project that fits in one person's head.

**Evidence:** Adoption review: "For `promptly-docs/` targeting `./promptly/`, this means two repos, cross-referenced obligation IDs in PRs, and durable outcomes 'flowing back.'"

**Recommendation:** Elevate **co-located adoption** to a first-class workflow. Reorder `ADOPTING.md` sections: (1) Co-located (solo/small team), (2) Spec-repo + code-repo (team scale), (3) Code-repo-only (consumer). Provide explicit directory layout: `specs/<feature>/` beside `src/`, `.agents/` at root, one `AGENTS.md`.

### 5.3 Skills have no documented load mechanism

**Problem:** There is no documentation on how an agent actually *loads* a skill, what the trigger mechanism is, or how skills compose.

**Evidence:** Adoption review: "There is no documentation on how an agent actually loads a skill. If they are meant to be loaded by an agent CLI, the adoption docs should explain the load mechanism. If they are meant to be read manually by the engineer, they should be reorganized as a handbook, not a skill tree."

**Recommendation:** Add a "How skills work" page explaining: (a) how each major agent CLI discovers skills, (b) the trigger mechanism, (c) how skills compose, (d) a test command to verify skills are visible. If no common mechanism exists, rebrand the directory as `handbook/` with an index.

### 5.4 VERIFY BY bindings become fiction when no test infrastructure exists

**Problem:** Every `VERIFY BY test:cmdTest:..` binding names a test that does not exist. The response is "nothing here runs" — correct as philosophy, but as an engineer I want a `swarm lint` command that tells me my spec is structurally valid.

**Evidence:** Adoption review: "Every `VERIFY BY` binding I wrote names a test that does not exist. Swarm's response is: 'Nothing here runs.' This is correct as philosophy, but as an engineer I want validation."

**Recommendation:** Ship a minimal reference `swarm lint` validator (even a 200-line Python or Node script) in a `tools/` directory that checks: (a) block-type prefixes match ids, (b) modals are canonical, (c) `VERIFY BY` bindings are syntactically valid, (d) no duplicate obligation ids, (e) required sections present and in order. This validates structure, not truth — but closes the credibility gap.

### 5.5 The 9-step flow is too heavy for small changes

**Problem:** For a 1-line bug fix, requiring a full `spec.md` + 9 steps is absurd.

**Evidence:** Adoption review: "A two-person team may spend more time in the spec repo than the code repo."

**Recommendation:** Define **three flow profiles**:

| Profile | Steps | When to use |
|---------|-------|-------------|
| **Expedition** (fast path) | `author → lint → implement → verify → review` | ≤3 obligations, single writer, no parallelization |
| **Standard** (full flow) | `author → lint → improve → lower → decompose → implement → verify → review → promote` | Normal features |
| **Spike** | `author → lint → (no review gate) → promote to memory or discard` | Exploratory work |

### 5.6 `lower` + `decompose` are unrealistic for humans to perform by hand

**Problem:** Node-id assignment, typed edge building, glob-pattern intersection — no human can reliably do this for a 20-obligation spec.

**Evidence:** `docs/passes/lower.md` describes: "Assign node ids, build typed edges, normalize `verify_by`, emit two derived graphs, handle `AND THE` chaining, sub-id production." `docs/passes/decompose.md` describes: "Partition obligations, project owned paths, compute merge order, prove pairwise disjointness."

**Recommendation:** For the by-hand pipeline, redesign `lower` and `decompose` to operate on markdown tables inside `spec.md`: add `## Dependency graph` and `## Work packets` sections that humans can edit. The JSON schemas remain the *machine* format, but the human surface should be markdown tables. Emit a disclaimer: "When a tool exists, these tables are auto-generated; today, author them by hand."

---

## 6. Missing Skills / Personas

| # | Skill / Persona | Severity | Role |
|---|-----------------|----------|------|
| 025 | `persona-archaeologist` / `write-inventory` | **Critical** | Brownfield reconstruction: map before you judge |
| 026 | `persona-janitor`, `persona-builder`, `persona-migrator`, `persona-performance-surgeon`, `persona-test-author` | Major | Referenced in `implement.md` but do not ship in starter kit |
| 027 | `persona-security-reviewer` / `write-threat-model` | Major | Security review, SAST/DAST interpretation, authn/authz review |
| 028 | `persona-migrator` / `write-migration-plan` | Major | Callsite inventory, wave definition, shim design |

---

## 7. External Research Synthesis

### 7.1 The Adoption Gap Is Social, Not Technical

Across OpenAPI, TLA+, Rust RFCs, and Google Design Docs, the formats that succeed are those that **reduce friction in the existing developer workflow** rather than adding a new ritual.

**OpenAPI succeeded because:**
- It met developers where they were (code-first AND spec-first)
- It produced *visible* value immediately (docs, SDKs, mocks)
- It used familiar JSON/YAML, not alien mathematical notation

**TLA+ failed at mainstream adoption because:**
- Proofs are "obnoxiously hard" (Microsoft's IronFleet: 4 lines of verified Dafny code per day)
- Developers mistrust non-code artifacts
- No automatic code generation or verification bridge
- Design verification is a *social* problem: "people just don't see the point"

**Implication for Swarm:** Specs must feel like "structured thinking" rather than "formal proof." They should connect directly to executable outcomes (agent behavior, validation, change plans). The value proposition should be "write this to avoid bugs" not "write this to prove correctness."

### 7.2 Rust RFCs: Clear Threshold, Lightweight Format, Author Ownership

**What works:**
- Clear threshold for "substantial" vs. trivial changes
- Pre-validation via informal discussion before formal submission
- Lightweight markdown, no special tooling
- Transparent lifecycle (PR → discussion → FCP → merge/close)
- **Author owns implementation** — no throw-it-over-the-wall

**Implication for Swarm:** Define a clear "when do I need a spec?" threshold. Provide a lightweight markdown template. Encourage informal discussion before formal spec submission. Make the spec lifecycle visible and simple.

### 7.3 Google Design Docs: Trade-offs Over Decisions

**Key principles:**
- "Rule #1: Write them in whatever form makes the most sense"
- Sweet spot: 10-20 pages for larger projects; 1-3 pages for "mini design docs"
- **Alternatives considered** is the most important section
- Outcomes over process

**Implication for Swarm:** Keep specs short. Focus on trade-offs and alternatives, not just "what we decided." Make specs living documents that can be amended.

### 7.4 React Codemods: Granular, Tool-Assisted, Before/After

**Best practices:**
- Bridge releases (18.3) that add warnings before breaking changes
- One codemod per breaking change, not one giant migration
- Before/after code examples for every change
- TypeScript codemods separate from runtime codemods

**Implication for Swarm:** Change specs should include:
- A "bridge" state where old and new can coexist
- Before/after examples for every change
- Granular, incremental migration steps

### 7.5 Hyrum's Law: All Observable Behavior Is a Contract

> "With a sufficient number of users of an API, it does not matter what you promise in the contract: all observable behaviors of your system will be depended on by somebody."

**Implication for Swarm:** Change specs must explicitly define:
- What behavioral properties are preserved
- What observable changes are expected
- How to validate the change (tests, property checks)
- The "blast radius" of the change

### 7.6 Strangler Fig: Gradual Modernization Is the Default

**Key insight:** "Replacing a serious IT system takes a long time, and the users can't wait for new features. Replacements seem easy to specify, but often it's hard to figure out the details of existing behavior."

**Implication for Swarm:** Change specs for large refactors should:
- Define clear outcomes before defining implementation
- Identify "seams" where the system can be split
- Accept transitional architecture as a first-class concept

### 7.7 Anthropic Agent Research: Simplicity Beats Sophistication

> "Consistently, the most successful implementations weren't using complex frameworks or specialized libraries. Instead, they were building with simple, composable patterns."

**Key principles:**
- Prefer **tools** (atomic capabilities) over **skills** (compositions) over **personas** (vague framing)
- Invest heavily in Agent-Computer Interface (ACI) design
- Retrieval beats pre-loading; focused separate calls beat monolithic context dumps
- "Success in the LLM space isn't about building the most sophisticated system. It's about building the right system for your needs."

**Implication for Swarm:**
- Define Swarm specs as **tools** that agents use, not **personas** that agents adopt
- A spec should expose a clear interface: inputs, outputs, invariants, validation criteria
- Keep agent instructions simple and composable; the spec provides the complexity

---

## 8. Concrete Recommendations (Prioritized by Impact)

### Immediate (do this week)

1. **Ship `change-plan.md` and `inventory.md` artifacts** with templates, skills, and step guides. These are the missing bridge for brownfield work and refactoring.
2. **Ship a minimal starter kit** (4 files: `AGENTS.md`, `spec.md` template, `audit.md` template, `sol.md` reference). Move the full kit to `starter-kit/full/`.
3. **Reframe SOL as a "notation"** in all positioning docs. Remove "language" and version-number marketing.
4. **Reframe lint codes as "review checklist items"** in user-facing docs. Remove "lint floor," "defect," and "BLOCKING" from starter-kit reference cards.
5. **Define the three flow profiles** (Expedition / Standard / Spike) in `docs/model/how-swarm-works.md`.

### Short-term (do this month)

6. **Ship a minimal `swarm lint` validator** (200-line script) that checks structural validity: block prefixes, modals, `VERIFY BY` syntax, duplicate ids, required sections.
7. **Rewrite `lower` and `decompose` step guides** to operate on markdown tables inside `spec.md`, not JSON schemas.
8. **Elevate co-located adoption** to first-class in `ADOPTING.md`.
9. **Ship missing personas** (`archaeologist`, `janitor`, `builder`, `migrator`, `security-reviewer`) or remove their references from `implement.md`.
10. **Add lightweight templates** (`spec.min.md`, `audit.min.md`, `task.min.md`) that are ≤30 lines each.

### Medium-term (do this quarter)

11. **Add remaining missing artifacts** (`deprecation-notice.md`, `runbook.md`, `onboarding.md`, `nfr.md`, `post-mortem.md`) as conditional Tier-3 templates.
12. **Ship a `promote.sh` helper** that appends findings to `memory/INDEX.md`.
13. **Add an `abandon` step guide** describing when and how to abandon a task/spec.
14. **Add a `test-plan.md` artifact** for complex verification strategies.
15. **Add a `spike.md` artifact** for time-boxed exploration.

---

## 9. Proposed Minimal Viable Swarm

What a two-person team should copy in 5 minutes:

```
promptly-docs/
├── .agents/
│   └── AGENTS.md          # ≤100 lines, soft cap
├── specs/
│   └── 001-feature/
│       ├── spec.md        # type: spec, the contract
│       └── audit.md       # type: audit, the observation
└── decisions/
    └── 001-adr.md         # type: adr
```

That's **4 files** to start. Add `inventory.md` and `change-plan.md` when doing brownfield work. Add `research.md` when investigating. Expand to the full starter kit only when the pain of not having skills/templates exceeds the overhead of maintaining them.

---

## 10. The Honesty Framework

Every page in Swarm that claims a "MUST," a "gate," a "defect," or a "BLOCKING" check should carry this disclaimer:

> **Honesty clause:** Swarm is a set of writing conventions for engineering specs. It has no runtime, no linter, no parser, and no scheduler. The rules on this page are self-policed by human review. A future tool MAY automate them; today, they are a shared checklist, not enforced infrastructure.

This honesty clause does not weaken Swarm. It strengthens it by aligning claims with reality. A senior engineer can respect a framework that knows what it is.

---

## Sources

1. **Internal:** Swarm codebase audit — 40 gaps identified across artifacts, skills, passes, and starter kit
2. **Rust RFC Process** — https://rust-lang.github.io/rfcs/
3. **Google Design Docs** — https://www.industrialempathy.com/posts/design-docs-at-google/
4. **Why Don't People Use Formal Methods?** — https://www.hillelwayne.com/post/why-dont-people-use-formal-methods/
5. **Architecture Decision Records (Nygard)** — https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
6. **React 19 Upgrade Guide** — https://react.dev/blog/2024/04/25/react-19-upgrade-guide
7. **Hyrum's Law** — https://www.hyrumslaw.com/
8. **Strangler Fig Application** — https://martinfowler.com/bliki/StranglerFigApplication.html
9. **Divio Documentation System** — https://documentation.divio.com/
10. **Building Effective AI Agents (Anthropic)** — https://www.anthropic.com/engineering/building-effective-agents
11. **Large-Scale Changes at Google** — https://research.google/blog/large-scale-changes-at-google/
12. **ADR GitHub Repository** — https://github.com/joelparkerhenderson/architecture-decision-record
