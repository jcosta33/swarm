---
type: research
id: plan-validation-survey
status: draft
date: 2026-06-11
sources: [report-1, report-2, report-3, web]
---

# Survey: external validation of the Swarm repositioning plan

Which of the plan's decisions does external evidence support, contradict, or leave open?

## Method

Eight evidence lanes (A competitors, B DX feedback, C review bottleneck, D structured requirements, E brownfield transformation, F official vendor guidance, G workspace topology, H adversarial counter-evidence) gathered web evidence against decisions D1–D15; all observations dated, most made 2026-06-11 against live repos/docs.
Every pattern claim ("common practice", "most tools") rests on ≥3 named, URL-checkable instances; competitor behavior is grounded in the working product (repo trees, command docs, issues), never landing-page marketing; observation (what a product does / a study measured) is kept separate from claim (what someone asserts) and vendor-claim (unaudited self-reported numbers).
Anything not confirmable at a checkable source is marked UNVERIFIED and never asserted; where sources disagree, both sides are presented; no instance was invented to reach three — claims were downgraded instead.

## Verdict map

| Decision | Verdict | Grounding findings |
|---|---|---|
| D1 identity: lightweight spec + review workflow | SUPPORTED-WITH-CAVEATS | V-001–V-005 (caveats: V-002 naming collision, V-003 live counter-position, V-043/H framing) |
| D2 six-step loop + 2 conditionals; nine-step demoted | SUPPORTED-WITH-CAVEATS | V-006–V-010 (caveat: V-008 — file count, not step count, draws the fire) |
| D3 two-tier spec format (plain AC default, SOL/EARS optional) | SUPPORTED | V-011–V-018 |
| D4 plain .md + frontmatter `type:`; no custom extension | SUPPORTED | V-019, V-020 |
| D5 external Git spec store as enterprise default | MIXED | V-021–V-025 (contradicted within the competitor set; supported at RFC/requirements granularity) |
| D6 intake artifact (verbatim ticket snapshot) | UNVERIFIED-open | V-026, V-027 (no precedent either way; adjacent demand is for integration, not snapshots) |
| D7 pristine code repos; future gitignored `.swarm/` | MIXED | V-028–V-030 (gitignored-state half has direct vendor precedent; nothing-committed half contradicts every competitor and vendor commit guidance) |
| D8 honesty framework + soft ~100-line AGENTS.md cap | SUPPORTED-WITH-CAVEATS | V-031–V-034 (caveat: the ~100 figure is Swarm's own invention, V-033) |
| D9 minimal starter kit (12-file copy surface) | SUPPORTED | V-035, V-036 (pressure from V-008) |
| D10 three flagship examples; large-PR-review demo | UNVERIFIED-open | V-037 (weak indirect support; competitor example-completeness never checked) |
| D11 separate swarm-cli; hard-errors vs warnings | SUPPORTED-WITH-CAVEATS | V-038–V-042 (caveats: competitors already ship validators; CLI maintenance is publicly monitored) |
| D12 review packet as product wedge | SUPPORTED-WITH-CAVEATS | V-043–V-050 (best-evidenced premise in the plan; three required framing corrections + one unmitigated risk, V-050) |
| D13 Change Plan + Inventory for structural work | SUPPORTED-WITH-CAVEATS | V-051–V-057 (causal benefit of the document itself is UNVERIFIED, V-057) |
| D14 lightweight findings/memory + status board | UNVERIFIED-open | V-058, V-059 (status board has named demand; findings/memory value ungrounded; drift unanswered) |
| D15 worktree-per-task isolation | SUPPORTED-WITH-CAVEATS | V-060–V-062 (isolation supported; high-fanout parallelism marketing contradicted) |

## Findings

### D1 — identity and promise

**V-001** · **Claim:** Heavyweight SDD ceremony is the most-documented, multi-voice, partly measured complaint against incumbent spec tools. · **Type:** measurement + observation · **Evidence:** Eberhardt/Scott Logic 2025-11-26: Spec Kit feature = 689 LOC from 2,577 lines of markdown, 33.5 min agent time + 3.5 h human review vs ~15 min iterative baseline (https://blog.scottlogic.com/2025/11/26/putting-spec-kit-through-its-paces-radical-idea-or-reinvented-waterfall.html); Zaninotto/Marmelab 2025-11-12: "8 files and 1,300 lines of text" for a trivial feature (https://marmelab.com/blog/2025/11/12/spec-driven-development-waterfall-strikes-back.html); Böckeler/martinfowler.com 2025-10-15: "very verbose and tedious to review" (https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html); spec-kit Discussion #1784 "illusion of work" (22 upvotes, https://github.com/github/spec-kit/discussions/1784); Eretz Kdosha 3-tool benchmark 2026-04-13: BMAD "heavy and hard to review" vs OpenSpec "lightest footprint" best overall (https://ranthebuilder.cloud/blog/i-tested-three-spec-driven-ai-tools-here-s-my-honest-take/) · **Confidence:** high · **Bears on:** D1, D2, D9 · **Direction:** supports (the lightweight repositioning; contradicts any heavyweight default)

**V-002** · **Claim:** The #2 OSS spec tool (OpenSpec, 54,246 stars 2026-06-11) won its position by positioning verbatim against heavyweight/rigid/greenfield-only SDD — the plan's direction, but also meaning "lightweight/minimal-ceremony" language is already occupied. · **Type:** observation · **Evidence:** OpenSpec README philosophy block "fluid not rigid / iterative not waterfall / easy not complex / built for brownfield" (https://github.com/Fission-AI/OpenSpec/blob/main/README.md); 5-core/6-expanded command profiles (https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md); third-party comparison (https://avasdream.com/blog/openspec-vs-spec-kit-ai-development); benchmark rating it lowest-friction (https://ranthebuilder.cloud/blog/i-tested-three-spec-driven-ai-tools-here-s-my-honest-take/) · **Confidence:** high · **Bears on:** D1, D2, D9 · **Direction:** supports (with a differentiation caveat on the word "lightweight")

**V-003** · **Claim:** The SDD debate is contested, not settled — a measured head-to-head once favored iterative prompting over the spec pipeline, while named defenders and successful retainers argue the opposite. · **Type:** claim (both sides named) · **Evidence:** against: Eberhardt "not a viable process" (URL in V-001); HN zvr "writing specs much harder than writing code" (https://news.ycombinator.com/item?id=45935763); for: HN canterburry "A spec is not a prompt… definition of how to tell if something is behaving as intended" (same thread); alexcloudstar "redefinition of work" (https://www.alexcloudstar.com/blog/spec-driven-development-2026/); Ask HN 2026-02-03 retainers reporting reliable brownfield results (https://news.ycombinator.com/item?id=46864948) · **Confidence:** high that the debate exists · **Bears on:** D1 · **Direction:** mixed (a lightweight entry conceding the ceremony critique is the defensible middle)

**V-004** · **Claim:** Anthropic's official best-practices doc recommends a spec-first pipeline nearly identical to D1's promise: interview → self-contained SPEC.md naming files/interfaces, out-of-scope, and an end-to-end verification step → fresh-session execution. · **Type:** official-guidance · **Evidence:** https://code.claude.com/docs/en/best-practices ("Let Claude interview you"; "The most useful specs are self-contained… end with an end-to-end verification step"); Explore→Plan→Implement→Commit workflow (same page); "Building Effective Agents" simplicity doctrine (https://www.anthropic.com/research/building-effective-agents) · **Confidence:** high · **Bears on:** D1, D2, D3 · **Direction:** supports

**V-005** · **Claim:** Positioning confusion is a documented failure of the category leader — strong evidence that a one-line identity plus an explicit "how this differs from AGENTS.md" answer is needed. · **Type:** observation · **Evidence:** spec-kit maintainer published an explainer post, title/date/author confirmed, body UNVERIFIED (den.dev 403s; https://den.dev/blog/github-spec-kit/, corroborated via https://notes.hello-data.nl/artificial-intelligence/whats-the-deal-with-github-spec-kit-den-delimarsky); HN launch question "How is this distinct from… README.md, AGENTS.md…?" (https://news.ycombinator.com/item?id=45154355); spec-kit #2625 guided-entry demand (https://github.com/github/spec-kit/issues/2625); #880/#1088 tracker-vs-spec confusion (https://github.com/github/spec-kit/issues/880, https://github.com/github/spec-kit/issues/1088) · **Confidence:** medium (one instance body unverified) · **Bears on:** D1, D10 · **Direction:** supports

### D2 — the six-step loop

**V-006** · **Claim:** Observed core flows across all five surveyed tools are 3–5 steps, and every tool tiers ceremony with an optional/advanced layer — a six-step headline with two conditionals and a demoted nine-step reference matches the universal tiering move but sits at the top of the observed range. · **Type:** observation · **Evidence:** Spec Kit 5 core + 4 optional commands (https://github.com/github/spec-kit README); Kiro 3 gated phases + gate-free Quick Plan (https://kiro.dev/docs/specs/quick-plan/); OpenSpec 5 core + 6 expanded behind a profile switch (https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md); BMAD 4 phases + Quick Flow (https://github.com/bmad-code-org/BMAD-METHOD) · **Confidence:** high · **Bears on:** D2 · **Direction:** supports (with the at-the-top caveat)

**V-007** · **Claim:** Mandatory full-pipeline ceremony for small changes is the canonical complaint against gated spec tools, conceded even by friendly reviewers — the direct case for D2's conditional steps and risk scaling. · **Type:** observation · **Evidence:** Böckeler: small bug → "4 user stories with… 16 acceptance criteria… a sledgehammer to crack a nut" (https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html); Martinelli 2026-03-29: "A single-line bug fix… should not trigger a full spec generation pipeline" (https://martinelli.ch/why-spec-driven-development-tools-fail-in-the-enterprise/); fikuri Kiro review (https://dev.to/fikuri/kiro-the-good-bad-and-ugly-part-in-my-personal-experience-1neh); morphllm comparison (https://www.morphllm.com/comparisons/kiro-vs-cursor) · **Confidence:** high · **Bears on:** D2, D1 · **Direction:** supports — provided the loop visibly allows skipping Spec for trivial work

**V-008** · **Claim:** In the market, "lightweight" means few commands, not few files — artifact volume per change is what drew the "illusion of work" fire, and Swarm's 6 core artifacts + intake + status is in line with, not below, the complained-about zone. · **Type:** observation · **Evidence:** OpenSpec still creates 4 artifacts per change while marketed minimal (https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md); Spec Kit's 7–8 files/feature drew #1784's fire (https://github.com/github/spec-kit/discussions/1784); Eberhardt's 2,577 markdown lines (https://blog.scottlogic.com/2025/11/26/putting-spec-kit-through-its-paces-radical-idea-or-reinvented-waterfall.html) · **Confidence:** high · **Bears on:** D2, D9, D12 · **Direction:** mixed (pressures the plan to make most artifacts optional in practice, not just in tiering rhetoric)

**V-009** · **Claim:** Anthropic officially canonizes simple-before-complex and skip-the-plan-when-trivial — vendor backing for demoting the nine-step lifecycle. · **Type:** official-guidance · **Evidence:** "Building Effective Agents": "find the simplest solution possible, and only increasing complexity when needed" (https://www.anthropic.com/research/building-effective-agents); Claude Code best practices: "If you could describe the diff in one sentence, skip the plan" (https://code.claude.com/docs/en/best-practices); skills doctrine "write minimal instructions" (https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) · **Confidence:** high · **Bears on:** D2, D9 · **Direction:** supports

**V-010** · **Claim:** One practitioner report finds agents executing multi-step structured workflows on larger codebases routinely skip steps, loop, or stall — the loop's value depends on a human or checker walking the steps, not the agent. · **Type:** claim (single source) · **Evidence:** QuantumBlack/McKinsey (https://medium.com/quantumblack/agentic-workflows-for-software-development-dc8e64f4a79d); corroborated in kind by spec non-following reports in V-032/V-044 · **Confidence:** medium · **Bears on:** D2, D8 · **Direction:** mixed

### D3 — two-tier spec format

**V-011** · **Claim:** Structured plain-markdown requirements with stable IDs and modal verbs are the prevailing working-product surface — tier 1's "### AC-001 + Verify with:" matches the dominant pattern. · **Type:** observation · **Evidence:** Spec Kit live template "FR-001: System MUST…" + Given/When/Then + [NEEDS CLARIFICATION] (https://raw.githubusercontent.com/github/spec-kit/main/templates/spec-template.md); OpenSpec "### Requirement:" + SHALL + "#### Scenario:" (https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md); Kiro 3 plain-md files (https://kiro.dev/docs/specs/feature-specs/) · **Confidence:** high · **Bears on:** D3, D1 · **Direction:** supports

**V-012** · **Claim:** EARS ships today as the default requirements notation in a major working product (Kiro), with a verifiable RE'09 Rolls-Royce pedigree and standards/tooling adoption. · **Type:** observation · **Evidence:** Kiro docs "WHEN [condition/event] THE SYSTEM SHALL [expected behavior]" (https://kiro.dev/docs/specs/feature-specs/); Mavin et al., RE'09, DOI 10.1109/RE.2009.9 (https://dl.acm.org/doi/10.1109/RE.2009.9); Intel/Terzakis ICCGI 2013 tutorial (https://www.iaria.org/conferences2013/filesICCGI13/ICCGI_2013_Tutorial_Terzakis.pdf); Jama Connect Requirements Advisor (https://www.jamasoftware.com/requirements-management-guide/writing-requirements/frequently-asked-questions-about-the-ears-notation-and-jama-connect-requirements-advisor/); INCOSE GtWR linkage corroborated at vendor/webinar level only — medium on that sub-point (https://www.incose.org/docs/default-source/working-groups/requirements-wg/guidetowritingrequirements/incose_rwg_gtwr_v4_summary_sheet.pdf) · **Confidence:** high (INCOSE sub-point medium) · **Bears on:** D3 · **Direction:** supports tier 2

**V-013** · **Claim:** Kiro — the only major product shipping EARS — itself converged on exactly a light/strict two-tier split (gate-free Quick Plan vs gated full feature specs), the single best external validation of D3's shape. · **Type:** observation · **Evidence:** https://kiro.dev/docs/specs/quick-plan/ (page updated 2026-05-05): full specs recommended "for complex or unfamiliar work where iteration and review gates add value" · **Confidence:** high · **Bears on:** D3, D2 · **Direction:** supports

**V-014** · **Claim:** Requirement ambiguity measurably degrades LLM code generation across all evaluated models, and models cannot reliably self-identify or resolve it — the burden falls on the spec author/checker, the plan's core premise. · **Type:** measurement · **Evidence:** Orchid benchmark, arXiv:2604.21505, 2026-04-23, 1,304 tasks (https://arxiv.org/abs/2604.21505); HumanEvalComm/TOSEM: >60% of responses generate code instead of asking when descriptions are ambiguous (https://arxiv.org/abs/2406.00215, https://dl.acm.org/doi/10.1145/3715109); ClarEval 2026-02-27: strong coders "lack the strategic communication skills" to clarify (https://arxiv.org/abs/2603.00187) · **Confidence:** high · **Bears on:** D3, D1, D11 · **Direction:** supports

**V-015** · **Claim:** Clarifying or repairing requirements before generation produces measured codegen gains, including with no human in the loop. · **Type:** measurement · **Evidence:** ClarifyGPT (FSE 2024): GPT-4 Pass@1 70.96%→80.80% (https://arxiv.org/abs/2310.10996); REA-Coder: 7.93–30.25% average gains across five datasets (https://arxiv.org/abs/2604.16198); SpecFix: +30.9% Pass@1 on repaired descriptions, transfers across models (https://arxiv.org/abs/2505.07270) · **Confidence:** high · **Bears on:** D3, D11, D12 · **Direction:** supports

**V-016** · **Claim:** EARS is the minority choice among agent tools (1 of 3 major; the others explicitly chose non-EARS structured markdown), with demand visible only as unshipped feature requests — and no evidence was found that EARS notation itself harms adoption (documented limits are narrow: >3 preconditions, training overhead, math-heavy requirements). · **Type:** observation (incl. negative search result) · **Evidence:** spec-kit #1356 EARS request, open, no maintainer commitment (https://github.com/github/spec-kit/issues/1356); OpenSpec non-EARS format (https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md); microsoft/vscode #261160 — title-level verification only (https://github.com/microsoft/vscode/issues/261160); limits: https://qracorp.com/when-not-to-use-ears/, https://www.se-trends.de/en/requirements-with-ears/; positive empirical side: https://link.springer.com/article/10.1007/s42979-025-03843-3, https://ieeexplore.ieee.org/document/10132248/ · **Confidence:** medium-high · **Bears on:** D3 · **Direction:** supports optional placement; cautions against marketing SOL/EARS as "where the industry is going"

**V-017** · **Claim:** Practitioners who retained SDD describe exactly tier-1 practice (AC-centric single specs with verification), while abandoners cite verbosity, rework, and non-reproducibility. · **Type:** observation · **Evidence:** HN canterburry (https://news.ycombinator.com/item?id=45935763); Ask HN 2026-02-03 cherry_tree/Biruk (https://news.ycombinator.com/item?id=46864948); spec-kit #1784 reply amondnet, 20+ projects (https://github.com/github/spec-kit/discussions/1784); abandoners: sholtomaud (https://github.com/github/spec-kit/discussions/1686), Eberhardt (V-001 URL) · **Confidence:** high · **Bears on:** D3, D1, D2 · **Direction:** supports

**V-018** · **Claim:** The EARS blue-chip adoption list (Airbus, Bosch, Dyson, Honeywell, NASA, Siemens…) is the originator's own claim; only Intel is independently corroborated. · **Type:** claim · **Evidence:** https://alistairmavin.com/ears/ (originator); Intel corroboration via the Terzakis tutorial (V-012) · **Confidence:** low as independent fact / high as attributed claim · **Bears on:** D3, D8 · **Direction:** context — UNVERIFIED as independent fact; cite only with attribution

### D4 — plain .md, no custom extension

**V-019** · **Claim:** 4 of 5 surveyed spec tools use plain .md; the sole custom-extension tool (Tessl, mandatory `.spec.md` + required `targets:` frontmatter) is also the spec-as-source philosophy Swarm explicitly rejects. · **Type:** observation · **Evidence:** Spec Kit (https://github.com/github/spec-kit), Kiro (https://kiro.dev/docs/specs/feature-specs/), OpenSpec (https://github.com/Fission-AI/OpenSpec), BMAD (https://github.com/bmad-code-org/BMAD-METHOD) all plain .md; Tessl spec format (https://github.com/tesslio/spec-driven-development-tile/blob/main/docs/spec-format.md, https://docs.tessl.io/use/spec-driven-development-with-tessl) · **Confidence:** high · **Bears on:** D4, D1 · **Direction:** supports

**V-020** · **Claim:** AGENTS.md is an externally verified cross-vendor convention (Linux-Foundation-stewarded; 60k+ projects claimed by two independent named sources; 121,280 files via lane F's own GitHub API query 2026-06-11), with native support in 20+ tools. · **Type:** measurement + observation · **Evidence:** https://agents.md; LF AAIF press release 2025-12-09 (https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation); Codex native walk-down support (https://developers.openai.com/codex/guides/agents-md); Cursor nested support (https://cursor.com/docs/context/rules). API figure counts files, not deduplicated repos — order-of-magnitude corroboration only. · **Confidence:** high · **Bears on:** D4, D8, D9 · **Direction:** supports

### D5 — workspace topology

**V-021** · **Claim:** Every surveyed spec-agent tool stores specs committed inside the code repo — six named instances — and Kiro's official docs recommend committing them; "external Git spec store as the enterprise default" deviates from 100% of observed competitor practice. · **Type:** observation · **Evidence:** Spec Kit `specs/` + `.specify/` (https://github.com/github/spec-kit); Kiro `.kiro/specs/` + commit guidance (https://kiro.dev/docs/getting-started/first-project/, https://kiro.dev/docs/specs/best-practices/ — one sentence medium-confidence); OpenSpec `openspec/` (https://github.com/Fission-AI/OpenSpec); BMAD `_bmad/` (https://github.com/bmad-code-org/BMAD-METHOD); spec-workflow-mcp `.spec-workflow/` (https://github.com/Pimzino/spec-workflow-mcp); Tessl work-specs `specs/` (https://docs.tessl.io/use/spec-driven-development-with-tessl) · **Confidence:** high · **Bears on:** D5, D7 · **Direction:** contradicts (as "common practice"; defensible only as deliberate differentiation)

**V-022** · **Claim:** Observable user demand in the tool space pushes toward more in-repo flexibility (monorepos, subfolders), not externalization; the only external motion is OpenSpec's beta machine-local workspaces/context-stores — explicitly "not a repo", not committed stores. · **Type:** observation · **Evidence:** spec-kit #1026, #581, #516 (https://github.com/github/spec-kit/issues/1026, https://github.com/github/spec-kit/issues/581, https://github.com/github/spec-kit/issues/516); zero issues found for "specs outside"/"separate repository" (gh search 2026-06-11, limited terms — absence caveat); OpenSpec workspaces under ~/.local/share/openspec/ (https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md) · **Confidence:** medium-high · **Bears on:** D5 · **Direction:** contradicts (with a demand-for-cross-repo-coordination nuance from the OpenSpec beta)

**V-023** · **Claim:** External Git/document stores for intent and decisions are real, named, working enterprise practice — at the proposal/RFC/requirements granularity, not the per-feature work-spec granularity. · **Type:** observation · **Evidence:** rust-lang/rfcs (https://github.com/rust-lang/rfcs), golang/proposal (https://github.com/golang/proposal), kubernetes/enhancements (https://github.com/kubernetes/enhancements); Oxide RFD repo (https://rfd.shared.oxide.computer/rfd/0001); HashiCorp Drive-based PRDs/RFCs (https://www.hashicorp.com/how-hashicorp-works/articles/writing-practices-and-culture); Sourcegraph RFCs as Google Docs (https://github.com/sourcegraph/handbook/blob/main/content/company-info-and-process/communication/rfcs/index.md); GitLab handbook repo (https://gitlab.com/gitlab-com/content-sites/handbook); requirements-management category Jama/DOORS/Polarion/Codebeamer (https://www.inflectra.com/tools/comparisons/doors-vs-jama-connect, https://www.ptc.com/en/products/codebeamer/more-than-just-requirements-management); Devin Knowledge (https://docs.devin.ai/product-guides/knowledge) · **Confidence:** high · **Bears on:** D5 · **Direction:** supports (D5's honest lineage: "a Git-native, agent-readable form of the external requirements store enterprises already run")

**V-024** · **Claim:** Externalized intent documents carry practitioner-documented failure modes — drift from reality and discoverability decay — while the colocation counter-philosophy (docs-as-code, in-repo ADRs, TechDocs) is mature, named, and cites atomic doc+code change and merge gating as benefits. · **Type:** observation · **Evidence:** Google design-docs drift account (https://www.industrialempathy.com/posts/design-docs-at-google/); Write the Docs docs-as-code (https://www.writethedocs.org/guide/docs-as-code/); Nygard ADRs in-repo (https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions); Google Cloud ADR guidance — in-repo default, central wiki named alternative for non-engineer access (https://docs.cloud.google.com/architecture/architecture-decision-records); Backstage TechDocs (https://backstage.io/docs/features/techdocs/); abandoned central ADR repo LBHackney-IT/lbh-adrs, archived 2024-04-03, reason unknown (https://github.com/LBHackney-IT/lbh-adrs) · **Confidence:** high · **Bears on:** D5, D14 · **Direction:** contradicts

**V-025** · **Claim:** All four major vendors' context-loading machinery is repo-rooted, so an external workspace forfeits automatic context loading; and Swarm's only dogfooding adopter (swarm-cli) co-locates its spec suite in the code repo — the external default ships with zero dogfooding evidence. · **Type:** observation · **Evidence:** Codex AGENTS.md root-walk (https://developers.openai.com/codex/guides/agents-md); Claude Code nested CLAUDE.md (https://code.claude.com/docs/en/best-practices); Gemini CLI JIT GEMINI.md scan (https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/gemini-md.md); Cursor `.cursor/rules` (https://cursor.com/docs/context/rules); local observation: /Users/josecosta/dev/swarm-cli/specs/001–009 co-located (2026-06-11) · **Confidence:** high · **Bears on:** D5, D7 · **Direction:** contradicts/mixed

### D6 — intake artifact

**V-026** · **Claim:** No surveyed tool has an intake artifact (verbatim upstream-ticket snapshot with URL+timestamp); where tracker integration exists it runs outbound (Spec Kit `/speckit.taskstoissues` exports tasks to issues). · **Type:** observation (absence within primary surfaces) · **Evidence:** Spec Kit README command table (https://github.com/github/spec-kit); OpenSpec commands doc (https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md); BMAD workflow map (https://github.com/bmad-code-org/BMAD-METHOD); Kiro docs (https://kiro.dev/docs/specs/) — none mention ticket ingestion; not exhaustive · **Confidence:** medium (absence claim) · **Bears on:** D6, D12 · **Direction:** context — novel, no precedent to copy and no contradiction

**V-027** · **Claim:** The adjacent demand that exists is for tracker integration and workflow-status visibility, not snapshots — D6's zero-connector snapshot is the manual version of what users actually requested and will likely draw the same integration requests. · **Type:** observation · **Evidence:** spec-kit #880 (https://github.com/github/spec-kit/issues/880); #1088 (https://github.com/github/spec-kit/issues/1088); Eretz Kdosha: "No help command or status view: the tool doesn't tell you where you are" (https://ranthebuilder.cloud/blog/i-tested-three-spec-driven-ai-tools-here-s-my-honest-take/) · **Confidence:** high · **Bears on:** D6, D14 · **Direction:** mixed (supports the underlying need; the snapshot form itself is unvalidated)

### D7 — pristine code repos

**V-028** · **Claim:** Every named competitor commits a tool/spec dir into the code repo; no agent-spec tool was found keeping the code repo pristine — D7 is a genuine differentiator with no market precedent in either direction. · **Type:** observation · **Evidence:** the six instances of V-021 (Spec Kit, Kiro, OpenSpec, BMAD, spec-workflow-mcp, Tessl) · **Confidence:** high · **Bears on:** D7, D5 · **Direction:** contradicts (as common practice; the differentiation cost is untested — see V-030)

**V-029** · **Claim:** The vendor norm is a split inside the repo — shared config committed (CLAUDE.md, .claude/settings.json, .claude/skills/, .cursor/rules), local/ephemeral state gitignored (settings.local.json, CLAUDE.local.md, .claude/worktrees/) — so D7's future gitignored `.swarm/` has an exact vendor precedent, while its "nothing committed beyond a pointer" half runs against what every vendor tells teams to commit. · **Type:** observation · **Evidence:** Claude Code settings (https://code.claude.com/docs/en/settings); best practices "Check CLAUDE.md into git" (https://code.claude.com/docs/en/best-practices); worktrees doc "Add .claude/worktrees/ to your .gitignore" (https://code.claude.com/docs/en/worktrees); Cursor rules "version-controlled" (https://cursor.com/docs/context/rules); Codex state in ~/.codex (https://developers.openai.com/codex/guides/agents-md) · **Confidence:** high · **Bears on:** D7 · **Direction:** mixed

**V-030** · **Claim:** The market preference between drop-in committed dirs (what all competitors ship and users evidently tolerate) and a pristine repo with run-time task hand-off (D7) is undocumented and untested. · **Type:** claim · **Evidence:** absence across lanes A/F/G after targeted searches; no checkable source either way · **Confidence:** high that the gap exists · **Bears on:** D7 · **Direction:** UNVERIFIED — open

### D8 — honesty framework and the ~100-line cap

**V-031** · **Claim:** Anthropic officially draws the exact advisory-vs-deterministic line D8 formalizes: "Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and guarantee the action happens." · **Type:** official-guidance · **Evidence:** https://code.claude.com/docs/en/best-practices (quote; plus "over-specified CLAUDE.md" failure pattern and "Ruthlessly prune") · **Confidence:** high · **Bears on:** D8 · **Direction:** supports

**V-032** · **Claim:** Cross-tool instruction non-compliance is documented at scale — agents read, acknowledge, then violate context-file rules — making honesty labels (convention ≠ enforced) the only defensible framing and undermining any plan surface that assumes guide compliance. · **Type:** observation + measurement · **Evidence:** anthropics/claude-code issues #34197, #27750, #30421, #33456, #32161 (https://github.com/anthropics/claude-code/issues/34197 et seq.; 9 named issues Dec 2025–May 2026); openai/codex #25884 "soft hint than a durable operating constraint" (https://github.com/openai/codex/issues/25884); Cursor silent rule failures (https://www.pathrule.io/writing/why-cursor-rules-get-silently-ignored); IFScale benchmark: best models 68% accuracy at 500 simultaneous instructions, primacy bias (https://arxiv.org/abs/2507.11538); yajin.org case study — fix was 3 rules + hooks, not more markdown (https://yajin.org/blog/2026-03-22-why-ai-agents-break-rules/) · **Confidence:** high · **Bears on:** D8, D9, D2, D11 · **Direction:** supports D8's labels; contradicts assumed compliance anywhere in the plan

**V-033** · **Claim:** No vendor publishes a ~100-line cap for agent context files — the published numeric bounds are 500 lines (Cursor rules; Anthropic SKILL.md body) and 32 KiB (Codex AGENTS.md budget), with community guidance spread 100–750 lines — so the ~100 figure is Swarm's own convention, 2–5x stricter than any vendor number. · **Type:** observation · **Evidence:** https://cursor.com/docs/context/rules ("under 500 lines"); https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices ("under 500 lines"); https://developers.openai.com/codex/guides/agents-md (32 KiB default); community spread: https://www.humanlayer.dev/blog/writing-a-good-claude-md, https://dev.to/nishilbhave/claudemd-best-practices-the-complete-2026-guide-435j, dissent ~750 lines (https://news.ycombinator.com/item?id=46864948) · **Confidence:** high · **Bears on:** D8 · **Direction:** mixed — soft "aim for" framing is vendor-aligned; the number must be presented as Swarm's own, not ecosystem-derived

**V-034** · **Claim:** Requirements-smell impact is real but noisy and task-dependent — direct evidence for D8's "lint codes as review checklists" and D11's hard-error/warning split rather than enforced floors. · **Type:** measurement · **Evidence:** Vogelsang et al. ICSE-NIER 2025: smells affected requirement-implementation prediction but not line-level tracing (https://arxiv.org/abs/2501.04810); Gentili & Falessi smell characterization (https://arxiv.org/abs/2404.11106); Femmer et al. detection-precision limits (https://arxiv.org/pdf/1611.08847) · **Confidence:** high · **Bears on:** D8, D11 · **Direction:** supports

### D9 — minimal starter kit

**V-035** · **Claim:** A 12-file copy surface sits at the lean end of the observed scaffold range — between Tessl's tile and Spec Kit's ~19–20 files, an order of magnitude under BMAD's 227 skill source files. · **Type:** observation · **Evidence:** Spec Kit `.specify/` ~19–20 files + 7–8/feature (https://github.com/github/spec-kit); BMAD 189+38 skill files via git tree (https://github.com/bmad-code-org/BMAD-METHOD); Kiro 3 files/spec (https://kiro.dev/docs/specs/feature-specs/); Tessl tile 4 skills/3 rules/2 scripts (https://github.com/tesslio/spec-driven-development-tile) · **Confidence:** high · **Bears on:** D9, D2 · **Direction:** supports

**V-036** · **Claim:** Vendor doctrine — progressive disclosure, minimal always-loaded surface, action-named skills, personas expressed as subagents not skills — matches the kit's core/advanced split and the folding of persona-* skills into task guides. · **Type:** official-guidance (persona inference medium) · **Evidence:** https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices (metadata-only preload; gerund/action naming; "Provide a default (with escape hatch)"); https://code.claude.com/docs/en/best-practices (skills for sometimes-relevant knowledge; persona worked example is a subagent); https://cursor.com/docs/context/rules (composable rules); Gemini @file imports (https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/gemini-md.md) · **Confidence:** high (naming inference medium) · **Bears on:** D9, D2, D14 · **Direction:** supports

### D10 — flagship examples

**V-037** · **Claim:** Demand for complete worked examples (real specs, real session evidence) is voiced but thin — three indirect voices, no issue literally requesting it — and whether competitor flagship docs lack complete ticket→review examples was never checked. · **Type:** observation · **Evidence:** HN CraigJPerry "such a rare (but valued!) occurrence" (https://news.ycombinator.com/item?id=45935763); HN esafak "Let's see some of those specs" (https://news.ycombinator.com/item?id=47197595); independent walkthrough blogs filling the gap (https://hubreb.github.io/blog/spec-kit-brownfield-implementation) · **Confidence:** medium · **Bears on:** D10 · **Direction:** supports weakly; competitor-gap half UNVERIFIED

### D11 — swarm-cli and the check split

**V-038** · **Claim:** OpenSpec proves the exact pattern D11 plans — markdown conventions + a deterministic validator with a severity split (`openspec validate --strict --json`, valid vs warning, CI-compatible) — while the category leader (Spec Kit) ships no deterministic checker, only LLM prompts. · **Type:** observation · **Evidence:** OpenSpec CLI docs (https://github.com/Fission-AI/OpenSpec/blob/main/docs/cli.md); Spec Kit /speckit.analyze + /speckit.checklist are LLM prompts (https://github.com/github/spec-kit templates/commands/analyze.md, README) · **Confidence:** high · **Bears on:** D11, D8 · **Direction:** supports — with the structural note that OpenSpec couples format and CLI in one repo vs Swarm's separate-repo plan

**V-039** · **Claim:** Spec validation is both shipped by competitors and actively demanded by users — a real, not speculative, need with a short remaining gap window for "checklists until a linter ships". · **Type:** observation · **Evidence:** OpenSpec validate (above); Kiro "deep spec analysis" product feature (https://kiro.dev/blog/deep-spec-analysis/); OpenSpec #880 user proposal for code-vs-spec validation (https://github.com/Fission-AI/OpenSpec/issues/880); HN "Verified Spec-Driven Development" 211 points (https://news.ycombinator.com/item?id=47197595) · **Confidence:** high · **Bears on:** D11, D8 · **Direction:** supports

**V-040** · **Claim:** Automated requirement checking and repair measurably works and transfers across models — empirical ceiling-raisers for what a swarm-cli spec-check could do. · **Type:** measurement · **Evidence:** SpecFix (https://arxiv.org/abs/2505.07270); ClarifyGPT (https://arxiv.org/abs/2310.10996); Orchid's "models cannot self-resolve ambiguity" (https://arxiv.org/abs/2604.21505) — the latter specifically supports an external check over trusting the agent · **Confidence:** high · **Bears on:** D11, D3 · **Direction:** supports

**V-041** · **Claim:** The convergent practitioner fix for instruction non-compliance is deterministic enforcement (hooks, CI, checkers), not more markdown — independent backing for a real CLI as the single enforcement answer. · **Type:** observation + official-guidance · **Evidence:** yajin.org case ("Don't Trust. Verify."; 300 lines → 3 + hooks) (https://yajin.org/blog/2026-03-22-why-ai-agents-break-rules/); Anthropic hooks-are-deterministic doctrine (https://code.claude.com/docs/en/best-practices); AI-review FP literature converging on tuned severity (V-042) · **Confidence:** high · **Bears on:** D11, D8 · **Direction:** supports

**V-042** · **Claim:** A separate CLI repo is a maintenance commitment users publicly monitor — Spec Kit's month of zero commits after a maintainer departure was treated as an adoption-risk signal; and AI review-tool false-positive noise (10–30% FP rates; ~40% of alerts ignored) is the documented failure mode the hard-error/warning split must avoid. · **Type:** observation (FP numbers mostly vendor-published) · **Evidence:** spec-kit Discussion #1482 (https://github.com/github/spec-kit/discussions/1482); Ask HN noting the lapse (https://news.ycombinator.com/item?id=46864948); cubic FP post (https://www.cubic.dev/blog/the-false-positive-problem-why-most-ai-code-reviewers-fail-and-how-cubic-solved-it); CodeAnt (https://www.codeant.ai/blogs/ai-code-review-false-positives); BlueDot independent 8-tool hands-on (https://blog.bluedot.org/p/best-ai-code-review-tools-2025) · **Confidence:** high (lapse) / medium (FP figures) · **Bears on:** D11, D12 · **Direction:** context/caveat

### D12 — review packet wedge

**V-043** · **Claim:** Review/verification is the measured emerging bottleneck of AI-assisted development — generation outpaces validation across independent telemetry, surveys, and academic PR studies — but the honest framing is "generation outpaces validation," NOT "AI slows teams" (DORA 2025 found a positive throughput association, reversing 2024). · **Type:** measurement (vendor caveats flagged) · **Evidence:** Faros AI (vendor telemetry, 10k+ devs): PR review time +91%, PR size +154%, no company-level KPI gains (https://www.faros.ai/blog/ai-software-engineering); Greptile (vendor): median PR size +93% Mar 2025→Mar 2026 (https://www.greptile.com/state-of-ai-coding); DORA 2025: throughput up, instability up, "AI as amplifier" (https://cloud.google.com/resources/content/2025-dora-ai-assisted-software-development-report, https://dora.dev/insights/dora-2025-year-in-review/); Stack Overflow 2025 (n=49,009): 46% distrust, 66% "almost right" frustration, 45.2% say debugging AI code takes longer (https://survey.stackoverflow.co/2025/ai); Sonar 2026 (n>1,100): 96% don't fully trust, 38% say AI code harder to review (https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/); GitClear duplication/churn trends (https://www.gitclear.com/ai_assistant_code_quality_2025_research); practitioner discourse (https://blog.logrocket.com/ai-coding-tools-shift-bottleneck-to-review/, https://www.builder.io/blog/developers-drowning-in-ai-prs) · **Confidence:** high (direction), medium-high (vendor figures) · **Bears on:** D12, D1 · **Direction:** supports

**V-044** · **Claim:** Agent claim–code inconsistency is documented, expensive, and tail-distributed: 1.7% of agent PRs show high message-code inconsistency, "descriptions claim unimplemented changes" is the #1 type (45.4%), and such PRs see 28.3% vs 80.0% acceptance and 3.5x merge latency — the honest pitch is "expensive when it happens," not "most agent PRs lie." · **Type:** measurement · **Evidence:** arXiv:2601.04886 (23,247 agentic PRs, 974 annotated; https://arxiv.org/abs/2601.04886); field cases: spec-kit #464 silent component swap reported "COMPLETED ✅" (https://github.com/github/spec-kit/issues/464); Marmelab verify-task "done without writing a single unit test" (https://marmelab.com/blog/2025/11/12/spec-driven-development-waterfall-strikes-back.html); METR perception gap — devs 19% slower while believing 20% faster (https://arxiv.org/abs/2507.09089) · **Confidence:** high · **Bears on:** D12, D8 · **Direction:** supports (the evidence-column mechanism specifically)

**V-045** · **Claim:** More-structured PR descriptions are associated with faster reviewer responses and shorter completion times — observational support that a structured, claim-aligned hand-off artifact speeds human review. · **Type:** measurement (correlational) · **Evidence:** MSR 2026, AIDev dataset, 33,596 agent PRs (https://arxiv.org/html/2602.17084v1) · **Confidence:** medium-high · **Bears on:** D12 · **Direction:** supports

**V-046** · **Claim:** Three of five surveyed tools now ship a review-of-agent-output step, so the wedge must NOT be framed as "nobody reviews agent output" — the honest, unoccupied gap is the persisted, independent, exception-routing review packet (coverage table + evidence column + bounded human-attention list). · **Type:** observation · **Evidence:** OpenSpec /opsx:verify — LLM, chat-only, non-blocking (https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md); BMAD bmad-code-review — adversarial, persists findings into the story file, but no standalone coverage table or exception list (https://github.com/bmad-code-org/BMAD-METHOD/tree/main/src/bmm-skills/4-implementation/bmad-code-review, https://github.com/bmad-code-org/BMAD-METHOD/blob/main/docs/explanation/adversarial-review.md); Tessl work-review — per-requirement pass/fail WITH file:line evidence, but ephemeral self-review (https://github.com/tesslio/spec-driven-development-tile/blob/main/skills/work-review/SKILL.md); Spec Kit and Kiro: none documented (https://github.com/github/spec-kit; https://kiro.dev/docs/specs/) · **Confidence:** high · **Bears on:** D12 · **Direction:** mixed — narrows but confirms the wedge

**V-047** · **Claim:** Anthropic officially recommends evidence-over-assertion ("Reviewing evidence is faster than re-running the verification yourself") and bounded adversarial review ("Report gaps, not style preferences"; reviewers prompted open-endedly over-report) — direct vendor support for the evidence column and the enumerated exception list. · **Type:** official-guidance · **Evidence:** https://code.claude.com/docs/en/best-practices ("Give Claude a way to verify its work"; "Add an adversarial review step"; over-reporting caveat) · **Confidence:** high · **Bears on:** D12, D3 · **Direction:** supports

**V-048** · **Claim:** Under load, teams currently review agent output LESS, not more — 61.38% of agent PRs receive no recorded review activity; only 48% of developers always verify AI code despite 96% distrust — so a review-workflow product faces real adoption risk unless the packet demonstrably reduces reviewer effort. · **Type:** measurement · **Evidence:** arXiv:2605.02273 (33,596 AI PRs; https://arxiv.org/html/2605.02273v1); Sonar verification gap (https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/, https://www.theregister.com/software/2026/01/09/devs-doubt-ai-written-code-but-dont-always-check-it/4932910); SO 2025: only 10.2% use AI mostly for review (https://survey.stackoverflow.co/2025/ai) · **Confidence:** high · **Bears on:** D12, D1 · **Direction:** mixed — pain real, behavior contradicts stated pain

**V-049** · **Claim:** The funded market answer to review pain is automated AI reviewers, not structured review artifacts — D12 must position as complementary (requirement coverage + exception routing, which bug-finding bots don't do) or compete with free in-the-box tooling; all efficacy/usage numbers in this category are vendor claims. · **Type:** observation + vendor-claim · **Evidence:** GitHub Copilot code review GA + "60M+ reviews / >1 in 5 reviews" vendor claims (https://github.blog/ai-and-ml/github-copilot/60-million-copilot-code-reviews-and-counting/, https://github.blog/changelog/2025-04-04-copilot-code-review-now-generally-available/); CodeRabbit $60M Series B "quality gates for AI coding" (https://www.coderabbit.ai/blog/coderabbit-series-b-60-million-quality-gates-for-code-reviews, https://siliconangle.com/2025/09/16/coderabbit-gets-60m-fix-ai-generated-code-quality/); Greptile vendor benchmarks (https://www.greptile.com/benchmarks); Graphite "Code review for the age of AI" (https://graphite.com/); landscape overview (https://www.devtoolsacademy.com/blog/state-of-ai-code-review-tools-2025/) · **Confidence:** high (existence/positioning), low-medium (all numbers) · **Bears on:** D12, D11, D1 · **Direction:** mixed

**V-050** · **Claim:** Automation-bias research predicts reviewers will rubber-stamp a coverage table with mostly-green rows — review-by-exception's strongest documented counter-evidence, currently unmitigated in the plan (no seeded failures, no mandatory spot-checks). · **Type:** claim (research-grounded) · **Evidence:** Thoughtworks Technology Radar "complacency with AI-generated code" (https://www.thoughtworks.com/en-us/radar/techniques/complacency-with-ai-generated-code); Atomic Robot vigilance-decrement essay (https://atomicrobot.com/blog/ai-review-fatigue/); academic automation-bias review (https://link.springer.com/article/10.1007/s00146-025-02422-7); Finster (https://bryanfinster.substack.com/p/ai-broke-your-code-review-heres-how) · **Confidence:** medium-high · **Bears on:** D12 · **Direction:** contradicts (the unmitigated form of review-by-exception)

### D13 — Change Plan + Inventory

**V-051** · **Claim:** Brownfield pain is the most consistent cross-tool SDD complaint, with named user demand in both major repos for reverse-engineering existing code into specs — the Inventory artifact has demonstrated demand and a partial precedent (BMAD's document-project, Kiro steering docs). · **Type:** observation · **Evidence:** Böckeler "even more work to introduce them into an existing codebase" (https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html); spec-kit #806, #959, #1173, #404, #778 (https://github.com/github/spec-kit/issues/806 et seq.); OpenSpec #510, #724 (https://github.com/Fission-AI/OpenSpec/issues/510, https://github.com/Fission-AI/OpenSpec/issues/724); Martinelli enterprise critique (https://martinelli.ch/why-spec-driven-development-tools-fail-in-the-enterprise/); BMAD bmad-document-project "Document brownfield projects for AI context" (https://github.com/bmad-code-org/BMAD-METHOD/tree/main/src/bmm-skills/1-analysis/bmad-document-project); ecosystem "brownkit" extension (https://github.com/github/spec-kit/issues/2510) · **Confidence:** high · **Bears on:** D13, D1 · **Direction:** supports

**V-052** · **Claim:** Refactoring fault-induction is empirically real but nuanced: classic studies found frequent fault induction (SCAM 2012, ~15% — exact figure medium-confidence; replicated on 103 systems in 2020), automated engines themselves break behavior, BUT the 2025 longitudinal study found refactored code overall LESS bug-prone, with ad-hoc single refactorings >3x more bug-prone than planned composite ones (5.77% vs 1.75%) and bugs surfacing only after ~7 further changes. · **Type:** measurement · **Evidence:** Bavota et al. SCAM 2012 (https://ieeexplore.ieee.org/document/6392107/); ESEC/FSE 2020 replication (https://dl.acm.org/doi/10.1145/3368089.3409695); refactoring-engine bug study, "Behavior Change" a top-3 symptom (https://arxiv.org/abs/2409.14610); EASE 2025 longitudinal (https://arxiv.org/html/2505.08005v1) · **Confidence:** high · **Bears on:** D13, D2 · **Direction:** supports planned/wave-structured change; contradicts a blanket "refactoring is dangerous" rationale — present both sides

**V-053** · **Claim:** Test-bound behavior-preservation verification is the research-validated mechanism — enumerate unchanged behaviors, bind each to an executable check — exactly the shape of D13's preservation-guarantees table, and now the central evaluation axis for LLM refactoring. · **Type:** observation · **Evidence:** SafeRefactor (https://www.researchgate.net/publication/228405000_Saferefactor-tool_for_checking_refactoring_safety); behavior-preservation mapping study (https://arxiv.org/pdf/2106.13900); TOSEM LLM-refactoring evaluation (https://dl.acm.org/doi/10.1145/3801158); JSS SLR (https://www.sciencedirect.com/science/article/abs/pii/S0164121225004315) · **Confidence:** high · **Bears on:** D13 · **Direction:** supports

**V-054** · **Claim:** Mature migration ecosystems independently converge on D13's anatomy — staged waves, before/after baseline-target, dry-run-before-apply, bridge releases, flag-for-human-review — across 6 named ecosystems; rollback/cutover sections, however, come from strangler-fig ops doctrine (Fowler/AWS/Azure), NOT from upgrade guides, and should be attributed accordingly. · **Type:** observation · **Evidence:** Next.js codemods `--dry`/before-after/manual-review markers (https://nextjs.org/docs/app/guides/upgrading/codemods); React 19 guide with the 18.3 bridge release (https://react.dev/blog/2024/04/25/react-19-upgrade-guide); Rails one-minor-at-a-time + test-coverage precondition (https://guides.rubyonrails.org/upgrading_ruby_on_rails.html); OpenRewrite dryRun patch review (https://docs.openrewrite.org/reference/rewrite-maven-plugin); Angular update guide (https://angular.dev/update-guide); jscodeshift -d/-p (https://github.com/facebook/jscodeshift); strangler fig (https://martinfowler.com/bliki/StranglerFigApplication.html, https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/strangler-fig.html, https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig) · **Confidence:** high · **Bears on:** D13 · **Direction:** supports (with the attribution split)

**V-055** · **Claim:** Hyrum's Law is genuine, citable doctrine — but the plan's slogan "a refactor that changes observable behavior is not a refactor" overshoots it: Hyrum's Law implies zero-observable-change is unsatisfiable, and the SWE-at-Google stance is mitigation-by-planning; the enumerated preserves-list is the faithful operationalization, the absolutist one-liner is attackable. · **Type:** observation · **Evidence:** https://www.hyrumslaw.com/; SWE at Google ch.1 (https://abseil.io/resources/swe-book/html/ch01.html) · **Confidence:** high · **Bears on:** D13 · **Direction:** mixed — supports the guarantees table, cautions the slogan

**V-056** · **Claim:** Plan-as-artifact ships commercially but never transformation-shaped — Amazon Q generates a machine transformation plan for Java upgrades; Kiro/Spec Kit/Cursor persist forward-feature plans; Claude Code/Aider plan ephemerally — so the accurate whitespace claim is "no general-purpose agent workflow ships a human-authored brownfield Change Plan with preservation guarantees and rollback," not "no one plans first." · **Type:** observation · **Evidence:** Amazon Q code transformation (https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/code-transformation.html, https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/how-CT-works.html); Kiro design.md + literal "waves" task execution (https://kiro.dev/docs/specs/); Spec Kit plan.md (https://github.com/github/spec-kit); Cursor Plan Mode persistent .cursor/plans files (https://cursor.com/docs/agent/plan-mode); Claude Code plan mode / Aider architect mode — in-session only (https://code.claude.com/docs/en/common-workflows, https://aider.chat/docs/usage/modes.html) · **Confidence:** high · **Bears on:** D13, D2 · **Direction:** supports scoped differentiation

**V-057** · **Claim:** No study was found that directly measures whether authoring a transformation-plan document reduces migration/refactoring defect rates — D13's causal benefit is supported by analogy (V-052 composite-vs-single, V-054 ecosystem structure) but is not a measured result. · **Type:** claim (verified absence) · **Evidence:** targeted searches across refactoring-safety literature, migration ecosystems, agent-tool docs returned nothing citable · **Confidence:** high that the gap exists · **Bears on:** D13, D8 · **Direction:** UNVERIFIED benefit — label the artifact "convention" under D8's honesty framework

### D14 — findings/memory + status board

**V-058** · **Claim:** "Where am I in the workflow" visibility is a named, measured weakness of the category leader, and users fall back to their tracker — indirect support for a status artifact. · **Type:** observation · **Evidence:** Eretz Kdosha: "the tool doesn't tell you where you are" (https://ranthebuilder.cloud/blog/i-tested-three-spec-driven-ai-tools-here-s-my-honest-take/); spec-kit #880, #1088 (https://github.com/github/spec-kit/issues/880, https://github.com/github/spec-kit/issues/1088); HN dilyevsky on spec-fragmentation across tickets (https://news.ycombinator.com/item?id=45935763) · **Confidence:** high · **Bears on:** D14, D6 · **Direction:** supports (the status board; the findings/ dir itself has no direct external evidence)

**V-059** · **Claim:** Spec/knowledge drift after the first iteration is an unresolved, recognized failure mode — multiple open spec-kit issues, dedicated drift-detection tooling emerging — and the plan currently ships no spec-evolution or drift-detection story. · **Type:** observation · **Evidence:** spec-kit #1191, #876, #1059, Discussion #152 (https://github.com/github/spec-kit/issues/1191, https://github.com/github/spec-kit/issues/876, https://github.com/github/spec-kit/issues/1059, https://github.com/github/spec-kit/discussions/152); Fiberplane Drift linter (https://fiberplane.com/blog/drift-documentation-linter/); Augment "living specs" — "specifications become outdated within weeks" (https://www.augmentcode.com/guides/living-specs-for-ai-agent-development); Böckeler spec-first vs spec-anchored maintenance gap (https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html) · **Confidence:** medium-high · **Bears on:** D14, D5, D13 · **Direction:** contradicts (an unanswered pressure, amplified by D5's cross-repo separation)

### D15 — worktree-per-task isolation

**V-060** · **Claim:** Worktree-per-task isolation is first-class, documented product behavior at two major vendors, with cloud-side parallel isolation at a third — the strongest officially-grounded decision in the plan. · **Type:** observation (official docs) · **Evidence:** Claude Code `claude --worktree`, desktop auto-worktree, subagent `isolation: worktree` (https://code.claude.com/docs/en/worktrees); Cursor worktrees + `.cursor/worktrees.json` (https://cursor.com/docs/configuration/worktrees); Codex cloud parallel tasks returning PRs — per-task-container detail UNVERIFIED (https://developers.openai.com/codex/cloud) · **Confidence:** high (Anthropic/Cursor), low (Codex container detail) · **Bears on:** D15 · **Direction:** supports

**V-061** · **Claim:** No surveyed spec-workflow competitor scaffolds worktree-per-task; the nearest is Spec Kit's branch-per-feature script — D15 is a differentiator inside the spec-tool category. · **Type:** observation (absence) · **Evidence:** create-new-feature.sh branch-per-feature (https://github.com/github/spec-kit); OpenSpec parallel change folders (https://github.com/Fission-AI/OpenSpec/blob/main/docs/workflows.md) · **Confidence:** medium (absence claim) · **Bears on:** D15 · **Direction:** context

**V-062** · **Claim:** Worktree isolation does not prevent the dominant cost of parallel agent runs — late-surfacing cross-worktree merge conflicts — and practitioners report a practical ceiling of ~3–5 parallel streams; all four sources still use worktrees, so isolation hygiene stands while high-fanout parallelism marketing would not. · **Type:** observation · **Evidence:** clash-sh/clash exists specifically to manage cross-worktree conflicts (https://github.com/clash-sh/clash); MindStudio playbook concedes agents are "blind to each other's changes" (https://www.mindstudio.ai/blog/parallel-agentic-development-git-worktrees); dev.to practitioner conflict account (https://dev.to/battyterm/how-i-run-a-team-of-ai-coding-agents-in-parallel-p7c); Intility ~3–5 stream ceiling (https://engineering.intility.com/article/agent-teams-or-how-i-learned-to-stop-worrying-about-merge-conflicts-and-love-git-worktrees) · **Confidence:** high · **Bears on:** D15 · **Direction:** mixed

## Where the evidence disagrees with the plan

### 1. D5 — workspace topology: external store vs in-repo norm

| Plan position (external Git spec store as enterprise default) | Counter-evidence (in-repo as universal practice) |
|---|---|
| External proposal/decision stores are established enterprise practice: rust-lang/rfcs, golang/proposal, kubernetes/enhancements, Oxide RFDs, GitLab handbook repo, Jama/DOORS/Polarion/Codebeamer, Devin Knowledge (V-023) | All six named spec-agent tools store specs committed in the code repo; Kiro's docs recommend it (V-021); user demand pushes toward in-repo monorepo flexibility, not externalization (V-022) |
| Clean cross-repo scope, review-of-review audit trail independent of code history, non-engineer access (V-023) | Colocation buys atomic spec+code change and merge gating (docs-as-code); external intent-docs have a documented drift + discoverability failure mode — Uber built a tool to fix it; Hackney's central ADR repo was archived (V-024) |
| Regulated-industry lineage: formal requirements have always lived in external stores (V-023, G16) | Every vendor's context-loading machinery is repo-rooted — external stores forfeit auto-loading and need an explicit pointer every run (V-025) |
| — | Swarm's only dogfooding adopter co-locates; the external default has zero dogfooding evidence (V-025) |

Trade-off: external wins at RFC/requirements granularity, multi-repo scope, and compliance access; in-repo wins at per-feature work-spec granularity, drift control, and agent auto-loading. The evidence currently weighs toward in-repo (or at minimum co-equal co-located default) for per-feature specs, with external defensible as a documented option carrying the enterprise/multi-repo rationale — not as "common practice." Decision belongs to the owner/ADR.

### 2. D7 — pristine code repo vs the committed-dir norm

| Plan position | Counter-evidence |
|---|---|
| Code repo stays pristine; one-line AGENTS.md pointer only; future CLI may own a gitignored `.swarm/` | Every competitor commits its tool dir (V-028); the vendor norm is split-in-repo: shared config committed, local state gitignored (V-029) |
| Gitignored `.swarm/` has an exact vendor precedent: `.claude/worktrees/` in .gitignore (V-029) | "Nothing committed" runs against what Anthropic/Cursor explicitly tell teams to commit (CLAUDE.md, settings.json, rules) (V-029) |

Trade-off: genuine differentiation with direct precedent for the gitignored-state half; the pristine half's friction cost vs drop-in dirs is undocumented and untested (V-030). Evidence weighs toward acknowledging the committed-config norm exists and stating why Swarm deviates, rather than implying pristine is standard.

### 3. D12 — wedge framing tensions

| Plan framing risk | What the evidence says |
|---|---|
| "No competitor reviews agent output" | Three of five ship a review step (OpenSpec verify, BMAD code-review, Tessl work-review); Tessl's format already IS coverage-with-file:line evidence. The unoccupied gap is narrower: persisted + independent + exception-routing packet (V-046) |
| Review packet adds a structured review step | Under load teams review LESS: 61.38% of agent PRs get no review; only 48% always verify (V-048). The packet must demonstrably reduce reviewer effort or it asks overloaded teams to do more |
| Review-by-exception routes attention efficiently | Automation-bias research predicts rubber-stamping of mostly-green tables; no countermeasure in the plan (V-050) — the sharpest unmitigated collision |
| The market lacks an answer to review pain | The funded answer is AI-reviewer bots (Copilot CR, CodeRabbit $60M, Greptile, Bugbot) — D12 must position as complementary on requirement coverage + exceptions, not compete on bug detection (V-049) |

Evidence weighs toward keeping D12 as the wedge (best-evidenced premise in the plan: V-043–V-045, V-047) with the four framing corrections above.

### 4. D2/D9 — "lightweight" means few commands, not few files

| Plan position | Counter-evidence |
|---|---|
| Six-step loop + 12-file kit is lightweight vs incumbents | The complaint that sank Spec Kit's reputation is artifact volume per change (2,577 md lines; 8 files; "illusion of work"), and OpenSpec's "lightweight" still means few commands (V-001, V-008). Swarm's 6 core artifacts + intake + status is in line with, not below, market weight |

Trade-off: step-count tiering matches the market move (V-006); per-task file volume needs explicit optional-by-default behavior. Evidence weighs toward a hard per-task artifact budget.

### 5. D8 — the ~100-line cap number

| Plan position | Counter-evidence |
|---|---|
| Soft ~100-line cap on AGENTS.md | No vendor publishes any number near 100; published bounds are 500 lines and 32 KiB; community spread is 100–750 (V-033). IFScale supports "shorter is better" directionally (V-032) but yields no specific threshold |

Evidence weighs toward keeping the soft framing and labeling the figure as Swarm's own convention.

### 6. D1 — throughput framing

| Tempting framing | What the evidence says |
|---|---|
| "AI agents fail to deliver / slow teams down" (METR 19% slower) | DORA 2025 found a positive throughput association (reversal from 2024); Faros shows output genuinely rising; METR's own 2026 follow-up could not replicate the slowdown and now leans speedup (V-043, H10/H11). The defensible claim is "generation outpaces validation" |

### 7. D13 — refactoring-risk rationale

| Tempting framing | What the evidence says |
|---|---|
| "Refactoring induces bugs (~15%)" (SCAM 2012) | The 2025 longitudinal study found refactored code overall LESS bug-prone; the precise, stronger claim is "ad-hoc single refactorings are >3x riskier than planned composite ones" — which argues FOR the Change Plan (V-052). Also: the "a refactor that changes observable behavior is not a refactor" slogan overshoots Hyrum's Law and is literally unsatisfiable (V-055) |

### 8. D5/D14 — spec evolution and drift (unanswered, both sides)

| Plan position | Counter-evidence |
|---|---|
| Per-feature specs + Change Plan for structural work | Routine spec amendment after review feedback is the documented unsolved pain at the category leader (open issues #1191/#876/#1059); drift-detection tooling is emerging because drift is endemic; D5's cross-repo separation removes even the same-PR co-update opportunity (V-059) |

Evidence weighs toward the plan needing an explicit routine spec-evolution story; without one, Swarm inherits the exact complaint, amplified by external storage.

## Counter-evidence register

| # | Counter-evidence (lane H strongest) | Threatens | Plan mitigation status |
|---|---|---|---|
| CE-1 | Eberhardt hands-on: Spec Kit ~10x slower than iterative prompting; 3.5 h human markdown review per feature; obvious bug shipped anyway (V-001, H1) | D1, D2, D9, D10 | PARTIAL — the failure mode is agent-generated spec bloat; the plan's short human-curated specs were not what was tested, but the plan sets no per-task artifact-volume budget |
| CE-2 | Spec drift + maintenance is unresolved cross-tool; dedicated drift tooling emerging; external storage structurally prevents same-PR co-updates (V-059, H5, B7) | D5, D14, D13 | UNMITIGATED — no spec-evolution or drift-detection story in the plan |
| CE-3 | Cross-tool instruction non-compliance at scale: 9+ Claude Code issues, Codex #25884, Cursor silent failures, IFScale 68% @ 500 instructions (V-032, H6–H8) | D8, D9, D2 (any surface assuming guide compliance) | PARTIAL — D8's honesty labels are exactly the right response; but the three agent guides and the loop still quietly depend on compliance for value; D11's checker is the convergent fix and must ship |
| CE-4 | Automation bias predicts rubber-stamping of mostly-green coverage tables (V-050, H16) | D12 (the wedge itself) | UNMITIGATED — no seeded-failure or mandatory spot-check countermeasure anywhere in the plan |
| CE-5 | METR RCT: devs 19% slower with AI while believing 20% faster — with the mandatory 2026 carry: not replicated, METR now leans speedup (H10, H11) | D1 (premise framing) | N/A — framing discipline: cite only with the 2026 update attached |
| CE-6 | AI review-tool false-positive noise: 10–30% FP rates, ~40% of alerts ignored, tools tuned down or disabled (V-042, H15) | D11, D12 | PARTIAL — the hard-error/warning split is the known mitigation; the review packet's curated exception list (vs per-line comments) is the right shape; thresholds untested |
| CE-7 | Worktrees don't prevent cross-worktree merge conflicts; practical ceiling ~3–5 parallel streams (V-062, H17) | D15 | PARTIAL — D15 as serial isolation hygiene is not contradicted; the plan must not market high-fanout parallelism |
| CE-8 | Agent case study: explicit 300-line rules broken via rush mode + compaction; fix was 3 rules + deterministic hooks (V-032, H9) | D8, D9 | PARTIAL — supports the soft cap and D11; reinforces that lint codes presented as "review checklists" will not self-enforce |
| CE-9 | The entire public empirical record attacks tool-generated heavy specs; the plan's actual configuration — lightweight human-authored specs — is publicly untested in BOTH directions (H lane closing note) | D1, D3, D10 | UNMITIGATED as evidence; the flagship examples (D10) are the plan's only current answer and are themselves unvalidated |

## Open questions / research to run

1. **Review-packet usability test (D12, CE-4).** No external evidence shows a coverage-table-with-evidence reduces review time or raises catch rate vs reviewing the raw diff — and automation-bias research predicts the opposite failure. Recommend: a study with N reviewers, real agent PRs, seeded false "green" rows, measuring catch rate and time-to-decision vs diff-only review.
2. **The 10-minute newcomer test (D9/D10).** The plan's onboarding claim has no external grounding either way. Recommend: run it as a real timed study with newcomers who have never seen Swarm, before the README ships.
3. **Intake-artifact value (D6).** Zero precedent, zero demand evidence for the snapshot form (demand is for tracker integration, V-027). Recommend: pilot with 2–3 adopter teams; measure whether the snapshot is ever consulted after task creation.
4. **Lightweight human-authored spec vs prompt-only (D1/D3, CE-9).** Every public hands-on tested tool-generated heavy specs. Recommend: a controlled comparison of Swarm-style short AC specs vs direct prompting on matched tasks — this is the single most load-bearing untested claim in the plan.
5. **External-workspace dogfooding (D5).** The enterprise default has never been run, even internally (V-025). Recommend: dogfood one real multi-repo adoption in the external topology before declaring it the enterprise default.
6. **Competitor flagship-example completeness (D10).** Whether Spec Kit/Kiro/OpenSpec docs lack complete ticket→review worked examples was never checked — UNVERIFIED. Recommend: a quick documented sweep before claiming the gap.
7. **Findings/memory value (D14).** No external evidence on whether a findings/ dir gets written to or read. Recommend: instrument dogfooding; count reads vs writes over a month.
8. **EARS reception among agent users (D3).** No complaints about EARS syntax in Kiro feedback were found — absence, not approval (V-016). Recommend: targeted user interviews if SOL marketing weight increases.
9. **Pristine-repo preference (D7, V-030).** Market preference between drop-in committed dirs and pristine+pointer is untested. Recommend: ask in adopter onboarding; track setup-friction complaints.
10. **Unverified circulating figures (C13).** Before any README/ADR cites them, chase primaries for: "AI PRs wait 4.6x longer for reviewer pickup"; "4.3 min vs 1.2 min review per suggestion"; DORA 2025 sample size; CodeRabbit "1.7x more issues" — all currently secondary-source only.

## Advisory implications for the plan

1. **D5 framing (workspace ADR, Increment 1):** never present the external store as common practice; frame it as "a Git-native, agent-readable form of the external requirements store enterprises already run" (cite V-023's named instances), promote co-located mode to co-equal default for single-repo teams, and record the V-021/V-024 counter-evidence (unanimous in-repo competitor practice; drift/discoverability failure modes) in the ADR Context.
2. **Add a routine spec-evolution story (D14/D5; docs/04 + workspace ADR):** how a spec is amended after review feedback without wholesale regeneration, and how drift between workspace and code is detected — record spec-kit #1191/#876/#1059 and Fiberplane Drift as the motivating counter-sources (V-059).
3. **D12 wording sweep (README + review ADR, Increment 2):** replace any "nobody reviews agent output" claim with the narrow verified gap — "no tool ships a persisted, independent, exception-routing review packet" (V-046); position vs AI-reviewer bots as complementary on requirement coverage + human-attention exceptions, never on bug detection (V-049).
4. **Add an automation-bias countermeasure to the review template (templates/review.md, §5.3):** e.g., a mandatory "spot-check one green row's evidence" instruction for the human reviewer, and record V-050's sources in the review ADR Context — this is the plan's sharpest unmitigated collision.
5. **Set a per-task artifact budget (docs/04–06 + templates):** explicit defaults (review packet ≤ 1 page; spec ≤ N lines; intake/status optional for trivial work), with the skip-Spec path visible in the README's first example — Eberhardt's 3.5 h and the "illusion of work" thread are the counter-sources to record (V-001, V-008).
6. **Label the ~100-line AGENTS.md cap as Swarm's own convention (D8 ADR):** cite the vendor bounds (500 lines / 32 KiB) and IFScale as directional motivation; do not present the figure as ecosystem-derived (V-032, V-033).
7. **Rewrite the Change Plan ADR's empirical rationale (ADR-0068, §12.2):** lead with "ad-hoc single refactorings are >3x riskier than planned composites" (EASE 2025) instead of the 2012 ~15% figure alone; cite strangler-fig sources (Fowler/AWS/Azure) for the rollback/cutover sections specifically; soften "a refactor that changes observable behavior is not a refactor" to the enumerated-preserves-list form (V-052, V-054, V-055); label the artifact's defect-reduction benefit "convention" per D8 (V-057).
8. **Throughput framing rule (README/PRINCIPLES, Increment 2):** the claim is "generation outpaces validation," never "AI slows teams"; if METR 2025 is cited anywhere, the 2026 non-replication update must be cited with it (V-043, CE-5).
9. **D15 scope note (docs/06):** present worktrees as per-task isolation hygiene with vendor precedent (Claude Code/Cursor), explicitly noting the ~3–5 parallel-stream practical ceiling and that isolation does not prevent cross-worktree conflicts (V-060, V-062).
10. **swarm-cli commitments (Increment 10 / ADR-0063):** ship the validator early — OpenSpec and Kiro already ship validation, so "checklists until a linter ships" has a short credibility window (V-038, V-039); add a visible maintenance signal (release cadence, CI badge), recording spec-kit's publicly-monitored zero-commit month as the counter-source (V-042).

## Sources

### Competitor working products (repos, templates, docs)
- https://github.com/github/spec-kit
- https://github.com/github/spec-kit/blob/main/templates/spec-template.md
- https://raw.githubusercontent.com/github/spec-kit/main/templates/spec-template.md
- https://github.com/Fission-AI/OpenSpec
- https://github.com/Fission-AI/OpenSpec/blob/main/README.md
- https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md
- https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md
- https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md
- https://github.com/Fission-AI/OpenSpec/blob/main/docs/workflows.md
- https://github.com/Fission-AI/OpenSpec/blob/main/docs/cli.md
- https://github.com/bmad-code-org/BMAD-METHOD
- https://github.com/bmad-code-org/BMAD-METHOD/tree/main/src/bmm-skills/4-implementation/bmad-code-review
- https://github.com/bmad-code-org/BMAD-METHOD/blob/main/docs/explanation/adversarial-review.md
- https://github.com/bmad-code-org/BMAD-METHOD/tree/main/src/bmm-skills/1-analysis/bmad-document-project
- https://github.com/tesslio/spec-driven-development-tile
- https://github.com/tesslio/spec-driven-development-tile/blob/main/docs/spec-format.md
- https://github.com/tesslio/spec-driven-development-tile/blob/main/skills/work-review/SKILL.md
- https://docs.tessl.io/use/spec-driven-development-with-tessl
- https://tessl.io/blog/tessl-launches-spec-driven-framework-and-registry/
- https://github.com/Pimzino/spec-workflow-mcp
- https://kiro.dev/docs/specs/
- https://kiro.dev/docs/specs/feature-specs/
- https://kiro.dev/docs/specs/quick-plan/
- https://kiro.dev/docs/specs/best-practices/
- https://kiro.dev/docs/getting-started/first-project/
- https://kiro.dev/docs/steering/
- https://kiro.dev/blog/deep-spec-analysis/
- https://thedocs.io/openspec/concepts/spec-format/

### Competitor issues / discussions (user demand and complaints)
- https://github.com/github/spec-kit/discussions/1784
- https://github.com/github/spec-kit/discussions/1686
- https://github.com/github/spec-kit/discussions/1482
- https://github.com/github/spec-kit/discussions/152
- https://github.com/github/spec-kit/issues/385
- https://github.com/github/spec-kit/issues/404
- https://github.com/github/spec-kit/issues/464
- https://github.com/github/spec-kit/issues/516
- https://github.com/github/spec-kit/issues/581
- https://github.com/github/spec-kit/issues/778
- https://github.com/github/spec-kit/issues/806
- https://github.com/github/spec-kit/issues/876
- https://github.com/github/spec-kit/issues/880
- https://github.com/github/spec-kit/issues/959
- https://github.com/github/spec-kit/issues/1026
- https://github.com/github/spec-kit/issues/1059
- https://github.com/github/spec-kit/issues/1088
- https://github.com/github/spec-kit/issues/1173
- https://github.com/github/spec-kit/issues/1191
- https://github.com/github/spec-kit/issues/1356
- https://github.com/github/spec-kit/issues/1436
- https://github.com/github/spec-kit/issues/2510
- https://github.com/github/spec-kit/issues/2625
- https://github.com/github/spec-kit/pull/2145
- https://github.com/Fission-AI/OpenSpec/issues/510
- https://github.com/Fission-AI/OpenSpec/issues/724
- https://github.com/Fission-AI/OpenSpec/issues/880
- https://github.com/microsoft/vscode/issues/261160
- https://github.com/anthropics/claude-code/issues/34197
- https://github.com/anthropics/claude-code/issues/27750
- https://github.com/anthropics/claude-code/issues/30421
- https://github.com/anthropics/claude-code/issues/33456
- https://github.com/anthropics/claude-code/issues/32161
- https://github.com/openai/codex/issues/25884
- https://forum.cursor.com/t/is-it-possible-to-disable-usage-rules-from-agents-md-cursor-and-codex-needs-separete-rules-set/138971

### Hands-on evaluations and practitioner commentary
- https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html
- https://blog.scottlogic.com/2025/11/26/putting-spec-kit-through-its-paces-radical-idea-or-reinvented-waterfall.html
- https://marmelab.com/blog/2025/11/12/spec-driven-development-waterfall-strikes-back.html
- https://ranthebuilder.cloud/blog/i-tested-three-spec-driven-ai-tools-here-s-my-honest-take/
- https://martinelli.ch/why-spec-driven-development-tools-fail-in-the-enterprise/
- https://avasdream.com/blog/openspec-vs-spec-kit-ai-development
- https://dev.to/fikuri/kiro-the-good-bad-and-ugly-part-in-my-personal-experience-1neh
- https://www.morphllm.com/comparisons/kiro-vs-cursor
- https://vibecoding.app/blog/spec-kit-review
- https://den.dev/blog/github-spec-kit/
- https://notes.hello-data.nl/artificial-intelligence/whats-the-deal-with-github-spec-kit-den-delimarsky
- https://news.ycombinator.com/item?id=45935763
- https://news.ycombinator.com/item?id=45154355
- https://news.ycombinator.com/item?id=45610996
- https://news.ycombinator.com/item?id=46864948
- https://news.ycombinator.com/item?id=47197595
- https://www.alexcloudstar.com/blog/spec-driven-development-2026/
- https://hubreb.github.io/blog/spec-kit-brownfield-implementation
- https://hedrange.com/2025/08/11/how-to-use-kiro-for-ai-assisted-spec-driven-development/
- https://clune.org/posts/spec-driven-development/
- https://simonwillison.net/2025/Oct/7/vibe-engineering/
- https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/
- https://simonwillison.net/2025/Jul/12/ai-open-source-productivity/
- https://yajin.org/blog/2026-03-22-why-ai-agents-break-rules/
- https://medium.com/quantumblack/agentic-workflows-for-software-development-dc8e64f4a79d
- https://www.industrialempathy.com/posts/design-docs-at-google/
- https://newsletter.pragmaticengineer.com/p/rfcs-and-design-docs
- https://alan.is/2026/03/07/unlocking-cursor-features-and-workflow-tips/

### Surveys, telemetry, and industry measurements
- https://cloud.google.com/resources/content/2025-dora-ai-assisted-software-development-report
- https://dora.dev/insights/dora-2025-year-in-review/
- https://dora.dev/dora-report-2025/
- https://cloud.google.com/blog/products/ai-machine-learning/announcing-the-2025-dora-report
- https://redmonk.com/rstephens/2025/12/18/dora2025/
- https://www.infoq.com/news/2026/03/ai-dora-report/
- https://www.splunk.com/en_us/blog/learn/state-of-devops.html
- https://survey.stackoverflow.co/2025/ai
- https://stackoverflow.co/company/press/archive/stack-overflow-2025-developer-survey/
- https://stackoverflow.blog/2025/12/29/developers-remain-willing-but-reluctant-to-use-ai-the-2025-developer-survey-results-are-here/
- https://www.gitclear.com/ai_assistant_code_quality_2025_research
- https://gitclear-public.s3.us-west-2.amazonaws.com/GitClear-AI-Copilot-Code-Quality-2025.pdf
- https://www.gitclear.com/developer_ai_productivity_analysis_tools_research_2026
- https://www.devclass.com/ai-ml/2025/02/20/ai-is-eroding-code-quality-states-new-in-depth-report/1626250
- https://www.faros.ai/blog/ai-software-engineering
- https://www.faros.ai/research
- https://adtmag.com/articles/2026/04/22/more-code-more-bugs.aspx
- https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/
- https://www.sonarsource.com/state-of-code-developer-survey-report.pdf
- https://www.theregister.com/software/2026/01/09/devs-doubt-ai-written-code-but-dont-always-check-it/4932910
- https://events.sonarsource.com/2026-state-of-code-developer-survey/
- https://www.greptile.com/state-of-ai-coding
- https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/
- https://metr.org/blog/2026-02-24-uplift-update/
- https://blog.robbowley.net/2026/04/04/metrs-developer-productivity-research-2026-update/
- https://getcoai.com/video/does-ai-actually-boost-developer-productivity-100k-devs-study-yegor-denisov-blanch-stanford/
- https://htek.dev/articles/stanford-study-ai-roi-in-engineering
- https://proxify.io/articles/stanford-study-of-100000-developers-on-engineering-productivity

### Academic papers
- https://arxiv.org/abs/2507.09089
- https://arxiv.org/pdf/2507.09089
- https://arxiv.org/abs/2601.04886
- https://arxiv.org/html/2601.04886
- https://arxiv.org/html/2605.02273v1
- https://arxiv.org/html/2602.17084v1
- https://arxiv.org/abs/2507.11538
- https://arxiv.org/abs/2604.21505
- https://arxiv.org/abs/2310.10996
- https://2024.esec-fse.org/details/fse-2024-research-papers/89/ClarifyGPT-A-Framework-for-Enhancing-LLM-based-Code-Generation-via-Requirements-Clar
- https://arxiv.org/abs/2604.16198
- https://arxiv.org/abs/2505.07270
- https://arxiv.org/abs/2406.00215
- https://dl.acm.org/doi/10.1145/3715109
- https://github.com/jie-jw-wu/human-eval-comm
- https://arxiv.org/abs/2603.00187
- https://arxiv.org/abs/2501.04810
- https://arxiv.org/abs/2404.11106
- https://arxiv.org/pdf/1611.08847
- https://dl.acm.org/doi/10.1109/RE.2009.9
- https://research.manchester.ac.uk/en/publications/easy-approach-to-requirements-syntax-ears/
- https://ieeexplore.ieee.org/document/6392107/
- https://people.lu.usi.ch/bavotg/papers/scam2012.pdf
- https://dl.acm.org/doi/10.1145/3368089.3409695
- https://arxiv.org/abs/2009.11685
- https://arxiv.org/html/2505.08005v1
- https://arxiv.org/abs/2409.14610
- https://www.researchgate.net/publication/228405000_Saferefactor-tool_for_checking_refactoring_safety
- https://sol.sbc.org.br/index.php/ctd/article/download/29168/28973/
- https://arxiv.org/pdf/2106.13900
- https://leopoldomt.github.io/assets/pdf/2014-scp.pdf
- https://dl.acm.org/doi/10.1145/3801158
- https://www.sciencedirect.com/science/article/abs/pii/S0164121225004315
- https://arxiv.org/abs/2602.21833
- https://link.springer.com/article/10.1007/s10664-026-10858-8
- https://link.springer.com/article/10.1007/s00146-025-02422-7
- https://link.springer.com/article/10.1007/s42979-025-03843-3
- https://ieeexplore.ieee.org/document/10132248/
- https://ieeexplore.ieee.org/document/5328509/

### Official vendor guidance and product docs
- https://code.claude.com/docs/en/best-practices
- https://code.claude.com/docs/en/worktrees
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/common-workflows
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- https://www.anthropic.com/research/building-effective-agents
- https://cursor.com/docs/context/rules
- https://cursor.com/docs/configuration/worktrees
- https://cursor.com/docs/agent/plan-mode
- https://cursor.com/blog/plan-mode
- https://developers.openai.com/codex/guides/agents-md
- https://developers.openai.com/codex/cloud
- https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/gemini-md.md
- https://agents.md
- https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation
- https://aider.chat/docs/usage/modes.html
- https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/code-transformation.html
- https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/how-CT-works.html
- https://aws.amazon.com/blogs/devops/accelerate-application-upgrades-with-amazon-q-developer-agent-for-code-transformation/
- https://docs.devin.ai/product-guides/knowledge

### Migration ecosystems and engineering doctrine
- https://nextjs.org/docs/app/guides/upgrading/codemods
- https://react.dev/blog/2024/04/25/react-19-upgrade-guide
- https://guides.rubyonrails.org/upgrading_ruby_on_rails.html
- https://docs.openrewrite.org/
- https://docs.openrewrite.org/reference/rewrite-maven-plugin
- https://angular.dev/update
- https://angular.dev/update-guide
- https://github.com/facebook/jscodeshift
- https://martinfowler.com/bliki/StranglerFigApplication.html
- https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/strangler-fig.html
- https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig
- https://www.hyrumslaw.com/
- https://abseil.io/resources/swe-book/html/ch01.html

### Enterprise knowledge/workspace practice
- https://backstage.io/docs/features/techdocs/
- https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- https://docs.cloud.google.com/architecture/architecture-decision-records
- https://learn.microsoft.com/en-us/azure/well-architected/architect-role/architecture-decision-record
- https://gitlab.com/gitlab-com/content-sites/handbook
- https://handbook.gitlab.com/handbook/company/culture/all-remote/handbook-first/
- https://slab.com/guides/how-success-is-written/gitlab-writing-offers-single-source-of-truth/
- https://www.writethedocs.org/guide/docs-as-code/
- https://github.com/rust-lang/rfcs
- https://github.com/golang/proposal
- https://github.com/kubernetes/enhancements
- https://rfd.shared.oxide.computer/rfd/0001
- https://www.hashicorp.com/how-hashicorp-works/articles/writing-practices-and-culture
- https://github.com/sourcegraph/handbook/blob/main/content/company-info-and-process/communication/rfcs/index.md
- https://github.com/LBHackney-IT/lbh-adrs
- https://www.inflectra.com/tools/comparisons/doors-vs-jama-connect
- https://www.planview.com/products-solutions/products/hub/integrations/ibm-doors/
- https://www.ptc.com/en/products/codebeamer/more-than-just-requirements-management
- https://www.jamasoftware.com/solutions/choosing-jama-connect-over-polarion/

### EARS and requirements practice
- https://alistairmavin.com/ears/
- https://qracorp.com/when-not-to-use-ears/
- https://qracorp.com/easy-approach-to-requirements-syntax-ears-guide/
- https://www.jamasoftware.com/requirements-management-guide/writing-requirements/adopting-the-ears-notation-to-improve-requirements-engineering/
- https://www.jamasoftware.com/requirements-management-guide/writing-requirements/frequently-asked-questions-about-the-ears-notation-and-jama-connect-requirements-advisor/
- https://www.incose.org/docs/default-source/working-groups/requirements-wg/guidetowritingrequirements/incose_rwg_gtwr_v4_summary_sheet.pdf
- https://www.reusecompany.com/webinars/implementing-the-latest-concepts-of-the-new-gtwr-v4-0
- https://www.iaria.org/conferences2013/filesICCGI13/ICCGI_2013_Tutorial_Terzakis.pdf
- https://www.se-trends.de/en/requirements-with-ears/
- https://dev.to/sebastian_dingler/ears-the-easy-approach-to-requirements-syntax-39a5
- https://makerneo.com/en/articles/what-is-ears-requirements-syntax-how-to-write-better-ai-prompts.html

### AI review tooling and counter-evidence
- https://github.blog/ai-and-ml/github-copilot/60-million-copilot-code-reviews-and-counting/
- https://github.blog/changelog/2025-04-04-copilot-code-review-now-generally-available/
- https://www.coderabbit.ai/blog/coderabbit-series-b-60-million-quality-gates-for-code-reviews
- https://siliconangle.com/2025/09/16/coderabbit-gets-60m-fix-ai-generated-code-quality/
- https://www.greptile.com/benchmarks
- https://graphite.com/
- https://graphite.com/blog/the-ideal-pr-is-50-lines-long
- https://www.devtoolsacademy.com/blog/state-of-ai-code-review-tools-2025/
- https://www.cubic.dev/blog/the-false-positive-problem-why-most-ai-code-reviewers-fail-and-how-cubic-solved-it
- https://www.codeant.ai/blogs/ai-code-review-false-positives
- https://blog.bluedot.org/p/best-ai-code-review-tools-2025
- https://www.propelcode.ai/blog/ai-code-review-false-positives-reducing-noise
- https://www.thoughtworks.com/en-us/radar/techniques/complacency-with-ai-generated-code
- https://atomicrobot.com/blog/ai-review-fatigue/
- https://bryanfinster.substack.com/p/ai-broke-your-code-review-heres-how
- https://blog.logrocket.com/ai-coding-tools-shift-bottleneck-to-review/
- https://www.builder.io/blog/developers-drowning-in-ai-prs
- https://www.metacto.com/blogs/code-review-bottleneck-ai-development
- https://dev.to/code-board/code-review-is-the-real-bottleneck-of-2026-and-most-teams-dont-see-it-5eed
- https://www.pathrule.io/writing/why-cursor-rules-get-silently-ignored
- https://fiberplane.com/blog/drift-documentation-linter/
- https://www.augmentcode.com/guides/living-specs-for-ai-agent-development
- https://github.com/clash-sh/clash
- https://www.mindstudio.ai/blog/parallel-agentic-development-git-worktrees
- https://dev.to/battyterm/how-i-run-a-team-of-ai-coding-agents-in-parallel-p7c
- https://engineering.intility.com/article/agent-teams-or-how-i-learned-to-stop-worrying-about-merge-conflicts-and-love-git-worktrees

### Context-file guidance (community)
- https://www.humanlayer.dev/blog/writing-a-good-claude-md
- https://dev.to/nishilbhave/claudemd-best-practices-the-complete-2026-guide-435j
- https://techsy.io/en/blog/claude-md-best-practices