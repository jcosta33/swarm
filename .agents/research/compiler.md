# A Controlled Language and Compiler Architecture for Agentic Specs

## What the evidence supports

The strongest defensible conclusion is that the future “compiler from specs to code” should **not** be framed as better prompt hacks, more personas, or a larger pile of reusable skills. The most stable finding across current evidence is narrower: large language models perform better when instructions are **explicit, scoped, structured, example-backed, and context-bounded**, but these instructions remain **soft control surfaces**, not enforcement. Anthropic’s own Claude Code documentation states that `CLAUDE.md` and memory are treated as **context, not enforced configuration**, and recommends hooks when behavior must be blocked deterministically. At the same time, Anthropic’s prompting guidance, Google’s Gemini guidance, and OpenAI’s Structured Outputs guidance all converge on the same practical themes: explicit direction, clear structure, examples, constrained outputs, and decomposition into smaller steps improve reliability, but none of those mechanisms removes the need for validation or enforcement. citeturn38search1turn37view0turn21view2turn22view0turn22view2turn22view3turn23view2

Three empirical results matter more than almost anything else for the design of a spec language. First, ambiguity materially harms code generation: the Orchid benchmark shows that ambiguous requirements consistently reduce performance and cause divergent implementations, and models often fail to recognize or resolve the ambiguity on their own. Second, long context is not the same thing as usable context: “Lost in the Middle” shows that relevant information buried in the middle of long inputs is used less reliably. Third, multi-turn conversations degrade reliability: a 2025 large-scale study found an average 39% drop across six generation tasks, driven less by a loss of raw capability than by increased unreliability and poor recovery after an early mistaken assumption. Taken together, these results strongly support a workflow in which messy discussion is converted into short, stable, analyzable artifacts before execution. citeturn13view2turn14search0turn13view1

The evidence also argues against over-romanticizing repository instructions or configuration-file craft. One 2026 study found that `AGENTS.md` presence was associated with lower median runtime and lower output token use while keeping completion behavior comparable, which is a meaningful signal in favor of a concise repository entrypoint. But another 2026 study found that repository-level context files often **reduced** success rates and increased inference cost when they added unnecessary requirements, and a separate factorial study found no detectable adherence gains from the specific structural variables people often obsess over, such as position, file size, or splitting content across files. The right synthesis is therefore not “write huge instruction files” or “the perfect heading order will save you.” It is: keep always-loaded instructions short, put only non-inferable universal facts there, and move large procedures into lazily loaded artifacts. citeturn24search0turn25view0turn27view0

That leads to the central design claim for Swarm’s future language: **the unit of reliability is not the prompt, and not the skill; it is the combination of a constrained specification language, static checks, deterministic validators, and phase-separated lowering into task-sized execution artifacts**. Controlled natural language is already established as a way to reduce ambiguity without abandoning human readability. EARS constrains requirement clauses into a small number of ordered patterns. Rimay shows that a domain-specific controlled language can cover a large proportion of real functional requirements, and later work shows that requirement smells and template non-conformance can be detected automatically with strong precision and recall. That is the direction that is actually supported: not “English, but better vibes,” and not “a formal theorem prover everywhere,” but a constrained natural language with analyzable structure. citeturn12view0turn34search0turn34search4turn33search7

## How to write the prose layer

The prose layer should be treated as a **performance-critical interface**, not just “whatever readable English happens to say the right thing.” There is very strong official guidance, and useful prior art, on what that interface should look like. U.S. government plain-language guidance, NIH plain-language guidance, and ASD-STE100 Simplified Technical English all converge on a small set of rules: use active voice, keep sentences short, keep one idea per sentence, remove padding words, prefer common words unless technical terms are required, define specialist terms when needed, and organize information so that the main point appears early and headings/lists/tables expose structure clearly. Anthropic and Google add the LLM-specific version of the same message: be precise, use consistent delimiters, state scope explicitly, and avoid unnecessary rhetoric. citeturn19view0turn19view1turn19view2turn19view3turn20view0turn9search0turn9search1turn22view0turn15view2

The practical implication is that Swarm should define a **controlled prose profile** for all human-readable normative text. This profile should not pretend to be mathematically optimal, because that evidence does not exist. It should instead represent the highest-confidence cross-source consensus.

