# 📒 Guide: Customizing personas

> How to override the default persona for a task type, and how to add an overlay persona for project-specific work the framework's 13 don't cover.

---

## ⚡ TL;DR

Two mechanisms:

1. **Override** the framework's default persona for a task type (e.g., `fix` → custom Fixer instead of The Skeptic)
2. **Add** a project-specific *overlay persona* alongside the framework's 13 (e.g., a TypeSurgeon for a TS-heavy shop)

Overlays don't require framework approval. The framework graduates an overlay to canonical only when many projects independently demand it.

---

## 🔄 Overriding a default persona

The framework's `task type → persona` mapping is rigid by default. Projects can override it via the project's `swarm.config` (a CLI artefact, not a framework artefact). The override is *explicit* — recorded in `swarm.config` and visible to every contributor.

### When to override

Common overrides:

| Default                                                     | Override                                                                    | When                                                       |
| ----------------------------------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `fix` → The Skeptic                                         | `fix` → custom `Fixer`                                                      | Team prefers minimality-focus over adversarial-focus       |
| `documentation` → The Documentarian                         | `documentation` → custom `TechnicalWriter`                                   | Team has a dedicated tech-writer mindset distinct from the framework's |
| `feature` → The Builder                                     | `feature` → custom `TypeSurgeon`                                             | TS-heavy codebase where every feature touches advanced types |

### How to override (project's CLI config)

The CLI's config — typically `swarm.config.yaml` or equivalent — has a section for persona overrides:

```yaml
# Example shape (the actual schema is the CLI's concern)
personas:
  overrides:
    fix: project-fixer
    documentation: technical-writer
```

The framework's `documentation-gatekeeper` reads the override (when present) and routes accordingly. The override-named persona must exist as a profile in `.agents/skills/personas/`.

---

## ➕ Adding an overlay persona

Overlays live alongside the framework's 13. They follow the same profile format ([`personas/README.md`](../personas/README.md#-the-persona-profile-format)) and live in the same directory.

### When to add an overlay

A new overlay is justified when:

- The work is *recurring* in your codebase (not a one-off task)
- The work has *distinct hard constraints* that none of the framework's 13 capture
- The work has *distinct empirical proofs* that warrant their own Self-review questions

If the work folds cleanly into an existing persona with a different mindset switch, *don't* add an overlay — use the existing one.

### Common overlay candidates

| Overlay                | Lifts from                          | Triggering pattern                                            |
| ---------------------- | ----------------------------------- | ------------------------------------------------------------- |
| **The Type Surgeon**   | spec-gemini's TypeScript-soundness persona | TypeScript codebase with strict generics / variance constraints |
| **The Integrator**     | spec-gemini's SDK/MCP wiring persona | Heavy third-party integration work                           |
| **The Spike Investigator** | framework.md's time-boxed exploration persona | Throwaway spike code answering one question         |
| **The Security Reviewer** | (project-defined)                | Regulated codebase requiring per-PR security audit            |
| **The Accessibility Auditor** | (project-defined)            | UI codebase with WCAG conformance requirements                |
| **The Data Engineer**  | (project-defined)                   | Data pipeline / ETL work with its own constraints             |

