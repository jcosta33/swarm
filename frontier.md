# Research: agentic development at the frontier — how Swarm stacks up

## Research question

What patterns are top engineers and frontier companies actually using to run agentic coding at scale in mid-2026, and how does Swarm compare? Where is Swarm intellectually aligned with the field, where does it differ, and where does it have operational gaps the field has already solved?

---

## Sources

- **[S1]** Cognition AI. _Don't Build Multi-Agents._ Walden Yan. cognition.ai/blog/dont-build-multi-agents (June 2025).
- **[S2]** Cognition AI. _Multi-Agents: What's Actually Working._ cognition.ai/blog/multi-agents-working (April 2026 — the "10 months later" reversal).
- **[S3]** Anthropic. _How we built our multi-agent research system._ anthropic.com/engineering/multi-agent-research-system (June 2025).
- **[S4]** Anthropic. _Claude Code best practices._ code.claude.com/docs/en/best-practices (current).
- **[S5]** Anthropic. _2026 Agentic Coding Trends Report._ resources.anthropic.com (early 2026).
- **[S6]** Anthropic / Boris Cherny. _Claude Code subagents course._ anthropic.skilljar.com (2026).
- **[S7]** GitHub. _Spec Kit._ github.com/github/spec-kit. Plus Microsoft Developer Blog companion piece.
- **[S8]** BMAD-METHOD. github.com/bmad-code-org/BMAD-METHOD and ArceApps deep-dive (Sep 2025).
- **[S9]** Jesse Vincent (obra). _Superpowers_ skills framework. github.com/obra/superpowers and Marc Nuri's analysis (May 2026).
- **[S10]** OpenAI. _Codex AGENTS.md guide_ and _Agent Skills._ developers.openai.com/codex.
- **[S11]** AGENTS.md — open standard now stewarded by the Agentic AI Foundation under the Linux Foundation. agents.md.
- **[S12]** IndyDevDan. _Top 2% Agentic Engineering Roadmap 2026._ agenticengineer.com (April 2026).
- **[S13]** CodeScene. _Agentic AI coding best-practice patterns._ codescene.com (Feb 2026).
- **[S14]** OpenSpec, Kiro (AWS), Augment Code's "Intent" — comparative analysis at augmentcode.com (March 2026).

---

## Key findings

The field has converged on a small number of patterns and is divided on a small number of others. The convergent patterns map closely to Swarm; the divergent ones are where Swarm should make a position choice.

### Convergent pattern 1 — Spec-before-code is now the default

Every major framework — Spec Kit, BMAD-METHOD, OpenSpec, Superpowers, Kiro, Augment's Intent — leads with a written specification that the agent implements against. Spec-driven development is now defined as a methodology where specifications become executable, first-class artifacts that directly generate implementations rather than merely guiding them. The Anthropic 2026 Trends Report calls this the standard pattern at "Phase 2" maturity (feature-level autonomy with human review), where most leading teams now operate [S5]. Blink reports that vague prompts versus brief written specs differ by ~60% in rollback rate [S5 cited via Blink]. Swarm's "spec grounds Feature Development" rule is the field consensus, not a novelty.

### Convergent pattern 2 — research → plan → execute → review → ship

Named slightly differently by different sources (Karpathy's "agentic engineering," IndyDevDan's "in-loop / out-loop," Anthropic's "explore → plan → code → verify," Superpowers' six-phase workflow) but structurally identical. The pattern is converging — research → plan → execute → review → ship, with the human as oversight at each gate. Swarm's distillation chain (research → spec → task → code → audit) is the same shape with different names.

### Convergent pattern 3 — AGENTS.md is the cross-tool standard

The format originated at OpenAI Codex and is now supported by Cursor, Aider, Devin, Factory, Jules (Google), Junie (JetBrains), Warp, Zed, opencode, and others — stewarded by the Agentic AI Foundation under the Linux Foundation. The OpenAI monorepo alone reportedly ships 88 nested AGENTS.md files, with the closest file in the directory tree winning. Codex extends this with `AGENTS.override.md` for monorepo subdirectories that need different rules. Swarm currently mentions AGENTS.md as an entry-point file but doesn't specify the format or the hierarchical override semantics — this is a gap. The right move is to adopt AGENTS.md verbatim and let it be Swarm's repo-root entry point.

