---
type: audit
id: swarm-adoption-experience-review
status: draft
created: 2026-06-08
updated: 2026-06-08
author: external-adopter-review
---

# Audit: Swarm adoption experience — an external adopter's review

*Lives in: `swarm/.agents/audits/` — a meta-audit of the Swarm framework itself, produced after adopting it into a real spec repo (`promptly-docs/`).*

> Stance: **skeptical senior engineer evaluating whether Swarm is worth the overhead for my team.** I just spent a session adopting Swarm into a fresh spec repo and producing ~8 feature specs, 5 audits, and 1 market survey from a brownfield Chrome-extension codebase. This audit records what worked, what didn't, and where the framework's claims diverged from its delivered value.

## Scope

- **In scope:** The Swarm starter kit (skills, reference cards, templates, memory), the SOL language, the spec-repo discipline, and the adoption workflow as exercised on a real project (`promptly-docs/` → `./promptly/`).
- **Out of scope:** Code-implementation skills (not used; this was a spec-repo-only adoption), the upstream Swarm project's full manual (not installed in the kit), and validity of specs produced by *other* agents against these specs (cannot be judged yet).

## Executive summary

Swarm delivers genuine value in **forcing rigor** and **preventing drift** between intent and code. It is also **heavy ceremony** for small projects, **aspirational about tooling** it does not ship, and **optimistic about team size** — the spec-repo/code-repo split assumes a team large enough to need separation. For a solo developer on an MVP Chrome extension, the overhead is real and the payoff is deferred. For a team maintaining a complex product across multiple repos, the discipline likely pays for itself.

---

## Observations

### O-001 — The audit template is the strongest artifact in the kit

- **What happened:** I started with the brownfield audit (`specs/000-present-state/audit.md`). The template's forced separation between **observations** (what the code *is*), **risks** (what could go wrong), and **recommended obligations** (what a future spec *should* require) prevented me from slipping into "just fix it" mode. I found 14 concrete issues in a codebase I thought I already understood.
- **Evidence:** `promptly-docs/specs/000-present-state/audit.md` — 14 observations with file:line citations, 5 risks with trigger conditions, 11 recommended obligations in prose.
- **Verdict:** The audit template alone justifies partial adoption. It is the fastest path to value.

### O-002 — SOL obligation blocks force precision that prose PRDs hide

- **What happened:** Converting `./promptly/docs/prd.md` (324 lines of conventional PRD prose) into 7 `spec.md` files exposed ambiguities the PRD masked. Example: PRD §2.4.2 says "If count exceeds MAX_WORDS threshold (e.g., 1000 words), truncate" — but SOL forces you to decide who enforces it (`THE selection module MUST`), how it's verified (`VERIFY BY test:cmdTest:..`), and what the risk level is (`RISK medium`). These decisions took time but produced a contract an implementer can actually build to.
- **Evidence:** Compare `./promptly/docs/prd.md` §2.4.2 (1 sentence) with `promptly-docs/specs/002-contextual-actions/spec.md` AC-001 + AC-005 + C-001 (binding obligations with proofs).
- **Verdict:** SOL is not just syntax sugar; it is a **thinking tool**. The cost is ~3–4× the writing time of a prose PRD.

### O-003 — The "NO RUNTIME" principle is intellectually coherent and practically frustrating

- **What happened:** Every `VERIFY BY test:cmdTest:..` binding I wrote names a test that does not exist. The `AGENTS.md` Commands table says `cmdTest: npx vitest run`, but the target repo has no test files and no `test` script in `package.json`. Swarm's response is: "Nothing here runs; every tool is a contract a future tool could build against." This is correct as philosophy, but as an engineer I want a `swarm lint` command that tells me my spec is structurally valid, my obligation IDs are unique, and my `VERIFY BY` adapters resolve.
- **Evidence:** `promptly-docs/specs/003-llm-integration/spec.md` contains 16 `VERIFY BY` bindings; 16 corresponding tests do not exist. `promptly-docs/AGENTS.md` Commands table references `cmdBenchmark: node benchmark.mjs` — a file that does not exist.
- **Verdict:** The framework is **pre-tooling**. It defines what a linter *should* check but does not ship one. A senior engineer will ask: "Why should I adopt a framework that doesn't enforce its own rules?"

