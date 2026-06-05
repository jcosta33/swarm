# Plan — reimagined Swarm adoption: a one-and-done `swarm-init` bundle

> A **plan**, not changes. Method: a 6-candidate design panel (drop-in mirror · single archive ·
> one-command · agent-performed · git-subtree · init-contract), each adversarially scored against the
> hard constraints (NO RUNTIME · provider-neutral · the two-destination problem · the project/framework
> ownership boundary · brownfield-safe · cross-platform portability · ADR-0044 single-sourcing), then
> synthesized (workflow `w4gohoh2r`, 13 agents). Supersedes the *mechanism* of DX-plan P1/P2.

## The recommended model — "init bundle driven by an install skill"

A graft of the three strongest candidates:

- **Ship a destination-partitioned, DERIVED bundle** `dist/swarm-init/` (and a `swarm-init.zip` release),
  built from `kernel/` by an ADR-0044-style agent-run transform (build direction `kernel → dist` only,
  diff-checked). Its internal tree is **partitioned by destination**, so *which file goes where is
  unrepresentable as an error* — the executor never decides placement, the file's subtree dictates it.
- **The primary "one-and-done" path is an `install-swarm` SKILL.md** the dev's *own* agent runs (the
  agent is the executor — NO RUNTIME holds: nothing in this repo executes).
- **An `INIT.md` contract + a `manifest.txt` op-list make it deterministic and verifiable**: the manifest
  is a `src → dst → ownership` table (data, not prose) the executor reads literally and reports
  evidence per line; a `conformant-repo/` golden fixture makes "adoption done" a *falsifiable predicate*,
  not a feeling.

Rejected as mechanisms: a standalone published **git mirror** (subtree needs a reachable remote + new
release machinery the single-sourced repo lacks) and any **self-extracting installer** (NO RUNTIME).

## The developer experience

**Primary path (agent executor) — effectively one-and-done:**
1. **Obtain the bundle** — `npx degit <owner>/swarm/dist/swarm-init`, unzip `swarm-init.zip`, or copy the
   checked-in folder. Lands anywhere (e.g. `~/dl/swarm-init/`).
2. **Tell your agent**: *"Adopt Swarm from `~/dl/swarm-init` following `INIT.md`."* (Or, if the kernel is
   already vendored, the `install-swarm` skill fires on its description / `/install-swarm`.)