The profile below is the strongest current synthesis of the evidence. It combines official LLM prompting guidance, plain-language guidance, and controlled-language prior art. citeturn19view0turn20view0turn9search0turn21view4turn22view0

| Rule                                                     | Why it belongs                                                                                                                                 |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Name the actor explicitly.                               | Active voice reduces ambiguity about who does what.                                                                                            |
| Keep one idea per sentence.                              | Both readers and models handle atomic statements better than bundled obligations.                                                              |
| Prefer short sentences.                                  | Official plain-language guidance repeatedly recommends short sentences; NIH suggests ~20 words or fewer, and OPM suggests 15–20 as an average. |
| Put the main point first.                                | Readers and models both benefit when the key obligation or conclusion appears early.                                                           |
| Use common words by default.                             | Technical vocabulary should be intentional, not ornamental.                                                                                    |
| Remove padding and emphasis adverbs.                     | Words like “very,” “really,” “actually,” and “carefully” generally add little operational meaning.                                             |
| Prefer positive instructions over negative-only wording. | Anthropic explicitly recommends telling the model what to do rather than only what not to do.                                                  |
| Use consistent section markers.                          | Anthropic and Google both recommend XML-style tags or clear headings when prompts mix instructions, context, and examples.                     |
| Use canonical examples, not a dump of edge cases.        | Both Anthropic and Google emphasize the value of examples, but advise curation rather than laundry lists.                                      |
| Keep normative text distinct from explanation.           | Mixed-purpose writing increases interpretation burden and makes later linting harder.                                                          |

Some rules should be treated as **style heuristics**, not syntax. Sentence-length targets belong here. So does the default preference for present tense, common words, and minimal rhetoric. These improve clarity, but they should not block compilation unless a project deliberately chooses stricter linting. Digital.gov recommends active voice and present tense; NIH recommends one idea per sentence and stripping padding words; NARA recommends active voice, short sentences, everyday words, omitted filler, and keeping subject and verb close. citeturn19view0turn20view0turn19view3

Other rules should be treated as **hard syntax or semantic lint**. The most important are the ones that make a statement incomplete, non-obligatory, or untestable. This is where the “if I say ‘when X’ I must follow it with a consequence” idea becomes real.

The following should be hard errors in the language:

| Error                                           | Example of failure                                         | Why it must fail                                                    |
| ----------------------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------- |
| Dangling condition                              | `WHEN token expires.`                                      | A trigger without a response is incomplete.                         |
| Missing actor                                   | `MUST retry once.`                                         | The responsible system/component is unclear.                        |
| Missing modality                                | `WHEN request fails, the client retries.`                  | No normative force.                                                 |
| Multiple bundled obligations without separation | `The API MUST validate input and log and retry and alert.` | Not atomic; hard to verify and diff.                                |
| Undefined term                                  | `Use hardened mode.`                                       | The term has no stable meaning unless defined.                      |
| Vague quality word without measure              | `The response must be fast.`                               | Not testable.                                                       |
| Missing verification binding                    | Requirement has no test, check, or proof mapping.          | Not reviewable, and not compilers’ end-state material.              |
| Mixed temporal patterns                         | `WHILE upload starts...`                                   | Event and state semantics are being conflated.                      |
| Double negation or negation ambiguity           | `Do not fail to preserve state.`                           | Negation is a known model weakness and a human readability problem. |

Negation deserves explicit caution. NIH guidance recommends positive wording because negatives can make readers stumble, and recent research shows that language models can mishandle negated instructions badly enough to invert prohibitions in some settings. That does **not** mean negative constraints should be banned; it means they should be written in a carefully normalized form and, when important, paired with the affirmative behavior that should happen instead. Use `MUST NOT` when prohibition is genuinely load-bearing, but avoid compound negation and avoid phrasing that leaves the safe alternative implicit. citeturn20view0turn17search5turn17search14turn21view3

This is also where “improve” must stop being a vibe word. Improvement should be decomposed into named transforms with concrete exit conditions. The AI should never be asked to “improve the spec” in the abstract. It should be asked to run one or more specific rewrites such as the following:

