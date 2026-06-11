# Swarm Glossary

> Swarm's reference for canonical vocabulary: one crisp definition per term, alphabetized, with cross-references to the owning concept.

One crisp definition per term, one term per meaning. Each entry cross-references the owning framework page (linked under Related below). Terms are alphabetized.

| Term | Definition |
| --- | --- |
| **adapter** | The project-specific tool an obligation's proof resolves to; the `<adapter>` slot of `VERIFY BY <type>:<adapter>:<artifact>` resolves through `AGENTS.md` > Commands `cmd*` placeholder slots. |
| **AGENTS.md** | The always-loaded bootloader of persistent facts and pointers, hard-capped at ≤200 lines / ≤25 KB [[LOSTMID]](./research/sources.md#LOSTMID); carries the Commands table the adapters resolve through but never defines modality, authority, or verification semantics. |
| **APS** | Agent Prose Semantics — the controlled-prose standard governing the readable prose around SOL blocks; its rules live under the `SOL-P###` lint layer. |
| **block type** | One of the seven SOL block kinds (`REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`, `TRACE`, `VERDICT`), each with a fixed id prefix and clause grammar. |
| **CONSTRAINT** | An obligation block (id `C-NNN`) that restricts *how* obligations may be satisfied rather than requesting behavior; carries binding force. |
| **decompose** | The step that projects the structured form into work packets (`task.md`), enforcing that owned write surfaces are a subset of assigned obligations' `WRITES`; a step, not an improve op. |
| **distillation loss budget** | The discipline that names what each build step Preserved, Dropped, and left Still-uncertain, bounding the meaning lost when prose intent is structured toward code. |
| **drift** | The condition where an obligation's source or a declared write surface changes after its last PASS, detected by content-hash comparison and surfaced as the `STALE` lifecycle decorator. |
| **EARS** | Easy Approach to Requirements Syntax — the trigger/condition keyword family (`WHEN`, `WHILE`, `WHERE`, `IF [THEN]`) that shapes the SOL `REQ` clause order. |
| **edge** | A typed relationship in the structured form (`depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, `preserves`); edges are the single source of relationship truth, never duplicated as node scalars. |
| **enforcement lane** | The first-class (today aspirational/manual) mapping of each CONSTRAINT/INVARIANT/stop-rule to its eventual deterministic home outside the model — hook, CI, permission, or schema. |
| **finding** | A plain `.md` artifact recording one durable project fact with mandatory provenance; the unit of promotion into spec, ADR, audit, or memory. |
| **INVARIANT** | An obligation block (id `I-NNN`) asserting a property that must remain preserved over time; prefers `property\|model\|static` proofs; carries binding force. |
| **kickback** | The re-entry of the `implement` step after a `FAIL` or `UNVERIFIED` verdict; a control-flow event, never a task type. |
| **lifecycle decorator** | One of `WAIVED`, `STALE`, `CONTRADICTED` — a parenthetical that decorates a core verdict to record its status over time. |
| **lint layer** | One of the five letters in `SOL-<LAYER><NNN>` — `S` syntax, `P` prose, `M` semantic, `V` verification, `O` orchestration — each a 100-block, append-only with tombstoning. |
| **lower** | The step (and conceptual phase) that translates the improved surface spec into the typed structured form. |
| **merge gate** | The pass/fail decision that permits a merge iff every required obligation is `PASS` or `WAIVED` and none is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED`. |
| **obligation** | A binding clause carried by a `REQ`, `CONSTRAINT`, or `INVARIANT` block; the unit that is verified, traced, and gated. The dependency-and-conflict relationships among obligations are encoded in the structured form via `edges[]`, over which Swarm's core analyses (topo-sort, cycle detection, write-conflict, traceability) run. |
| **phase** | One of the seven conceptual stages (`PARSE → NORMALIZE → LOWER → EXECUTE → VERIFY → REVIEW → PROMOTE`) onto which steps map. |
| **plan** | The `*.plan.json` artifact — a graph envelope plus rich task payload derived from the structured form; documented as a contract only, with no `locks` primitive. |
| **profile** | A persona reframed as a heuristic parameter on a step (e.g. `review[profile: skeptic]`), carrying Prevents/Default-questions/Required-evidence/Refuses/Applies-when. |
| **promotion** | The protocol that moves a durable discovery out of task-local state into a finding, spec amendment, ADR, audit, or memory entry, with provenance, before task close. |
| **proof type** | One of the nine closed verification kinds (`static, test, contract, property, model, perf, security, manual, monitor`) that types a `VERIFY BY` binding. |
| **REQ** | An obligation block (id `AC-NNN`) defining a required behavior in EARS-shaped clause order; carries binding force. |
| **SOL** | The obligation language — the English-shaped, uppercase-keyword controlled notation, embedded in Markdown, in which obligations are authored. |
| **source authority** | The two-orthogonal-axis ordering (domain first, then artifact) that resolves which obligation governs when two conflict; code and tests may falsify but never silently amend intent. |
| **STALE** | The lifecycle decorator marking a prior PASS whose recorded source or write-surface hash no longer matches current state; blocks the merge gate and forces a 3-way reconcile. |
| **step** | One of the nine schedulable transformations (`author → lint → improve → lower → decompose → implement → verify → review → promote`) that a task performs over its source artifacts. |
| **step guide** | A skill reframed as procedural guidance for performing a step; it never owns SOL or APS semantics, which must be understandable without it [[SKILLBP]](./research/sources.md#SKILLBP). |
| **structured form** | The typed `{meta, nodes[], edges[], diagnostics[], provenance}` JSON envelope (`*.ir.json`) emitted from the surface spec; documented as a contract, not shipped by any tool. |
| **surface** | The human-authored layer — English-shaped uppercase space-separated keywords in `.md` — as distinct from the snake_case structured-form layer. |
| **SURFACE** | A named coarse write-surface group (`SURFACE <name> = …`), optionally attributed `append-only\|integration\|shared`; replaces any `locks` primitive. |
| **task_kind** | The frontmatter enum that parameterizes the `implement`/`author` steps (e.g. `feature`, `fix`, `refactor`, `review`, `spec-writing`, `orchestration`); the enum has 17 canonical values, and `kickback` is not among them — it is a control-flow event, not a task type. |
| **trace** | The emitted artifact (`*.trace.md`) recording a `TRACE` block — implementation claims, changed surfaces, proof references — plus the provenance the drift join consumes. |
| **validity** | The property of a **spec/authoring repo** that ships the language reference docs, the seven core templates, and a populated `AGENTS.md` bootloader. Graded per role — a code repo that only consumes specs has a near-zero footprint and is not measured against the docs/templates clauses; there is no version-file clause ([ADR-0050](./adrs/0050-swarm-is-a-spec-repo-discipline.md)). |
| **VERDICT** | The judgment block (reusing the judged obligation's id) carrying one core value (`PASS`, `FAIL`, `BLOCKED`, `UNVERIFIED`) optionally decorated with a lifecycle value; lives inside `review.md`, never a standalone file. |
| **VERIFY BY** | The surface clause binding an obligation to its proof: `VERIFY BY <type>:<adapter>:<artifact>[#selector]`; the structured-form field name is `verify_by`. |
| **write surface** | A file or glob an obligation declares it may modify via `WRITES`; the unit of write-conflict and parallel-safety analysis, and the projection an owned path must be a subset of. |

## Related

The full mechanics behind these one-line definitions live in their owning framework pages:

- [SOL](./language/SOL.md) — the obligation language, its block types and clause grammar.
- [APS](./language/APS.md) — the controlled-prose standard around SOL blocks.
- [grammar](./language/grammar.md) — the complete clause grammar.
- [structured form](structured-form.md) — the typed structured-form contract.
- [proof types](proof-types.md) — the nine closed verification kinds.
- [the flow](./model/how-swarm-works.md) — the seven phases and nine steps.
- [source authority](./model/source-authority.md) — the two-axis ordering that resolves conflicts.
- [drift and staleness](drift-and-staleness.md) — the `STALE` decorator and 3-way reconcile.
- [promotion protocol](promotion-protocol.md) — moving durable discoveries into findings, ADRs, audits, or memory.
- [distillation loss budget](distillation-loss-budget.md) — the Preserved / Dropped / Still-uncertain discipline.