### Convergent pattern 4 — skills as progressive disclosure

Anthropic's skills format (October 2025) — a folder containing `SKILL.md` plus optional scripts and references, loaded on demand based on the description field — has been adopted nearly verbatim by OpenAI Codex [S10]. The file format for an agent and a subagent is identical; both are Markdown files with YAML frontmatter — the distinction is entirely behavioural, about the role the instance plays at runtime. Skills carry deep domain knowledge; the description field is the trigger. Swarm's `.agents/skills/` directory and `description` field already match this. Two refinements worth borrowing:

- Skills as folders with subdirectories (`references/`, `scripts/`, `examples/`) for progressive disclosure
- Skill descriptions written for the model ("when should I fire?"), not as summaries of content

### Convergent pattern 5 — context isolation via subagents

This is the single biggest architectural lesson of 2025–2026. Subagents run in separate context windows and report back summaries — since context is the fundamental constraint, subagents are one of the most powerful tools available. Anthropic's research system showed subagents outperforming single-agent setups by 90.2% on breadth-first tasks [S3]. Boris Cherny's rule of thumb: feature-specific subagents (with extra context and skills) beat general "qa" or "backend engineer" agents [S6]. Superpowers dispatches a fresh subagent per task with two-stage review [S9]. Swarm doesn't currently address subagent strategy at all — every task in Swarm runs in a single session. This is a meaningful gap (see §"applicability" below).

### Divergent pattern 1 — single-threaded writes vs. orchestrator-worker

This is the most important strategic question in agentic coding right now.

- **Cognition's position (June 2025, _Don't Build Multi-Agents_):** Most multi-agent setups in the world are limited to "readonly" subagents like web search and code search, because of context-engineering constraints. Their argument: agents making independent decisions in parallel produce inconsistent results because they lack each other's context. Devin therefore runs a single agent thread for writes [S1].
- **Anthropic's position (also June 2025):** Their Research system uses an orchestrator-worker pattern. A Lead Researcher agent decomposes a query, spawns parallel subagents (each in its own context window), and synthesizes results [S3]. Internal evaluations: 90.2% improvement over single-agent on breadth-first tasks [S3].
- **Cognition's reversal (April 2026):** _Multi-Agents: What's Actually Working_ [S2]. Walden Yan now writes that a narrower class works, where agents contribute intelligence while writes stay single-threaded. The synthesis: read-side parallelism is fine; write-side parallelism causes coordination failure.

The field has converged on this synthesis. Multi-agent is good for research, exploration, and review. Single-threaded for writes. Swarm's implicit assumption is single-threaded, but it doesn't say so — it should make this explicit.

### Divergent pattern 2 — persona ceremony

Three distinct points on the spectrum:

- **Spec Kit (low ceremony):** No personas at all. The user is the orchestrator; commands like `/specify`, `/plan`, `/tasks` structure prompts to a single agent. Tool-agnostic, works with 30+ coding agents [S7].
- **Superpowers (mid ceremony):** No named human-style personas. Skills represent practices (TDD, debugging, code review) and skills can dispatch subagents that are also skill-driven. The discipline lives in the skills, not in characters [S9].
- **BMAD-METHOD (high ceremony):** 21+ named personas — Mary the Analyst, Preston the PM, Winston the Architect, Sally the PO, Simon the SM, Devon the Dev, Quinn the QA. The BMad Master Orchestrator coordinates handoffs through YAML configs [S8]. Several reviewers note the coordination overhead and learning curve [S14].

Swarm sits between Superpowers and BMAD: 13 personas, but they describe mindsets (Builder, Skeptic, Specifier) rather than roleplaying named characters. No "BMad Master." This is a defensible middle position. The risk is BMAD-style ceremony creeping in. The hedge against it is that Swarm's persona profiles are short (one screen), have hard rules and forbidden actions, and the task-type-to-persona mapping is rigid (so the agent never picks).

