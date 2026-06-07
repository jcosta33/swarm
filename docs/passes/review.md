# The `review` step

> Swarm's reference for the `review` step: the merge gate, the seven-value verdict vocabulary, the `CONTRADICTED` resolution protocol, the model-judge discipline, the untrusted-source boundary, and the `review.md` verdict record.

`review` is the eighth of the **nine steps** of the Swarm flow (`author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote`). This page is the reference for that single step.

Like every Swarm step, `review` has **no runtime**: it is a contract a human, an agent following a step guide, or a future tool performs. Nothing here is shipped code (Principle 1: no runtime). Every "gate", "check", or "enforcement" named below is **manual today** — a deterministic home a future harness MUST provide, never a thing Swarm runs.

## What the step does

The `review` step **renders the merge-gate judgment**: it compares trace claims against the obligations they purport to satisfy, records one `VERDICT` per required proof binding, and decides — for the whole change set — whether promotion is permitted. Its single durable artifact is `review.md`, and **that artifact *is* the verdict record**. Swarm ships **no** `verdict.md`; a repo that records verdicts in a standalone `verdict.md` is invalid.

| Aspect | Value |
|---|---|
| Phase | **REVIEW** |
| Input artifacts | `trace.md` (implementation claims), the `spec.swarm.md` obligations, recorded verification evidence (see [`verify`](verify.md)), diffs |
| Output artifact | `review.md` — the canonical container of `VERDICT` blocks |
| Default proof suite for the `review` task kind | `manual @ REVIEW` over the recorded evidence; re-run of the bound `cmd*` proofs |
| Lint layer | `SOL-M`, `SOL-V` (SEMANTIC + VERIFICATION) — well-formedness of verdicts + cross-reference/authority floors (see [`lint`](lint.md)) |

## Review as exception-handling

The reason the gate is worth rendering: it turns review from *reading every line of a large agent diff* into
*inspecting the exceptions*. The reviewer is handed a **review packet** — the spec's obligations, the trace's
claimed actions, the diff under review, the recorded checks, the open risks, and a promotion recommendation —
and reads only what the structure flags. Concretely, the **human-attention list** is:

- **Failed or unverified obligations** — every `VERDICT` that is not `PASS`/`WAIVED` (`FAIL`, `BLOCKED`,
  `UNVERIFIED`, or a `STALE`/`CONTRADICTED` decorator): the obligations the change did not demonstrably satisfy.
- **Unauthorized changes** — edits not traceable to an in-scope obligation, recorded in `review.md`'s
  `## Unauthorized changes` table and judged allowed / suspect / reject.
- **High-risk surfaces** — obligations carrying `RISK high`/`critical`, which the model-judge discipline below
  already escalates to an independent second judge.
- **Promotion decisions** — the durable discoveries queued in `review.md`'s `## Promotion queue` (resolved by
  [`promote`](promote.md)).

Everything else — obligations carrying a passing, non-stale verdict bound to a proof that actually ran — needs
no line-by-line reading; the gate has already accounted for it. This section only says what a reviewer
*looks at*; **how** the gate decides is the predicate below, and waiver mechanics stay defined in
[`verify`](verify.md) — neither is restated here.

## The verdicts it records

`review` records **verdicts** in the seven-value model defined once in [`verify`](verify.md): a verdict carries **exactly one CORE value** (`PASS` / `FAIL` / `BLOCKED` / `UNVERIFIED`) and **zero or more LIFECYCLE decorators** (`WAIVED` / `STALE` / `CONTRADICTED`). The value meanings, the decoration rules (`WAIVED` only on `FAIL`/`UNVERIFIED`, `STALE` only on a prior `PASS`, `CONTRADICTED` on any core), and the well-formedness lint (`SOL-V005`/`V007`/`V008`) all live in [`verify`](verify.md); `review` applies them.

The verdict line is `VERDICT <id>: <CORE> [(<lifecycle> by <authority>: <reason>)]`, with `<id>` reusing the judged obligation's surface id (`AC-001`, `C-001`, `I-001`, `IF-001`), followed by `REASON` and one or more `EVIDENCE` clauses. A `QUESTION` is never judged; a `TRACE` is the *input* to judgment; a `VERDICT` *is* the recorded judgment.

## The merge gate it renders

The **merge gate** is the single normative predicate `review` exists to render. It is evaluated over every **required** obligation — every `REQ`, `CONSTRAINT`, `INVARIANT`, and `INTERFACE` in scope, each with its required `VERIFY BY` bindings:

