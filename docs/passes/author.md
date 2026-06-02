# The `author` pass

> Swarm's reference for the `author` pass: how human intent enters the compiler pipeline as `spec.swarm.md`, and how the epistemic stance of each source parent is preserved when it is authored in.

`author` is the first of the **nine passes** of the Swarm compiler pipeline (`author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote`). This page is the reference for that single pass.

Like every Swarm pass, `author` has **no runtime**: it is a contract a human, an agent following a pass guide, or a future tool performs. Nothing here is shipped code.

## What the pass does

The `author` pass **captures human intent as SOL obligations and APS prose**, producing the first compiler-visible artifact of the pipeline.

| Aspect | Value (from §9.3) |
|---|---|
| Phase(s) | **entry** — pre-`PARSE` |
| Input artifacts | chat, `research.md`, `audit.md`, `bug-report.md`, prior `spec.swarm.md` |
| Output artifact | `spec.swarm.md` (draft: prose + SOL blocks) |
| Typical carrier profile (§27) | Architect (spec), Surveyor/Researcher (research), Auditor (audit), Bug Hunter (bug-report) |
| Lint layer (§8) | — (produces the input to `lint`; emits no lint codes itself) |

## Where it sits in the pipeline

The seven **phases** are `PARSE -> NORMALIZE -> LOWER -> EXECUTE -> VERIFY -> REVIEW -> PROMOTE`. `author` is deliberately **outside** that phase taxonomy: it is the *entry pass* that runs **before `PARSE`**, because its output (`spec.swarm.md`) is the first artifact the compiler can see.

Two contract notes follow from this position (§9.3.1):

- **`author` is not itself analyzable.** Everything *downstream* of `author` is analyzable; the author pass is the boundary at which un-structured intent (chat, working documents) becomes the structured, compiler-visible spec. Analysis begins at `lint` (the `PARSE` + `NORMALIZE` pass), not at `author`.
- **`author` feeds `lint`.** The next pass, `lint`, is non-mutating and decides well-formedness; the only pass permitted to rewrite the spec is `improve`, and only semantics-preservingly. So `author` is where new intent legitimately *enters*; passes after it normalize and lower that intent rather than re-invent it.

## `author` is NOT a stdlib pass guide

Of the nine passes, exactly **five** ship with a stdlib pass guide in v0.1: `lint`, `decompose`, `implement`, `review[profile: skeptic]`, and `promote` (§9.4). `author` is one of the **four** passes (`author`, `improve`, `lower`, `verify`) that are *fully specified by their pass contract and the language references* and ship no stdlib pass guide in v0.1. They MAY gain one in a later framework release without any language-version change (§25). A pass guide, when it exists, is SOFT control (Invariant 2): it MUST NOT define SOL/APS semantics, modality, authority order, or verification meaning.

## Authoring is parent-normalization: epistemic stances are preserved

`author` is the pass through which a spec's recognized **parents** normalize into `spec.swarm.md`. The recognized parents are PRD, research, RFC, ADR, audit, bug-report, finding, use-case/examples, NFR/SLO, and interface sources (OpenAPI / GraphQL / DB schema) (§29).

Each parent carries an **epistemic stance** — what kind of knowledge it is allowed to assert — and that stance is **normative**: it MUST be preserved when the parent is promoted into a spec (or, for a bug-report, into a fix task). The `author` pass is where most of this normalization happens (the rows below marked "via `author`"):

| Parent artifact | Epistemic stance | Promotes to |
|---|---|---|
| `spec.swarm.md` | **intent** — declares required behavior as SOL obligations | (is the authority; lowers to tasks) |
| `audit.md` | **observation-only** — describes present state and risk; asserts no new intended behavior | a `spec.swarm.md` (via `author`) |
| `bug-report.md` | **diagnosis-only** — reproduces and root-causes a defect; prescribes no fix | a **fix task** (`implement`) |
| `research.md` | **inquiry** — surveys options and evidence; commits to no decision | a `spec.swarm.md` (via `author`) |
| `prd.md` | **intent** — states desired product outcomes; non-authoritative until authored | a `spec.swarm.md` (via `author`) |
| `rfc.md` | **proposal** — proposes a design/approach; commits nothing until accepted | a `spec.swarm.md` (via `author`) or an `adr.md` |
| `use-case.md` / examples | **scenario** — illustrates desired behavior by example | `REQ`/`INTERFACE` blocks in a `spec.swarm.md` (via `author`) |
| `nfr.md` / SLOs | **quality attribute** — states non-functional targets | `CONSTRAINT`/`INVARIANT` blocks + verification rows (via `author`) |
| interface source (OpenAPI/GraphQL/DB schema) | **boundary shape** — declares an interface contract | `INTERFACE` blocks (via `author`) |
| `finding.md` | **evidence** — one durable, evidenced project fact | governs as Axis-A rank 3 once accepted (§22, §23) |
| `adr.md` | **decision** — an immutable architecture decision (Nygard) | governs as Axis-A rank 1 (§22, §30) |

### The stance invariants `author` must honor (§29.1)

- An `audit.md` MUST NOT contain `REQ`/`CONSTRAINT`/`INVARIANT` obligation blocks of its own intent. Observed risk has obligation force only **after** it is promoted *into* a spec — and that promotion is the `author` pass. (This is the epistemic-stance invariant of the kept ADR 0007.)
- A `bug-report.md` MUST NOT prescribe an implementation. Its diagnosis promotes *into* a **fix task** (an `implement`-pass input), not into a fix it dictates. (Kept ADR 0001.)
- More generally, `author` must not let a lower-stance parent smuggle higher-stance content across the boundary: an observation, an inquiry, or a proposal becomes binding **intent** only when authored into a `spec.swarm.md`, where SOL obligations carry that force.

Authoring writes the one human-authored compiler-visible artifact, `spec.swarm.md`: the `.swarm.` infix marks it as such (§29.2). Every other parent in the table above is plain `.md` (a working artifact); `author` MUST NOT introduce per-parent `.swarm.*` names for audit / research / bug-report / finding / adr.

## What gates the boundary — but not via `author`

`author` itself emits no lint codes and runs no gate; it produces the draft that the rest of the pipeline analyzes. The disciplines that *guard* the content `author` produces live downstream and are referenced here only for orientation: forbidden compositions (e.g. a file that is both a spec and an audit) are enforced not by `author` and not by a gatekeeper skill, but by the **distillation loss budget** (§24) and **source authority** (§22) (§29.5). Re-introducing a composition-policing skill is forbidden, because such a skill would be a semantic owner (§26.1) and soft control presented as enforcement (§17).

## Related

- [`lint`](lint.md) — the next pass; the `PARSE` + `NORMALIZE` pass that `author` feeds, where analysis begins.
- [`improve`](improve.md) — the only pass permitted to rewrite the spec, and only semantics-preservingly.
- [`lower`](lower.md) and [`decompose`](decompose.md) — how the authored spec lowers to IR and then to tasks.
- [`verify`](verify.md) — like `author`, a pass with no v0.1 stdlib pass guide.
- [SOL](../language/SOL.md) — the obligation language `author` writes into `spec.swarm.md`.