### Divergent pattern 3 — TDD as iron law vs. flexible

- **Superpowers takes a hard line:** Code written before the test gets deleted. Their TDD skill enforces RED-GREEN-REFACTOR with no exceptions. The skill includes a "red flags" list of rationalizations the agent is most likely to use to skip the rule [S9].
- **BMAD treats QA as a separate phase** — Quinn the QA Engineer takes over after Devon the Dev finishes.
- **Spec Kit, Cognition, and Anthropic** treat tests as part of the spec's acceptance criteria but don't enforce ordering.

Swarm currently treats Test Authoring as a standalone task type with a Test Engineer persona, and validation gates require tests to pass — but doesn't mandate test-first ordering inside Feature Development. This is a deliberate choice (Swarm is general-purpose), but the question remains open.

### Divergent pattern 4 — session start hooks

Superpowers ships a session-start hook that injects a short bootstrap document — reportedly under two thousand tokens — telling the agent to invoke a relevant skill before it does anything else [S9]. This is what makes the framework work in practice: skills don't apply themselves; the hook ensures they're considered. Swarm relies on the gatekeeper skill being loaded, but doesn't specify how. This is an operational gap.

### Convergent pattern 6 — gitignored task-local files

This is universal and quiet — every framework that has thought hard about it ends up gitignoring task scratch files. Swarm matches.

---

## Comparison table

|                            | Spec Kit         | BMAD-METHOD          | Superpowers                 | Cognition / Devin  | Anthropic Research    | Swarm                          |
| -------------------------- | ---------------- | -------------------- | --------------------------- | ------------------ | --------------------- | ------------------------------ |
| Primary unit of work       | Spec command     | Story file           | Skill-driven task           | Devin session      | Lead Researcher query | Task file                      |
| Spec required for features | Yes              | Yes (PRD + arch)     | Yes (after brainstorming)   | Implicit (plan.md) | N/A (research)        | Yes                            |
| Personas                   | None             | 21+ named characters | None (skill-based)          | None               | Lead + Subagents      | 13, mindset-based, 1:1 to task |
| Skills format              | n/a              | YAML workflows       | SKILL.md (Anthropic format) | n/a                | SKILL.md              | SKILL.md                       |
| Subagent strategy          | n/a              | Persona-handoff      | Subagent-per-task           | Read-only only     | Orchestrator-worker   | **Not addressed**              |
| Validation enforcement     | Manual           | QA agent phase       | TDD iron law                | CI before merge    | Citation agent        | Named gate slots               |
| Cross-tool portability     | Yes (30+ agents) | Yes (multi-IDE)      | Yes (6 hosts)               | Devin-only         | Anthropic-only        | **Tool-agnostic by design**    |
| Session start hook         | n/a              | YAML state           | Bootstrap doc               | Cloud session      | n/a                   | **Not specified**              |
| Sequencing rules           | Implicit         | Phase-based          | Skill-based                 | Implicit           | Orchestration prompts | **Explicit gatekeeper rules**  |

---

## Where Swarm is well-positioned

1. **Task-as-source-of-truth framing.** Most frameworks lead with the spec or the persona. Swarm leads with the task and arranges everything else around it. This is closer to how Cognition describes Devin internally [S40] and matches IndyDevDan's "talk to your lead agent" framing for 2026 [S12].

2. **Explicit forbidden flows.** No other framework I found writes them out as a table the way Swarm does. Spec Kit, Superpowers, BMAD all have these implicitly. Making them explicit is genuinely novel.

3. **Persona ceremony pitched correctly.** Mindsets, not characters. Hard rules and forbidden actions, not roleplay. Rigid 1-to-1 task mapping so the agent never chooses. This is a better middle ground than anything I found.

4. **Tool-agnostic validation gates.** Most frameworks bake in `pnpm test` or `cargo check`. Swarm's named-slot approach is portable in a way the others aren't.

