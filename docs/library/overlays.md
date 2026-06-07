# Project conventions — house rules in `AGENTS.md`

> Swarm's reference for **project conventions**: the project-scoped, non-Swarm rules a repository layers onto the standard library — architecture conventions, extra refusals, local command bindings — without forking it; how a convention composes with pass guides and profiles; and the hard boundary that a convention MAY add project rules but MUST NOT override an approved obligation or Swarm's language semantics.

A **project convention** is the project-scoped guidance layer of Swarm. Where a pass guide documents *how* to perform one of the nine steps, and a heuristic profile documents *what an agent looks for and refuses* while performing a step, a project convention documents *what this one project additionally expects* on top of both. It is how a repository encodes its house rules — its architecture conventions, its testing policy, its domain refusals, its local command bindings — without editing or forking the standard library that ships those passes and profiles.

Like every Swarm artifact, a project convention is **markdown-only** and has no runtime: it is guidance a human or an agent reads while performing a step, never shipped code. Project conventions live in the repository's **`AGENTS.md` bootloader** — the file that already carries the standing project facts and the `Commands` table. There is no separate overlays directory: a convention is a fact about the project, and project facts live in the bootloader an agent already reads first (ADR-0049). The standard library prescribes none, because Swarm is complete without any project convention at all.

## What a project convention is

A project convention is an **OPTIONAL, project-scoped, non-Swarm rule**. Three properties define it:

- **Optional.** A conformant repository MAY ship zero project conventions. They add project-specific expectations; they are never required for Swarm, a pass, or a profile to be well-defined. The standard library prescribes none.
- **Project-scoped.** A convention carries guidance Swarm deliberately does not ship — convention specific to one repository. It is the canonical home for the kind of rule that is true here but would be wrong to bake into the shared standard library.
- **Non-Swarm.** A convention's rules are project house rules. They never define or redefine anything Swarm owns (see [The boundary](#the-boundary)).

Typical convention content:

| A convention carries… | Example |
|---|---|
| **Architecture conventions** | "New HTTP handlers register through the `router/` table, never inline in `main`." |
| **Testing policy** | "Every `task_kind: fix` ships a regression test that fails before the fix." |
| **Extra refusals** | "Refuse to bind a new third-party dependency without an ADR." |
| **Local command bindings** | "In this repo, the integration suite is `make itest`; name it where a pass needs it." |
| **Domain / house rules** | "Money is always minor units (integer cents); reject float currency in any spec." |

`AGENTS.md` is the canonical home for architecture and testing-policy rules. Such rules are not pass guides — they document no pass — and not profiles — they carry no cognitive stance. They encode project-local convention, and that is exactly what the bootloader is for. Keeping them in `AGENTS.md` prevents one repository's house rules from contaminating the shared standard-library pass guides.

## How a project convention is written

A project convention is one of the standing project facts in `AGENTS.md`. State it as an enumerated house rule, scoped to the passes, `task_kind`s, paths, or layers it governs, with the reason it holds — never a restatement of Swarm semantics. The four things a well-formed convention makes explicit:

| Element | Content |
|---|---|
| **Concern** | The single project concern the rule exists to serve. One concern per rule. |
| **Scope** | Which passes, `task_kind`s, paths, or layers the rule acts as guidance under. This scope is what lets the convention compose narrowly rather than apply everywhere. |
| **Rule** | The project-specific guidance itself — architecture, testing, or domain convention — and nothing Swarm owns. |
| **Rationale** | Why the project holds the rule, stated inline — never a restatement of a Swarm definition. |

## How a project convention composes

A project convention is the most downstream object in Swarm's one-way, acyclic dependency chain:

```text
language definitions → artifact contracts → pass contracts → pass guides → heuristic profiles → project conventions
```

It sits *downstream of every Swarm object*: it consumes language, artifact, pass, pass-guide, and profile contracts, and is consumed by nothing. Concretely, that means:

- **A convention composes with a pass guide additively.** The pass guide supplies the procedure for the pass; the convention adds the project's extra expectations *for that pass*, scoped to it. The pass guide still owns *how* the pass runs.
- **A convention composes with a profile additively.** The profile supplies the cognitive stance; the convention adds project-specific things to look for or refuse on top. The profile still owns the stance.
- **A convention MAY depend on any upstream node** — it may cite, link, or quote a language definition, an artifact contract, a pass contract, a pass guide, or a profile.
- **Nothing depends on a convention.** A convention MUST NOT introduce a back-edge into the chain: it MUST NOT be required to interpret SOL, and MUST NOT be named as a dependency of a pass guide, a profile, or a pass contract. Naming a convention as upstream of any of those is malformed.

### Always-resident, by design