> **Merge gate (normative).** A change set MAY be promoted **if and only if** **(a)** for **every required `VERIFY BY` binding** of every required obligation in scope, the binding's latest verdict is `PASS` or `WAIVED`, **and none** is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED`; **(b)** for every `RISK high|critical` obligation, its bound oracle is **adequate** — no open `SOL-V011` (an inadequate high-consequence oracle *blocks*, it does not merely warn; see [`verify` §6.2](verify.md)); **and (c)** the in-scope required-obligation set is **non-empty** — a change no obligation covers MUST NOT pass by vacuity. "Latest" is the verdict from the most recent recorded run.

There is **one `VERDICT` per required binding** — an obligation with three required bindings contributes three, and *all* must pass-or-waive; the node-level `status` is the aggregate (blocking if any binding blocks, else `PASS`). The per-value disposition under the gate is the table in [`verify`](verify.md). A valid repo MUST NOT promote while any required binding is in a blocking disposition; the gate is **manual today**, with a deterministic home (CI, a PreToolUse hook, a merge-blocking status) when a harness exists. A `WAIVED` verdict passes **only while its waiver is live**: it auto-expires on the next source-hash change of the waived obligation and reverts to its underlying `FAIL`/`UNVERIFIED` — there are **no permanent waivers**.

**Clause (c) — no pass by vacuity ([ADR-0055](../adrs/0055-close-the-gate-soft-control-gaps.md)).** The universal in clause (a) is vacuously true when *no* obligation is in scope, so an **uncovered change** — an edit whose behavior no obligation requires — would otherwise ship "verified" with no contract and no proof. It does not: an uncovered change `BLOCK`s the gate until one of three things happens — a spec amendment authors the covering obligation (the normal route; a bug fix follows it via the [`bug-report` → fix-task seam](../artifacts/bug-report.md)), the edit is reverted, or it is recorded as an allowed entry in the `## Unauthorized changes` table with a reason. An empty assigned-obligation set is a coverage gap to resolve, never a free pass.

**Clause (b) — adequacy is gated where consequence is highest ([ADR-0055](../adrs/0055-close-the-gate-soft-control-gaps.md)).** For a `RISK high|critical` obligation, a bare concrete `test` with no `mutation`/`metamorphic` adequacy evidence is an inadequate oracle (`SOL-V011`), and at this RISK it **blocks the gate** rather than merely warning — closing the gap where "schema is not verification" matters most. Adequacy stays **advisory for `RISK low|medium`** (strict mode extends blocking to them). The adequacy rule and the per-RISK oracle table live once in [`verify` §6.2](verify.md); the gate only consults them.

## Resolving a `CONTRADICTED` verdict

`CONTRADICTED` arises when two proofs disagree, or when a `TRACE`/code disagrees with the obligation. The `review` step owns its resolution, which is normative:

1. **Block at the merge gate.** A `CONTRADICTED` on any required obligation blocks promotion. Contradiction is never resolved by picking the more convenient result.
2. **Route to review.** The reviewer MUST record **both** conflicting evidence refs (the two `EVIDENCE` lines required by `SOL-V005`).
3. **The stronger oracle is authoritative pending reconciliation.** Using the fixed proof-strength order — `model > property | contract > test > static > manual | monitor` — the stronger proof's result is the *working assumption* while the contradiction is open. This does **not** close the contradiction; it keeps review from being paralysed. Example: a `contract` `PASS` is presumptively authoritative over a `manual` `FAIL`, but the obligation stays `CONTRADICTED` (and gate-blocking) until reconciled. **Equal-strength case:** when both proofs share a rank (two `test`s, `property` vs `contract`, `manual` vs `monitor`), neither is stronger — no working assumption is set, and the contradiction MUST NOT auto-resolve to either side; it routes to an independent reviewer or a higher-rank re-proof.
4. **Reconcile (never silently).** Reconciliation re-runs the disagreeing proofs, fixes the weaker oracle, corrects the code, or amends the obligation — the same not-silent discipline as the 3-way reconcile. The `CONTRADICTED` decorator is removed only when both proofs agree (or one is withdrawn as invalid with a recorded reason).

> Rationale: block-plus-stronger-oracle keeps the gate honest (no silent pick-the-pass) while keeping review actionable. Executable oracles outrank an LLM-judge `manual` verdict because judge bias is a known failure mode — an executable result is harder to fool than a narrative judgment.

