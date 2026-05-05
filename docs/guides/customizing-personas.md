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

1. **Author operative constraints** mirroring the iron-law scaffold (`Hard constraints`, `Forbidden actions`, `Empirical proofs`, `Red flags`, handoffs). Rationale references: [`concepts/04-personas.md`](../concepts/04-personas.md) + catalogue notes in [`personas/README.md`](../personas/README.md).
2. **Collocate alongside the scaffold catalogue** — either append `## Overlay: <Name>` to your fork of [`personas/SKILL.md`](../../scaffold/.agents/skills/personas/SKILL.md) **or** keep `.agents/skills/personas/overlays/<slug>.md` (+ loader wiring in [`AGENTS.md`](../../scaffold/AGENTS.md)).
3. **Record deterministic routing**: launcher / CLI config (if applicable) **plus** prose in [`AGENTS.md`](../../scaffold/AGENTS.md) so humans can audit overrides without binary config spelunking.
4. **(Optional)** ADR documenting why merging into an existing persona failed — prevents silent persona explosion.

Operational shortcuts produce decorative personas incapable of powering Self-review gates.

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