### O-004 — The closed-set taxonomy is useful reference but feels like pedantic gatekeeping

- **What happened:** The reference cards repeatedly state the closed-set counts: "7 block types · 5 modals · 7 verdicts · 9 proof types · 7 phases · 9 steps · 10 improve ops · 5 lint layers · 7 edge types · 17 task_kind." I found myself counting to make sure I hadn't invented an 8th block type or a 6th modal. This prevented creative drift (no `SHALL`, no `CAN`, no custom verdicts), but it also created anxiety about getting the "rules" wrong.
- **Evidence:** `promptly-docs/.agents/reference/sol.md` lines 74–76; `promptly-docs/.agents/reference/proofs.md` lines 25–26.
- **Verdict:** The discipline is healthy; the presentation feels like a compliance checklist. A lighter touch ("Here are the valid modals: MUST, MUST NOT, SHOULD, SHOULD NOT, MAY") would convey the same rule without the ceremony.

### O-005 — The spec-repo / code-repo split assumes a team size most projects don't have

- **What happened:** Swarm's ADOPTING.md says "Code repos stay pristine" and "A code repo that implements a spec stays pristine — a good SOL spec is self-legible." For `promptly-docs/` targeting `./promptly/`, this means two repos, cross-referenced obligation IDs in PRs, and durable outcomes "flowing back" to the spec repo. This is excellent for a 10-person team. For a solo developer, it means context-switching between directories and maintaining two `.gitignore` files for a project that fits in one person's head.
- **Evidence:** `swarm/docs/ADOPTING.md` §3 vs §4; `promptly-docs/decisions/0002-target-promptly-extension.md` acknowledges "two-repo workflow" as a negative consequence.
- **Verdict:** The discipline is sound at scale; the default should probably be **co-located** for solo/small teams, with migration to split repos as the team grows. The kit treats co-location as an afterthought.

### O-006 — The starter kit is large; adoption feels like onboarding to a framework, not a format

- **What happened:** The starter kit contains 20 skills, 3 reference cards, 11 templates, 2 memory seeds, 1 example spec, 1 example audit, 1 example research doc, and 1 seed ADR. Copying all of this into `promptly-docs/` added 47 files before I wrote a single line of project-specific content. Several skills (`persona-architect`, `persona-skeptic`, `distillation-discipline`) are generic cognitive stances that an experienced engineer already internalizes. The signal-to-noise ratio is low.
- **Evidence:** `find promptly-docs/.agents -type f | wc -l` = 49 files in `.agents/` before any project specs were written.
- **Verdict:** A "minimal kit" option (audit template + spec template + 1 reference card + AGENTS.md) would lower the adoption barrier significantly.

### O-007 — The skills are inert markdown; the agent CLI integration is underspecified