Adequacy can override strength **within a recorded contradiction**: a `test` carrying strong mutation/metamorphic evidence over the disputed surface MAY be treated as authoritative over a nominally-stronger proof that exercised neither — but the override is a recorded judgment, never a silent re-rank, and never closes the contradiction on its own.

## When the oracle is a model judge

Because Swarm ships no runtime, **every verdict today is recorded by a human or agent**, and the `review` task kind's default suite is `manual @ REVIEW`. So the de-facto oracle for many obligations is an **LLM judge** rendering a `manual` verdict. The proof-strength order already ranks `manual`/`monitor` last because such judgments are fallible — and the failure modes are measured, not assumed: judge bias is directional and predictable — a judge favours the earlier-positioned answer, the longer answer, and answers resembling its own style [[JUDGEBIAS]](../research/sources.md#JUDGEBIAS); an evaluator scores its **own** generations higher than they merit, the bias rising with its ability to recognise them [[SELFPREFER]](../research/sources.md#SELFPREFER); a judge that shares lineage with the generator inflates its own kin [[CORRELATED]](../research/sources.md#CORRELATED); and self-judgment with no external signal does not reliably improve and can degrade [[SELFCORRECT]](../research/sources.md#SELFCORRECT). These are structural failure modes, not occasional slips.