3. **The agent executes the manifest in one turn**: copies `root/*` to the repo root (AGENTS.md + the two
   real `@AGENTS.md` alias files), appends `gitignore.additions.txt` (idempotent, line-guarded), copies
   `payload/` → `.swarm/kernel/`, writes `.swarm/VERSION`, `mkdir`s the full canonical workspace
   (each dir `.gitkeep`'d), seeds `.swarm/memory/{INDEX,glossary}.md` + `.swarm/config.yaml`, and creates
   the **skills bridge** into the detected scan dir (`.claude/skills` if `.claude/` present, else the
   neutral `.agents/skills`).
4. **The agent runs the postcondition self-check** against the `conformant-repo/` fixture and pastes
   per-clause PASS/FAIL — adoption is *verified*, not assumed.
5. **The dev fills the project blanks** the agent flagged `{{TODO: confirm}}` — the `## Commands` rows
   (cmdValidate/cmdTest/cmdFormat required; the rest optional) and `## Project facts` — then commits.

**Manual fallback (no agent):** `INIT.md` is a literal copy-paste runbook — each manifest line is a
`cp -R`/`mkdir -p`/`ln -s`/append the human runs in their own shell.
**Future tool:** a *separate-repo* `swarm init [--from <bundle>]` implements the identical `INIT.md`
contract — same bytes land. (Fills the `init` verb already reserved in `conformance.md`.)

## The shipped tree (`dist/swarm-init/`, derived from `kernel/`)

```
dist/swarm-init/
  INIT.md              # THE CONTRACT: pre/postconditions + idempotency rule + the manifest. Inert.
  manifest.txt         # strict ordered op-list (MKDIR/COPY/RENAME/SYMLINK/APPEND-IF-ABSENT/SEED),
                       #   src → dst → ownership — the DATA spine the skill reads literally
  VERSION              # plain semver → .swarm/VERSION
  root/                # << lands at the REPO ROOT, name-for-name >>
    AGENTS.md          #   the {{…}}-bearing bootloader (Commands slots + facts)
    CLAUDE.md          #   REAL one-line "@AGENTS.md" — NOT a symlink (portability)
    GEMINI.md          #   REAL one-line "@AGENTS.md" — NOT a symlink
    gitignore.additions.txt   # renamed off the dotfile (zip/browser visibility)
  payload/             # << lands verbatim at .swarm/kernel/ >>  (= kernel/.agents/ minus .swarm-version)
    language/ templates/ passes/ skills/ conformance/ memory/    # framework-owned (overlays relocated)
  workspace-seed/      # << seeds the .swarm/ skeleton; cures git-drops-empty-dirs >>
    config.yaml        #   → .swarm/config.yaml (surfaces:{} + neutral multi-CLI adapter block + lint defaults)
    memory/{INDEX,glossary}.md   # → .swarm/memory/ (project-owned recall, distinct from the payload seed)
    DOTKEEP/           #   one .gitkeep per empty workspace dir, asserted == workspace.md's canonical subtree
  SKILL-install/       # the install-swarm SKILL.md + brownfield-merge.md + facts-discovery.md +
                       #   postcheck.md + the conformant-repo/ fixture (driver/doc only; NOT a destination)
```

## The irreducible minimum (honest)

It is **not** a literal `unzip -d . && done`: the **two destinations** (repo root vs `.swarm/kernel/`)
plus **NO RUNTIME** mean an executor (the agent, a human following `INIT.md`, or a future CLI) must
*fan the bundle out*. Everything mechanical — placement, rename, the 8-dir skeleton, the seeds, the
bridge — is done **for** the dev. The genuinely unavoidable residual is:
- **Fill `## Commands` + `## Project facts`** (no design can infer project commands/invariants; an unbound
  `cmd*` is the defined safe state — "agent asks before running"). The agent may *propose* bindings from
  `package.json`/`Makefile`/CI, but a human confirms.
- **Approve any brownfield `AGENTS.md` merge diff** (the one most-dangerous action — human-gated).
- **The one symlink** (the skills bridge) can't be shipped (zip/git/Windows mangle it) — it's created
  locally, degrading to a re-synced copy on Windows-without-Developer-Mode.

## Brownfield (mechanical, not "union the prose")

`INIT.md`'s brownfield branch is heading-keyed and append-only: (1) **root `AGENTS.md`** present → never
overwrite; **APPEND-IF-HEADING-ABSENT** Swarm's sections, keep the dev's Commands rows and add only
missing `cmd*`; on a heading **collision → emit a diff and STOP for human approval** (fallback: land as
`AGENTS.swarm.md`). (2) **`CLAUDE.md`/`GEMINI.md`** get a *different* policy — ensure the `@AGENTS.md`
include line is present (append if needed), never sidecar. (3) **`.gitignore`** append-only, grep-guarded
per line. (4) **CI** untouched/read-only. (5) `.swarm/kernel/` is brand-new so the payload never collides.
(6) existing code adopts as an `observed` surface — init does not retrofit specs. A
`brownfield-before/ → brownfield-after/` fixture pair pins that pre-existing content survives.

## Upgrade

Re-run the skill/`INIT.md` against a newer bundle; the idempotency rule keys off the two version files
(`.swarm/VERSION` vs the bundle `VERSION`), per ADR-0041. **REPLACE** (framework-owned):
`.swarm/kernel/**` wholesale from the new `payload/`, then write `.swarm/VERSION`. **PRESERVE**
(project-owned, never clobbered): root `AGENTS.md`, `.swarm/config.yaml`, **`.swarm/overlays/`** (relocated
outside the payload), and the whole data workspace. Root `AGENTS.md` uses the *template-upgrades,
filled-instance-is-diffed-not-overwritten* idiom (re-deliver the fresh template, heading-keyed merge of
new required sections, report a diff). Skills bridge re-derived (symlink no-op; copy-mode re-copies).
Postcondition: `.swarm/VERSION == new bundle`, project surfaces byte-identical except the intended refresh,
fixture self-check PASS.

## Skills + ownership boundary

Skills ship **only** at the framework-owned `.swarm/kernel/skills/` (single source); the bridge into the
CLI scan dir is created **at install time, never shipped** (zero symlinks in the artifact), additive-only
(adds Swarm's entries beside the dev's; never prescribes where the dev's own skills live), and the
`conformant-repo/` fixture asserts `<scan>/skills` byte-equals `.swarm/kernel/skills` to catch copy-mode
drift. **Ownership is tagged in the manifest's third column** so the upgrade has a machine-readable
boundary: framework-owned = `.swarm/kernel/**` (replaced); project-owned = root `AGENTS.md`,
`.swarm/config.yaml`, `.swarm/overlays/`, the data workspace (preserved).

## Repo restructure — the ship-blocking preconditions

Four changes in the framework repo (all ADR-0044-consistent: `kernel/` stays the maintained source;
`dist/swarm-init/` is **derived, never hand-edited**):

1. **Apply ADR-0044 §-resolution to the *live* `kernel/.agents/` tree FIRST (= K2b).** The kernel still
   carries the dangling-`§N` remainder (the DX sim counted **359** in skills/templates/fixtures; this pass
   estimated **~482** across the live payload — either way K2a only cleaned the language/passes twins +
   the entry points). **The bundle must ship the self-contained payload, so K2b is a hard precondition.**
2. **Relocate overlays out of the payload** → a sibling **`.swarm/overlays/`** (project-owned). Today
   `workspace.md` nests `overlays/` *inside* `kernel/`, so an upgrade payload-swap **deletes project
   overlays** — an upgrade footgun. ADR-grade (touches `workspace.md`, `kernel/AGENTS.md`, `kernel/README.md`).
3. **Ship a `.swarm/config.yaml` template in the kernel** (`workspace.md` mandates the file but no template
   ships) so the bundle's `workspace-seed/config.yaml` derives from a real source; reconcile with
   `conformance.yaml`.
4. **Add the build transform + a coherence gate** asserting `dist/payload == kernel/.agents − .swarm-version`,
   `dist VERSION == .swarm-version`, `root/AGENTS.md == kernel/AGENTS.md`, the DOTKEEP set ==
   `workspace.md`'s canonical subtree, and `manifest.txt` vs the actual payload shape — the same
   diff-checked discipline ADR-0044 gave the twins, so the new derived tree can't silently drift.

## ADRs needed

- **ADR-0045** — the init bundle is a derived artifact of the kernel (build `kernel → dist` only,
  coherence-gated); extends ADR-0044's derived-and-checked discipline to a third tree.
- **ADR-0046** — adoption is an agent-run procedure shipped as `install-swarm` SKILL.md + an inert `INIT.md`
  contract (manifest `src→dst→ownership`, postcondition-first `conformant-repo/` fixture); realizes the
  `init` verb (add the `init` namespace to `conformance.yaml` to reconcile).
- **ADR-0047** — relocate project overlays to `.swarm/overlays/` outside the replaceable subtree.
- **ADR-0048** — the skills-bridge convention (framework-owned home + install-time symlink/copy bridge,
  additive-only, fixture-asserted byte-equal). Formalizes what `kernel/README.md` only gestured at.
- **ADR-0049 (optional)** — ship a `.swarm/config.yaml` template as a first-class seed.

## Risks

- **Skill-executor non-determinism** — `SKILL.md` is LLM-interpreted; mitigation is the manifest-as-data
  spine + evidence-per-line against the postcondition fixture, but it's not a compiled installer's hard
  guarantee.
- **A *third* hand-synced derived tree** (`dist/`) atop the language/passes twins, in a repo whose dominant
  defect is "fix one, miss the twin" — the coherence gate must actually be run each release.
- **The preconditions are ship-blocking** (K2b on ~hundreds of refs + the ADR-grade overlay relocation +
  the config template) — the bundle is incoherent until they land.
- **Brownfield `AGENTS.md` merge** is the single most dangerous action — human-approval-gated, not hands-off.
- **Windows copy-mode bridge** drifts between upgrades unless re-copied — caught by the byte-equality fixture.

## Honest caveats (the NO-RUNTIME / portability line)

- The single-drag-drop *ideal* is hard-limited by two destinations + NO RUNTIME; an executor must fan the
  bundle out. (A single identity-mapped tarball gets closer to literal one-extract but loses the
  destination-partition clarity and still can't do brownfield-non-clobber or the fill — offered only as an
  optional convenience packaging, not the primary path.)
- The irreducible dev action is the Commands+facts fill and the brownfield-merge approval — genuinely
  unavoidable authoring, not a packaging miss.
- NO RUNTIME holds everywhere (inert bundle; `INIT.md`/`SKILL.md`/`manifest.txt` are documented procedures;
  the `dist/` build is an ADR-0044-style agent-run transform). The cost: correctness depends on the
  executor following the manifest — which is exactly why the contract is **postcondition-first**, and the
  fixture is the guardrail that catches a sloppy run.

## How this relates to the other plans

- **Supersedes the *mechanism* of DX-plan P1/P2** — the loose "ADOPTING.md + copy-paste block + skills
  bridge" becomes this `INIT.md` contract + `install-swarm` skill + derived bundle. The DX-plan gaps it
  closes (no quickstart, 404 memory pointer, skills dead-on-arrival, uncreated workspace, `VERSION` rename)
  are all folded into the manifest + postcondition fixture.
- **Hard-depends on K2b** (precondition #1) and on the **overlay relocation** (precondition #2) — so the
  natural order is **K2b → overlay relocation + config template → the bundle/skill/contract + ADRs 0045-0048**.

---

*No framework changes made. Workflow `w4gohoh2r` (13 agents). Execution awaits review.*
