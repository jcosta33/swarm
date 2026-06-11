---
type: reference
id: build-brief
status: active
created: 2026-06-11
---

# Build brief — canon for every file authored in the repositioning

Read this whole file before writing anything. It is the single source of voice, vocabulary,
and shape for the rebuilt repo. The detailed design is `.agents/plans/practical-swarm-repositioning-plan.md`;
the recorded decisions are `docs/adrs/0057-…0068-*.md`. Where this brief and an ADR disagree, the ADR wins.

## Identity (use verbatim where a one-liner is needed)

> **Swarm is a lightweight spec and review workflow for teams using coding agents.**
> Turn tickets into clear specs, specs into agent-ready tasks, and agent output into
> evidence you can review — plain markdown, any agent, no runtime.

Thesis: **coding agents increase code volume; Swarm reduces the coordination and review cost
of that volume.** Generation outpaces validation — Swarm invests in the validation side.

Swarm **is**: a spec format agents can work from · a task-packet format that bounds agent work ·
a review-packet format that shows where human attention goes · a findings convention so lessons
survive the session · a starter kit of markdown templates · a workspace convention.
Swarm **is not**: an agent or agent runtime · a compiler · a programming language · a Jira/Linear
replacement · a code generator · a replacement for PRs and CI · a docs portal · a complete SDLC
platform · a formal verification system · a guarantee that agent output is correct.

## Voice rules (hard)

1. **Fresh product.** Never "previously/now", "renamed from", "formerly", or migration framing —
   that history lives only in `docs/adrs/`. Write as if this is the first public version.
2. **Honest about enforcement.** Nothing in this repo runs. Every rule statement carries one of
   four levels where force could be misread: **convention** (expected practice) · **checklist**
   (review inspects it) · **toolable** (a future/optional tool can check it; name the tool —
   "swarm-cli's `swarm spec check`") · **enforced** (only when a shipped tool actually enforces —
   today: never). Approved phrasing: "This is a convention — nothing in this repo enforces it."
   / "A future `swarm spec check` should flag this; until then treat it as a review checklist item."
3. **Page labels.** Every page under `docs/01–10`, `docs/reference/`, `docs/examples/` carries
   exactly one italic line under its H1:
   - `*Works today — plain markdown plus your agent; no Swarm tooling required.*`
   - `*Future automation — a contract for tooling that does not exist yet; nothing on this page runs today.*` (future-cli.md only)
   - `*Advanced design note — internal rationale; not needed to use Swarm.*`
   At most ONE future-CLI aside per happy-path page, phrased "(future CLI: `swarm review` will
   draft this packet — today you or your agent fills the template)".
4. **No counts ceremony.** Never recite cardinalities ("7 block types · 5 modals…"). List values,
   not counts. Counts live only in `conformance/README.md` (producer note) + the cheatsheet appendix.
5. **Short beats complete.** Happy-path pages ≤ ~150 lines. Reference pages as tight as accuracy allows.
   Every file useful; review evidence over planning prose.
6. **Citations stay contextual.** Load-bearing empirical claims cite inline:
   `[[KEY]](../research/sources.md#KEY)` (adjust relative depth). Carry citations WITH the claim
   when content moves. Never fabricate a key — only keys present in `docs/research/sources.md`.
   Claims without a verified source are stated as design rationale, not fact.

## Vocabulary (user tier ↔ reference tier)

| Say (user docs, kit core, examples) | Reference tier may also use |
|---|---|
| step | pass |
| requirement / acceptance criterion (AC) | obligation |
| evidence / verification method | proof / proof type |
| review result: Pass, Fail, Unverified, Blocked | verdict (incl. lifecycle: Waived, Stale, Contradicted) |
| save a finding | promote |
| checks / "common mistakes to check for" | lint codes `SOL-XNNN` (checks.md only) |
| structured requirements (SOL) | SOL — a notation, never "a language", never versioned |
| writing rules / spec hygiene | APS |
| review stance / role | profile |
| prepare tasks / split work | lower / decompose (advanced-lifecycle + future-cli only) |
| agent run summary (review packet evidence) | trace (future-cli only) |
| workspace | spec repo |
| six-step loop | nine-step lifecycle (advanced-lifecycle.md only) |

Spec frontmatter: `type, id, title, status, owner, sources[]` (+ optional `format: sol`).
No `swarm_language`, no `aps_version`, no `spec_version`, no `.swarm.` infix anywhere.
File discrimination = frontmatter `type:`. IDs: SPEC-*, TASK-*, REVIEW-*, FINDING-*, INV-*, CHANGE-*;
requirements `AC-NNN` (constraints `C-NNN`, invariants `I-NNN` in SOL form).

## The loop (the only workflow first-contact docs teach)

```
Pull → Spec → Task → Run → Review → Close
```
Two conditional steps for structural/brownfield work: **Inventory** (before Spec) and
**Change Plan** (after Spec). Per-shape flows: feature (6 steps) · refactor (Inventory/Audit →
Change Plan → Task → Run → Review → Close) · bug (Pull → Spec check → Task → Run → Review → Close) ·
rewrite (Inventory → Audit → Spec + Change Plan → Tasks → …) · small cleanup (Task → Run → Review →
Close) · spike (Question → Research → decision). Not every task needs every step — and the evidence
says indiscriminate process on trivial work measurably hurts; the skip-paths are required, not a concession.

## Artifacts

**Core:** intake (recommended when work originates in an external tracker) · spec · task · review
(the wedge) · finding · status. **Conditionally-core (structural/brownfield):** inventory · change-plan.
**Advanced:** audit · bug · adr · research · prd · rfc · threat-model · release-note (named type only).
Workspace layout: `specs/<feature>/` folders for durable intent (supporting docs co-located);
type folders `intake/ tasks/ reviews/ findings/ inventory/ change-plans/` for flow artifacts — all
committed; `status.md` board; `decisions/` for ADRs; `.agents/` holds only tooling. Code repos stay
pristine (a one-line AGENTS.md pointer at most; PR links the review packet).

## Frozen formats

The exact template texts live in `docs/adrs/0058…` (spec), `0060` (task, review), `0061` (intake),
`0067` (finding, status), `0068` (change-plan, inventory) and are copied verbatim into
`starter-kit/templates/`. Never restate a format — link to the template or the artifact-formats page.
Key review rules: a Pass needs pasted output or a CI link; an empty Evidence cell means Unverified,
never Pass; reviewers spot-check at least one green row's evidence; exception triggers list =
unverified/failed requirements · out-of-scope changes · risky files · missing test output · changed
public interfaces · DB migrations · security-sensitive changes · new finding candidates · blocked questions.

## Evidence one-liners you may use (with these exact citations)

- Ambiguous or incomplete task input measurably degrades agent code correctness
  [[ORCHID]] [[HUMANEVALCOMM]]; models usually code anyway instead of asking [[HUMANEVALCOMM]] [[HILBENCH]].
- Clarifying or repairing the requirement text recovers it, and the repaired text transfers across
  models [[CLARIFYGPT]] [[SPECFIX]].
- Executable acceptance criteria are the strongest known task-input signal [[ORACLESWE]].
- The planner→coder handoff is the dominant multi-agent failure surface [[PLANCODER]].
- Forced process on already-clear tasks measurably hurts [[HUMANEVALCOMM]] [[ASKORASSUME]] — hence the skip-paths.
- Reviewers favor their own/agent output without structure [[SELFPREFER]] [[JUDGEBIAS]]; "tests passed"
  without output is not evidence [[REFLEXION]].
Do NOT cite METR without its caveat; do not invent numbers.