The corollary is load-bearing and bounds when independence is owed. **The trustworthy oracle is a deterministic proof, not a judgment** — an external check is the signal that makes a verify-then-correct loop sound [[SELFCORRECT]](../research/sources.md#SELFCORRECT). So where an obligation is bound to a deterministic proof (`test`/`static`/`contract`/`property`), the **author may run it**: the proof, not the author, is the judge, and authorship does not bias a deterministic result. The independence requirements below (rules 2–4) are therefore owed **only where the oracle is the model's own judgment** — a `manual` verdict or an LLM-as-judge — which is exactly the case the evidence above indicts. Self-review is not banned; *self-issued judgment unbacked by an external signal* is.

Any `manual`/judge-rendered verdict MUST satisfy all four requirements. These are SOFT-control contracts today, with a deterministic home in a `review.md` schema validator / CI gate when a harness exists:

| # | Requirement | Disposition if violated |
|---|---|---|
| 1 | **Record judge identity** — the model (name + version/family) or named human, in the optional `judge` adjunct on the trace-provenance record. | Unrecorded judge → treated as `UNVERIFIED` (joins the non-proofs); raise a `SOL-V` judge-provenance smell. |
| 2 | **No shared lineage with the generator** — not the same model, not teacher→student inheritance, not the same model family (a judge of shared lineage inflates its own kin). | Verdict does not count; re-judge by an unrelated oracle. **BLOCKING.** |
| 3 | **Implementer ≠ reviewer** — the agent/human that implemented the change MUST NOT render its own `manual` verdict (the self-preference hazard [[SELFPREFER]](../research/sources.md#SELFPREFER); the soft-oracle analogue of "no self-issued waiver"). A deterministic proof the implementer runs is **not** a self-issued verdict — the proof is the oracle, not the implementer. | Treated as `UNVERIFIED`; require an independent reviewer. **BLOCKING.** |
| 4 | **Dual independent judgment for `RISK high`/`critical`** — two independent judges (two unrelated models, or a model plus a human), neither sharing lineage (per 2), neither the implementer (per 3), because a single judgment is not reliable enough alone for high-stakes obligations. | Single judgment → `UNVERIFIED` (dual owed). Judges that **disagree** → decorate `CONTRADICTED` (record the two judgments as the two evidence refs) → route through the `CONTRADICTED` resolution above. |

> Rationale: ranking a judgment last does nothing if the judgment is silently biased — a self-judged, same-family, single-shot `manual` `PASS` would otherwise sail through whenever no executable proof contests it. The discipline is "no astrology for agents" applied to the one oracle Swarm cannot make executable: when the oracle is a model, **name it, isolate it, and double it where the risk is highest**.

## The untrusted-source boundary the reviewer must hold

Every artifact `review` reads is agent-readable markdown, which is also an attack surface: attacker instructions can be hidden in rule files via zero-width and bidirectional-control characters, a compromised dependency can write a malicious `AGENTS.md`, this class of file-borne injection has reached remote code execution in shipped coding agents, and indirect (file-borne) prompt injection is among the foremost risks for any LLM that reads untrusted text. Treating every read artifact as untrusted input is therefore a baseline reviewer posture, not a precaution for unusual cases. None of the controls below is shipped tooling; each is a contract a future harness builds against and is **manual today**.

- **Non-printing-character rejection (`SOL-S013`, HARD lane).** A SYNTAX-layer diagnostic REJECTS any agent-read artifact containing zero-width, bidirectional-control, other non-printing control characters (outside `\t`/`\n`), or homoglyph-suspect mixed-script identifiers. Because the check is purely lexical it sits in the **HARD/deterministic lane**; it is **BLOCKING** and its eventual home is a PreToolUse hook or CI gate. Resolution: strip the offending codepoints or re-author in printable characters.
- **Source-authority rule for externally-authored sources (SOFT/governance).** An `audit.md`/`research.md`/`bug-report.md` whose provenance lies **outside the repo trust boundary** MUST be flagged approval-required and **never auto-promotable**. An external source carries the *lowest* applicable source authority and MUST NOT silently amend an approved `spec.swarm.md` (a lower-ranked actor amending a higher-ranked artifact is `SOL-M004`). A source whose provenance cannot be established as in-boundary is treated as external by default. This composes with `SOL-S013`: the lexical check cleans the *bytes*, the source-authority rule governs the *trust* of the source those bytes came from.

## The `review.md` artifact

`review.md` IS the verdict record — the canonical container of `VERDICT` blocks. A valid `review.md` MUST contain:

| Section | Meaning |
|---|---|
| frontmatter | `type: review`, `id`, `source_trace`, `source_spec`, `reviewed_output`, `pass`, `profile` (e.g. `skeptic`), `created`. |
| `## Claimed coverage` | Which trace step claims which obligation, with the evidence ref it claims — the adjudication target the per-obligation verdicts judge against. |
| `## Per-obligation verdicts` | One `VERDICT` block per judged obligation, using the canonical verdict line plus `REASON`/`EVIDENCE`. |
| `## Obligation-verdict matrix` | A compact table: obligation id → core → lifecycle → evidence checked. |
| `## Constraint and invariant verdicts` | The same, for `C-` and `I-` ids. |
| `## Unauthorized changes` | Every change not traceable to an authorizing obligation, judged allowed / suspect / reject. |
| `## Final verdict` | The merge-gate result at the change-set level (PASS / BLOCKED). |
| `## Promotion queue` | Items to promote, with target + status. |

Three lint floors the reviewer enforces by hand or via the [`lint`](lint.md) step today (`SOL-V` layer): a non-`PASS/FAIL/BLOCKED/UNVERIFIED` core or a lifecycle missing its mandatory fields is `SOL-V005` (BLOCKING); a misplaced `WAIVED`/`STALE` is `SOL-V007` (BLOCKING); a required obligation with no `VERDICT` at the gate is `SOL-V008` (BLOCKING, and counts as `UNVERIFIED`). A `WAIVED` MUST name authority + reason + expiry; a `STALE` MUST cite the prior-verdict ref + changed surface; a `CONTRADICTED` MUST cite the two conflicting evidence refs.

What `review` MUST reject as a non-proof (never `PASS`): schema-valid output (shape is not truth), "tests passed" with no command/exit-code/output, and a `manual` verdict with no recorded reasoning [[REFLEXION]](../research/sources.md#REFLEXION). Rewarding grounded attribution and refusing when unsupported is what measurably raises trustworthiness — plain prompting does not [[TRUSTALIGN]](../research/sources.md#TRUSTALIGN); an unsupported claim is withheld, not emitted.

## Related

- [The `verify` step](verify.md) — the seven-value verdict model, the closed proof taxonomy, `VERIFY BY` binding, oracle adequacy, the proof-strength order, and the soft/hard control boundary the gate consumes.
- [The `implement` step](implement.md) — produces the `trace.md` claims that are the input to judgment.
- [The `promote` step](promote.md) — what happens after the gate passes: the memory model, the promotion protocol, and the promotion-status enum.
- [The `lint` step](lint.md) — the `SOL-V` / `SOL-S` / `SOL-M` lint floors the reviewer enforces (`SOL-V005`/`V007`/`V008`, `SOL-S013`, `SOL-M002`).
- [The `review.md` artifact](../artifacts/review.md) — the full artifact contract and template body for the verdict record.
- [The `trace.md` artifact](../artifacts/trace.md) — the implementation-claim input that `review` judges, including the trace-provenance and `judge` adjunct records.
- [SOL diagnostics](../language/SOL.md) and [the errors reference](../language/errors.md) — the `SOL-V`, `SOL-S013`, and `SOL-M002` codes the reviewer enforces.
- The Skeptic persona — the heuristic profile `review` runs under (`review[profile: skeptic]`), served by the `persona-skeptic` skill.