5. **Distillation directionality.** The unidirectional flow (research → spec → task → code → audit) matches the universal pattern but Swarm states it as a hard constraint rather than a convention. The "code → spec back-fill is forbidden" rule isn't stated anywhere else I found, even though everyone implicitly believes it.

---

## Where Swarm has gaps

These are concrete, not theoretical. The field has answers; Swarm doesn't.

### Gap 1 — no subagent strategy

This is the largest gap. Every serious framework treats subagents as essential for context preservation. Swarm currently runs every task in one session. This is fine for small tasks, but for non-trivial work with codebase exploration, it produces the "context pollution" failure Cognition and Anthropic both identify [S1, S3, S6].

**What to add:** A new section in the framework spec on **subagent strategy**. Specifically:

- Research, Audit, and Review tasks should run in subagents by default — they explore widely and report a digest.
- Implementation tasks should run in the main session unless they require investigative work, in which case a research subagent does the investigating and reports back.
- Adopt the Cognition/Anthropic synthesis: read-side parallelism allowed, write-side single-threaded.

### Gap 2 — AGENTS.md not specified

The field has standardized on AGENTS.md (Linux Foundation now). Swarm mentions it in passing but doesn't:

- Specify the format expectations (the open standard does)
- Specify hierarchical override semantics (Codex does, with `AGENTS.override.md`)
- Specify where Swarm's gate-command bindings live inside it

**What to add:** A small `§AGENTS.md anatomy` subsection in the spec. State that AGENTS.md is the canonical entry point, follows the open standard at agents.md, and is where repo-specific gate command bindings live.

### Gap 3 — no session start hook

Superpowers' bootstrap hook is the operational glue that makes a skills framework actually work. Without it, the agent has to be told to load skills, which means humans hold the discipline. Swarm has the same risk.

**What to add:** A specification for a session-start instruction injected via AGENTS.md or an equivalent mechanism (Claude Code hooks, Codex skills auto-loading) that tells the agent: "First action — read your task file and the gatekeeper skill. Then proceed." This is one paragraph but it's load-bearing.

### Gap 4 — no "iron law" pattern in skills

Superpowers' write-skills introduces a structural pattern: every skill opens with a non-negotiable rule (an "iron law"), followed by a table of "red flags" — the rationalizations the agent is most likely to use to skip the rule. These read like a senior engineer's code-review feedback codified into instructions; the target is not teaching the agent, because it already knows the rules [S9].

Swarm's persona profiles have "Hard rules" and "Forbidden actions" — close, but missing the red-flag pattern. Borrowing it would tighten the personas significantly.

**What to add:** Update the persona profile format (§7.1 in the framework spec) to include a `## Red flags` subsection — concrete rationalizations the agent should refuse, in the persona's voice.

### Gap 5 — research is reactive, not proactive

Several frameworks (Superpowers, IndyDevDan, gstack) treat research as something the agent does aggressively before planning, with the brainstorming-skill or equivalent forcing clarifying questions before any code is written. Swarm currently treats Research as a standalone task type that produces a research file. That's correct but incomplete — it doesn't tell the agent to invoke research proactively when scope is unclear.

**What to add:** Either a "research pre-flight" rule in the gatekeeper, or a Brainstorm task type. Brainstorm is closer to what the field calls it. (See open question below.)

### Gap 6 — memory across sessions

Cognition's plan.md, Anthropic's persistent memory in the Lead Researcher, Devin's session-handoff to cloud — every serious framework addresses what survives between sessions. Swarm's task file is gitignored and worktree-local; durable findings migrate to audits/specs/research. That's the right approach. But Swarm doesn't say what happens when a task spans multiple sessions in the same worktree, or how a long-running task survives a context-window reset.