These appear in the [Persona section's overlay catalogue](../personas/README.md#%EF%B8%8F-project-level-overlays).

### How to add an overlay

1. **Author the persona profile.** Use the framework's persona template (see [`personas/README.md`](../personas/README.md#-the-persona-profile-format)). Required sections: Role, Mindset, Hard constraints, Forbidden actions, Decision heuristics, Triggering documents, Triggering task types, Skills auto-attached, Empirical proofs required, Self-review focus, Anti-patterns, Red flags, Example, Handoff partners, Checklist.

2. **Place the file.** `.agents/skills/personas/<persona-slug>.md` (or folder form: `.agents/skills/personas/<persona-slug>/SKILL.md`).

3. **Update the project's `swarm.config`** (CLI concern) to map a task type (or task variant) to the overlay.

4. **Update the project's AGENTS.md** to mention the overlay if it changes the standing convention.

5. **(Optional)** Add an ADR documenting why the overlay was added — the alternatives considered (folding into an existing persona) and why they were rejected.

---

## 🛠️ Worked example: adding The Type Surgeon

Setup: a TypeScript-heavy codebase has work that consistently demands deep generics-and-variance reasoning. The Builder's "pragmatic delivery" mindset isn't the right stance for this work; the codebase needs an overlay persona.

### Step 1: author the profile

`.agents/skills/personas/the-type-surgeon.md`:

```markdown
# Persona: The Type Surgeon

## TL;DR
You handle TypeScript-soundness work — strict generics, variance, conditional types. Avoid `any`. Prefer making the type system carry invariants over runtime checks.

## Role
TypeScript-soundness, generics, and variance architecture for our TS-heavy codebase.

## Mindset
Academically rigorous. Obsessed with compiler safety. Avoid `any`. Create clean generic constraints.

## Hard constraints
1. Use strict typing; `any` is forbidden in non-test code (use `unknown` + narrowing).
2. Generic constraints are explicit; no implicit-`any` widening.
3. Variance is documented for any generic that crosses module boundaries.
4. Run `tsc --noEmit --strict` after every change; paste the output.

## Forbidden actions
1. Suppressing `// @ts-expect-error` without a comment explaining why.
2. Loosening tsconfig settings to make a violation pass.
3. Casting via `as <type>` to bypass the type system without an explanation.

[... Decision heuristics, Triggering tasks, Skills, Empirical proofs, Self-review focus, Anti-patterns, Red flags, Example, Handoff partners, Checklist — same format as framework personas]
```

### Step 2: configure the override

`swarm.config.yaml` (CLI concern; example shape):

```yaml
personas:
  overrides:
    feature: the-type-surgeon  # for tasks tagged ts-heavy
    rewrite: the-type-surgeon
```

Or, more granularly, route specific paths:

```yaml
personas:
  overrides:
    feature:
      paths:
        - "src/types/**"
        - "src/api/**"
      persona: the-type-surgeon
```

(The exact schema depends on the CLI; the framework cares only that the routing is *deterministic*.)

### Step 3: update AGENTS.md

```markdown
## Project-specific personas

Beyond the framework's 13, this project uses:

- **The Type Surgeon** — for TypeScript-soundness work in `src/types/` and `src/api/`. Profile at `.agents/skills/personas/the-type-surgeon.md`. Triggered for `feature` and `rewrite` tasks touching those paths.
```

### Step 4: write an ADR

`.agents/adrs/0023-type-surgeon-overlay.md`:

```markdown
# ADR 0023: Adopt The Type Surgeon overlay persona

## Status
Accepted

## Date
2026-04-22

## Context
Our codebase has approximately 45% of its functionality in `src/types/` and `src/api/` where
strict generics, variance, and conditional types are load-bearing. The framework's Builder
mindset ("pragmatic delivery") consistently produces type-loose implementations that the
Skeptic later flags. The Skeptic's adversarial review catches the issues, but the kickback
loop is expensive.

## Decision
Add **The Type Surgeon** as a project-level overlay persona. Route `feature` and `rewrite`
tasks touching `src/types/**` or `src/api/**` to The Type Surgeon instead of The Builder.

## Considered and rejected
- _Folding into The Builder._ Rejected because the Builder's mindset (pragmatic delivery)
  conflicts with the Type Surgeon's mindset (academically rigorous; avoid `any`); blending
  produces neither stance well.
- _Adding "type-strict" as a Builder skill._ Rejected because the discipline is mindset-level,
  not skill-level — a skill can be skipped or de-emphasised; a persona's hard constraints can't.

## Consequences

### Positive
- Type-soundness violations caught at the persona level, not at Skeptic review.
- Smaller kickback loops on TS-heavy work.

### Negative
- Project contributors must understand both Builder and Type Surgeon mindsets.
- The override semantics (paths-based routing) are CLI-specific; if we change CLI, we may need to re-implement.

### Neutral
- The framework remains at 13 canonical personas; The Type Surgeon is project-specific.

## See also
- Profile: `.agents/skills/personas/the-type-surgeon.md`
- AGENTS.md "Project-specific personas" section
- ADR 0014: The Builder's responsibilities (the framework persona we're partially superseding)
```

### Step 5: tell the team

A short note in your team's communication channel:

> "Added The Type Surgeon overlay persona for TypeScript-soundness work in `src/types/` and `src/api/`. Profile lives at `.agents/skills/personas/the-type-surgeon.md`. Triggered automatically for `feature` and `rewrite` tasks in those paths. ADR: `.agents/adrs/0023-type-surgeon-overlay.md`."

---

## 🪜 Graduation: when an overlay becomes canonical

If many projects independently adopt the same overlay (or a similar one), the framework may *graduate* it to canonical (as the 14th, 15th, ... persona). The path:

1. Multiple projects use the same overlay (3+ independent codebases is a reasonable signal)
2. A framework contributor proposes graduation via an ADR
3. The proposed persona profile is reviewed and refined
4. The persona enters the canonical 13 → 14 (or however many) catalogue
5. `MIGRATIONS.md` documents the change for adopters

Until graduation, overlays are project-level and don't affect framework-conformance.

---

## ⚠️ Common mistakes

- **Adding an overlay because the existing persona "feels off"** — usually fixable by adopting the persona properly, not by inventing a new one. Try the existing persona for 3-5 sessions first.
- **Inventing personas per session** — forbidden. The persona is catalogued before it's used.
- **Routing overrides without recording rationale** — every override has an ADR (or at least a note in `AGENTS.md`).
- **Overlay personas that don't follow the framework profile format** — the format is what makes the persona *operational*. Skipping sections (e.g., no Hard constraints, no Red flags) makes the overlay aspirational rather than enforceable.

---

## See also

- [`personas/README.md`](../personas/README.md) — the persona catalogue and profile format
- [`concepts/04-personas.md`](../concepts/04-personas.md) — the conceptual frame
- [`reference/compatibility-matrix.md`](../reference/compatibility-matrix.md) — the canonical mappings
- [ADR 0002](../adrs/0002-personas-1-to-1-with-task-types.md) — why 1-to-1
- [ADR 0009](../adrs/0009-personas-are-mindsets.md) — mindset, not role
- [`extending-the-framework.md`](extending-the-framework.md) — how to propose adding to the framework itself