- **What happened:** ADOPTING.md instructs: "Copy `starter-kit/.agents/skills/` into the directory my agent CLI actually scans — `.claude/skills/` for Claude Code, otherwise `.agents/skills/`". I copied them to `.agents/skills/`, but there is no documentation on how an agent actually *loads* a skill, what the trigger mechanism is, or how skills compose. The skills contain excellent heuristics (e.g., surveyor's "three concrete instances" rule), but they are static reference docs, not active guidance.
- **Evidence:** `swarm/docs/ADOPTING.md` §3; `swarm/starter-kit/README.md` §2.
- **Verdict:** If the skills are meant to be loaded by an agent CLI, the adoption docs should explain the load mechanism. If they are meant to be read manually by the engineer, they should be reorganized as a handbook, not a skill tree.

### O-008 — The surveyor stance genuinely improved research quality

- **What happened:** While writing the market survey (`promptly-docs/specs/009-market-survey/research.md`), the surveyor stance's "three concrete instances" rule caught me generalizing from one competitor. I had to find explicit evidence from Grammarly, LanguageTool, and QuillBot before claiming "inline real-time suggestions are the dominant interaction mode." The "observation vs claim" separation prevented me from dressing intuition as fact.
- **Evidence:** `promptly-docs/specs/009-market-survey/research.md` F-001 cites three named products with direct quotes from their CWS listings/product pages.
- **Verdict:** The **surveyor skill is the standout** of the persona set. It provides a reproducible evidentiary discipline that most "competitive analysis" docs lack.

### O-009 — AGENTS.md's 200-line cap creates a perverse incentive

- **What happened:** I wrote a comprehensive `AGENTS.md` for Promptly (92 lines) and immediately worried about the 200-line cap. The cap is described as a "HARD CAP: MUST stay <= 200 lines / 25 KB" and "a valid repo MUST have a regression check that fails when this file exceeds the cap." This is a healthy constraint against bloat, but it also discourages adding genuinely useful project facts. I found myself wondering: "Should I document the WXT build toolchain quirks, or will that push me closer to the cap?"
- **Evidence:** `promptly-docs/AGENTS.md` lines 1–3 (the cap is declared in the template comment); actual file is 92 lines.
- **Verdict:** The cap is a good lint rule; framing it as a "HARD CAP" with "regression check" language feels authoritarian for a framework with no runtime.

### O-010 — The distillation loss statement is a hidden gem

- **What happened:** The `spec.md` template requires a `## Distillation loss statement` with `### Preserved`, `### Dropped`, and `### Still uncertain` subsections. This forced me to document what I *chose not to carry* from the PRD into the spec. Example: I explicitly dropped "arrow or indicator pointing toward the text" from the overlay spec, noting it as "polish, not MVP-critical." Without this section, that decision would have been invisible.
- **Evidence:** `promptly-docs/specs/001-text-selection-overlay/spec.md` ## Distillation loss statement.
- **Verdict:** This section should be celebrated more loudly in the framework. It is where **design rationale** lives.

---

## Risks

- **R-001 — Adoption fatigue kills uptake** — fires when a team evaluates Swarm against lighter alternatives (ADRs in a `docs/` folder, Gherkin/Cucumber for tests, plain Markdown checklists). The starter kit's 49 files of boilerplate before writing a single spec creates a "this is heavier than the code itself" impression. *Mitigation: ship a minimal kit.*

- **R-002 — VERIFY BY bindings become fiction** — fires when no test infrastructure exists in the code repo. Every `VERIFY BY test:cmdTest:..` I wrote is a promise with no creditor. Over time, these bindings will be ignored, turning the spec into ceremonial documentation. *Mitigation: provide a reference implementation of a spec linter/verdict tracker, even if minimal.*

- **R-003 — The framework becomes the work** — fires on small teams: maintaining specs, ADRs, memory INDEX, and glossary consumes cycles that could build product. Swarm's 9-step flow (`author → lint → improve → lower → decompose → implement → verify → review → promote`) is thorough and expensive. A two-person team may spend more time in the spec repo than the code repo. *Mitigation: treat steps as optional for MVP specs; enforce full flow only for high-risk changes.*

- **R-004 — SOL syntax errors go undetected** — fires because no linter exists: a mis-typed `MUST` as `must`, a missing `VERIFY BY`, or an out-of-order section (`## Constraints` before `## Obligations`) will sit in the spec undiscovered until a human reviewer catches it. For a framework that claims "the spec is the source of truth," the absence of a parser is a credibility gap. *Mitigation: ship a `swarm lint` CLI or GitHub Action.*

---

## Recommended obligations

*(Prose only — candidate obligations a future spec could promote if Swarm chooses to address them.)*

- The starter kit SHOULD offer a **minimal adoption path** containing only the audit template, spec template, SOL reference card, and AGENTS.md seed. (→ framework-usability spec)
- The framework SHOULD provide a **machine-readable SOL validator** (a linter that checks block types, modals, ID uniqueness, section ordering, and VERIFY BY adapter resolution) as reference code, not just as a contract. (→ tooling spec)
- ADOPTING.md SHOULD elevate **co-located adoption** (spec + code in one repo) to a first-class workflow with explicit instructions, rather than treating it as a footnote. (→ adoption spec)
- The `## Distillation loss statement` section SHOULD be highlighted in onboarding docs as a required best practice, not buried in the template. (→ documentation spec)
- The skills directory SHOULD document how skills are **loaded, triggered, and composed** by agent CLIs, or be rebranded as a reference handbook if they are intended for manual reading only. (→ tooling spec)

---

## O-011 — The audit is incomplete for brownfield-to-spec transitions; a reconstructive stance is missing

- **What happened:** After finishing the present-state audit (`promptly-docs/specs/000-present-state/audit.md`), I had 14 observations and 5 risks — but I still had to manually grep the codebase to reconstruct implicit behavioral contracts before I could write specs. Example: the audit correctly flagged that `background.ts` imports `listen_for_streams` from a repository (violating architecture). But to write the `messaging` spec, I needed to know: *who calls `publish`? Who subscribes to `EventType.SETTINGS_UPDATE`? What is the implicit contract of `listen_for_streams`?* The audit finds violations; it does not produce the **contract map** required to fix them safely.
- **Evidence:** `promptly-docs/specs/000-present-state/audit.md` O-003 (architecture violation) vs `promptly-docs/specs/005-messaging/spec.md` IF-001 through IF-004 (interface blocks that had to be manually reconstructed from source).
- **Verdict:** The audit's adversarial, observation-only stance is too valuable to dilute. But Swarm needs a **reconstructive companion** — an `inventory.md` or `contract-map.md` artifact that maps the as-built architecture (caller graphs, implicit contracts, data flows, dead vs. hot code) before the architect draws new boundaries. The current flow expects the author to do this grepping work invisibly between audit and spec.

### The missing concepts

| Concept | What it does | Why it's not an audit |
|---|---|---|
| **`persona-archaeologist`** (reconstructive stance) | Maps the territory: entry-point graphs, implicit contracts, data flows, test-to-surface coverage | The auditor is adversarial ("what's broken?"); the archaeologist is reconstructive ("what was built here?"). Mixing them dilutes both. |
| **`write-inventory` skill** (systematic pass) | Runs a mechanical extraction: module graph, public surfaces, cross-module callers, dead code, hot paths | The audit produces judgment; the inventory produces structured data. Both are needed. |

### How this changes the rewrite/refactor flow

**Current implicit flow:**
```
audit → [author manually greps codebase] → author (spec) → implement
```

**Proposed explicit flow:**
```
audit (what's wrong) → inventory/contract-map (what exists) → author (spec) → migration-plan (how to transition) → implement → verify → review
```

The `inventory` step is the missing bridge. It makes implicit contracts explicit before the architect writes boundaries. Without it, the author does invisible, unrepeatable archaeology.

### Recommended obligations

- Swarm SHOULD provide a **reconstructive stance** (`persona-archaeologist` or `persona-cartographer`) for brownfield code analysis, producing an `inventory.md` or `contract-map.md` artifact that maps as-built architecture without judging it. (→ framework spec)
- Swarm SHOULD provide a **`write-inventory` pass-guide** that systematically extracts: module graph, public surfaces and callers, implicit contracts, data flows, test coverage map, dead code, and hot paths. (→ framework spec)
- The starter kit SHOULD document that **audits are insufficient for rewrites/refactors alone** — an inventory/contract-map is required input before authoring migration or replacement specs. (→ adoption spec)

---

## O-012 — The ceremonial parts undermine the useful parts; Swarm should be a convention, not a language

- **What happened:** While adopting Swarm, I repeatedly encountered what I can only call **framework theater** — elaborate claims about rules, counts, and enforcement mechanisms that exist only as markdown assertions. The most egregious examples:

  **1. The `.md` extension is pure ceremony.** Swarm insists that specs use the `*.md` infix and that "naming an audit that way mislabels an observation as a Swarm-visible spec." But the extension does nothing. No parser checks it. No tool validates it. It is a naming convention that creates friction with editors, GitHub rendering, and casual file operations. The PRD I converted from was `prd.md`; my specs could just as well be `spec.md`. The `spec.md` naming adds no value and signals an unjustified self-importance.

  **2. The lint floors are fiction dressed as engineering.** The SOL reference card lists: "Blocking, common set: S `SOL-S001/S003/S005/S006/S012` · P `SOL-P001`–`SOL-P008` · M `SOL-M001/M002` · V `SOL-V001` · O `SOL-O001/O005`." These are presented as lint codes — but there is no linter. Calling them "lint floors" and "defects" implies automated enforcement that does not exist. They are naming conventions for manual review mistakes. A more honest framing: "Common mistakes to watch for" — not "lint floors."

  **3. The closed-set numerology reads like cult doctrine.** The reference cards repeatedly demand: "7 block types · 5 modals · 7 verdicts · 9 proof types · 7 phases · 9 steps · 10 improve ops · 5 lint layers · 7 edge types · 17 task_kind." The actual useful constraints are tiny: use 5 modals (MUST/MUST NOT/SHOULD/SHOULD NOT/MAY), write requirements as `WHEN..THE..VERIFY BY`, and bind each to a proof. Everything else is taxonomy trivia. I never once needed to know there are exactly "10 improve ops" or "7 edge types" to write a good spec.

  **4. "SOL/0.1" as a named language is overstated.** SOL is not a language; it is a lightweight markup convention. Calling it "SOL/0.1" with version numbers implies parsers, grammars, compatibility concerns — infrastructure no one has built. The actual syntax is: frontmatter + markdown headers + plaintext blocks starting with `REQ AC-NNN:`. That's a convention. A good one. But not a language, and versioning it as 0.1 suggests stability claims the project cannot make.

  **5. The "NO RUNTIME" principle is framed as doctrine when it is simply the correct design.** The README states: "Swarm ships markdown, not software. Everything that 'runs' is a contract a future tool builds against, never something this repo executes." This is the right call — a spec-writing convention does not need a runtime any more than Markdown or ADRs do. The issue is not "no runtime"; the issue is that the framework **simultaneously claims enforceable rules** (lint codes, regression checks, hard caps) while correctly having no runtime to enforce them. The tension is between "convention" and "enforceable rule," not between "no runtime" and "needs runtime." No runtime is correct; pretending there is enforcement is not.

  **6. The 200-line AGENTS.md "HARD CAP" with "regression check" language.** The template says: "HARD CAP: MUST stay <= 200 lines / 25 KB; SHOULD target ~50-150 lines. A valid repo MUST have a regression check that fails when this file exceeds the cap." There is no regression check. There is no tool that counts lines. The cap is a good convention; framing it as a hard requirement with enforcement language is false precision.

- **Evidence:**
  - `promptly-docs/.agents/reference/sol.md` lines 74–76: "7 block types · 5 modals · 7 verdicts · 9 proof types · 7 phases · 9 steps · 10 improve ops · 5 lint layers · 7 edge types · 17 task_kind"
  - `promptly-docs/.agents/reference/sol.md` lines 78–80: "Blocking, common set: S `SOL-S001/S003/S005/S006/S012` · P `SOL-P001`–`SOL-P008` …"
  - `swarm/README.md` line 62: "The one rule: NO RUNTIME"
  - `promptly-docs/.agents/skills/write-audit/SKILL.md` line 61: "Required sections, in order: `## Scope` (In/Out), `## Observations`, `## Risks`, `## Recommended obligations` … A document missing a required section or ordering them wrong is the required-section defect `SOL-S012`"
  - `promptly-docs/AGENTS.md` line 7: "HARD CAP: MUST stay <= 200 lines / 25 KB; SHOULD target ~50-150 lines. A valid repo MUST have a regression check that fails when this file exceeds the cap."

- **What IS actually helpful (stripped of ceremony):**

| Ceremonial framing | What it actually is | Why it matters |
|---|---|---|
| "SOL/0.1 language" | A lightweight convention: frontmatter + typed blocks + proof bindings | Forces precision without requiring a parser |
| "Lint floors SOL-S001…" | A checklist of common mistakes | Useful as guidance, not as pseudo-automated rules |
| "*.md extension" | A file naming convention | Unnecessary; `spec.md` or `contract.md` works as well |
| "7 block types, 5 modals, 9 proof types" | Constraints on vocabulary | The 5 modals and proof-type binding are genuinely useful; the counts are trivia |
| "NO RUNTIME" | Ships conventions, not executables | Correct design; the issue is overstated enforcement claims elsewhere, not the absence of a runtime |
| "HARD CAP 200 lines" | A good length guideline | Useful discipline; calling it a "hard cap with regression check" is overstated |

- **Verdict:** Swarm should drop the pretense of being a language and embrace what it actually is: **a set of excellent writing conventions for engineering specs.** The audit template, the typed obligation blocks, the `VERIFY BY` binding, the distillation loss statement, and the per-feature folder discipline are all genuinely valuable. But every time the framework claims enforcement it cannot deliver — lint codes, hard caps, language versions, `.` file extensions — it undermines its own credibility. A senior engineer's first reaction to "7 block types · 5 modals · 7 verdicts" is not admiration; it is suspicion that the framework values taxonomy over utility.

### Recommended obligations

- Swarm SHOULD reframe SOL as a **convention** or **notation**, not a language, and drop the version numbering (`SOL/0.1`) until a parser exists. (→ positioning spec)
- Swarm SHOULD remove the `.md` file extension requirement and treat it as an **optional convention**, not a normative naming rule. (→ language spec)
- Swarm SHOULD reframe lint codes (`SOL-S001`, etc.) as **common mistakes to avoid**, not "lint floors" or "defects," and remove all language implying automated enforcement until a linter ships. (→ documentation spec)
- Swarm SHOULD trim the closed-set counts to only the subsets that actually constrain authoring: the 5 modals, the proof-type list, and the block-type prefixes. The rest (phases, steps, improve ops, lint layers, edge types, task kinds) belong in a reference appendix, not in operative cards. (→ reference spec)
- Swarm SHOULD keep "NO RUNTIME" as a standing principle but pair it with a clear statement that conventions are self-policed, not machine-enforced, and that lint codes / hard caps are guidance for human review, not automated rules. (→ principles spec)
- Swarm SHOULD reframe the AGENTS.md line cap as a **soft guideline** ("aim for ~100 lines") rather than a hard cap with regression-check language. (→ AGENTS.md template)

---

## Overall verdict

**Conditionally recommended.**

Swarm is not a format; it is a **discipline**. The discipline is valuable — the audit template, the SOL precision, the distillation loss statement, and the surveyor stance all produced measurably better artifacts than I would have written ad-hoc. But the framework asks for full adoption before proving value, ships no enforcement tools, and optimizes for team scale that many projects haven't reached yet.

**My advice to a senior engineer:**

- **Try the audit template first.** Adopt nothing else. If it surfaces issues you missed, Swarm has already paid for itself.
- **Add specs incrementally.** Write one `spec.md` for your next high-risk feature. Don't adopt the full 9-step flow or the memory system until you feel the pain of not having them.
- **Demand tooling.** If the Swarm project ships a linter/validator, re-evaluate full adoption. Until then, treat it as a very good set of conventions and templates, not as an enforceable framework.
- **Keep it co-located for small teams.** The spec-repo/code-repo split is elegant theory; for 1–3 people, it is friction without benefit.

Swarm is the best spec-discipline framework I have seen for agent-driven development. It is also not yet a framework — it is a **manifesto with templates**. The gap between those two things is where my skepticism lives.