**What to add:** A `§ Session resumption` subsection. Mostly: the task file's `## Next steps`, `## Decisions`, `## Findings`, and `## Self-review` sections together act as the resumption record. Anthropic's "rainbow deployment" pattern (don't update agent versions while sessions are running) might be relevant for production deployments, but probably out of scope for a documentation framework.

---

## Tradeoffs and risks specific to Swarm's positioning

**Risk: Swarm is heavier than Spec Kit but less battle-tested than BMAD.** Spec Kit users get spec-first benefits with one CLI install. BMAD users get a complete role-based development pipeline that's been validated in production. Swarm sits between, which is the correct philosophical position but a harder sell unless someone bootstraps a real project with it.

**Mitigation:** Build a bootstrap pack that generates the minimum scaffolding (templates, skills, AGENTS.md) for a new repo. Swarm is more ergonomic when you don't have to write the templates yourself.

**Risk: The 13 task types could ossify.** New task patterns will emerge (e.g., agent-to-agent integration testing, long-context summarization, MCP server authoring). The framework needs a version-bumping convention.

**Mitigation:** Already addressed by the "if a recurring real-world task can't be served, the catalogue grows" rule. Just make it explicit that the catalogue is versioned.

**Risk: The persona/task rigid mapping breaks for genuinely hybrid work.** A bug fix that requires research before fixing is two tasks in Swarm; some frameworks (BMAD) handle this with a single task that hands off across personas. The split-vs-merge tradeoff is real.

**Mitigation:** The framework already says "split it." Practice will tell whether splitting is cheap or expensive in real workflows.

---

## Recommendation

Swarm is intellectually aligned with the bleeding edge — its core ideas (task-as-source-of-truth, downhill distillation, mindset-based personas, named validation slots, gitignored task files) match what the field has converged on. Where it differs from common practice, it usually differs in a defensible direction.

The framework has six specific operational gaps the field has already solved:

1. **Adopt the AGENTS.md open standard** as the entry point. Specify format and override semantics.
2. **Add a subagent-strategy section.** Adopt the Cognition/Anthropic synthesis: read-side parallelism allowed, write-side single-threaded.
3. **Specify a session-start mechanism** (Superpowers-style bootstrap hook, or AGENTS.md-driven equivalent).
4. **Add a "red flags" subsection to persona profiles** — borrow the Superpowers pattern.
5. **Make research proactive** — either a gatekeeper pre-flight rule or a Brainstorm task type.
6. **Specify session-resumption semantics** — mostly already implied by the task file structure, just needs to be written.

If these six are addressed, Swarm becomes the most principled documentation-first framework in the space — more rigorous than Spec Kit, less ceremony than BMAD, and better positioned for tool portability than Superpowers (which is Anthropic-format-only despite multi-host support). The biggest single thing missing is the subagent strategy. That's the one that should land first.

---

## Open questions

- [ ] **[MAJOR]** Should Swarm add a Brainstorm task type, or fold it into the start of Research/Spec Authoring? Field is split. Superpowers makes brainstorming a skill; BMAD has it as a workflow phase; Spec Kit folds it into `/specify`.
- [ ] **[MAJOR]** Should subagents map 1-to-1 to task types, or should Swarm define a separate "subagent recipe" layer? Anthropic's docs treat subagents as orthogonal to agents [S32]. Swarm could too.
- [ ] **[MINOR]** Should the framework adopt Superpowers' "iron law + red flags" pattern wholesale for all `write-<type>` skills as well, not just personas?
- [ ] **[MINOR]** Where do AI-native review patterns (security review agent, dependency-graph audit agent, etc.) fit? They're Reviews in the catalogue, but the field is treating them as recurring background tasks rather than ad-hoc Reviews.

---

## What this research did not resolve

- Whether the convergence around AGENTS.md will hold or whether a vendor will fragment it (Cursor's `.cursor/rules/` and Claude's `.claude/skills/` already coexist).
- Whether Anthropic's orchestrator-worker pattern transfers to coding tasks. Anthropic's own engineering docs are explicit that multi-agent systems excel at problems that can be divided into parallel strands of research, but are less effective for tightly interdependent tasks such as coding [S60]. The Cognition reversal qualifies this but doesn't refute it.
- Long-term cost. Multi-agent systems consume roughly 15× more tokens than single-agent chats [S60]. This is fine for research workflows but punishing for routine implementation work.
- Memory. None of the frameworks I read have a satisfactory answer for cross-session, cross-worktree, cross-project knowledge accumulation. This is probably the next frontier.