| Rewrite      | Exact meaning                                                                  |
| ------------ | ------------------------------------------------------------------------------ |
| `clarify`    | Remove ambiguity, fill missing actor/trigger/response, define missing terms.   |
| `atomize`    | Split multi-obligation sentences into atomic requirements.                     |
| `normalize`  | Convert wording into canonical clause order and approved modals/keywords.      |
| `quantify`   | Replace vague quality words with measurable thresholds or observable outcomes. |
| `bind-proof` | Add a verification mapping for each normative statement.                       |
| `scope`      | Add explicit non-goals, applicability, and exclusions.                         |
| `deconflict` | Detect and resolve contradictions with other requirements or decisions.        |
| `decompose`  | Partition a source spec into task-sized units or child specs.                  |

That definition of “improve” is not merely stylistic. It creates an analyzable rewrite library that can later be linted, benchmarked, and eventually automated. The idea is directly aligned with prior work on requirements smells and template conformance checking, where systems detect specific defects and recommend structured repairs rather than attempting an open-ended rewrite. citeturn32search0turn33search7

## What the syntax should encode

The best near-term target is a **controlled English syntax**, not a fully symbolic language and not unconstrained prose. EARS is the strongest direct prior art for this choice because it keeps requirements readable while constraining clause order and semantics. Its core patterns distinguish ubiquitous requirements, event-driven requirements, state-driven requirements, and optional-feature requirements with a small set of keywords such as `When`, `While`, and `Where`. Gherkin provides a complementary lesson on test-oriented behavior phrasing: fixed keywords and stable sequencing reduce ambiguity and force clearer domain language. RFC 2119 and RFC 8174 provide the best-established normative modal vocabulary for obligation levels, with the important clarification that the keywords carry special meaning only when written in uppercase. citeturn12view0turn12view1turn12view2turn12view3

That suggests the following design principle: **borrow EARS for clause shape and RFC 2119/8174 for modal semantics**. In other words, Swarm’s requirement language should probably use clause starters like `WHEN`, `WHILE`, `WHERE`, and possibly `IF`, but use uppercase `MUST`, `MUST NOT`, `SHOULD`, and `MAY` for obligation. This keeps the syntax close to natural English while making the normative force precise. citeturn12view0turn12view2turn12view3

A strong starting grammar would look like this:

| Pattern                                                          | Intended meaning                                      |
| ---------------------------------------------------------------- | ----------------------------------------------------- |
| `THE <actor> MUST <response>.`                                   | Ubiquitous requirement. Always applies.               |
| `WHEN <trigger>, THE <actor> MUST <response>.`                   | Event-driven requirement.                             |
| `WHILE <state>, THE <actor> MUST <response>.`                    | State-driven requirement.                             |
| `WHERE <feature or configuration>, THE <actor> MUST <response>.` | Optional-feature requirement.                         |
| `IF <undesired condition>, THE <actor> MUST <mitigation>.`       | Exception, error, or unwanted-behavior handling.      |
| `THE <actor> MUST NOT <action>.`                                 | Prohibition. Use only when prohibition truly matters. |
| `VERIFY <proof binding>.`                                        | Required proof target for the preceding requirement.  |

A parseable surface form could be as simple as this:

```text
REQ AUTH-001
WHEN refresh token is expired,
THE client MUST clear the local session
AND MUST redirect the browser to "/login".
VERIFY test auth.refresh.expired_redirects
SOURCE bug BR-017
```

And this:

```text
REQ IMPORT-004
WHILE the import job is running,
THE worker MUST persist progress every 100 rows.
VERIFY test import.progress_checkpointing
SOURCE spec import-reliability
```

The important thing is not the exact punctuation. The important thing is that the surface syntax can be lowered into a stable intermediate representation with at least these fields:

| Field           | Meaning                                          |
| --------------- | ------------------------------------------------ |
| `id`            | Stable requirement identifier                    |
| `kind`          | ubiquitous / event / state / feature / exception |
| `actor`         | Responsible component or system                  |
| `condition`     | Trigger/state/feature predicate if applicable    |
| `modal`         | MUST / MUST NOT / SHOULD / MAY                   |
| `response`      | Required behavior                                |
| `applicability` | Where it applies                                 |
| `exclusions`    | Where it does not apply                          |
| `verification`  | Test, check, proof, or review step               |
| `source`        | Upstream artifact or issue                       |
| `terms`         | Glossary references                              |

Once the spec is lowered to that IR, linting becomes tractable, semantic diffing becomes possible, task generation becomes principled, and skills stop carrying hidden semantics.