Project conventions are **always-resident context** — they live in `AGENTS.md`, the bootloader an agent reads first on every task. This is the right lifecycle for a standing project fact: what this repo's architecture *is*, which command *is* the integration suite [[AGENTSMD-HARM]](../research/sources.md#AGENTSMD-HARM), what the domain *means* — none of it should be hidden behind lazy activation, because it is always true. (This contrasts with a pass guide or a profile, which loads only when a task names it. The split below is what keeps each rule in the layer whose lifecycle fits it [[CTXENG]](../research/sources.md#CTXENG).)

## The boundary

A project convention's whole purpose is to *add* project rules. The boundary is that it may add but may never override. A convention is **purely additive guidance**; it never weakens, waives, or reinterprets anything Swarm marks authoritative. Stated as hard rules, a convention:

- **MUST NOT define or redefine SOL or APS semantics.** The language belongs to Swarm.
- **MUST NOT define or redefine a Swarm object** — a block type (one of the 7 blocks), a modal (one of the 5 modals), a verdict value (one of the 7 verdicts), a proof type (one of the 9 proof types), or a lint code (`SOL-<LAYER>NNN`).
- **MUST NOT override an approved obligation.** A convention adds project expectations; it never relaxes, waives, or reinterprets an obligation the spec already approved. Waiver authority stays with a human or the spec owner — never a convention.

The bootloader is the layer most tempting to abuse as a back door for project-local semantics — the place a repository would be tempted to quietly redefine a modal or weaken a verdict under the cover of "house rules." It cannot. A project convention is **SOFT control**: its rules are guidance for a model, not enforcement, and they bind nothing Swarm marks authoritative. A conformant repository confirms that no project convention defines or overrides any of the Swarm objects enumerated above — the same regression check that confirms no skill, profile, or other `AGENTS.md` section has smuggled in modality, authority order, or verification semantics.

The clean way to read the boundary: if a rule changes *what this project additionally expects*, it is a project convention; if it changes *what the words mean or what counts as done*, it belongs to Swarm and an amendment, not a convention.

### Where does a rule belong — `AGENTS.md`, a pass guide, or a project profile?

Before a rule lands as a project convention, one gating question decides whether `AGENTS.md` is even its right home: **is this rule vendorable across a different language, a different CI provider, and a different agent?** The answer routes the rule to one of three places.

- **Portable → a pass guide.** If the rule would still produce its intended behaviour for a team on another language, CI, and agent — with nothing else loaded — it is universal *how-to-work* guidance, not project convention. It belongs to a pass guide in the standard library, not the bootloader. A portable rule trapped in `AGENTS.md` is misfiled; it should be lifted into the pass guide so every adopter inherits it.
- **Project-local standing fact → `AGENTS.md`.** If the rule is true *here* but would be wrong (or merely irrelevant) to bake into the shared standard library — a stack-specific convention, a local command binding, a house refusal — and it is a standing fact the agent should treat as always-true context, it belongs in the bootloader. This is the rule that fails the vendorability test because it is coupled to *this* repository.
- **A project-local cognitive stance → a project profile.** If the rule is not a standing fact but a multi-step *discipline* an agent should adopt for a particular pass — a stance with its own refusal set — it is a project-authored profile loaded lazily by the task that needs it, not always-resident context.

The split matters because each layer has a different lifecycle: a pass guide is portable and inherited by every adopter, the bootloader is project-local and always resident, and a profile is project-local but loaded only when a task names it. Misfiling a rule — a portable one trapped in the bootloader, a per-pass discipline forced to always-resident — costs adopters either reuse or focus.

## Where project conventions live

| Location | Holds |
|---|---|
| `AGENTS.md` | The repository's bootloader — the canonical home for project conventions alongside the `Commands` table and the standing project facts. Always read first; no separate overlays directory (ADR-0049). |
| `packages/<name>/AGENTS.md` | A nested bootloader in a monorepo — adds to or overrides the root conventions for that workspace, closest-wins (see [workspace](../model/workspace.md)). |

## Related

- [`improve`](../passes/improve.md) — a project convention composes additively with its pass contract (and its `pass-improve-spec` guide), adding project expectations without changing the procedure.
- [`verify`](../passes/verify.md) — the pass a convention's testing-policy and local-command-binding rules most often scope to.
- [SOL](../language/SOL.md) — the obligation language whose semantics a project convention MUST NOT define or redefine.
- [APS](../language/APS.md) — the prose standard a project convention MUST NOT redefine.
- [errors](../language/errors.md) — the `SOL-<LAYER>NNN` lint catalog a project convention MUST NOT add to or override.
- [conformance](../model/conformance.md) — where the regression check that confirms no project convention redefines a Swarm object lives, and which records that project conventions are not required for conformance.
- [workspace](../model/workspace.md) — where project conventions live: the `AGENTS.md` bootloader, with no separate overlays directory (ADR-0049).
