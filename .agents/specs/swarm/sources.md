# Swarm Kernel Specification v0.1 — Sources

This file is the evidence base for the Swarm kernel specification. Every load-bearing empirical or standards claim in the spec MUST trace to an entry here, cited by its **[KEY]**. Each entry records a full citation, the spec section/claim it *Grounds*, and the precise *Finding* (fact or number) it supports. Some entries are flagged where the original review misrepresented a source (wrong number, wrong scope, wrong venue); the corrected framing is given and is what the spec MUST use. Entries listed under "Rejected / unverifiable" could not be confirmed against a primary source (fabricated arXiv ids, hallucinated venues/studies, or invented statistics) and MUST NOT be cited; they are recorded so future authors do not re-introduce them.

## Standards (requirements language & controlled English)

- **[RFC2119]** Bradner, S. "Key words for use in RFCs to Indicate Requirement Levels." RFC 2119 / BCP 14, IETF, March 1997. https://www.rfc-editor.org/rfc/rfc2119
  *Grounds:* The spec's use of RFC-2119 keyword semantics; the claim that SHALL is a synonym for MUST (not a distinct/weaker term).
  *Finding:* §1: "MUST — This word, or the terms 'REQUIRED' or 'SHALL', mean that the definition is an absolute requirement of the specification." Establishes MUST ≡ REQUIRED ≡ SHALL.

- **[RFC8174]** Leiba, B. "Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words." RFC 8174 / BCP 14, IETF, May 2017. https://www.rfc-editor.org/rfc/rfc8174
  *Grounds:* The spec's claim that 8174 is purely the lowercase/uppercase disambiguation overlay on 2119, not a re-definition of keyword synonymy.
  *Finding:* Keywords carry their special meaning "only when, in all capitals"; lowercase uses have "their normal English meanings and are not affected by this document." Does not redefine MUST/SHALL/REQUIRED synonymy. Together with RFC 2119 forms BCP 14.