On the question of a new file extension, the evidence does **not** currently justify inventing a heavily symbolic authoring language as the first move. Controlled natural languages such as STE and Rimay were designed precisely because unrestricted prose is too loose while fully formal notation is too costly for most authors. The highest-confidence recommendation is therefore: author the language initially in markdown or markdown-adjacent text, but make the grammar strict enough that it can later be serialized into a dedicated extension if needed. In other words, the thing that matters first is the grammar and linting model, not the suffix. citeturn9search0turn34search0turn33search7

## How skills and task templates should change

The language layer should become the **semantic core**. Skills, task templates, and `AGENTS.md` should become **delivery mechanisms** around that core, not parallel systems that each reinvent meaning.

Anthropic’s current skill model is revealing here. Skills are lazily loaded instructions that Claude can invoke when relevant or that a user can invoke directly. Their descriptions influence automatic loading, their bodies stay out of context until used, `disable-model-invocation: true` can prevent automatic execution, and `context: fork` can run a skill in an isolated subagent. Anthropic’s docs explicitly frame skills as the right place for repeated procedures, checklists, and multi-step workflows, especially when `CLAUDE.md` has grown procedural instead of factual. That is very close to the architecture Swarm should adopt. citeturn39view0turn40view0turn40view1turn40view2turn40view3

The implication is straightforward. A “skeptic persona” should **not** be a persona blob carrying hidden rules. A thin stance or role prompt may still be useful for focus or tone, because Anthropic notes that even a short role instruction can shape behavior, but the semantics of review belong in a **review-mode contract** or a **review skill**, not in roleplay. The actual reusable object should be something like `adversarial-review`, with an explicit type such as `review`, explicit entry conditions, explicit checks, and explicit output schema. If it is safe for Claude to apply automatically when a task is clearly a review, it can be model-invocable. If it has side effects or should always be manually chosen, set `disable-model-invocation: true`. If it should run in isolation so that implementation context does not pollute the review, give it `context: fork` and a dedicated subagent. citeturn37view1turn37view0turn40view1turn40view3

In practical terms, the question “is this a skill or part of `AGENTS.md`?” should be answered by **load scope and semantic ownership**.

| Concern                                                                 | Best home                 | Why                                                |
| ----------------------------------------------------------------------- | ------------------------- | -------------------------------------------------- |
| Universal repo facts, toolchain, verification commands, authority order | `AGENTS.md`               | Always needed, but must stay minimal               |
| Normative requirement grammar, lint rules, glossary policy, proof model | Language spec / contracts | These are the semantics of the system              |
| Reusable multi-step procedures                                          | Skills                    | They are procedural, optional, and lazily loadable |
| Session-specific execution state                                        | Task template             | It is per-task, not durable doctrine               |
| Durable project facts and decisions                                     | Findings, ADRs, memory    | They are knowledge, not procedures                 |
| Deterministic stop rules                                                | Hooks / validators        | Prompts are not enforcement                        |

This separation is not aesthetic; it is necessary because Anthropic explicitly says instruction files are context, not enforcement, and because overloading always-loaded instructions hurts cost and can hurt task outcomes. Skills therefore remain valuable, but only when they are clearly **procedural modules**, not semantic garbage bins. citeturn38search1turn25view0turn24search0

Task templates should also change materially. They should stop being generic prose work orders and become **lowered execution artifacts** from the spec language. A good task file should contain the selected requirement IDs, the bounded change surface, the allowed files or modules, the required proofs, the upstream source, and the promotion obligations for discoveries. This is where multi-agent scaling actually becomes possible. If five agents are working at once, the human cannot review five free-form chats; the human can review five **typed execution artifacts** with traceable requirement slices and proof bindings. That design is consistent with Anthropic’s orchestrator/worker advice, their emphasis on transparent decomposition, and the reality that long contexts and multi-turn drift make free-form conversational accumulation less trustworthy than stable artifacts. citeturn2view1turn15view1turn13view1

One subtle but important recommendation follows from the AGENTS and configuration-file literature: let the language be **unitary at the semantic level**, but keep skills **optional at the procedural level**. In other words, the grammar, lint rules, proof model, authority hierarchy, and traceability rules should form one coherent system. Skills can remain pluggable because they are execution helpers, not meaning. That resolves the tension between “piecemeal adoption” and “cohesive framework”: semantics should be indivisible; procedures may stay modular. citeturn25view0turn27view0turn39view0

