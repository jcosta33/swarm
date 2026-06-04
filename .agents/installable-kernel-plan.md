# Plan — the optimal installable Swarm kernel

> A **plan**, not changes. It answers a design question — *what should the kernel an
> adopter installs actually contain, and what should stay upstream?* — explains why the
> current payload is shaped the way it is, weighs it against prior art (web-checked,
> June 2026) and Swarm's own evidence, and proposes a phased reshape. No framework files
> are touched. `.agents/specs/swarm/` is frozen and out of scope.

## The question

The kernel (`kernel/` → installs into an adopter's `.swarm/kernel/`) is what a consuming repo
adopts. Beyond `skills/` and `templates/` it also ships `language/`, `passes/`, `conformance/`,
`memory/`, and `overlays/`. The owner's question: *why does the installed kernel carry that
documentation, instead of just folder scaffolding (a template `AGENTS.md`, `.swarm/` + `.agents/`,
the skills, a minimal worked example) — with the human-facing docs living upstream in `docs/` and
the agent-facing material as skills + `AGENTS.md`?*

## 1. What the install ships beyond skills/templates — and why it's there today

| Payload | Lines (e.g.) | Who reads it | Why it is currently vendored |
| --- | --- | --- | --- |
| `language/` (`SOL.md`, `APS.md`, `errors.md`, `versioning.md`) | ~470 / ~360 each | **the agent**, on demand | The normative grammar + the `SOL-<LAYER><NNN>` lint catalogue. The skills are deliberately *thin* — ADR-0042/0016 make every skill SOFT control that "cites SOL/IR but defines none of it." So a skill says "emit the §8 codes"; in the adopter repo (which has **no `docs/`**) that referent must be *present* — it is `language/`. |
| `passes/` (9 pass contracts) | ~200 each | the agent | The per-pass contract (what `lint`/`lower`/… must do, the gates, the record shapes). Same reason: the pass-guide *skill* (`pass-lint-spec`, 114 lines) cites the §8/§9/§11.6 *contract*; the contract is the vendored `passes/lint.md`. |
| `conformance/` (`conformance.yaml` + golden fixtures) | 30 files | agent + adopter | The machine-checkable adoption contract (ADR-0026/0033) **and** the only worked examples that ship (a spec, IR, task, trace, review, finding per fixture). |
| `memory/` (`INDEX.md`, `glossary.md`) | 2 files | the agent | A recall seed — the "load-*when*" map (ADR-0032) so memory isn't empty on day one. |
| `overlays/` (`README.md`) | 1 file | adopter | The mechanism to layer project-local rules onto the kernel without editing it (the "vendorable across language/CI/agent" gate). |
| `AGENTS.md` (+ `CLAUDE.md`/`GEMINI.md` aliases, `.gitignore.additions`, `README.md`) | ~80 | agent + adopter | The bootloader + the adoption instructions. |

**The key correction to the framing.** `language/` and `passes/` are **not "documentation for the
user to read."** They are the agent's *normative reference* — the standard-library headers it loads
on demand to perform a pass correctly, **offline and at the pinned version**, in a repo that does not
contain `docs/`. The human-facing tutorial layer (`docs/`, 102 files) already **stays upstream** and
is **never vendored** — so that half of the intuition is already how the framework works.

## 2. Where the intuition is right, and the one nuance

**Right (and worth acting on):**
- **Human docs stay upstream; the agent gets skills + `AGENTS.md`.** Already true for `docs/`. The
  install is *meant* to be agent-operational, not a manual.
- **The install should be minimal.** Swarm's own freshly-adopted evidence agrees: over-specified
  context files *reduce* success and raise cost ([AGENTSMD-HARM]), most added docs are inert and some
  harmful via staleness ([SWESKILLS]), and every extra always-loaded doc is a distractor — see
  `docs/research/` and ADR-0043. A leaner payload is the evidence-backed direction.
- **The `docs/` ↔ `kernel/` duplication is a genuine defect.** `language/` and `passes/` are
  *divergent re-renderings* of `docs/language/` and `docs/passes/` (different cross-links + prose),
  maintained by hand. This is the recurring "fix one copy, miss the twin" defect — the single
  strongest argument for the owner's instinct.
- **A worked demo + an in-workspace orientation doc are missing.** There is no framed example project
  and no `.swarm/`-root explainer of the folder layout. Adopters get fixtures, not a tour.

**The nuance the proposal must absorb:** the *agent-facing normative reference* (the SOL/APS grammar,
the lint catalogue, the artifact contracts the skills cite) **cannot simply move to `docs/` or be
dropped** — because of three hard Swarm constraints:
- **No runtime / no package manager.** ESLint can `extends` a *versioned npm package* instead of
  vendoring (the ecosystem norm). Swarm has no resolver to pin-and-fetch an upstream ruleset, so the
  options are vendor, reference-by-URL (fragile, network-bound), or embed-in-skills (bloat).
- **Offline + version-pinned determinism.** A project pins a kernel version; the agent must resolve
  "§8 / the lint catalogue" without a network round-trip and without drifting from the pin.
- **Skills "cite, don't define" (ADR-0042).** Folding the semantics back into skills would re-bloat
  every skill and re-introduce the exact over-specification the evidence warns against.

So the fix is not "delete `language/`/`passes/`" — it is **single-source them, minimize them, and
stop divergently duplicating them into `docs/`.**

## 3. Prior art (web-checked, June 2026)

| System | What installs into the project | What stays upstream | Lesson for Swarm |
| --- | --- | --- | --- |
| **GitHub Spec Kit** (closest analog) | `.specify/` = `memory/` (the *constitution*), `templates/`, `scripts/`, `specs/` + agent **commands/prompts** (or **`--skills` mode** → agent skills) | the language/method docs (`spec-driven.md`, `docs/`) live in the spec-kit repo | Installs **templates + agent commands/skills + a memory/constitution + a workspace** — **not** a vendored reference manual. Validates the lean-payload instinct. Has an explicit `upgrade.md` story. |
| **Claude Code plugins / Agent Skills** | a *plugin* = a versioned bundle of `SKILL.md` skills (+ commands/hooks/MCP) → `.claude/skills/`, version-controlled | the platform + marketplace handle discovery/versioning/updates | Distribution unit = **versioned skill bundle**; the agent-facing content **is** the skills. No manual is copied per project. |
| **ESLint shareable configs** | nothing vendored — you `extends` a **versioned package**, pinned by semver | the rules live in the package | The ecosystem norm is **reference-a-pinned-package, not vendor-a-copy** — *unavailable to Swarm* (no resolver), which is exactly why Swarm must vendor; so vendor **minimally and single-sourced**. |
| **create-react-app `eject`** | minimal by default; **eject** copies the full config in as a *one-way* escape hatch | the config normally hidden in the tool | "Batteries-included but easy to modify": ship a **minimal working default**, vendor the full reference only when a project must customize it. |

**Convergent lesson:** the comparable kits install **templates + agent skills/commands + a
memory/constitution seed + a workspace + a bootloader**, and keep the **reference manual upstream**.
Swarm's *no-resolver* constraint means it must still vendor the *normative referent* — but the prior
art says vendor it **lean and single-sourced**, not as a hand-maintained twin of the human docs.

## 4. The recommended model — a two-layer kernel

Split the payload by **who reads it and when**, and make the normative reference single-sourced.

- **Layer A — the operational kernel (always vendored, minimal, agent-facing):**
  `AGENTS.md` (bootloader), `skills/` (the conditioning), `templates/` (copyable artifacts),
  a **`memory/` seed**, the **`conformance/` contract**, `overlays/`, and a **`.swarm/` workspace
  skeleton with one worked example** + a **`.swarm/README.md` orientation doc** (the owner's idea —
  see Layer C).
- **Layer B — the normative reference (vendored, but single-sourced & minimized):**
  `language/` (the grammar + lint catalogue the skills cite) stays — it is load-bearing and has no
  upstream substitute in an adopter repo — but it is **derived from / checked against one canonical
  source**, never a hand-divergent twin, and trimmed to the "headers" the skills actually cite.
  `passes/` is **reduced to terse normative contracts** (or folded into each pass-guide skill's
  `references/`), removing the overlap with both the skills and `language/`.
- **Upstream only (never vendored):** `docs/` — the human tutorial/explanation layer (already the
  case).

### Single-sourcing the twin (the highest-value structural fix)

Pick **one canonical home** for each duplicated body and make the other a derived/checked copy:
- **Option 1 — `docs/` canonical, kernel derived.** A release step copies `docs/language` +
  `docs/passes` into the payload (stripping docs-only cross-links), and a deterministic check asserts
  the payload matches the canonical modulo links. The twin becomes a *checked invariant*, not a
  silent-drift hazard. (No-runtime-friendly: the "build" is a copy + a diff check an agent runs.)
- **Option 2 — kernel canonical, `docs/` is the rendering.** `docs/language` + `docs/passes` become
  thin human-facing wrappers that *embed/transclude* the kernel files. Removes the second copy
  entirely.
- Either kills the "fix one, miss the twin" defect. **Option 1 is recommended** (keeps `docs/` as the
  rich human read; the payload is the lean derived artifact).

## 5. The plan (phased; no changes until approved; each load-bearing step gets an ADR)

- **K1 — ADR: "The installable kernel — operational payload vs upstream reference."** Record the
  two-layer split (§4), the *vendor-because-no-resolver* rationale, and the single-source rule for the
  twin. Refines ADR-0040 (kernel payload directory) and relates to ADR-0042/0016 (thin skills) and
  ADR-0041 (two-axis versioning). **Gate for K2–K5.**
- **K2 — Single-source the `docs/`↔`kernel/` twin (the defect fix).** Implement Option 1: a canonical
  source + a deterministic equality-modulo-links check wired into the coherence gates. This is the
  highest-leverage item and directly removes the recurring twin-drift defect.
- **K3 — Minimize Layer B.** Audit `language/` down to the headers the skills cite; resolve the
  `passes/`-vs-pass-guide overlap (terse contract, or move the contract into the skill's
  `references/`). Measure the payload-line reduction; flag anything dropped (no silent truncation).
- **K4 — Add adoption ergonomics (the owner's scaffold idea).** Ship a **`.swarm/` workspace
  skeleton** with an **organized worked example** (a real `spec.swarm.md` + its task/trace/review in
  `.swarm/sources` + `.swarm/generated`, reusing/reframing the conformance fixtures), and a
  **`.swarm/README.md`** that explains the folder structure and purpose (desired/observed/derived,
  `memory/`, `kernel/`). Decide its relation to the root `AGENTS.md` (root bootloader = *how an agent
  starts*; `.swarm/README.md` = *what the workspace is*) so they don't duplicate.
- **K5 — The version/update story.** Define how an adopter upgrades a vendored kernel (the gap Spec
  Kit fills with `upgrade.md`): tie the payload to the **package axis** of ADR-0041, ship a short
  `UPGRADING.md`, and specify what an `overlays/`-based customization must do to survive an upgrade.
- **K6 (consideration) — package the payload as a distributable bundle.** Evaluate shipping the kernel
  as a Claude-Code-plugin-style versioned bundle (and/or a Spec-Kit-style `init`), so adoption is
  "install a pinned version" rather than "copy a folder" — without violating no-runtime (the bundle is
  inert markdown; only the *delivery* is packaged).

## 6. Honesty / open questions (the §0.7 line)

- **The lean-payload direction is evidence-backed; the exact minimal set is a design judgment, not a
  measurement.** [AGENTSMD-HARM]/[SWESKILLS] show *more is worse*; they do not tell us *which* files
  to cut. K3 must justify each removal, not cut by reflex.
- **Vendoring is forced by the no-resolver constraint, not chosen for its own sake.** If Swarm ever
  grows a resolver/launcher, the ESLint `extends` model becomes available and Layer B could shrink to
  a pinned reference — note this as the future fork, don't assume it now.
- **Do not let "minimal" break self-containment.** The adopter has no `docs/`; whatever the skills
  cite MUST still resolve inside `.swarm/kernel/`. Minimization is bounded by "the skills' citations
  still resolve offline."
- **This touches ADR-0040 and the kernel contract — it is a real structural change, not a tidy-up.**
  It needs ADRs and a re-run of the conformance + coherence gates; it is not a free refactor.

---

*No framework changes made. Prior-art rows are web-sourced (June 2026); the Swarm evidence is in
`docs/research/sources.md` + ADR-0043. Execution awaits review.*