- **[EARS]** Mavin, A., Wilkinson, P., Harwood, A., & Novak, M. "Easy Approach to Requirements Syntax (EARS)." Proc. 2009 17th IEEE International Requirements Engineering Conference (RE'09), Atlanta GA, IEEE, 2009, pp. 317–322. DOI 10.1109/RE.2009.9. Official guide: https://alistairmavin.com/ears/
  *Grounds:* The spec's adoption of EARS patterns — specifically that ubiquitous requirements use no keyword and that `Where` gates a requirement on optional-feature inclusion.
  *Finding:* Ubiquitous: "The <system> shall <response>" — "always active (so there is no EARS keyword)." While (state-driven), When (event-driven). Where = optional feature: "Where <feature is included>, the <system> shall…"; applies in products that include the specified feature. If/Then = unwanted behaviour.

- **[FRET]** Giannakopoulou, D., Pressburger, T., Mavridou, A., Schumann, J. "Formal Requirements Elicitation with FRET." NASA Ames; NTRS 20200001989 (REFSQ 2020). Tool: NASA Software Catalog ARC-18066-1, https://software.nasa.gov/software/ARC-18066-1 ; GitHub: NASA/fret
  *Grounds:* The spec's precedent that constrained/structured natural-language requirements can be deterministically translated to formal (temporal) logic — controlled English as a real, tooled engineering practice, not aspiration.
  *Finding:* FRET writes requirements in restricted natural language "FRETish" (fields: scope, condition, component, timing, response) with unambiguous semantics, formalizing each into future/past-time metric temporal logic and exporting to CoCoSim, Simulink Design Verifier, Kind, SMV.

- **[STE]** ASD (AeroSpace and Defence Industries Association of Europe). "ASD-STE100: Simplified Technical English." Maintained by the Simplified Technical English Maintenance Group (STEMG). https://www.asd-ste100.org/
  *Grounds:* The spec's "one term = one meaning" controlled-vocabulary discipline — citing a mature, published controlled-language standard as precedent.
  *Finding:* Controlled natural language for technical documentation: writing rules (Issue 9 = 53 rules) + controlled dictionary (~900 approved words) enforcing "One word, one part of speech, one meaning" (e.g., "test" approved only as a noun). (Publisher is ASD, not its former name AECMA.)

## Versioning & format standards

- **[SEMVER]** Preston-Werner, T. "Semantic Versioning 2.0.0." semver.org. https://semver.org/
  *Grounds:* Justifies treating Swarm version 0.x as unstable ("anything MAY change") and the requirement to declare a public API before SemVer guarantees apply.
  *Finding:* §4: "Major version zero (0.y.z) is for initial development. Anything MAY change at any time. The public API SHOULD NOT be considered stable." §1: "Software using Semantic Versioning MUST declare a public API." MAJOR = incompatible; MINOR = backward-compatible features; PATCH = backward-compatible fixes.

- **[RUSTED]** The Rust Project. "What are Editions? — Rust Edition Guide," doc.rust-lang.org/edition-guide/editions/. AND newpavlov et al. "RFC 2495: Minimum Supported Rust Version (MSRV)." rust-lang/rfcs, 2018. https://rust-lang.github.io/rfcs/2495-min-rust-version.html
  *Grounds:* Supports the design of editions and MSRV-floor as two orthogonal versioning axes (language epoch vs. minimum toolchain), independent of the compiler release number.
  *Finding:* Editions are opt-in and per-crate ("each crate can decide when to migrate … independently"); crates of different editions interoperate. MSRV adds a `rust` field to `Cargo.toml`; cargo checks MSRV across the dependency tree. **Caveat:** the edition guide does NOT assert a fixed "~3 year cadence" — editions to date (2015/2018/2021/2024) are roughly 3 years apart but not a guaranteed schedule; the spec must not claim a guaranteed cadence.

- **[CSLANG]** Wagner, B. et al. "Language versioning" and "Configure language version." C# reference, Microsoft Learn (updated 2026-02-04 / 2026-01-16). https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-versioning
  *Grounds:* Intended to support the claim that the language version is a separate versioning axis decoupled from the SDK/compiler. **Corrected framing required.**
  *Finding (corrected):* LangVersion defaults from the target framework and is overridable via `<LangVersion>`, but is **capped by the installed compiler/SDK** ("can support any language version up to the version in the installed SDK"; newer-than-TFM is "unsupported"). Accurate framing: decoupled from the *target-framework default* (overridable) but **bounded by the installed compiler** — NOT independent of the SDK/compiler. The spec MUST NOT say LangVersion is "decoupled from the SDK/compiler."

- **[SARIF]** OASIS. "Static Analysis Results Interchange Format (SARIF) Version 2.1.0 Plus Errata 01." OASIS Standard, 28 August 2023. https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html
  *Grounds:* Supports using SARIF as the JSON interchange format for Swarm's diagnostics/findings (results in runs, rules carrying severity metadata).
  *Finding:* "A SARIF log file SHALL contain a serialization of the SARIF object model into the JSON format." `result`s are contained within `run`s; rules are `reportingDescriptor` objects. Severity is carried by the `level` property (error/warning/note/none), not a property literally named "severity" — the spec should reference `level`.

- **[OTELGENAI]** OpenTelemetry Authors. "Semantic conventions for generative AI (GenAI) spans." OpenTelemetry, 2024–2026. https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-spans/
  *Grounds:* Supports instrumenting Swarm agent/LLM calls with a vendor-neutral standard capturing model name and token usage (cost-relevant), with dedicated agent/framework spans.
  *Finding:* Defines `gen_ai.request.model`, `gen_ai.usage.input_tokens`, `gen_ai.usage.output_tokens`, `gen_ai.operation.name`; metrics include `gen_ai.client.token.usage`, `gen_ai.client.operation.duration`. **Caveat:** status is "Development" (experimental, not frozen — names may change); there is no first-class "cost" attribute, so cost must be phrased as "token usage from which cost is computed."

- **[OWASP-LLM01]** OWASP Gen AI Security Project. "LLM01:2025 Prompt Injection," OWASP Top 10 for LLM Applications 2025. https://genai.owasp.org/llmrisk/llm01-prompt-injection/
  *Grounds:* Supports designating prompt injection (including indirect/tool-and-content-borne injection) as the top LLM security risk Swarm must mitigate.
  *Finding:* #1 entry. "A Prompt Injection Vulnerability occurs when user prompts alter the LLM's behavior or output in unintended ways." Explicitly covers indirect injection (input from websites/files) and notes injections "do not need to be human-visible/readable, as long as the content is parsed by the model."

## LLM instruction-following & context

- **[IFSCALE]** Jaroslawicz, D., Whiting, B., Shah, P., Maamari, K. "How Many Instructions Can LLMs Follow at Once?" arXiv:2507.11538, 2025 (Distyl AI). https://arxiv.org/abs/2507.11538
  *Grounds:* The spec's core claim that instruction-following accuracy degrades with instruction density/count, that even frontier models top out well below 100%, and that there is a primacy/earlier-instruction bias — motivating bounded, ordered skill/instruction loading.
  *Finding:* IFScale = 500 keyword-inclusion instructions. "Even the best frontier models only achieve 68% accuracy at the max density of 500 instructions." Best model (gemini-2.5-pro) peaks ~84.8% near 250, drops to ~68.9% at 500. Confirmed primacy bias toward earlier instructions, most pronounced at ~150–200. **No "5,000-instruction," "~99%," or "inflection ~2,000" claim appears in this paper** — those come from [ARIZE26] below.

- **[FORMAT]** He, J., Rungta, M., Koleczek, D., Sekhon, A., Wang, F. X., Hasan, S. "Does Prompt Formatting Have Any Impact on LLM Performance?" arXiv:2411.10541, 2024 (Microsoft/MIT; NAACL 2025 Industry Track). https://arxiv.org/abs/2411.10541
  *Grounds:* The spec's claim that prompt/skill FORMAT (Markdown vs JSON vs YAML) measurably affects model output, magnitude being model-dependent (larger/newer models more format-robust).
  *Finding:* "GPT-3.5-turbo's performance varies by up to 40% in a code translation task depending on the prompt template," whereas "larger models like GPT-4 are more robust." GPT-3.5-turbo favors JSON; GPT-4 favors Markdown. **Caveat:** the 40% figure is GPT-3.5-turbo/code-translation-specific; do not generalize it to current frontier models.

- **[LOSTMID]** Liu, N. F., Lin, K., Hewitt, J., Paranjape, A., Bevilacqua, M., Petroni, F., Liang, P. "Lost in the Middle: How Language Models Use Long Contexts." Transactions of the ACL (TACL), Vol. 12, pp. 157–173, 2024. DOI 10.1162/tacl_a_00638. https://aclanthology.org/2024.tacl-1.9/ (preprint arXiv:2307.03172)
  *Grounds:* Primary, peer-reviewed source for long-context positional degradation ("context rot") — motivates positioning critical instructions at the start/end rather than the middle.
  *Finding:* "Performance is often highest when relevant information occurs at the beginning or end of the input context, and significantly degrades when models must access relevant information in the middle of long contexts" — a U-shaped curve, holding "even for explicitly long-context models." **Venue is TACL 2024** (not 2023; an early bibtex mislabeled the preprint). "Context rot" is a later popular term, not coined here.

- **[ARIZE26]** Voss, L. (Arize AI). "Models got an order of magnitude better at following instructions in one year." Arize AI company blog, 12 May 2026. https://arize.com/blog/llm-instruction-following-benchmark-2026/
  *Grounds:* The origin of the "≈5,000 instructions / ≈99% / inflection ≈2,000" figures, IF the spec cites them to justify large skill/instruction files. **Must be cited only as preliminary, non-peer-reviewed evidence — never as an established finding.**
  *Finding:* A 2026 re-run/extension of IFScale claims the degradation boundary moved from ~200–300 to "closer to 2,000 instructions," and "GPT 5.5 achieves 99% accuracy through N=5,000" ("~10X better in 12 months"). **Self-described as not-yet-a-formal-paper, measuring only keyword/named-item inclusion**; the authors caveat it is "evidence that long skills files are viable, not proof that every kind of instruction in them is followed." WEAK evidence — company blog, narrow proxy task. The "99% at N=5,000" must never be presented as a robust capability result.

## Multi-agent systems

- **[MAST]** Cemri, M., Pan, M. Z., Yang, S., Agrawal, L. A., Chopra, B., Tiwari, R., Keutzer, K., Parameswaran, A., Klein, D., Ramchandran, K., Zaharia, M., Gonzalez, J. E., Stoica, I. "Why Do Multi-Agent LLM Systems Fail?" NeurIPS 2025 (Datasets and Benchmarks Track); arXiv:2503.13657. https://arxiv.org/abs/2503.13657
  *Grounds:* The spec's central claim that specification/system-design and verification failures dominate multi-agent failure (spec+verification ≈ 63.07%; spec+coordination ≈ 78.71%) — motivating spec-driven + verification-first design.
  *Finding (corrected):* MAST taxonomy over 200+ traces, 7 frameworks, 6 annotators, Cohen's κ 0.88; 14 failure modes in 3 categories. Distribution (Fig. 2): FC1 "Specification Issues" 41.77%, FC2 "Inter-Agent Misalignment" 36.94%, FC3 "Task Verification" 21.30%. **Corrections:** FC1 is "Specification Issues" (not "Specification and System Design"); use exact percentages (41.77 / 36.94 / 21.30). Derived sums hold: spec+verification = 63.07%, spec+coordination = 78.71%.

- **[ANTHROPIC-MA]** Anthropic. "How we built our multi-agent research system." Anthropic Engineering blog, June 13, 2025. https://www.anthropic.com/engineering/multi-agent-research-system
  *Grounds:* The orchestrator-worker pattern as the design, and the claim that coding/shared-context tasks are poor multi-agent fits (favoring spec-driven coordination over naive parallel subagents in coding).
  *Finding:* Orchestrator-worker (lead + parallel subagents). "Most coding tasks involve fewer truly parallelizable tasks than research, and LLM agents are not yet great at coordinating … in real time." Domains needing shared context / many dependencies "are not a good fit for multi-agent systems today." Multi-agent outperformed single-agent Opus 4 by 90.2% on internal research eval; ~15x chat tokens.

- **[COGNITION]** Yan, W. "Don't Build Multi-Agents." Cognition blog, June 12, 2025. https://cognition.ai/blog/dont-build-multi-agents
  *Grounds:* The spec's argument for single-threaded execution and full-context sharing rather than fan-out parallel agents — the counterpoint grounding context-sharing/coordination decisions.
  *Finding:* Two principles: (1) "Share context, and share full agent traces, not just individual messages"; (2) "Actions carry implicit decisions, and conflicting decisions carry bad results." Recommends single-threaded linear agents. Authored by co-founder Walden Yan; the canonical opposing pair to [ANTHROPIC-MA].

- **[PLANCODER]** Lyu, Z., Chen, S., Ji, Z., Wang, L., Wang, S., Wu, D., Wang, W., Cheung, S.-C. "Understanding and Bridging the Planner-Coder Gap: A Systematic Study on the Robustness of Multi-Agent Systems for Code Generation." arXiv:2510.10460, Oct 2025. https://arxiv.org/abs/2510.10460
  *Grounds:* The spec's ~75%-of-failures claim about the planner→coder handoff, motivating an explicit interface/monitor (or spec artifact) between planning and coding agents.
  *Finding:* "the planner-coder gap … accounts for 75.3% of failures." Underspecified plans + coder misinterpretation; semantic-preserving input mutations break 7.9%–83.3% of previously-solved problems; a monitor agent repairs 40.0%–88.9% of failures.

## Spec-driven development

- **[SPECKIT]** GitHub. "Spec Kit: Toolkit to help you get started with Spec-Driven Development." https://github.com/github/spec-kit
  *Grounds:* The spec's claim that a mature spec-driven workflow exists with the phases constitution → specify → clarify → plan → tasks → analyze → implement, used to justify Swarm's phased pipeline.
  *Finding:* Open-source SDD toolkit with those seven phases (shipping commands are namespaced, e.g. `/speckit.specify`; `analyze` is a consistency/quality gate after tasks, before implement). Constitution = immutable governing principles; SDD makes "code serves specifications."

- **[KIRO]** AWS / Kiro. "Feature Specs" (spec-driven development docs). https://kiro.dev/docs/specs/feature-specs/
  *Grounds:* The spec's claim that an industrial spec-driven flow (requirements→design→tasks, EARS-based) exists in a shipping tool, reinforcing Swarm's spec-first methodology.
  *Finding:* Kiro specs = three files: requirements.md (user stories + acceptance criteria in EARS), design.md (architecture), tasks.md (implementation plan). EARS form: "WHEN [condition/event] THE SYSTEM SHALL [expected behavior]."

## Verification & proof

- **[VERINA]** Ye, Z., Yan, Z., He, J., Kasriel, T., Yang, K., Song, D. "VERINA: Benchmarking Verifiable Code Generation." arXiv:2505.23135, 2025. https://arxiv.org/abs/2505.23135 (OpenReview: openreview.net/forum?id=0A4Uf88pog)
  *Grounds:* The claim that joint code+spec+proof generation is a near-total failure for frontier models at single-trial — motivating staged/assisted verification rather than one-shot LLM proofs.
  *Finding:* 189 manually-curated Lean tasks (code + formal spec + proof). Best model OpenAI o3: 72.6% code correctness, 52.3% spec soundness/completeness, and "a mere 4.9% proof success rate (based on one trial per task)." **Venue correction:** arXiv / OpenReview (ICLR track), NOT ICML 2025.

- **[VERICODING]** Bursuc, S., Ehrenborg, T., Lin, S., Astefanoaei, L., Chiosa, I. E., Kukovec, J., Singh, A., Butterley, O., Bizid, A., Dougherty, Q., Zhao, M., Tan, M., Tegmark, M. "A Benchmark for Vericoding: Formally Verified Program Synthesis." arXiv:2509.22908, 2025. https://arxiv.org/abs/2509.22908
  *Grounds:* The claim that mechanized proof / verified-code-synthesis is high for Dafny (rebutting blanket single-digit pessimism). **Corrected framing required.**
  *Finding:* ~12,504 formal specs. Best-approach success: Dafny 82%, Verus/Rust 44%, Lean 27%; "LLM progress has improved … pure Dafny verification from 68% to 96% over the past year." **Correction:** results are language-specific — high (82–96%) for Dafny but still low for Lean (27%)/Verus. The spec MUST NOT assert a blanket "mechanized proof is no longer single-digit %"; correct framing: "high for Dafny, still low for Lean/Verus." This does not contradict [VERINA]'s 4.9% Lean end-to-end proof.

- **[DAFNYBENCH]** Loughridge, C., Sun, Q., Ahrenbach, S., Cassano, F., Sun, C., Sheng, Y., Mudide, A., Misu, M. R. H., Amin, N., Tegmark, M. "DafnyBench: A Benchmark for Formal Software Verification." arXiv:2406.08467, 2024 (ICLR 2025 DL4C workshop). https://arxiv.org/abs/2406.08467
  *Grounds:* Establishes the Dafny LLM-verification baseline and the prior-year reference point for proof-completion progress; grounds Swarm's verifier-in-the-loop benchmarking.
  *Finding:* LLMs auto-generate hints so the Dafny verifier succeeds on "over 750 programs with about 53,000 lines of code"; best model/prompting achieved 68% success — the same 68% baseline [VERICODING]'s "68%→96%" trajectory anchors to.

- **[SWEBENCH-ADQ]** Wang, Y., Pradel, M., Liu, Z. "Are 'Solved Issues' in SWE-bench Really Solved Correctly? An Empirical Study." arXiv:2503.15223, 2025 (ICSE 2026). https://arxiv.org/abs/2503.15223
  *Grounds:* Oracle-adequacy motivation — SWE-bench Verified's bundled tests are an inadequate oracle, so passing the official suite overstates correctness; motivates requiring stronger/independent oracles. **One number corrected.**
  *Finding:* "7.8% of all patches count as correct while failing the developer-written test suite"; aggregate weaknesses "lead to an inflation of reported resolution rates by 6.2 absolute percent points." (29.6% of plausible patches behave differently from ground-truth; 28.6% of those certainly incorrect.) **Correction:** the spec MUST use **6.2 pp** inflation; any "~14.5 pt" figure is fabricated/absent and MUST be dropped.

- **[ORACLE]** Barr, E. T., Harman, M., McMinn, P., Shahbaz, M., Yoo, S. "The Oracle Problem in Software Testing: A Survey." IEEE Transactions on Software Engineering, 41(5):507–525, May 2015. DOI 10.1109/TSE.2014.2372785. http://www0.cs.ucl.ac.uk/staff/m.harman/tse-oracle.pdf
  *Grounds:* Primary, peer-reviewed grounding for the "test-oracle problem" and property-based/metamorphic testing as the principled response — why Swarm cannot rely on a single concrete-test oracle.
  *Finding:* Canonical survey defining the test-oracle problem and cataloguing oracle types — specified, derived, implicit, and metamorphic-testing pseudo-oracles — for cases where a precise oracle is unavailable. (Strongest available primary source; prefer over blogs/preprints.)

## LLM-as-judge & evaluation

- **[MTBENCH]** Zheng, L., Chiang, W.-L., Sheng, Y., Zhuang, S., Wu, Z., Zhuang, Y., Lin, Z., Li, Z., Li, D., Xing, E. P., Zhang, H., Gonzalez, J. E., Stoica, I. "Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena." NeurIPS 2023 Datasets and Benchmarks Track; arXiv:2306.05685, 2023. https://arxiv.org/abs/2306.05685
  *Grounds:* Primary source for LLM-judge position/verbosity/self-preference bias, and for the "~80% judge↔human agreement (= human-human level)" figure. **Use this for any human-agreement number — not [TRUSTJUDGE].**
  *Finding:* Documents position bias, verbosity bias, self-enhancement (self-preference) bias, limited reasoning. Strong judges like GPT-4 "can match both controlled and crowdsourced human preferences well, achieving over 80% agreement, the same level of agreement between humans."

- **[TRUSTJUDGE]** Schroeder, K., Wood-Doughty, Z. "Can You Trust LLM Judgments? Reliability of LLM-as-a-Judge." arXiv:2412.12509, Dec 2024 (rev. Feb 2025). https://arxiv.org/abs/2412.12509
  *Grounds:* Supports "single-judge LLM scores are not internally reliable; aggregate/replicate." **Does NOT support any judge↔expert agreement percentage.**
  *Finding:* Internal-consistency-reliability framework using McDonald's omega over 100 replicated evaluations (varying seeds). Omega 0.462–0.803 across judges/benchmarks (mostly "questionable" 0.6–0.7 to "acceptable" 0.7–0.8); multi-judge inter-rater reliability 0.167–1.000. "LLM judgment reliability is a significant concern." **Correction:** the "~60–68% judge↔expert agreement" attributed to this paper is fabricated (a mis-transcription of the 0.6–0.7 omega band). For a human-agreement %, cite [MTBENCH] (~80%).

- **[PREFLEAK]** Li, D., Sun, R., Huang, Y., Zhong, M., Jiang, B., Han, J., Zhang, X., Wang, W., Liu, H. "Preference Leakage: A Contamination Problem in LLM-as-a-judge." ICLR 2026 (accepted); arXiv:2502.01534, Feb 2025. https://arxiv.org/abs/2502.01534
  *Grounds:* The requirement that the judge model must NOT share lineage/family with the candidate/generator model (else inflated, contaminated scores).
  *Finding:* Defines preference leakage from relatedness between data-generator and judge LLMs. Three relatedness types: same model, inheritance (teacher→student), same model family. Judges are empirically biased toward related student models, a bias "harder to detect" than previously identified LLM-judge biases.

- **[BDCSURVEY]** Xu, C., Guan, S., Greene, D., Kechadi, M-T. "Benchmark Data Contamination of Large Language Models: A Survey." arXiv:2406.04244, Jun 2024. https://arxiv.org/abs/2406.04244
  *Grounds:* Using held-out and mutated/regenerated test fixtures (rather than static public benchmarks) for agent evaluation gates.
  *Finding:* Surveys benchmark data contamination (training on eval data → "inaccurate or unreliable performance"). Mitigations: Data Curation (private + dynamic benchmarks), Data Refactoring (data regeneration, e.g. EvoEval/DyVal 2, + content filtering), Benchmark-free Evaluation (LLM-as-judge, human). **Caveat:** does NOT discuss canary strings — do not attribute canary-string claims to it.

- **[TTC]** Ma, Y., Li, Y., Dong, Y., Jiang, X., Cao, R., Chen, J., Huang, F., Li, B. "Thinking Longer, Not Larger: Enhancing Software Engineering Agents via Scaling Test-Time Compute." arXiv:2503.23803, Mar 2025. https://arxiv.org/abs/2503.23803
  *Grounds:* Test-time-compute budgeting — allocating more inference compute/search budget to harder tasks instead of larger models.
  *Finding:* A 32B "SWE-Reasoner" with internal TTC reaches 37.60% on SWE-bench Verified; external TTC (budget=8) raises it to 46.00%, surpassing far larger models (DeepSeek R1 671B, OpenAI o1); models "dynamically allocate more tokens to … challenging problems." **Caveat:** SWE-agent-specific, not a general scaling law (cite Snell et al. arXiv:2408.03314 for a general claim).

## Agent memory & governance

- **[MEMGPT]** Packer, C., Wooders, S., Lin, K., Fang, V., Patil, S. G., Stoica, I., Gonzalez, J. E. "MemGPT: Towards LLMs as Operating Systems." arXiv:2310.08560, 2023. https://arxiv.org/abs/2310.08560
  *Grounds:* The correct primary source for any "two-tier agent memory" / RAM-vs-disk context-management claim. **Use this for a true two-tier framing, not [MEMTIER].**
  *Finding:* Two-tier memory: main context (in-context tokens ≈ RAM) and external context (out-of-context ≈ disk: recall + archival storage). The LLM self-manages paging via function calls (OS virtual-memory analogy). Now the Letta framework.

- **[MEM0]** Chhikara, P., Khant, D., Aryan, S., Singh, T., Yadav, D. "Mem0: Building Production-Ready AI Agents with Scalable Long-Term Memory." arXiv:2504.19413, Apr 2025. https://arxiv.org/abs/2504.19413
  *Grounds:* The spec's extract-consolidate-retrieve memory pipeline and production agent-memory claims.
  *Finding:* Memory-centric architecture that dynamically extracts, consolidates, and retrieves salient information across sessions; graph variant (Mem0-g) for relational structure. Evaluated on LOCOMO vs memory-augmented/RAG/full-context baselines with improved accuracy and lower latency/cost.

- **[AMEM]** Xu, W., Liang, Z., Mei, K., Gao, H., Tan, J., Zhang, Y. "A-MEM: Agentic Memory for LLM Agents." arXiv:2502.12110, Feb 2025. https://arxiv.org/abs/2502.12110
  *Grounds:* The spec's self-organizing/linked agent-memory claims as an alternative to fixed-schema stores.
  *Finding:* Zettelkasten-inspired agentic memory that autonomously builds interconnected knowledge networks via dynamic indexing/linking; each memory generates a structured note (description, keywords, tags) linked to related notes, refining over time.

- **[MEMTIER]** Sidik, B., Rokach, L. (Ben-Gurion University of the Negev). "MEMTIER: Tiered Memory Architecture and Retrieval Bottleneck Analysis for Long-Running Autonomous AI Agents." arXiv:2605.03675, May 2026. https://arxiv.org/abs/2605.03675
  *Grounds:* The spec's tiered agent-memory and episodic→semantic consolidation claims. **Corrected name & framing required.**
  *Finding:* Tripartite (episodic JSONL store + async consolidation daemon promoting episodic→semantic + five-signal weighted retrieval + PPO weight-adaptation). Result: "Acc=0.382, F1=0.412" with Qwen2.5-7B on a 6GB GPU, "+33 percentage point improvement over the full-context baseline (0.050 → 0.382)" on 500-question LongMemEval-S. **Corrections:** the name is MEMTIER (not "TierMem") and it is *tripartite*, not "two-tier" — use [MEMGPT] for a true two-tier claim.

- **[SSGM]** Lam, C., Li, J., Zhang, L., Zhao, K. "Governing Evolving Memory in LLM Agents: Risks, Mechanisms, and the Stability and Safety Governed Memory (SSGM) Framework." arXiv:2603.11768, Mar 2026 (v2 May 2026). https://arxiv.org/abs/2603.11768
  *Grounds:* The spec's memory-governance claims — validation-before-commit, consistency verification, and rollback/decay of agent memory.
  *Finding:* Conceptual governance architecture that "decouples memory evolution from execution by enforcing consistency verification, temporal decay modeling, and dynamic access control prior to any memory consolidation." Taxonomy of three failure points: memory poisoning (ingestion), semantic drift (consolidation), conflict/hallucination (retrieval). **Caveat:** conceptual/position framework with no headline accuracy number — attributing a quantitative result to SSGM would be misrepresentation.

## Determinism

- **[DETERMINISM]** He, H. et al., Thinking Machines Lab. "Defeating Nondeterminism in LLM Inference." Thinking Machines Lab blog, 10 Sep 2025. https://thinkingmachines.ai/blog/defeating-nondeterminism-in-llm-inference/
  *Grounds:* The spec's determinism claim — that reproducible/deterministic agent inference is attainable via batch-invariant kernels rather than being a hard hardware limit.
  *Finding:* Nondeterminism stems from lack of batch-invariance, not inherent FP/concurrency randomness — "the primary reason … is that the load (and thus batch-size) nondeterministically varies." Fix: batch-invariant RMSNorm/matmul/attention. Across 1,000 completions, batch-invariant kernels gave 1 unique output vs 80 for standard vLLM. **Caveat:** lab blog, not peer-reviewed (the canonical original); corroborated by Simon Willison and LMSYS/SGLang's deterministic-inference reproduction.

## Security (spec / config-file injection)

- **[RULESBACKDOOR]** Karliner, Z. et al. "New Vulnerability in GitHub Copilot and Cursor: How Hackers Can Weaponize Code Agents." Pillar Security blog, March 18, 2025. https://www.pillar.security/blog/new-vulnerability-in-github-copilot-and-cursor-how-hackers-can-weaponize-code-agents
  *Grounds:* The spec's spec-injection threat model — that agent rule/config files are an injection vector and must be treated as untrusted/sanitized.
  *Finding:* "Rules File Backdoor" embeds attacker instructions in AI-assistant rule files via "zero-width joiners, bidirectional text markers, and invisible characters" (Unicode obfuscation) — invisible to humans, parsed by the AI. Working exploits vs GitHub Copilot and Cursor (.cursor/rules); persists across forks (supply-chain risk). Corroborated by MITRE ATLAS AML.CS0041.

- **[NVIDIA-AGENTSMD]** Teixeira, D. (NVIDIA AI Red Team). "Mitigating Indirect AGENTS.md Injection Attacks in Agentic Environments." NVIDIA Technical Blog, April 20, 2026. https://developer.nvidia.com/blog/mitigating-indirect-agents-md-injection-attacks-in-agentic-environments/
  *Grounds:* That agent instruction files (AGENTS.md, CLAUDE.md, .cursorrules) expand the indirect-prompt-injection surface — the spec's requirement to protect/validate config files.
  *Finding:* A compromised dependency can write a malicious AGENTS.md that overrides user instructions and hides modifications (e.g., injecting a delay, omitting changes from PR summaries, biasing downstream summarizers via comments). Demonstrated vs OpenAI Codex via a malicious Go library at build time. Recommends restricting agent file read/write scope and config-file integrity enforcement.

- **[CVE-2025-61592]** NIST NVD. "CVE-2025-61592." Published October 3, 2025 (CNA: GitHub, Inc.). https://nvd.nist.gov/vuln/detail/CVE-2025-61592
  *Grounds:* Concrete CVE demonstrating spec/rules-file prompt injection escalating to RCE in a real coding agent — strongest evidence for "treat config/rules as untrusted."
  *Finding:* In Cursor (Anysphere) ≤ v1.7, auto-loading project `.cursor/cli.json` from cwd could override global config, enabling RCE in a malicious repo via permissive shell-command config + prompt injection through `.cursor/rules`. **CVSS 3.1 base 8.8 HIGH** (AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H). Patch 2025.09.17-25b418f. (Note: 8.8 is the score; 3.1 is the CVSS version.)

## Context-file efficacy & evaluation hygiene

- **[SKILLSBENCH]** Li, X. et al. "SkillsBench: Benchmarking How Well Agent Skills Work Across Diverse Tasks." arXiv:2602.12670, Feb 13, 2026. https://arxiv.org/abs/2602.12670
  *Grounds:* Empirical evidence that curated, modular skill/context files measurably help agents (and bloated/self-authored ones don't) — supports the spec's modular-skill design and "curate, don't dump" guidance.
  *Finding:* 86 tasks, 11 domains, deterministic verifiers, 7 model configs, 7,308 trajectories. Curated Skills raise average pass rate by 16.2 pp (+4.5 pp SWE to +51.9 pp Healthcare); 16/84 tasks show negative deltas; self-generated Skills give no average benefit; focused 2–3-module Skills beat comprehensive docs. (Not yet peer-reviewed.)

- **[CONTEXTCOV]** Sharma, R. K. "ContextCov: Deriving and Enforcing Executable Constraints from Agent Instruction Files." arXiv:2603.00822, v1 Feb 28, 2026 (v2 May 4, 2026). https://arxiv.org/abs/2603.00822
  *Grounds:* That converting agent instruction files into enforced/executable constraints raises compliance — backs the spec's "instructions-as-enforced-rules" direction. **One claim must be dropped.**
  *Finding:* "88.3% constraint compliance (vs. 67.0% and 50.3%) with 3.4× lower feedback cost, while maintaining functional correctness"; extracts 46,000+ executable checks across 723 repos (99.997% syntax validity). **Correction:** the "McNemar's test, p=0.031" attached to the 88.3% vs 67.0% comparison is **fabricated** — no p-value appears in the paper. Cite the (three-way) compliance numbers; DROP the McNemar/p-value claim.

- **[AGENTREADMES]** Chatlatanagulchai, W., Li, H., Kashiwa, Y., Reid, B. et al. "Agent READMEs: An Empirical Study of Context Files for Agentic Coding." arXiv:2511.12884, Nov 2025. https://arxiv.org/abs/2511.12884
  *Grounds:* That real-world context/agent files under-specify security/performance and accumulate debt — supports the spec's call for structured, maintained, security-aware context files.
  *Finding:* Study of 2,303 context files from 1,925 repos. Functional content dominates (implementation 69.9%, architecture 67.7%, build/run 62.3%); non-functional rare (security 14.5%, performance 14.5%). Files "evolve like configuration code"; Claude Code files have median Flesch reading ease ~16.6 ("very difficult to read") → "context debt." (Not yet peer-reviewed.)

- **[AGENTSMD-HARM]** Gloaguen, Mündler, Müller, Raychev, Vechev. "Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?" arXiv:2602.11988, Feb 2026. https://arxiv.org/abs/2602.11988 (companion: "On the Impact of AGENTS.md Files on the Efficiency of AI Coding Agents," arXiv:2601.20404)
  *Grounds:* The correct primary source for whether AGENTS.md/context files help — replaces the unverifiable "EASE 2025" attribution. Corroborates "focused beats comprehensive" from [SKILLSBENCH]/[CONTEXTCOV].
  *Finding:* Finds context files can *reduce* task success vs no-context and raise inference cost >20% — i.e., over-specified context files are harmful, motivating "curate, don't dump."

- **[HILBENCH]** "HiL-Bench (Human-in-Loop Benchmark): Do Agents Know When to Ask for Help?" arXiv:2604.09408, April 2026. https://arxiv.org/abs/2604.09408
  *Grounds:* The spec's human-in-the-loop / clarification-escalation requirement — agents fail when specs are ambiguous and don't reliably ask.
  *Finding:* Benchmarks selective escalation; core metric Ask-F1 (harmonic mean of question precision and blocker recall). Frontier agents solve up to ~89% of SWE/SQL tasks with full info, but with messy/ambiguous specs the best model drops to ~24% even with a tool to ask for help. (Not yet peer-reviewed.)

- **[HOW2BENCH]** Cao, J., Chan, Y.-K. et al. "Rigor, Reliability, and Reproducibility Matter: A Decade-Scale Survey of 572 Code Benchmarks" (earlier titles: "How Should We Build A Benchmark? Revisiting 274 Code-Related Benchmarks for LLMs"). arXiv:2501.10711, 2025. https://arxiv.org/abs/2501.10711
  *Grounds:* The spec's "rigorous, reproducible evaluation" / benchmark-hygiene requirement.
  *Finding:* Introduces the HOW2BENCH 55-item checklist over the full benchmark lifecycle. ~70% of benchmarks took no data-quality-assurance measures; >10% not (fully) open-sourced; many highly-cited benchmarks have duplicated samples / incorrect references; a 49-participant study found low awareness of quality/reproducibility/transparency. **Caveat:** cite by arXiv ID and the named artifact "HOW2BENCH" (sample count differs across versions: 274 → 572).

- **[REAGENT]** "REAgent: Requirement-Driven LLM Agents for Software Issue Resolution." arXiv:2604.06861, April 8, 2026. https://arxiv.org/abs/2604.06861
  *Grounds:* Tangential — only cite if the spec makes a "requirements-first issue-resolution" argument. Off-topic for spec-injection security / context-file efficacy.
  *Finding:* A requirement-driven agent that generates/refines structured issue-oriented requirements before patching; evaluated on SWE-bench Lite/Verified/Pro (DeepSeek-V3.2, Qwen-Plus). (Verify the exact claim before citing; not peer-reviewed; low relevance.)

## Rejected / unverifiable (do NOT cite)

These could not be confirmed against a primary source, or the specific cited fact does not exist in the named source. They MUST NOT be cited. Where a real source covers the same ground, the replacement key is named.

- **"Arize 99% / N=5,000 / inflection ≈2,000" as established fact** — The numbers are real (traceable to [ARIZE26]) but the *characterization* as a robust capability result is rejected. [ARIZE26] is a non-peer-reviewed company blog measuring only keyword inclusion and self-described as not-yet-a-formal-paper. Cite ONLY as preliminary/WEAK evidence, never as established. Do not present "99% at N=5,000" as a capability finding.
- **"IFScale 5,000 instructions / ~99% / inflection ~2,000 / 2026 re-run"** — These do NOT appear in [IFSCALE] (arXiv:2507.11538), which caps at 500 instructions and ~68%. Any attribution of those numbers to IFScale is wrong; they belong to [ARIZE26] (and are WEAK there).
- **"~60–68% judge↔expert agreement" attributed to arXiv:2412.12509 ([TRUSTJUDGE])** — Fabricated. That paper measures internal-consistency (McDonald's omega 0.462–0.803), not expert agreement; the "60–68%" is a mis-transcription of the 0.6–0.7 omega band. For a human-agreement %, use [MTBENCH] (~80%).
- **"SWE-bench ~14.5 pt resolve-rate drop when tests strengthened"** — Fabricated/absent from arXiv:2503.15223. The real figure is **6.2 pp** inflation ([SWEBENCH-ADQ]); the 7.8% extra-test-failure figure is real, the 14.5 is not.
- **"ContextCov McNemar's test, p=0.031"** — Fabricated. No McNemar test or p-value appears in arXiv:2603.00822. The 88.3% vs 67.0% vs 50.3% compliance numbers ([CONTEXTCOV]) are real; the statistical test is invented.
- **"EASE 2025" (as a cited agent-context / spec-injection study)** — Unverifiable. EASE 2025 is a real conference but no specific paper/number maps to this citation. The underlying AGENTS.md-efficacy claim lives on arXiv — use [AGENTSMD-HARM] (arXiv:2602.11988) and/or arXiv:2601.20404 instead.
- **"TierMem" (as a named two-tier memory system)** — No such name. The real paper is [MEMTIER] (arXiv:2605.03675) and is *tripartite*, not two-tier. For a true two-tier claim use [MEMGPT].
- **"RIVA representation/embedding drift"** — Scope error. RIVA (arXiv:2603.02345) is Infrastructure-as-Code **configuration** drift detection, not representation/embedding/semantic drift. Do NOT cite RIVA for representation drift. For behavioral drift, a closer match is arXiv:2601.04170 ("Agent Drift: Quantifying Behavioral Degradation in Multi-Agent LLM Systems") — verify before relying on it; for IaC config drift, RIVA is fine but only for that scope.
- **"H-MEM" (agent-memory paper)** — No canonical H-MEM agent-memory paper was identifiable. Treat any "H-MEM" citation as unverified until a specific id/URL is provided. Use [AMEM]/[MEM0]/[MEMGPT] for agentic/linked/tiered memory.
- **"VERINA at ICML 2025" / "vericoding as a VERINA rebuttal" / blanket "mechanized proof is no longer single-digit %"** — Venue/scope errors. [VERINA] is arXiv/OpenReview (not ICML 2025). [VERICODING]'s high numbers are Dafny-only (Lean still 27%); the blanket "no longer single-digit" generalization is rejected.