## What is still missing from a complete package

The package is not complete if it only has syntax, task templates, document flow, and skills. The missing pieces are the pieces that make the language behave more like a real programming language and less like disciplined markdown.

The first missing piece is a **language reference**. This is more than examples. It needs a normative definition of clause types, modal vocabulary, glossary rules, conflict rules, and proof bindings. Without that, different skills or templates will reintroduce drift.

The second missing piece is a **linting and smell taxonomy**. Requirements engineering has already shown that natural-language requirements can be statically audited for smells and template conformance. Swarm needs the analogous compiler front end: syntax errors, semantic errors, warnings, and advisory smells. The existence of tools like Paska and prior NLP-based template conformance checking makes this direction well-supported rather than speculative. citeturn32search0turn33search7

The third missing piece is a **standard rewrite library**. As long as “improve,” “tighten,” “refine,” or “make this better” remain vague prompts, Swarm does not have a real transformation model. The language needs named rewrites with preconditions and exit conditions so that both humans and AIs know exactly what operation is being requested.

The fourth missing piece is a **traceability graph**. A compiler-quality workflow needs to answer: which requirement produced this task, which tests or checks prove it, which code paths implement it, which review passed it, which finding or ADR amended it, and what superseded it. Without traceability, multi-agent concurrency collapses back into diff review as the bottleneck.

The fifth missing piece is a **verification contract**. This is distinct from syntax. It specifies what counts as proof for each class of statement: unit test, integration test, benchmark, schema validation, log evidence, UI evidence, formal proof, or human acceptance. This is essential because “spec as code” only becomes compiler-like when claims are tied to a proof discipline. OpenAI’s Structured Outputs docs also reinforce the relevant lesson on the generation side: even schema-constrained outputs can still be wrong, so deterministic validation remains necessary. citeturn23view2

The sixth missing piece is a **review protocol**. If the human reviewer is still the main bottleneck, multi-agent scale will stall. Review needs its own language constructs, rubrics, and output schemas. This includes adversarial review modes, counterexample search, requirement-to-proof checks, and mitigation for LLM-judge bias such as randomizing pair order, using fixed rubrics, and keeping human spot checks. The literature on LLM-as-judge position bias makes that caveat unavoidable. citeturn30search0turn30search1

The seventh missing piece is a **deterministic enforcement layer**. Anthropic is explicit that if behavior must be blocked, prompts are not enough; hooks or other runtime controls are required. So the “compiler” must eventually include enforcing phases outside the model: pre-edit gates, permission rules, pre-commit or CI checks, schema validation, and policy hooks. Otherwise the system remains advisory. citeturn38search1turn38search11

The eighth missing piece is a **benchmark and golden corpus**. A language is not real until it has conformance tests. Swarm needs good and bad examples, ambiguity fixtures, stale-memory fixtures, missing-proof fixtures, conflicting-requirement fixtures, and review tasks. This is especially important because current research shows that prompt underspecification and small phrasing changes can significantly alter model behavior. citeturn13view0turn13view2

The ninth missing piece is a **multi-agent orchestration contract**. If multiple agents are to run concurrently, they need typed child tasks, ownership boundaries, merge conditions, and handoff schemas. Anthropic’s own agent guidance emphasizes routing, orchestration, and worker decomposition, and Claude Code now exposes custom subagents and forked skill contexts for task-specific workflows and context isolation. The orchestration gap is not about spawning more agents; it is about guaranteeing that each leaf task is small, typed, and independently reviewable. citeturn2view1turn40view3turn38search16

The tenth missing piece is a **formalization lane**, even if it is partial. Current research on verifiable code generation and neuro-symbolic requirements auditing suggests that full end-to-end formal proof remains difficult, but partial lowering to formal logic or solver-auditable forms is already useful. Verina shows that end-to-end verified code generation is still far from solved, especially proof generation. VERIMED shows that combining LLMs with SMT-based auditing can turn ambiguity and inconsistency into checkable signals and can dramatically improve verified accuracy in a narrow domain. That means the right roadmap is hybrid: controlled NL first, formal lowering where it pays, not speculative “full formal compiler” claims today. citeturn29search2turn35search0

