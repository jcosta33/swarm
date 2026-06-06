# Swarm Glossary

> Swarm's reference for canonical vocabulary: one crisp definition per term, alphabetized, with cross-references to the owning concept.

One crisp definition per term, one term per meaning. Each entry cross-references the owning section (the `§` numbers point into the framework's reference material). Terms are alphabetized.

| Term | Definition |
| --- | --- |
| **adapter** | The project-specific tool an obligation's proof resolves to; the `<adapter>` slot of `VERIFY BY <type>:<adapter>:<artifact>` resolves through `AGENTS.md` > Commands `cmd*` placeholder slots (§15, §31). |
| **AGENTS.md** | The always-loaded bootloader of persistent facts and pointers, hard-capped at ≤200 lines / ≤25 KB [[LOSTMID]](../research/sources.md#LOSTMID); carries the Commands table the adapters resolve through but never defines modality, authority, or verification semantics (§31). |
| **APS** | Agent Prose Semantics — the controlled-prose standard governing the readable prose around SOL blocks; its rules live under the `SOL-P###` lint layer (§7). |
| **block type** | One of the seven SOL block kinds (`REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`, `TRACE`, `VERDICT`), each with a fixed id prefix and clause grammar (§4, §6). |
| **conformance** | The property of a repository that ships the language reference docs, the seven core templates, a populated `AGENTS.md` bootloader, and the version file (`install/.agents/.swarm-version`, or `.agents/swarm.version` in an adopted project) (§20, §32). |
| **CONSTRAINT** | An obligation block (id `C-NNN`) that restricts *how* obligations may be satisfied rather than requesting behavior; carries binding force (§6). |
| **decompose** | The pass that projects the IR into work packets (`task.md`), enforcing that owned write surfaces are a subset of assigned obligations' `WRITES`; a pass, not an improve op (§9, §11). |
| **distillation loss budget** | The discipline that names what each compilation step Preserved, Dropped, and left Still-uncertain, bounding the meaning lost when prose intent is lowered toward code (§24). |
| **drift** | The condition where an obligation's source or a declared write surface changes after its last PASS, detected by content-hash comparison and surfaced as the `STALE` lifecycle decorator (§16). |
| **EARS** | Easy Approach to Requirements Syntax — the trigger/condition keyword family (`WHEN`, `WHILE`, `WHERE`, `IF [THEN]`) that shapes the SOL `REQ` clause order (§5, §6). |
| **edge** | A typed relationship in the IR (`depends_on`, `blocks`, `conflicts_with`, `verified_by`, `affects`, `implements`, `preserves`); edges are the single source of relationship truth, never duplicated as node scalars (§12). |
| **enforcement lane** | The first-class (today aspirational/manual) mapping of each CONSTRAINT/INVARIANT/stop-rule to its eventual deterministic home outside the model — hook, CI, permission, or schema (§17). |
| **finding** | A plain `.md` artifact recording one durable project fact with mandatory provenance; the unit of promotion into spec, ADR, audit, or memory (§23, §29). |
| **IR** | The intermediate representation — the typed `{meta, nodes[], edges[], diagnostics[], provenance}` JSON envelope (`*.swarm.ir.json`) emitted from the surface spec; documented as a contract, not shipped by any tool (§12, Appendix C). |
| **INVARIANT** | An obligation block (id `I-NNN`) asserting a property that must remain preserved over time; prefers `property\|model\|static` proofs; carries binding force (§6, §15). |
| **kickback** | The re-entry of the `implement` pass after a `FAIL` or `UNVERIFIED` verdict; a control-flow event, never a task type (§28). |
| **lifecycle decorator** | One of `WAIVED`, `STALE`, `CONTRADICTED` — a parenthetical that decorates a core verdict to record its status over time (§14). |
| **lint layer** | One of the five letters in `SOL-<LAYER><NNN>` — `S` syntax, `P` prose, `M` semantic, `V` verification, `O` orchestration — each a 100-block, append-only with tombstoning (§8). |
| **lower** | The pass (and conceptual phase) that translates the improved surface spec into the typed IR (§9, §11). |
| **merge gate** | The pass/fail decision that permits a merge iff every required obligation is `PASS` or `WAIVED` and none is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED` (§14). |
| **obligation** | A binding clause carried by a `REQ`, `CONSTRAINT`, or `INVARIANT` block; the unit that is verified, traced, and gated (§4, §6). |
| **obligation graph** | The dependency-and-conflict graph the IR encodes via `edges[]`, over which Swarm's core analyses (topo-sort, cycle detection, write-conflict, traceability) run (§3, §12). |
| **pass** | One of the nine schedulable transformations (`author → lint → improve → lower → decompose → implement → verify → review → promote`) that a task performs over its source artifacts (§9). |
| **pass guide** | A skill reframed as procedural guidance for performing a pass; it never owns SOL or APS semantics, which must be understandable without it [[SKILLBP]](../research/sources.md#SKILLBP) (§26). |
| **phase** | One of the seven conceptual compiler stages (`PARSE → NORMALIZE → LOWER → EXECUTE → VERIFY → REVIEW → PROMOTE`) onto which passes map (§9). |
| **plan** | The `*.swarm.plan.json` artifact — a graph envelope plus rich task payload derived from the IR; documented as a contract only, with no `locks` primitive (§13). |
| **profile** | A persona reframed as a heuristic parameter on a pass (e.g. `review[profile: skeptic]`), carrying Prevents/Default-questions/Required-evidence/Refuses/Applies-when (§27). |
| **promotion** | The protocol that moves a durable discovery out of task-local state into a finding, spec amendment, ADR, audit, or memory entry, with provenance, before task close (§23, §29). |
| **proof type** | One of the nine closed verification kinds (`static, test, contract, property, model, perf, security, manual, monitor`) that types a `VERIFY BY` binding (§15). |
| **REQ** | An obligation block (id `AC-NNN`) defining a required behavior in EARS-shaped clause order; carries binding force (§6). |
| **SOL** | The obligation language — the English-shaped, uppercase-keyword controlled notation, embedded in Markdown, in which obligations are authored (§4, §5, Appendix A). |
| **source authority** | The two-orthogonal-axis ordering (domain first, then artifact) that resolves which obligation governs when two conflict; code and tests may falsify but never silently amend intent (§22). |
| **STALE** | The lifecycle decorator marking a prior PASS whose recorded source or write-surface hash no longer matches current state; blocks the merge gate and forces a 3-way reconcile (§14, §16). |
| **surface** | The human-authored layer — English-shaped uppercase space-separated keywords in `.swarm.md` — as distinct from the snake_case IR layer (§4, §5). |
| **SURFACE** | A named coarse write-surface group (`SURFACE <name> = …`), optionally attributed `append-only\|integration\|shared`; replaces any `locks` primitive (§4, §18, G7). |
| **task_kind** | The frontmatter enum that parameterizes the `implement`/`author` passes (e.g. `feature`, `fix`, `refactor`, `review`, `spec-writing`, `orchestration`); the enum has 17 canonical values, and `kickback` is not among them — it is a control-flow event, not a task type (§28). |
| **trace** | The emitted artifact (`*.swarm.trace.md`) recording a `TRACE` block — implementation claims, changed surfaces, proof references — plus the provenance the drift join consumes (§16, §21). |
| **VERDICT** | The judgment block (reusing the judged obligation's id) carrying one core value (`PASS`, `FAIL`, `BLOCKED`, `UNVERIFIED`) optionally decorated with a lifecycle value; lives inside `review.md`, never a standalone file (§14). |
| **VERIFY BY** | The surface clause binding an obligation to its proof: `VERIFY BY <type>:<adapter>:<artifact>[#selector]`; the IR field name is `verify_by` (§15). |
| **write surface** | A file or glob an obligation declares it may modify via `WRITES`; the unit of write-conflict and parallel-safety analysis, and the projection an owned path must be a subset of (§18). |

## Related

The full mechanics behind these one-line definitions live in their owning framework pages:

- [SOL](../language/SOL.md) — the obligation language, its block types and clause grammar.
- [APS](../language/APS.md) — the controlled-prose standard around SOL blocks.
- [grammar](../language/grammar.md) — the complete clause grammar.
- [IR schema](ir-schema.md) — the typed intermediate representation contract.
- [proof types](proof-types.md) — the nine closed verification kinds.
- [compiler pipeline](../model/compiler-pipeline.md) — the seven phases and nine passes.
- [source authority](../model/source-authority.md) — the two-axis ordering that resolves conflicts.
- [drift and staleness](drift-and-staleness.md) — the `STALE` decorator and 3-way reconcile.
- [promotion protocol](promotion-protocol.md) — moving durable discoveries into findings, ADRs, audits, or memory.
- [distillation loss budget](distillation-loss-budget.md) — the Preserved / Dropped / Still-uncertain discipline.