## The compiler architecture this implies

The cleanest way to unify everything is to treat Swarm as a **specification operating system** with a compiler pipeline.

At the front end sits the **surface language**: controlled English clauses inside markdown or a markdown-adjacent format. The author writes requirements using a small grammar, approved modals, and glossary-controlled terminology.

The next phase is **static analysis**. This phase catches syntax errors, missing actors, dangling conditions, vague adjectives, undefined terms, missing proof bindings, contradiction candidates, and template non-conformance. This is where the system learns to say “this is invalid” rather than “this could be better.”

The next phase is **normalization to an intermediate representation**. The IR should be stable across authoring styles and future tools. It is the thing that task templates, review skills, CI checks, and eventually CLIs consume.

The next phase is **lowering to execution artifacts**. Source specs are partitioned into task-sized units with explicit proof obligations. Bugs lower into fix tasks. Audits lower into refactor or spec-amendment tasks. Findings lower into memory or ADR proposals. This is where the system becomes agent-operable instead of merely readable.

The next phase is **heuristic execution**. This is where LLMs and agents actually work. Skills belong here as procedural macros, not semantic foundations. An adversarial review skill, for example, is a compiled review procedure against a typed task, not a personality overlay.

The next phase is **deterministic verification**. Tests, builds, schema checks, benchmarks, hooks, and policy validators confirm or reject the resulting change. This is the point where the system behaves most like a real compiler toolchain: work either passes the configured gates or it does not.

The final phase is **promotion and memory maintenance**. Durable discoveries become findings, ADRs, or memory entries. Stale entries are demoted or replaced. The important point is that no significant knowledge is allowed to die in a chat transcript or a gitignored scratch file.

A compact representation of that pipeline looks like this:

| Phase     | Output                                | Nature                    |
| --------- | ------------------------------------- | ------------------------- |
| Parse     | Requirement AST / normalized clauses  | Deterministic             |
| Lint      | Errors, warnings, smell findings      | Deterministic + heuristic |
| Normalize | Spec IR                               | Deterministic             |
| Lower     | Task IR, review IR, verification plan | Mostly deterministic      |
| Execute   | Code, docs, tests, analysis           | Heuristic                 |
| Verify    | Pass/fail evidence                    | Deterministic             |
| Review    | Review verdict + rubric evidence      | Hybrid                    |
| Promote   | Findings, ADRs, memory updates        | Hybrid but routable       |

This architecture also gives a precise answer to the user’s original intuition about “true compilation-like spec as code.” The real breakthrough is **not** that English becomes magically executable. The breakthrough is that a constrained human-readable language is made analyzable enough to support compiler phases: parsing, static analysis, lowering, deterministic gating, and traceability. The LLM then acts where heuristics are genuinely helpful—rewriting, decomposition, code generation, review assistance, and formalization attempts—rather than pretending to be the whole compiler.

## Open questions and limitations

The evidence is strong enough to support a controlled natural language with linting, proof bindings, and lazy procedural skills. It is **not** strong enough to support claims of universal wording that works “100% of the time” across models, providers, and tasks. The current literature still shows prompt sensitivity, model-specific behavior, and context-related instability. citeturn13view0turn27view0

There is also not yet enough cross-model empirical evidence to justify a very narrow universal ban-list of English words beyond the obvious requirements smells: vagueness, undefined terms, padding words, ambiguous negatives, and bundled obligations. Some of the prose profile is therefore a best-practice synthesis, not a proven global optimum. citeturn20view0turn19view3turn22view0

Finally, a fully formal verified-program compiler from unrestricted specs is still not here. The current state of the art supports partial formalization, better requirements alignment, stronger auditing, and better proof-aware evaluation, but not a general end-to-end pipeline that can replace engineering judgment. The practical path forward remains hybrid and engineering-driven rather than utopian. citeturn29search2turn35search0turn29search1

The clearest, highest-confidence conclusion is this: **the complete package is a controlled specification language, a prose profile, a linter, a rewrite library, a traceability model, a verification contract, a review protocol, a deterministic enforcement layer, and a lowering pipeline into agent-sized tasks. Skills remain useful, but only as procedural modules around that core.** That is the architecture most consistent with the evidence, and it is the one most likely to scale from today’s markdown discipline into tomorrow’s actual compiler.
